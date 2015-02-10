$(function() {
    // add active class to show search input
    $('#search-container').click(function(event) {
        event.stopPropagation();
        $("#search-container").addClass("active");
    });

    // remove active class and hide search input
    $(document).click(function() {
        cancelSearch();
    });

    function cancelSearch() {
        $(".gsc-input-box input").val("");
        $("#search-container").removeClass("active");
    }
});
