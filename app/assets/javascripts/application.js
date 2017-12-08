//= require jquery3
//= require popper
//= require bootstrap
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require_tree .

$(document).ready(function() {
    listeners();
});

let listeners = function() {

    $('body').scrollspy({ target: '#sidebar' })
    
    $('.tester').on('click', function(e) {
        console.log('hello');
        $(this).addClass('hidden');
    });


};

$.ajax({
    url: "/sports",
    headers: {
        'Authorization': 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo1LCJleHAiOjE1MTI4MzI2NTl9.c_AZx_vsX7KRcovSMdUdnauaT7ogCW5iqBO2ZljinhI',
        'Accept': 'version=v2'
    }
}).done(function () {
    console.log("Hooray sports!")
});

// $.ajax({
//     method: 'POST',
//     url: '/authenticate',
//     data: {
//         'email':'new@new.com',
//         'password':'123123123'
//     }
// }).done(function (res) {
//     console.log('response', res);
// });

