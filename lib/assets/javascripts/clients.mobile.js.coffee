$ ->
  $(document).on 'click', '.delete-client', ->
    self = $(this)
    $.ajax
      type: "DELETE"
      url: $(self).attr("rel")
      cache: false
      data: {}
      success: (data) ->
        $("#client_delete_" + $(self).attr("index")).toggle()
        $("#client_deleted_" + $(self).attr("index")).toggle()
        $("#client_" + $(self).attr("index")).toggle()
      error: (data) ->
        alert "Failed to perform action"
