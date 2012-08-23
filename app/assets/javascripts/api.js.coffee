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
