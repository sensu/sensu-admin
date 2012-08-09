# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  $('[hidden="true"]').hide();
  $('[hidden="false"]').show();
  $('.silence-input').keypress ->
    $('#silence_' + $(this).attr("title")).text($(this).attr("rel"));
    $('[client_silence=client_silencer_' + $(this).attr("index_id") + ']').text($(this).attr("rel"));
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
    $.post $(this).attr("rel"), { 'description': $('#input_' + $(self).attr("misc")).val()},
      (data) ->
        if data
          $(self).hide();
          $('#input_' + $(self).attr("misc")).hide();
          $('#unsilence_' + $(self).attr("misc")).show();
          $('#silence_' + $(self).attr("misc")).hide();
          $('td[rel="' + $(self).attr("misc") + '_popup_info"]').attr('data-content', $('#input_' + $(self).attr("misc")).val());
          $('td[rel="' + $(self).attr("misc") + '_column_silenced"]').text($('#input_' + $(self).attr("misc")).val());
          $('i[rel="' + $(self).attr("misc") + '_icon_silenced"]').attr("class", "icon-volume-off");
        else
          alert("Failed to unsilence...");
  $('.unsilence-event').click ->
    self = $(this);
    $.post $(this).attr("rel"),
      (data) ->
        if data
          $(self).hide();
          $('#input_' + $(self).attr("misc")).show();
          $('#unsilence_' + $(self).attr("misc")).hide();
          $('#silence_' + $(self).attr("misc")).show();
          $('td[rel="' + $(self).attr("misc") + '_popup_info"]').attr('data-content', "No");
          $('td[rel="' + $(self).attr("misc") + '_column_silenced"]').text("No");
          $('i[rel="' + $(self).attr("misc") + '_icon_silenced"]').attr("class", "icon-volume-up");
        else
          alert("Failed to unsilence...");
