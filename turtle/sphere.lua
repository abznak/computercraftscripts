-- build a giant sphere
-- by @abznak, MIT License



-- location of material to keep
keep_material_index = 1
eat_material_index = 2
plant_material_index = 3

tx = 0
ty = 0
tz = 0

function movex(n)
	turtle.turnLeft()
	for i = 1, math.abs(n), 1 do
		if (n < 0) then
			moved = turtle.back()
		else
			moved = turtle.forward()
		end
		if not got then
			dbg('obstruction')
		else
			tx = tx + unitn
		end
	end
	turtle.turnRight()
end
		
		
 
 
print("Material to keep at slot " .. keep_material_index)
print("Material to eat at slot " .. eat_material_index)
print("Material to plant at slot " .. plant_material_index)
 
 
-- locations before this are reserved
internal_storage_start = 4
internal_storage_stop = 16
 
-- internal vars
selected_slot = 0
 
function dbg(src, msg)
  print (src, " ", tx, ",", ty, ",", tz, " ", msg)
end
 
-- drop stuff we don't want.  Eat if hungry.  
-- @return true iff we did something
function eat_and_junk()
	did_stuff = false
	while turtle.suck() do
		print "sucked"
	end
	for i = internal_storage_start, internal_storage_stop, 1 do
		select_slot(i)
		if (turtle.compareTo(eat_material_index)) then
			print("found food at " .. i)  
			turtle.refuel()
			print "fuel at " . turtle.getFuelLevel()
			did_stuff = true
		end
	end
	return did_stuff
end
 
function select_slot(ss)
  if turtle.select(ss) then
    selected_slot = ss
  end
end
 
function select_building_material()
  fnn = 'select_building_material'
  dbg(fnn, 'start')
  ss = selected_slot
  dbg(fnn, 'ss: ' .. ss)
  if ss < internal_storage_start or ss > internal_storage_stop then
    dbg(fnn, 'out of range')
    select_slot(internal_storage_start)
    ss = interal_storage_start
  end
  while (turtle.getItemCount(ss) == 0) and (ss < internal_storage_stop) do
    dbg(fnn, 'nothing at ' .. ss)
    ss = ss + 1
    select_slot(ss)
  end
  return turtle.getItemCount(ss) > 0
end
   
   

movex(3)
