

class 'rng'

	function rng:__init() 
		self.digest = rUtil.encodeMD5(tostring(rSystem.getTime()))
	end

	function rng:updateDigest(input)
		self.digest = rUtil.encodeMD5(self.digest .. input)
	end

	function rng:rand()
		return math.random()
--		return self:rand(0,10000.0)/10000.0		
	end	

	function rng:rand(low,high)
		return math.random(low,high)
--[[
		local range = high - low

		self.digest = rUtil.encodeMD5(self.digest)
--]]
	end