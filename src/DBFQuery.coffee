DBFParser = require("./DBFParser");

class DBFQuery
	constructor: (@from, @where, @orderby, @fields='*', @encoding='cp866', @callback) ->
		@records = []
		@dbfParser = new DBFParser(@from, @encoding)
		@dbfParser.on 'record', (record) =>
			check = true;
			if typeof(@where) == 'function'
				check &= @where(record)
			else if @where? and typeof(@where) == 'object'
				for _w_ in @where
					check &= switch _w_[1].toLowerCase()
						when '=' then  record[_w_[0]] == _w_[2]
						when '!=' then record[_w_[0]] != _w_[2]
						when '<' then record[_w_[0]] < _w_[2]
						when '<=' then record[_w_[0]] <= _w_[2]
						when '>' then record[_w_[0]] > _w_[2]
						when '>=' then record[_w_[0]] >= _w_[2]
						when 'like' then record[_w_[0]].toString().match(_w_[2]) != null
			if record['_deleted_'] == false and check
				if fields? and fields != '*'
					obj = {};
					obj[fieldName] = record[fieldName] for fieldName in fields
				else
					obj = record				
				@records.push(obj)
		
		@dbfParser.on 'end', () => 
			if @orderby? and typeof(@orderby) == 'object'
				DBFQuery.sort(@records, @orderby)
			else if typeof(@orderby) == 'function'
				@orderby(@records)
			@callback?(@records)
		
	selectSimple: () ->
		@records = []
		@dbfParser.parse()


DBFQuery.leftJoin = (arr1, field1, arr2, field2) ->
	if not arr1? or not arr2? or not field1 or not field2?
		return -1;
	cnt = 0;
	for rec1 in arr1
		for rec2 in arr2
			if rec1[field1] == rec2[field2]
				rec1[field1] = rec2
				cnt++
				break
		if typeof(rec1[field1]) != 'object'
			rec1[field1] = null
	return cnt

DBFQuery.sort = (arr, fields) ->
	arr.sort((x1, x2)->
		for field in fields
			a = x1[field].toString()
			b = x2[field].toString()
			if a < b
				return -1
			else if a > b
				return 1
		return 0
	)


module.exports = DBFQuery
