package {
	
	import flashx.textLayout.formats.Float;
	
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	public class PlayState extends FlxState {
		
		public const EPSILON:Number = 0.001;
		public const CANNON_VEL:Number = 6400; //the initial velocity (in pixels per second) of the hand upon launch from a cannon
		public const ROTATE_RATE:Number = 2; //the speed (in degrees per frame) with which the hand rotates before grappling
		public const GRAPPLE_SPEED:Number = 300; //the velocity (in pixels per second) of the grappling arm when extending or retracting
		public const MAX_MOVE_VEL:Number = 200; //maximum velocity (in pixels per second) of the hand's movement
		public const MAX_GRAV_VEL:Number = 400; //terminal velocity (in pixels per second) when the hand is falling
		public const GRAV_RATE:Number = 1600; //acceleration (in pixels per second per second) due to gravity
		public const MOVE_ACCEL:Number = 1600; //acceleration (in pixels per second per second) of the hand when moving along a wall
		public const MOVE_DECEL:Number = MOVE_ACCEL; //deceleration (in pixels per second per second) of the hand when moving along a wall 
		public const FLOOR_JUMP_VEL:Number = 200; //initial velocity (in pixels per second) of a hand jumping from the floor
		public const WALL_JUMP_VEL:Number = 100; //initial velocity (in pixels per second) of a hand jumping from the wall
		public const CEIL_JUMP_VEL:Number = 50; //initial velocity (in pixels per second) of a hand jumping from the ceiling
		
		/*
		public const METAL_MIN:uint = 64; //minimum index number of metal in the tilemap
		public const METAL_MAX:uint = 147; //maximum index number of metal in the tilemap
		public const WOOD_MIN:uint = 1; //minimum index number of wood in the tilemap
		public const WOOD_MAX:uint = 63; // maximum index number of wood in the tilemap
		public const UNTOUCHABLE_MIN:uint = 148;
		public const UNTOUCHABLE_MAX:uint = 170;
		
		public const UNTOUCHABLE_OVERFLOW_MIN:uint = 192;
		public const UNTOUCHABLE_OVERFLOW_MAX:uint = 231;
		public const WOOD_OVERFLOW_MIN:uint = 232;
		public const WOOD_OVERFLOW_MAX:uint = 263;
		public const WOOD_OVERFLOW_OVERFLOW_MIN:uint = 289;
		public const WOOD_OVERFLOW_OVERFLOW_MAX:uint = 292;
		
		public const GRASS_MIN:uint = 272;
		public const GRASS_MAX:uint = 286;
		public const UNTOUCHABLE_GRASS_MIN:uint = 264;
		public const UNTOUCHABLE_GRASS_MAX:uint = 271;
		*/
		
		public const EMPTY_SPACE:uint = 0; // index of empty space in tilemap
		public const GRAPPLE_LENGTH:uint = 320; // maximum length of the grappling arm
		public const DOT_SPACING:uint = 10;
		public const DOT_SPEED:uint = 3;
		
		public var steamsNumberArray:Array = new Array();
		public var steamsNumber:Number = 0;
		public var steamTimer:Number = 0;
		public var steamTimerMax:Number = 2;
		public var steamsStartPoint:Array = new Array();
		public var steamsDXY:Array = new Array();
		
		//public const SOUND_ON:Boolean = false;
		
		private var levelFunctional:FlxTilemap;
		
		/* Level Spawn Points */
		public const HAND_SPAWN:uint = 191;
		public const BODY_SPAWN:uint = 190;
		public const CANNON_SPAWN:uint = 189;
		public const DOOR_MIN:uint = 184;
		public const DOOR_MAX:uint = 185;
		public const BUTTON_MIN:uint = 172;
		public const BUTTON_MAX:uint = 183;
		
		public const EXIT_SPAWN:uint = 171;
		
		public const STEAM:Array = [64,69,71,72,77,78,79,86,88,91,93,95,117,125,126,127,252,253,254,255,256,257,258,259,260,261,262,263,289,290,291,292];
		public const STEAM_U:Array = [254,255,289,290,86,91,93,125];
		public const STEAM_D:Array = [69,71,76,117,252,253,260,261];
		public const STEAM_L:Array = [263,262,259,257,79,77,95,127];
		public const STEAM_R:Array = [64,72,88,126,256,258,291,292];
		public const STEAM_1:Array = [291,289,262,260,257,256,254,252,93,88,86,79,78,77,69,64];
		
		/* Midground Spawn Points */
		public const GEAR_MIN:uint = 1;
		public const GEAR_MAX:uint = 18;
		public const STEAM_MIN:uint = 19;
		public const STEAM_MAX:uint = 30;
		public const TRASH_SPAWN:uint = 31;
		public const JUMP_HINT_SPAWN:uint = 32;
		public const SIGN_SPAWN:uint = 33;
		
		//button animation frames
		public const BUTTON_PRESSED:uint = 0;
		public const BUTTON_INIT:uint = 1;
		
		public const ACTION_KEY:String = "SPACE";
		public const BODY_KEY:String = "CONTROL";
		
		public var reinvigorated:Boolean;
		
		public var pause:PauseState;
		
		public var touchedExitPoint:Boolean = false;
		
		public var time:Number = 0;
		public var IDLE_TIME:Number = 15;
		
		public var pulseTimer:Number = 0;
		public var pulseTimeMax:Number = 2.2;
		public var pulseDir:Number = 1;
		
		public var dbg:int;
		public var rad:Number;
		public var controlDirs:Array;
		public var lastGround:uint;
		public var tempGround:uint;
		
		public var jumpHintGroup:FlxGroup = new FlxGroup();
		
		public var electricityNum:int = 1;
		
		public var doorsDead:Boolean;
		
		public var level:FlxTilemap;
		public var levelBack:FlxTilemap;
		public var hand:FlxSprite;
		public var hint:FlxSprite;
		public var bodyGroup:FlxGroup;
		public var curBody:uint;
		public var curCannon:uint;
		public var arrow:FlxSprite;
		public var bodyGearGroup:FlxGroup;
		public var bodyHeadGroup:FlxGroup;
		
		public var bodyArmBaseGroup:FlxGroup = new FlxGroup();
		public var cannonArmBaseGroup:FlxGroup = new FlxGroup();
		
		public var bodyTargetAngle:Number;
		
		public var overlay:FlxSprite = new FlxSprite();
		
		public var arms:FlxGroup = new FlxGroup();
		public const numArms:int = 22;
		public var handDir:uint;
		
		public var handFalling:Boolean;
		public var bodyMode:Boolean;
		public var cannonMode:Boolean;
		public var handOut:Boolean;
		public var handIn:Boolean;
		public var handGrab:Boolean;
		public var handMetalFlag:uint;
		public var handWoodFlag:uint;
		public var onGround:Boolean;
		public var handTouching:uint;
		public var lastVel:FlxPoint; //last nonzero hand velocity - used for convex corners
		public var touchingTrash:Boolean;
		
		public var gearInGroup:FlxGroup = new FlxGroup();
		public var gearOutGroup:FlxGroup = new FlxGroup();
		public var steams:FlxGroup = new FlxGroup();
		
		public var lastTouchedWood:Boolean = false;
		public var arrowStartAngle:int;
		public var shootAngle:int;
		//public var handReturnedToBody:Boolean = false;
		
		public var buttonGroup:FlxGroup = new FlxGroup();
		public var buttonStateArray:Array = new Array();
		public var buttonReactionArray:Array = new Array();
		public var buttonMode:uint;
		public var buttonBangGroup:FlxGroup = new FlxGroup();
		
		public var doorGroup:FlxGroup = new FlxGroup();
		
		public var electricity:FlxSprite;
		
		public var timeFallen:Number;
		
		public var markerLine:FlxSprite;
		//public var hintArrow:FlxSprite = new FlxSprite();
		public var exitArrow:FlxSprite = new FlxSprite();
		public var exitRad:Number;
		public var exitOn:Boolean;
		public var col:uint; //pulse color
		
		public var cannonGroup:FlxGroup = new FlxGroup();
		
		public var exitPoint:FlxPoint = new FlxPoint();
		
		public var trashGroup:FlxGroup = new FlxGroup();
		public var lastTouchedDirt:Boolean = false;
		
		[Embed("assets/cannon.png")] public var cannonSheet:Class;
		
		[Embed("assets/trash.png")] public var trashSheet:Class;
		
		[Embed("assets/arm_base.png")] public var armBaseSheet:Class;
		
		[Embed("assets/level-tiles.png")] public var tileset:Class;
		[Embed("assets/background-tiles.png")] public var backgroundset:Class;
		[Embed("assets/midground-tiles.png")] public var midgroundset:Class;
		
		[Embed("assets/arrow.png")] public var arrowSheet:Class;
		[Embed("assets/hand.png")] public var handSheet:Class;
		[Embed("assets/hint.png")] public var hintSheet:Class;
		[Embed("assets/arm.png")] public var armSheet:Class;
		[Embed("assets/body.png")] public var bodySheet:Class;
		
		[Embed("assets/electricity.png")] public var electricitySheet:Class;
		
		[Embed("assets/gear_64x64.png")] public var gear64x64Sheet:Class;
		[Embed("assets/gear_32x32.png")] public var gear32x32Sheet:Class;
		[Embed("assets/gear_16x16.png")] public var gear16x16Sheet:Class;
		
		[Embed("assets/sign.png")] public var signSheet:Class;
		
		public static var levelMap:Class;
		public static var midgroundMap:Class;
		public static var backgroundMap:Class;
		
		[Embed("assets/button_d.png")] public var buttonDSheet:Class;
		[Embed("assets/button_l.png")] public var buttonLSheet:Class;
		[Embed("assets/button_u.png")] public var buttonUSheet:Class;
		[Embed("assets/button_r.png")] public var buttonRSheet:Class;
		
		[Embed("assets/door_h.png")] public var doorHSheet:Class;
		[Embed("assets/door_v.png")] public var doorVSheet:Class;
		
		[Embed("assets/bodygear.png")] public var bodyGearSheet:Class;
		
		[Embed("assets/!.png")] public var bangSheet:Class;
		
		[Embed("assets/Metal_Footsteps.mp3")] public var metalFootstepsSFX:Class;
		[Embed("assets/Wood_Footsteps.mp3")] public var woodFootstepsSFX:Class;
		[Embed("assets/Grapple_Extend.mp3")] public var grappleExtendSFX:Class;
		[Embed("assets/Robody_Aim.mp3")] public var robodyAimSFX:Class;
		[Embed("assets/Jump.mp3")] public var jumpSFX:Class;
		[Embed("assets/Pipe_Walk.mp3")] public var pipeWalkSFX:Class;
		[Embed("assets/Robody_LandOnPipe.mp3")] public var robodyLandOnPipeSFX:Class;
		[Embed("assets/Robody_LandOnWall.mp3")] public var robodyLandOnWallSFX:Class;
		[Embed("assets/Ambient_Electrical_Hum.mp3")] public var ambientElectricalHumSFX:Class;
		[Embed("assets/Cannon_Shot.mp3")] public var cannonShotSFX:Class;
		[Embed("assets/Hand_Landing_On_Metal.mp3")] public var handLandingOnMetalSFX:Class;
		[Embed("assets/Hand_Landing_On_Nonstick_Metal.mp3")] public var handLandingOnNonstickMetalSFX:Class;
		[Embed("assets/ButtonPress.mp3")] public var buttonPressSFX:Class;
		[Embed("assets/Ambient_Gears.mp3")] public var ambientGearsSFX:Class;
		[Embed("assets/Ambient_Steam.mp3")] public var ambientSteamSFX:Class;
		[Embed("assets/Door_Open.mp3")] public var doorOpenSFX:Class;
		[Embed("assets/Dirt_Footsteps.mp3")] public var dirtFootstepsSFX:Class;
		[Embed("assets/Land_On_Dirt.mp3")] public var handLandingOnDirtSFX:Class;
		
		public var metalCrawlSound:FlxSound = new FlxSound().loadEmbedded(metalFootstepsSFX);
		public var woodCrawlSound:FlxSound = new FlxSound().loadEmbedded(woodFootstepsSFX);
		public var grappleExtendSound:FlxSound = new FlxSound().loadEmbedded(grappleExtendSFX);
		public var robodyAimSound:FlxSound = new FlxSound().loadEmbedded(robodyAimSFX);
		public var jumpSound:FlxSound = new FlxSound().loadEmbedded(jumpSFX);
		public var pipeWalkSound:FlxSound = new FlxSound().loadEmbedded(pipeWalkSFX);
		public var robodyLandOnPipeSound:FlxSound = new FlxSound().loadEmbedded(robodyLandOnPipeSFX);
		public var robodyLandOnWallSound:FlxSound = new FlxSound().loadEmbedded(robodyLandOnWallSFX);
		public var ambientElectricalHumSound:FlxSound = new FlxSound().loadEmbedded(ambientElectricalHumSFX,true);
		public var cannonShotSound:FlxSound = new FlxSound().loadEmbedded(cannonShotSFX);
		public var handLandingOnMetalSound:FlxSound = new FlxSound().loadEmbedded(handLandingOnMetalSFX);
		public var handLandingOnNonstickMetalSound:FlxSound = new FlxSound().loadEmbedded(handLandingOnNonstickMetalSFX);
		public var buttonPressSound:FlxSound = new FlxSound().loadEmbedded(buttonPressSFX);
		public var ambientGearsSound:FlxSound = new FlxSound().loadEmbedded(ambientGearsSFX,true);
		public var ambientSteamSound:FlxSound = new FlxSound().loadEmbedded(doorOpenSFX);//ambientSteamSFX,true);
		public var doorOpenSound:FlxSound = new FlxSound().loadEmbedded(doorOpenSFX);
		public var dirtFootstepsSound:FlxSound = new FlxSound().loadEmbedded(dirtFootstepsSFX);
		public var handLandingOnDirtSound:FlxSound = new FlxSound().loadEmbedded(handLandingOnDirtSFX);
		
		[Embed("assets/steam.png")] public var steamSheet:Class;
		
		[Embed("assets/head.png")] public var headSheet:Class;
		[Embed("assets/sky.png")] public var skySheet:Class;
		[Embed("assets/factory.png")] public var factorySheet:Class;
		
		[Embed("assets/body_marker_line.png")] public var bodyMarkerLineSheet:Class;
		[Embed("assets/cannon_marker_line.png")] public var cannonMarkerLineSheet:Class;
		public var cannonMarkerLine:FlxSprite = new FlxSprite();
		//public var bodyMarkerLine:FlxSprite = new FlxSprite();
		public var bodyMarkerGroup:FlxGroup;
		public var bodyMarkerTimer:Number;
		public var markerEnd:FlxSprite;
		public var markerEndGroup:FlxGroup;
		
		public var camTag:FlxSprite = new FlxSprite();
		public var camAngle:Number = new Number;
		
		/*public function PlayState(level:Class,midground:Class,background:Class) {
			
			//if (Registry.DEBUG_ON) {
				levelMap = level;
				midgroundMap = midground;
				backgroundMap = background;
			//}
		}*/
		
		override public function create():void {
			
			ambientSteamSound.volume = 0.5;
			
			if (!Registry.DEBUG_ON) {
				Registry.level = Registry.levelOrder[Registry.levelNum];
				Registry.midground = Registry.midOrder[Registry.levelNum];//Registry.midgroundMap;
				Registry.background = Registry.backOrder[Registry.levelNum];//Registry.backgroundMap;
			}
			
						
			levelFunctional = RegistryLevels.currentFlxTilemapFunctional();			
			
			levelMap = Registry.level;
			midgroundMap = Registry.midground;
			backgroundMap = Registry.background;
			
			dbg = 0;
			timeFallen = 0; //this was initialized above, so I moved it here for saftey's sake- mjahearn
			reinvigorated = false;//false; //ditto
			doorsDead = false;
			controlDirs = new Array();
			lastGround = FlxObject.DOWN;
			tempGround = FlxObject.DOWN;
			
			
			FlxG.bgColor = 0xff000000;
			if (Registry.levelNum >= 5) {
				//FlxG.bgColor = 0xff442288;
				//0xffaaaaaa; //and... if we want motion blur... 0x22000000
				var sky:FlxSprite = new FlxSprite(0,0,skySheet);
				sky.scrollFactor = new FlxPoint(0,0);
				add(sky);
				
			} /*else {
				var fact:FlxSprite = new FlxSprite(0,0,factorySheet);
				fact.scrollFactor = new FlxPoint(0,0);
				add(fact);
			}*/
			
			/* Background */
			var background:FlxTilemap = new FlxTilemap().loadMap(new backgroundMap,backgroundset,8,8);
			background.scrollFactor = new FlxPoint(0.5, 0.5);
			add(background);
			
			/* Midground */
			var midground:FlxTilemap = new FlxTilemap();
			midground.loadMap(new midgroundMap,midgroundset,8,8);
			
			for (var i:int = GEAR_MIN; i <= GEAR_MAX; i++) {
				var gearArray:Array = midground.getTileInstances(i);
				if (gearArray) {
					for (var j:int = 0; j < gearArray.length; j++) {
						
						// Decide gear spin (In or Out)
						// n.b. Every other gear in the sheet is In or Out
						var gearGroup:FlxGroup;
						if (i%2 == 0) {gearGroup = gearInGroup;}
						else {gearGroup = gearOutGroup;}
						
						// Decide gear size
						// n.b. Gears are grouped by 3 speeds, then by 2 sizes, then 2 spins
						var gearSheet:Class;
						var gearGaugeNumber:Number = (i-GEAR_MIN)%6;
						if (gearGaugeNumber < 2) {gearSheet = gear64x64Sheet;}
						else if (gearGaugeNumber < 4) {gearSheet = gear32x32Sheet;}
						else {gearSheet = gear16x16Sheet;}
						
						// do something for gear speed...?  Do we need gears to spin at different speeds?  Maybe not...
						
						var gearPoint:FlxPoint = pointForTile(gearArray[j],midground);
						var gear:FlxSprite = new FlxSprite(gearPoint.x,gearPoint.y,gearSheet);
						gearGroup.add(gear);
					}
				}
			}
			add(gearInGroup);
			add(gearOutGroup);
			
			// Trash
			var trashArray:Array = midground.getTileInstances(TRASH_SPAWN);
			if (trashArray) {
				var trashValidFrames:Array = [0,1,2,3,4,5,6,7];//,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,27,28,29,33,34];
				var trashValidAngles:Array = [90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270];
				for (j = 0; j < trashArray.length; j++) {
					var trashPoint:FlxPoint = pointForTile(trashArray[j],midground);
					var trash:FlxSprite = new FlxSprite(trashPoint.x,trashPoint.y);
					trash.loadGraphic(trashSheet,true,false,32,32,true);
					//trash.color = (0xffff0000 & Math.random()*0xffffffff)
					trash.color = 0xff555555;
					trash.frame = trashValidFrames[int(Math.random()*(trashValidFrames.length-1))];
					trash.angle = trashValidAngles[int(Math.random()*(trashValidAngles.length-1))];
					//trash.acceleration.y = MAX_GRAV_VEL;
					//trash.acceleration.x = -MAX_GRAV_VEL;
					trash.immovable = true;
					//FlxG.collide(hand,trash,woodCallback);
					trashGroup.add(trash);
				}
			}
			add(trashGroup);
			
			var jumpHintArray:Array = midground.getTileInstances(JUMP_HINT_SPAWN);
			midground.setTileProperties(JUMP_HINT_SPAWN,FlxObject.NONE);
			if (jumpHintArray) {
				for (j = 0; j < jumpHintArray.length; j++) {
					midground.setTileByIndex(jumpHintArray[j],0);
					var jumpHintPoint:FlxPoint = pointForTile(jumpHintArray[j],midground);
					jumpHintGroup.add(new FlxSprite(jumpHintPoint.x,jumpHintPoint.y));
				}
			}

			/* Level */
			
			level = new FlxTilemap();
			level.loadMap(new levelMap,tileset,8,8);
			add(level);
			FlxG.worldBounds = new FlxRect(0, 0, level.width,level.height);
			if (Registry.extendedCamera) {
				FlxG.camera.bounds = new FlxRect(-FlxG.width/2, -FlxG.height/2, level.width+FlxG.width, level.height+FlxG.height);
			} else {
				FlxG.camera.bounds = FlxG.worldBounds;
			}
			
			// Exit arrow
			level.setTileProperties(EXIT_SPAWN,FlxObject.NONE);
			var exitArray:Array = level.getTileInstances(EXIT_SPAWN);
			if (exitArray) {
			exitPoint = pointForTile(exitArray[0],level);
			level.setTileByIndex(exitArray[0],0);
			} else {
				exitPoint = new FlxPoint(0,0);
			}
			
			
			setCallbackFromSpawn(RegistryLevels.kSpawnMetal,metalCallback,levelFunctional,false);
			
			this.setCallbackFromSpawn(RegistryLevels.kSpawnWood,woodCallback,levelFunctional,false);
			
			if (Registry.DEBUG_ON) {add(levelFunctional);}
			
			/*
			for (i = WOOD_MIN; i <= WOOD_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, woodCallback);
			}
			
			for (i = WOOD_OVERFLOW_MIN; i <= WOOD_OVERFLOW_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, woodCallback);
			}
			
			for (i = WOOD_OVERFLOW_OVERFLOW_MIN; i <= WOOD_OVERFLOW_OVERFLOW_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, woodCallback);
			}
			
			for (i = METAL_MIN; i <= METAL_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, metalCallback);
			}
			
			for (i = UNTOUCHABLE_MIN; i <= UNTOUCHABLE_MAX; i++) {
				level.setTileProperties(i, FlxObject.NONE);
			}
			
			for (i = UNTOUCHABLE_OVERFLOW_MIN; i <= UNTOUCHABLE_OVERFLOW_MAX; i++) {
				level.setTileProperties(i, FlxObject.NONE);
			}
			
			
			for (i = UNTOUCHABLE_GRASS_MIN; i <= UNTOUCHABLE_GRASS_MAX; i++) {
				level.setTileProperties(i, FlxObject.NONE);
			}
			
			
			// do we need a grass sound?
			for (i = GRASS_MIN; i <= GRASS_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, dirtCallback);
			}*/
			
			
			
			
			// Cannons
			level.setTileProperties(CANNON_SPAWN,FlxObject.NONE);
			var cannonArray:Array = level.getTileInstances(CANNON_SPAWN);
			if (cannonArray) {
				for (j = 0; j < cannonArray.length; j++) {
					level.setTileByIndex(cannonArray[j],0);
					var cannonPoint:FlxPoint = pointForTile(cannonArray[j],level);
					var cannon:FlxSprite = new FlxSprite(cannonPoint.x,cannonPoint.y,cannonSheet);
					cannon.facing = FlxObject.DOWN; // this might need to change if they're mounted on walls?
					cannon.angle = 0;
					cannonGroup.add(cannon);
					
					cannonArmBaseGroup.add(new FlxSprite(cannon.x,cannon.y,armBaseSheet));
					cannon.facing = FlxObject.DOWN;
				}
			}
			add(cannonGroup);
			add(cannonArmBaseGroup);
			
			// Buttons
			for (i = BUTTON_MIN; i <= BUTTON_MAX; i++) {
				level.setTileProperties(i,FlxObject.NONE);
				var buttonArray:Array = level.getTileInstances(i);
				if (buttonArray) {
					for (j = 0; j < buttonArray.length; j++) {
						level.setTileByIndex(buttonArray[j],0);
						var buttonPoint:FlxPoint = pointForTile(buttonArray[j],level);
						
						// Decide button graphic
						var buttonSheet:Class;
						var w:Number;
						var h:Number;
						var buttonGaugeNumber:Number = (i-BUTTON_MIN)%4;
						var bangAngle:Number;
						var bangDX:Number = 0;
						var bangDY:Number = 0;
						if (buttonGaugeNumber == 0) {buttonSheet = buttonLSheet; w = 8; h = 32; bangAngle = 90; bangDX = 8;}
						else if (buttonGaugeNumber == 1) {buttonSheet = buttonUSheet; w = 32; h = 8; bangAngle = 180; bangDY = 8;}
						else if (buttonGaugeNumber == 2) {buttonSheet = buttonRSheet; buttonPoint.x; w = 8; h = 32; bangAngle = -90; bangDX = -32;}
						else if (buttonGaugeNumber == 3) {buttonSheet = buttonDSheet; buttonPoint.y; w = 32; h = 8; bangAngle = 0; bangDY = -32;}
						
						
						var button:FlxSprite = new FlxSprite(buttonPoint.x,buttonPoint.y);
						button.loadGraphic(buttonSheet,true,false,w,h,true);
						button.frame = BUTTON_INIT;
						
						buttonGroup.add(button);
						buttonStateArray.push(false);
						
						var bang:FlxSprite = new FlxSprite(button.x+bangDX,button.y+bangDY);
						bang.loadGraphic(bangSheet,true,false,32,32,true);
						bang.angle = bangAngle;
						//bang.addAnimation("idle",[0]);
						bang.addAnimation("excite",[0,0,1,2,3,4,5,5,5,5,4,3,2,1,0,0],10,true);
						bang.play("excite");
						//bang.alpha = 0.88;
						buttonBangGroup.add(bang);
						
						
						//how to handle different buttons doing different things:
						/*if ( BUTTON IS A SPECIFIC BUTTON ) {
						specialFunctionDefinedBelowButtonReactionThatCallsButtonReaction();
						} else {*/
						buttonReactionArray.push(buttonReaction);
						//}
					}
				}
			}
			add(buttonGroup);
			add(buttonBangGroup);
			buttonMode = 0;
			
			// Bodies
			bodyGroup = new FlxGroup();
			bodyGearGroup = new FlxGroup();
			bodyHeadGroup = new FlxGroup();
			level.setTileProperties(i,FlxObject.NONE);
			var bodyArray:Array = level.getTileInstances(BODY_SPAWN);
			if (bodyArray) {
				for (j= 0; j < bodyArray.length; j++) {
					level.setTileByIndex(bodyArray[j],0);
					var bodyPoint:FlxPoint = pointForTile(bodyArray[j],level);
					
					var body:FlxSprite = new FlxSprite(bodyPoint.x,bodyPoint.y,bodySheet); // need to adjust graphic
					bodyTargetAngle = body.angle;
					//setGravity(body,FlxObject.DOWN,true);
					bodyGroup.add(body);
					var bodyGear:FlxSprite = new FlxSprite(body.x,body.y,bodyGearSheet);
					bodyGearGroup.add(bodyGear);
					// the positioning should be based on angle too
					var bodyHead:FlxSprite = new FlxSprite(body.x,body.y,headSheet);
					bodyHead.y -= bodyHead.height;
					bodyHeadGroup.add(bodyHead);
					
					bodyArmBaseGroup.add(new FlxSprite(body.x,body.y,armBaseSheet));
					body.facing = FlxObject.DOWN;
					
					var theta:Number = (body.angle-90)*Math.PI/180.0;
					
					bodyHead.x = body.x + body.width/2.0 - bodyHead.width/2.0 + (bodyHead.height*1.5)*Math.cos(theta);
					bodyHead.y = body.y + body.height/2.0 - bodyHead.height/2.0 + (bodyHead.height*1.5)*Math.sin(theta);
					bodyHead.angle = body.angle;
					
					bodyGear.x = body.x + body.width/2.0 - bodyGear.width/2.0 + (bodyGear.width/2.0)*Math.cos(theta-Math.PI/2.0);
					bodyGear.y = body.y + body.height/2.0 - bodyGear.height/2.0 + (bodyGear.width/2.0)*Math.sin(theta-Math.PI/2.0);
				}
			}
			add(bodyGroup);
			add(bodyGearGroup);
			add(bodyHeadGroup);
			add(bodyArmBaseGroup);
			
			// Doors
			for (i = DOOR_MIN; i <= DOOR_MAX; i++) {
				level.setTileProperties(i,FlxObject.NONE);
				var doorArray:Array = level.getTileInstances(i);
				if (doorArray) {
					for (j = 0; j < doorArray.length; j++) {
						level.setTileByIndex(doorArray[j],0);
						var doorPoint:FlxPoint = pointForTile(doorArray[j],level);
						
						// Decide door graphic
						var doorSheet:Class;
						var doorNumber:Number = (i-DOOR_MIN)%2;
						if      (doorNumber == 0) {doorSheet = doorVSheet; w = 16; h = 64;}
						else if (doorNumber == 1) {doorSheet = doorHSheet; w = 64; h = 16;}
						
						var door:FlxSprite = new FlxSprite(doorPoint.x,doorPoint.y);
						door.immovable = true;
						door.loadGraphic(doorSheet,true,false,w,h,true);
						//door.addAnimation("closed",[0]);
						door.addAnimation("open",[1,2,2,2,2,2,2,2,2,2,2,2,2,3,4,5,6,7,8,9,10,11,12],22,false);
						//door.play("closed");
						door.addAnimation("pulse 1",[17,17,17,16,15,14,14,14,15,16,17,17,17],10,true);
						door.addAnimation("pulse 2",[21,21,20,19,18,18,19,20,21,21],10,true);
						door.frame = 13;
						
						
						doorGroup.add(door);
					}
				}
			}
			add(doorGroup);
			
			
			// Steam
			//for (i = STEAM_MIN; i <= STEAM_MAX; i++) {
			for (var b:uint = 0; b < STEAM.length; b++) {
				i = STEAM[b];
				var steamArray:Array = level.getTileInstances(i);
				if (steamArray) {
					for (j = 0; j < steamArray.length; j++) {
						var steamPoint:FlxPoint = pointForTile(steamArray[j],level);
						var steam:FlxSprite = new FlxSprite(steamPoint.x,steamPoint.y);
						//steam.alpha = 0.5;
						steam.loadGraphic(steamSheet,true,false,32,32,true);
						steam.addAnimation("idle",[0]);
						steam.play("idle");
						
						// Decide steam angle
						// n.b. Steam is grouped in 3 frequencies, 4 angles
						//var steamGaugeNumber:Number = (i-STEAM_MIN)%4
						//if (steamGaugeNumber == 0) {
						
						steam.x -= steam.width/2 - 4; // the 4 is for the tile width and height
						steam.y -= steam.height/2 - 4;
						
						if (STEAM_L.indexOf(i) != -1) {
							steam.x += steam.width/2;
							steam.angle = 90;
							steam.facing = FlxObject.RIGHT;
							steamsDXY.push(new FlxPoint(-1,0));
						} else if (STEAM_U.indexOf(i) != -1) {//else if (steamGaugeNumber == 1) {
							steam.y += steam.height/2;
							steam.angle = 180;
							steam.facing = FlxObject.DOWN;
							steamsDXY.push(new FlxPoint(0,-1));
						} else if (STEAM_R.indexOf(i) != -1) {//else if (steamGaugeNumber == 2) {
							steam.x -= steam.width/2;
							steam.angle = 270;
							steam.facing = FlxObject.LEFT;
							steamsDXY.push(new FlxPoint(1,0));
						} else { //sGN == 3
							steam.y -= steam.height/2;
							steam.facing = FlxObject.UP;
							steamsDXY.push(new FlxPoint(0,1));
						}
						
						// Decide steam pattern
						// n.b. Steam is group in 3 patterns
						// maybe these could just be timed using FlxG.elapsed, and then each puff could be synced with sound
						//steamGaugeNumber = (i-STEAM_MIN);
						var steamPuffFrames:Array = [0,1,2,3,0];
						//if (steamGaugeNumber < 4)      {
						if (STEAM_1.indexOf(i) != -1) {
							//steamPuffFrames = [1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
							steamsNumberArray.push(0);
						} else {
						//else if (steamGaugeNumber < 8) {
							//steamPuffFrames = [0,0,0,0,0,0,0,0,0,1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
							steamsNumberArray.push(1);
						}/*
						else                           {
							//steamPuffFrames = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,0,0,0,0,0,0];
							steamsNumberArray.push(2);
						}*/
						steam.addAnimation("puff",steamPuffFrames,11,false);
						
						steamsStartPoint.push(new FlxPoint(steam.x,steam.y));
						
						steams.add(steam);
					}
				}
			}
			add(steams);
			
			
			// Hand + Arms
			level.setTileProperties(HAND_SPAWN,FlxObject.NONE);
			var array:Array = level.getTileInstances(HAND_SPAWN);
			var handPoint:FlxPoint = pointForTile(array[0],level);
			level.setTileByIndex(array[0],0);
			
			var arm:FlxSprite;
			for (i = 0; i < numArms; i++) {
				arm = new FlxSprite(0,0,armSheet); //originally body.x/y
				arm.visible = false;
				arms.add(arm);
			}
			add(arms);
			
			exitArrow.loadGraphic(arrowSheet,true,false,32,32,true);
			exitArrow.addAnimation("excite",[0,0,1,2,3,4,5,5,5,5,4,3,2,1,0,0],10,true);
			exitArrow.play("excite");
			exitArrow.scrollFactor = new FlxPoint();
			exitArrow.visible = false;
			add(exitArrow);
			exitRad = FlxG.height/2 - exitArrow.width;
			exitOn = false;
			
			// marker line
			//markerLine.makeGraphic(level.width,level.height,0x00000000);
			//add(markerLine);
			bodyMarkerGroup = new FlxGroup();
			bodyMarkerTimer = 0;
			cannonMarkerLine = new FlxSprite(0,0,cannonMarkerLineSheet);
			markerEnd = new FlxSprite(0,0);
			markerEnd.loadGraphic(handSheet,true,false,32,32);
			markerEnd.frame = 21;
			markerEnd.alpha = 0.5;
			markerEnd.visible = false;
			markerEndGroup = new FlxGroup();
			add(bodyMarkerGroup);
			add(cannonMarkerLine);
			markerEndGroup.add(markerEnd);
			add(markerEndGroup);
			
			hand = new FlxSprite(handPoint.x, handPoint.y);
			hand.loadGraphic(handSheet,true,false,32,32,true);
			hand.addAnimation("crawl right",[0,1,2,3,4,5,6],22,true);
			hand.addAnimation("idle right",[7,7,7,7,7,7,7,8,9,9,9,9,9,9,8],10,true);
			hand.addAnimation("crawl left",[20,19,18,17,16,15,14],22,true);
			hand.addAnimation("idle left", [13,13,13,13,13,13,13,12,11,11,11,11,11,11,12],10,true);
			hand.addAnimation("idle body right", [21,21,21,21,21,21,21,22,23,23,23,23,23,23,22],10,true);
			hand.addAnimation("idle body left", [25,25,25,25,25,25,25,26,27,27,27,27,27,27,26],10,true);
			hand.addAnimation("fall right",[29]);//[28,29],22,false);
			hand.addAnimation("fall left",[33]);//[33,34],22,false);
			hand.addAnimation("extend right",[35,36],22,false);
			hand.addAnimation("extend left",[40,41],22,false);
			handDir = FlxObject.RIGHT;
			hand.play("idle right");
			hand.maxVelocity.x = MAX_MOVE_VEL;
			hand.maxVelocity.y = MAX_MOVE_VEL;
			hand.drag.x = MOVE_DECEL;
			hand.drag.y = MOVE_DECEL;
			setDir(hand, FlxObject.DOWN, true);
			//onGround = false;
			add(hand);
			
			camTag = new FlxSprite(hand.x,hand.y);//,bodySheet);
			//add(camTag);
			
			// sign
			midground.setTileProperties(SIGN_SPAWN,FlxObject.NONE);
			var signArray:Array = midground.getTileInstances(SIGN_SPAWN);
			if (signArray) {
				for (j = 0; j < signArray.length; j++) {
					var signPoint:FlxPoint = pointForTile(signArray[j],midground);
					midground.setTileByIndex(array[j],0);
					add(new FlxSprite(signPoint.x, signPoint.y, signSheet));
				}
			}
			
			hint = new FlxSprite(0,0);
			hint.loadGraphic(hintSheet,true,false,64,64,true);
			hint.addAnimation("idle",[0]);
			//hint.addAnimation("think",[1,2,3,4],10,false);
			//hint.addAnimation("thinking up",[4]);
			//hint.addAnimation("thinking space",[5]);
			hint.addAnimation("X",[1,2,3],10,true);
			hint.addAnimation("Z",[4,5,6],10,true);
			hint.addAnimation("arrows",[7,8,9],10,true);
			hint.addAnimation("left X right",[10,11,12],10,true);
			hint.addAnimation("enter",[13,14,15],10,true);
			hint.play("idle");
			add(hint);
			
			electricity = new FlxSprite(hand.x,hand.y);
			electricity.loadGraphic(electricitySheet,true,false,32,32,true);
			electricity.addAnimation("electricute",[1,2,3,4,5,6,7],22,true);
			electricity.addAnimation("stop",[0]);
			add(electricity);
			
			electricity.play("electricute");
			
			bodyMode = false;
			cannonMode = false;
			curBody = uint.MAX_VALUE;
			handOut = false;
			handIn = false;
			handGrab = false;
			handMetalFlag = uint.MAX_VALUE;
			handWoodFlag = uint.MAX_VALUE;
			handTouching = hand.touching;
			rad = 0;
			lastVel = new FlxPoint();
			touchingTrash = false;
			
			arrow = new FlxSprite();
			arrow.loadGraphic(arrowSheet);
			arrow.visible = false;
			add(arrow);
			
			pause = new PauseState();
			pause.setAll("exists", false);
			add(pause);
			
			/*
			// hint arrows
			hintArrow.makeGraphic(FlxG.width,FlxG.height,0x00000000);
			hintArrow.scrollFactor = new FlxPoint(0,0);
			add(hintArrow);
			*/
			
			if (Registry.DEBUG_ON) {
				var text:FlxText = new FlxText(0,0,FlxG.width,"Press Esc to return to level select");
				text.scrollFactor = new FlxPoint(0,0);
				add(text);
			}
			
			FlxG.camera.follow(camTag, Registry.extendedCamera?FlxCamera.STYLE_LOCKON:FlxCamera.STYLE_TOPDOWN);
			
			overlay.makeGraphic(level.width,level.height,0xff000000);
			overlay.alpha = 0;
			add(overlay);
		}
		
		override public function update():void {
			
			pulseTimer += pulseDir*FlxG.elapsed;
			if (pulseTimer >= pulseTimeMax) {pulseTimer = pulseTimeMax;}
			if (pulseTimer <= 0) {pulseTimer = 0;}
			if (pulseTimer <= 0 || pulseTimer >= pulseTimeMax) {
				pulseDir *= -1;
			}
			
			steamTimer += FlxG.elapsed;
			if (steamTimer > steamTimerMax) {
				steamTimer = 0;
			}
			
			bodyMarkerTimer += FlxG.elapsed*DOT_SPEED;
			if (bodyMarkerTimer > 1) {
				bodyMarkerTimer -= 1;
			}
						
			if (Registry.levelNum >= 5) {overlay.alpha = 1 - Math.abs(level.width - hand.x)/level.width;}
			
			if ((bodyMode || cannonMode) && !handOut && (!FlxG.keys.RIGHT && !FlxG.keys.LEFT)) {
				time += FlxG.elapsed;
			} else if ((!bodyMode && !cannonMode) && hand.velocity.x == 0 && hand.velocity.y == 0) {
				time += FlxG.elapsed;
			} else {
				time = 0;
			}
			if (time > IDLE_TIME) {
				time = IDLE_TIME;
			}
			if (FlxG.paused) {
				time = 0;
			}
			//FlxG.log(time);
			
			//if (SOUND_ON) {Registry.update();}
			Registry.update();
			
			// escape for debugging (should remove later)
			if (FlxG.keys.justPressed("ESCAPE") && Registry.DEBUG_ON) {
				FlxG.switchState(new LevelSelect);
			}
			
			if (hand.x > FlxG.worldBounds.right || hand.x < FlxG.worldBounds.left ||
				hand.y > FlxG.worldBounds.bottom || hand.y < FlxG.worldBounds.top) {
				if (doorsDead || Registry.levelNum == 5) {
					goToNextLevel();
				} else {
					FlxG.resetState();
				}
			}
			
			if (FlxG.keys.justPressed("DOWN") && controlDirs.indexOf(FlxObject.DOWN) == -1) {
				controlDirs.push(FlxObject.DOWN);
			}
			if (FlxG.keys.justPressed("UP") && controlDirs.indexOf(FlxObject.UP) == -1) {
				controlDirs.push(FlxObject.UP);
			}
			if (FlxG.keys.justPressed("RIGHT") && controlDirs.indexOf(FlxObject.RIGHT) == -1) {
				controlDirs.push(FlxObject.RIGHT);
			}
			if (FlxG.keys.justPressed("LEFT") && controlDirs.indexOf(FlxObject.LEFT) == -1) {
				controlDirs.push(FlxObject.LEFT);
			}
			if (FlxG.keys.justReleased("DOWN")) {
				controlDirsRemove(FlxObject.DOWN);
			}
			if (FlxG.keys.justReleased("UP")) {
				controlDirsRemove(FlxObject.UP);
			}
			if (FlxG.keys.justReleased("RIGHT")) {
				controlDirsRemove(FlxObject.RIGHT);
			}
			if (FlxG.keys.justReleased("LEFT")) {
				controlDirsRemove(FlxObject.LEFT);
			}
			if (controlDirs.length == 0) {
				resetTempGround();
			}
			
			//time += FlxG.elapsed;
			// PRECONDITION: if bodyMode, then curBody < uint.MAX_VALUE
			var body:FlxSprite;
			var bodyGear:FlxSprite;
			var bodyHead:FlxSprite;
			var armBase:FlxSprite;

			var enteringCannon:Boolean = false;
			var enteringBody:Boolean = false;
			
			if (!bodyMode && !cannonMode) {
				curBody = handOverlapsBody();
				curCannon = handOverlapsCannon();
			
				if (curBody < uint.MAX_VALUE && curCannon < uint.MAX_VALUE) {
					var closeBody:FlxSprite = bodyGroup.members[curBody];
					var closeCannon:FlxSprite = cannonGroup.members[curCannon];
					var handToBody:Number = Math.pow(hand.x + hand.width/2.0 - closeBody.x - closeBody.width/2.0,2) + Math.pow(hand.y + hand.height/2.0 - closeBody.y - closeBody.height/2.0,2);
					var handToCannon:Number = Math.pow(hand.x + hand.width/2.0 - closeCannon.x - closeCannon.width/2.0,2) + Math.pow(hand.y + hand.height/2.0 - closeCannon.y - closeCannon.height/2.0,2);
					if (handToCannon < handToBody) {enteringCannon = true;}
					else {enteringBody = true;}
				} else if (curBody < uint.MAX_VALUE) {enteringBody = true;}
				else if (curCannon < uint.MAX_VALUE) {enteringCannon = true;}
			}
			
			var touchingMetal:Boolean = (onGround && isMetalInDir(hand, hand.facing, 4)); //USE ONLY FOR GRAPHICS + AUDIO; THIS MAY CHANGE DURING CONTROLS SECTION
			
			if (enteringBody || bodyMode) {
				body = bodyGroup.members[curBody];
				bodyGear = bodyGearGroup.members[curBody];
				bodyHead = bodyHeadGroup.members[curBody];
				armBase = bodyArmBaseGroup.members[curBody];
			} else if (enteringCannon || cannonMode) {
				body = cannonGroup.members[curCannon];
				armBase = cannonArmBaseGroup.members[curCannon];
			}
			
			/*
			if (bodyMode) {
				body = bodyGroup.members[curBody];
				bodyGear = bodyGearGroup.members[curBody];
				bodyHead = bodyHeadGroup.members[curBody];
				armBase = bodyArmBaseGroup.members[curBody];
			} if (cannonMode) {
				body = cannonGroup.members[curCannon];
				armBase = cannonArmBaseGroup.members[curCannon];
			}*/
			
			if (hand.overlapsPoint(exitPoint)) {
				touchedExitPoint = true;
			}
			
			if (exitOn) {
				if (exitPoint.x < FlxG.camera.scroll.x || exitPoint.x >= FlxG.camera.scroll.x + FlxG.width ||
					exitPoint.y < FlxG.camera.scroll.y || exitPoint.y >= FlxG.camera.scroll.y + FlxG.height) {
					if (!exitArrow.visible) {
						if (!touchedExitPoint) {
							exitArrow.visible = true;
						}
					}
					var exitX:Number = exitPoint.x - FlxG.camera.scroll.x - FlxG.width/2;
					var exitY:Number = exitPoint.y - FlxG.camera.scroll.y - FlxG.height/2;
					var exitA:Number = Math.atan2(exitY, exitX);
					exitArrow.angle = exitA*180/Math.PI;
					exitArrow.x = FlxG.width/2 + Math.cos(exitA) * exitRad - exitArrow.width/2;
					exitArrow.y = FlxG.height/2 + Math.sin(exitA) * exitRad - exitArrow.height/2;
				} else if (exitArrow.visible) {
					exitArrow.visible = false;
				}
			}
			
			if (Registry.cameraFollowsHand) {
				if (onGround) {
					camTag.angle += angleDifference(camAngle, camTag.angle)/8.0;
				} else {
					camTag.angle += angleDifference(hand.angle, camTag.angle)/8.0;
				}
				FlxG.camera.angle = -camTag.angle;
			} else if (camTag.angle != camAngle) {
				camTag.angle += (-camTag.angle + camAngle)/8.0;
				FlxG.camera.angle = -camTag.angle;
			}
			
			/*
			// marker line
			markerLine.fill(0x00000000);
			*/
			if (bodyMode) {
				if (!handOut && !handIn) {// && !handOut && !handIn) {
					rad = arrow.angle*Math.PI/180;
					var startX:Number = hand.x+hand.width/2.0;
					var startY:Number = hand.y+hand.height/2.0;
					var endX:Number = startX + GRAPPLE_LENGTH * Math.cos(rad);
					var endY:Number = startY + GRAPPLE_LENGTH * Math.sin(rad);
					//markerLine.drawLine(startX,startY,endX,endY,0xFFad0222,2);
					
					
					camTag.x += (-camTag.x + endX)/44.0;
					camTag.y += (-camTag.y + endY)/44.0;
					
					// make objects glow
					
					
				}/* else { // if (bodyMode && (body.velocity.x != 0 || body.velocity.y !=0)) {
					
					endX = hand.x + (body.x - hand.x)*0.25;
					endY = hand.y + (body.y - hand.y)*0.25;
					camTag.x += (-camTag.x + endX)/8.0;
					camTag.y += (-camTag.y + endY)/8.0;
				}*/
			} else {
				camTag.x += (-camTag.x + hand.x)/8.0;
				camTag.y += (-camTag.y + hand.y)/8.0;
			} //
			
			/*
			var tagCenter:FlxPoint = camTag.getScreenXY();
			var dScreenX:Number = FlxG.width/2.0 - tagCenter.x;
			var dScreenY:Number = FlxG.height/2.0 - tagCenter.y;
			FlxG.log(dScreenX + ',' + dScreenY);
			FlxG.camera.target.x += dScreenX;
			FlxG.camera.target.y += dScreenY;
			//camTag.y -= dScreenY;
			*/
			
			/* else if (cannonMode) {
				rad = arrow.angle*Math.PI/180;
				startX = hand.x+hand.width/2.0;
				startY = hand.y+hand.height/2.0;
				endX = startX + GRAPPLE_LENGTH * Math.cos(rad) / 4.0;
				endY = startY + GRAPPLE_LENGTH * Math.sin(rad) / 4.0;
				markerLine.drawLine(startX,startY,endX,endY,0xFFad0222,2);
			}
			markerLine.alpha = 0.22 + 0.78*pulseTimer/pulseTimeMax;
			*/
			/*
			// hint arrow
			hintArrow.fill(0x00000000);
			
			
			if (doorsDead) {
				startX = hand.x+hand.width/2.0;
				startY = hand.y+hand.height/2.0;
				endX = exitPoint.x;
				endY = exitPoint.y;
				hintArrow.drawLine(startX,startY,endX,endY,0xFFad0222,2);
			}
			*/
			
			// hint system
			//theta = (hand.angle)*Math.PI/180.0;
			
			hint.x = hand.x + hand.width - hint.width/2.0;// + (hint.width/2.0)*Math.sin(theta);
			hint.y = hand.y + hand.height - hint.height;// - (hint.height/2.0)*Math.cos(theta);
			//hint.angle = hand.angle;
			
			// marker glow (for hand overlapping)
			hand.color = 0xffffff;
			for (var mmm:String in bodyGroup.members) {
				bodyGroup.members[mmm].color = 0xaaaaaa;
				bodyArmBaseGroup.members[mmm].color = 0xffffff;
				bodyGearGroup.members[mmm].color = 0xaaaaaa;
				bodyHeadGroup.members[mmm].color = 0xaaaaaa;
			}
			for (mmm in cannonGroup.members) {
				cannonGroup.members[mmm].color = 0xaaaaaa;
				cannonArmBaseGroup.members[mmm].color = 0xffffff;
			}
			
			var handOnJumpGroup:Boolean = false;
			for (var tt:uint = 0; tt < jumpHintGroup.length; tt++) {
				if (hand.overlaps(jumpHintGroup.members[tt])) {
					handOnJumpGroup = true;
				}
			}
			
			var pulseNum:Number = int((pulseTimer/pulseTimeMax)*5) + 7;
			if (pulseNum >= 15) {pulseNum = 15;}
			if (pulseNum <= 7) {pulseNum = 7;}
			col = pulseNum*Math.pow(16,4) + pulseNum*Math.pow(16,5);
			
			if (!cannonMode && !bodyMode) {
				
				if (time >= IDLE_TIME) {
					hint.play("enter");
				} else if ((enteringBody || enteringCannon ) && Registry.neverEnteredBodyOrCannon) {
					hint.play("Z");
				}
				// arrow hint (uncomment if you want it, I think it's kind of ugly though...)
				/*
				else if (Registry.neverCrawled) {
					if (hand.velocity.x != 0 || hand.velocity.y != 0 && onGround) {
						Registry.neverCrawled = false;
					} else {
						hint.play("arrows");
					}
				}
				*/
				//
				else if (Registry.neverJumped && handOnJumpGroup && hand.angle == 90) {
					hint.play("X");
				} else {
					hint.play("idle");
				}
				
				if (enteringBody) {
					hand.color = col;
					body.color = col;
					armBase.color = col;
					bodyGear.color = col;
					bodyHead.color = col;
				} else if (enteringCannon) {
					hand.color = col;
					body.color = col;
					armBase.color = col;
				}
			} else if (cannonMode || bodyMode) {
				if (time >= IDLE_TIME) {
					hint.play("enter");
				} else if (Registry.neverAimedBodyOrCannon) {
					hint.play("arrows");
				} else if (Registry.neverFiredBodyOrCannon) {
					hint.play("left X right");
				} else {
					hint.play("idle");
				}
			}
			if (FlxG.paused) {
				hint.play("idle");
			}
			
			/* Begin Audio */
			if (Registry.SOUND_ON) {
				
				// Something's not quite right here...
				// The hand jumped
				if ((!bodyMode && !cannonMode) && FlxG.keys.justPressed(ACTION_KEY) && /*hand.touching*/onGround && hand.facing != FlxObject.DOWN) {
					jumpSound.play();
				} else if ((!bodyMode && !cannonMode) && hand.touching) {
					jumpSound.stop();
				}
				
				// The hand is crawling on wood or metal
				if ((!bodyMode &&!cannonMode) && /*hand.touching*/onGround && (hand.velocity.x != 0 || hand.velocity.y != 0)) {
					/*if (lastTouchedWood && !lastTouchedDirt) {
						metalCrawlSound.stop();
						dirtFootstepsSound.stop();
						woodCrawlSound.play();
					} else if (lastTouchedDirt) {
						metalCrawlSound.stop();
						woodCrawlSound.stop();
						dirtFootstepsSound.play();
					} else {
						woodCrawlSound.stop();
						dirtFootstepsSound.stop();
						metalCrawlSound.play();
						
					}*/
					if (touchingMetal) {
						woodCrawlSound.stop();
						dirtFootstepsSound.stop();
						metalCrawlSound.play();
					} else if (lastTouchedDirt) {
						metalCrawlSound.stop();
						woodCrawlSound.stop();
						dirtFootstepsSound.play();
					} else {
						metalCrawlSound.stop();
						dirtFootstepsSound.stop();
						woodCrawlSound.play();
					}
				} else {
					woodCrawlSound.stop();
					metalCrawlSound.stop();
					dirtFootstepsSound.stop();
				}
				// The hand is in the body, aiming
				if ((bodyMode || cannonMode) && !handOut && !handIn) {
					grappleExtendSound.stop();
					if ((FlxG.keys.RIGHT || FlxG.keys.LEFT) && -270 < hand.angle - body.angle && hand.angle - body.angle < -90) {
						robodyAimSound.play();
					} else {
						robodyAimSound.stop();
					}
				}
					// The hand is launching out of the body
				else if (bodyMode && (handOut || handIn)) {
					robodyLandOnWallSound.stop();
					robodyAimSound.stop();
					if (hand.velocity.x !=0 || hand.velocity.y != 0 || body.velocity.x != 0 || body.velocity.y != 0) {
						grappleExtendSound.play();
					} else {
						grappleExtendSound.stop();
					}
				} else {
					grappleExtendSound.stop();
					robodyAimSound.stop();
				}
				
				// The body just hit a wall
				if (bodyMode && handIn && hand.overlaps(body) && ((hand.angle < body.angle - 270) || (body.angle - 90 < hand.angle))) {
					robodyLandOnWallSound.play();
				}
				
				// hand electricity
				if (/*hand.touching && !lastTouchedWood*/touchingMetal) {
					ambientElectricalHumSound.play();
				} else {
					ambientElectricalHumSound.stop();
				}
				
				// cannon fire
				if (cannonMode && FlxG.keys.justPressed("X")) {
					cannonShotSound.stop();
					cannonShotSound.play();
				}
				
				// hand landed
				//if ((lastVel.x != 0 && lastVel.y != 0) || handFalling) {
				if (!lastTouchedDirt) {
					if (hand.justTouched(FlxObject.ANY)) {
						if (!lastTouchedWood) {
							handLandingOnMetalSound.stop();
							handLandingOnDirtSound.stop();
							handLandingOnMetalSound.play();
						} else {
							handLandingOnNonstickMetalSound.stop();
							handLandingOnDirtSound.stop();
							handLandingOnNonstickMetalSound.play();
						}
					}
				} else if (hand.justTouched(FlxObject.ANY)) {
					handLandingOnNonstickMetalSound.stop();
					handLandingOnMetalSound.stop();
					handLandingOnDirtSound.play();
				}
				//}
				
				
				// button press, gears, steam
				for (var qq:uint = 0; qq < buttonGroup.length; qq++) {
					var button:FlxSprite = buttonGroup.members[qq];
					var buttonState:Boolean = buttonStateArray[qq];
					if (button.frame != BUTTON_PRESSED && (hand.overlaps(button) && !buttonState)) {
						buttonPressSound.stop();
						buttonPressSound.play();
					}
					/*
					if (button.frame == 2) {
						ambientGearsSound.play();
					}
					if (button.frame == 3) {
						ambientSteamSound.play();
					}
					*/
					
				}
				
				for (qq = 0; qq < steams.length; qq++) {
					if (steams.members[qq].frame == 1) {
						ambientSteamSound.stop();
						ambientSteamSound.play();
					}
				}
				
				
				// door open
				for (var ab:int = doorGroup.length-1; ab >= 0; ab--) {
					if (doorGroup.members[ab].frame == 1) {
						doorOpenSound.stop();
						doorOpenSound.play();
						ambientGearsSound.play();
					}
				}
			}
			/* End Audio */
			
			// to time the fall for the different falling rot, really belongs with anim stuff
			if (/*hand.touching*/onGround) {handFalling = false; timeFallen = 0;}
			timeFallen += FlxG.elapsed;
			
			// less janky way of getting gears/heads to move with body...
			if (bodyMode) {
				
				var theta:Number = (body.angle-90)*Math.PI/180.0;
				
				bodyHead.x = body.x + body.width/2.0 - bodyHead.width/2.0 + (bodyHead.height*1.5)*Math.cos(theta);
				bodyHead.y = body.y + body.height/2.0 - bodyHead.height/2.0 + (bodyHead.height*1.5)*Math.sin(theta);
				bodyHead.angle = body.angle;
				
				bodyGear.x = body.x + body.width/2.0 - bodyGear.width/2.0 + (bodyGear.width/2.0)*Math.cos(theta-Math.PI/2.0);
				bodyGear.y = body.y + body.height/2.0 - bodyGear.height/2.0 + (bodyGear.height/2.0)*Math.sin(theta-Math.PI/2.0);
				bodyGear.angle = -hand.angle;
			}
			if (bodyMode || cannonMode) {
				if (!handOut) {
					armBase.angle = hand.angle - 180;
				}
				armBase.x = body.x;
				armBase.y = body.y;
			}
			
			// make arrow pulse
			exitArrow.alpha = (6.0 - exitArrow.frame)/6.0 + 0.22;
			
			// Press Buttons!
			for (var mm:uint = 0; mm < buttonGroup.length; mm++) {
				button = buttonGroup.members[mm];
				buttonState = buttonStateArray[mm];
				var bangFrame:Number = buttonBangGroup.members[mm].frame;
				buttonBangGroup.members[mm].alpha = (6.0 - bangFrame)/6.0 + 0.22;
				if (button.frame != BUTTON_PRESSED && (hand.overlaps(button) && !buttonState)) { // should change this to make it only recognize the space where the button is visually
					button.frame = BUTTON_PRESSED;
					buttonStateArray[mm] = true;
					buttonReactionArray[mm]();
					buttonBangGroup.members[mm].kill();
					for (var bb:String in doorGroup.members) {
						var door:FlxSprite = doorGroup.members[bb];
						if (door.frame == 13) {door.play("pulse 1");}
						else if (14 <= door.frame && door.frame <= 17) {door.play("pulse 2");}
					}
				}
			}
			
			// Bring midground to life
			if (reinvigorated) {
				
				// Steam
				
				// Spin Gears // should eventually make them accel into spin
				var gear:FlxSprite;
				for (var jjj:String in gearInGroup.members) {
					gear = gearInGroup.members[jjj];
					gear.angle += 0.5*(64.0/gear.width);
					if (gear.angle > 360) {gear.angle = 0;}
				}
				for (jjj in gearOutGroup.members) {
					gear = gearOutGroup.members[jjj];
					gear.angle -= 0.5*(64.0/gear.width);
					if (gear.angle < 0) {gear.angle = 360;}
				}
			}
			
			/* Begin Animations */
			// The hand is not attached to a body
			if (!bodyMode && !cannonMode) {
				// The hand is about to mount a body
				if (FlxG.keys.justPressed(BODY_KEY)) {
					//bodyTargetAngle = hand.angle;
				}
				// The hand is crawling along a flat surface
				if (/*hand.touching*/onGround) {
					// Set the Angle of the hand
					if (hand.facing == FlxObject.DOWN) {hand.angle = 0;}
					else if (hand.facing == FlxObject.LEFT && !lastTouchedWood) {hand.angle = 90;}
					else if (hand.facing == FlxObject.UP && !lastTouchedWood) {hand.angle = 180;}
					else if (hand.facing == FlxObject.RIGHT && !lastTouchedWood) {hand.angle = 270;}
					// The hand is changing direction
					// (because the sprite's not ambidexterous)
					if (playerIsPressing(FlxObject.LEFT)) {handDir = FlxObject.LEFT;}
					if (playerIsPressing(FlxObject.RIGHT)) {handDir = FlxObject.RIGHT;}
					// Make the hand crawl or idle
					// (this relies on the facing and direction because the sprite's not ambidexterous)
					if (handDir == FlxObject.LEFT) {
						if ((hand.facing == FlxObject.UP && hand.velocity.x > 0) ||
							(hand.facing == FlxObject.DOWN && hand.velocity.x < 0) ||
							(hand.facing == FlxObject.LEFT && hand.velocity.y < 0) ||
							(hand.facing == FlxObject.RIGHT && hand.velocity.y > 0)) {
							hand.play("crawl left");
						} else if (hand.velocity.x == 0 && hand.velocity.y == 0) {
							hand.play("idle left");
						}
					} else if (handDir == FlxObject.RIGHT) {
						if ((hand.facing == FlxObject.UP && hand.velocity.x < 0) ||
							(hand.facing == FlxObject.DOWN && hand.velocity.x > 0) ||
							(hand.facing == FlxObject.LEFT && hand.velocity.y > 0) ||
							(hand.facing == FlxObject.RIGHT && hand.velocity.y < 0)) {
							hand.play("crawl right");
						} else if (hand.velocity.x == 0 && hand.velocity.y == 0) {
							hand.play("idle right");
						}
					}
					// The hand is about to jump from a flat surface
					if (FlxG.keys.justPressed(ACTION_KEY) && (hand.facing != FlxObject.DOWN || Registry.jumping)) {
						if (handDir == FlxObject.LEFT) {hand.play("fall left");} //<- placeholder {hand.play("jump left");}
						else if (handDir == FlxObject.RIGHT) {hand.play("fall right");} //<- placeholder {hand.play("jump right");}
					}
				}
				// The hand is rounding a convex corner
				else if (!handFalling) { // (!lastTouchedWood)
					
					if (handDir == FlxObject.LEFT) {
						/*if ((hand.facing == FlxObject.UP && hand.angle > 90) ||
						(hand.facing == FlxObject.DOWN && hand.angle > -90) || <- this line's not working
						(hand.facing == FlxObject.LEFT && hand.angle > 0) ||
						(hand.facing == FlxObject.RIGHT && hand.angle > 180)) {
						*/
						hand.angle -= 2.2;
						hand.play("fall left"); //<- placeholder {hand.play("jump left");
						//}
					} else if (handDir == FlxObject.RIGHT) {
						/*if ((hand.facing == FlxObject.UP && hand.angle < 270) ||
						(hand.facing == FlxObject.DOWN && hand.angle < 90) ||
						(hand.facing == FlxObject.LEFT && hand.angle < 180) ||
						(hand.facing == FlxObject.RIGHT && hand.angle < 360)) { <- this line's not working
						*/
						hand.angle += 2.2;
						hand.play("fall right"); //<- placeholder {hand.play("jump right");
						//}
					}
				}
				
				/*
				else if (!onGround && lastTouchedWood) {
					if (handDir == FlxObject.LEFT) {
						hand.play("fall left"); //<- placeholder {hand.play("jump left");
						//}
					} else if (handDir == FlxObject.RIGHT) {
						hand.play("fall right"); //<- placeholder {hand.play("jump right");
						//}
					}
				}
				*/
				
				/*
				// The hand ran off a wooden platform
				else if (lastTouchedWood) {
					if (handDir == FlxObject.LEFT) {
						hand.play("fall left");
					} else if (handDir == FlxObject.RIGHT) {
						hand.play("fall right");
					}
				} */
				// The hand is falling (with style!)
				else {
					
					if (hand.angle > 0 && hand.angle < 360) {
						if (handDir == FlxObject.LEFT) {
							hand.play("fall left");
							hand.angle += 10;
						} else if (handDir == FlxObject.RIGHT) {
							hand.play("fall right");
							hand.angle -= 10;
						}
					}
					else if (timeFallen > 0.44) {
						
						var vSquared:Number = Math.pow(hand.velocity.x,2) + Math.pow(hand.velocity.y,2);
						
						if (handDir == FlxObject.LEFT) {hand.angle += vSquared/8000;}
						else if (handDir == FlxObject.RIGHT) {hand.angle -= vSquared/8000;}
					}
				}
			}
			
			// The hand is attached to a body
			else if (bodyMode || cannonMode) {
				// The hand is idling in the body
				if (!handOut && !handIn) {
					hand.angle = arrow.angle - 90;
					body.angle = bodyTargetAngle;
					if (body.angle == 0) {body.facing = FlxObject.DOWN;}
					else if (body.angle == 270) {body.facing = FlxObject.RIGHT;}
					else if (body.angle == 180) {body.facing = FlxObject.UP;}
					else if (body.angle == 90) {body.facing = FlxObject.LEFT;}
					
					if (handDir == FlxObject.LEFT) {hand.play("idle body left");}
					else {hand.play("idle body right");}
					// The hand is about to dismount 
					if (FlxG.keys.justPressed(BODY_KEY)) {
						// play falling animations?
					}
					// Keep arms hidden
					for (var i:String in arms.members) {
						arms.members[i].visible = false;
					}
				}
				// The hand is extended
				else if (handOut || handIn) {
					
					
					if (/*FlxG.keys.SPACE*/handOut && /*!hand.touching*/ !touchingMetal) {
						if (handDir == FlxObject.LEFT) {hand.play("extend left");}
						else {hand.play("extend right");} // maybe there should be an animation for extending?
					} else {
						if (handDir == FlxObject.LEFT) {hand.play("idle body left");}
						else {hand.play("idle body right");}
					}
					
					// Properly space and rotate the arm segments
					var deltaX:Number = -body.x + hand.x;
					var deltaY:Number = -body.y + hand.y;
					
					var arm:FlxSprite;
					var stupid:int = 0;
					for (var jj:String in arms.members) {
						arm = arms.members[jj];
						arm.visible = true;
						arm.x = body.x + deltaX*(stupid)/numArms + hand.frameWidth/2.0-arm.frameWidth/2.0;
						arm.y = body.y + deltaY*(stupid)/numArms + hand.frameHeight/2.0-arm.frameHeight/2.0;
						stupid = stupid + 1;
						arm.angle = shootAngle + 90;
					}
					
					// The hand has come in contact with a wall
					if (/*hand.touching*/touchingMetal && !lastTouchedWood) {
						if (hand.isTouching(FlxObject.DOWN)) {hand.angle = 0;}
						else if (hand.isTouching(FlxObject.LEFT)) {hand.angle = 90;}
						else if (hand.isTouching(FlxObject.UP)) {hand.angle = 180;}
						else if (hand.isTouching(FlxObject.RIGHT)) {hand.angle = 270;}
						// The arm is retracting while holding
						if (/*!FlxG.keys.SPACE*/handIn && hand.facing != body.facing) {
							//bodyTargetAngle = hand.angle; 
							//to prevent corner bug, this ^ needs to be set when the body begins to be pulled in (otherwise handIn is false by here if the pulling takes 1 frame)
							if (bodyTargetAngle > body.angle) {
								body.angle += 4;
							} else if (bodyTargetAngle < body.angle) {
								body.angle -= 4;
							}
						}
					}
					// The hand is retracting without having touched anything
					if (/*!FlxG.keys.SPACE*/handIn && /*!hand.touching*/!touchingMetal) {
						
					}
				}
			}
			
			if (/*hand.touching && !lastTouchedWood*/touchingMetal) {
				electricity.play("electricute");
				electricity.angle = hand.angle;
				electricity.x = hand.x;
				electricity.y = hand.y;
				electricity.alpha = (6.0 - electricity.frame)/6.0 + 0.22;
				//electricity.alpha += electricityNum*0.022;
				//if (electricity.alpha <= 0.5 || electricity.alpha >= 1) {
					//electricityNum *= -1;
				//}
			} else {
				electricity.play("stop");
				electricity.alpha = 1;
			}
			
			for (var mn:uint = 0; mn < steams.length; mn++) {
				if (steamsNumberArray[mn] < steamsNumber && int(10*steamTimer) == 10*(steamsNumberArray[mn])) {
					steams.members[mn].play("puff");
					steams.members[mn].x = steamsStartPoint[mn].x - 4.4*steamsDXY[mn].x*steams.members[mn].frame;
					steams.members[mn].y = steamsStartPoint[mn].y - 4.4*steamsDXY[mn].y*steams.members[mn].frame;
					steams.members[mn].alpha = 1 - steams.members[mn].frame/3.0 + 0.5;
				}
			}
			
			//FlxG.log(steamTimer);
			
			/* End Animations */
			
			if (bodyMode || cannonMode) {
				
				// Fixes some bugs with grappling, maybe also redundant?
				if (!hand.overlaps(body)) {
					body.allowCollisions = FlxObject.NONE;
				} else {
					body.allowCollisions = FlxObject.ANY;
					/*if (body.justTouched(FlxObject.ANY)) {
						body.x = hand.x;
						body.y = hand.y;
						setDir(body,hand.facing);
					}
					if (hand.velocity.x == 0 && hand.velocity.y == 0 && body.velocity.x == 0 && body.velocity.y == 0 && !hand.touching) {
						hand.x = body.x;
						hand.y = body.y;
					}*/
				}
				
				body.velocity.x = 0;
				body.velocity.y = 0;
				hand.velocity.x = 0;
				hand.velocity.y = 0;
				var diffX:Number = hand.x + hand.width/2.0 - body.x - body.width/2.0;
				var diffY:Number = hand.y + hand.width/2.0 - body.y - body.height/2.0;
				if (handOut) {
					//rad = Math.atan2(diffY, diffX);
					//arrow.angle = 180*rad/Math.PI;
					//rad = arrow.angle*Math.PI/180;
					if (hand.touching <= 0 && Math.pow(diffX, 2) + Math.pow(diffY, 2) < Math.pow(GRAPPLE_LENGTH,2)) {
						hand.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
						hand.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
					} else {
						handOut = false;
						handIn = true;
					}
				} if (handIn) {
					//rad = Math.atan2(diffY, diffX);
					if (/*hand.touching > 0 && hand.facing == hand.touching*/hand.facing != body.facing) {
						bodyTargetAngle = hand.angle;
						body.velocity.x = GRAPPLE_SPEED * Math.cos(/*rad*/Math.atan2(diffY, diffX));
						body.velocity.y = GRAPPLE_SPEED * Math.sin(/*rad*/Math.atan2(diffY, diffX));
						showArrow();
					} else {
						hand.velocity.x = -GRAPPLE_SPEED * Math.cos(rad);
						hand.velocity.y = -GRAPPLE_SPEED * Math.sin(rad);
						arrow.angle = shootAngle;
						//handReturnedToBody = true;
						
					}
					if (Math.abs(diffX) <= Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.cos(rad)) + EPSILON &&
						Math.abs(diffY) <= Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.sin(rad)) + EPSILON) {
						handIn = false;
						hand.velocity.x = 0;
						hand.velocity.y = 0;
						hand.acceleration.x = 0;
						hand.acceleration.y = 0;
						body.velocity.x = 0;
						body.velocity.y = 0;
						body.acceleration.x = 0;
						body.acceleration.y = 0;
						if (hand.facing == body.facing) {
							hand.x = body.x;
							hand.y = body.y;
						} else {
							body.x = hand.x;
							body.y = hand.y;
							setDir(body,hand.facing);
							showArrow();
						}
						markerEnd.visible = true;
						updateRaytrace(arrow.angle);
						hand.allowCollisions = FlxObject.ANY;
					}
				} if (!handOut && !handIn) {
					if (playerIsPressing(FlxObject.LEFT)) {
						arrow.angle -= ROTATE_RATE;
						if (arrow.angle < arrowStartAngle - 90) {arrow.angle = arrowStartAngle - 90;}
						
						if (Registry.neverAimedBodyOrCannon) {
							Registry.neverAimedBodyOrCannon = false;
						}
						updateRaytrace(arrow.angle);
					} if (playerIsPressing(FlxObject.RIGHT)) {
						arrow.angle += ROTATE_RATE;
						if (arrow.angle > arrowStartAngle + 90) {arrow.angle = arrowStartAngle + 90;}
						
						if (Registry.neverAimedBodyOrCannon) {
							Registry.neverAimedBodyOrCannon = false;
						}
						updateRaytrace(arrow.angle);
					}
					if (FlxG.keys.justPressed(BODY_KEY)) {
						if (bodyMode) {
							lastTouchedWood = false;
						}
						bodyMode = false;
						cannonMode = false;
						markerEnd.visible = false;
						setDir(hand, body.facing);
						lastGround = body.facing;
						if (Registry.handRelative) {
							tempGround = FlxObject.DOWN;
						} else {
							tempGround = body.facing;
						}
					}
					rad = Math.PI*arrow.angle/180;
					if (FlxG.keys.justPressed(ACTION_KEY) && bodyMode) {
						shootAngle = arrow.angle;
						handOut = true;
						markerEnd.visible = false;
						hand.maxVelocity.x = Number.MAX_VALUE;
						hand.maxVelocity.y = Number.MAX_VALUE;
						hand.drag.x = 0;
						hand.drag.y = 0;
						hand.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
						hand.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
						hand.allowCollisions = 0;
						if (hand.velocity.x > 0) {
							hand.allowCollisions |= FlxObject.RIGHT;
						} else if (hand.velocity.x < 0) {
							hand.allowCollisions |= FlxObject.LEFT;
						}
						if (hand.velocity.y > 0) {
							hand.allowCollisions |= FlxObject.DOWN;
						} else if (hand.velocity.y < 0) {
							hand.allowCollisions |= FlxObject.UP;
						}
						
						if (Registry.neverFiredBodyOrCannon) {
							Registry.neverFiredBodyOrCannon = false;
						}
						
					} else if (FlxG.keys.justPressed(ACTION_KEY) && cannonMode) {
						cannonMode = false;
						//rad = Math.PI*arrow.angle/180;
						
						setDir(hand,FlxObject.DOWN,true);
						hand.velocity.x = CANNON_VEL * Math.cos(rad);
						hand.velocity.y = 1.5 * CANNON_VEL * Math.sin(rad);
						
						if (Registry.neverFiredBodyOrCannon) {
							Registry.neverFiredBodyOrCannon = false;
						}
						
					}
				}
			} else {
				if (FlxG.keys.justPressed(BODY_KEY)) {
					if (enteringBody) {
						
						bodyMode = true;
						lastTouchedWood = false;
						handFalling = false;
						onGround = true;
						markerEnd.visible = true;
						
						hand.velocity.x = 0;
						hand.velocity.y = 0;
						hand.acceleration.x = 0;
						hand.acceleration.y = 0;
						hand.x = body.x;
						hand.y = body.y;
						
						bodyTargetAngle = body.angle;
						hand.facing = body.facing;
						
						showArrow();
						updateRaytrace(arrow.angle);
						
						if (Registry.neverEnteredBodyOrCannon) {
							Registry.neverEnteredBodyOrCannon = false;
						}
						
					} else if (enteringCannon) {
						
						cannonMode = true;
						lastTouchedWood = false;
						handFalling = false;
						onGround = true;
						lastGround = body.facing;
						if (Registry.handRelative) {
							tempGround = FlxObject.DOWN;
						} else {
							tempGround = body.facing;
						}
						
						hand.velocity.x = 0;
						hand.velocity.y = 0;
						hand.acceleration.x = 0;
						hand.acceleration.y = 0;
						hand.x = body.x;
						hand.y = body.y;
						
						bodyTargetAngle = body.angle;
						hand.facing = body.facing;
						
						showArrow();
						
						if (Registry.neverEnteredBodyOrCannon) {
							Registry.neverEnteredBodyOrCannon = false;
						}
						
					}
				} else {
					if (onGround) {
						if (hand.facing == FlxObject.DOWN || hand.facing == FlxObject.UP) {
							hand.acceleration.x = 0;
						} else if (hand.facing == FlxObject.LEFT || hand.facing == FlxObject.RIGHT) {
							hand.acceleration.y = 0;
						}
						if (playerIsPressing(FlxObject.LEFT)) {
							if (handIsFacing(FlxObject.DOWN) && !handIsFacing(FlxObject.LEFT)) {
								hand.acceleration.x = -MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.LEFT) && !handIsFacing(FlxObject.UP)) {
								hand.acceleration.y = -MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.UP) && !handIsFacing(FlxObject.RIGHT)) {
								hand.acceleration.x = MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.RIGHT)) {
								hand.acceleration.y = MOVE_ACCEL;
							}
						} if (playerIsPressing(FlxObject.RIGHT)) {
							if (handIsFacing(FlxObject.DOWN) && !handIsFacing(FlxObject.RIGHT)) {
								hand.acceleration.x = MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.RIGHT) && !handIsFacing(FlxObject.UP)) {
								hand.acceleration.y = -MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.UP) && !handIsFacing(FlxObject.LEFT)) {
								hand.acceleration.x = -MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.LEFT)) {
								hand.acceleration.y = MOVE_ACCEL;
							}
						} if (FlxG.keys.justPressed(ACTION_KEY)) {
							if (Registry.jumping && handIsFacing(FlxObject.DOWN)) {
								jumpStuff();
								hand.velocity.y = -FLOOR_JUMP_VEL;
							} else if (handIsFacing(FlxObject.UP)) {
								jumpStuff();
								hand.velocity.y = CEIL_JUMP_VEL;
							} else if (handIsFacing(FlxObject.LEFT)) {
								jumpStuff();
								hand.velocity.x = WALL_JUMP_VEL;
							} else if (handIsFacing(FlxObject.RIGHT)) {
								jumpStuff();
								hand.velocity.x = -WALL_JUMP_VEL;
							}
						}
					}
				}
			}
			
			if (bodyMode && !handOut && !handIn) {
				theta = (arrow.angle)*Math.PI/180.0;
				var dotNum:int = int(Math.sqrt(Math.pow(markerEnd.x-body.x, 2) + Math.pow(markerEnd.y-body.y, 2)))/DOT_SPACING;
				for (var n:int = 0; n <= dotNum; n++) {
					if (bodyMarkerGroup.length <= n) {
						bodyMarkerGroup.add(new FlxSprite().makeGraphic(2, 2, 0xffffffff));
					}
					if (n > 0) {
						bodyMarkerGroup.members[n].color = bodyMarkerGroup.members[n-1].color;
					}
					bodyMarkerGroup.members[n].x = body.getMidpoint().x + Math.cos(theta)*DOT_SPACING*(n + bodyMarkerTimer);
					bodyMarkerGroup.members[n].y = body.getMidpoint().y + Math.sin(theta)*DOT_SPACING*(n + bodyMarkerTimer);
					bodyMarkerGroup.members[n].alpha = 0.22 + 0.78*pulseTimer/pulseTimeMax;
				}
				for (; n < bodyMarkerGroup.length; n++) {
					bodyMarkerGroup.members[n].alpha = 0;
				}
				bodyMarkerGroup.visible = true;
			} else {
				bodyMarkerGroup.visible = false;
			}
			if (cannonMode) {
				theta = (arrow.angle)*Math.PI/180.0;
				cannonMarkerLine.x = hand.x + hand.width/2.0 + (cannonMarkerLine.height/2.0)*Math.cos(theta);
				cannonMarkerLine.y = hand.y + hand.height/2.0 - cannonMarkerLine.height/2.0 + (cannonMarkerLine.height/2.0)*Math.sin(theta);
				cannonMarkerLine.angle = arrow.angle-90;
				cannonMarkerLine.alpha = 0.22 + 0.78*pulseTimer/pulseTimeMax;
			} else {
				cannonMarkerLine.alpha = 0;
			}
			
			super.update();
			
			if (hand.velocity.x != 0) {
				lastVel.x = hand.velocity.x;
			}
			if (hand.velocity.y != 0) {
				lastVel.y = hand.velocity.y;
			}
			
			//var doorsJustDied:Boolean = false;
			//if (!doorsDead) {
			for (var a:int = doorGroup.length-1; a >= 0; a--) {
				if (doorGroup.members[a].frame == 12) {
					doorGroup.members[a].kill();
					ambientGearsSound.stop();
					reinvigorated = false;
					doorsDead = true;
					//doorsJustDied = true;
				}
			}
			//}
			
			/*
			// catch all drop doors
			//if (doorsDead) {
			if (doorsJustDied) {// && !doorsDead) {
				//doorsDead = true;
				for (a = bodyGroup.length-1; a >= 0; a--) {
					var bbody:FlxSprite = bodyGroup.members[a];
					var bbodyGear:FlxSprite = bodyGearGroup.members[a];
					var bbodyHead:FlxSprite = bodyHeadGroup.members[a];
					var barmBase:FlxSprite = bodyArmBaseGroup.members[a];
					if (!bbody.touching) {
						
						bbody.acceleration.y = MAX_GRAV_VEL;
						if (0 > bbody.angle || bbody.angle < 360) {
							if (0 > bbody.angle) {
								bbody.angle += 5;
							} else {
								bbody.angle -= 5;
							}
						}
						
						var btheta:Number = (bbody.angle-90)*Math.PI/180.0;
						bbodyHead.x = bbody.x + bbody.width/2.0 - bbodyHead.width/2.0 + (bbodyHead.height*1.5)*Math.cos(btheta);
						bbodyHead.y = bbody.y + bbody.height/2.0 - bbodyHead.height/2.0 + (bbodyHead.height*1.5)*Math.sin(btheta);
						bbodyHead.angle = bbody.angle;
						bbodyGear.x = bbody.x + bbody.width/2.0 - bbodyGear.width/2.0 + (bbodyGear.width/2.0)*Math.cos(btheta-Math.PI/2.0);
						bbodyGear.y = bbody.y + bbody.height/2.0 - bbodyGear.height/2.0 + (bbodyGear.width/2.0)*Math.sin(btheta-Math.PI/2.0);
						barmBase.x = bbody.x;
						barmBase.y = bbody.y;
					}
					
					if (bbody.justTouched(FlxObject.DOWN)) {
						bbody.facing = FlxObject.DOWN;
						bbody.angle = 0;
					}
				}
			}
			*/
			
			handMetalFlag = uint.MAX_VALUE;
			handWoodFlag = uint.MAX_VALUE;
			//FlxG.collide(level,trashGroup);
			if (!onGround) {
				touchingTrash = false;
			}
			//FlxG.collide(trashGroup, hand,stupidCallback);//, woodCallback);
			//FlxG.collide(trashGroup,trashGroup);
			//FlxG.collide(level, hand/*, levelHandCallback*/);
			FlxG.collide(doorGroup, hand, doorCallback);
			//FlxG.overlap(hand, steams, handSteamOverlap); //uncomment to turn steam pushing back on
			//FlxG.collide(flapGroup, hand, doorCallback);
			//FlxG.collide(level, bodyGroup);
			FlxG.collide(doorGroup, bodyGroup);
			/*FlxG.collide(markerEnd, level);
			FlxG.collide(markerEnd, doorGroup);*/
			
			FlxG.collide(levelFunctional,hand);
			FlxG.collide(levelFunctional,bodyGroup);
			
			if (FlxG.collide(markerEnd, /*level*/levelFunctional) || FlxG.collide(markerEnd, doorGroup)) {
				markerEnd.velocity.x = 0;
				markerEnd.velocity.y = 0;
			}
			handTouching = hand.touching;
			correctMetal();
			if (bodyMode) {
				//was block stuff
			} else {
				if (onGround/* && (!hand.isTouching(hand.facing) || (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE && !hand.isTouching(FlxObject.DOWN)))*/) {
					lastGround = hand.facing;
					if (isNothingInDir(hand.facing, 4)) {
						if (touchingMetal) { //was the player touching metal the last frame?
							if (hand.facing == FlxObject.LEFT) {
								if (lastVel.y > 0) {
									setDir(hand,FlxObject.UP,true);
									hand.acceleration.y -= MOVE_ACCEL;
								} else {
									setDir(hand,FlxObject.DOWN,true);
									hand.acceleration.y += MOVE_ACCEL;
								}
								hand.acceleration.x = -GRAV_RATE;
							} else if (hand.facing == FlxObject.RIGHT) {
								if (lastVel.y > 0) {
									setDir(hand,FlxObject.UP,true);
									hand.acceleration.y -= MOVE_ACCEL;
								} else {
									setDir(hand,FlxObject.DOWN,true);
									hand.acceleration.y += MOVE_ACCEL;
								}
								hand.acceleration.x = GRAV_RATE;
							} else if (hand.facing == FlxObject.DOWN) {
								if (lastVel.x > 0) {
									setDir(hand,FlxObject.LEFT,true);
									hand.acceleration.x -= MOVE_ACCEL;
								} else {
									setDir(hand,FlxObject.RIGHT,true);
									hand.acceleration.x += MOVE_ACCEL;
								}
								hand.acceleration.y = GRAV_RATE;
							} else if (hand.facing == FlxObject.UP) {
								if (lastVel.x > 0) {
									setDir(hand,FlxObject.LEFT,true);
									hand.acceleration.x -= MOVE_ACCEL;
								} else {
									setDir(hand,FlxObject.RIGHT,true);
									hand.acceleration.x += MOVE_ACCEL;
								}
								hand.acceleration.y = -GRAV_RATE;
							}
						} else {
							setDir(hand,FlxObject.DOWN,true);
						}
					} else if (hand.facing != FlxObject.DOWN && !isMetalInDir(hand, hand.facing, 4)) { //replacing || lastTouchedWood
						setDir(hand,FlxObject.DOWN,true);
					}
				}/* else if (!onGround && hand.isTouching(hand.facing) && (handWoodFlag == uint.MAX_VALUE || handMetalFlag < uint.MAX_VALUE || hand.isTouching(FlxObject.DOWN))) {
					
					// probably this should happen when it loses contact with the surface in the first place
					if      (hand.isTouching(FlxObject.LEFT)) {hand.facing = FlxObject.LEFT;}
					else if (hand.isTouching(FlxObject.UP  )) {hand.facing = FlxObject.UP;}
					else if (hand.isTouching(FlxObject.RIGHT)) {hand.facing = FlxObject.RIGHT;}
					else                                       {hand.facing = FlxObject.DOWN;}
					
					onGround = true;
					setDir(hand, hand.facing);
				}*/
				// ^ I *think* this block is redundant...
			}
			
			
			// Pause
			if (FlxG.keys.justPressed("ENTER")) {
				FlxG.paused = !FlxG.paused;
				pause.setAll("exists", FlxG.paused);
				//IDLE_TIME = 22;
			}
			
			if (FlxG.paused) {
				if (bodyMode || cannonMode) {
					pause.con.play("attached");
				} else {
					pause.con.play("detached");
				}
			}
			if (FlxG.paused && FlxG.keys.justPressed("R")) {
				// sound stuff
				ambientGearsSound.stop();
				ambientSteamSound.stop();
				ambientElectricalHumSound.stop();
				FlxG.resetState();
			}
		}
		
		/*public function levelHandCallback(a:FlxObject, b:FlxObject):void {
			FlxG.log("okay");
		}*/
		
		public function metalCallback(tile:FlxTile, spr:FlxSprite):void {
			metalStuff(tile.mapIndex, spr);
		}
		
		public function metalStuff(ind:uint, spr:FlxSprite):void {
			if (spr == hand && !cannonMode) {
				handMetalFlag = ind;
				lastTouchedWood = false;
				//if (getHandTouching() != spr.facing) {
					fixGravity(spr);
				//}
			} else if (spr == markerEnd) {
				setGrappleOkay();
			} else if (spr in bodyGroup.members) {
				//if (spr.touching != spr.facing) {
					fixGravity(spr);
				//}
			}
		}
		
		public function woodCallback(tile:FlxTile, spr:FlxSprite):void {
			woodStuff(tile.mapIndex, spr);
		}
		
		public function stupidCallback(spr1:FlxSprite,spr2:FlxSprite):void {
			//lastTouchedWood = true;
			touchingTrash = true;
			woodStuff(1, hand);
		}
		
		public function woodStuff(ind:uint, spr:FlxSprite):void {
			if (spr == hand) {
				handWoodFlag = ind;
				lastTouchedWood = true;
				if (/*getHandTouching() != spr.facing && onGround &&*/ !bodyMode) {fixGravity(spr);}
			}
		}
		
		public function dirtCallback(tile:FlxTile, spr:FlxSprite):void {
			lastTouchedDirt = true;
			woodCallback(tile,spr);
		}
		
		public function doorCallback(spr1:FlxSprite, spr2:FlxSprite):void {
			if (spr2 == hand) {
				handMetalFlag = 1;
				//if (getHandTouching() != spr2.facing) {
					fixGravity(spr2, true);
				//}
				lastTouchedWood = false;
			} else {
				handMetalFlag = 1;
				//if (getHandTouching() != spr1.facing) {
					fixGravity(spr1, true);
				//}
				lastTouchedWood = false;
			}
		}
		
		/*
		public function hitUp(spr1:FlxSprite, spr2:FlxSprite):void {
			var spr:FlxSprite;
			if (spr2 == hand) {
				spr = spr1;
			} else {
				spr = spr2;
			}
			//spr.acceleration.y = MAX_GRAV_VEL;
			//spr.acceleration.x = -MAX_GRAV_VEL;
			spr.angle += 2.2*hand.velocity.x/MAX_MOVE_VEL;
			spr.velocity.y = -MAX_MOVE_VEL;
			spr.velocity.x = -MAX_MOVE_VEL;
		}
		*/
				
		public function fixGravity(spr:FlxSprite, isDoor:Boolean=false):void {
			var hitOnlyWood:Boolean = true;
				if ((getHandTouching() & FlxObject.DOWN) > 0) {
					hitOnlyWood = false;
					setDir(spr, FlxObject.DOWN);
				} else if ((getHandTouching() & FlxObject.UP) > 0 && (isDoor || isMetalInDir(hand,FlxObject.UP,4))) { //max was originally 3, but I think that was a typo from back when there were corners
					hitOnlyWood = false;
					setDir(spr, FlxObject.UP);
				} else if ((getHandTouching() & FlxObject.LEFT) > 0 && (isDoor || isMetalInDir(hand,FlxObject.LEFT,4))) {
					hitOnlyWood = false;
					setDir(spr, FlxObject.LEFT);
				} else if ((getHandTouching() & FlxObject.RIGHT) > 0 && (isDoor || isMetalInDir(hand,FlxObject.RIGHT,4))) {
					hitOnlyWood = false;
					setDir(spr, FlxObject.RIGHT);
				}
				if (hitOnlyWood && !onGround && spr.facing != FlxObject.DOWN) { //if the hand only hit wood after being shot by steam
					setDir(spr, FlxObject.DOWN, true);
				}
			//}
		}
		
		public function setDir(spr:FlxSprite, dir:uint, grav:Boolean=false):void {
			spr.facing = dir;
			spr.acceleration.x = 0;
			spr.acceleration.y = 0;
			if (grav) {
				if (dir == FlxObject.DOWN) {
					spr.acceleration.y = GRAV_RATE;
				} else if (dir == FlxObject.UP) {
					spr.acceleration.y = -GRAV_RATE;
				} else if (dir == FlxObject.LEFT) {
					spr.acceleration.x = -GRAV_RATE;
				} else if (dir == FlxObject.RIGHT) {
					spr.acceleration.x = GRAV_RATE;
				}
				spr.drag.x = 0;
				spr.drag.y = 0;
				spr.maxVelocity.x = MAX_GRAV_VEL;
				spr.maxVelocity.y = MAX_GRAV_VEL;
				onGround = false;
			} else {
				spr.drag.x = MOVE_DECEL;
				spr.drag.y = MOVE_DECEL;
				spr.maxVelocity.x = MAX_MOVE_VEL;
				spr.maxVelocity.y = MAX_MOVE_VEL;
				onGround = true;
				camTag.angle = trueAngle(camTag.angle);
			}
			if (dir == FlxObject.DOWN) {
				camAngle = 0;
			} else if (dir == FlxObject.UP) {
				if (camAngle < 0) {
					camAngle = -180;
				} else {
					camAngle = 180;
				}
			} else if (dir == FlxObject.LEFT) {
				if (camAngle == -180) {
					camTag.angle = 180;
				}
				camAngle = 90;
			} else if (dir == FlxObject.RIGHT) {
				if (camAngle == 180) {
					camTag.angle = -180;
				}
				camAngle = -90;
			}
			if (onGround) {
				if (Registry.continuityUntilRelease) {
					//if (Registry.handRelative) {
					if ((handIsFacing(FlxObject.DOWN) && (lastGround & FlxObject.UP) == FlxObject.UP)
						|| (handIsFacing(FlxObject.UP) && (lastGround & FlxObject.DOWN) == FlxObject.DOWN)
						|| (handIsFacing(FlxObject.LEFT) && (lastGround & FlxObject.RIGHT) == FlxObject.RIGHT)
						|| (handIsFacing(FlxObject.RIGHT) && (lastGround & FlxObject.LEFT) == FlxObject.LEFT)) {
						if (tempGround == FlxObject.DOWN) {
							tempGround = FlxObject.UP;
						} else if (tempGround == FlxObject.UP) {
							tempGround = FlxObject.DOWN;
						} else if (tempGround == FlxObject.LEFT) {
							tempGround = FlxObject.RIGHT;
						} else if (tempGround == FlxObject.RIGHT) {
							tempGround = FlxObject.LEFT;
						}
					}
					//} else {
					//	tempGround = lastGround;
					//}
				} else if (!Registry.handRelative) {
					tempGround = dir;
				}
				lastGround = spr.facing;
			} 
		}
		
		public function handIsFacing(dir:uint):Boolean {
			return (hand.facing & dir) > 0;
		}
		
		// I kind of want to nix arrows and bodyTargetAngle etc
		public function showArrow():void {
			arrow.angle = bodyTargetAngle - 90;
			arrowStartAngle = arrow.angle;
		}
		
		public function isMetal(tile:uint):Boolean {
			/*
			return (tile >= METAL_MIN && tile <= METAL_MAX);
			*/
			for (var i:uint = 0; i < RegistryLevels.kSpawnMetal.length; i++) {
				var index:uint = RegistryLevels.kSpawnMetal[i];
				if (tile == index) {
					return true;
				}
			}
			return false;
		}
		
		public function isUntouchable(tile:uint):Boolean {
			/*
			return (tile == 0 || (tile >= UNTOUCHABLE_MIN && tile <= UNTOUCHABLE_MAX)
				|| (tile >= UNTOUCHABLE_OVERFLOW_MIN && tile <= UNTOUCHABLE_OVERFLOW_MAX)
				|| (tile >= UNTOUCHABLE_GRASS_MIN && tile <= UNTOUCHABLE_GRASS_MAX));
			*/
			for (var i:uint = 0; i < RegistryLevels.kSpawnEmpty.length; i++) {
				var index:uint = RegistryLevels.kSpawnEmpty[i];
				if (tile == index) {
					return true;
				}
			}
			return false;
		}
		
		public function handOverlapsBody():uint {
			var hasOverlapped:Boolean = false;
			var b_max:int;
			var b_distSq_Min:Number;
			for (var b:int = 0; b < bodyGroup.length; b++) {
				var b_body:FlxSprite = bodyGroup.members[b];
				if (hand.overlaps(b_body)) {
					//return(b);
					var b_distSq:Number = Math.pow(hand.x + hand.width/2.0 - b_body.x - b_body.width/2.0,2) + Math.pow(hand.y + hand.height/2.0 - b_body.y - b_body.height/2.0,2);
					if (!hasOverlapped) {
						b_max = b;
						b_distSq_Min = b_distSq;
						hasOverlapped = true;
					} else if (b_distSq < b_distSq_Min) {
						b_max = b;
						b_distSq_Min = b_distSq;
					}
				}
			}
			if (hasOverlapped) {
				return(b_max);
			}
			return(uint.MAX_VALUE);
		}
		
		public function handOverlapsCannon():uint {
			var hasOverlapped:Boolean = false;
			var b_max:int;
			var b_distSq_Min:Number;
			for (var b:int = 0; b < cannonGroup.length; b++) {
				var b_cannon:FlxSprite = cannonGroup.members[b];
				if (hand.overlaps(b_cannon)) {
					//return(b);
					var b_distSq:Number = Math.pow(hand.x + hand.width/2.0 - b_cannon.x - b_cannon.width/2.0,2) + Math.pow(hand.y + hand.height/2.0 - b_cannon.y - b_cannon.height/2.0,2);
					if (!hasOverlapped) {
						b_max = b;
						b_distSq_Min = b_distSq;
						hasOverlapped = true;
					} else if (b_distSq < b_distSq_Min) {
						b_max = b;
						b_distSq_Min = b_distSq;
					}
				}
			}
			if (hasOverlapped) {
				return(b_max);
			}
			return(uint.MAX_VALUE);
		}
		
		/*
		public function pointForTile(tile:uint,map:FlxTilemap):FlxPoint {
			var X:Number = 8*(int)(tile%map.widthInTiles);
			var Y:Number = 8*(int)(tile/map.widthInTiles);
			var p:FlxPoint = new FlxPoint(X,Y);
			return p;
		}*/
		
		public function buttonReaction():void {
			
			steamTimer = 0;
			
			steamsNumber++;
			if (buttonStateArray.indexOf(false) == -1) {
				for (var a:int = 0; a < doorGroup.length; a++) {
					doorGroup.members[a].play("open");
				}
				exitOn = true;
				//exitArrow.visible = true;
				
				for (var mn:int = 0; mn < steams.length; mn++) {//(var m:String in steams.members) {
					//if (steamsNumberArray[mn] < steamsNumber) {
					steams.members[mn].play("idle");
					//}
				}
				steamsNumber = 0;
				
				reinvigorated = true;
			}
			buttonMode++;
			if (buttonMode == 1) {
				for (var b:uint = 0; b < buttonGroup.length; b++) {
					if (buttonGroup.members[b].frame != BUTTON_PRESSED) {
						buttonGroup.members[b].frame = 2;
						
						/*
						//
						//reinvigorated = true;
						for (mn = 0; mn < steams.length; mn++) {//(var m:String in steams.members) {
							if (steamsNumberArray[mn] < steamsNumber) {
								steams.members[mn].play("puff");
							}
						}
						*/
					}
				}
			} else {
				for (var c:uint = 0; c < buttonGroup.length; c++) {
					if (buttonGroup.members[c].frame != BUTTON_PRESSED) {
						buttonGroup.members[c].frame = 3;
						
						/*
						//
						for (mn = 0; mn < steams.length; mn++) {//(var m:String in steams.members) {
							if (steamsNumberArray[mn] < steamsNumber) {
								steams.members[mn].play("puff");
							}
						}
						*/
						
					}
				}
			}
			/*
			if (reinvigorated) {
				reinvigorated = false;
				for (var m:String in steams.members) {
					var steam:FlxSprite = steams.members[m];
					steam.play("idle");
				}
				
			} else {
				reinvigorated = true;
				for (m in steams.members) {
					steam = steams.members[m];
					steam.play("puff");
				}
			}
			*/
		}
		
		public function playerIsPressing(dir:uint):Boolean {
			//if (Registry.continuityUntilRelease) {
				if (dir == FlxObject.LEFT) {
					if (tempGround == FlxObject.DOWN) {
						return controlDirs.indexOf(FlxObject.LEFT) > controlDirs.indexOf(FlxObject.RIGHT);
					} else if (tempGround == FlxObject.LEFT) {
						return controlDirs.indexOf(FlxObject.UP) > controlDirs.indexOf(FlxObject.DOWN);
					} else if (tempGround == FlxObject.UP) {
						return controlDirs.indexOf(FlxObject.RIGHT) > controlDirs.indexOf(FlxObject.LEFT);
					} else if (tempGround == FlxObject.RIGHT) {
						return controlDirs.indexOf(FlxObject.DOWN) > controlDirs.indexOf(FlxObject.UP);
					}
				} else if (dir == FlxObject.RIGHT) {
					if (tempGround == FlxObject.DOWN) {
						return controlDirs.indexOf(FlxObject.LEFT) < controlDirs.indexOf(FlxObject.RIGHT);
					} else if (tempGround == FlxObject.LEFT) {
						return controlDirs.indexOf(FlxObject.UP) < controlDirs.indexOf(FlxObject.DOWN);
					} else if (tempGround == FlxObject.UP) {
						return controlDirs.indexOf(FlxObject.RIGHT) < controlDirs.indexOf(FlxObject.LEFT);
					} else if (tempGround == FlxObject.RIGHT) {
						return controlDirs.indexOf(FlxObject.DOWN) < controlDirs.indexOf(FlxObject.UP);
					}
				}
			/*} else {
				if (dir == FlxObject.LEFT) {
					if (Registry.handRelative || (handIsFacing(FlxObject.DOWN) && !handIsFacing(FlxObject.LEFT))) {
						return controlDirs.indexOf(FlxObject.LEFT) > controlDirs.indexOf(FlxObject.RIGHT);
					} else if (handIsFacing(FlxObject.LEFT) && !handIsFacing(FlxObject.UP)) {
						return controlDirs.indexOf(FlxObject.UP) > controlDirs.indexOf(FlxObject.DOWN);
					} else if (handIsFacing(FlxObject.UP) && !handIsFacing(FlxObject.RIGHT)) {
						return controlDirs.indexOf(FlxObject.RIGHT) > controlDirs.indexOf(FlxObject.LEFT);
					} else if (handIsFacing(FlxObject.RIGHT)) {
						return controlDirs.indexOf(FlxObject.DOWN) > controlDirs.indexOf(FlxObject.UP);
					}
				} else if (dir == FlxObject.RIGHT) {
					if (Registry.handRelative || (handIsFacing(FlxObject.DOWN) && !handIsFacing(FlxObject.RIGHT))) {
						return controlDirs.indexOf(FlxObject.RIGHT) > controlDirs.indexOf(FlxObject.LEFT);
					} else if (handIsFacing(FlxObject.RIGHT) && !handIsFacing(FlxObject.UP)) {
						return controlDirs.indexOf(FlxObject.UP) > controlDirs.indexOf(FlxObject.DOWN);
					} else if (handIsFacing(FlxObject.UP) && !handIsFacing(FlxObject.LEFT)) {
						return controlDirs.indexOf(FlxObject.LEFT) > controlDirs.indexOf(FlxObject.RIGHT);	
					} else if (handIsFacing(FlxObject.LEFT)) {
						return controlDirs.indexOf(FlxObject.DOWN) > controlDirs.indexOf(FlxObject.UP);
					}
				}
			}*/
			return false;
		}
		
		public function goToNextLevel():void {
			
			// sound stuff
			ambientGearsSound.stop();
			ambientSteamSound.stop();
			ambientElectricalHumSound.stop();
			
			Registry.levelNum++;
			if (Registry.levelNum < Registry.levelOrder.length) {
				Registry.level = Registry.levelOrder[Registry.levelNum];
				Registry.midground = Registry.midOrder[Registry.levelNum];
				Registry.background = Registry.backOrder[Registry.levelNum];
				FlxG.switchState(new PlayState);//(Registry.levelOrder[Registry.levelNum],Registry.midgroundMap,Registry.backgroundMap));
			} else {
				FlxG.switchState(new EndState());
			}
		}
		
		/*public function goToNextIteration():void {
			//Registry.iteration++;
			Registry.levelNum = 0;
			FlxG.switchState(new PlayState(Registry.levelOrder[0],Registry.midgroundMap,Registry.backgroundMap));
		}*/
		
		public function controlDirsRemove(dir:uint):void {
			var cD:int = controlDirs.indexOf(dir);
			if (cD != -1) {
				controlDirs.splice(cD, 1);
			}
		}
		
		public function getHandTouching():uint {
			/*if (hand.touching == handTouching) {
				return handTouching;
			}
			if (handTouching != 0 && (isMultiDirection(handTouching))) {// || !isMultiDirection(hand.touching))(hand.touching & handTouching) >= hand.touching) { //originally >= handTouching if this causes problems
				return handTouching;
			}*/
			return hand.touching;
		}
		
		public function resetTempGround():void {
			lastGround = hand.facing;
			if (Registry.handRelative) {
				tempGround = FlxObject.DOWN;
			} else {
				tempGround = hand.facing;
			}
		}
		
		/*public function isMultiDirection(n:uint):Boolean {
			return ((n & FlxObject.DOWN) > 0 && (n ^ FlxObject.DOWN) > 0) || ((n & FlxObject.UP) > 0 && (n ^ FlxObject.UP) > 0) || ((n & FlxObject.LEFT) > 0 && (n ^ FlxObject.LEFT) > 0);
		}*/
		
		public function correctMetal():void {
			if (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE) {
				/* since Flixel only ever calls one tile callback function, the one corresponding to the topmost or leftmost corner 
				of the hand against the surface, we must do this check for the other corner to compensate */
				if ((hand.isTouching(FlxObject.UP) && isMetalInDir(hand, FlxObject.UP, 4)) 
				 || (hand.isTouching(FlxObject.DOWN) && isMetalInDir(hand, FlxObject.DOWN, 4))
				 || (hand.isTouching(FlxObject.LEFT) && isMetalInDir(hand, FlxObject.LEFT, 4))
				 || (hand.isTouching(FlxObject.RIGHT) && isMetalInDir(hand, FlxObject.RIGHT, 4))) {
					metalStuff(1, hand);
				}
			}
		}
		
		public function isMetalInDir(spr:FlxSprite, dir:uint, max:uint):Boolean {
			var indX:uint = int(spr.x/8);
			var indY:uint = int(spr.y/8);
			if (dir == FlxObject.LEFT) {
				for (var a:uint = 0; a <= max; a++) {
					if (indY < levelFunctional.heightInTiles - a && isMetal(levelFunctional.getTile(indX-1, indY+a))) {
						return true;
					}
				}
				for (var aD:uint = 0; aD < doorGroup.length; aD++) {
					if (doorGroup.members[aD].height == 64) {
						var doorAX:uint = int(doorGroup.members[aD].x/8);
						var doorAY:uint = int(doorGroup.members[aD].y/8);
						if (doorAX == indX-2 && doorAY >= indY - 7 && doorAY <= indY + 4) {
							return true;
						}
					}
				}
			} else if (dir == FlxObject.RIGHT) {
				for (var b:uint = 0; b <= max; b++) {
					if (indY < levelFunctional.heightInTiles - b && isMetal(levelFunctional.getTile(indX+4, indY+b))) {
						return true;
					}
				}
				for (var bD:uint = 0; bD < doorGroup.length; bD++) {
					if (doorGroup.members[bD].height == 64) {
						var doorBX:uint = int(doorGroup.members[bD].x/8);
						var doorBY:uint = int(doorGroup.members[bD].y/8);
						if (doorBX == indX+4 && doorBY >= indY - 7 && doorBY <= indY + 4) {
							return true;
						}
					}
				}
			} else if (dir == FlxObject.UP) {
				for (var c:uint = 0; c <= max; c++) {
					if (indX < levelFunctional.widthInTiles - c && isMetal(levelFunctional.getTile(indX+c, indY-1))) {
						return true;
					}
				}
				for (var cD:uint = 0; cD < doorGroup.length; cD++) {
					if (doorGroup.members[cD].width == 64) {
						var doorCX:uint = int(doorGroup.members[cD].x/8);
						var doorCY:uint = int(doorGroup.members[cD].y/8);
						if (doorCY == indY-2 && doorCX >= indX - 7 && doorCX <= indX + 4) {
							return true;
						}
					}
				}
			} else if (dir == FlxObject.DOWN) {
				for (var d:uint = 0; d <= max; d++) {
					if (indX < levelFunctional.widthInTiles - d && isMetal(levelFunctional.getTile(indX+d, indY+4))) {
						return true;
					}
				}
				for (var dD:uint = 0; dD < doorGroup.length; dD++) {
					if (doorGroup.members[dD].width == 64) {
						var doorDX:uint = int(doorGroup.members[dD].x/8);
						var doorDY:uint = int(doorGroup.members[dD].y/8);
						if (doorDY == indY+4 && doorDX >= indX - 7 && doorDX <= indX + 4) {
							return true;
						}
					}
				}
			}
			return false;
		}
		
		public function isNothingInDir(dir:uint, max:uint):Boolean {
			/*if (touchingTrash) {
				return false;
			}*/
			var indX:uint = int(hand.x/8);
			var indY:uint = int(hand.y/8);
			if (dir == FlxObject.LEFT && nothingCheckPattern(max, indX, indY, true, false)) {
				return false;
			} else if (dir == FlxObject.RIGHT && nothingCheckPattern(max, indX, indY, true, true)) {
				return false;
			} else if (dir == FlxObject.UP && nothingCheckPattern(max, indX, indY, false, false)) {
				return false;
			} else if (dir == FlxObject.DOWN && nothingCheckPattern(max, indX, indY, false, true)) {
				return false;
			}
			return true;
		}
		
		public function nothingCheckPattern(max:uint, indX:uint, indY:uint, fixedX:Boolean, forwards:Boolean):Boolean {
			for (var a:uint = 0; a <= max; a++) {
				if (indY < levelFunctional.heightInTiles - a && fixedX?(!isUntouchable(levelFunctional.getTile(indX+(forwards?4:-1), indY+a))):(!isUntouchable(levelFunctional.getTile(indX+a, indY+(forwards?4:-1))))) {
					return true;
				}
			}
			for (var aD:uint = 0; aD < doorGroup.length; aD++) {
				if (fixedX?doorGroup.members[aD].height:doorGroup.members[aD].width == 64) {
					var doorAX:uint = int(doorGroup.members[aD].x/8);
					var doorAY:uint = int(doorGroup.members[aD].y/8);
					if (fixedX?(doorAX == indX+(forwards?4:-2) && doorAY >= indY - 7 && doorAY <= indY + 4)
						:(doorAY == indY+(forwards?4:-2) && doorAX >= indX - 7 && doorAX <= indX + 4)) {
						return true;
					}
				}
			}
			for (var t:uint = 0; t < trashGroup.length; t++) {
				var trashX:uint = int(trashGroup.members[t].x/8);
				var trashY:uint = int(trashGroup.members[t].y/8);
				if (fixedX?(trashX == indX+(forwards?4:-4) && trashY >= indY - 3 && trashY <= indY + 4)
					:(trashY == indY+(forwards?4:-4) && trashX >= indX - 3 && trashX <= indX + 4)) {
					return true;
				}
			}
			return false;
		}
		
		public function jumpStuff():void {
			handFalling = true;
			Registry.neverJumped = false;
			lastGround = hand.facing;
			setDir(hand,FlxObject.DOWN,true);
		}
		
		public function handSteamOverlap(spr1:FlxSprite, spr2:FlxSprite):void {
			var steam:FlxSprite = (spr1==hand)?spr2:spr1;
			if (steam.frame > 0 && !bodyMode && !cannonMode) {
				setDir(hand, steam.facing, true);
			}
		}
		
		public function updateRaytrace(angle:Number):void {
			if (bodyMode) {
				markerEnd.angle = angle-90;
				var theta:Number = angle*Math.PI/180.0;
				markerEnd.x = hand.x;
				markerEnd.y = hand.y;
				markerEnd.velocity.x = GRAPPLE_SPEED*Math.cos(theta);
				markerEnd.velocity.y = GRAPPLE_SPEED*Math.sin(theta);
				markerEnd.color = Math.min(col*2, 0xff0000);
				bodyMarkerGroup.setAll("color", 0xff0000);
				while (Math.sqrt(Math.pow(markerEnd.x-hand.x, 2) + Math.pow(markerEnd.y-hand.y, 2)) < GRAPPLE_LENGTH) {
					markerEndGroup.update();
					if (FlxG.collide(markerEnd, /*level*/levelFunctional, raytraceCallback) || FlxG.collide(markerEnd, doorGroup, raytraceDoorCallback)) {
						break;
					}
				}
				if (FlxG.overlap(markerEnd, buttonGroup) || (markerEnd.touching != 0 && isMetalInDir(markerEnd, markerEnd.touching,4))) {
					setGrappleOkay();
				}
				markerEnd.velocity.x = 0;
				markerEnd.velocity.y = 0;
			}
		}
		
		public function raytraceCallback(spr1:FlxSprite, spr2:FlxObject):void {
			if (markerEnd.isTouching(FlxObject.LEFT)) {
				markerEnd.angle = 90;
			} else if (markerEnd.isTouching(FlxObject.RIGHT)) {
				markerEnd.angle = 270;
			} else if (markerEnd.isTouching(FlxObject.UP)) {
				markerEnd.angle = 180;
			} else if (markerEnd.isTouching(FlxObject.DOWN)) {
				markerEnd.angle = 0;
			}
		}
		
		public function raytraceDoorCallback(spr1:FlxSprite, spr2:FlxObject):void {
			setGrappleOkay();
			raytraceCallback(spr1, spr2);
		}
		
		public function setGrappleOkay():void {
			markerEnd.color = 0xffffff;
			bodyMarkerGroup.setAll("color", 0xffffff);
		}
		
		private function groupFromSpawn(_spawn:Array,_class:Class,_map:FlxTilemap,_hide:Boolean=true):FlxGroup {
			var _group:FlxGroup = new FlxGroup();
			for (var i:uint = 0; i <_spawn.length; i++) {
				var _array:Array = _map.getTileInstances(_spawn[i]);
				if (_array) {
					for (var j:uint = 0; j < _array.length; j++) {
						var _point:FlxPoint = pointForTile(_array[j],_map);
						_group.add(new _class(_point.x,_point.y));
						if (_hide) {
							_map.setTileByIndex(_array[j],0);
						}
					}
				}
			}
			return _group;
		}
		
		private function setCallbackFromSpawn(_spawn:Array,_callback:Function,_map:FlxTilemap,_hide:Boolean=true):void {
			for (var i:uint = 0; i <_spawn.length; i++) {
				_map.setTileProperties(_spawn[i],FlxObject.ANY,_callback);
				var _array:Array = _map.getTileInstances(_spawn[i]);
				if (_array && _hide) {
					for (var j:uint = 0; j < _array.length; j++) {
						_map.setTileByIndex(_array[j],0);
					}
				}
			}
		}
		
		private function pointForTile(_tile:uint,_map:FlxTilemap):FlxPoint {
			var _x:Number = (_map.width/_map.widthInTiles)*(int)(_tile%_map.widthInTiles);
			var _y:Number = (_map.width/_map.widthInTiles)*(int)(_tile/_map.widthInTiles);
			var _point:FlxPoint = new FlxPoint(_x,_y);
			return _point;
		}
		
		private function trueAngle(a:Number):Number {
			var r:Number = a % 360;
			if (r <= -180) {
				r += 360;
			} else if (r > 180) {
				r -= 360;
			}
			return r;
		}
		
		private function angleDifference(a:Number, b:Number):Number {
			var tA:Number = trueAngle(a);
			var tB:Number = trueAngle(b);
			
			var d1:Number = tA-tB;
			var d2:Number = d1>=0?d1-360:d1+360;
			if (Math.abs(d1) < Math.abs(d2)) {
				return d1;
			}
			return d2;
		}
	}
}