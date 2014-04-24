jQuery ->
  jQuery('.page-url-info-show .actions a.delete').click (evt)->
    res = window.confirm "确定删除这个网址吗?"
    if res == true
      url_info_id = jQuery(this).data("urlinfoid")
      jQuery.ajax
        url: "/url_infos/#{url_info_id}"
        method: 'DELETE',
        statusCode:
          200: ()->
            window.location.href = "/"



class SignInForm
  constructor: (@$form)->
    @$submit = @$form.find 'a.btn.submit'

  init: ->
    @$submit.click =>
      @$form.submit()

    @$form
      .find 'input.password'
      .keypress (evt)=>
        if evt.which == 13
          evt.preventDefault()
          @$form.submit()

jQuery ->
  if jQuery('.page-sign-in').length > 0
    form = new SignInForm jQuery('.page-sign-in form')
    form.init()
