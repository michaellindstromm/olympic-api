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


    $('.dark-dropdowns a').on('click', function(e) {
        e.preventDefault();
        $(this).parent().siblings('.dark-dropdowns-button').text($(this).text());
        $(this).parent().siblings('.dark-dropdowns-button').val($(this).text());
    });

};

var token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MTI4OTA4NjF9.vF3Pi7WX1zWcmHdCk_Qz7J3sfagJJCKwIhFLvdaXsRE';

$.ajax({
    url: '/api/olympics?page=4&per_page=15',
    headers: {
        'Authorization': token,
        'Accept': 'version=v2'
    }
}).done(function (res) {
    console.log(res)
}).fail(function(e) {
    console.log(e);
});

$.ajax({
    url: "/api/endpoints",
}).done(function (res) {
    console.log(res);
});

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

