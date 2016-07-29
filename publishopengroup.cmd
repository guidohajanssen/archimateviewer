
rmdir output\xsl /s /q
mkdir output\xsl
copy xsl\default.xsl output\xsl\default.xsl 
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl\preprocess.xsl -s:xsl\preindex.xsl -o:output\xsl\index.xsl customxsl=%4
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl\preprocess.xsl -s:xsl\prebrowsepages.xsl -o:output\xsl\browsepages.xsl customxsl=%4

rmdir %2 /s /q 
mkdir %2
java -jar lib/java/saxon/saxon9he.jar -xsl:output\xsl\index.xsl -s:%1 -o:%2\index.html
java -jar lib/java/saxon/saxon9he.jar -xsl:output\xsl\browsepages.xsl -s:%1 folder=%2 configfile=%3
mkdir %2\lib
xcopy lib\reportlibs %2 /s /e /y
