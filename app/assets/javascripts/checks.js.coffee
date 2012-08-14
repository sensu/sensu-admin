# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.collapse').on 'show', ->
    $('#icon_toggle_' + $(this).attr("rel")).attr('class', 'icon-minus');
  $('.collapse').on 'hide', ->
    $('#icon_toggle_' + $(this).attr("rel")).attr('class', 'icon-plus');
  $('a.modal-for-check-submit').click ->
    $('#check_modal_' + $(this).attr("misc")).modal("show");
  $('.submit-individual-check').click ->
    self = $(this)
    $.post $(this).attr("rel"), { 'subscribers': $('#subscribers_input_' + $(this).attr("misc")).val()},
      (data) ->
        if data
          $('#check_modal_' + $(self).attr("misc")).modal("hide");
