//= require jquery3
//= require popper
//= require bootstrap
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require flipclock.min
//= require_tree .

let request_uri = "'https://olympicapi.herokuapp.com/api/endpoints'"
let base_uri = "'https://olympicapi.herokuapp.com/api/"
let token;
var selection;
let count = 1
var scrolling = false;

// This object holds the example language requests that are formatted in the correct way. All characters and words are seperated by spaces, and line breaks are denoted by the '~' symbol. This object also holds the color options to colorized the out put correctly.

var example_request = {

    color_options: {
        yellow: ["curl", "from", "import", "print", "require", "puts", "var", "function", "console", "new", "if", "using", "string", "await"],
        green: ["=", "log", "==="],
        grey: ["(", "{", "'", ")", "}", ",", ";", "[", "]"],
        purple: ["'GET'", "'rest_client'", "'request'", "'Status:'", "'Headers:'", "'Response:'", "'Body:'"]
    },

    cURL: 
        `curl -H 'Authorization: [TOKEN]' -H 'Accept: version=v2' ~ [[URI_HOLDER]] ~ `, 

    Python: `from urllib2 import Request , urlopen ~ ~ request = Request ( [[URI_HOLDER]] , headers = ~ { 'Authorization' : '[TOKEN]' , 'Accept' : 'version=v2' } ) ~ ~ response_body = urlopen ( request ) .read ( ) ~ print response_body ~ `,

    Ruby: `require 'rest_client' ~ ~ response = RestClient.get [[URI_HOLDER]] , headers = { 'Authorization' : '[TOKEN]' , 'Accept' : 'version=v2' } ~ puts response ~ `,

    Node: `var request = require ( 'request' ) ; ~ ~ var options = { ~ url : [[URI_HOLDER]] , ~ headers : { ~ 'Authorization' : '[TOKEN]' , ~ 'Accept' : 'version=v2' ~ } ~ } ; ~ ~  function callback ( error , response , body ) { ~ console.log ( 'Status:' , response.statusCode ) ; ~ console.log ( 'Headers:' , JSON.stringify ( response.headers ) ) ; ~ console.log ( 'Response:' , body ) ; ~ } ~ ~ request ( options , callback ) ; ~`,

    JavaScript: `var request = new XMLHttpRequest() ; ~ ~ request.open ( 'GET' , [[URI_HOLDER]] ) ; ~ request.setRequestHeader ( 'Authorization' , [TOKEN] ) ; ~ request.setRequestHeader ( 'Accept', 'version=v2' ) ; ~ ~ request.onreadystatechange = function ( ) { ~ if ( this.readyState === 4 ) { ~ console.log ( 'Status:' , this.status ) ; ~ console.log ( 'Headers:' , this.getAllResponseHeaders() ) ; ~ console.log ( 'Body:' , this.responseText ) ; ~ } ~ } ; ~ ~ request.send() ; ~`,

    cSharp: `using System ; ~ ~ using System.Net.Http ; ~ ~ var baseAddress = new Uri ( [[URI_HOLDER]] ) ; ~ using ( var httpClient = new HttpClient { BaseAddress = baseAddress } ) { ~ ~ using ( var response = await httpClient.GetAsync ( 'undefined' ) ) { ~ ~ string responseData = await response.Content.ReadAsStringAsync() ; ~ ~ } ~ } ; ~`
}

// Have to use on 'turbolinks:load' instead of on 'ready', otherwise same page links will not load properly and the try server will not work when leaving and returning to index page without refresh. This calls the method to set the listeners and also to ready the try server.

$(document).on('turbolinks:load', function () {

    if (window.location.pathname === '/') {
        getNewToken();
        homeListeners();
        selection = undefined;
    } else {
        formListeners();
    }
});

