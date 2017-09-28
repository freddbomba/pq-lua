dofile("boid.lua")

class 'flock'

	function flock:__init(people) 
	
		self.state = ""
		self.people = people
		self.ppl = {}
				
		self.osc_socket = rOSCSocketOut(
			config:getString("osc_address","10.0.0.255"),
			config:getInt("osc_port",9999)
		)
		self.osc_msg = rOSCMessageOut()
				
		self.factor_center 		= 1.0
		self.factor_collision 	= 1.0
		self.factor_velocity 	= 1.0
		self.factor_target 		= 0.0
		self.factor_wander		= 1.0
		self.limit_collision 	= 15.0
		self.limit_velocity 	= 80.0
		self.limit_visibility 	= 60.0
				
		self.center		  = rVec2(0,0)
		self.center_red   = rVec2(0,0)
		self.center_green = rVec2(0,0)
		self.center_blue  = rVec2(0,0)

		self.dv_center = rVec2(0,0)

		self.boids_num = 0
		self.boids = {}
		
		for i=1,24 do
			self:addBoid()
		end
		
		self.target = rSpriteRect(15,15,rColor(1,1,0))
		self.target:setPos(ripe:displayW()/2,ripe:displayH()/2)
		
	end

	function flock:addBoid() 
		local pos = rVec2(math.random(ripe:displayW()),math.random(ripe:displayH()))
		local vel = rVec2(math.random(-ripe:displayW(),ripe:displayW()),math.random(-ripe:displayH(),ripe:displayH()))
		self.boids_num = self.boids_num + 1
		self.boids[self.boids_num] = boid(self.boids_num,pos,vel)	
	end


	function flock:shuffleBL()
