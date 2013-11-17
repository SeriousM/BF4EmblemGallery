Template.google_analytics.rendered = ->
  if !window.ga?
    ((params...) ->
      i = params[0]
      s = params[1]
      o = params[2]
      g = params[3]
      r = params[4]
      a = params[5]
      m = params[6]
      i["GoogleAnalyticsObject"] = r
      i[r] = i[r] or ->
        (i[r].q = i[r].q or []).push params
  
      i[r].l = 1 * new Date()
  
      a = s.createElement(o)
      m = s.getElementsByTagName(o)[0]
  
      a.async = 1
      a.src = g
      m.parentNode.insertBefore a, m
    ) window, document, "script", "//www.google-analytics.com/analytics.js", "ga"
    
    window.ga = ga
    
    try
      ga "create", "UA-37332361-2", "bf4emblems.net"
      ga "send", "pageview"
    catch Error