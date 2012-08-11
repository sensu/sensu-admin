# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  modal_shown = false
  should_update = false
  updateEventTable = ()->
    if modal_shown
      should_update = true
    else
      $('#error_event_list').hide();
      $('#updating_event_list').show();
      $.ajax "/events/events_table",
        type: 'GET'
        error: (jqXHR, textStatus, errorThrown) ->
          $('#updating_event_list').hide();
          $('#error_event_list').show();
        success: (data, textStatus, jqXHR) ->
          $("#main_events_table").html(data['data']);
          $('#updating_event_list').hide();
          runTableHooks();
  updateEventTable();
  setInterval () ->
    updateEventTable();
  , 60000
  runTableHooks = ()->
    $('.modal').on 'shown', ->
      modal_shown = true
    $('.modal').on 'hide', ->
      modal_shown = false
      if should_update
        should_update = false
        updateEventTable();
    $('[hidden="true"]').hide();
    $('[hidden="false"]').show();
    $('.silence-input').keypress ->
      $('[control="silence_submit_' + $(this).attr("misc") + '"]').show();
    $('td.moreinfo').click ->
      $($(this).closest('tr').attr("rel")).modal("show");
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
      should_update = false
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
            updateEventTable();
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
    search_val = $('#events_search').val();
    $('#primary_events_table').tableFilter({ additionalFilterTriggers: [$('#events_search')]});
    $('#events_search').val(search_val);
    $('#primary_events_table').tableFilterApplyFilterValues();
    $('#primary_events_table').tableFilterRefresh();
    $('.filters').hide();
    
