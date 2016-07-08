#!/bin/sh

#   publisharchimatetool.sh
#  
#
#  Created by Guido Janssen on 02/07/16.
#

mkdir -p output/open-exchange

echo "generating open group exchange format file output/open-exchange/"$2".xml for "$1
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/archimatetool.xsl -s:$1 -o:output/open-exchange/$2.xml

./	publishopengroup.sh output/open-exchange/$2.xml $2 $3 $4