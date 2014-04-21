# javascript:void(function(d){window.USER_SECRET='d7304a2ceb3bab7cfcdb5152cff6f5a4';window.M4YE_SITE='//192.168.1.26:4000/js-plugins/';var l=function(u){var e=d.createElement('script');e.setAttribute('type','text/javascript');e.setAttribute('charset','UTF-8');e.setAttribute('src',u);d.body.appendChild(e)};l(window.M4YE_SITE+'web-url-collector.js?r='+Math.random())}(document));

USER_SECRET = window.USER_SECRET
M4YE_SITE = window.M4YE_SITE

COLLECT_URL = 'http://collect.4ye.me/collect_url'
CHECK_URL = 'http://collect.4ye.me/check_url'
USER_INFO_URL = 'http://4ye.mindpin.com/api/user_info'

init = (func)->
  if window.jQuery
    func()
  else
    script = document.createElement('script')
    script.setAttribute 'type', 'text/javascript'
    script.setAttribute 'charset', 'UTF-8'
    script.setAttribute 'src', '//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js'
    script.onload = ->
      jQuery.noConflict()
      func()
    document.body.appendChild script

init ->
  build = (klass)->
    jQuery("<div></div>").addClass klass

  class Collector
    constructor: ->
      @URL = document.URL

      @ANIMATE_DURATION = 100

      @STRING_INIT = '正在加载数据 …'
      @STRING_SAVING = '正在努力保存 …'
      @STRING_SUCCESS = '✔ 保存好了。'
      @STRING_FAILURE = '出错了！'
      @STRING_COLLECTED = '这个网页已经收集过了。'

      @$elm = build 'mindpin-web-url-collector'
        .css
          'font-family': 'helvetica, arial, 微软雅黑'
        .appendTo jQuery(document.body)

    b_current_url: ->
      @$current_url = build 'mwuc-url'
        .css
          'padding': 10
          'background-color': 'rgba(255, 255, 255, 0.7)'
          'border-bottom': 'dashed 1px #ddd'
          'font-size': '14px'
          'word-break': 'break-all'
          'text-align': 'left'
          'line-height': '16px'
          'box-sizing': 'content-box'
        .html "收集：" + @URL
        .appendTo @$form

    b_user_info: ->
      @$user_info = build 'mwuc-user-info'
        .css
          'padding': 10
          'background-color': 'rgba(255, 255, 255, 0.7)'
          'border-bottom': 'dashed 1px #ddd'
          'font-size': '14px'
          'word-break': 'break-all'
          'text-align': 'left'
          'height': '32px'
          'line-height': '32px'
          'box-sizing': 'content-box'
        .appendTo @$form
        .hide()
      
      @$user_avatar = jQuery "<img />"
        .addClass 'mwuc-user-avatar'
        # .attr 'src', 'http://4ye.mindpin.com/static_files/uploads/user/avatar/1001/normal_K1cXDwad.png'
        .css
          'width': '32px'
          'height': '32px'
          'border-radius': 32
          'display': 'block'
          'float': 'left'
        .appendTo @$user_info

      @$user_name = build 'mwuc-user-name'
        .css
          'height': 32
          'line-height': '32px'
          'float': 'left'
          'margin-left': 15
          'font-size': '16px'
        # .html '洋气书生'
        .appendTo @$user_info

      @$visit_site = jQuery "<a href='http://collect.4ye.me' target='_blank'></a>"
        .css
          'cssText': 'text-decoration:none !important;'
          'display': 'block'
          'height': 24
          'line-height': '24px'
          'float': 'right'
          'font-size': '14px'
          'background-color': '#777'
          'color': 'white'
          'border-radius': '3px'
          'padding': '0 10px'
          'margin-top': '5px'
          'cursor': 'pointer'
          'transition': 'all .1s ease-in'
        .html '去四叶书签'
        .appendTo @$user_info
        .mouseenter ->
          if !jQuery(this).hasClass('disabled')
            jQuery(this).css 
              'background-color': '#666'
              'text-decoration': 'none'
        .mouseleave ->
          jQuery(this).css 
            'background-color': '#777'

    b_loading: ->
      @$loading = build 'mwuc-loading'
        .css
          'height': 24
          'line-height': '24px'
          'font-size': '14px'
          'margin': '10px'
          'padding': 10
          'box-sizing': 'content-box'
        .appendTo @$form

      @$loading_icon = build 'mwuc-loading-icon'
        .css
          'height': 24
          'width': 24
          'background': "url(#{M4YE_SITE}ajax-loader.gif) no-repeat"
          'float': 'left'
          'margin-right': 10
        .appendTo @$loading

      @$loading_info = build 'mwuc-loading-info'
        .css
          'height': 24
          'line-height': '24px'
          'float': 'left'
        .html @STRING_SAVING
        .appendTo @$loading

    b_success_failure: ->
      @$success = build 'mwuc-success'
        .css
          'height': 24
          'line-height': '24px'
          'margin': '10px'
          'padding': '10px'
          'background-color': '#E0EFD6'
          'box-sizing': 'content-box'
          'color': '#007600'
          'border': 'dashed 1px rgba(0, 0, 0, 0.1)'
          'font-size': '14px'
        .appendTo @$form
        .hide()

      @$span_success = jQuery "<span></span>"
        .html @STRING_SUCCESS
        .appendTo @$success

      @$span_success_site_url = jQuery "<a target='_blank'>打开看看</a>"
        .css
          'color': '#007600'
          'text-decoration': 'underline'
        .appendTo @$success

      @$failure = build 'mwuc-failure'
        .css
          'height': 24
          'line-height': '24px'
          'margin': '10px'
          'padding': '10px'
          'background-color': '#EFD6D8'
          'box-sizing': 'content-box'
          'color': '#980000'
          'border': 'dashed 1px rgba(0, 0, 0, 0.1)'
          'font-size': '14px'
        .html @STRING_FAILURE
        .appendTo @$form
        .hide()

      @$collected = build 'mwuc-collected'
        .css
          'height': 24
          'line-height': '24px'
          'margin': '10px'
          'padding': '10px'
          'background-color': '#E0EFD6'
          'box-sizing': 'content-box'
          'color': '#007600'
          'border': 'dashed 1px rgba(0, 0, 0, 0.1)'
          'font-size': '14px'
        .appendTo @$form
        .hide()

      @$span_collected = jQuery "<span></span>"
        .html @STRING_COLLECTED
        .appendTo @$collected

      @$span_collected_site_url = jQuery "<a target='_blank'>打开看看</a>"
        .css
          'color': '#007600'
          'text-decoration': 'underline'
        .appendTo @$collected


    b_inputs: ->
      @$inputs = build 'mwuc-inputs'
        .appendTo @$form
        .hide()

      @$title_input = jQuery '<input />'
        .addClass 'mwuc-title'
        .attr 'name', 'mwuc-title'
        .attr 'placeholder', '网页标题'
        .css
          'cssText': 'color: #222 !important;'
          'border': 'solid 1px #BBBBBB'
          'box-shadow': '0 1px 2px rgba(0, 0, 0, 0.15)'
          'width': 320 - 20 - 14
          'height': 20
          'line-height': '20px'
          'margin': '10px 10px 5px'
          'padding': '4px 6px'
          'font-size': '14px'
          'font-family': 'helvetica, arial, 微软雅黑'
          'transition': 'none'
          'border-radius': 0
          'display': 'block'
          'box-sizing': 'content-box'
        .focus ->
          jQuery(this).css 'border-color', '#08c'
        .blur ->
          jQuery(this).css 'border-color', '#bbb'
        .val document.title
        .appendTo @$inputs

      @$desc_input = jQuery '<textarea />'
        .addClass 'mwuc-desc'
        .attr 'name', 'mwuc-desc'
        .attr 'placeholder', '写点什么呗 …'
        .css
          'cssText': 'color: #222 !important;'
          'border': 'solid 1px #BBBBBB'
          'box-shadow': '0 1px 2px rgba(0, 0, 0, 0.15)'
          'width': 320 - 20 - 14
          'height': 100
          'line-height': '20px'
          'margin': '0px 10px 5px'
          'padding': '4px 6px'
          'font-size': '14px'
          'font-family': 'helvetica, arial, 微软雅黑'
          'transition': 'none'
          'border-radius': 0
          'display': 'block'
          'resize': 'none'
          'box-sizing': 'content-box'
        .focus ->
          jQuery(this).css 'border-color', '#08c'
        .blur ->
          jQuery(this).css 'border-color', '#bbb'
        .appendTo @$inputs

      @$tags_input = jQuery '<input />'
        .addClass 'mwuc-tags'
        .attr 'name', 'mwuc-tags'
        .attr 'placeholder', 'TAGs'
        .css
          'cssText': 'color: #222 !important;'
          'border': 'solid 1px #BBBBBB'
          'box-shadow': '0 1px 2px rgba(0, 0, 0, 0.15)'
          'width': 320 - 20 - 14
          'height': 20
          'line-height': '20px'
          'margin': '0px 10px 5px'
          'padding': '4px 6px'
          'font-size': '14px'
          'font-family': 'helvetica, arial, 微软雅黑'
          'transition': 'none'
          'border-radius': 0
          'display': 'block'
          'box-sizing': 'content-box'
        .focus =>
          @$tags_input.css 'border-color', '#08c'
        .blur =>
          @$tags_input.css 'border-color', '#bbb'
        .appendTo @$inputs

    b_buttons: ->
      @$buttons = build 'mwuc-buttons'
        .css
          'height': 32
          'margin': 10
        .appendTo @$form

      @$submit = jQuery '<a></a>'
        .addClass 'mwuc-submit'
        .html '收集！到四叶书签'
        .css
          'float': 'left'
          'color': 'white'
          'text-align': 'center'
          'height': 32
          'line-height': '32px'
          'background-color': '#009800'
          'display': 'block'
          'width': 320 - 20 - 2 - 70 - 5
          'font-size': '14px'
          'font-weight': 'bold'
          'box-shadow': '0 1px 2px rgba(0, 0, 0, 0.15)'
          'cursor': 'pointer'
          'margin': '0 5px 0 0'
          'border': 'solid 1px rgba(0, 0, 0, 0.1)'
          'border-radius': 3
          'position': 'relative'
          'transition': 'all .1s ease-in'
          'text-shadow': '0 0 3px rgba(0, 0, 0, 0.5)'
          'box-sizing': 'content-box'
        .appendTo @$buttons
        .mouseenter ->
          if !jQuery(this).hasClass('disabled')
            jQuery(this).css 
              'background-color': '#00ab00'
              'text-decoration': 'none'
              # 'top': -2
        .mouseleave ->
          jQuery(this).css 
            'background-color': '#009800'
            # 'top': 0
        .click =>
          if !@$submit.hasClass('disabled')
            @do_collect()

      @$close = jQuery '<a></a>'
        .addClass 'mwuc-close'
        .html '关闭'
        .css
          'float': 'left'
          'color': 'rgba(255, 255, 255, 0.8)'
          'text-align': 'center'
          'height': 32
          'line-height': '32px'
          'background-color': '#333'
          'display': 'block'
          'width': 70 - 2
          'font-size': '14px'
          'font-weight': 'bold'
          'box-shadow': '0 1px 2px rgba(0, 0, 0, 0.15)'
          'cursor': 'pointer'
          'margin': '0'
          'border': 'solid 1px rgba(0, 0, 0, 0.1)'
          'border-radius': 3
          'position': 'relative'
          'transition': 'all .1s ease-in'
          'text-shadow': '0 0 3px rgba(0, 0, 0, 0.5)'
          'box-sizing': 'content-box'
        .appendTo @$buttons
        .mouseenter ->
          jQuery(this).css 
            'background-color': '#222'
            'color': 'white'
            'text-decoration': 'none'
            # 'top': -2
        .mouseleave ->
          jQuery(this).css 
            'background-color': '#333'
            'color': 'rgba(255, 255, 255, 0.8)'
            # 'top': 0
        .click ->
          Collector.close()

    submit_enabled: (flag)->
      if flag
        @$submit
          .removeClass 'disabled'
          .css 'opacity', 1
      else
        @$submit
          .addClass 'disabled'
          .css 'opacity', 0.4

    render: ->
      @$overlay = build 'mindpin-web-url-collector-overlay'
        .css
          'position': 'fixed'
          'top': 0
          'left': 0
          'right': 0
          'bottom': 0
          'background-color': 'rgba(0, 0, 0, 0.6)'
          'z-index': 100000001
        .hide()
        .fadeIn @ANIMATE_DURATION
        .appendTo @$elm

      @$form = build 'mindpin-web-url-collector-form'
        .css
          'position': 'fixed'
          'top': -300
          'right': 40
          'width': 320
          'background-color': '#f4f4f4'
          'box-shadow': '0 0 5px rgba(0, 0, 0, 0.5)'
          'z-index': 100000002
        .animate
          'top': 0
        , @ANIMATE_DURATION
        .appendTo @$elm

      @b_current_url()
      @b_user_info()
      @b_loading()
      @b_success_failure()

      @b_inputs()
      @b_buttons()

      @init_data()

    init_data: ->
      @$loading.hide()
      @submit_enabled(false)

      jQuery.ajax
        url: USER_INFO_URL
        type: 'GET'
        data:
          secret: USER_SECRET
        success: (res)=>
          console.log res
          @$user_avatar.attr 'src', res.avatar
          @$user_name.html res.name
          @$user_info.fadeIn @ANIMATE_DURATION

          @check_url()

    check_url: ->
      @$loading.show()
      @submit_enabled(false)

      jQuery.ajax
        url: CHECK_URL
        type: 'GET'
        data:
          secret: USER_SECRET
          url: @URL
        success: (res)=>
          console.log res
          @$loading.slideUp @ANIMATE_DURATION

          if res.collected
            @$collected.slideDown @ANIMATE_DURATION
            @$span_collected_site_url.attr 'href', res.data.site_url
          else
            @submit_enabled(true)
            @$inputs.slideDown @ANIMATE_DURATION

    do_collect: ->
      title = @$title_input.val()
      desc  = @$desc_input.val()
      tags  = @$tags_input.val()

      @submit_enabled(false)

      @$inputs.slideUp @ANIMATE_DURATION
      @$loading.slideDown @ANIMATE_DURATION, =>
        # setTimeout =>
        #   @$loading.slideUp @ANIMATE_DURATION
        #   @$success.slideDown @ANIMATE_DURATION
        # , 500

        jQuery.ajax
          url: COLLECT_URL
          type: 'POST'
          data:
            secret: USER_SECRET
            url: @URL
            title: title
            desc: desc
            tags: tags
          success: (res)=>
            @$loading.slideUp @ANIMATE_DURATION
            @$success.slideDown @ANIMATE_DURATION
            @$span_success_site_url.attr 'href', res.site_url
          error: (xhr)=>
            @$loading.slideUp @ANIMATE_DURATION
            @$failure.slideDown @ANIMATE_DURATION

    @close: ->
      jQuery('.mindpin-web-url-collector').fadeOut 100, ->
        jQuery('.mindpin-web-url-collector').remove()
      console.clear()


  if jQuery('.mindpin-web-url-collector').length > 0
    Collector.close()
  else
    new Collector().render()