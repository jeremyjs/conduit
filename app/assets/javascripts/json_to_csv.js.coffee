json1 = { id: 1, UserName: Sam Smith }
json2 = [ { id: 1, UserName: "Sam Smith" }, { id: 2, UserName: "Fred Frankly" } ]
json3 = { "d": "[{\"Id\":1,\"UserName\":\"Sam Smith\"},{\"Id\":2,\"UserName\":\"Fred Frankly\"},{\"Id\":1,\"UserName\":\"Zachary Zupers\"}]" }

json_to_csv([json1])
json_to_csv(json2)
json_to_csv(JSON.stringify(json2))
json_to_csv(json3.d)

json_to_csv(objArray) ->
  if typeof objArray != 'object'
    array = JSON.parse(objArray)
  else
    array = objArray

  str = ''

  for obj in array
    line = ''

    for k, v in obj
      line += v + ','

    str += line[0...-1] + '\r\n'

  window.open( "data:text/csv;charset=utf-8," + escape(str))
