jQuery ->
  $search  = jQuery(".search")
  $results = jQuery(".results")

  $search.on "keydown", ->
    q = $search.val()

    if q.length > 0
      deferred = jQuery.get("/search/#{q}")

      deferred.done (res)->
        $results.html(res)
    
