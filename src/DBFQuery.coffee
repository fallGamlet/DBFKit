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
			@callback?(@records)
		
	selectSimple: () ->
		@records = []
		@dbfParser.parse()


module.exports = DBFQuery
