$ ->
  $(document).on 'click', '.delete-stash', ->
    self = $(this)
    $.ajax
      type: "POST"
      url: $(self).attr("rel")
      cache: false
      key: $(self).attr("key")
      data: {'key': $(self).attr("key")},
      success: (data) ->
        $("#delete_" + $(self).attr("index")).toggle()
        $("#deleted_" + $(self).attr("index")).toggle()
        $("#stash_" + $(self).attr("index")).toggle()
      error: (data) ->
        alert "Failed to perform action"
