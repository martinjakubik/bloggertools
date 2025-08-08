#!/bin/bash
# sets up usage
USAGE="usage: $0 -i --inputDir inputDir -o --destinationDir destinationDir -d --debug"

# set up defaults
DEBUG=0
using_downloads_folder=1
inputDir=~/inputDir
destinationDir=~/destinationDir

# parses and reads command line arguments
if [ $# -eq 0 ]; then
    >&2 echo "you did not provide a folder name; using downloads folder"
else
    using_downloads_folder=0
fi

while [ $# -gt 0 ]
do
  case "$1" in
    (-i) inputDir="$2"; shift;;
    (--inputDir) inputDir="$2"; shift;;
    (-o) destinationDir="$2"; shift;;
    (--destinationDir) destinationDir="$2"; shift;;
    (-d) DEBUG=1;;
    (--debug) DEBUG=1;;
    (-*) echo >&2 ${USAGE}
    exit 1;;
  esac
  shift
done

echo you entered values
echo   "From inputDir : $inputDir"
echo   "To            : $destinationDir"

echo > list_of_google_takeout_directories

if [ $using_downloads_folder -eq 1 ] ; then
    basefilepath=~/Downloads
else
    basefilepath=$(dirname "$inputDir")/$(basename "$inputDir")
fi

for x in $basefilepath/Takeout* ; do
    google_takeout_directory="$x"
    if [[ -d "$google_takeout_directory" ]] ; then
        find "$google_takeout_directory" -type d -depth 2 >> list_of_google_takeout_directories
    fi
done

if [[ -e list_of_google_takeout_directories ]] ; then
    file_array=()
    while IFS= read -r google_takeout_source_directory; do
        if [[ ! -z "${google_takeout_source_directory// }" ]] ; then
            file_array+=($google_takeout_source_directory)
            google_takeout_directory_basename=$(basename "$google_takeout_source_directory")
            if [[ ! -d $destinationDir/"$google_takeout_directory_basename" ]] ; then
                mkdir -p "$destinationDir/$google_takeout_directory_basename"
                cp "$google_takeout_source_directory"/* "$destinationDir"/"$google_takeout_directory_basename/"
            fi
        fi
    done < list_of_google_takeout_directories
fi
