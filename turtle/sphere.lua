-- build a giant sphere
-- by @abznak, MIT License
-- WORKING!



-- location of material to keep
keep_material_index = 1
eat_material_index = 2
plant_material_index = 3


cubesize = 1

mcubex = 7  --note, sphere fucntion assume these 3 are equal
mcubey = mcubex 
mcubez = mcubex

-- locations before this are reserved
internal_storage_start = 4
internal_storage_stop = 16
 
-- internal vars
selected_slot = 1


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
	local dz = math.random(cubesize)-1-1   --extra -1 so we can have a 2 high block


	if (not isIn(tx+dx,ty+dy,tz+dz)) then
		--our random point is not in, move to next cube
		movez(cubesize)
		return
	end	





	movex(dx)
	movey(dy)
	movez(dz)
	select_building_material()
	turtle.placeDown()
	dbg("placed")
	movez(1)
	select_material(plant_material_index)
	turtle.placeDown()
	movex(-dx)
	movey(-dy)
	movez(cubesize-dz-1) --extra -1 because of the movez(1)
	dbg("/rndInCube")
end

function isIn(x,y,z)
--sphere
	r = cubesize * mcubex / 2
	local nx = x - r
	local ny = y - r
	local nz = z - r
	dbg('isin', 'nx '.. nx.. ' ny '.. ny .. ' nz ' .. nz .. ' r ' .. r)
	return nx*nx+ny*ny+nz*nz <= r*r
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
	
	


function obstruction_check()
	if (turtle.getFuelLevel() == 0) then
		dbg('oc', 'out of fuel')
		--todo: wait for more fuel
		exit()
	else
		dbg('oc', "obstruction")
		exit() --not an actual function?  still, it works
	end
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
			obstruction_check()
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
			obstruction_check()
		else
			ty = ty + unitn
		end
	end
end
function movex(n)
	if n == 0 then
		return
	end
	turtle.turnRight()
	absn = math.abs(n)
	unitn = n/absn
	for i = 1, math.abs(n), 1 do
		if (n < 0) then
			moved = turtle.back()
		else
			moved = turtle.forward()
		end
		if not moved then
			obstruction_check()
		else
			tx = tx + unitn
		end
	end
	turtle.turnLeft()
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
			print("fuel at " .. turtle.getFuelLevel())
			did_stuff = true
		end
	end
	return did_stuff
end
 
function select_slot(ss)
  turtle.select(ss)
	selected_slot = ss
end
 
function select_building_material()
	select_material(keep_material_index)
end
--select material that is the same as the material at i
function select_material(mat_index)
  fnn = 'select_building_material'
  dbg(fnn, 'start')
  ss = selected_slot
  dbg(fnn, 'ss: ' .. ss)


	if (turtle.getItemCount(ss) > 0) and turtle.compareTo(mat_index) then
		dbg(fnn, 'already selected')
		return true
	end
	
	for ss = internal_storage_start, internal_storage_stop, 1 do
		dbg(fnn, 'testing ' .. ss .. ' against ' .. mat_index)
		if (turtle.getItemCount(ss) > 0) then
			select_slot(ss)
			if turtle.compareTo(mat_index) then
				dbg(fnn, 'found! ' .. ss)
				select_slot(ss)
				return true
			end
		end
	end
	dbg(fnn, "not found :(")
	exit()
	return false
			

--[[
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
]]
end

function init()
	tx = 0
	ty = 0
	tz = 0
	select_slot(1)
	eat_and_junk()
end



-- remember to double call iniit if you do any preliminary moving
--init()
--movez(-20)



--init()
--movey(6)



print ('in 3...')   
os.sleep(3)
turtle.up()  --because everything happens one square down from the turtle

init()
makeCubes()
