exports.isArray = isArray = (item) ->
  Object.prototype.toString.call(item) == '[object Array]'

exports.isObject = (item) ->
  typeof item == 'object' && `item !== null`

exports.cloneObject = (obj) ->
  result = {}
  for key of obj
    result[key] = obj[key]
  result

exports.pairListDict = (keyValuePairs...) ->
  if keyValuePairs.length==1
    keyValuePairs = keyValuePairs[0]

  len = keyValuePairs.length; i = 0; result = {}
  while i<len
    result[keyValuePairs[i]] = keyValuePairs[i+1]
    i += 2
  result

dupStr = (str, n) ->
  s = ''
  i = 0
  while i++<n then s += str
  s

exports.newLine = (str, indent, addNewLine) ->
  if addNewLine then '\n' + dupStr(' ', indent) + str
  else str

exports.funcString = (fn) ->
  if typeof fn != 'function'
    if !fn? then return 'null'
    if fn.getBaseComponent then return fn.toString()
    else
      try return JSON.stringify(fn)
      catch e then return fn.toString()
  s = fn.toString()
  if fn.invalidate then return s
  if s.slice(0, 12)=="function (){" then s = s.slice(12, s.length-1)
  else if s.slice(0, 13)=="function () {" then s = s.slice(13, s.length-1)
  else s = s.slice(9)
  s = s.trim()
  if s.slice(0, 7)=='return ' then s = s.slice(7)
  if s[s.length-1]==';' then s = s.slice(0, s.length-1)
  'fn:'+s

globalDcid = 1

exports.newDcid = -> globalDcid++

exports.isEven = (n) ->
  if n<0 then n = -n
  while n>0 then n -= 2
  n==0

exports.matchCurvedString = (str, i) ->
  if str[i]!='(' then return
  level = 0
  while ch = str[++i]
    if ch=='\\'
      if !(ch=str[++i]) then return
    else if ch=='(' then level++
    else if ch==')'
      if level==0 then return ++i
      else level--

exports.intersect = (maps) ->
  result = {}
  m = maps[0]
  for key of m
    isMember = true
    for m2 in maps[1...]
      if !m2[key]
        isMember = false
        break
    isMember && result[key] = m[key]
  result

exports.substractSet = (whole, unit) ->
  for key of unit then delete whole[key]
  whole

exports.binarySearch = (item, items) ->
  length = items.length
  if !length then return 0
  if length==1
    if items[0]>=item then return 0
    else return 1
  start = 0; end = length-1
  while 1
    index = start+Math.floor((end-start)/2)
    if start==end
      if items[index]>=item then return index
      else return index+1
    else if item==items[index] then return index
    if item==items[index+1] then return index+1
    else if item<items[index] then end = index
    else if item>items[index+1] then start = index+1
    else return index+1

exports.binaryInsert = (item, items) ->
  length = items.length
  if !length then items[0] = item; return 0
  if length==1
    if items[0]==item then return 0
    else if items[0]>item then items[1] = items[0]; items[0] = item; return 0
    else items[1] = item; return 1
  start = 0; end = length-1
  while 1
    index = start+Math.floor((end-start)/2)
    if start==end
      if items[index]==item then return index
      else if items[index]>item then items.splice(index, 0, item); return index
      else items.splice(index+1, 0, item); return index+1
    else if item==items[index] then return index
    if item==items[index+1] then return index+1
    else if item<items[index] then end = index
    else if item>items[index+1] then start = index+1
    else items.splice(index+1, 0, item); return index+1

exports.foreach = (items, callback) ->
  if !items
    return

  if isArray(items)
    result = []
    for item, i in items
      result.push(callback(item, i))
  else
    result = {}
    for key, item of items
      result[key] = callback(item, key)

  result

hasOwn = Object.hasOwnProperty

exports.mixin = (proto, mix) ->
  for key, value of mix
    if hasOwn.call(proto, key)
      continue
    else
      proto[key] = value

  proto

exports.makeReactMap = (description) ->
  result = {}
  items = description.split(/\s*,\s*/)
  for item in items
    pair = item.trim().split(/\s*:\s*/)
    if pair.length == 1
      result[pair[0]] = ''
    else
      reactField = pair[1]
      for field in pair[0].split(/\s+/)
        result[field] = reactField
  result