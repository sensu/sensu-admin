# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.timepicker').timepicker({  'step': 15, 'showDuration': true, 'timeFormat': 'g:ia', 'scrollDefaultNow': true })
  $('.datepicker').datepicker({ 'autoclose': true, 'dateFormat': 'd/m/yy', 'format': 'dd/mm/yyyy' })
  $('.create-custom-stash-working').hide()
  $('.show-custom-stash-modal').click ->
    $('#custom_stash_modal').modal("show")
  $('.stash-submit-event').click ->
    self = $(this)
    $.post "/stashes/create_stash", { 'description': $('#custom_stash_description').val(), 'key': $('#custom_stash_key_input').val(), 'date': $('#custom_stash_date_input').val(), 'time': $('#custom_stash_time_input').val()},
      (data) ->
        if data
          $(self).hide()
          $('.create-custom-stash-working').show()
          location.reload()
        else
          alert("Stash creation failed")
  $('.delete-stash').click ->
    self = $(this)
    if (confirm('Are you sure?'))
      $.post $(this).attr("rel"), { 'key': $(self).attr("key")},
        (data) ->
          if data
            $($(self).attr("misc")).remove()
            $("#stash_count").html($(".table tbody tr").length)
          else
            alert("Stash deletion failed")
  $('#delete-all-stashes').click ->
    if (confirm('Are you sure?'))
      $('#delete-all-stashes-button').text("Working...")
      self = $(this)
      $.post $(this).attr("rel"),
        (data) ->
          if data
            $('#delete-all-stashes-button').text("Deleted!")
            $('tr').hide()
            $('h2').text("Stashes (0)")
          else
            alert("Stash deletion failed")
