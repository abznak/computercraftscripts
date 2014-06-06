-- Turtle Functions
-- currently refuel, then random walk while laying blocks.
-- by @abznak, MIT License



-- location of material to keep
keep_material_index = 1
eat_material_index = 2
 
 
print("Material to keep at slot " .. keep_material_index)
print("Material to eat at slot " .. eat_material_index)
print("Input ender chest in front, output ender chest above.")
print("")
 
 
-- locations before this are reserved
internal_storage_start = 3
internal_storage_stop = 16
 
target_fuel_level = 25000
 
 
 
-- internal vars
selected_slot = 0
 
function dbg(src, msg)
  print (src, " ", msg)
end
 
-- drop stuff we don't want.  Eat if hungry.  
-- @return true iff we did something
function eat_and_junk()
	did_stuff = false
	while turtle.suck() do
		print "sucked"
	end
	for i = internal_storage_start, internal_storage_stop, 1 do
	 
		print ("location ", i)
		select_slot(i)
		if (turtle.compareTo(eat_material_index)) then
			print("found food at " .. i)  
			if turtle.getFuelLevel() < target_fuel_level then
				print "eating it"
				turtle.refuel()
				did_stuff = true
			end
		end
		if (not turtle.compareTo(keep_material_index)) then
			print("unwanted item at " .. i)
			turtle.dropUp()
			did_stuff = true
		end
	end
	return did_stuff
end
 
function random_walk(max_distance, turn_prob, max_anger)
  anger = 0
  for i = 1, max_distance, 1 do
    trouble = false
    r = turtle.back()
    if not r then
      trouble = true
      anger = anger + 1
    else
      r = select_building_material()
      if not r then
        return
      end
      turtle.place()
    end
    if math.random() < turn_prob then
      if math.random() > .5 then
        turtle.turnLeft()
      else
        turtle.turnRight()
      end
    end
    if anger > max_anger then
      anger = 0
      r = turtle.up()
      select_building_material()
      turtle.placeDown()
      if (not r) then
        return
      end
    end
  end
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
   
   
-- build a flat circle.
-- no error checking, because the fails will be art
function build_diamond(r, isplace) 
	for y = -1, -r, -1 do
		turtle.back()
	end
	turtle.turnLeft()
	for y = -1, -r, -1 do
		turtle.back()
	end
	turtle.turnRight()


	for y = -r, r, 1 do
		a = ''
  	for x = -r, r, 1 do     
			-- diamond: local isin = math.abs(y) + math.abs(x) <= r
			local isin = true
			if isin then
				a = a .. '#'
			else
				a = a .. '.'
			end

			if isin then
				if isplace then
					select_building_material()
					turtle.placeUp()
				else
					turtle.digUp()  --Note UP!
				end
			end
			turtle.forward()
		end


		-- wasteful, but easy to code
  	for x = -r, r, 1 do
			turtle.back()
		end

		turtle.turnLeft()
		turtle.forward()
		turtle.turnRight()

		print(a)
	end


  -- possibly off by one
	turtle.turnLeft()
	for y = -r, r, 1 do
		turtle.back()
	end
	turtle.turnRight()

	--SO inefficient.  easy to code though
	for y = 1, r, 1 do
		turtle.forward()
	end
	turtle.turnLeft()
	for y = 1, r, 1 do
		turtle.forward()
	end
		
end
   
-- build a flat circle.
-- no error checking, because the fails will be art
function build_circle(r) 
	for y = -r, r, 1 do
		a = ''
  	for x = -r, r, 1 do     
			local isin = y*y + x*x <= math.pow(r+0.5,2) --- adding .5 gives nicer circles
			if isin then
				a = a .. '#'
			else
				a = a .. '.'
			end
			if isin then
				select_building_material()
				turtle.placeDown()
			end
			turtle.forward()
		end


		-- wasteful, but easy to code
  	for x = -r, r, 1 do
			turtle.back()
		end

		turtle.turnLeft()
		turtle.forward()
		turtle.turnRight()

		print(a)
	end


  -- possibly off by one
	turtle.turnLeft()
	for y = -r, r, 1 do
		turtle.back()
	end
	turtle.turnRight()
		
end

function init()
	print ('selected slot', selected_slot)
	for j = 1, 3, 1 do
		print ("eat and junk" .. j)
		if not eat_and_junk() then
			print "done eating"
			break
		end
	end
	 
--[[
	for j = 1, 3, 1 do
		turtle.back()
	end
	turtle.turnLeft()
	turtle.turnLeft()
]]

	print ('selected slot', selected_slot)
	select_slot(internal_storage_start)
--	random_walk(100000, 0.1, 10)
end

--turtle.up()
--turtle.up()
--turtle.up()


function build_circle_stack()
--[[ big island 
	stack_size = 3
	r_start = 3
	r_step = 3
]]
	stack_size = 2
	r_start = 6
	r_step = 4

	r_stop = (stack_size-1) * r_step + r_start
	for r = r_start, r_stop, r_step do
		build_circle(r)
		
		-- move to keep turtle centered.  Assumes r_step is positive
		for j = 1, r_step, 1 do
			turtle.back()
		end
		turtle.turnLeft()
		for j = 1, r_step, 1 do
			turtle.back()
		end
		turtle.turnRight()
		turtle.up()
		
		print(r)
	end
end


--for j = 1, 3, 1 do
--	turtle.back()
--end



init()
--[[ ground launch script
turtle.turnLeft()
turtle.turnLeft()
turtle.forward()
for k = 1, 10, 1 do
	turtle.up()
end
for k = 1, 30, 1 do
	turtle.forward()
end
]]
--[[turtle.turnRight()
for k = 1, 15, 1 do
	turtle.forward()
end
turtle.turnLeft()
--for k = 1, 15, 1 do
--	turtle.forward()
--end
for k = 1, 5, 1 do
	turtle.down()
end
]]

--[[turtle.forward()

turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
turtle.down()
]]

--[[turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.back()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
]]

for r = 0, 2, 1 do
	build_diamond(r, true)
	turtle.down()
end
turtle.up()


os.sleep(20)

for r = 2, 0, -1 do
	turtle.up()
	build_diamond(r, false)
end

turtle.down()
turtle.down()
turtle.down()
turtle.forward()
turtle.forward()
turtle.forward()
turtle.forward()
turtle.forward()
turtle.forward()
turtle.forward()


--[[turtle.up()
build_diamond(1)
build_diamond(4)
]]
--build_circle_stack()
