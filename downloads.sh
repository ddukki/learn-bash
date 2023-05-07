#!/bin/bash

# An overly complicated script that uses arrays, functions, and control
# structures to move items from a downloads folder into separate, categorical
# folders. Purely for learning/experimental purposes.

# Extensions that should be moved into separate folders.
exeExt=('exe' 'msi' 'dll' 'bat')
imgExt=('png' 'jpg' 'jpeg' 'gif' 'bmp' 'svg')
pdfExt=('pdf' 'eps')
docExt=('doc' 'docx' 'ppt' 'pptx' 'xls' 'xlsx' 'odt' 'csv' 'txt' 'pages' 'epub')
arcExt=('rar' 'zip' '7z' 'gz' 'iso' 'jar' 'img')
fonExt=('ttf' 'otf')
audExt=('mp3' 'wav')
vidExt=('mp4' 'mov' 'webp')
codExt=('php' 'java' 'go' 'mod' 'sql' 'log' 'conf' 'env' 'auz' 'pem' 'key')

# These extensions will be DELETED! Use with extreme caution!
delExt=('lnk' 'torrent')

# The directory with all the files that will be moved.
dldir=/mnt/c/Users/ddukki/Downloads

# is_ext takes in two arguments:
# $1: The extension to check against a list of known extensions.
# $2: A list of known extensions in the form of an array.
#
# If $1 matches any of the extensions listed in $2, then this will return a 0.
# Returns a 1 otherwise.
is_ext(){

  # Read in the two arguments, using a shift to read in the rest of the args as
  # an array.
  in_ext=$1
  shift
  arrExt=("$@")

  # Set up the return/echo arg.
  local found=1

  # Search for the extension in the given array, making sure to ignore case.
  for ext in "${arrExt[@]}";do
    if [[ ${ext,,} == ${in_ext,,} ]];then
      found=0
      break
    fi
  done

  echo "$found"
}

# Loop through all the files in the designated directory.
for entry in "$dldir"/*
do
  if [ -f "$entry" ];then
    ext="${entry##*.}"
    filename=$(basename "$entry")

    founddir=false
    if [[ $(is_ext "$ext" "${exeExt[@]}") -lt 1 ]];then
      movedir="$dldir"/Programs
      founddir=true
    elif [[ $(is_ext "$ext" "${imgExt[@]}") -lt 1 ]];then
      movedir="$dldir"/Images
      founddir=true
    elif [[ $(is_ext "$ext" "${arcExt[@]}") -lt 1 ]];then
      movedir="$dldir"/Archives
      founddir=true
    elif [[ $(is_ext "$ext" "${pdfExt[@]}") -lt 1 ]];then
      movedir="$dldir"/PDFs
      founddir=true
    elif [[ $(is_ext "$ext" "${fonExt[@]}") -lt 1 ]];then
      movedir="$dldir"/Fonts
      founddir=true
    elif [[ $(is_ext "$ext" "${docExt[@]}") -lt 1 ]];then
      movedir="$dldir"/Docs
      founddir=true
    elif [[ $(is_ext "$ext" "${audExt[@]}") -lt 1 ]];then
      movedir="$dldir"/Audio
      founddir=true
    elif [[ $(is_ext "$ext" "${vidExt[@]}") -lt 1 ]];then
      movedir="$dldir"/Videos
      founddir=true
    elif [[ $(is_ext "$ext" "${codExt[@]}") -lt 1 ]];then
      movedir="$dldir"/Code
      founddir=true
    fi

    if $founddir;then
      echo "$filename : $movedir"
      mv -i "$dldir/$filename" "$movedir/$filename"
    fi

    if [[ $(is_ext "$ext" "${delExt[@]}") -lt 1 ]];then
      rm "$entry"
    fi

  elif [ -d "$entry" ];then
    echo "dir $entry"
  fi
done