# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  $('.silence-input').keypress ->
    $('#silence_' + $(this).attr("title")).text($(this).attr("rel"));
  $('tr').click ->
    $($(this).attr("rel")).modal("show");
  $('.popupx').popover();
  resolve = $('.resolve-event').click ->
    self = $(this);
    $.post $(this).attr("rel"),
      (data) ->
        if data
          $(self).text("Resolved");
          $($(self).attr("misc")).hide();
          $(self).css("color", "green");
        else
          $(self).text("Failed to resolve");
          $(self).css("color", "red");
  $('.silence-event').click ->
    self = $(this);
    $.post $(this).attr("rel"), { 'description': $('#input_' + $(this).attr("misc")).val()},
      (data) ->
        if data
          $(self).hide();
          $('#input_' + $(self).attr("misc")).hide();
          $('#unsilence_' + $(self).attr("misc")).show();
          $('td[rel="' + $(self).attr("misc") + '_column_silenced"]').text("true");
          $('i[rel="' + $(self).attr("misc") + '_icon_silenced"]').attr("class", "icon-volume-off");
        else
          $(self).text("Failed to silence");
          $(self).css("color", "red");
