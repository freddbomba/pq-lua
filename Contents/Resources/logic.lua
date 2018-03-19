


class 'logic'

	function logic:__init()
		trace("logic:__init()")
	end

	---------------------------------------
	function logic:init(scene)
		trace("logic:init()")

		-- global RNG
		-- to be changed with deterministic random file logic
		dofile("rng.lua")

		F_RNG = rng()


		dofile("flock.lua")
		dofile("flockScene.lua")


			-- GUI --

		self.gui_visible = false

		gui = rGui.get()
--		win1 = rGuiWindowScene("test",scene)
		win1 = rGuiWindow("epq // ")
		win1:setSize(300,517)
		win1:setPos(690,14)
		gui:add(win1)


		check1 = rGuiCheck("Show output")
		check1:setState(true)
		check1:setPos(10,10)
		win1:add(check1)

		check2 = rGuiCheck("Render to canvas")
		check2:setState(true)
		check2:setPos(10,30)
		win1:add(check2)

		check3 = rGuiCheck("Show flock")
		check3:setState(true)
		check3:setPos(10,50)
		win1:add(check3)

		-- GFX --

		self.scene		= scene
		self.scene.buffered = true
--		self.scene.visible = false




		self.image_path = config:getString("image_path","./")

		-- layers
		self.layers_files	= config:getInt("layers_files",23)
		self.layers 	 	= {}
		self.layers_ts  	= rSystem.getTime()
		self.layers_wt  	= F_RNG:rand(1* 60 * 1000, 4 * 60 * 1000)
		self.layers_count 	= 0

		-- flocks
		self.flocks  	= {}
		self.flocks[1] 	= flock({})

		self.flock_scene = flockScene(DISPLAY_WIDTH,DISPLAY_HEIGHT,self.flocks[1])
		--comment out for boids disappearence at startup
	    -- ripe:addScene(self.flock_scene)

		self.first = true
		self:changeImage()

		-- apply configuration to
		-- all elements
		self:loadConfig()

		-- modulation curve
		self.f_curve = rCurveLinear()
		self:changeCurve()

		-- canvas
		self.canvas = rSpriteImageOffscreen( tm:createTexture("canvas", ripe:displayW(), ripe:displayH(), 4) );
 		self.canvas:setClearColor(rColor(0,0,0,0))
		self.canvas_wt = F_RNG:rand(12 * 60 * 1000, 25 * 60 * 1000)
		self.canvas_ts = rSystem.getTime()
		self.canvas_count = 0

		self.ts_running = rSystem.getTime()

	end

	---------------------------------------
	function logic:draw()

		---------------------------------------
		-- canvas
		---------------------------------------
		local delta = rSystem.getTime() - self.canvas_ts
		if( delta > self.canvas_wt ) then

			-- clear canvas
			self.canvas:clear()
			self.canvas_wt = F_RNG:rand( 12 * 60 * 1000 , 25 * 60 * 1000 )
			self.canvas_ts = rSystem.getTime()

			-- change layers
			self:changeImage()
			self.layers_wt  = F_RNG:rand( 1 * 60 * 1000 , 4 * 60 * 1000 )
			self.layers_ts  = rSystem.getTime()

			-- change curve
			self:changeCurve()

			self.canvas_count = self.canvas_count + 1

		end

		---------------------------------------
		-- layers
		---------------------------------------
		delta = rSystem.getTime() - self.layers_ts
		if( delta > self.layers_wt ) then
			self:changeImage()
			self.layers_wt  = F_RNG:rand( 1 * 60 * 1000 , 4 * 60 * 1000 )
			self.layers_ts  = rSystem.getTime()
		end

		---------------------------------------
		-- flock
		---------------------------------------
		self.flocks[1]:update()

		-- set visibility
		local t = (	rSystem.getTime() - self.canvas_ts ) / self.canvas_wt
		self.flocks[1].limit_visibility = (150 - 25.0 * (self.f_curve:evaluate(t)/120))


--		self.canvas:beginOffscreen()
--		self.scene:draw()
--		self.canvas:endOffscreen()
--		self.canvas:draw()

--		self.flocks[1]:draw()

--		self.flock_scene:draw()

	end

	---------------------------------------
	function logic:changeCurve()
		self.f_curve:clear()

		local t = {}
		for i=1,40 do
			t[i] = math.random(10,790)
		end
		table.sort(t)

		self.f_curve:addPoint(0,120)
		for i=1,40 do
			self.f_curve:addPoint(t[i],math.random(-120,120))
		end
		self.f_curve:addPoint(800,120)
	end

	---------------------------------------
	function logic:changeImage()
