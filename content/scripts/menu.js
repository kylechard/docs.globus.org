$(function(){
	// Find each dropdown item with an active sub-item
	$.each($('li.dropdown li.active'), function( index, elem ) {
		$(elem).parents('li').addClass('active');
	});
});