zeroPad = (n) ->
  if n < 10
    "0#{n}"
  else
    n.toString()

currentTimeString = ->
  now = new Date()
  ymdhms = now.getUTCFullYear().toString() + "-"
  ymdhms += zeroPad(now.getUTCMonth() + 1) + "-"
  ymdhms += zeroPad(now.getUTCDate()) + " "
  ymdhms += zeroPad(now.getUTCHours()) + ":"
  ymdhms += zeroPad(now.getUTCMinutes()) + ":"
  ymdhms += zeroPad(now.getUTCSeconds())
  
  ymdhms

$ ->
  $('[data-set-current-time]').click (e) ->
    e.preventDefault()
    input = $("input[name='#{$(@).data('set-current-time')}']")
    input.val(currentTimeString())