--		trace("shuffleBL")
		local i
		for i = 1,self.boids_num do
			local b = self.boids[i]
			b.s = rSpriteImage(tm:loadTexture("b0" .. F_RNG:rand(1,2) .. ".png"))
			b.s:setPos(b.p)
			b.s:setScale(0)
			b.s.color:setRGBA(1,1,1,0.15)
			b.layer = F_RNG:rand(1,2)
		end
	end

	function flock:update()

		-- check ppl
		self.ppl = {}
		local count = 0
		for k,v in sortedpairs(self.people) do
			count = count + 1
			self.ppl[count] = v
		end		

		self.state = ""

		self.center_tmp = nil
		self.center_max = 0		

		local v1,v2,v3,v4,v5
		
		for i = 1,self.boids_num do

			local b = self.boids[i]
			
			if(#self.ppl > 0) then
				-- scale by distance to target
				self.factor_target = 4

				local target = self:get_target(b)
				self.target:setPos(target)
				local d = (target - b.p)
				b.s:setScale(0.03 + b.s:getScale() + ( (4/math.max(1,d:length())) - b.s:getScale())/8.0 )
				b.s:setAlpha(0.02 + b.s:getAlpha() + ( (0.2/math.max(1,d:length())) - b.s:getAlpha())/5.0 )
				self.limit_velocity = d:length() * 10.0
				
			else	
				-- scale by flock size
				self.factor_target = 0
				self.limit_velocity = 87.5
				b.s:setAlpha(0.15)
				if(b.count > 3) then
					b.s:setScale(b.s:getScale() + ( (b.count / 13) - b.s:getScale())/10)
				else
					b.s:setScale(b.s:getScale() + ( - b.s:getScale())/10 )
				end
			end
			
			v1 = self:go_to_center(b) * self.factor_center
			v2 = self:avoid_collision(b) * self.factor_collision
			v3 = self:relative_velocity(b) * self.factor_velocity
			v4 = self:go_to_target(b) * self.factor_target
			v5 = self:wander(b) * self.factor_wander
			
			b.v = b.v + v1 + v2 + v3 + v4 + v5

			-- bound position
			self:bound_position(b)

			-- limit velocity
			local v = b.v:length()
		   	if v > self.limit_velocity then
	        	b.v = (b.v / v) * self.limit_velocity
	        end
	
			b:update()			
			
			-- centers
			if(i <= 8) then
				if( i == 1) then self.center_red_tmp = b.p
				else self.center_red_tmp = (self.center_red_tmp + b.p)
				end	
			elseif(i <= 16) then
				if(i == 9) then self.center_green_tmp = b.p
				else self.center_green_tmp = (self.center_green_tmp + b.p)
				end
			elseif(i <= 24) then
				if(i == 17) then self.center_blue_tmp = b.p
				else self.center_blue_tmp = (self.center_blue_tmp + b.p)
				end
			end
			
			-- strongest activity
			if (b.count > self.center_max) then
				self.center_tmp = b.center
				self.center_max = b.count
			end
			
		end

		-- update centers
		self.center_red 	= self.center_red +   (((self.center_red_tmp/8) - self.center_red) / 20)
		self.center_green 	= self.center_green +   (((self.center_green_tmp/8) - self.center_green) / 20)
		self.center_blue 	= self.center_blue +   (((self.center_blue_tmp/8) - self.center_blue) / 20)		
		self.center 		= self.center + ((self.center_tmp - self.center) / 40)
		
		-- compute relative distance-vectors from center
		self.dv_red = self.center_red - self.center
		self.dv_red.x = math.abs(self.dv_red.x / DISPLAY_WIDTH)
		self.dv_red.y = math.abs(self.dv_red.y / DISPLAY_HEIGHT)

		self.dv_green = self.center_green - self.center
		self.dv_green.x = math.abs(self.dv_green.x / DISPLAY_WIDTH)
		self.dv_green.y = math.abs(self.dv_green.y / DISPLAY_HEIGHT)

		self.dv_blue = self.center_blue - self.center
		self.dv_blue.x = math.abs(self.dv_blue.x / DISPLAY_WIDTH)
		self.dv_blue.y = math.abs(self.dv_blue.y / DISPLAY_HEIGHT)
				
		-- relative center vector
		self.dv_center:set(
			math.abs(self.center.x / DISPLAY_WIDTH),
			math.abs(self.center.y / DISPLAY_HEIGHT)
		)
				
		-- send osc data
		self.osc_msg:init("/s")
			self.osc_msg:addArgument(self.dv_red:length())
			self.osc_msg:addArgument(self.dv_green:length())
			self.osc_msg:addArgument(self.dv_blue:length())
			self.osc_msg:addArgument(self.dv_center.x)
			self.osc_msg:addArgument(self.dv_center.y)
			self.osc_msg:addArgument(self.center_max)
		self.osc_msg:pack()
		self.osc_socket:send(self.osc_msg)

	end
	
	function flock:get_target(b)
		if(#self.ppl > 0)then
			local t = ((self.boids_num+1)/ #self.ppl)
			t = math.min(#self.ppl,math.floor(b.id/t) + 1)
			return (self.ppl[t].s:getPos())
		else
			return rVec2(0,0)
		end				
	end
	
	function flock:wander(b)
		if(rSystem.getTime() - b.ts_wander > b.ts_wander_wait)then
			b.ts_wander = rSystem.getTime()
			b.ts_wander_wait = F_RNG:rand(500,4000)
			b.wander = b.v + rVec2(F_RNG:rand(-360,360),F_RNG:rand(-360,360))
		end
		return b.wander/10
	end
	
	function flock:go_to_target(b)	
		return (self:get_target(b) - b.p)
	end

	function flock:go_to_center(b)	

		b.center = rVec2(b.p.x,b.p.y)
		b.count = 1
		local tmp
		
		for i = 1,self.boids_num do
			if(b ~= self.boids[i])then
				tmp = b.p - self.boids[i].p
				if (  tmp:length() < self.limit_visibility  ) then
					b.center = b.center + self.boids[i].p
					b.count = b.count + 1
				end
			end
		end
		
		b.center = b.center / b.count
		return (b.center - b.p)

	end

	function flock:avoid_collision(b)

		local v = rVec2(0,0)
		local tmp
		
		for i = 1,self.boids_num do
			if(b ~= self.boids[i])then
				tmp = b.p - self.boids[i].p
				if (  tmp:length() < self.limit_visibility  ) then				
					if (  tmp:length() < self.limit_collision  ) then
						v = v - (self.boids[i].p - b.p)
					end
				end
			end
		end

		return v

	end

	function flock:relative_velocity(b)
		local c = rVec2(b.v.x,b.v.y)
		local count = 1
		local tmp
		
		for i = 1,self.boids_num do
			if(b ~= self.boids[i]) then
				tmp = b.p - self.boids[i].p
				if (  tmp:length() < self.limit_visibility  ) then
					c = c + self.boids[i].v
					count = count + 1
				end
			end
		end
		c = c / (count)
		return (c - b.v) / 8
	end
	
	function flock:bound_position(b)

		if b.p.x <= 0 then b.p.x = ripe:displayW()
		elseif b.p.x > ripe:displayW() then b.p.x = 1
		end
		
		if b.p.y <= 0 then b.p.y = ripe:displayH()
		elseif b.p.y > ripe:displayH() then b.p.y = 1
		end

	end
	