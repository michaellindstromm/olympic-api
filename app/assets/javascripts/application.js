//= require jquery3
//= require popper
//= require bootstrap
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require_tree .


var example_request = {

    color_options: {
        yellow: ["curl", "from", "import", "print", "require", "puts", "var", "function", "console"],
        green: ["=", "log"],
        grey: ["(", "{", "'", ")", "}", ",", ";"],
        purple: ["'GET'", "'rest_client'", "'request'", "'Status:'", "'Headers:'", "'Response:'"]
    },

    cURL: 
        "curl --include \\\ ~ 'https://olympicapi.herokuapp.com/api/' ~ ", 

    Python: "from urllib2 import Request , urlopen ~ ~ request = Request ( 'https://olympicapi.herokuapp.com/api/' ) ~ ~ response_body = urlopen ( request ) .read ( ) ~ print response_body ~ ",

    Ruby: "require 'rest_client' ~ ~ response = RestClient.get 'https://olympicapi.herokuapp.com/api/' ~ puts response ~ ",
    Node: "var request = require ( 'request' ) ; ~ ~ request ( 'https://olympicapi.herokuapp.com/api/' , function ( error , response , body ) { ~ console.log ( 'Status:' , response.statusCode ) ; ~ console.log ( 'Headers:' , JSON.stringify ( response.headers ) ) ; ~ console.log ( 'Response:' , body ) ; ~ } ) ; ~"
}

$(document).ready(function() {
    listeners();
});

let listeners = function() {

    $('body').scrollspy({ target: '#sidebar' })
    
    $('.tester').on('click', function(e) {
        // console.log('hello');
        $(this).addClass('hidden');
    });


    $('.dark-language-menu a').on('click', function(e) {
        e.preventDefault();
        $(this).parent().siblings('.dark-dropdowns-button').text($(this).text());
        $(this).parent().siblings('.dark-dropdowns-button').val($(this).text());

        dropdown_selection = $(this).parent().siblings('.dark-dropdowns-button').val();

        $('.dark-language-div').html('');
        $('.dark-line-count').html('');
        
        count = 1
        depth = 0;
        first_char = false;

        $('.dark-language-div').append(`<span id=language-line${count} class='code-line'></span>`);
        example_request[dropdown_selection].split(' ').forEach(function(item, index) {

            next_grey = example_request.color_options.grey.indexOf(example_request[dropdown_selection].split(" ")[index + 1]);

            if (item === "}" && first_char) {
                depth -= 1;
            }

            if (depth > 0 && first_char) {
                first_char = false
                for(i = 0; i < depth; i++) {
                    $(`#language-line${count}`).append("&emsp;&emsp;");
                }
            }


            if (example_request.color_options.yellow.indexOf(item) !== -1 ) {

                $(`#language-line${count}`).append("<span class='qmethod'>" + item + "</span>");
                if (next_grey !== -1) {

                } else {
                    $(`#language-line${count}`).append("   ");
                }

            } else if (example_request.color_options.green.indexOf(item) !== -1) {

                $(`#language-line${count}`).append("<span class='qgreen'>" + item + "</span>");
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
                if (count < 10) {
                    $('.dark-line-count').append("<span class='text-muted'>" + "0" + (count) + "</span>" + "</br>");
                } else {
                    $('.dark-line-count').append("<span class='text-muted'>" + (count) + "</span>" + "</br>");
                }

                if ($(`#language-line${count}`).text().split('').length > 150) {
                    $('.dark-line-count').append("</br></br>");
                } else if ($(`#language-line${count}`).text().split('').length > 75) {
                    $('.dark-line-count').append("</br>");
                }

                count += 1

                $('.dark-language-div').append(`<span id=language-line${count} class='code-line'></span>`);


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

            if (item === "{" && first_char) {
                depth += 1;
            } 
            
        });

    });

    
};

// var token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MTI5MzcwNjJ9.f2IIkus_lENV4EJDaYzhI0Nz7HyVXVw5Rw3qeMflrMM';

// $.ajax({
//     url: '/api/athletes',
//     headers: {
//         'Authorization': token,
//         'Accept': 'version=v2'
//     }
// }).done(function (res) {
//     console.log(res)
// }).fail(function(e) {
//     console.log(e);
// });

// $.ajax({
//     url: "/api/endpoints",
// }).done(function (res) {
//     console.log(res);
// });


// $.ajax({
//     method: 'POST',
//     url: '/api/authenticate',
//     data: {
//         'email':'test@test.com',
//         'password':'123123123'
//     }
// }).done(function (res) {
//     console.log('response', res);
// });

