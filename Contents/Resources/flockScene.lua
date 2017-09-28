
class 'flockScene' (rScene)

	function flockScene:__init(w,h,f)  super(w,h)
		self.flock = f
		
		self.white = rColor(1,1,1)
		self.red = rColor(1,0,0)
		self.green = rColor(0,1,0)
		self.blue = rColor(0,0,1)
		
		
		self.font = rFontManager.get():load("Andale Mono",16)
				
		self.agent = rSpriteImage(tm:loadTexture("agent.png"))

		self.halo_collision = rSpriteArc(0)
		self.halo_collision.color = rColor(0,1,0,0.1)
		
		self.halo_visibility = rSpriteArc(0)
		self.halo_visibility.color = rColor(1,1,1,0.02)
		
		self.centers = {}
		self.centers[1] = rSpriteRect(20,20)
		self.centers[1].color = self.white
		self.centers[2] = rSpriteRect(15,15)
		self.centers[2].color = self.red
		self.centers[3] = rSpriteRect(15,15)
		self.centers[3].color = self.green
		self.centers[4] = rSpriteRect(15,15)
		self.centers[4].color = self.blue
		
		
	end
		
	function flockScene:draw()
	
			self:beginScene()
	
			local b
			for i = 1,self.flock.boids_num do
				b = self.flock.boids[i]

				self.halo_visibility:setR(self.flock.limit_visibility)
				self.halo_visibility:setPos(b.p)
				self.halo_visibility:draw()

				self.halo_collision:setR(self.flock.limit_collision)
				self.halo_collision:setPos(b.p)
				self.halo_collision:draw()	

				if(i<=8) then
					self.agent.color = self.red
				elseif(i <= 16) then
					self.agent.color = self.green
				else
					self.agent.color = self.blue
				end

				self.agent:setPos(b.s:getPos())
				self.agent:setRotation(b.s:getRotation())
				self.agent:draw()

				self.font:draw(tostring(b.count),b.p.x + 22, b.p.y - 22, 1.0,self.white);
			end
	
			rUtil.drawLine(self.flock.center.x, self.flock.center.y, self.flock.center_red.x , self.flock.center_red.y, self.red)
			rUtil.drawLine(self.flock.center.x, self.flock.center.y, self.flock.center_green.x , self.flock.center_green.y, self.green)
			rUtil.drawLine(self.flock.center.x, self.flock.center.y, self.flock.center_blue.x , self.flock.center_blue.y, self.blue)
	
			self.centers[1]:setPos(self.flock.center)
			self.centers[2]:setPos(self.flock.center_red)
			self.centers[3]:setPos(self.flock.center_green)
			self.centers[4]:setPos(self.flock.center_blue)
			
			self.centers[1]:draw()
			self.centers[2]:draw()
			self.centers[3]:draw()
			self.centers[4]:draw()
			
			self.font:draw("dx: " .. tostring(round(self.flock.dv_red.x,2)),self.flock.center_red.x + 12, self.flock.center_red.y - 20, 1.0, self.white)
			self.font:draw("dy: " .. tostring(round(self.flock.dv_red.y,2)),self.flock.center_red.x + 12, self.flock.center_red.y - 5, 1.0, self.white)
			self.font:draw("d : " .. tostring(round(self.flock.dv_red:length(),2)),self.flock.center_red.x + 12, self.flock.center_red.y + 12, 1.0, self.white)

			self.font:draw("dx: " .. tostring(round(self.flock.dv_green.x,2)),self.flock.center_green.x + 12, self.flock.center_green.y - 20, 1.0, self.white)
			self.font:draw("dy: " .. tostring(round(self.flock.dv_green.y,2)),self.flock.center_green.x + 12, self.flock.center_green.y - 5, 1.0, self.white)
			self.font:draw("d : " .. tostring(round(self.flock.dv_green:length(),2)),self.flock.center_green.x + 12, self.flock.center_green.y + 10, 1.0, self.white)
	
			self.font:draw("dx: " .. tostring(round(self.flock.dv_blue.x,2)),self.flock.center_blue.x + 12, self.flock.center_blue.y - 20, 1.0, self.white)
			self.font:draw("dy: " .. tostring(round(self.flock.dv_blue.y,2)),self.flock.center_blue.x + 12, self.flock.center_blue.y - 5, 1.0, self.white)
			self.font:draw("d : " .. tostring(round(self.flock.dv_blue:length(),2)),self.flock.center_blue.x + 12, self.flock.center_blue.y + 10, 1.0, self.white)
			
			self.font:draw("x: " .. tostring(round(self.flock.dv_center.x,2)),self.flock.center.x + 15, self.flock.center.y - 20, 1.0, self.white)
			self.font:draw("y: " .. tostring(round(self.flock.dv_center.y,2)),self.flock.center.x + 15, self.flock.center.y - 5, 1.0, self.white)
			self.font:draw("p: " .. tostring(self.flock.center_max),self.flock.center.x + 15, self.flock.center.y + 10, 1.0, self.white)

	
			self:endScene()
	
	end
