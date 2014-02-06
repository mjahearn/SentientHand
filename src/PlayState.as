package {
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
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
				
		private var levelFunctional:FlxTilemap;
		
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
		//public const JUMP_HINT_SPAWN:uint = 32;
		//public const SIGN_SPAWN:uint = 33;
		
		//button animation frames
		//public const BUTTON_PRESSED:uint = 0;
		//public const BUTTON_INIT:uint = 1;
		
		public const ACTION_KEY:String = Registry.jumpSpace?"SPACE":"UP";
		public const BODY_KEY:String = "DOWN";
		
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
		
		//public var jumpHintGroup:FlxGroup = new FlxGroup();
		
		public var electricityNum:int = 1;
		
		public var levelCosmeticFront:FlxTilemap;
		//public var midground:FlxTilemap;
		//public var background:FlxTilemap;
		//public var levelMid:FlxTilemap;
		//public var levelBack:FlxTilemap;
		//public var hand:FlxSprite;
		public var hand:SprHand;
		//public var hint:FlxSprite;
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
		public var handOut:Boolean;
		public var handIn:Boolean;
		public var handGrab:Boolean;
		public var handMetalFlag:uint;
		public var handWoodFlag:uint;
		public var onGround:Boolean;
		public var lastVel:FlxPoint; //last nonzero hand velocity - used for convex corners
		
		public var gearInGroup:FlxGroup = new FlxGroup();
		public var gearOutGroup:FlxGroup = new FlxGroup();
		public var steams:FlxGroup = new FlxGroup();
		
		public var lastTouchedWood:Boolean = false;
		public var arrowStartAngle:int;
		public var shootAngle:int;
		//public var handReturnedToBody:Boolean = false;
		
		public var buttonGroup:FlxGroup = new FlxGroup();
		//public var buttonStateArray:Array = new Array();
		//public var buttonReactionArray:Array = new Array();
		//public var buttonMode:uint;
		//public var buttonBangGroup:FlxGroup = new FlxGroup();
		
		public var electricity:FlxSprite;
		
		public var timeFallen:Number;
		
		public var markerLine:FlxSprite;
		//public var hintArrow:FlxSprite = new FlxSprite();
		//public var exitArrow:FlxSprite = new FlxSprite();
		public var exitRad:Number;
		//public var exitOn:Boolean;
		public var col:uint; //pulse color
		
		public var cannonGroup:FlxGroup = new FlxGroup();
		
		public var exitPoint:FlxPoint = new FlxPoint();
		
		public var trashGroup:FlxGroup = new FlxGroup();
		public var lastTouchedDirt:Boolean;
		
		public var reversePolarity:Boolean;
		
		[Embed("assets/spr_cannon.png")] public var cannonSheet:Class;
		
		[Embed("assets/trash.png")] public var trashSheet:Class;
		
		[Embed("assets/spr_arm_base.png")] public var armBaseSheet:Class;
		
		/*
		[Embed("assets/level-tiles.png")] public var tileset:Class;
		[Embed("assets/background-tiles.png")] public var backgroundset:Class;
		[Embed("assets/midground-tiles.png")] public var midgroundset:Class;
		*/
		
		[Embed("assets/arrow.png")] public var arrowSheet:Class;
		//[Embed("assets/hand.png")] public var handSheet:Class;
		//[Embed("assets/hint.png")] public var hintSheet:Class;
		[Embed("assets/spr_arm.png")] public var armSheet:Class;
		[Embed("assets/spr_body.png")] public var bodySheet:Class;
		
		[Embed("assets/electricity.png")] public var electricitySheet:Class;
		
		[Embed("assets/gear_64x64.png")] public var gear64x64Sheet:Class;
		[Embed("assets/gear_32x32.png")] public var gear32x32Sheet:Class;
		[Embed("assets/gear_16x16.png")] public var gear16x16Sheet:Class;
		
		[Embed("assets/sign.png")] public var signSheet:Class;
		
		//public static var levelMap:Class;
		//public static var midgroundMap:Class;
		//public static var backgroundMap:Class;
		
		//[Embed("assets/door_h.png")] public var doorHSheet:Class;
		//[Embed("assets/door_v.png")] public var doorVSheet:Class;
		
		[Embed("assets/spr_bodygear.png")] public var bodyGearSheet:Class;
		
		//[Embed("assets/!.png")] public var bangSheet:Class;
		
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
		[Embed("assets/Ambient_Gears.mp3")] public var ambientGearsSFX:Class;
		[Embed("assets/Ambient_Steam.mp3")] public var ambientSteamSFX:Class;
		//[Embed("assets/Door_Open.mp3")] public var doorOpenSFX:Class;
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
		public var ambientGearsSound:FlxSound = new FlxSound().loadEmbedded(ambientGearsSFX,true);
		public var ambientSteamSound:FlxSound = new FlxSound().loadEmbedded(/*doorOpenSFX);*/ambientSteamSFX,true);
		//public var doorOpenSound:FlxSound = new FlxSound().loadEmbedded(doorOpenSFX);
		public var dirtFootstepsSound:FlxSound = new FlxSound().loadEmbedded(dirtFootstepsSFX);
		public var handLandingOnDirtSound:FlxSound = new FlxSound().loadEmbedded(handLandingOnDirtSFX);
		
		[Embed("assets/steam.png")] public var steamSheet:Class;
		
		[Embed("assets/spr_head.png")] public var headSheet:Class;
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
		
		//private var testHint:SprHint;
		
		private var hintArrowKeysGroup:FlxGroup;
		private var dripperEvent:EventTimer;
		private var dripGroup:FlxGroup;
		private var roachGroup:FlxGroup;
		
		private var musOverlay:FlxSound;
		
		override public function create():void {
			
			setUpAudio();
			
			dbg = 0;
			timeFallen = 0; //this was initialized above, so I moved it here for saftey's sake- mjahearn
			lastTouchedDirt = false; //ditto
			//doorsDead = false;
			controlDirs = new Array();
			reversePolarity = false;
			
			FlxG.bgColor = 0xff000000;
			if (RegistryLevels.isLastLevel()) {
				//FlxG.bgColor = 0xff442288;
				//0xffaaaaaa; //and... if we want motion blur... 0x22000000
				var sky:FlxSprite = new FlxSprite(0,0,skySheet);
				sky.scrollFactor = new FlxPoint(0,0);
				add(sky);
				
			}
			
			levelFunctional = RegistryLevels.lvlFunc();
			
			addLevelCosmeticBack();
			addLevelCosmeticMid();
			addLevelCosmeticFront();
			
			if (Registry.DEBUG_ON && levelCosmeticFront.totalTiles <= 0) {add(levelFunctional);}
			
			/*
			level = RegistryLevels.lvlCosmFront();
			midground = RegistryLevels.lvlCosmMid();
			background = RegistryLevels.lvlCosmBack();
			*/
			
			/*
			levelMap = Registry.level;
			midgroundMap = Registry.midground;
			backgroundMap = Registry.background;
			*/
			
			/*
			var jumpHintArray:Array = midground.getTileInstances(JUMP_HINT_SPAWN);
			if (jumpHintArray) {
				midground.setTileProperties(JUMP_HINT_SPAWN,FlxObject.NONE);
				for (j = 0; j < jumpHintArray.length; j++) {
					midground.setTileByIndex(jumpHintArray[j],0);
					var jumpHintPoint:FlxPoint = pointForTile(jumpHintArray[j],midground);
					jumpHintGroup.add(new FlxSprite(jumpHintPoint.x,jumpHintPoint.y));
				}
			}*/
			
			//addHints();
			
			/* Level */
			/*
			//level = new FlxTilemap();
			//level.loadMap(new levelMap,tileset,8,8);
			if (level.totalTiles > 0) { // check if null
				add(level);
			}*/
			FlxG.worldBounds = new FlxRect(0, 0, levelFunctional.width,levelFunctional.height);
			if (Registry.extendedCamera) {
				FlxG.camera.bounds = new FlxRect(-FlxG.width/2, -FlxG.height/2, levelFunctional.width+FlxG.width, levelFunctional.height+FlxG.height);
			} else {
				FlxG.camera.bounds = FlxG.worldBounds;
			}
			
			/*
			var exitSprite:FlxSprite = groupFromSpawn(RegistryLevels.kSpawnExitArrow,FlxSprite,levelFunctional).members[0];
			// Exit arrow
			exitPoint = new FlxPoint();
			exitPoint.x = exitSprite.x;
			exitPoint.y = exitSprite.y;
			*/
			
			setCallbackFromSpawn(RegistryLevels.kSpawnMetal,metalCallback,levelFunctional,false);
			
			setCallbackFromSpawn(RegistryLevels.kSpawnWood,woodCallback,levelFunctional,false);
			
			setCallbackFromSpawn(RegistryLevels.kSpawnNeutral,neutralCallback,levelFunctional,false);
			
			// CANNONS
			cannonGroup = groupFromSpawn(RegistryLevels.kSpawnLauncher,FlxSprite,levelFunctional);
			for (var i:uint = 0; i < cannonGroup.length; i++) {
				var cannon:FlxSprite = cannonGroup.members[i];
				cannon.loadGraphic(cannonSheet);
				cannon.facing = FlxObject.DOWN;
				cannon.angle = 0;
			}
			add(cannonGroup);
			cannonArmBaseGroup = groupFromSpawn(RegistryLevels.kSpawnLauncher,FlxSprite,levelFunctional);
			for (i = 0; i < cannonArmBaseGroup.length; i++) {
				var armBase:FlxSprite = cannonArmBaseGroup.members[i];
				armBase.loadGraphic(armBaseSheet);
				armBase.facing = FlxObject.DOWN;
			}
			add(cannonArmBaseGroup);
			
			addButtons();
			
			bodyGearGroup = new FlxGroup();
			bodyHeadGroup = new FlxGroup();
			bodyGroup = groupFromSpawn(RegistryLevels.kSpawnGrappler,FlxSprite,levelFunctional);
			for (i = 0; i < bodyGroup.length; i++) {
				var body:FlxSprite = bodyGroup.members[i];
				body.loadGraphic(bodySheet);
				bodyTargetAngle = body.angle;
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
			add(bodyGroup);
			add(bodyGearGroup);
			add(bodyHeadGroup);
			add(bodyArmBaseGroup);
			
			// Steam
			//for (i = STEAM_MIN; i <= STEAM_MAX; i++) {
			for (var b:uint = 0; b < STEAM.length; b++) {
				i = STEAM[b];
				var steamArray:Array = levelCosmeticFront.getTileInstances(i);
				if (steamArray) {
					for (var j:uint = 0; j < steamArray.length; j++) {
						var steamPoint:FlxPoint = pointForTile(steamArray[j],levelCosmeticFront);
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
			
			var arm:FlxSprite;
			for (i = 0; i < numArms; i++) {
				arm = new FlxSprite(0,0,armSheet); //originally body.x/y
				arm.visible = false;
				arms.add(arm);
			}
			add(arms);
			
			/*
			exitArrow.loadGraphic(arrowSheet,true,false,32,32,true);
			exitArrow.addAnimation("excite",[0,0,1,2,3,4,5,5,5,5,4,3,2,1,0,0],10,true);
			exitArrow.play("excite");
			exitArrow.scrollFactor = new FlxPoint();
			exitArrow.visible = false;
			add(exitArrow);
			exitRad = FlxG.height/2 - exitArrow.width;
			//exitOn = false;
			*/
			
			bodyMarkerGroup = new FlxGroup();
			bodyMarkerTimer = 0;
			cannonMarkerLine = new FlxSprite(0,0,cannonMarkerLineSheet);
			markerEnd = new FlxSprite(0,0);
			markerEnd.loadGraphic(/*handSheet*/Registry.kHandSheet,true,false,32,32);
			markerEnd.frame = 21;
			markerEnd.alpha = 0.75;
			markerEnd.visible = false;
			markerEndGroup = new FlxGroup();
			add(bodyMarkerGroup);
			add(cannonMarkerLine);
			markerEndGroup.add(markerEnd);
			add(markerEndGroup);
			
			addDripperEvent();
			
			// Hand
			hand = groupFromSpawn(RegistryLevels.kSpawnHand,SprHand,levelFunctional).members[0];
			add(hand);
			handDir = FlxObject.RIGHT;
			setDir(hand, FlxObject.DOWN, true);
			
			camTag = new FlxSprite(hand.x,hand.y);
			
			electricity = new FlxSprite(hand.x,hand.y);
			electricity.loadGraphic(electricitySheet,true,false,32,32,true);
			electricity.addAnimation("electricute",[1,2,3,4,5,6,7],22,true);
			electricity.addAnimation("stop",[0]);
			add(electricity);
			
			electricity.play("electricute");
			
			curBody = uint.MAX_VALUE;
			handOut = false;
			handIn = false;
			handGrab = false;
			handMetalFlag = uint.MAX_VALUE;
			handWoodFlag = uint.MAX_VALUE;
			rad = 0;
			lastVel = new FlxPoint();
			
			arrow = new FlxSprite();
			arrow.loadGraphic(arrowSheet);
			arrow.visible = false;
			add(arrow);
			
			pause = new PauseState();
			pause.setAll("exists", false);
			add(pause);
			
			if (Registry.DEBUG_ON) {
				var text:FlxText = new FlxText(0,0,FlxG.width,"Press Esc to return to level select");
				text.scrollFactor = new FlxPoint(0,0);
				add(text);
			}
			
			FlxG.camera.follow(camTag, Registry.extendedCamera?FlxCamera.STYLE_LOCKON:FlxCamera.STYLE_TOPDOWN);
			
			addRoaches();
			
			overlay.makeGraphic(FlxG.width,FlxG.height,0xff000000);
			
			stupidCollisionThing(); // because I took out the hiding part of spawning, but didn't want to create new groups for wood and metal collisions
			
			// TEST BULB
			var $bulb:SprBulb = new SprBulb(hand.x, hand.y);
			add($bulb);
			// TEST EXIT SIGN
			var $exitSign:SprExit = new SprExit(SprExit.kL,hand.x+hand.width*2,hand.y);
			add($exitSign);
		}
		
		private function stupidCollisionThing():void {
			for (var i:uint = 0; i < RegistryLevels.kSpawnEmpty.length; i++) {
				var tmpArray:Array = levelFunctional.getTileInstances(RegistryLevels.kSpawnEmpty[i]);
				if (tmpArray) {
					for (var j:uint = 0; j < tmpArray.length; j++) {
						levelFunctional.setTileByIndex(tmpArray[j],0,false);
					}
				}
			}
		}
		
		private function setUpAudio():void {
			if (!Registry.SOUND_ON) {
				SoundMixer.soundTransform = new SoundTransform(0);	
			}
			
			var $curMus:FlxSound = RegistryLevels.currentMusic;
			var $curMusOverlay:FlxSound = RegistryLevels.currentMusicOverlay;
			
			var $preMus:FlxSound = RegistryLevels.previousMusic;
			var $preMusOverlay:FlxSound = RegistryLevels.previousMusicOverlay;
			
			musOverlay = $curMusOverlay;
			
			if ($preMus && $curMus != $preMus) {
				add($preMus);
				add($preMusOverlay);
				$preMus.fadeOut(2.2);
				$preMusOverlay.fadeOut(2.2);
			}
			$curMus.play();
			$curMusOverlay.play();
			hideMusicOverlayInstantly();
			
			ambientSteamSound.volume = 0.5;
		}
		
		private function addLevelCosmeticBack():void {
			var $lvlCosmBack:FlxTilemap = RegistryLevels.lvlCosmBack();
			if ($lvlCosmBack.totalTiles <= 0) {return;}
			
			$lvlCosmBack.scrollFactor = new FlxPoint(0.5, 0.5);
			
			add($lvlCosmBack);
		}
		
		private function addLevelCosmeticMid():void {
			var $lvlCosmMid:FlxTilemap = RegistryLevels.lvlCosmMid();
			if ($lvlCosmMid.totalTiles <= 0) {return;}
			
			add($lvlCosmMid);
			addHints($lvlCosmMid);
			/*
			// GEARS
			for (var i:int = GEAR_MIN; i <= GEAR_MAX; i++) {
				var gearArray:Array = $lvlCosmMid.getTileInstances(i);
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
						
						var gearPoint:FlxPoint = pointForTile(gearArray[j],$lvlCosmMid);
						var gear:FlxSprite = new FlxSprite(gearPoint.x,gearPoint.y,gearSheet);
						gearGroup.add(gear);
					}
				}
			}
			add(gearInGroup);
			add(gearOutGroup);
			
			// TRASH
			var trashArray:Array = $lvlCosmMid.getTileInstances(TRASH_SPAWN);
			if (trashArray) {
				var trashValidFrames:Array = [0,1,2,3,4,5,6,7];//,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,27,28,29,33,34];
				var trashValidAngles:Array = [90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270];
				for (j = 0; j < trashArray.length; j++) {
					var trashPoint:FlxPoint = pointForTile(trashArray[j],$lvlCosmMid);
					var trash:FlxSprite = new FlxSprite(trashPoint.x,trashPoint.y);
					trash.loadGraphic(trashSheet,true,false,32,32,true);
					trash.color = 0xff555555;
					trash.frame = trashValidFrames[int(Math.random()*(trashValidFrames.length-1))];
					trash.angle = trashValidAngles[int(Math.random()*(trashValidAngles.length-1))];
					trash.immovable = true;
					trashGroup.add(trash);
				}
			}
			add(trashGroup);
			*/
		}
		
		private function addLevelCosmeticFront():void {
			levelCosmeticFront = RegistryLevels.lvlCosmFront();
			if (levelCosmeticFront.totalTiles <= 0) {return;}
			
			/*
			// sign
			var signArray:Array = midground.getTileInstances(SIGN_SPAWN);
			if (signArray) {
			midground.setTileProperties(SIGN_SPAWN,FlxObject.NONE);
			for (j = 0; j < signArray.length; j++) {
			var signPoint:FlxPoint = pointForTile(signArray[j],midground);
			midground.setTileByIndex(signArray[j],0);
			add(new FlxSprite(signPoint.x, signPoint.y, signSheet));
			}
			}*/
			
			add(levelCosmeticFront);
		}
		
		private function addButtons():void {
			buttonGroup = new FlxGroup();
			
			var i:uint;
			var tmpBtn:SprButton;
			
			// DOWN
			var buttonDGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnButtonD,SprButton,levelFunctional);
			for (i = 0; i < buttonDGroup.length; i++) {
				tmpBtn = buttonDGroup.members[i];
				tmpBtn.orientation = SprButton.kDown;
			}
			addMembersInGroupToGroup(buttonDGroup,buttonGroup);
			
			// RIGHT
			var buttonRGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnButtonR,SprButton,levelFunctional);
			for (i = 0; i < buttonRGroup.length; i++) {
				tmpBtn = buttonRGroup.members[i];
				tmpBtn.orientation = SprButton.kRight;
			}
			addMembersInGroupToGroup(buttonRGroup,buttonGroup);
			
			// UP
			var buttonUGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnButtonU,SprButton,levelFunctional);
			for (i = 0; i < buttonUGroup.length; i++) {
				tmpBtn = buttonUGroup.members[i];
				tmpBtn.orientation = SprButton.kUp;
			}
			addMembersInGroupToGroup(buttonUGroup,buttonGroup);
			
			// LEFT
			var buttonLGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnButtonL,SprButton,levelFunctional);
			for (i = 0; i < buttonLGroup.length; i++) {
				tmpBtn = buttonLGroup.members[i];
				tmpBtn.orientation = SprButton.kLeft;
			}
			addMembersInGroupToGroup(buttonLGroup,buttonGroup);
			
			for (i = 0; i < buttonGroup.length; i++) {
				tmpBtn = buttonGroup.members[i];
				tmpBtn.reactionToPress = buttonReaction;
			}
			
			add(buttonGroup);
		}
		
		private function addMembersInGroupToGroup(tmpFrom:FlxGroup,tmpTo:FlxGroup):void {
			for (var i:uint = 0; i < tmpFrom.length; i++) {
				tmpTo.add(tmpFrom.members[i]);
			}
		}
		
		private function addHints($lvl:FlxTilemap):void {
			
			var $hintGroup:FlxGroup = new FlxGroup();
			
			var i:uint;
			var $hint:SprHint;
			
			var $debugCounter:uint = 0;
			
			// HINT 0
			var $hint0Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint0,SprHint,$lvl);
			for (i = 0; i < $hint0Group.length; i++) {
				$hint = $hint0Group.members[i];
				$hint.text = "SCRAP cannot press the LEFT or RIGHT ARROW KEYS to MOVE.";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 1
			var $hint1Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint1,SprHint,$lvl);
			for (i = 0; i < $hint1Group.length; i++) {
				$hint = $hint1Group.members[i];
				$hint.text = "Do NOT push the button. It's very bad. Very, very bad.";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 2
			var $hint2Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint2,SprHint,$lvl);
			for (i = 0; i < $hint2Group.length; i++) {
				$hint = $hint2Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 3
			var $hint3Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint3,SprHint,$lvl);
			for (i = 0; i < $hint3Group.length; i++) {
				$hint = $hint3Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 4
			var $hint4Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint4,SprHint,$lvl);
			for (i = 0; i < $hint4Group.length; i++) {
				$hint = $hint4Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 5
			var $hint5Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint5,SprHint,$lvl);
			for (i = 0; i < $hint5Group.length; i++) {
				$hint = $hint5Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 6
			var $hint6Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint6,SprHint,$lvl);
			for (i = 0; i < $hint6Group.length; i++) {
				$hint = $hint6Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 7
			var $hint7Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint7,SprHint,$lvl);
			for (i = 0; i < $hint7Group.length; i++) {
				$hint = $hint7Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			
			for (i = 0; i < $hintGroup.length; i++) {
				$hint = $hintGroup.members[i];
				$hint.x += Number($lvl.width/$lvl.widthInTiles)/2.0 - $hint.width/2.0;
				$hint.y += Number($lvl.height/$lvl.heightInTiles)/2.0 - $hint.height/2.0;
			}
			
			add($hintGroup);
			
		}
		
		private function addDripperEvent():void {
			
			/*
			dripGroup = new FlxGroup();
			
			var $dripMarkerGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnDrip,FlxSprite,level);
			for (var i:uint = 0; i < $dripMarkerGroup.length; i++) {
				var $spr:FlxSprite = $dripMarkerGroup.members[i];
				
				var $drip:SprDrip = new SprDrip($spr.x,$spr.y);
				dripGroup.add($drip);
				
				var $maybeDrip:Function = function():void {
					//if (!$drip.alive && maybe()) {
						$drip.x = $spr.x;
						$drip.y = $spr.y;
						add($drip);
					//}
				};
				
				var $dripperTimer:EventTimer = new EventTimer(1.1 + Math.random()*2.2,$maybeDrip);
				add($dripperTimer);
			}*/
			
			
			dripGroup = new FlxGroup();
			var tmpMaybeDrip:Function = function():void {
				
				var tmpDripGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnDrip,SprDrip,levelCosmeticFront);
				
				for (var i:uint = 0; i < tmpDripGroup.length; i++) {
					var tmpDrip:SprDrip = tmpDripGroup.members[i];
					if (maybe()) {
						add(tmpDrip);
						dripGroup.add(tmpDrip);
					}
				}
			};
			
			dripperEvent = new EventTimer(2.2,tmpMaybeDrip);
			add(dripperEvent);
			
			
			
			/*
			dripGroup = new FlxGroup();
			
			var $dripSpriteGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnDrip,SprDrip,levelCosmeticFront);
			var $dripSprite:SprDrip;
			var $maybeDrip:Function;
			var $dripEvent:EventTimer;
			
			for (var i:uint = 0; i < $dripSpriteGroup.length; i++) {
				$dripSprite = $dripSpriteGroup.members[i];
				
				var $x:Number = $dripSprite.x;
				Registry.log($x);
				
				$maybeDrip = function():void {
					if (maybe()) {
						var $newDripSprite:SprDrip = $dripSprite.refreshedCopy();
						add($newDripSprite);
						dripGroup.add($newDripSprite);
						
						Registry.log($x);
					}
				};
				
				$dripEvent = new EventTimer(2.2 + Math.random()*2.2,$maybeDrip);
				add($dripEvent);
			}
			*/
			
			
			
		}
		
		private function maybe():Boolean {
			return Math.random()*2 > 1;
		}
		
		private function addRoaches():void {
			roachGroup = groupFromSpawn(RegistryLevels.kSpawnRoaches,SprRoach,levelCosmeticFront);
			add(roachGroup);
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
				
			if (RegistryLevels.isLastLevel()) {overlay.alpha = 1 - Math.abs(levelFunctional.width - hand.x)/levelFunctional.width;}
			//if (Registry.levelNum >= 5) {overlay.alpha = 1 - Math.abs(level.width - hand.x)/level.width;}
			
			if (hand.isAttachedToBody() && !handOut && (!FlxG.keys.RIGHT && !FlxG.keys.LEFT)) {
			//if ((bodyMode || hand.isAttachedToCannon()) && !handOut && (!FlxG.keys.RIGHT && !FlxG.keys.LEFT)) {
				time += FlxG.elapsed;
			} else if (!hand.isAttachedToBody() && hand.velocity.x == 0 && hand.velocity.y == 0) {
			//} else if ((!bodyMode && !hand.isAttachedToCannon()) && hand.velocity.x == 0 && hand.velocity.y == 0) {
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
			
			// escape for debugging (should remove later)
			if (FlxG.keys.justPressed("ESCAPE") && Registry.DEBUG_ON) {
				FlxG.switchState(new LevelSelect);
			}
			
			if (hand.x > FlxG.worldBounds.right || hand.x < FlxG.worldBounds.left ||
				hand.y > FlxG.worldBounds.bottom || hand.y < FlxG.worldBounds.top) {
				//if (doorsDead || RegistryLevels.isLastLevel()) {
				//maybe replace the old doorsDead check with a check to see if the hand is in the right place?
					goToNextLevel();
				/*} else {
					FlxG.resetState();
				}*/
			}
			
			if (FlxG.keys.justPressed("RIGHT") && controlDirs.indexOf(FlxObject.RIGHT) == -1) {
				controlDirs.push(FlxObject.RIGHT);
			}
			if (FlxG.keys.justPressed("LEFT") && controlDirs.indexOf(FlxObject.LEFT) == -1) {
				controlDirs.push(FlxObject.LEFT);
			}
			if (FlxG.keys.justPressed(ACTION_KEY) && controlDirs.indexOf(FlxObject.UP) == -1) {
				controlDirs.push(FlxObject.UP);
			}
			if (FlxG.keys.justPressed(BODY_KEY) && controlDirs.indexOf(FlxObject.DOWN) == -1) {
				controlDirs.push(FlxObject.DOWN);
			}
			if (FlxG.keys.justReleased("RIGHT")) {
				controlDirsRemove(FlxObject.RIGHT);
			}
			if (FlxG.keys.justReleased("LEFT")) {
				controlDirsRemove(FlxObject.LEFT);
			}
			if (FlxG.keys.justReleased(ACTION_KEY)) {
				controlDirsRemove(FlxObject.UP);
			}
			if (FlxG.keys.justReleased(BODY_KEY)) {
				controlDirsRemove(FlxObject.DOWN);
			}
			
			//time += FlxG.elapsed;
			// PRECONDITION: if bodyMode, then curBody < uint.MAX_VALUE
			var body:FlxSprite;
			var bodyGear:FlxSprite;
			var bodyHead:FlxSprite;
			var armBase:FlxSprite;

			var enteringCannon:Boolean = false;
			var enteringBody:Boolean = false;
			
			if (!hand.isAttachedToBody()) {
			//if (!bodyMode && !hand.isAttachedToCannon()) {
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
			
			var touchingMetal:Boolean = (onGround && isMetalInDir(hand, hand.facing/*, 4*/)); //USE ONLY FOR GRAPHICS + AUDIO; THIS MAY CHANGE DURING CONTROLS SECTION
			
			if (enteringBody || hand.isAttachedToGrappler()) {
			//if (enteringBody || bodyMode) {
				body = bodyGroup.members[curBody];
				bodyGear = bodyGearGroup.members[curBody];
				bodyHead = bodyHeadGroup.members[curBody];
				armBase = bodyArmBaseGroup.members[curBody];
			} else if (enteringCannon || hand.isAttachedToCannon()) {
				body = cannonGroup.members[curCannon];
				armBase = cannonArmBaseGroup.members[curCannon];
			}
			
			/*
			if (bodyMode) {
				body = bodyGroup.members[curBody];
				bodyGear = bodyGearGroup.members[curBody];
				bodyHead = bodyHeadGroup.members[curBody];
				armBase = bodyArmBaseGroup.members[curBody];
			} if (hand.isAttachedToCannon()) {
				body = cannonGroup.members[curCannon];
				armBase = cannonArmBaseGroup.members[curCannon];
			}*/
			
			if (hand.overlapsPoint(exitPoint)) {
				touchedExitPoint = true;
			}
			
			/*if (exitOn) {
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
			}*/
			
			if (Registry.cameraFollowsHand) {
				if (onGround) {
					camTag.angle += angleDifference(camAngle, camTag.angle)/12.0;
				} else {
					camTag.angle += angleDifference(hand.angle, camTag.angle)/12.0;
				}
				FlxG.camera.angle = -camTag.angle;
			} else if (camTag.angle != camAngle) {
				camTag.angle += (-camTag.angle + camAngle)/12.0;
				FlxG.camera.angle = -camTag.angle;
			}
			
			if (hand.isAttachedToGrappler()) {
				if (!handOut && !handIn && !handFalling) {
					/*rad = arrow.angle*Math.PI/180;
					var startX:Number = hand.x+hand.width/2.0;
					var startY:Number = hand.y+hand.height/2.0;
					var endX:Number = startX + GRAPPLE_LENGTH * Math.cos(rad);
					var endY:Number = startY + GRAPPLE_LENGTH * Math.sin(rad);*/
					
					camTag.x += (-camTag.x + /*endX*/markerEnd.x)/44.0;
					camTag.y += (-camTag.y + /*endY*/markerEnd.y)/44.0;
					
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
			FlxG.camera.target.x += dScreenX;
			FlxG.camera.target.y += dScreenY;
			//camTag.y -= dScreenY;
			*/
			
			/* else if (hand.isAttachedToCannon()) {
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
			/*
			hint.x = hand.x + hand.width - hint.width/2.0;// + (hint.width/2.0)*Math.sin(theta);
			hint.y = hand.y + hand.height - hint.height;// - (hint.height/2.0)*Math.cos(theta);
			//hint.angle = hand.angle;
			*/
			
			// marker glow (for hand overlapping)
			hand.color = poleCol; //retrieved through get function below
			electricity.color = poleCol;
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
			for (mmm in arms.members) {
				arms.members[mmm].color = poleCol;
			}
			
			var handOnJumpGroup:Boolean = false;/*
			for (var tt:uint = 0; tt < jumpHintGroup.length; tt++) {
				if (hand.overlaps(jumpHintGroup.members[tt])) {
					handOnJumpGroup = true;
				}
			}*/
			
			var pulseNum:Number = int((pulseTimer/pulseTimeMax)*5) + 7;
			if (pulseNum >= 15) {pulseNum = 15;}
			if (pulseNum <= 7) {pulseNum = 7;}
			//col = pulseNum*Math.pow(16,4) + pulseNum*Math.pow(16,5);
			col = pulseNum*Math.pow(16,2) + pulseNum*Math.pow(16,3);
			
			if (!hand.isAttachedToBody()) {
			//if (!hand.isAttachedToCannon() && !bodyMode) {
				/*
				if (time >= IDLE_TIME) {
					hint.play("enter");
				} else if ((enteringBody || enteringCannon ) && Registry.neverEnteredBodyOrCannon) {
					hint.play("Z");
				}*/
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
				/*
				else if (Registry.neverJumped && handOnJumpGroup && hand.angle == 90) {
					hint.play("X");
				} else {
					hint.play("idle");
				}
				*/
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
			} else if (hand.isAttachedToBody()) {
			//} else if (hand.isAttachedToCannon() || bodyMode) {
				/*
				if (time >= IDLE_TIME) {
					hint.play("enter");
				} else if (Registry.neverAimedBodyOrCannon) {
					hint.play("arrows");
				} else if (Registry.neverFiredBodyOrCannon) {
					hint.play("left X right");
				} else {
					hint.play("idle");
				}*/
				if (hand.isAttachedToCannon()) {
					body.color = poleCol;
					armBase.color = poleCol;
				} else if (hand.isAttachedToGrappler()) {
					body.color = poleCol;
					armBase.color = poleCol;
					bodyGear.color = poleCol;
					bodyHead.color = poleCol;
				}
			}
			/*
			if (FlxG.paused) {
				hint.play("idle");
			}
			*/
			/* Begin Audio */
			// Something's not quite right here...
			// The hand jumped
			if (!hand.isAttachedToBody() && FlxG.keys.justPressed(ACTION_KEY) && /*hand.touching*/onGround && hand.facing != FlxObject.DOWN) {
			//if ((!bodyMode && !hand.isAttachedToCannon()) && FlxG.keys.justPressed(ACTION_KEY) && /*hand.touching*/onGround && hand.facing != FlxObject.DOWN) {
				jumpSound.play();
			} else if (!hand.isAttachedToBody() && hand.touching) {
			//} else if ((!bodyMode && !hand.isAttachedToCannon()) && hand.touching) {
				jumpSound.stop();
			}
				
			// The hand is crawling on wood or metal
			if (!hand.isAttachedToBody() && /*hand.touching*/onGround && (hand.velocity.x != 0 || hand.velocity.y != 0)) {
			//if ((!bodyMode &&!hand.isAttachedToCannon()) && /*hand.touching*/onGround && (hand.velocity.x != 0 || hand.velocity.y != 0)) {
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
			if (hand.isAttachedToBody() && !handOut && !handIn && !handFalling) {
			//if ((bodyMode || hand.isAttachedToCannon()) && !handOut && !handIn) {
				grappleExtendSound.stop();
				if ((FlxG.keys.RIGHT || FlxG.keys.LEFT) && -270 < hand.angle - body.angle && hand.angle - body.angle < -90) {
					robodyAimSound.play();
				} else {
					robodyAimSound.stop();
				}
			}
				// The hand is launching out of the body
			else if (hand.isAttachedToGrappler() && (handOut || handIn)) {
			//else if (bodyMode && (handOut || handIn)) {
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
			if (hand.isAttachedToGrappler() && handIn && hand.overlaps(body) && ((hand.angle < body.angle - 270) || (body.angle - 90 < hand.angle))) {
			//if (bodyMode && handIn && hand.overlaps(body) && ((hand.angle < body.angle - 270) || (body.angle - 90 < hand.angle))) {
				robodyLandOnWallSound.play();
			}
			
			// hand electricity
			if (/*hand.touching && !lastTouchedWood*/touchingMetal) {
				ambientElectricalHumSound.play();
			} else {
				ambientElectricalHumSound.stop();
			}
			
			// cannon fire
			if (hand.isAttachedToCannon() && FlxG.keys.justPressed(ACTION_KEY)) {
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
			/*
			for (var qq:uint = 0; qq < buttonGroup.length; qq++) {
				var button:FlxSprite = buttonGroup.members[qq];
				var buttonState:Boolean = buttonStateArray[qq];
				if (button.frame != BUTTON_PRESSED && (hand.overlaps(button) && !buttonState)) {
					buttonPressSound.stop();
					buttonPressSound.play();
				}
			*/
				/*
				if (button.frame == 2) {
					ambientGearsSound.play();
				}
				if (button.frame == 3) {
					ambientSteamSound.play();
				}
				*/
				/*
			}*/
			
			checkIfButtonPressedByHand();
			
			for (var qq:uint = 0; qq < steams.length; qq++) {
				if (steams.members[qq].frame == 1) {
					ambientSteamSound.stop();
					ambientSteamSound.play();
				}
			}
			
			
			// door open
			/*for (var ab:int = doorGroup.length-1; ab >= 0; ab--) {
				if (doorGroup.members[ab].frame == 1) {
					doorOpenSound.stop();
					doorOpenSound.play();
					ambientGearsSound.play();
				}
			}*/
			/* End Audio */
			
			// to time the fall for the different falling rot, really belongs with anim stuff
			if (/*hand.touching*/onGround) {handFalling = false; timeFallen = 0;}
			timeFallen += FlxG.elapsed;
			
			// less janky way of getting gears/heads to move with body...
			if (hand.isAttachedToGrappler()) {
			//if (bodyMode) {
				
				var theta:Number = (body.angle-90)*Math.PI/180.0;
				
				bodyHead.x = body.x + body.width/2.0 - bodyHead.width/2.0 + (bodyHead.height*1.5)*Math.cos(theta);
				bodyHead.y = body.y + body.height/2.0 - bodyHead.height/2.0 + (bodyHead.height*1.5)*Math.sin(theta);
				bodyHead.angle = body.angle;
				
				bodyGear.x = body.x + body.width/2.0 - bodyGear.width/2.0 + (bodyGear.width/2.0)*Math.cos(theta-Math.PI/2.0);
				bodyGear.y = body.y + body.height/2.0 - bodyGear.height/2.0 + (bodyGear.height/2.0)*Math.sin(theta-Math.PI/2.0);
				bodyGear.angle = -hand.angle;
			}
			if (hand.isAttachedToBody()) {
			//if (bodyMode || hand.isAttachedToCannon()) {
				if (!handOut) {
					armBase.angle = hand.angle - 180;
				}
				armBase.x = body.x;
				armBase.y = body.y;
			}
			
			// make arrow pulse
			/*exitArrow.alpha = (6.0 - exitArrow.frame)/6.0 + 0.22;*/
			
			/*
			// Press Buttons!
			for (var mm:uint = 0; mm < buttonGroup.length; mm++) {
				button = buttonGroup.members[mm];
				buttonState = buttonStateArray[mm];
				var bangFrame:Number = buttonBangGroup.members[mm].frame;
				buttonBangGroup.members[mm].alpha = (6.0 - bangFrame)/6.0 + 0.22;
				if (button.frame != BUTTON_PRESSED && hand.overlaps(button) && !buttonState && onGround) { // should change this to make it only recognize the space where the button is visually
					button.frame = BUTTON_PRESSED;
					buttonStateArray[mm] = true;
					buttonReactionArray[mm]();
					//buttonBangGroup.members[mm].kill();*/
					/*for (var bb:String in doorGroup.members) {
						var door:FlxSprite = doorGroup.members[bb];
						if (door.frame == 13) {door.play("pulse 1");}
						else if (14 <= door.frame && door.frame <= 17) {door.play("pulse 2");}
					}*//*
				} else if (button.frame == BUTTON_PRESSED && !hand.overlaps(button) && buttonState) { // should change this to make it only recognize the space where the button is visually
					button.frame = BUTTON_INIT;
					buttonStateArray[mm] = false;
				}
			}*/
			
			// Bring midground to life
				
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
			
			/* Begin Animations */
			// The hand is not attached to a body
			if (!hand.isAttachedToBody()) {
			//if (!bodyMode && !hand.isAttachedToCannon()) {
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
							hand.play(SprHand.kAnimCrawlLeft);
						} else if (hand.velocity.x == 0 && hand.velocity.y == 0) {
							hand.play(SprHand.kAnimIdleLeft);
						}
					} else if (handDir == FlxObject.RIGHT) {
						if ((hand.facing == FlxObject.UP && hand.velocity.x < 0) ||
							(hand.facing == FlxObject.DOWN && hand.velocity.x > 0) ||
							(hand.facing == FlxObject.LEFT && hand.velocity.y > 0) ||
							(hand.facing == FlxObject.RIGHT && hand.velocity.y < 0)) {
							hand.play(SprHand.kAnimCrawlRight);
						} else if (hand.velocity.x == 0 && hand.velocity.y == 0) {
							hand.play(SprHand.kAnimIdleRight);
						}
					}
					// The hand is about to jump from a flat surface
					if (FlxG.keys.justPressed(ACTION_KEY) && hand.facing != FlxObject.DOWN) {
						if (handDir == FlxObject.LEFT) {hand.play(SprHand.kAnimFallLeft);} //<- placeholder {hand.play("jump left");}
						else if (handDir == FlxObject.RIGHT) {hand.play(SprHand.kAnimFallRight);} //<- placeholder {hand.play("jump right");}
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
						hand.play(SprHand.kAnimFallLeft); //<- placeholder {hand.play("jump left");
						//}
					} else if (handDir == FlxObject.RIGHT) {
						/*if ((hand.facing == FlxObject.UP && hand.angle < 270) ||
						(hand.facing == FlxObject.DOWN && hand.angle < 90) ||
						(hand.facing == FlxObject.LEFT && hand.angle < 180) ||
						(hand.facing == FlxObject.RIGHT && hand.angle < 360)) { <- this line's not working
						*/
						hand.angle += 2.2;
						hand.play(SprHand.kAnimFallRight); //<- placeholder {hand.play("jump right");
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
							hand.play(SprHand.kAnimFallLeft);
							hand.angle += 10;
						} else if (handDir == FlxObject.RIGHT) {
							hand.play(SprHand.kAnimFallRight);
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
			else if (hand.isAttachedToBody()) {
			//else if (bodyMode || hand.isAttachedToCannon()) {
				// The hand is idling in the body
				if (!handOut && !handIn && !handFalling) {
					hand.angle = arrow.angle - 90;
					/*body.angle = bodyTargetAngle;
					if (body.angle == 0) {body.facing = FlxObject.DOWN;}
					else if (body.angle == 270) {body.facing = FlxObject.RIGHT;}
					else if (body.angle == 180) {body.facing = FlxObject.UP;}
					else if (body.angle == 90) {body.facing = FlxObject.LEFT;}*/
					adjustBody(body);
					
					if (handDir == FlxObject.LEFT) {hand.play(SprHand.kAnimIdleBodyLeft);}
					else {hand.play(SprHand.kAnimIdleBodyRight);}
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
						if (handDir == FlxObject.LEFT) {hand.play(SprHand.kAnimExtendLeft);}
						else {hand.play(SprHand.kAnimExtendRight);} // maybe there should be an animation for extending?
					} else {
						if (handDir == FlxObject.LEFT) {hand.play(SprHand.kAnimIdleBodyLeft);}
						else {hand.play(SprHand.kAnimIdleBodyRight);}
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
			
			/* End Animations */
			
			if (hand.isAttachedToBody()) {
				
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
				
				if (body.acceleration.y == 0) {
					body.velocity.x = 0;
					body.velocity.y = 0;
					hand.velocity.x = 0;
					hand.velocity.y = 0;
				}
				var diffX:Number = hand.getMidpoint().x - body.getMidpoint().x; //hand.x + hand.width/2.0 - body.x - body.width/2.0;
				var diffY:Number = hand.getMidpoint().y - body.getMidpoint().y; //hand.y + hand.width/2.0 - body.y - body.height/2.0;
				if (handOut) {
					//rad = Math.atan2(diffY, diffX);
					//arrow.angle = 180*rad/Math.PI;
					//rad = arrow.angle*Math.PI/180;
					if (hand.touching <= 0 && Math.pow(diffX, 2) + Math.pow(diffY, 2) < Math.pow(GRAPPLE_LENGTH,2)) {
						hand.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
						hand.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
						FlxG.log(hand.velocity.x + " " + hand.velocity.y);
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
						hand.allowCollisions = FlxObject.ANY;
						if (isMetalInDir(body, body.facing)) {
							markerEnd.visible = true;
							updateRaytrace(arrow.angle);
						} else {
							setDir(body,FlxObject.DOWN,true);
							setDir(hand,FlxObject.DOWN,true);
							handFalling = true;
						}
					}
				} if (!handOut && !handIn && !handFalling) {
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
					if (playerIsPressing(FlxObject.DOWN)) {
						controlDirs = new Array();
						if (hand.isAttachedToGrappler()) {
						//if (bodyMode) {
							lastTouchedWood = false;
							hand.detachFromGrappler();
							addHeartSad();
							hideMusicOverlay();
						} else if (hand.isAttachedToCannon()) {
							hand.detachFromCannon();
						}
						//bodyMode = false;
						markerEnd.visible = false;
						setDir(hand, body.facing);
					}
					rad = Math.PI*arrow.angle/180;
					if (playerIsPressing(FlxObject.UP) && hand.isAttachedToGrappler()) {
					//if (FlxG.keys.justPressed(ACTION_KEY) && bodyMode) {
						controlDirsRemove(FlxObject.UP);
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
						
					} else if (playerIsPressing(FlxObject.UP) && hand.isAttachedToCannon()) {
						controlDirsRemove(FlxObject.UP);
						hand.detachFromCannon(); //change to fireCannon method
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
				if (playerIsPressing(FlxObject.DOWN)) {
					controlDirsRemove(FlxObject.DOWN);
					if (enteringBody) {
						controlDirs = new Array();
						hand.attachToGrappler();
						addHeartHappy();
						showMusicOverlay();
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
						controlDirs = new Array();
						hand.attachToCannon();
						lastTouchedWood = false;
						handFalling = false;
						onGround = true;
						
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
						} if (playerIsPressing(FlxObject.UP)) {
							controlDirsRemove(FlxObject.UP)
							if (handIsFacing(FlxObject.UP)) {
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
			
			if (hand.isAttachedToGrappler() && !handOut && !handIn && !handFalling) {
				theta = (arrow.angle)*Math.PI/180.0;
				var dotNum:int = int(Math.sqrt(Math.pow(markerEnd.x-body.x, 2) + Math.pow(markerEnd.y-body.y, 2)))/DOT_SPACING;
				for (var n:int = 0; n <= dotNum; n++) {
					if (bodyMarkerGroup.length <= n) {
						bodyMarkerGroup.add(new FlxSprite().makeGraphic(2, 2, 0xffffffff));
						if (bodyMarkerGroup.length == 1) {
							updateRaytrace(arrow.angle);
						}
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
			if (hand.isAttachedToCannon()) {
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
			
			for (var mmmmm:uint = 0; mmmmm < roachGroup.length; mmmmm++) {
				var tmpRoach:SprRoach = roachGroup.members[mmmmm];
				tmpRoach.goAwayFromSprite(hand);
			}
			
			handMetalFlag = uint.MAX_VALUE;
			handWoodFlag = uint.MAX_VALUE;
	
			FlxG.collide(dripGroup,levelFunctional);

			FlxG.collide(levelFunctional,hand);
			FlxG.collide(levelFunctional,bodyGroup);
			
			if (FlxG.collide(markerEnd, levelFunctional)) {
				markerEnd.velocity.x = 0;
				markerEnd.velocity.y = 0;
			}
			correctMetal();
			if (!hand.isAttachedToGrappler() && onGround) {
			//if (!bodyMode && onGround) {
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
				} else if (hand.facing != FlxObject.DOWN && !isMetalInDir(hand, hand.facing/*, 4*/)) { //replacing || lastTouchedWood
					setDir(hand,FlxObject.DOWN,true);
				}
			}
						
			// Pause
			if (FlxG.keys.justPressed("ENTER")) {
				FlxG.paused = !FlxG.paused;
				pause.setAll("exists", FlxG.paused);
				//IDLE_TIME = 22;
			}
			
			if (FlxG.paused) {
				if (hand.isAttachedToBody()) {
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
			if (reversePolarity) {
				woodStuff(tile.mapIndex, spr);
			} else {
				metalStuff(tile.mapIndex, spr);
			}
		}
		
		public function metalStuff(ind:uint, spr:FlxSprite):void {
			if (spr == hand && !hand.isAttachedToCannon()) {
				handMetalFlag = ind;
				lastTouchedWood = false;
				fixGravity(spr);
			} else if (spr == markerEnd) {
				setGrappleOkay();
			} else if (isBody(spr)) {
				fixGravity(spr);
			}
		}
		
		public function woodCallback(tile:FlxTile, spr:FlxSprite):void {
			if (reversePolarity) {
				metalStuff(tile.mapIndex, spr);
			} else {
				woodStuff(tile.mapIndex, spr);
			}
		}
		
		public function woodStuff(ind:uint, spr:FlxSprite):void {
			if (spr == hand) {
				handWoodFlag = ind;
				lastTouchedWood = true;
				if (!hand.isAttachedToGrappler() || handFalling) {
				//if (!bodyMode) {
					fixGravity(spr);
				}
			} else if (isBody(spr)) {
				fixGravity(spr);
			}
		}
		
		public function neutralCallback(tile:FlxTile, spr:FlxSprite):void {
			woodStuff(tile.mapIndex, spr);
		}
		
		public function dirtCallback(tile:FlxTile, spr:FlxSprite):void {
			lastTouchedDirt = true;
			woodCallback(tile,spr);
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
				
		public function fixGravity(spr:FlxSprite):void {
			var hitOnlyWood:Boolean = true;
			if (spr.isTouching(FlxObject.DOWN)) {
				hitOnlyWood = false;
				setDir(spr, FlxObject.DOWN);
			} else if (spr.isTouching(FlxObject.UP) && isMetalInDir(spr,FlxObject.UP/*, 4*/)) { //max was originally 3, but I think that was a typo from back when there were corners
				hitOnlyWood = false;
				setDir(spr, FlxObject.UP);
			} else if (spr.isTouching(FlxObject.LEFT) && isMetalInDir(spr,FlxObject.LEFT/*, 4*/)) {
				hitOnlyWood = false;
				setDir(spr, FlxObject.LEFT);
			} else if (spr.isTouching(FlxObject.RIGHT) && isMetalInDir(spr,FlxObject.RIGHT/*, 4*/)) {
				hitOnlyWood = false;
				setDir(spr, FlxObject.RIGHT);
			}
			if (hitOnlyWood && !onGround && spr.facing != FlxObject.DOWN) { //if the hand only hit wood after being shot by steam
				setDir(spr, FlxObject.DOWN, true);
			}
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
			if (spr == hand) {
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
			} else if (isBody(spr)) {
				adjustBody(spr);
				showArrow();
			}
		}
		
		public function handIsFacing(dir:uint):Boolean {
			return (hand.facing & dir) > 0;
		}
		
		// I kind of want to nix arrows and bodyTargetAngle etc
		public function showArrow():void {
			arrow.angle = bodyGroup.members[curBody].angle - 90;
			arrowStartAngle = arrow.angle;
		}
		
		public function isMetal(tile:uint):Boolean {
			//return (tile >= METAL_MIN && tile <= METAL_MAX);
			if (reversePolarity) {
				return RegistryLevels.kSpawnWood.indexOf(tile) != -1;
			}
			return RegistryLevels.kSpawnMetal.indexOf(tile) != -1;
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
			reversePolarity = !reversePolarity;
		}
		
		public function playerIsPressing(dir:uint):Boolean {
			if (dir == FlxObject.LEFT) {
				return controlDirs.indexOf(FlxObject.LEFT) > controlDirs.indexOf(FlxObject.RIGHT);
			} else if (dir == FlxObject.RIGHT) {
				return controlDirs.indexOf(FlxObject.LEFT) < controlDirs.indexOf(FlxObject.RIGHT);
			} else if (dir == FlxObject.UP) {
				return controlDirs.indexOf(FlxObject.UP) > -1;
			} else if (dir == FlxObject.DOWN) {
				return controlDirs.indexOf(FlxObject.DOWN) > -1;
			}
			return false;
		}
		
		public function goToNextLevel():void {
			
			// sound stuff
			ambientGearsSound.stop();
			ambientSteamSound.stop();
			ambientElectricalHumSound.stop();
			
			RegistryLevels.num++;
			FlxG.switchState(new PlayState);
			/*
			Registry.levelNum++;
			if (Registry.levelNum < Registry.levelOrder.length) {
				Registry.level = Registry.levelOrder[Registry.levelNum];
				Registry.midground = Registry.midOrder[Registry.levelNum];
				Registry.background = Registry.backOrder[Registry.levelNum];
				FlxG.switchState(new PlayState);//(Registry.levelOrder[Registry.levelNum],Registry.midgroundMap,Registry.backgroundMap));
			} else {
				FlxG.switchState(new EndState());
			}
			*/
		}
		
		public function controlDirsRemove(dir:uint):void {
			var cD:int = controlDirs.indexOf(dir);
			if (cD != -1) {
				controlDirs.splice(cD, 1);
			}
		}
		
		public function correctMetal():void {
			if (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE) {
				/* since Flixel only ever calls one tile callback function, the one corresponding to the topmost or leftmost corner 
				of the hand against the surface, we must do this check for the other corner to compensate */
				if ((hand.isTouching(FlxObject.UP) && isMetalInDir(hand, FlxObject.UP/*, 4*/)) 
				 || (hand.isTouching(FlxObject.DOWN) && isMetalInDir(hand, FlxObject.DOWN/*, 4*/))
				 || (hand.isTouching(FlxObject.LEFT) && isMetalInDir(hand, FlxObject.LEFT/*, 4*/))
				 || (hand.isTouching(FlxObject.RIGHT) && isMetalInDir(hand, FlxObject.RIGHT/*, 4*/))) {
					metalStuff(1, hand);
				}
			}
		}
		
		public function isMetalInDir(spr:FlxSprite, dir:uint):Boolean {
			var indX:uint = int(spr.x/8);
			var indY:uint = int(spr.y/8);
			var max:int;
			if (dir == FlxObject.LEFT) {
				if (spr.y % 8 == 0) {
					max = 3;
				} else {
					max = 4;
				}
				for (var a:uint = 0; a <= max; a++) {
					if (indY < levelFunctional.heightInTiles - a && isMetal(levelFunctional.getTile(indX-1, indY+a))) {
						return true;
					}
				}
			} else if (dir == FlxObject.RIGHT) {
				if (spr.y % 8 == 0) {
					max = 3;
				} else {
					max = 4;
				}
				for (var b:uint = 0; b <= max; b++) {
					if (indY < levelFunctional.heightInTiles - b && isMetal(levelFunctional.getTile(indX+4, indY+b))) {
						return true;
					}
				}
			} else if (dir == FlxObject.UP) {
				if (spr.x % 8 == 0) {
					max = 3;
				} else {
					max = 4;
				}
				for (var c:uint = 0; c <= max; c++) {
					if (indX < levelFunctional.widthInTiles - c && isMetal(levelFunctional.getTile(indX+c, indY-1))) {
						return true;
					}
				}
			} else if (dir == FlxObject.DOWN) {
				if (spr.x % 8 == 0) {
					max = 3;
				} else {
					max = 4;
				}
				for (var d:uint = 0; d <= max; d++) {
					if (indX < levelFunctional.widthInTiles - d && isMetal(levelFunctional.getTile(indX+d, indY+4))) {
						return true;
					}
				}
			}
			return false;
		}
		
		public function isNothingInDir(dir:uint, max:uint):Boolean {
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
			return false;
		}
		
		public function jumpStuff():void {
			handFalling = true;
			Registry.neverJumped = false;
			setDir(hand,FlxObject.DOWN,true);
		}
		
		public function updateRaytrace(angle:Number):void {
			if (hand.isAttachedToGrappler()) {
			//if (bodyMode) {
				markerEnd.angle = angle-90;
				var theta:Number = angle*Math.PI/180.0;
				markerEnd.x = hand.x;
				markerEnd.y = hand.y;
				markerEnd.velocity.x = GRAPPLE_SPEED*Math.cos(theta);
				markerEnd.velocity.y = GRAPPLE_SPEED*Math.sin(theta);
				//markerEnd.color = Math.min(col*2, 0x00ff00/*0xff0000*/);
				markerEnd.visible = false;
				bodyMarkerGroup.setAll("color", 0xff0000);
				while (Math.sqrt(Math.pow(markerEnd.x-hand.x, 2) + Math.pow(markerEnd.y-hand.y, 2)) < GRAPPLE_LENGTH) {
					markerEndGroup.update();
					if (FlxG.collide(markerEnd, /*level*/levelFunctional, raytraceCallback)/* || FlxG.collide(markerEnd, doorGroup, raytraceDoorCallback)*/) {
						break;
					}
				}
				if (FlxG.overlap(markerEnd, buttonGroup)) {
					setGrappleButton();
				} else if (markerEnd.touching != 0 && isMetalInDir(markerEnd, markerEnd.touching/*, 4*/)) {
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
		
		public function setGrappleOkay():void {
			markerEnd.visible = true;
			markerEnd.color = poleCol;
			//markerEnd.color = 0xffffff;
			bodyMarkerGroup.setAll("color", 0xffffff);
		}
		
		public function setGrappleButton():void {
			markerEnd.visible = true;
			markerEnd.color = col;
			//markerEnd.color = 0xffffff;
			bodyMarkerGroup.setAll("color", col);
		}
		
		private function groupFromSpawn(_spawn:Array,_class:Class,_map:FlxTilemap):FlxGroup {
			var _group:FlxGroup = new FlxGroup();
			for (var i:uint = 0; i <_spawn.length; i++) {
				var _array:Array = _map.getTileInstances(_spawn[i]);
				if (_array) {
					for (var j:uint = 0; j < _array.length; j++) {
						var _point:FlxPoint = pointForTile(_array[j],_map);
						_group.add(new _class(_point.x,_point.y));
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
		
		private function checkIfButtonPressedByHand():void {
			
			var tmpShouldToggleAll:Boolean;
			var i:uint;
			var tmpBtn:SprButton;
			
			for (i = 0; i < buttonGroup.length; i++) {
				tmpBtn = buttonGroup.members[i];
				if (tmpBtn.canBePressed() && hand.overlaps(tmpBtn)) {
					tmpBtn.press();
					tmpShouldToggleAll = true;
				} else if (!tmpBtn.canBePressed() && !hand.overlaps(tmpBtn)) {
					tmpBtn.unpress();
				}
			}
			
			if (tmpShouldToggleAll) {
				for (i = 0; i < buttonGroup.length; i++) {
					tmpBtn = buttonGroup.members[i];
					tmpBtn.toggleColor();
					if (!hand.overlaps(tmpBtn)) {
						tmpBtn.unpress();
					}
				}
			}
		}
		
		private function addHeartHappy():void {
			var $heart:SprHeart = new SprHeart(hand);
			add($heart);
			$heart.makeHappy();
		}
		
		private function addHeartSad():void {
			var $Heart:SprHeart = new SprHeart(hand);
			add($Heart);
			$Heart.makeSad();
		}
		
		private function hideMusicOverlayInstantly():void {
			musOverlay.volume = 0;
		}
		
		private function hideMusicOverlay():void {
			//musOverlay.volume = 0;
			
			var $timer:EventTimer;
			
			musOverlay.volume = 1;
			var $event:Function = function():void {
				remove($timer);
				musOverlay.volume = 0;
			};
			var $pulse:Function = function():void {
				musOverlay.volume -= 0.05;
			};
			$timer = new EventTimer(0.5,$event,false,true,$pulse);
			add($timer);
		}
		
		private function showMusicOverlay():void {
			//musOverlay.volume = 1;
			
			var $timer:EventTimer;
			
			musOverlay.volume = 0;
			var $event:Function = function():void {
				remove($timer);
				musOverlay.volume = 1;
			};
			var $pulse:Function = function():void {
				musOverlay.volume += 0.05;
			};
			$timer = new EventTimer(0.5,$event,false,true,$pulse);
			add($timer);
		}
		
		private function get poleCol():uint {
			return reversePolarity?0xff0000:0xffff00;
		}
		
		private function isBody(spr:FlxSprite):Boolean {
			return bodyGroup.members.indexOf(spr) > -1;
		}
		
		private function adjustBody(spr:FlxSprite):void {
			if (spr.facing == FlxObject.DOWN) {spr.angle = 0;}
			else if (spr.facing == FlxObject.LEFT) {spr.angle = 90;}
			else if (spr.facing == FlxObject.UP) {spr.angle = 180;}
			else if (spr.facing == FlxObject.RIGHT) {spr.angle = 270;}
		}
	}
}