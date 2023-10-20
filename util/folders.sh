#!/usr/bin/env bash

# This is a _very_ dirty line by line .vdf and .acf file “parser”. I needed to
# be able to obtain the installation folder for the game, and the file format
# is the ugliest thing I have ever seen. Could not find a tool to parse it, was
# too lazy to do it properly, so this is what we get.
#
# At some point™ someone™ should code this shit properly.

getBg3Library () {
  while read -r key value
  do
    [ "${key}" = "\"path\"" ] && library="$(echo ${value} | tr -d "\"")"
    [ "${key}" = "\"1086940\"" ] && echo ${library} && return 0
  done < ~/.steam/root/steamapps/libraryfolders.vdf
  return 1
}

getBg3Folder () {
  library=${1:-$(getBg3Library)}
  while read -r key value
  do
    [ "${key}" = "\"installdir\"" ] && echo ${value} | tr -d "\"" && return 0
  done < ${library}/steamapps/appmanifest_1086940.acf
  return 1
}
