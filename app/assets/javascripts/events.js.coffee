# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  updateEventTable = ()->
    $('#updating_event_list').show(1000);
    $.get "/events/events_table",
      (data) ->
        $("#main_events_table").empty();
        $("#main_events_table").append(data['data']);
        $('#updating_event_list').hide(1000);
        $('#event_list_updated').show(1000);
        $('#event_list_updated').hide(2000);
        runTableHooks();
  updateEventTable();
  setInterval () ->
    updateEventTable();
  , 60000
  runTableHooks = ()->
    $('[hidden="true"]').hide();
    $('[hidden="false"]').show();
    $('.silence-input').keypress ->
      $('[control="silence_submit_' + $(this).attr("misc") + '"]').show();
    $('td.moreinfo').click ->
      $($(this).closest('tr').attr("rel")).modal("show");
    $('.rowpopup').popover({ 
      'placement': 'bottom',
      'template': '<div class="popover"><div class="arrow"></div><div class="popover-inner wide-popover"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
      });
    $('.columnpopup').popover({'placement': 'left'});
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
      $("#event-" + $(self).attr("index_id")).modal("hide");
      $("#modal_" + $(self).attr("misc")).modal("show");
    $('.silence-submit-event').click ->
      self = $(this);
      $.post $(this).attr("rel"), { 'description': $('#text_input_' + $(self).attr("misc")).val()},
        (data) ->
          if data
            $("#modal_" + $(self).attr("misc")).modal("hide");
            $('[control="unsilence_' + $(self).attr("misc") + '"]').show();
            $('[control="silence_' + $(self).attr("misc") + '"]').hide();
            $('td[rel="' + $(self).attr("misc") + '_popup_info"]').attr('data-content', $('#input_' + $(self).attr("misc")).val());
            $('td[rel="' + $(self).attr("misc") + '_column_silenced"]').text($('#input_' + $(self).attr("misc")).val());
            $('i[rel="icon_silenced_' + $(self).attr("index_id") + '"]').attr("class", "icon-volume-off");
          else
            alert("Failed to silence...");
    $('.unsilence-submit-event').click ->
      self = $(this);
      $.post $(this).attr("rel"),
        (data) ->
          if data
            $('[control="unsilence_' + $(self).attr("misc") + '"]').hide();
            $('[control="silence_' + $(self).attr("misc") + '"]').show();
            $('td[rel="' + $(self).attr("misc") + '_popup_info"]').attr('data-content', "No");
            $('td[rel="' + $(self).attr("misc") + '_column_silenced"]').text("No");
            $('i[rel="icon_silenced_' + $(self).attr("index_id") + '"]').attr("class", "icon-volume-up");
          else
            alert("Failed to unsilence...");
