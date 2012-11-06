# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  updateApiStatus = ()->
    $.ajax "/api/status",
      type: 'GET'
      error: (jqXHR, textStatus, errorThrown) ->
        $("#api_info_div").html("Failed to update API information!")
      success: (data, textStatus, jqXHR) ->
        $("#api_info_div").html(data['data'])
  updateApiStatus()
  if $('#sensu_api_setup').length > 0
    $(document).on 'click', '#test_api_server', ->
      $.post "/api/test_api", { 'url': $("#setting_value").val()},
        (data) ->
          if data
            if data['data']['status'] == 'ok'
              $('#test_api_status').text("API Success! " + data['data']['message'] + " -- Please click Save Setting now to save your changes")
              $('#save_api_server').show()
              $('#test_api_server').hide()
              $('.alert').hide()
            else
              $('#test_api_status').text("API Failed! " + JSON.stringify(data['data']['message']))
          else
            $('#test_api_status').text("Failed to contact API -- Possible app error")
