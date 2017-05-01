--主角机体
PLANE_CONFIG = { 
	{maxHp_ = 10, bulletId_ = 1, bulletType_ = 1, bulletCalmTime_ = 0.1},
	{maxHp_ = 15, bulletId_ = 1, bulletType_ = 1, bulletCalmTime_ = 0.2},
	{maxHp_ = 8, bulletId_ = 3, bulletType_ = 1, bulletCalmTime_ = 0.4}, --升级时间
	{maxHp_ = 10, bulletId_ = 1, bulletType_ = 1, bulletCalmTime_ = 0.1},
	{maxHp_ = 15, bulletId_ = 3, bulletType_ = 1, bulletCalmTime_ = 0.4}, --只升级type
	{maxHp_ = 15, bulletId_ = 7, bulletType_ = 1, bulletCalmTime_ = 0.2}, --升级type
	}

ROLE_SCORE_TBL = {  
	500,500,1000,2000,5000
 }

--AI的宏
AI={
	LINE = 1, --匀速直线
	SPEED_UP = 2, --突然加速
	TURN_TO_ROLE = 3, --转向主角
	FIRE_BULLET = 4, --发射子弹
	DEAD_TO_FIRE = 5, --死亡发射子弹
	SPEED_UP_FOLLOW = 6, --突然加速跟随角色
	FOLLOW = 7, --跟随角色
	FOLLOW_AND_FIRE = 8,--跟随角色并且发射子弹
	DEAD_ITEM= 9, --死亡之后有道具
}
--敌人的AI
ENEMY_AI_TBL = {
	AI.FIRE_BULLET,  
	AI.LINE,
	AI.DEAD_TO_FIRE,

	AI.SPEED_UP,
	AI.FIRE_BULLET,
	AI.FOLLOW_AND_FIRE, --boss

	AI.FOLLOW_AND_FIRE,
	AI.FOLLOW_AND_FIRE,
	AI.DEAD_ITEM,

	AI.DEAD_TO_FIRE,
	AI.FOLLOW_AND_FIRE,
	15, --待定

	AI.FOLLOW_AND_FIRE,
	AI.FOLLOW_AND_FIRE,
	1, --待定

}

--敌人发射类型
--1普通；2散弹；3一串；4两列；5全场；6跟随子弹；
--7一半的散弹；8：三列的子弹；9连续发射一串；10连续发射散弹
ENEMY_FIRE_TYPE_TBL = {
	1,1,5,
	1,2,2,
	9,3,7,
	5,9,1,
	10,10,1,
}

--敌人对应的子弹
ENEMY_BULLET_TBL = {
	1,1,8,
	2,4,5,
	7,9,1,
	8,7,2,
	8,9,1,
}

--敌人对应的是否漂浮
ENEMY_FLOAT_TBL = {
	false,false,false,
	false,false,true,
	true,false,false,
	false,true,true,
	true,true,false,
}

--子弹的伤害值
BULLET_DAMAGE_TBL = {
	1,2,4,
	2,2,2,
	2,2,2,
}

--敌人的血量
ENEMY_HP_TBL = {
	5,2,5,
	8,8,120,
	200,15,5,
	2,120,15,
	100,15,15,
}

--boss的子弹发射改变表
BOSS_FIRE_TBL = {
	-- [11] = { 9, 10  }
}

--敌人AI思考时间
ENEMY_AI_TIME_TBL = {
	3,2.5,1,
	1,2,2,
	2,2,2,
	3,3,2,
	2,2,2,
}

--敌人的分数
ENEMY_SCORE_TBL = {
	50,50,100,
	200,200,500,
	100,200,300,
	1000,2000,5000,
	2000,2000,5000,
}



--敌人的速度
ENEMY_SPEED_TBL = {
	cc.p( 0,-4 ),cc.p( 0,-7 ),cc.p( 0,-5 ),
	cc.p( 0,-10 ),cc.p( 0,-2 ),cc.p( 0,-2 ),
	cc.p( 0,-2 ),cc.p( 0,-2 ),cc.p( 0,-2 ),
	cc.p( 0,-2 ),cc.p( 0,-2 ),cc.p( 0,-2 ),
	cc.p( 0,-2 ),cc.p( 0,-2 ),cc.p( 0,-2 ),
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