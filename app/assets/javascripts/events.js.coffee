# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$ ->
  # Hack so that escape works on modals
  $('div.modal').attr("tabindex", "-1")

  if $('#primary_events_table').length > 0
    updateEventTable = ()->
      $('#updating_event_list').show()
      $('#primary_events_table').dataTable().fnReloadAjax()
      setTimeout (() -> $('#updating_event_list').hide()), 2500

    setPickers = ()->
      $('.timepicker').timepicker({  'step': 15, 'showDuration': true, 'timeFormat': 'g:ia', 'scrollDefaultNow': true })
      $('.datepicker').datepicker({ 'autoclose': true, 'dateFormat': 'd/m/yy', 'format': 'dd/mm/yyyy' })

    runPermanentHooks = ()->
      $(document).on 'keydown', '.silence-input', ->
        misc = $(this).attr("misc")
        $('#no_input_' + $(this).attr("misc")).hide()
        if $(this).val().length >= $(this).data("min")
          $('[control="silence_submit_' + misc + '"]').addClass('btn-success').removeClass('btn-inverse')
        else
          $('[control="silence_submit_' + misc + '"]').addClass('btn-inverse').removeClass('btn-success')

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

      $(document).on 'click', '.silence-client', ->
        $("#event-data-modal").modal("hide")
        $.get "/events/modal_silence", { 'event_query': $(this).attr('misc'), 'i': $(this).attr('index_id'), 't':'client' },
          (data) ->
            if data
              $('#event-data-modal').html(data['data'])
              $('#event-data-modal').modal("show")
              setPickers()
            else
              alert("Could not get modal info")

      $(document).on 'click', '.silence-check', ->
        $("#event-data-modal").modal("hide")
        $.get "/events/modal_silence", { 'event_query': $(this).attr('misc'), 'i': $(this).attr('index_id'), 't':'check' },
          (data) ->
            if data
              $('#event-data-modal').html(data['data'])
              $('#event-data-modal').modal("show")
              setPickers()
            else
              alert("Could not get modal info")

      $(document).on 'click', '.silence-submit-event', ->
        misc = $(this).attr("misc")
        if $('#text_input_' + misc).val().length < $('#text_input_' + misc).data("min")
          alert('Comment must be at least ' + $('#text_input_' + misc).data("min") + ' characters long')
          return false
        $.post $(this).attr("rel"), { 'expire_at_time': $('#silence_expire_at_time_' + misc).val(), 'expire_at_date': $('#silence_expire_at_date_' + misc).val(), 'description': $('#text_input_' + misc).val()},
          (data) ->
            if data.code == 0
              $("#event-data-modal").modal("hide")
              $('i[event="' + misc + '"]').removeClass("icon-volume-up").addClass("icon-volume-off")
              updateEventTable()
            else
              alert(data)

      $(document).on 'click', '.unsilence-submit-event', ->
        misc = $(this).attr("misc")
        $.post $(this).attr("rel"),
          (data) ->
            if data
              $('td[rel="' + misc + '_popup_info"]').attr('data-content', "No")
              $('td[rel="' + misc + '_column_silenced"]').text("No")
              $('i[event="' + misc + '"]').removeClass("icon-volume-off").addClass("icon-volume-up")
            else
              alert("Failed to unsilence...")

      $(document).on 'click', 'a.delete-client', ->
        if (confirm('Are you sure?'))
          $.post "/clients/delete_client", { 'key': $(this).attr('key') },
            (data) ->
              if data
                $("td:contains('" + this.data.split("=")[1] + "')").parent().hide()
              else
                alert("Could not delete client")

      use_environments = $("#use_environments").attr("rel")
      if use_environments == "true"
        aocolumns = [{bVisible: false}, null, null, null, null, null, null, null, {bSortable: false}]
      else
        aocolumns = [{bVisible: false}, null, null, null, null, null, null, {bSortable: false}]

      dtable = $('#primary_events_table').dataTable
        bAutoWidth: false
        bJQueryUI: false
        bProcessing: false
        sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
        sWrapper: "dataTables_wrapper form-inline"
        bServerSide: false
        bSort: true
        aoColumns: aocolumns
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
