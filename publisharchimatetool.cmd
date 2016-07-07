mkdir output\open-exchange 
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl/archimatetool.xsl -s:%1 -o:output\open-exchange/%2.xml

rmdir /s /q output\xsl
mkdir output\xsl
xcopy xsl\default.xsl output\xsl\default.xsl
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl\preprocess.xsl -s:xsl\preindex.xsl -o:output\xsl\index.xsl customxsl=%4
java -jar lib/java/saxon/saxon9he.jar -xsl:xsl\preprocess.xsl -s:xsl\prebrowsepages.xsl -o:output\xsl\browsepages.xsl customxsl=%4

rmdir /s /q %2 
mkdir output\site\%2 

java -jar lib\java\saxon\saxon9he.jar -xsl:output\xsl\index.xsl -s:output\open-exchange\%2.xml -o:output/site/%2/index.html

java -jar lib\java\saxon\saxon9he.jar -xsl:output\xsl\browsepages.xsl -s:output\open-exchange\%2.xml folder=output/site/%2 configfile=%3

mkdir output\site\%2\lib 
xcopy lib\reportlibs output\site\%2 /s /e /y
