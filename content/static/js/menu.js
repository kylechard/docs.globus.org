$(function(){
    // Find each dropdown item with an active sub-item
    $.each($('li.dropdown li.active'), function( index, elem ) {
        $(elem).parents('li').addClass('active');
    });

    // Nav tabs
    //
    // go to active tab on load
    var url = document.location.toString();
    if (url.match('#')) $('#nav-tabs a[href=#'+url.split('#')[1]+']').tab('show');
    // Change hash for page-reload
    $('#nav-tabs a').on('shown.bs.tab', function (e) {
    window.location.hash = e.target.hash;
    });
    // On click
  $('#nav-tabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });

    // Sidebar menus
    $('.panel a.caret').click(function() {
      $( this ).parent().next('.list-group').children('.collapse').toggleClass( "in" );
      $( this ).toggleClass( "open" );
      $( this ).parent().toggleClass( "open" );
      $( this ).parent().next('.list-group').toggleClass( "open");
    });
});
