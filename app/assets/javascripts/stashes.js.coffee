# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.delete-stash').click ->
    self = $(this);
    $.post $(this).attr("rel"), { 'key': $(self).attr("key")},
      (data) ->
        if data
          $($(self).attr("misc")).hide();
        else
          alert("Stash deletion failed");
  $('#delete-all-stashes').click ->
    self = $(this);
    $.post $(this).attr("rel"),
      (data) ->
        if data
          $('#delete-all-stashes-button').text("Deleted!");
          $('tr').hide();
        else
          alert("Stash deletion failed");
