# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  update_counter = 0
  modal_shown = false
  should_update = false
  updateEventTable = ()->
    if modal_shown
      should_update = true
      if update_counter > 30
        location.reload() # A nasty hack to get around JS loading up and crashing the browser
    else
      $('#error_event_list').hide()
      $('#updating_event_list').show()
      search_query = $('input[aria-controls="primary_events_table"]').val()
      $.ajax "/events/events_table",
        type: 'GET'
        error: (jqXHR, textStatus, errorThrown) ->
          $('#updating_event_list').hide()
          $('#error_event_list').show()
        success: (data, textStatus, jqXHR) ->
          $("#main_events_table").html(data['data'])
          $('#updating_event_list').hide()
          dropTableHooks()
          runTableHooks()
          $('#primary_events_table').dataTable({
              "oSearch": {"sSearch": search_query},
              "sPaginationType": "bootstrap",
              "iDisplayLength": 50
            })
  dropTableHooks = ()->
    $('.modal').unbind()
    $('.timepicker').unbind()
    $('.datepicker').unbind()
    $('#primary_events_table').unbind()
  runTableHooks = ()->
    $('[hidden="true"]').hide()
    $('[hidden="false"]').show()
    $('.timepicker').timepicker({  'step': 15, 'showDuration': true, 'timeFormat': 'g:ia', 'scrollDefaultNow': true })
    $('.datepicker').datepicker({ 'autoclose': true, 'dateFormat': 'd/m/yy', 'format': 'dd/mm/yyyy' })
  runPermanentHooks = ()->
    $(document).on 'shown', '.modal', ->
      modal_shown = true
    $(document).on 'hide', '.modal', ->
      modal_shown = false
      if should_update
        should_update = false
        updateEventTable()
    $(document).on 'keydown', '.silence-input', ->
      self = $(this)
      misc = $(self).attr("misc")
      $('#no_input_' + $(self).attr("misc")).hide()
      if $(self).val().length > 12
        $('[control="silence_grey_submit_' + misc + '"]').hide()
        $('[control="silence_submit_' + misc + '"]').show()
      else
        $('[control="silence_grey_submit_' + misc + '"]').show()
        $('[control="silence_submit_' + misc + '"]').hide()
    $(document).on 'click', '[control^=silence_grey_submit_]', ->
      $('#no_input_' + $(this).attr("misc")).show()
    $(document).on 'click', 'div.moreinfo', ->
      $.get "/events/modal_data", { 'event_query': $(this).attr('misc'), 'i': $(this).attr('index_id') },
        (data) ->
          if data
            $('#event-data-moda').html(data)
            $('#event-data-modal').modal("show")
          else
            alert("Could not get modal info")
    resolve = $(document).on 'click', '.resolve-event', ->
      self = $(this)
      $.post $(this).attr("rel"),
        (data) ->
          if data
            $(self).text("Resolved")
            $($(self).attr("misc")).hide()
            $(self).css("color", "green")
          else
            $(self).text("Failed to resolve")
            $(self).css("color", "red")
    $(document).on 'click', '.silence-event', ->
      self = $(this)
      should_update = false
      $("#event-" + $(self).attr("index_id")).modal("hide")
      $("#modal_" + $(self).attr("misc")).modal("show")
    $(document).on 'click', '.silence-submit-event', ->
      self = $(this)
      misc = $(self).attr("misc")
      $.post $(this).attr("rel"), { 'expire_at_time': $('#silence_expire_at_time_' + misc).val(), 'expire_at_date': $('#silence_expire_at_date_' + misc).val(), 'description': $('#text_input_' + misc).val()},
        (data) ->
          if data
            $("#modal_" + misc).modal("hide")
            $('td[rel="' + misc + '_popup_info"]').attr('data-content', $('#input_' + misc).val())
            $('td[rel="' + misc + '_column_silenced"]').text($('#input_' + misc).val())
            $('i[rel="icon_silenced_' + $(self).attr("index_id") + '"]').attr("class", "icon-volume-off")
            updateEventTable()
          else
            alert("Failed to silence...")
    $(document).on 'click', '.unsilence-submit-event', ->
      self = $(this)
      misc = $(self).attr("misc")
      $.post $(this).attr("rel"),
        (data) ->
          if data
            $('[control="unsilence_' + misc + '"]').hide()
            $('[control="silence_' + misc + '"]').show()
            $('td[rel="' + misc + '_popup_info"]').attr('data-content', "No")
            $('td[rel="' + misc + '_column_silenced"]').text("No")
            $('i[rel="icon_silenced_' + $(self).attr("index_id") + '"]').attr("class", "icon-volume-up")
          else
            alert("Failed to unsilence...")
  setInterval () ->
    update_counter = update_counter + 1
    updateEventTable()
  , 60000
  updateEventTable()
  runPermanentHooks()
  runTableHooks()
  runPermanentHooks()
