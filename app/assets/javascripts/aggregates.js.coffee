# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('a.modal-for-aggregate-display').click ->
    $('#aggregate_modal_' + $(this).attr("misc")).modal("show")
