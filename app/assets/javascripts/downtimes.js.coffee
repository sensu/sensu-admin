# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#downtime_clients_table').tableFilter({ additionalFilterTriggers: [$('#downtime_client_search')]})
  $('#downtime_checks_table').tableFilter({ additionalFilterTriggers: [$('#downtime_check_search')]})
  $('.filters').hide()
  $('#select_all_clients').change ->
    $('tr[rel="downtime_client_table_row"][filtermatch!="false"]').find('input[type="checkbox"]').attr("checked", $(this).is(":checked"))
  $('#select_all_checks').change ->
    $('tr[rel="downtime_check_table_row"][filtermatch!="false"]').find('input[type="checkbox"]').attr("checked", $(this).is(":checked"))
  $('.toggle_box').click ->
    $(this).siblings('.check_box').find('input').trigger("click")
  updateServerTime = ()->
    $.ajax "/api/time",
      type: 'GET'
      error: (jqXHR, textStatus, errorThrown) ->
        $("#api_time_div").html("Failed to update server time.")
      success: (data, textStatus, jqXHR) ->
        $("#api_time_div").html(data['data'])
  updateServerTime()
  setInterval () ->
    updateServerTime()
  , 60000
