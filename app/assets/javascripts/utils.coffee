@sum = (iterable, operation = false) ->
  return 0 unless iterable
  sum = 0
  if operation
    iterable.each( ->
      sum += $(this)[operation]()
    )
  else
    iterable.each( ->
      sum += $(this)
    )
  sum
