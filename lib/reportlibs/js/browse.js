// text wrapping for all svg nodes
function textwrap(element) {
	var texts = element.getElementsByTagName("text");
	var i=0;
	for (i=0;i<texts.length;i++	) {
		var width = texts[i].previousElementSibling.getAttribute("width");
		d3plus.textwrap()
				.container(d3.select(texts[i]))
				.width(width-20)
				.draw();
	}
};

function setRootPanelHeight() {
	$('.root-panel-body').css('height', $('.root-panel').outerHeight() - $('.root-panel-heading').outerHeight());
}

$(document).ready(function() {

    var style = location.search.split('style=')[1];

    if (style == 'tabbed') {
        $('#tabbed').show();
        $('#listed').hide();
        // Set heigh of panels the first time
	    
    
	// Set jQuery UI Layout panes
	$('body').layout({
		minSize: 50,
		maskContents: true,
		north: {
		  size: 55,
		  spacing_open: 8,
		  closable: false,
		  resizable: false
		},
		west: {
				size: 350,
				spacing_open: 8
			},
		west__childOptions: {
		  maskContents: true,
		  south: {
			  minSize: 50,
					size: 250,
					spacing_open: 8
				},
				center: {
					minSize: 50,
					onresize: "setRootPanelHeight"
				}
		}
	   });

        setRootPanelHeight();
    }
	textwrap(document);
	
	$(".documentation").each(function() {
		$(this).html($(this).text());
		
	});
	            
    
    
    
    if (style == 'listed') {
        $('#print').hide();
        $('#link').hide();
        $('#tabbed').hide();
        $('#listed').show();
        $('#panel').removeClass('panel');
        $('#panel').removeClass('panel-default');
        $('#panel').removeClass('root-panel');
        $('#panelheader').removeClass('panel-heading').addClass("well");
        $('#panelheader').removeClass('root-panel-heading');
        $('#panelbody').removeClass('panel-body');
        $('#panelbody').removeClass('root-panel-body');
    }
	
});