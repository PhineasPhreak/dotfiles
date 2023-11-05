#!/bin/env python3

from glob import glob
# import os

# Original code
# tmpl = """<IconPath>%s</IconPath>"""
# print("<JWM>")
# print("\n".join([tmpl % dir for dir in glob("/usr/share/icons/*/*/*")]))
# print("</JWM>")


# To search in subdirectories, consider using the os.walk() function.
# It recursively yields a 3-tuple (dirpath, dirnames, filenames), where dirpath is the path to the current directory, dirnames is a list of the names of the subdirectories in the current directory and filenames lists the regular files in the current directory.
# rootdir = "/usr/share/icons/"
# for rootdir, dirs, files in os.walk(rootdir):
#     for subdir in dirs:
#         print(os.path.join(rootdir, subdir))

# https://www.techiedelight.com/list-all-subdirectories-in-directory-python/
# Python 3.5 extended support for recursive globs using ** to search subdirectories and symbolic links to directories.
rootdir = "/usr/share/icons/"
print("<JWM>")
for path in glob(f'{rootdir}/*/**/', recursive=True):
    print(f"<IconPath>{path}</IconPath>")
print("</JWM>")
