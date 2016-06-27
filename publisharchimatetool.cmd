mkdir open-exchange
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/archimatetool.xsl -s:models/%1.archimate -o:open-exchange/%1.xml
rmdir /s /q %2
mkdir %2
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/index.xsl -s:open-exchange/%1.xml -o:%2/index.html
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/browsepages.xsl -s:open-exchange/%1.xml folder=%2
mkdir %2\lib
xcopy lib\reportlibs %2 /s /e