#!/bin/sh

#   publisharchimatetool.sh
#  
#
#  Created by Guido Janssen on 02/07/16.
#
mkdir output
mkdir output/open-exchange
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/archimatetool.xsl -s:$1 -o:output/open-exchange/$2.xml
rm -rf output/site/$2
mkdir output/site
mkdir output/site/$2
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/index.xsl -s:output/open-exchange/$2.xml -o:output/site/$2/index.html
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/browsepages.xsl -s:output/open-exchange/$2.xml folder=output/site/$2 configfile=$3
cp -R lib/reportlibs/js output/site/$2
cp -R lib/reportlibs/css output/site/$2