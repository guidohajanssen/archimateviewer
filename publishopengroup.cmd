rmdir /s /q %2
mkdir %2
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/index.xsl -s:%1 -o:%2/index.html
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/browsepages.xsl -s:%1 folder=%2
mkdir %2\lib
xcopy lib\reportlibs %2 /s /e
