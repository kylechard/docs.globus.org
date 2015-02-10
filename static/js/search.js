$(function() {
    var searchIndex,
      searchHits;

  // Load the JSON containing all pages
  // Has it been loaded before (and stored with localstorage)?
  if (localStorage['searchIndex']) {
    searchIndex = JSON.parse(localStorage['searchIndex']);

    if (localStorageHasExpired())
      loadSearchIndex();
    } else {
      loadSearchIndex();
    }

  function loadSearchIndex() {
    $.getJSON('/search-index.json', function(data) {
      searchIndex = data["pages"];
      localStorage['searchIndex'] = JSON.stringify(searchIndex);
      localStorage['updated'] = new Date().getTime();
    });
  }

  function localStorageHasExpired() {
    // Expires in one day (86400000 ms)
    if (new Date().getTime() - parseInt(localStorage['updated'],10) > 86400000) {
      return true;
    }
    return false;
  }

  // Expand and activate search if the page loaded with a value set for the search field
  if ($("#searchfield").val().length > 0) {
    $("#search-container").addClass("active");
    searchForString($("#searchfield").val());
  }

  // On input change, update the search results
  $("#searchfield").on("input", function(e) {
    $(this).val().length > 0 ? $("#search-container").addClass("active") : $("#search-container").removeClass("active");

    searchForString($(this).val());
  });


  function searchForString(searchString) {
    searchHits = [];
    searchString = searchString.toLowerCase();

    // Search for string in all pages
    for (var i = 0; i < searchIndex.length; i++) {
      var page = searchIndex[i];

      // Add the page to the array of hits if there's a match
      //if (page.title.toLowerCase().indexOf(searchString) !== -1) {
        searchHits.push(page);
      //}
    }
    renderResultsForSearch(searchString);
  }

  // Update the UI representation of the search hits
  function renderResultsForSearch(searchString){
    $("#search-results").empty();

    // Check if there are any results. If not, show placeholder and exit
    if (searchHits.length < 1) {
      $('<li class="placeholder">No results for <em></em></li>').appendTo("#search-results").find("em").text(searchString);
      return;
    }

    // Render results (max 6)
    for (var i = 0; i < Math.min(searchHits.length, 50); i++) {
      var page = searchHits[i];

      $('<li class="result"><a href="' + page.url + '"><em>' + page.title + '</em><small>' + page.section + '</small></a></li>').appendTo("#search-results");
    }

    // Select the first alternative
    $("#search-results li:first-child").addClass("selected");
  }

  // Move the selected list item when hovering
  $("#search-results").on("mouseenter", "li", function(e) {
    $(this).parent().find(".selected").removeClass("selected").end().end()
      .addClass("selected");
  });

  function moveSearchSelectionUp() {
    $prev = $("#search-results .selected").prev();
    if ($prev.length < 1)
      return;

    $("#search-results .selected").removeClass("selected");
    $prev.addClass("selected");
  }

  function moveSearchSelectionDown() {
    $next = $("#search-results .selected").next();
    if ($next.length < 1)
      return;

    $("#search-results .selected").removeClass("selected");
    $next.addClass("selected");
  }

  function goToSelectedSearchResult() {
    var href = $("#search-results .selected a").attr("href");
    if (href)
      window.location.href = href;
  }
});
