# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  $('tr').click ->
    $($(this).attr("rel")).modal("show");
  $('.console-output').qtip({ content: { attr: 'rel' } });
  clicked = $('.resolve-event').click ->
    $.post $(this).attr("rel"),
      (data) ->
        if data
          clicked.text("Resolved");
          clicked.css("color", "green");
        else
          clicked.text("Failed to resolve");
          clicked.css("color", "red");
