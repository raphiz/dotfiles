#!/usr/bin/env python3
# Some parts of this are based or directly copied form dotbot

import dotbot
import os
import glob
import shutil


class link_existing_files(dotbot.Plugin):

    _directive = 'link'

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('Link cannot handle directive %s' % directive)
        self._process_link_diffs(data)
        return True

    def _process_link_diffs(self, links):
        success = True
        defaults = self._context.defaults().get('link', {})
        for destination, source in links.items():
            destination = os.path.expandvars(destination)
            relative = defaults.get('relative', False)
            use_glob = defaults.get('glob', False)
            if isinstance(source, dict):
                # extended config
                relative = source.get('relative', relative)
                use_glob = source.get('glob', use_glob)
                path = self._default_source(destination, source.get('path'))
            else:
                path = self._default_source(destination, source)
            path = os.path.expandvars(os.path.expanduser(path))
            if use_glob:
                self._log.debug("Globbing with path: " + str(path))
                glob_results = glob.glob(path)
                if len(glob_results) is 0:
                    self._log.warning(
                        "Globbing couldn't find anything matching " + str(path))
                    success = False
                    continue
                glob_star_loc = path.find('*')
                if glob_star_loc is -1 and destination[-1] is '/':
                    self._log.error("Ambiguous action requested.")
                    self._log.error("No wildcard in glob, directory use undefined: " +
                                    destination + " -> " + str(glob_results))
                    self._log.warning(
                        "Did you want to link the directory or into it?")
                    success = False
                    continue
                elif glob_star_loc is -1 and len(glob_results) is 1:
                    success &= self._link(path, destination, relative)
                else:
                    self._log.lowinfo("Globs from '" + path +
                                      "': " + str(glob_results))
                    glob_base = path[:glob_star_loc]
                    for glob_full_item in glob_results:
                        glob_item = glob_full_item[len(glob_base):]
                        glob_link_destination = os.path.join(
                            destination, glob_item)
                        success &= self._link(
                            glob_full_item, glob_link_destination, relative)
            else:
                success &= self._link(path, destination, relative)
        if success:
            self._log.info('All links have been set up')
        else:
            self._log.error('Some links were not successfully set up')
        return success

    def _default_source(self, destination, source):
        if source is None:
            basename = os.path.basename(destination)
            if basename.startswith('.'):
                return basename[1:]
            else:
                return basename
        else:
            return source

    def _exists(self, path):
        '''
        Returns true if the path exists.
        '''
        path = os.path.expanduser(path)

        return os.path.exists(path)

    def _is_link(self, path):
        '''
        Returns true if the path is a symbolic link.
        '''
        return os.path.islink(os.path.expanduser(path))

    def _link_destination(self, path):
        '''
        Returns the destination of the symbolic link.
        '''
        path = os.path.expanduser(path)
        return os.readlink(path)

    def _link(self, source, link_name, relative):
        '''
        Links link_name to source.
        Returns true if successfully linked files.
        '''
        success = False
        destination = os.path.expanduser(link_name)
        absolute_source = os.path.join(self._context.base_directory(), source)
        if relative:
            source = self._relative_path(absolute_source, destination)
        else:
            source = absolute_source
        if (not self._exists(link_name) and self._is_link(link_name) and
                self._link_destination(link_name) != source):
            self._log.warning('Invalid link %s -> %s' %
                              (link_name, self._link_destination(link_name)))
        elif self._exists(link_name) and not self._is_link(link_name):
            # 1. copy link_name to 
            # mv absolute_source to absolute_source + '.old'
            # cp link_name to absolute_source
            # do link!
            # Make a backup copy
            shutil.copy2(absolute_source, absolute_source + '.old')
            os.unlink(absolute_source)
            shutil.copy2(link_name, absolute_source)
            self._log.error('%s -> %s' % (absolute_source, link_name))
            self._log.error(
                '%s already exists but is a regular file or directory' %
                link_name)
            success = True
        return success
