# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  if $('#primary_events_table').length > 0
    updateEventTable = ()->
      $('#updating_event_list').show()
      $('#primary_events_table').dataTable().fnReloadAjax()
      setTimeout (() -> $('#updating_event_list').hide()), 2500

    runPermanentHooks = ()->
      $('.timepicker').timepicker({  'step': 15, 'showDuration': true, 'timeFormat': 'g:ia', 'scrollDefaultNow': true })
      $('.datepicker').datepicker({ 'autoclose': true, 'dateFormat': 'd/m/yy', 'format': 'dd/mm/yyyy' })

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
              $('#event-data-modal').html(data['data'])
              $('#event-data-modal').modal("show")
            else
              alert("Could not get modal info")

      resolve = $(document).on 'click', '.resolve-event', ->
        self = $(this)
        $.post $(this).attr("rel"),
          (data) ->
            if data
              $(self).text("Resolved")
              $(self).css("color", "green")
              $('#event-data-modal').modal("hide")
              updateEventTable()
            else
              $(self).text("Failed to resolve")
              $(self).css("color", "red")

      $(document).on 'click', '.silence-event', ->
        self = $(this)
        $("#event-data-modal").modal("hide")
        $("#modal_" + $(self).attr("misc")).modal("show")

      $(document).on 'click', '.silence-submit-event', ->
        self = $(this)
        misc = $(self).attr("misc")
        $.post $(this).attr("rel"), { 'expire_at_time': $('#silence_expire_at_time_' + misc).val(), 'expire_at_date': $('#silence_expire_at_date_' + misc).val(), 'description': $('#text_input_' + misc).val()},
          (data) ->
            if data
              $("#modal_" + misc).modal("hide")
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
            else
              alert("Failed to unsilence...")

    dtable = $('#primary_events_table').dataTable
      bAutoWidth: false
      bJQueryUI: false
      bProcessing: false
      sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
      sWrapper: "dataTables_wrapper form-inline"
      bServerSide: false
      bSort: true
      aoColumns: [{bVisible: false}, null, null, null, null, null, null, null, null]
      sPaginationType: "bootstrap"
      iDisplayLength: 25
      sAjaxSource: $('#primary_events_table').data('source')
      fnRowCallback: (nRow, aData, iDisplayIndex, iDisplayIndexFull) ->
        if aData[0] == 1
          tr = $('td', nRow).closest('tr')
          $(tr).attr('class', 'critical-event')
          return nRow

    runPermanentHooks()

    setInterval () ->
      updateEventTable()
    , 60000
