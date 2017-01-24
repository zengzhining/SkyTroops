--主角机体
PLANE_CONFIG = { 
	{maxHp_ = 5, bulletId_ = 1, bulletType_ = 1, bulletCalmTime_ = 0.1},
	{maxHp_ = 5, bulletId_ = 2, bulletType_ = 2, bulletCalmTime_ = 0.2},
	{maxHp_ = 8, bulletId_ = 2, bulletType_ = 1, bulletCalmTime_ = 0.15},
	{maxHp_ = 5, bulletId_ = 1, bulletType_ = 1, bulletCalmTime_ = 0.2},
	{maxHp_ = 5, bulletId_ = 1, bulletType_ = 1, bulletCalmTime_ = 0.2},
	{maxHp_ = 5, bulletId_ = 1, bulletType_ = 1, bulletCalmTime_ = 0.2},
	{maxHp_ = 5, bulletId_ = 1, bulletType_ = 1, bulletCalmTime_ = 0.2},
	}

ROLE_SCORE_TBL = {  
	500,500,1000,2000,5000
 }

--子弹的伤害值
BULLET_DAMAGE_TBL = {
	1,2,2,
	2,2,2,
	2.5,2.5,2.5,
}

--敌人的血量
ENEMY_HP_TBL = {
	4,1,10,
	8,8,100,
	15,15,15,
	15,15,15,
	300,15,15,
}

--敌人的AI
ENEMY_AI_TBL = {
	4,2,7,
	8,5,13,
	9,11,9,
	9,14,15,
	21,11,1,
}

--敌人AI思考时间
ENEMY_AI_TIME_TBL = {
	2,2.5,1,
	2,2,1,
	2,2,1,
	2,2,0.5,
	2,2,1,
}

--敌人的分数
ENEMY_SCORE_TBL = {
	10,10,15,
	20,50,500,
	100,200,300,
	1000,2000,5000,
	2000,2000,5000,
}

--敌人对应的子弹
ENEMY_BULLET_TBL = {
	1,1,1,
	2,4,5,
	8,9,1,
	8,7,2,
	8,9,1,
}

--敌人的速度
ENEMY_SPEED_TBL = {
	cc.p( 0,-1.5 ),cc.p( 0,-5 ),cc.p( 0,-2 ),
	cc.p( 0,-2 ),cc.p( 0,-2 ),cc.p( 0,-2 ),
	cc.p( 0,-2 ),cc.p( 0,-2 ),cc.p( 0,-2 ),
	cc.p( 0,-2 ),cc.p( 0,-2 ),cc.p( 0,-2 ),
	cc.p( 0,-2 ),cc.p( 0,-2 ),cc.p( 0,-2 ),
}

--敌人对应的是否漂浮
ENEMY_FLOAT_TBL = {
	false,false,false,
	false,false,true,
	false,false,false,
	false,true,true,
	true,true,false,
}

--关卡的描述
LEVEL_DES = {
	"Faith",
	"Courage",
	"Courage",
	"Courage",
	"Courage",
	"Courage",
	
}