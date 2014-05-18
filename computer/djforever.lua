--[[ 

  DJ Forever
  by abznak
  Plays songs.  Forever.

  Usage:
    Build a computercraft computer.  Put a disk drive under it.
    Run: 
      pastebin get s2rKTuN7 djf
      djf

  (That's a script that downloads the latest version of this file every time you run it)


bugs - multiple timers can confuse it.  TODO: use timer ids
]]
 



print("dj forever running")
print("by @abznak")
print("q or ctrl to quit")
print("")


songs =  {
["C418 - 13"]     = 2*60 + 58,
["C418 - cat"]    = 3*60 + 05,
["C418 - blocks"] = 5*60 + 45,
["C418 - chirp"]  = 3*60 + 05,
["C418 - far"]    = 2*60 + 54,
["C418 - mall"]   = 3*60 + 17,
["C418 - mellohi"]= 1*60 + 36,
["C418 - stal"]   = 2*60 + 30,
["C418 - strad"]  = 3*60 + 08,
["C418 - ward"]   = 4*60 + 11,
["C418 - 11"]     = 1*60 + 11,
["C418 - wait"]   = 3*60 + 58,
}




i = 0
doquit = false
while (not redstone.getInput("back") and not doquit) do
  i = i + 1
  print("")
  print("track ", i)
  side = "bottom"
  track = disk.getLabel(side)
  if (track == nil) then
    print("no disk found at ", side)
  else
    length = songs[track]
    print("track: ", track)
    print("length: ", length)
    disk.playAudio("bottom")
    os.startTimer(length)
  end
  songdone = false
  while not songdone and not doquit do
    local event, param = os.pullEvent()
    print("event: ", event,' ', param)
--    if (event == 'char' and param == 'q') or (event == 'key' and param == 16) then
    if (event == 'char') or (event == 'key') then
      -- quit on any key to avoid timer madness
      print("")
      print("quitting")
      doquit = true
    end
    songdone = true
    --todo: calculate songdone based on time.  schedule another timer if it isn't done.
  end
end
disk.stopAudio(side)
print("done")



--[[

The MIT License (MIT)

Copyright (c) 2014 Timothy Adam Smith

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]
