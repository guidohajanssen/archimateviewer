# archimateviewer
Viewer for Archimate models based on the Open Group Exchange Format.
For example of the output see also http://www.archimateviewer.nl

The project now contains only three basic files:
- archimatetool.xsl transform an archimatetool (www.archimatetool.com) xml file to the archimate open group exchange format xml (http://www.opengroup.org/xsd/archimate/)
- index.xsl creates the index page
- browsepages.xsl creates a page for each element or view 

Use publisharchimatetool [archimatetoolfile] [sitename] [configfile] to create the archimate viewer website. 
It will create the open group exchange format file in output/open-exchange and the site in output/site

Use publishopengroup [opengroupexchangeformatfile] [sitename] [configfile] to create the archimate viewer website.
The site will be created in output/site

Far from finished but a good start. Have to learn GitHub at the same time
