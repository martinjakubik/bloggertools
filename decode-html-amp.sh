#!/bin/bash

if [ $# -eq 0 ]; then
    >&2 echo "please provide a file name"
    exit 1
fi

basefilepath=$1
basedirname=$(dirname $1)
basefilename=$(basename $1)
infilename=${basedirname}/generated/${basefilename}
outfilename=${basedirname}/generated/${basefilename}.out

echo " input file: " $basefilename
echo "output file: " $outfilename

cp $basefilename $infilename

sed -e 's/&lt;/</g' $infilename > $infilename.1
sed -e 's/&gt;/>/g' $infilename.1 > $infilename.2
sed -e 's/&amp;/&/g' $infilename.2 > $infilename.3

cp $infilename.3 $outfilename