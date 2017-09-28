

class 'person'

	function person:__init(id, pos) 
		self.id = id
		self.ts = rSystem.getTime()
		self.s = rSpriteArc(30)
		self.s:setPos(pos)
		self.s.color:setRGB(0,1,0)
	end