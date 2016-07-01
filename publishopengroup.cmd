rmdir output\site\%2 /s /q 
mkdir output\site\%2
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/index.xsl -s:%1 -o:output\site\%2/index.html
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/browsepages.xsl -s:%1 folder=output\site\%2 configfile=%3
mkdir output\site\%2\lib
xcopy lib\reportlibs output\site\%2 /s /e /y
