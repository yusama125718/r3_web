// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require popper
//= require bootstrap
import "@hotwired/turbo-rails"
import "controllers"

$(function($) {
  $(".clickable-row").css("cursor","pointer").click(function() {
      location.href = $(this).data("href");
  });
});