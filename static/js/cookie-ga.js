$(function() {
    window['ga-disable-UA-19656330-29'] = true; // Turn off GA for now

    // Check if user has already said ok to cookies
    function getCookie(cname) {
        var name = cname + "=";
        var ca = document.cookie.split(';');
        for(var i=0; i<ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1);
            if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
        }
        return "";
    }

    var cookie_status=getCookie("gdev_cookies");
    if (cookie_status!="") {
        window['ga-disable-UA-19656330-29'] = false; // Turn on GA
    }else{
        // Check if user from EU country
        var eu_countries = ["AL", "AD", "AM", "AT", "AZ", "BY", "BE", "BA", "BG", "HR", "CY", "CZ", "DK", "EE", "FI", "FR", "GE", 
            "DE", "GR", "HU", "IS", "IE", "IT", "KZ", "XK", "LV", "LI", "LT", "LU", "MK", "MT", "MD", "MC", "ME", "NL", "NO", "PL", 
            "PT", "RO", "RU", "SM", "RS", "SK", "SI", "ES", "SE", "CH", "TR", "UA", "GB", "VA", "US"];

        $.ajax( { 
            url: '//freegeoip.net/json/', // limited to 10,000 queries per hour
            type: 'POST', 
            dataType: 'jsonp',
            success: function(location) {
                console.log(location.country_code);
                if($.inArray(location.country_code, eu_countries) > -1) {
                    $('#cookie_notice').modal('show'); // show cookie notice if EU country
                    $('#cookie_notice').on('hidden.bs.modal', function () {
                        document.cookie="gdev_cookies=true"; // set cookie status to true
                    })
                }else{
                    document.cookie="gdev_cookies=true"; // set cookie status to true
                }
            }
        });
    }

});