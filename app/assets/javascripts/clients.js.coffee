# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.subpopover').popover({'placement': 'bottom'})
  $('td.moreinfo').click ->
    $($(this).closest('tr').attr("rel")).modal("show")
  $('a.delete-client').click ->
    self = $(this)
    if (confirm('Are you sure?'))
      $.ajax $(this).attr("rel"),
        type: 'DELETE'
        success: (data) ->
          if data
            $("#client_row_" + $(self).attr('key')).hide()
          else
            alert("Could not delete client")

  dtable = $('#clients_table').dataTable
      bAutoWidth: false
      bSort: true
      aoColumns: [null, null, null, null, null, null, {bSortable: false}, {bSortable: false}]
      bPaginate: false
