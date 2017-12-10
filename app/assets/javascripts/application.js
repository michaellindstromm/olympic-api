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

var token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MTI4NzI1MTh9.i8iHd7Duc3ApEUOEZ4Raj20b_QdOg1DQrF-lG6F0KcE';

$.ajax({
    url: "/api/endpoints",
}).done(function (res) {
    makeCall(res);
});

function makeCall(endpoints) {

    $.ajax({
        url: '/api/olympics/49?page=4&per_page=15',
        headers: {
            'Authorization': token,
            'Accept': 'version=v2'
        }
    }).done(function (res) {
        console.log(res)
    });
};

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

