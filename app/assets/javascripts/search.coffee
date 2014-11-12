jQuery ->
  $search  = jQuery(".search")
  $results = jQuery(".results")

  values = {}

  $search.on "keyup", ->
    values.new = $search.val()

    if values.new.length == 0
      $results.html("")

      values =
        new: ""
        old: ""

    if values.new.length > 0 && values.new != values.old
      values.old = values.new

      deferred = jQuery.get("/search/#{values.new}")

      deferred.done (res)->
        $results.html(res)
    
