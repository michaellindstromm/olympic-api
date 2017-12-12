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
let count = 1

var example_request = {

    color_options: {
        yellow: ["curl", "from", "import", "print", "require", "puts", "var", "function", "console", "new", "if", "using", "string", "await"],
        green: ["=", "log", "==="],
        grey: ["(", "{", "'", ")", "}", ",", ";", "[", "]"],
        purple: ["'GET'", "'rest_client'", "'request'", "'Status:'", "'Headers:'", "'Response:'", "'Body:'"]
    },

    cURL: 
        `curl --include \\\ ~ [[URI_HOLDER]] ~ `, 

    Python: `from urllib2 import Request , urlopen ~ ~ request = Request ( [[URI_HOLDER]] ) ~ ~ response_body = urlopen ( request ) .read ( ) ~ print response_body ~ `,

    Ruby: `require 'rest_client' ~ ~ response = RestClient.get [[URI_HOLDER]] ~ puts response ~ `,

    Node: `var request = require ( 'request' ) ; ~ ~ request ( [[URI_HOLDER]] , function ( error , response , body ) { ~ console.log ( 'Status:' , response.statusCode ) ; ~ console.log ( 'Headers:' , JSON.stringify ( response.headers ) ) ; ~ console.log ( 'Response:' , body ) ; ~ } ) ; ~`,

    JavaScript: `var request = new XMLHttpRequest() ; ~ ~ request.open ( 'GET' , [[URI_HOLDER]] ) ; ~ ~ request.onreadystatechange = function ( ) { ~ if ( this.readyState === 4 ) { ~ console.log ( 'Status:' , this.status ) ; ~ console.log ( 'Headers:' , this.getAllResponseHeaders() ) ; ~ console.log ( 'Body:' , this.responseText ) ; ~ } ~ } ; ~ ~ request.send() ; ~`,

    Java: `using System ; ~ ~ using System.Net.Http ; ~ ~ var baseAddress = new Uri ( [[URI_HOLDER]] ) ; ~ using ( var httpClient = new HttpClient { BaseAddress = baseAddress } ) { ~ ~ using ( var response = await httpClient.GetAsync( 'undefined' ) ) { ~ ~ string responseData = await response.Content.ReadAsStringAsync() ; ~ ~ } ~ } ~`
}

var selection;

$(document).on('turbolinks:load', function () {
    if (window.location.pathname === '/') {
        getNewToken();
        homeListeners();
        selection = undefined;

    } else {
        formListeners();
    }
});

function formListeners() {

    $('#passwordConfirm').on('keyup', function(e) {
        if ($(this).val().length > 7 && $(this).val() === $('#password').val()) {
            $('.firstTokenButton').attr('disabled', false);
        } else {
            $('.firstTokenButton').attr('disabled', true);
        }
    });

    var date = new Date("February 08, 2018 00:00:00"); //Month Days, Year HH:MM:SS
    var now = new Date();
    var diff = (date.getTime() / 1000) - (now.getTime() / 1000);

    var clock = $('.clock').FlipClock(diff, {
        clockFace: 'DailyCounter',
        countdown: true
    });
};


let homeListeners = function() {

    $(document).on('turbolinks:click', function (event) {
        if (event.target.getAttribute('href').charAt(0) === '#') {
            return event.preventDefault()
        }
    })

    $('body').scrollspy({ target: '#sidebar' })
    
    $('.dark-language-menu a').on('click', function(e) {
        e.preventDefault();

        $(this).parent().siblings('.dark-dropdowns-button').text($(this).text());
        $(this).parent().siblings('.dark-dropdowns-button').val($(this).text());

        selection = $(this).parent().siblings('.dark-dropdowns-button').val();

        
        format_as_json(example_request[selection], '.dark-language-line-count', '.dark-language-div');

    });

    $('.dark-input-url').on('keyup', function(e) {

        if (e.which === 13) {
            makeTheCall();
        }

        if (selection) {

            format_as_json(example_request[selection], '.dark-language-line-count', '.dark-language-div')

        }
    });

    
};

function format_as_json(selection, counter_div, output_div) {
    $(output_div).html('');
    $(counter_div).html('');
    update_uri();
    depth = 0;
    first_char = false;
    line_count = 1;

    $(output_div).append(`<span id=language-line${count} class='code-line'></span>`);
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

function update_uri() {
    request_uri = base_uri + $('.dark-input-url').val() + "'";
}

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
        if (e.status === 401) {
            getNewToken();
        } else if (e.status === 404) {
            $('.dark-response-div pre').html('Please make a valid request.');

        } else if (e.status === 429) {
            $('.dark-response-div pre').html('Wooooah Nelly. Slow down there.');
        
        }
    });
}

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
        populateResponseExample();
        populateEndpointExample();
    });
}

function populateEndpointExample () {
    $.ajax({
        url: "/api/endpoints",
        headers: {
            'Authorization': token,
            'Accept': 'version=v2'
        }
    }).done(function (res) {
        $('.light-endpoint-example').html(syntaxHighlight(JSON.stringify(res, null, 4), true));
    });

};

function populateResponseExample() {
    $.ajax({
        url: "/api/countries?page=2&per_page=5",
        headers: {
            'Authorization': token,
            'Accept': 'version=v2'
        }
    }).done(function (res) {
        $('.light-response-example').html(syntaxHighlight(JSON.stringify(res, null, 4), true));
    });
};

function seeResponse(response) {

    response_as_string = JSON.stringify(response, null, 4)

    $('.dark-response-div pre').html('');

    $('.dark-response-div pre').append(syntaxHighlight(response_as_string, false));
}

function syntaxHighlight(json, light) {
    json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
        if (light) {
            var cls = 'qblue'
        } else {
            var cls = 'number';
        }
        if (/^"/.test(match)) {
            if (/:$/.test(match)) {
                if (light) {
                    cls = 'chrome-purple'
                } else {
                    cls = 'key';
                }
            } else {
                if (light) {
                    cls = 'code-red'
                } else {
                    cls = 'string';
                }
            }
        } else if (/true|false/.test(match)) {
            cls = 'boolean';
        } else if (/null/.test(match)) {
            cls = 'null';
        }
        return '<span class="' + cls + '">' + match + '</span>';
    });
}
