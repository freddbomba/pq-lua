
function trace(msg) 
	log:info(tostring(msg))
end

function clear()
	console:clear()
end

function exit()
	ripe:exit(0)
end

function string:split( inSplitPattern, outResults )
  if not outResults then
	outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
	table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
	theStart = theSplitEnd + 1
	theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

function sortedpairs(t,comparator)
	local sortedKeys = {};
	table.foreach(t, function(k,v) table.insert(sortedKeys,k) end);
	table.sort(sortedKeys,comparator);
	local i = 0;
	local function _f(_s,_v)
		i = i + 1;
		local k = sortedKeys[i];
		if (k) then
			return k,t[k];
		end
	end
	return _f,nil,nil;
end

function tsToString(ts) 
	
	if( ts < 0 ) then ts = 0 end
	
	local sec = math.floor(ts / 1000)
	local min = math.floor(sec / 60)
	sec = sec - ( min * 60 )
	local hou = math.floor(min / 60)
	min = min - ( hou * 60)
	
	if( sec < 10 ) then sec = "0" .. sec end
	if( min < 10 ) then min = "0" .. min end
	if( hou < 10 ) then hou = "0" .. hou end
	
	return (hou .. ":" .. min .. ":" .. sec)

end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


--

log		= rLog.get()
ripe	= rMaster.get()
console = rConsole.get()
tm		= rTextureManager.get()
--mm		= rMidiManager.get()

--log:setLevel(rLog.LEVEL_DEBUG)

math.randomseed(os.time())
for i=1,10 do math.random() end