// Listener specifically for the form, as to not load all home page listeners. These probably need to be allocated to their own file. For the future!
function formListeners() {

    // Disables button only when passwords match so form can only be submitted with correct password because bootstraps for validator does the rest for the other fields.
    // $('.password_confirmation').on('keyup', function(e) {
    //     if ($(this).val().length > 7 && $(this).val() === $('.password').val()) {
    //         $('.firstTokenButton').attr('disabled', false);
    //         $(this).siblings('.customLabel').css({'color':'#007bff'});
    //         $(this).css({'border-color':'#007bff'});
    //     } else if ($(this).val().length === 0) {
    //         $('.firstTokenButton').attr('disabled', false);
    //         $(this).siblings('.customLabel').css({'color':'#007bff'});
    //         $(this).css({'border-color':'#007bff'});
    //     } else {
    //         $('.firstTokenButton').attr('disabled', true);
    //         $(this).siblings('.customLabel').css({'color':'red'});
    //         $(this).css({'border-color':'red'});
    //     }
    // });

    // $('.password').on('keyup', function(e) {
    //     if ($(this).val().length > 7 && $(this).val() === $('.password').val()) {
    //         $(this).siblings('.customLabel').css({ 'color': '#007bff' });
    //         $(this).css({ 'border-color': '#007bff' });
    //     } else if ($(this).val().length === 0) {
    //         $(this).siblings('.customLabel').css({ 'color': '#007bff' });
    //         $(this).css({ 'border-color': '#007bff' });
    //     } else {
    //         $(this).siblings('.customLabel').css({ 'color': 'red' });
    //         $(this).css({ 'border-color': 'red' });
    //     }
    // });

    var date = new Date("February 08, 2018 00:00:00"); //Month Days, Year HH:MM:SS
    var now = new Date();
    var diff = (date.getTime() / 1000) - (now.getTime() / 1000);

    var clock = $('.clock').FlipClock(diff, {
        clockFace: 'DailyCounter',
        countdown: true
    });

    $('.customInput').each(function(index, item) {
        if ($(item).val().length > 0) {
            $(item).siblings('.customLabel').addClass('is_active');
        }
    });

    $('.customInput').on('focus', function(e) {
        $(this).siblings('.customLabel').addClass('is_active');
    });
    
    $('.customInput').on('blur', function(e) {
        if ($(this).val().length === 0) {
            $(this).siblings('.customLabel').removeClass('is_active');
        } 
    });

    $('.field_with_errors .customInput').on('focus', function(e) {
        $('.field_with_errors .customLabel').addClass('is_active');
    });

    $('.field_with_errors .customInput').on('blur', function (e) {
        if ($(this).val().length === 0) {
            $(this).parent().siblings('.field_with_errors').children('.customLabel').removeClass('is_active');
        }
    });

    
    $('.alert').delay(2700).fadeOut(1000);
    
};


// Listeners for index page
let homeListeners = function() {

    // This prevents turbolinks get requests on any link click.
    $(document).on('turbolinks:click', function (event) {
        if (event.target.getAttribute('href').charAt(0) === '#') {
            return event.preventDefault()
        }
    })

    // Scrollspy for sidebar
    $('body').scrollspy({ target: '#sidebar' })
    
    // Listener for the try server language example dropdown
    $('.dark-language-menu a').on('click', function(e) {
        e.preventDefault();

        // Sets the language selected to show for dropdown
        $(this).parent().siblings('.dark-dropdowns-button').text($(this).text());
        if ($(this).text() === "c#") {
            $(this).parent().siblings('.dark-dropdowns-button').val('cSharp');

        } else {
            $(this).parent().siblings('.dark-dropdowns-button').val($(this).text());

        }

        selection = $(this).parent().siblings('.dark-dropdowns-button').val();

        // Calls method to take correct string from the example_request object and format it correctly.
        format_as_json(example_request[selection], '.dark-language-div');

    });

    // Listens for enter key to make call to requested endpoint and also to show what user is typing in request language div
    $('.dark-input-url').on('keyup', function(e) {

        if (e.which === 13) {
            makeTheCall();
        }

        if (selection) {

            format_as_json(example_request[selection], '.dark-language-div')

        }
    });

    
};

