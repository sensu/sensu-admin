$ ->
  $(document).on 'click', '.resolve-submit', ->
    self = $(this)
    $.ajax
      type: "POST"
      url: $(this).attr("rel")
      cache: false
      success: (data) ->
        $("[rel=\"silence_" + $(self).attr("control") + "\"]").hide()
        $("[rel=\"unsilence_" + $(self).attr("control") + "\"]").hide()
        $("[control=\"resolve_" + $(self).attr("control") + "\"]").hide()
        $("[control=\"resolved_" + $(self).attr("control") + "\"]").show()
        $("#" + $(self).attr("type")).toggle()
      error: (data) ->
        alert "Failed to perform action"
  $(document).on 'click', '.silence-submit', ->
    self = $(this)
    if $(self).attr("description")
      description = $("#" + $(self).attr("description") + "_description").val()
      if description.length == 0
        description = "No reason given"
    else
      description = ""
    if $(self).attr("silence_type")
      silence_type = $(self).attr("silence_type")
    else
      silence_type = ""
    $.ajax
      type: "POST"
      url: $(this).attr("rel")
      cache: false
      data: { description: description }
      success: (data) ->
        $("[rel=\"silence_" + $(self).attr("control") + "\"]").toggle()
        $("[rel=\"unsilence_" + $(self).attr("control") + "\"]").toggle()
        $("[rel=\"silence_details_" + $(self).attr("control") + "\"]").text silence_type + description
      error: (data) ->
        alert "Failed to perform action"
