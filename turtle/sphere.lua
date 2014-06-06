-- build a giant sphere
-- by @abznak, MIT License



-- location of material to keep
keep_material_index = 1
eat_material_index = 2
plant_material_index = 3

tx = 0
ty = 0
tz = 0

cubesize = 2

mcubex = 3
mcubey = 3
mcubez = 3

-- locations before this are reserved
internal_storage_start = 4
internal_storage_stop = 16
 
-- internal vars
selected_slot = 0


print("Material to keep at slot " .. keep_material_index)
print("Material to eat at slot " .. eat_material_index)
print("Material to plant at slot " .. plant_material_index)
--read()

--[[
  pre - in bottom left back of cube
  post - in bottom left back of cube above
  places a block at a random point in the cube
]]
function rndInCube()
	dbg("rndInCube")
	local dx = math.random(cubesize)-1
	local dy = math.random(cubesize)-1
	local dz = math.random(cubesize)-1
	movex(dx)
	movey(dy)
	movez(dz)
	select_building_material()
	dbg("placed")
	turtle.placeDown()
	movex(-dx)
	movey(-dy)
	movez(cubesize-dz)
	dbg("/rndInCube")
end

function makeCubes()
	dbg('makeCubes')
	for x = 1, mcubex, 1 do
		for y = 1, mcubey, 1 do
			for z = 1, mcubez, 1 do
				rndInCube()
			end
			movey(cubesize)
			movez(-mcubez * cubesize)
		end
		movex(cubesize)
		movey(-mcubey * cubesize)
	end
	movex(-mcubez * cubesize)
end				
	
	




function movez(n)
	if n == 0 then
		return
	end
	absn = math.abs(n)
	unitn = n/absn
	for i = 1, math.abs(n), 1 do
		if (n < 0) then
			moved = turtle.down()
		else
			moved = turtle.up()
		end
		if not moved then
			dbg('obstruction')
		else
			tz = tz + unitn
		end
	end
end
function movey(n)
	if n == 0 then
		return
	end
	absn = math.abs(n)
	unitn = n/absn
	for i = 1, math.abs(n), 1 do
		if (n < 0) then
			moved = turtle.back()
		else
			moved = turtle.forward()
		end
		if not moved then
			dbg('obstruction')
		else
			ty = ty + unitn
		end
	end
end
function movex(n)
	if n == 0 then
		return
	end
	turtle.turnLeft()
	absn = math.abs(n)
	unitn = n/absn
	for i = 1, math.abs(n), 1 do
		if (n < 0) then
			moved = turtle.back()
		else
			moved = turtle.forward()
		end
		if not moved then
			dbg('obstruction')
		else
			tx = tx + unitn
		end
	end
	turtle.turnRight()
end
		
		
 
 
 
 
 
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
    ss = internal_storage_start
  end
	dbg(fnn, 'ss ' .. ss)
	dbg(fnn, 'iss ' .. internal_storage_stop)
  while (turtle.getItemCount(ss) == 0) and (ss < internal_storage_stop) do
    dbg(fnn, 'nothing at ' .. ss)
    ss = ss + 1
    select_slot(ss)
  end
  return turtle.getItemCount(ss) > 0
end

function init()
	select_slot(1)
end


   
--turtle.up()  --because everything happens one square down from the turtle
movey(20)

   
init()
makeCubes()
