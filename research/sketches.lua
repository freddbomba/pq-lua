#! /usr/bin/env lua
local lz = require "luazen"
require "struct"
local timestamp = math.random(10000)
local hash=lz.md5(timestamp)
print (hash)
local u16, u32 = struct.unpack('<I2I4', hash)
print u16, u32, hash
command = "screencapture -t png ~/Desktop/tmp/frame000"..hash..".png"
print(command)
--os.execute(command)
