module("Helper", package.seeall)

--上下漂移浮动
function floatObject( obj, time )
	if not time then 
		time = 1.0
	end
	local a = CCRepeatForever:create(cc.Sequence:create(
		cc.EaseIn:create( cc.MoveBy:create(time, ccp( 0, 4 )), 1.5),
		cc.EaseOut:create( cc.MoveBy:create(time, ccp( 0, 4 )), 1.5),
		cc.EaseIn:create( cc.MoveBy:create(time, ccp( 0, -4 )), 1.5),
		cc.EaseOut:create( cc.MoveBy:create(time, ccp( 0, -4 )), 1.5)
		))
	obj:runAction(a)
end

--淡入淡出
function fadeObj( obj, time )
	if not time then 
		time = 1.0
	end

	local seq = cc.Sequence:create(
		cc.EaseOut:create( cc.FadeOut:create(time), 1.5 ),
		cc.EaseIn:create( cc.FadeIn:create(time), 1.5 )
		)
	obj:runAction(cc.RepeatForever:create(seq))
end

function showParticle( layer, point, fileName )
	local emitter = particle.createParticle( fileName)
	emitter:pos(point)
	layer:add(emitter,999)
end
--显示一个粒子特效
function showClickParticle( layer, point )
	showParticle(layer, point, "Particles/LavaFlow.plist")
end


