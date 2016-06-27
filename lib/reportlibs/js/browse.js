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

	// Set heigh of panels the first time
	setRootPanelHeight();

	textwrap(document);
	
	$(".documentation").each(function() {
		$(this).html($(this).text());
	});
	
});