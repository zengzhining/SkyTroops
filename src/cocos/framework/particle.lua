--粒子效果

local particle = {}

particle.createParticle = function(plistFile)
	local emitter = cc.ParticleSystemQuad:create(plistFile)
	return emitter
end

return particle