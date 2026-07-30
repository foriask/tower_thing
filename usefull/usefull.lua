function sum_table(_table1, _table2)
	local _finished_table = {}
	for _i, _value in ipairs(_table1) do
		table.insert(_finished_table, _value + _table2[_i])
	end
	return _finished_table
end
function lerp(_valueb, _valuea, _force)
	return (_valuea + ((_valueb - _valuea) * _force))
end
function mult_num_table(_num, _table)
	local _finished_table = {}
	for _i, _value in ipairs(_table) do
		table.insert(_finished_table, _value * _num)
	end
	return _finished_table
end

function distance_2d(_pos1, _pos2)
	local _distance = math.sqrt(math.abs(math.pow(_pos1[1] - _pos2[1], 2) + math.pow(_pos1[2] - _pos2[2], 2)))
	return _distance
end

function powdistance_2d(_pos1, _pos2)
	local _distance_raw = (((_pos1[1] - _pos2[1]) ^ 2) + ((_pos1[2] - _pos2[2]) ^ 2))
	return _distance_raw - _distance_raw % 1
end