// Method that formats and colorizes language request
function format_as_json(selection, output_div) {

    // clears output
    $(output_div).html('');
    // updates request endpoint to what user has inputed
    update_uri();

    // variables used for formatting
    depth = 0;
    first_char = false;
    line_count = 1;

    // create new line
    $(output_div).append(`<span id=language-line${count} class='code-line'></span>`);

    // take correct language string, split it, and loop over each character
    selection.split(' ').forEach(function (item, index) {

        next_grey = example_request.color_options.grey.indexOf(selection.split(" ")[index + 1]);

        if (item === "[[URI_HOLDER]]") {
            item = request_uri;
        }

        if (item === "{" && index > 0) {
            first_char = true
            depth += 1;
        } else if (item === "}") {
            depth -= 1;
        }

        if (depth > 0 && first_char) {
            first_char = false
            for (i = 0; i < depth; i++) {
                $(`#language-line${count}`).append("&emsp;&emsp;");
            }
        }


        if (example_request.color_options.yellow.indexOf(item) !== -1) {

            $(`#language-line${count}`).append("<span class='qmethod'>" + item + "</span>");

            if (item === "if" || item === "using") {
                $(`#language-line${count}`).append("   ");
            }

            if (next_grey !== -1) {

            } else {
                $(`#language-line${count}`).append("   ");
            }

        } else if (example_request.color_options.green.indexOf(item) !== -1) {

            $(`#language-line${count}`).append("<span class='number'>" + item + "</span>");
            if (next_grey !== -1) {

            } else {
                $(`#language-line${count}`).append("   ");
            }

        } else if (example_request.color_options.grey.indexOf(item) !== -1) {

            $(`#language-line${count}`).append("<span style='color:grey'>" + item + "</span>");

            if (item === ",") {
                $(`#language-line${count}`).append(" ");
            }

        } else if (example_request.color_options.purple.indexOf(item) !== -1) {

            $(`#language-line${count}`).append("<span class='chrome-purple'>" + item + "</span>");

            if (next_grey !== -1) {

            } else {
                $(`#language-line${count}`).append("   ");
            }

        } else if (item === "~") {

            first_char = true;

            $(`#language-line${count}`).append("</br>");

            count += 1

            $(output_div).append(`<span id=language-line${count} class='code-line'></span>`);


        } else {

            if (item === "console.log") {
                cl = item.split('.')
                $(`#language-line${count}`).append("<span class='qmethod'>" + cl[0] + "</span>");
                $(`#language-line${count}`).append("<span class='dark-code-font'>" + "." + "</span>");
                $(`#language-line${count}`).append("<span class='qgreen'>" + cl[1] + "</span>");
            } else {

                $(`#language-line${count}`).append("<span class='dark-code-font'>" + item + "</span>");
            }


            if (next_grey !== -1) {

            } else {
                $(`#language-line${count}`).append("   ");
            }

        }

    });
};


// updates the request url to the one the user has inputed. used for display in language request div
function update_uri() {
    request_uri = base_uri + $('.dark-input-url').val() + "'";
}

// makes call based on user input
function makeTheCall() {
    $.ajax({
        url: "/api/" + $('.dark-input-url').val(),
        headers: {
            'Authorization': token,
            'Accept': 'version=v2'
        }
    }).done(function (res) {
        seeResponse(res);
    }).fail(function(e) {
        // checks to see if unauthorized meaning the token as expired and then makes the call again
        if (e.status === 401) {
            getNewToken();
        } else if (e.status === 404) {
            $('.dark-response-div pre').html('Please make a valid request.');

        } else if (e.status === 429) {
            $('.dark-response-div pre').html('Wooooah Nelly. Slow down there.');
        
        }
    });
}

// gets a new token for use in the try server
function getNewToken() {
    $.ajax({
        method: 'POST',
        url: '/api/authenticate',
        data: {
            'email': 'test@test.com',
            'password': '123123123'
        }
    }).done(function (res) {
        token = res.auth_token;
        makeTheCall();
    });
}

// called after a successful response is returned which stringifies the json, formats it, and then appends it to the response div for display
function seeResponse(response) {

    response_as_string = JSON.stringify(response, null, 4)

    $('.dark-response-div pre').html('');

    $('.dark-response-div pre').append(syntaxHighlight(response_as_string, false));
}


// regex used for knowing which color to make json so it looks all pretty
function syntaxHighlight(json) {
    json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
        var cls = 'number';
        if (/^"/.test(match)) {
            if (/:$/.test(match)) {
                cls = 'key';
            } else {
                cls = 'string';
            }
        } else if (/true|false/.test(match)) {
            cls = 'boolean';
        } else if (/null/.test(match)) {
            cls = 'null';
        }
        return '<span class="' + cls + '">' + match + '</span>';
    });
}
