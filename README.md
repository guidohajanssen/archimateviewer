# ArchiMate Viewer
Viewer for Archimate models based on the Open Group ArchiMate Exchange Format version 2.1.
If you want to know more about the exchange format go to http://www.opengroup.org/xsd/archimate/ 
If you would like to try out the viewer online go to http://www.archimateviewer.nl

The viewer uses:
  - SVG for the diagram rendering
  - jQuery 1.12.4 and Bootstrap 3.3.6 for the website layout and dynamics 
  - d3 3.5.17 and d3plus 1.9.5 for wordwrap of the SVG text elements 
  - Saxon9HE as the XSLT processor

The project uses XSLT to create the model website:
- archimatetool.xsl transform an Archi File (www.archimatetool.com) in native format into an Open Group ArchiMate Exchange Format file.  
- preindex.xsl creates the index page of the model website with the header and navigation.
- prebrowsepages.xsl creates a page for each element or view in the model
- preprocess.xsl transforms the preindex.xsl and prebrowsepages.xsl into index.xsl and browsepages.xsl by including an optional customization xslt file
- default.xsl is the default customization xslt file
And has some javascript and stylesheet specific for the index and browse pages:
- index.js 
- browse.js
- model.css
All the javascript and css are loaded dynamically.

Use publisharchimatetool.cmd (or.sh for Linux/MacOSX) [modelfilename.archimate] [sitename] [configfile] to create the model website.
It will create the Open Group ArchiMate Exchange Format in output/open-exchange and the site in output/site/[sitename]

Use publishopengroup.cmd (or .sh for Linux/MacOSX) [modelfilename.xml] [sitename] [configfile] to create the model website.
The site will be created in output/site/[sitename].

Far from finished but a good start. 
I Have to learn GitHub at the same time.
