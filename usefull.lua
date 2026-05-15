function sum_table(_table1, _table2)
	local _finished_table = {}
	for _i, _value in ipairs(_table1) do
		table.insert(_finished_table, _value + _table2[_i])
	end
	return _finished_table
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
function collision_raycast(_point, _line, _group)
	-- This wont be working for more than one second. Anyways, there you go.
	for _i, _obj in pairs(_group) do
		if (math.abs(_line[1]) + math.abs(_line[2])) == 0 then
			return false
		end
		if _obj.collider.type == "c" then
			-- _cuts is a value taht cuts the line into point to study. This works for almost all possible velocities and is pretty simple.
			local _check_point = _point
			-- Mult x the cuts. Just get a bunch of point
			if not (distance_2d(_check_point, _obj.position) <= _obj.collider.radius) then
				return
			end

			return true, _check_point, _obj
		end
		-- Circles are simple. collider.radius is necesary though. This just checks it the lazy way, point - circle. This is just fine for most of uses. Also scales with the speed/fps ratio to avoid problems.
		if _obj.collider.type == "s" then
			local _check_point = _point
			local _horizon_check_1 = ((_check_point[1] < _obj.collider[3]) and (_check_point[1] > _obj.collider[1]))
			if not _horizon_check_1 then
				return false
			end
			local _vertical_check_1 = ((_check_point[2] < _obj.collider[4]) and (_check_point[2] > _obj.collider[2]))
			if not _vertical_check_1 then
				return
			end
			return true, _point, _obj
			-- VIVO BIEN...  ME RINDO. LOD pero más difícil¿?
		end
	end
end
