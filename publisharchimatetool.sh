#!/bin/sh

#   publisharchimatetool.sh
#  
#
#  Created by Guido Janssen on 02/07/16.
#
mkdir output
mkdir output/open-exchange

echo "generating open group exchange format file"
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/archimatetool.xsl -s:$1 -o:output/open-exchange/$2.xml

echo "preprocessing the xsl files"
rm -rf output/xsl
mkdir output/xsl
cp xsl/default.xsl output/xsl/default.xsl
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/preprocess.xsl -s:xsl/preindex.xsl -o:output/xsl/index.xsl customxsl=$4
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/preprocess.xsl -s:xsl/prebrowsepages.xsl -o:output/xsl/browsepages.xsl customxsl=$4


mkdir output/site
rm -rf output/site/$2
mkdir output/site/$2

echo "generating website"
java -jar lib/java/saxon/saxon9he.jar -xsl:output/xsl/index.xsl -s:output/open-exchange/$2.xml -o:output/site/$2/index.html

java -jar lib/java/saxon/saxon9he.jar -xsl:output/xsl/browsepages.xsl -s:output/open-exchange/$2.xml folder=output/site/$2 configfile=$3

cp -R lib/reportlibs/js output/site/$2
cp -R lib/reportlibs/css output/site/$2