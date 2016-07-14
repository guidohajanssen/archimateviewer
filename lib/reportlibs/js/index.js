function setRootPanelHeight() {
	$('.root-panel-body').css('height', $('.root-panel').outerHeight() - $('.root-panel-heading').outerHeight());
}

function strcmp(a, b){
	var aText = $(a).text().trim().toLowerCase();
	var bText = $(b).text().trim().toLowerCase();
	if (aText.toString() < bText.toString()) return -1;
  if (aText.toString() > bText.toString()) return 1;
  return 0;
}

function search() {
    var searchelement = $('#searchelement').val();
	var searchtext = $('#searchtext').val().toLowerCase();
	$('.tree').find('li').hide();
	$('.tree').find('ul').hide();
    if (searchelement == 'Name') {
        var elements = $('.tree-element').filter(function() {
               return $(this).text().toLowerCase().indexOf(searchtext) > -1;
        });
        
                elements.show();
        elements.parents().show();
    } else {
        if (searchtext=='') {
            $('div[key=\"'+searchelement+'\"]').parents().show();
        } else {
            $('div[key=\"'+searchelement+'\"]').filter(function() {
                return $(this).attr('value').toLowerCase().indexOf(searchtext) > -1;
            }).parents().show();

        }
    }
};


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
	
	$("p").each(function() {
		$(this).html($(this).text());
	});

	// Setup modeltree
	$('.tree li:has(ul)').addClass('parent_li').find(' > ul > li').hide();

	$('.treefolder').css('cursor','grab');
	// Add show/hide function on modeltree
	$('.tree li.parent_li > span').on('click', function (e) {
		var children = $(this).parent('li.parent_li').find(' > ul > li');
		if (children.is(":visible")) {
			children.hide('fast');
			$(this).find(' > i').addClass('glyphicon-triangle-right').removeClass('glyphicon-triangle-bottom');
		} else {
			children.show('fast');
			$(this).find(' > i').addClass('glyphicon-triangle-bottom').removeClass('glyphicon-triangle-right');
		}
		e.stopPropagation();
	});
	
	var page = location.search.split('page=')[1];
    if (page == '') {
        // do nothing
    } else {
        $('#contents').prop('src','browsepage-'+page+'.html');
    }
    
});
