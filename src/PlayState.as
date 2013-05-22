package {
	
	import flashx.textLayout.formats.Float;
	
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	public class PlayState extends FlxState {
		
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
		public const METAL_MIN:uint = 65; //minimum index number of metal in the tilemap
		public const METAL_MAX:uint = 147; //maximum index number of metal in the tilemap
		public const WOOD_MIN:uint = 1; //minimum index number of wood in the tilemap
		public const WOOD_MAX:uint = 64; // maximum index number of wood in the tilemap
		public const UNTOUCHABLE_MIN:uint = 148;
		public const UNTOUCHABLE_MAX:uint = 170;
		
		public const UNTOUCHABLE_OVERFLOW_MIN:uint = 192;
		public const UNTOUCHABLE_OVERFLOW_MAX:uint = 231;
		public const WOOD_OVERFLOW_MIN:uint = 232;
		public const WOOD_OVERFLOW_MAX:uint = 251;
		
		public const GRASS_MIN:uint = 272;
		public const GRASS_MAX:uint = 286;
		public const UNTOUCHABLE_GRASS_MIN:uint = 264;
		public const UNTOUCHABLE_GRASS_MAX:uint = 271;
		
		public const EMPTY_SPACE:uint = 0; // index of empty space in tilemap
		public const GRAPPLE_LENGTH:uint = 320; // maximum length of the grappling arm
		
		//public const SOUND_ON:Boolean = false;
		
		/* Level Spawn Points */
		public const HAND_SPAWN:uint = 191;
		public const BODY_SPAWN:uint = 190;
		public const CANNON_SPAWN:uint = 189;
		public const DOOR_MIN:uint = 184;
		public const DOOR_MAX:uint = 185;
		public const BUTTON_MIN:uint = 172;
		public const BUTTON_MAX:uint = 183;
		
		public const EXIT_SPAWN:uint = 171;
		
		/* Midground Spawn Points */
		public const GEAR_MIN:uint = 1;
		public const GEAR_MAX:uint = 18;
		public const STEAM_MIN:uint = 19;
		public const STEAM_MAX:uint = 30;
		public const TRASH_SPAWN:uint = 31;
		
		//button animation frames
		public const BUTTON_PRESSED:uint = 0;
		public const BUTTON_INIT:uint = 1;
		
		public const ACTION_KEY:String = "X";
		public const BODY_KEY:String = "Z";
		
		public var reinvigorated:Boolean;
		
		public var pause:PauseState;
		
		public var touchedExitPoint:Boolean = false;
		
		public var dbg:int;
		public var rad:Number;
		public var controlDirs:Array;
		public var lastGround:uint;
		public var tempGround:uint;
		
		public var electricityNum:int = 1;
		
		public var doorsDead:Boolean = false;
		
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
		
		public var markerLine:FlxSprite = new FlxSprite();
		//public var hintArrow:FlxSprite = new FlxSprite();
		public var exitArrow:FlxSprite = new FlxSprite();
		public var exitRad:Number;
		public var exitOn:Boolean;
		
		public var cannonGroup:FlxGroup = new FlxGroup();
		
		public var exitPoint:FlxPoint = new FlxPoint();
		
		public var trashGroup:FlxGroup = new FlxGroup();
		
		[Embed("assets/cannon.png")] public var cannonSheet:Class;
		
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
		public var ambientSteamSound:FlxSound = new FlxSound().loadEmbedded(ambientSteamSFX,true);
		public var doorOpenSound:FlxSound = new FlxSound().loadEmbedded(doorOpenSFX);
		
		[Embed("assets/steam.png")] public var steamSheet:Class;
		
		[Embed("assets/head.png")] public var headSheet:Class;
		
		/*public function PlayState(level:Class,midground:Class,background:Class) {
			
			//if (Registry.DEBUG_ON) {
				levelMap = level;
				midgroundMap = midground;
				backgroundMap = background;
			//}
		}*/
		
		override public function create():void {
			
			if (!Registry.DEBUG_ON) {
				Registry.level = Registry.levelOrder[Registry.levelNum];
				Registry.midground = Registry.midOrder[Registry.levelNum];//Registry.midgroundMap;
				Registry.background = Registry.backOrder[Registry.levelNum];//Registry.backgroundMap;
			}
			
			levelMap = Registry.level;
			midgroundMap = Registry.midground;
			backgroundMap = Registry.background;
			
			dbg = 0;
			timeFallen = 0; //this was initialized above, so I moved it here for saftey's sake- mjahearn
			reinvigorated = false; //ditto
			controlDirs = new Array();
			lastGround = FlxObject.DOWN;
			tempGround = FlxObject.DOWN;
			
			/* Background */
			var background:FlxTilemap = new FlxTilemap().loadMap(new backgroundMap,backgroundset,8,8);
			background.scrollFactor = new FlxPoint(0.5, 0.5);
			add(background);
			if (Registry.levelNum < 5) {
				FlxG.bgColor = 0xff090502;
			} else {
				FlxG.bgColor = 0xff442288;
				//0xffaaaaaa; //and... if we want motion blur... 0x22000000
			}
			
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
				var trashValidFrames:Array = [0,1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,27,28,29,33,34];
				var trashValidAngles:Array = [90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270];
				for (j = 0; j < trashArray.length; j++) {
					var trashPoint:FlxPoint = pointForTile(trashArray[j],midground);
					var trash:FlxSprite = new FlxSprite(trashPoint.x,trashPoint.y);
					trash.loadGraphic(handSheet,true,false,32,32,true);
					trash.color = (0xffff0000 & Math.random()*0xffffffff)
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
			
			// Steam
			for (i = STEAM_MIN; i <= STEAM_MAX; i++) {
				var steamArray:Array = midground.getTileInstances(i);
				if (steamArray) {
					for (j = 0; j < steamArray.length; j++) {
						var steamPoint:FlxPoint = pointForTile(steamArray[j],midground);
						var steam:FlxSprite = new FlxSprite(steamPoint.x,steamPoint.y);
						steam.alpha = 0.5;
						steam.loadGraphic(steamSheet,true,false,32,32,true);
						steam.addAnimation("idle",[0]);
						steam.play("idle");
						
						// Decide steam angle
						// n.b. Steam is grouped in 3 frequencies, 4 angles
						var steamGaugeNumber:Number = (i-STEAM_MIN)%4
						if (steamGaugeNumber == 0) {steam.angle = 90;}
						else if (steamGaugeNumber == 1) {steam.angle = 180;}
						else if (steamGaugeNumber == 2) {steam.angle = 270;}
						
						// Decide steam pattern
						// n.b. Steam is group in 3 patterns
						// maybe these could just be timed using FlxG.elapsed, and then each puff could be synced with sound
						steamGaugeNumber = (i-STEAM_MIN);
						var steamPuffFrames:Array;
						if (steamGaugeNumber < 4)      {steamPuffFrames = [1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];}
						else if (steamGaugeNumber < 8) {steamPuffFrames = [0,0,0,0,0,0,0,0,0,1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];}
						else                           {steamPuffFrames = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,0,0,0,0,0,0];}
						steam.addAnimation("puff",steamPuffFrames,11,true);
						
						steams.add(steam);
					}
				}
			}
			add(steams);

			/* Level */
			
			level = new FlxTilemap();
			level.loadMap(new levelMap,tileset,8,8);
			add(level);
			FlxG.worldBounds = new FlxRect(0, 0, level.width,level.height);
			FlxG.camera.bounds = FlxG.worldBounds;
			
			level.setTileProperties(EXIT_SPAWN,FlxObject.NONE);
			var exitArray:Array = level.getTileInstances(EXIT_SPAWN);
			if (exitArray) {
			exitPoint = pointForTile(exitArray[0],level);
			level.setTileByIndex(exitArray[0],0);
			} else {
				exitPoint = new FlxPoint(0,0);
			}
			
			for (i = WOOD_MIN; i <= WOOD_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, woodCallback);
			}
			
			for (i = WOOD_OVERFLOW_MIN; i <= WOOD_OVERFLOW_MAX; i++) {
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
				level.setTileProperties(i, FlxObject.ANY, woodCallback);
			}
			
			
			
			
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
			markerLine.makeGraphic(level.width,level.height,0x00000000);
			add(markerLine);
			
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
			setGravity(hand, FlxObject.DOWN, true);
			onGround = true;
			add(hand);
			
			hint = new FlxSprite(0,0);
			hint.loadGraphic(hintSheet,true,false,64,64,true);
			hint.addAnimation("idle",[0]);
			//hint.addAnimation("think",[1,2,3,4],10,false);
			//hint.addAnimation("thinking up",[4]);
			//hint.addAnimation("thinking space",[5]);
			hint.addAnimation("X",[1,2,3],10,true);
			hint.addAnimation("Z",[4,5,6],10,true);
			hint.addAnimation("arrows",[7,8,9],10,true);
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
			
			FlxG.camera.follow(hand, FlxCamera.STYLE_TOPDOWN);
		}
		
		override public function update():void {
			//if (SOUND_ON) {Registry.update();}
			Registry.update();
			
			// escape for debugging (should remove later)
			if (FlxG.keys.justPressed("ESCAPE") && Registry.DEBUG_ON) {
				FlxG.switchState(new LevelSelect);
			}
			
			if (hand.x > FlxG.worldBounds.right || hand.x < FlxG.worldBounds.left ||
				hand.y > FlxG.worldBounds.bottom || hand.y < FlxG.worldBounds.top) {
				goToNextLevel();
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
			
			// marker line
			markerLine.fill(0x00000000);
			if (bodyMode && !handOut && !handIn) {
				rad = arrow.angle*Math.PI/180;
				var startX:Number = hand.x+hand.width/2.0;
				var startY:Number = hand.y+hand.height/2.0;
				var endX:Number = startX + GRAPPLE_LENGTH * Math.cos(rad);
				var endY:Number = startY + GRAPPLE_LENGTH * Math.sin(rad);
				markerLine.drawLine(startX,startY,endX,endY,0xFFad0222,2);
				// make objects glow
			} else if (cannonMode) {
				rad = arrow.angle*Math.PI/180;
				startX = hand.x+hand.width/2.0;
				startY = hand.y+hand.height/2.0;
				endX = startX + GRAPPLE_LENGTH * Math.cos(rad) / 4.0;
				endY = startY + GRAPPLE_LENGTH * Math.sin(rad) / 4.0;
				markerLine.drawLine(startX,startY,endX,endY,0xFFad0222,2);
			}
			
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
				bodyGroup.members[mmm].color = 0xffffff;
				bodyArmBaseGroup.members[mmm].color = 0xffffff;
				bodyGearGroup.members[mmm].color = 0xffffff;
				bodyHeadGroup.members[mmm].color = 0xffffff;
			}
			for (mmm in cannonGroup.members) {
				cannonGroup.members[mmm].color = 0xffffff;
				cannonArmBaseGroup.members[mmm].color = 0xffffff;
			}
			if (!cannonMode && !bodyMode) {
				
				if ((enteringBody || enteringCannon ) && Registry.neverEnteredBodyOrCannon) {
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
				else {
					hint.play("idle");
				}
				
				if (enteringBody) {
					hand.color = 0xff0000;
					body.color = 0xff0000;
					armBase.color = 0xff0000;
					bodyGear.color = 0xff0000;
					bodyHead.color = 0xff0000;
				} else if (enteringCannon) {
					hand.color = 0xff0000;
					body.color = 0xff0000;
					armBase.color = 0xff0000;
				}
			} else if (cannonMode || bodyMode) {
				if (Registry.neverFiredBodyOrCannon) {// || Registry.neverAimedBodyOrCannon) {
					hint.play("X");
				} else {
					hint.play("idle");
				}
			}
			
			/* Begin Audio */
			if (Registry.SOUND_ON) {
				
				// Something's not quite right here...
				// The hand jumped
				if ((!bodyMode && !cannonMode) && FlxG.keys.justPressed(ACTION_KEY) && hand.touching && hand.facing != FlxObject.DOWN) {
					jumpSound.play();
				} else if ((!bodyMode && !cannonMode) && hand.touching) {
					jumpSound.stop();
				}
				
				// The hand is crawling on wood or metal
				if ((!bodyMode &&!cannonMode) && hand.touching && (hand.velocity.x != 0 || hand.velocity.y != 0)) {
					if (lastTouchedWood) {
						metalCrawlSound.stop();
						woodCrawlSound.play();
					} else {
						woodCrawlSound.stop();
						metalCrawlSound.play();
					}
				} else {
					woodCrawlSound.stop();
					metalCrawlSound.stop();
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
				if (hand.touching && !lastTouchedWood) {
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
				if (hand.justTouched(FlxObject.ANY)) {
					if (!lastTouchedWood) {
						handLandingOnMetalSound.stop();
						handLandingOnMetalSound.play();
					} else {
						handLandingOnNonstickMetalSound.stop();
						handLandingOnNonstickMetalSound.play();
					}
				}
				
				// button press, gears, steam
				for (var qq:uint = 0; qq < buttonGroup.length; qq++) {
					var button:FlxSprite = buttonGroup.members[qq];
					var buttonState:Boolean = buttonStateArray[qq];
					if (button.frame != BUTTON_PRESSED && (hand.overlaps(button) && !buttonState)) {
						buttonPressSound.stop();
						buttonPressSound.play();
					}
					if (button.frame == 2) {
						ambientGearsSound.play();
					}
					if (button.frame == 3) {
						ambientSteamSound.play();
					}
				}
				
				
				// door open
				for (var ab:int = doorGroup.length-1; ab >= 0; ab--) {
					if (doorGroup.members[ab].frame == 1) {
						doorOpenSound.stop();
						doorOpenSound.play();
					}
				}
			}
			/* End Audio */
			
			// to time the fall for the different falling rot, really belongs with anim stuff
			if (hand.touching) {handFalling = false; timeFallen = 0;}
			timeFallen += FlxG.elapsed;
			
			// less janky way of getting gears/heads to move with body...
			if (bodyMode) {
				
				var theta:Number = (body.angle-90)*Math.PI/180.0;
				
				bodyHead.x = body.x + body.width/2.0 - bodyHead.width/2.0 + (bodyHead.height*1.5)*Math.cos(theta);
				bodyHead.y = body.y + body.height/2.0 - bodyHead.height/2.0 + (bodyHead.height*1.5)*Math.sin(theta);
				bodyHead.angle = body.angle;
				
				bodyGear.x = body.x + body.width/2.0 - bodyGear.width/2.0 + (bodyGear.width/2.0)*Math.cos(theta-Math.PI/2.0);
				bodyGear.y = body.y + body.height/2.0 - bodyGear.height/2.0 + (bodyGear.width/2.0)*Math.sin(theta-Math.PI/2.0);
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
				if (hand.touching) {
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
					
					
					if (/*FlxG.keys.SPACE*/handOut && !hand.touching) {
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
					if (hand.touching && !lastTouchedWood) {
						
						if (hand.isTouching(FlxObject.DOWN)) {hand.angle = 0;}
						else if (hand.isTouching(FlxObject.LEFT)) {hand.angle = 90;}
						else if (hand.isTouching(FlxObject.UP)) {hand.angle = 180;}
						else if (hand.isTouching(FlxObject.RIGHT)) {hand.angle = 270;}
						bodyTargetAngle = hand.angle;
						// The arm is retracting while holding
						if (/*!FlxG.keys.SPACE*/handIn) {
							if (bodyTargetAngle > body.angle) {
								body.angle += 4;
							} else if (bodyTargetAngle < body.angle) {
								body.angle -= 4;
							}
						}
					}
					// The hand is retracting without having touched anything
					if (/*!FlxG.keys.SPACE*/handIn && !hand.touching) {
						
					}
				}
			}
			
			if (hand.touching && /*!lastTouchedWood*/ handMetalFlag < uint.MAX_VALUE) {
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
			
			/* End Animations */
			
			if (bodyMode || cannonMode) {
				
				// Fixes some bugs with grappling, maybe also redundant?
				if (!hand.overlaps(body)) {
					body.allowCollisions = FlxObject.NONE;
				} else {
					body.allowCollisions = FlxObject.ANY;
					if (body.justTouched(FlxObject.ANY)) {
						body.x = hand.x;
						body.y = hand.y;
						setGravity(body,hand.facing,true);
					}
					if (hand.velocity.x == 0 && hand.velocity.y == 0 && body.velocity.x == 0 && body.velocity.y == 0 && !hand.touching) {
						hand.x = body.x;
						hand.y = body.y;
					}
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
					if (hand.touching > 0 && hand.facing == hand.touching) {
						body.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
						body.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
						showArrow();
					} else {
						hand.velocity.x = -GRAPPLE_SPEED * Math.cos(rad);
						hand.velocity.y = -GRAPPLE_SPEED * Math.sin(rad);
						arrow.angle = shootAngle;
						//handReturnedToBody = true;
						
					}
					if (Math.abs(diffX) <= Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.cos(rad)) &&
						Math.abs(diffY) <= Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.sin(rad))) {
						handIn = false;
						hand.velocity.x = 0;
						hand.velocity.y = 0;
						hand.acceleration.x = 0;
						hand.acceleration.y = 0;
						body.velocity.x = 0;
						body.velocity.y = 0;
						body.acceleration.x = 0;
						body.acceleration.y = 0;
						if (hand.touching == 0) {
							hand.x = body.x;
							hand.y = body.y;
						}/* else {
							body.x = hand.x;
							body.y = hand.y;
						}*/
						hand.allowCollisions = FlxObject.ANY;
						//showArrow();
					}
				} if (!handOut && !handIn) {
					if (playerIsPressing(FlxObject.LEFT)) {
						arrow.angle -= ROTATE_RATE;
						if (arrow.angle < arrowStartAngle - 90) {arrow.angle = arrowStartAngle - 90;}
						
						if (Registry.neverAimedBodyOrCannon) {
							Registry.neverAimedBodyOrCannon = false;
						}
						
					} if (playerIsPressing(FlxObject.RIGHT)) {
						arrow.angle += ROTATE_RATE;
						if (arrow.angle > arrowStartAngle + 90) {arrow.angle = arrowStartAngle + 90;}
						
						if (Registry.neverAimedBodyOrCannon) {
							Registry.neverAimedBodyOrCannon = false;
						}
					}
					if (FlxG.keys.justPressed(BODY_KEY)) {
						if (bodyMode) {
							lastTouchedWood = false;
						}
						bodyMode = false;
						cannonMode = false;
						setGravity(hand, body.facing, true);
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
						
						setGravity(hand,FlxObject.DOWN,true);
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
							handFalling = true;
							lastGround = hand.facing;
							if (Registry.jumping && hand.isTouching(FlxObject.DOWN)) {
								hand.velocity.y = -FLOOR_JUMP_VEL;
							} else if (hand.isTouching(FlxObject.UP)) {
								hand.velocity.y = CEIL_JUMP_VEL;
							}
							//process horizontal/vertical walls separately, to handle corners
							if (hand.isTouching(FlxObject.LEFT)) {
								hand.velocity.x = WALL_JUMP_VEL;
							} else if (hand.isTouching(FlxObject.RIGHT)) {
								hand.velocity.x = -WALL_JUMP_VEL;
							}
						}
					}
				}
			}
			
			super.update();
			
			var doorsJustDied:Boolean = false;
			//if (!doorsDead) {
			for (var a:int = doorGroup.length-1; a >= 0; a--) {
				if (doorGroup.members[a].frame == 12) {
					doorGroup.members[a].kill();
					//doorsDead = true;
					doorsJustDied = true;
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
			FlxG.collide(trashGroup, hand,stupidCallback);//, woodCallback);
			//FlxG.collide(trashGroup,trashGroup);
			FlxG.collide(level, hand/*, levelHandCallback*/);
			FlxG.collide(doorGroup, hand, doorCallback);
			//FlxG.collide(flapGroup, hand, doorCallback);
			FlxG.collide(level, bodyGroup);
			FlxG.collide(doorGroup, bodyGroup);
			handTouching = hand.touching;
			correctMetal();
			if (bodyMode) {
				//was block stuff
			} else {
				if (onGround && (!hand.isTouching(hand.facing) || (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE && !hand.isTouching(FlxObject.DOWN)))) {
					onGround = false;
					lastGround = hand.facing;
					
					if (handFalling || lastTouchedWood) {
						setGravity(hand,FlxObject.DOWN,true);
					} else if (hand.velocity.x > 0 && (hand.facing == FlxObject.UP || hand.facing == FlxObject.DOWN)) {
						setGravity(hand,FlxObject.LEFT,true);
						hand.acceleration.x -= MOVE_ACCEL;
					} else if (hand.velocity.x < 0 && (hand.facing == FlxObject.UP || hand.facing == FlxObject.DOWN)) {
						setGravity(hand,FlxObject.RIGHT,true);
						hand.acceleration.x += MOVE_ACCEL;
					} else if (hand.velocity.y > 0 && (hand.facing == FlxObject.LEFT || hand.facing == FlxObject.RIGHT)) {
						setGravity(hand,FlxObject.UP,true);
						hand.acceleration.y -= MOVE_ACCEL;
					} else if (hand.velocity.y < 0 && (hand.facing == FlxObject.LEFT || hand.facing == FlxObject.RIGHT)) {
						setGravity(hand,FlxObject.DOWN,true);
						hand.acceleration.y += MOVE_ACCEL;
					}
					
					hand.drag.x = 0;
					hand.drag.y = 0;
					hand.maxVelocity.x = MAX_GRAV_VEL;
					hand.maxVelocity.y = MAX_GRAV_VEL;
				} else if (!onGround && hand.isTouching(hand.facing) && (handWoodFlag == uint.MAX_VALUE || handMetalFlag < uint.MAX_VALUE || hand.isTouching(FlxObject.DOWN))) {
					
					// probably this should happen when it loses contact with the surface in the first place
					if      (hand.isTouching(FlxObject.LEFT)) {hand.facing = FlxObject.LEFT;}
					else if (hand.isTouching(FlxObject.UP  )) {hand.facing = FlxObject.UP;}
					else if (hand.isTouching(FlxObject.RIGHT)) {hand.facing = FlxObject.RIGHT;}
					else                                       {hand.facing = FlxObject.DOWN;}
					
					onGround = true;
					setGravity(hand, hand.facing, true);
					hand.drag.x = MOVE_DECEL;
					hand.drag.y = MOVE_DECEL;
					hand.maxVelocity.x = MAX_MOVE_VEL;
					hand.maxVelocity.y = MAX_MOVE_VEL;
					
					/*if (Registry.continuityUntilRelease) {
						if (Registry.handRelative) {
							if ((handIsFacing(FlxObject.DOWN) && (lastGround & FlxObject.UP) == FlxObject.UP)
							|| (handIsFacing(FlxObject.UP) && (lastGround & FlxObject.DOWN) == FlxObject.DOWN)
							|| (handIsFacing(FlxObject.LEFT) && (lastGround & FlxObject.RIGHT) == FlxObject.RIGHT)
							|| (handIsFacing(FlxObject.RIGHT) && (lastGround & FlxObject.LEFT) == FlxObject.LEFT)) {
								if (tempGround == FlxObject.DOWN) {
									tempGround = FlxObject.UP;
								} else {
									tempGround = FlxObject.DOWN;
								}
							}
						} else {
							tempGround = lastGround;
						}
					}*/
				}
			}
			
			
			// Pause
			if (FlxG.keys.justPressed("P")) {
				FlxG.paused = !FlxG.paused;
				pause.setAll("exists", FlxG.paused);
			}
			if (FlxG.paused && FlxG.keys.justPressed("R")) {
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
				if (getHandTouching() != spr.facing) {
					fixGravity(spr);
				}
			} else if (spr in bodyGroup) {
				if (spr.touching != spr.facing) {
					fixGravity(spr);
				}
			}
		}
		
		public function woodCallback(tile:FlxTile, spr:FlxSprite):void {
			if (spr == hand) {
				handWoodFlag = tile.mapIndex;
				lastTouchedWood = true;
				
				if (getHandTouching() != spr.facing && onGround && !bodyMode) {fixGravity(spr);}
			}
		}
		
		public function doorCallback(spr1:FlxSprite, spr2:FlxSprite):void {
			if (spr2 == hand) {
				handMetalFlag = 1;
				if (getHandTouching() != spr2.facing) {
					fixGravity(spr2, true);
				}
				lastTouchedWood = false;
			} else {
				handMetalFlag = 1;
				if (getHandTouching() != spr1.facing) {
					fixGravity(spr1, true);
				}
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
			if ((getHandTouching() & spr.facing) >= spr.facing) {
				if ((getHandTouching() & FlxObject.DOWN) > 0) {
					setGravity(spr, FlxObject.DOWN, false);
				} if ((getHandTouching() & FlxObject.UP) > 0 && (isDoor || isMetalInDir(FlxObject.UP,3))) {
					setGravity(spr, FlxObject.UP, false);
				} if ((getHandTouching() & FlxObject.LEFT) > 0 && (isDoor || isMetalInDir(FlxObject.LEFT,3))) {
					setGravity(spr, FlxObject.LEFT, false);
				} if ((getHandTouching() & FlxObject.RIGHT) > 0 && (isDoor || isMetalInDir(FlxObject.RIGHT,3))) {
					setGravity(spr, FlxObject.RIGHT, false);
				}
			} else {
				if ((getHandTouching() & FlxObject.DOWN) > 0) {
					setGravity(spr, FlxObject.DOWN, true);
				} else if ((getHandTouching() & FlxObject.UP) > 0 && (isDoor || isMetalInDir(FlxObject.UP,3))) {
					setGravity(spr, FlxObject.UP, true);
				} else if ((getHandTouching() & FlxObject.LEFT) > 0 && (isDoor || isMetalInDir(FlxObject.LEFT,3))) {
					setGravity(spr, FlxObject.LEFT, true);
				} else if ((getHandTouching() & FlxObject.RIGHT) > 0 && (isDoor || isMetalInDir(FlxObject.RIGHT,3))) {
					setGravity(spr, FlxObject.RIGHT, true);
				}
			}
		}
		
		public function setGravity(spr:FlxSprite, dir:uint, reset:Boolean):void {
			if (reset) {
				spr.facing = dir;
				spr.acceleration.x = 0;
				spr.acceleration.y = 0;
			} else {
				spr.facing = spr.facing | dir;
			}
			if (dir == FlxObject.DOWN) {
				spr.acceleration.y = GRAV_RATE;
			} else if (dir == FlxObject.UP) {
				spr.acceleration.y = -GRAV_RATE;
			} else if (dir == FlxObject.LEFT) {
				spr.acceleration.x = -GRAV_RATE;
			} else if (dir == FlxObject.RIGHT) {
				spr.acceleration.x = GRAV_RATE;
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
					/*} else {
						tempGround = lastGround;
					}*/
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
			return (tile >= METAL_MIN && tile <= METAL_MAX);
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
		
		public function pointForTile(tile:uint,map:FlxTilemap):FlxPoint {
			var X:Number = 8*(int)(tile%map.widthInTiles);
			var Y:Number = 8*(int)(tile/map.widthInTiles);
			var p:FlxPoint = new FlxPoint(X,Y);
			return p;
		}
		
		public function buttonReaction():void {
			if (buttonStateArray.indexOf(false) == -1) {
				for (var a:int = 0; a < doorGroup.length; a++) {
					doorGroup.members[a].play("open");
				}
				exitOn = true;
				//exitArrow.visible = true;
			}
			buttonMode++;
			if (buttonMode == 1) {
				for (var b:uint = 0; b < buttonGroup.length; b++) {
					if (buttonGroup.members[b].frame != BUTTON_PRESSED) {
						buttonGroup.members[b].frame = 2;
						
						//
						reinvigorated = true;
					}
				}
			} else {
				for (var c:uint = 0; c < buttonGroup.length; c++) {
					if (buttonGroup.members[c].frame != BUTTON_PRESSED) {
						buttonGroup.members[c].frame = 3;
						
						//
						for (var m:String in steams.members) {
							steams.members[m].play("puff");
						}
						
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
		
		public function stupidCallback(spr1:FlxSprite,spr2:FlxSprite):void {
			lastTouchedWood = true;
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
			if (hand.touching == handTouching) {
				return handTouching;
			}
			if (handTouching != 0 && (isMultiDirection(handTouching)/* || !isMultiDirection(hand.touching)*/)/*(hand.touching & handTouching) >= hand.touching*/) { //originally >= handTouching if this causes problems
				return handTouching;
			}
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
		
		public function isMultiDirection(n:uint):Boolean {
			return ((n & FlxObject.DOWN) > 0 && (n ^ FlxObject.DOWN) > 0) || ((n & FlxObject.UP) > 0 && (n ^ FlxObject.UP) > 0) || ((n & FlxObject.LEFT) > 0 && (n ^ FlxObject.LEFT) > 0);
		}
		
		public function correctMetal():void {
			if (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE) {
				/* since Flixel only ever calls one tile callback function, the one corresponding to the topmost or leftmost corner 
				of the hand against the surface, we must do this check for the other corner to compensate */
				if ((hand.isTouching(FlxObject.UP) && isMetalInDir(FlxObject.UP, 4)) 
				 || (hand.isTouching(FlxObject.DOWN) && isMetalInDir(FlxObject.DOWN, 4))
				 || (hand.isTouching(FlxObject.LEFT) && isMetalInDir(FlxObject.LEFT, 4))
				 || (hand.isTouching(FlxObject.RIGHT) && isMetalInDir(FlxObject.RIGHT, 4))) {
					metalStuff(1, hand);
				}
			}
		}
		
		public function isMetalInDir(dir:uint, max:uint):Boolean {
			var indX:uint = int(hand.x/8);
			var indY:uint = int(hand.y/8);
			if (dir == FlxObject.LEFT) {
				for (var a:uint = 0; a <= max; a++) {
					if (indY < level.heightInTiles - a && isMetal(level.getTile(indX-1, indY+a))) {
						return true;
					}
				}
			} else if (dir == FlxObject.RIGHT) {
				for (var b:uint = 0; b <= max; b++) {
					if (indY < level.heightInTiles - b && isMetal(level.getTile(indX+4, indY+b))) {
						return true;
					}
				}
			} else if (dir == FlxObject.UP) {
				for (var c:uint = 0; c <= max; c++) {
					if (indX < level.widthInTiles - c && isMetal(level.getTile(indX+c, indY-1))) {
						return true;
					}
				}
			} else if (dir == FlxObject.DOWN) {
				for (var d:uint = 0; d <= max; d++) {
					if (indX < level.widthInTiles - d && isMetal(level.getTile(indX+d, indY+4))) {
						return true;
					}
				}
			}
			return false;
		}
	}
}