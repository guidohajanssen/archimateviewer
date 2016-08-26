#!/bin/sh

#   publishopengroup.sh
#  
#   creates a site based on the open group archimate exchange file format
#

echo "preprocessing the xsl files for site generation"
rm -rf output/xsl
mkdir output/xsl
cp xsl/default.xsl output/xsl/default.xsl
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/preprocess.xsl -s:xsl/preindex.xsl -o:output/xsl/index.xsl customxsl=$4
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/preprocess.xsl -s:xsl/prebrowsepages.xsl -o:output/xsl/browsepages.xsl customxsl=$4

echo "generating site output/site/"$2
mkdir -p output/site
rm -rf output/site/$2
mkdir output/site/$2
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/replacetype.xsl -s:$1 -o:output/model.xml
java -jar lib/java/saxon/saxon9he.jar -xsl:output/xsl/index.xsl -s:output/model.xml -o:output/site/$2/index.html
java -jar lib/java/saxon/saxon9he.jar -xsl:output/xsl/browsepages.xsl -s:output/model.xml folder=output/site/$2 configfile=$3

echo "opening site"

open file://$(pwd)/output/site/$2/index.html