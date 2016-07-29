mkdir output\open-exchange 
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/archimatetool.xsl -s:%1 -o:output\open-exchange\openexchange.xml

publishopengroup output\open-exchange\openexchange.xml %2 %3 %4

