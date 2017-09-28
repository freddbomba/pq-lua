dofile("common.lua");

function init()

	CLIENTS			= 1
	CLIENT_WIDTH	= 2560
	CLIENT_HEIGHT	= 1080
	CLIENT_PADDING	= 0

	DISPLAY_WIDTH	= (CLIENT_WIDTH + 2*CLIENT_PADDING) * CLIENTS
	DISPLAY_HEIGHT	=  CLIENT_HEIGHT + 2*CLIENT_PADDING;

	-- CONFIG
	config = rConfig("epq.properties")

	master = main();
	ripe:addListener(master);
--	ripe:toggleBrake();
--	ripe:setFPSLimit(17);
	ripe:setScale(0.7);
	ripe:displayOpen("epq",DISPLAY_WIDTH,DISPLAY_HEIGHT,false);
	ripe:setClearColor(rColor(0,0,0,1.0))

end

class 'main' (rListener)

	function main:__init() super()
		trace("main:__init()")
	end

	function main:init()
		trace("main:init()")
		-- start scene main
--		self.scene = rSceneNetServer(CLIENT_WIDTH,CLIENT_HEIGHT,CLIENT_PADDING,CLIENTS,6666)
		self.scene = rScene(DISPLAY_WIDTH,DISPLAY_HEIGHT)
		ripe:addScene(self.scene)
		-- load logic
		dofile("logic.lua")
		self.logic = logic()
		self.logic:init(self.scene)
	end

	function main:draw()
		self.logic:draw()
	end

	function main:keyboard(key)
		self.logic:keyboard(key)
	end

	function main:mouse(button, state, x, y)
		self.logic:mouse(button,state,x,y);
	end

	function main:midi(timestamp,status,data1,data2)
		self.logic:midi(timestamp,status,data1,data2)
	end

	function main:network(type,id,msg)
		self.logic:network(type,id,msg)
	end

	function main:gui(target,event)
		self.logic:gui_event(target, event)
	end