-- trace function call below (fredd)
		trace("change_image")

		local i,l,k,j

		-- shuffle flock layers/brushes
		self.flocks[1]:shuffleBL()

		self.layers_count = self.layers_count + 1
		local j_last = 0

		for k=1,2 do
			if( self.first) then
				self.layers[k] = {}
			end

			-- pick a strip

			local j = F_RNG:rand(1,self.layers_files)
			while ( j == j_last) do
				j = F_RNG:rand(1,self.layers_files)
			end
			j_last = j

				if( not self.first ) then
					self.scene:remove(self.layers[k][1])
					self.layers[k][1]:unMaskAll()
				end
				self.layers[k][1] = rSpriteImage(tm:loadTexture(self.image_path .. "img_" .. j .. ".png"))

				self.layers[k][1]:setX( ripe:displayW() * 0.5 )
				self.layers[k][1]:setY( ripe:displayH() * 0.5 )
--				self.layers[k][i]:mask(self.dummy)

				for l=1,#self.flocks[1].boids do
					if(self.flocks[1].boids[l].layer == k)then
						self.layers[k][1]:mask(self.flocks[1].boids[l].s)
					end
				end
				self.scene:add(self.layers[k][1])


		end
		self.first = false


--		trace("change_image_end")

	end

	---------------------------------------
	function logic:loadConfig()
	config:load("epq.properties")

		self.canvas_save = config:getBool("canvas_save",true)

		self.flocks[1].factor_center = config:getDouble("factor_center",1.0)
		self.flocks[1].factor_collision = config:getDouble("factor_collision",1.0)
		self.flocks[1].factor_velocity = config:getDouble("factor_velocity",1.0)
		self.flocks[1].factor_target = config:getDouble("factor_target",0.0)
		self.flocks[1].limit_collision = config:getDouble("limit_collision",15.0)
		self.flocks[1].limit_velocity = config:getDouble("limit_velocity",80.0)
		self.flocks[1].limit_visibility = config:getDouble("limit_visibility",60.0)
		self.flocks[1].factor_wander = config:getDouble("factor_wander",0.0)

--		self.flocks[1].halo_collision:setR( self.flocks[1].limit_collision )
--		self.flocks[1].halo_visibility:setR( self.flocks[1].limit_visibility )

	end

	---------------------------------------
	function logic:saveConfig()
		config:setDouble("factor_center",self.flocks[1].factor_center)
		config:setDouble("factor_collision",self.flocks[1].factor_collision)
		config:setDouble("factor_velocity",self.flocks[1].factor_velocity)
		config:setDouble("factor_target",self.flocks[1].factor_target)
		config:setDouble("limit_collision",self.flocks[1].limit_collision)
		config:setDouble("limit_velocity",self.flocks[1].limit_velocity)
		config:setDouble("limit_visibility",self.flocks[1].limit_visibility)
		config:setDouble("factor_wander",self.flocks[1].factor_wander)
--		config:save()
	end

	---------------------------------------
	function logic:keyboard(key)

		-- tab
		if key == 9 then
			if( self.gui_visible ) then
				self.gui_visible = false
				gui:setVisible(false)

--				self.scene.active = true
				self.scene.x = 0
				self.scene.y = 0
				self.scene.scale = 1.0

				self.flock_scene.x = 0
				self.flock_scene.y = 0
				self.flock_scene.scale = 1.0

			else
				self.gui_visible = true
				gui:setVisible(true)

--				self.scene.active = false
				self.scene.x = 20
				self.scene.y = 20
				self.scene.scale = 0.65

				self.flock_scene.x = 20
				self.flock_scene.y = 20
				self.flock_scene.scale = 0.65


			end

			return
		end


		if key <= 128 then
			key = string.char(key)
		end

		if(key == "c") then
			self:changeCurve()
		end

		if(key == "b") then
			self.canvas_ts = 0
		end

		if(key == "r") then
			self.layers_ts = 0
		end

-- adding printing (fredd)
		if(key == "p") then
			timestamp = math.random()
			command = "screencapture -t png ~/Desktop/tmp/frame000"..timestamp..".png"
			os.execute(command)
 			-- os.execute('lpr pdfshot.pdf')
		end

	end

	---------------------------------------
	function logic:mouse(button, state, x, y)
		self.flocks[1].target:setPos(x,y)
	end

	---------------------------------------
	function logic:network(type,id,msg)
	end

	---------------------------------------
	function logic:midi(timestamp,status,data1,data2)
	end

	function logic:gui_event(target,event)
		if(target:getID() == check1:getID()) then
			self.scene.visible = check1:getState()

		elseif(target:getID() == check2:getID()) then
			self.scene.buffered = check2:getState()

		elseif(target:getID() == check3:getID()) then
			self.flock_scene.visible = check3:getState()
		end
	end
