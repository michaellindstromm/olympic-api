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
        // console.log('hello');
        $(this).addClass('hidden');
    });


    $('.dark-dropdowns a').on('click', function(e) {
        e.preventDefault();
        $(this).parent().siblings('.dark-dropdowns-button').text($(this).text());
        $(this).parent().siblings('.dark-dropdowns-button').val($(this).text());
        // console.log($('.root-url').html() + $('.dark-input-url').val());
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

