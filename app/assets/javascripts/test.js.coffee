$ ->
  dtable = $('#test_table').dataTable
    bJQueryUI: true
    bProcessing: true
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sWrapper: "dataTables_wrapper form-inline"
    bServerSide: false
    sPaginationType: "bootstrap"
    iDisplayLength: 25
    sAjaxSource: $('#test_table').data('source')
  setInterval () ->
    $('#test_table').dataTable().fnReloadAjax()
  , 60000
