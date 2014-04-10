jQuery ->
  jQuery('.page-url-info-show .action a.delete').click (evt)->
    res = window.confirm "确定删除吗?"
    if res == true
      url_info_id = jQuery(this).data("urlinfoid")
      jQuery.ajax
        url: "/url_infos/#{url_info_id}/destroy"
        method: 'DELETE',
        statusCode:
          200: ()->
            window.location.href = "/"




