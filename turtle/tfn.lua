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
internal_storage_start = 4
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
   
   
   

function build_circle(r) 
	for y = -r, r, 1 do
		a = ''
  	for x = -r, r, 1 do
      local isin = y*y + x*x > r*r
			if isin then
				a = a + '#'
			else
				a = a + '.'
			end
		end
		print(a)
	end
end

--[[
function do_stuff()
	print ('selected slot', selected_slot)
	for j = 1, 10, 1 do
		print ("eat and junk" .. j)
		eat_and_junk()
	end
	 
	for j = 1, 15, 1 do
		turtle.back()
	end
	print ('selected slot', selected_slot)
	select_slot(internal_storage_start)
	random_walk(100000, 0.1, 10)
end

]]
build_circle(5)