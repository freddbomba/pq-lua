

class 'boid'

	function boid:__init(id,pos,vel)

		self.id = id
		self.p = pos
		self.v = vel
		self.count = 0
		self.center = pos

		self.ts_wander = rSystem.getTime()
		self.ts_wander_wait = F_RNG:rand(1000,4000)
		self.wander = rVec2()

		self.s = rSpriteImage(tm:loadTexture("b0" .. F_RNG:rand(1,2,3,4,5) .. ".png"))
		self.s = rSpriteImage(tm:loadTexture("agent.png"))
		self.s:setPos(self.p)
		self.s:setScale(0)
		self.s.color:setRGBA(1,1,1,0.15)
		self.layer = F_RNG:rand(1,2)

		self.update_ts = rSystem.getTime()

	end

	function boid:__eq(b)
	 	return (self.s:getID() == b.s:getID())
	end

	function boid:update()

		local speed = self.v:length()
		local delta = rSystem.getTime() - self.update_ts
		self.update_ts = rSystem.getTime()
		local v2 = rVec2(self.v.x,self.v.y)
		v2:normalize()
		v2 = v2 * speed * (delta/1250.0)
		self.p = self.p + (v2)
		self.p = self.p + (self.v/20)
		self.s:setPos(self.p)

		local yaxis = rVec2(0,1)
		self.s:setRotation( ((180 - yaxis:angle(self.v)) / 360) )
	end
