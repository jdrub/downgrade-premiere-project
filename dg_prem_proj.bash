#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
GR_BOLD='\033[1;32m'
DEF='\033[0m' # default 

if [ -z "$1" ]
  then
    printf "${RED}No argument supplied${DEF}\n"
    exit 1
fi

if ! [[ $1 =~ ^.*\.prproj$ ]]
  then
    printf "${RED}The argument supplied needs to be a *.prproj file${DEF}\n"
    exit 1
fi

printf "copying file... "
# make a copy of the file replace the extension with .gz
base=$(basename -- "$1")
dir=$(dirname $1)
name=${base%.*}
name=${name:-$base} # don't consider .bashrc the extension in /foo/.bashrc
new_file=$dir${name}_downgrade
cp -- "$1" "$new_file".gz
printf "${GREEN}done.${DEF}\n"

# unzip the file
printf "unzipping... "
gunzip "$new_file".gz
printf "${GREEN}done.${DEF}\n"

# replace the premiere version with "1"
printf "updating xml file... "
sed -i "" "s/\(<Project ObjectID.*Version=\"\).*\(\"\)/\11\2/" "$new_file"
printf "${GREEN}done.${DEF}\n"

# re-zip the file
printf "repackaging the .prproj file... "
gzip "$new_file"

# replace the .gz extension with .prproj
mv "$new_file".gz "$new_file".prproj
printf "${GREEN}done.${DEF}\n"

printf "\n${GREEN}saved downgraded project file as ${GR_BOLD}'$new_file'.prproj${DEF}\n"

