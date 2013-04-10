package {
	
	import flashx.textLayout.formats.Float;
	
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	public class PlayState extends FlxState {
		
		//public var time:Number = 0;
		
		public const CANNON_VEL:Number = 6400; //the initial velocity (in pixels per second) of the hand upon launch from a cannon
		public const ROTATE_RATE:Number = 2; //the speed (in degrees per frame) with which the arrow (later the hand) rotates before grappling
		public const GRAPPLE_SPEED:Number = 300; //the velocity (in pixels per second) of the grappling arm when extending or retracting
		public const MAX_MOVE_VEL:Number = 200; //maximum velocity (in pixels per second) of the hand's movement
		public const MAX_GRAV_VEL:Number = 400; //terminal velocity (in pixels per second) when the hand is falling
		public const GRAV_RATE:Number = 1600; //acceleration (in pixels per second per second) due to gravity
		public const MOVE_ACCEL:Number = 1600; //acceleration (in pixels per second per second) of the hand when moving along a wall
		public const MOVE_DECEL:Number = MOVE_ACCEL; //deceleration (in pixels per second per second) of the hand when moving along a wall 
		public const FLOOR_JUMP_VEL:Number = 200; //initial velocity (in pixels per second) of a hand jumping from the floor
		public const WALL_JUMP_VEL:Number = 100; //initial velocity (in pixels per second) of a hand jumping from the wall
		public const CEIL_JUMP_VEL:Number = 50; //initial velocity (in pixels per second) of a hand jumping from the ceiling
		public const METAL_MIN:uint = 48; //minimum index number of metal in the tilemap
		public const METAL_MAX:uint = 127; //maximum index number of metal in the tilemap
		public const WOOD_MIN:uint = 1; //minimum index number of wood in the tilemap
		public const WOOD_MAX:uint = 47; // maximum index number of wood in the tilemap
		//public const SPAWN:unit = ???; // index of player spawn point in tilemap (mjahearn: this should probably be a FlxPoint variable, set in create() after we read the tilemap)
		public const EMPTY_SPACE:uint = 0; // index of empty space in tilemap
		public const GRAPPLE_LENGTH:uint = 320; // maximum length of the grappling arm
		public const SOUND_ON:Boolean = true;
		
		/*
		Spawn Point Info:
		hand: 191
		body: 190
		cannon: 189
		blocks 186, 187, 188 -> (small, medium, large)
		doors: 184, 185 -> (vertical, horizontal)
		buttons: 180, 181, 182, 183 -> (L, U, R, D)
		*/
		
		public const HAND_SPAWN:uint = 191;
		public const BODY_SPAWN:uint = 190;
		public const CANNON_SPAWN:uint = 189;
		public const BLOCK_MIN:uint = 186;
		public const BLOCK_MAX:uint = 188;
		public const DOOR_MIN:uint = 184;
		public const DOOR_MAX:uint = 185;
		public const BUTTON_MIN:uint = 180;
		public const BUTTON_MAX:uint = 183;
		
		/* midground spawn points: */
		public const GEAR_MIN:uint = 1;
		public const GEAR_MAX:uint = 18;
		public const STEAM_MIN:uint = 19;
		public const STEAM_MAX:uint = 30;
		
		public var reinvigorated:Boolean = false;
		
		public var dbg:int;
		public var rad:Number;
		
		public var level:FlxTilemap;
		public var levelBack:FlxTilemap;
		public var hand:FlxSprite;
		//public var body:FlxSprite;
		public var bodyGroup:FlxGroup;
		public var curBody:uint;
		public var curCannon:uint;
		public var arrow:FlxSprite;
		//public var bodyGear:FlxSprite;
		public var bodyGearGroup:FlxGroup;
		public var bodyHeadGroup:FlxGroup;
		
		public var bodyTargetAngle:Number;
		
		public var arms:FlxGroup = new FlxGroup();
		public var numArms:int = 22;
		public var handDir:uint;
		
		public var handFalling:Boolean;
		public var bodyMode:Boolean;
		public var cannonMode:Boolean;
		public var handOut:Boolean;
		public var handGrab:Boolean;
		public var handMetalFlag:uint;
		public var handWoodFlag:uint;
		public var onGround:Boolean;
		
		public var blockGroup:FlxGroup;
		public var handBlockFlag:uint;
		public var handBlockRel:FlxPoint;
		
		public var gearInGroup:FlxGroup = new FlxGroup();
		public var gearOutGroup:FlxGroup = new FlxGroup();
		public var steams:FlxGroup = new FlxGroup();
		
		public var lastTouchedWood:Boolean = false;
		public var arrowStartAngle:int;
		public var shootAngle:int;
		public var handReturnedToBody:Boolean = false;
		
		public var buttonGroup:FlxGroup = new FlxGroup();
		public var buttonStateArray:Array = new Array();
		public var buttonReactionArray:Array = new Array();
		
		public var doorGroup:FlxGroup = new FlxGroup();
		
		public var electricity:FlxSprite;
		
		public var timeFallen:Number = 0;
		
		public var markerLine:FlxSprite = new FlxSprite();
		
		public var cannonGroup:FlxGroup = new FlxGroup();
		
		[Embed("assets/cannon.png")] public var cannonSheet:Class;
		
		[Embed("assets/level-tiles.png")] public var tileset:Class;
		[Embed("assets/background-tiles.png")] public var backgroundset:Class;
		[Embed("assets/midground-tiles.png")] public var midgroundset:Class;
		
		[Embed("assets/testArrow.png")] public var arrowSheet:Class;
		[Embed("assets/hand.png")] public var handSheet:Class;
		[Embed("assets/arm.png")] public var armSheet:Class;
		[Embed("assets/body.png")] public var bodySheet:Class;
		
		[Embed("assets/electricity.png")] public var electricitySheet:Class;
		
		[Embed("assets/gear_64x64.png")] public var gear64x64Sheet:Class;
		[Embed("assets/gear_32x32.png")] public var gear32x32Sheet:Class;
		[Embed("assets/gear_16x16.png")] public var gear16x16Sheet:Class;
		
		[Embed("assets/testMap.csv", mimeType = 'application/octet-stream')] public static var testMap:Class;
		[Embed("assets/factory-demo.csv", mimeType = 'application/octet-stream')] public static var factoryDemoMap:Class;
		[Embed("assets/factory-demo-background.csv", mimeType = 'application/octet-stream')] public static var backgroundMap:Class;
		[Embed("assets/factory-demo-midground.csv", mimeType = 'application/octet-stream')] public static var midgroundMap:Class;
		
		[Embed("assets/block_32x32.png")] public var block32x32Sheet:Class;
		[Embed("assets/block_48x48.png")] public var block48x48Sheet:Class;
		[Embed("assets/block_64x64.png")] public var block64x64Sheet:Class;
		
		[Embed("assets/button_d.png")] public var buttonDSheet:Class;
		[Embed("assets/button_l.png")] public var buttonLSheet:Class;
		[Embed("assets/button_u.png")] public var buttonUSheet:Class;
		[Embed("assets/button_r.png")] public var buttonRSheet:Class;
		
		[Embed("assets/door_h.png")] public var doorHSheet:Class;
		[Embed("assets/door_v.png")] public var doorVSheet:Class;
		
		[Embed("assets/bodygear.png")] public var bodyGearSheet:Class;
		
		[Embed("assets/Metal_Footsteps.mp3")] public var metalFootstepsSFX:Class;
		[Embed("assets/Wood_Footsteps.mp3")] public var woodFootstepsSFX:Class;
		[Embed("assets/Grapple_Extend.mp3")] public var grappleExtendSFX:Class;
		[Embed("assets/Robody_Aim.mp3")] public var robodyAimSFX:Class;
		[Embed("assets/Jump.mp3")] public var jumpSFX:Class;
		[Embed("assets/Pipe_Walk.mp3")] public var pipeWalkSFX:Class;
		[Embed("assets/Robody_LandOnPipe.mp3")] public var robodyLandOnPipeSFX:Class;
		[Embed("assets/Robody_LandOnWall.mp3")] public var robodyLandOnWallSFX:Class;
		public var metalCrawlSound:FlxSound = new FlxSound().loadEmbedded(metalFootstepsSFX);
		public var woodCrawlSound:FlxSound = new FlxSound().loadEmbedded(woodFootstepsSFX);
		public var grappleExtendSound:FlxSound = new FlxSound().loadEmbedded(grappleExtendSFX);
		public var robodyAimSound:FlxSound = new FlxSound().loadEmbedded(robodyAimSFX);
		public var jumpSound:FlxSound = new FlxSound().loadEmbedded(jumpSFX);
		public var pipeWalkSound:FlxSound = new FlxSound().loadEmbedded(pipeWalkSFX);
		public var robodyLandOnPipeSound:FlxSound = new FlxSound().loadEmbedded(robodyLandOnPipeSFX);
		public var robodyLandOnWallSound:FlxSound = new FlxSound().loadEmbedded(robodyLandOnWallSFX);
		
		[Embed("assets/SentientHandTrackA.mp3")] public var musicBackground:Class;
		public var musicBackgroundSound:FlxSound = new FlxSound().loadEmbedded(musicBackground,true);
		
		[Embed("assets/steam.png")] public var steamSheet:Class;
		
		[Embed("assets/head.png")] public var headSheet:Class;
		
		/*public var buttonReaction:Function = function():void {
			if (buttonStateArray.indexOf(false) == -1) {
				Registry.iteration++;
				FlxG.log(Registry.iteration);
				FlxG.resetState();
			}
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
		}*/
		
		override public function create():void {
			dbg = 0;
			FlxG.bgColor = 0xff000000;//0xffaaaaaa; //and... if we want motion blur... 0x22000000
			
			/*var data:Array = new Array(
				2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1,
				2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1,
				2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1,
				2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1,
				2, 0, 0, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 2, 0, 0, 0, 0, 0, 1,
				2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0,
				1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
				1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);*/
			
			/* Background */
			
			add(new FlxTilemap().loadMap(new backgroundMap,backgroundset,8,8));
			
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
			
			for (i = STEAM_MIN; i <= STEAM_MAX; i++) {
				var steamArray:Array = midground.getTileInstances(i);
				if (steamArray) {
					for (j = 0; j < steamArray.length; j++) {
						var steamPoint:FlxPoint = pointForTile(steamArray[j],midground);
						var steam:FlxSprite = new FlxSprite(steamPoint.x,steamPoint.y);
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
			//level.loadMap(FlxTilemap.arrayToCSV(data,20), tileset, 32, 32);
			//level.loadMap(new testMap,tileset,8,8);
			level.loadMap(new factoryDemoMap,tileset,8,8);
			add(level);
			//FlxG.worldBounds = new FlxRect(0, 0, level.width,level.height);//640, 480);
			//FlxG.camera.bounds = FlxG.worldBounds;
			FlxG.worldBounds = level.getBounds();
			FlxG.camera.setBounds(0,0,level.width,level.height,true);
			
			for (i = WOOD_MIN; i <= WOOD_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, woodCallback);
			}
			
			for (i = METAL_MIN; i <= METAL_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, metalCallback);
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
				}
			}
			add(cannonGroup);
			
			// Bodies
			bodyGroup = new FlxGroup();
			bodyGearGroup = new FlxGroup();
			bodyHeadGroup = new FlxGroup();
			//for (i = BODY_MIN; i <= BODY_MAX; i++) {
				level.setTileProperties(i,FlxObject.NONE);
				var bodyArray:Array = level.getTileInstances(BODY_SPAWN);
				if (bodyArray) {
					for (j= 0; j < bodyArray.length; j++) {
						level.setTileByIndex(bodyArray[j],0);
						var bodyPoint:FlxPoint = pointForTile(bodyArray[j],level);

						var body:FlxSprite = new FlxSprite(bodyPoint.x,bodyPoint.y,bodySheet); // need to adjust graphic
						bodyTargetAngle = body.angle;
						setGravity(body,FlxObject.DOWN,true);
						bodyGroup.add(body);
						var bodyGear:FlxSprite = new FlxSprite(body.x,body.y,bodyGearSheet);
						bodyGearGroup.add(bodyGear);
						// the positioning should be based on angle too
						var bodyHead:FlxSprite = new FlxSprite(body.x,body.y,headSheet);
						bodyHead.y -= bodyHead.height;
						bodyHeadGroup.add(bodyHead);
					}
				}
			//}			
			add(bodyGroup);
			add(bodyGearGroup);
			add(bodyHeadGroup);
			
			// Blocks
			blockGroup = new FlxGroup();
			for (i = BLOCK_MIN; i <= BLOCK_MAX; i++) {
				level.setTileProperties(i,FlxObject.NONE);
				var blockArray:Array = level.getTileInstances(i);
				if (blockArray) {
					for (j = 0; j < blockArray.length; j++) {
						level.setTileByIndex(blockArray[j],0);
						var blockPoint:FlxPoint = pointForTile(blockArray[j],level);

						var blockImgClass:Class;
						var blockSizeNumber:Number = (i-BLOCK_MIN)%3;
						FlxG.log(blockSizeNumber);
						if      (blockSizeNumber == 0) {blockImgClass = block32x32Sheet;}
						else if (blockSizeNumber == 1) {blockImgClass = block48x48Sheet;}
						else if (blockSizeNumber == 2) {blockImgClass = block64x64Sheet;}

						var testBlock:FlxSprite = new FlxSprite(blockPoint.x,blockPoint.y,blockImgClass);
						setBlockState(testBlock,0);
						blockGroup.add(testBlock);
					}
				}
			}
			add(blockGroup);
			
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
						var buttonGaugeNumber:Number = (i-BUTTON_MIN)%4
						if (buttonGaugeNumber == 0) {buttonSheet = buttonLSheet; w = 5; h = 32;}
						else if (buttonGaugeNumber == 1) {buttonSheet = buttonUSheet; w = 32; h = 5;}
						else if (buttonGaugeNumber == 2) {buttonSheet = buttonRSheet; buttonPoint.x += 3; w = 5; h = 32;}
						else if (buttonGaugeNumber == 3) {buttonSheet = buttonDSheet; buttonPoint.y += 3; w = 32; h = 5;}
						
						
						var button:FlxSprite = new FlxSprite(buttonPoint.x,buttonPoint.y);
						button.loadGraphic(buttonSheet,true,false,w,h,true);
						button.addAnimation("up",[0]);
						button.addAnimation("down",[1]);
						button.play("up");
						
						/*
						// Decide button angle
						var buttonGaugeNumber:Number = (i-BUTTON_MIN)%4
						if (buttonGaugeNumber == 0) {button.angle = 90; button.x -= 14; button.y += 14;}
						else if (buttonGaugeNumber == 1) {button.angle = 180;}
						else if (buttonGaugeNumber == 2) {button.angle = 270; button.x -= 10; button.y += 14;}
						else if (buttonGaugeNumber == 3) {button.y += 3;}
						*/
						
						buttonGroup.add(button);
						buttonStateArray.push(false);
						
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
			
			// Doors
			for (i = DOOR_MIN; i <= DOOR_MAX; i++) {
				level.setTileProperties(i,FlxObject.NONE);
				var doorArray:Array = level.getTileInstances(i);
				if (doorArray) {
					for (j = 0; j < doorArray.length; j++) {
						level.setTileByIndex(doorArray[j],0);
						var doorPoint:FlxPoint = pointForTile(doorArray[j],level);
						
						// Decide button graphic
						var doorSheet:Class;
						if      (i == DOOR_MAX) {doorSheet = doorHSheet; w = 96; h = 16;}
						else if (i == DOOR_MIN) {doorSheet = doorVSheet; w = 16; h = 96;}
						
						
						var door:FlxSprite = new FlxSprite(doorPoint.x,doorPoint.y);
						door.immovable = true;
						door.loadGraphic(doorSheet,true,false,w,h,true);
						door.addAnimation("closed",[0]);
						door.addAnimation("open",[1,2,2,2,2,2,2,2,3,4,5,6,7,8,9,10,11],10,true);
						door.play("closed");
						
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
			
			hand = new FlxSprite(handPoint.x, handPoint.y);
			hand.loadGraphic(handSheet,true,false,32,32,true);
			hand.addAnimation("crawl right",[0,1,2,3,4,5,6],22,true);
			hand.addAnimation("idle right",[7,7,7,7,7,7,7,8,9,9,9,9,9,9,8],10,true);
			hand.addAnimation("crawl left",[20,19,18,17,16,15,14],22,true);
			hand.addAnimation("idle left", [13,13,13,13,13,13,13,12,11,11,11,11,11,11,12],10,true);
			hand.addAnimation("idle body right", [21,21,21,21,21,21,21,22,23,23,23,23,23,23,22],10,true);
			hand.addAnimation("idle body left", [25,25,25,25,25,25,25,26,27,27,27,27,27,27,26],10,true);
			hand.addAnimation("fall right",[28,29],22,false);
			hand.addAnimation("fall left",[33,34],22,false);
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
			
			electricity = new FlxSprite(hand.x,hand.y);
			electricity.loadGraphic(electricitySheet,true,false,32,32,true);
			electricity.addAnimation("electricute",[1,2,3],22,true);
			electricity.addAnimation("stop",[0]);
			add(electricity);
			
			electricity.play("electricute");
			
			bodyMode = false;
			cannonMode = false;
			curBody = uint.MAX_VALUE;
			handOut = false;
			handGrab = false;
			handMetalFlag = uint.MAX_VALUE;
			handWoodFlag = uint.MAX_VALUE;
			handBlockFlag = uint.MAX_VALUE;
			handBlockRel = new FlxPoint();
			rad = 0;
			
			arrow = new FlxSprite();
			arrow.loadGraphic(arrowSheet);
			arrow.visible = false;
			add(arrow);
			
			if (SOUND_ON) {
				musicBackgroundSound.play();
			}
			
			// marker line
			markerLine.makeGraphic(level.width,level.height,0x00000000);
			add(markerLine);
		}
		
		override public function update():void {
			FlxG.camera.follow(hand, FlxCamera.STYLE_PLATFORMER);
			
			//time += FlxG.elapsed;
			// PRECONDITION: if bodyMode, then curBody < uint.MAX_VALUE
			var body:FlxSprite;
			var bodyGear:FlxSprite;
			var bodyHead:FlxSprite;
			if (bodyMode) {
				body = bodyGroup.members[curBody];
				bodyGear = bodyGearGroup.members[curBody];
				bodyHead = bodyHeadGroup.members[curBody];
			} if (cannonMode) {
				body = cannonGroup.members[curCannon];
			}
			
			// marker line
			markerLine.fill(0x00000000);
			if ((bodyMode && !handOut) || cannonMode) {
				rad = arrow.angle*Math.PI/180;
				var startX:Number = hand.x+hand.width/2.0;
				var startY:Number = hand.y+hand.height/2.0;
				var endX:Number = startX + GRAPPLE_LENGTH * Math.cos(rad);
				var endY:Number = startY + GRAPPLE_LENGTH * Math.sin(rad);
				markerLine.drawLine(startX,startY,endX,endY,0xFFad0222,2);
				
				// make objects glow
			}
			
			// marker glow (for hand overlapping)
			if (!bodyMode && !cannonMode) {
				var handOverlaps:Boolean = false;
				
				var bodyOverlapId:uint = handOverlapsBody();
				if (bodyOverlapId < uint.MAX_VALUE) {
					handOverlaps = true;
					bodyGroup.members[bodyOverlapId].color = 0xff8000;
				} else {
					for (var mmm:String in bodyGroup.members) {
						bodyGroup.members[mmm].color = 0xffffff;
					}
				}
				
				var cannonOverlapId:uint = handOverlapsCannon();
				if (cannonOverlapId < uint.MAX_VALUE) {
					handOverlaps = true;
					cannonGroup.members[cannonOverlapId].color = 0xff8000;
				} else {
					for (mmm in cannonGroup.members) {
						cannonGroup.members[mmm].color = 0xffffff;
					}
				}
				
				if (handOverlaps) {hand.color = 0xff8000;}
				else {hand.color = 0xffffff;}
			} else {
				for (mmm in cannonGroup.members) {
					cannonGroup.members[mmm].color = 0xffffff;
				}
				for (mmm in bodyGroup.members) {
					bodyGroup.members[mmm].color = 0xffffff;
				}
				hand.color = 0xffffff;
			}
			
			
			// to time the fall for the different falling rot, really belongs with anim stuff
			if (hand.touching) {handFalling = false; timeFallen = 0;}
			timeFallen += FlxG.elapsed;
			
			// janky way of moving body gear
			if (bodyMode) {
				
				var theta:Number = (body.angle-90)*Math.PI/180;
				
				bodyHead.angle = body.angle;
				bodyHead.x = body.x;
				bodyHead.y = body.y;
				//bodyHead.x = body.x + GRAPPLE_LENGTH*Math.cos(theta);
				//bodyHead.y = body.y + GRAPPLE_LENGTH*Math.sin(theta);
				
				//FlxG.log(Math.sin(theta));
				
				theta = (body.angle-135)*Math.PI/180;
				
				bodyGear.angle = -hand.angle + body.angle;
				bodyGear.x = body.x + (body.height/4)*Math.cos(theta);
				bodyGear.y = body.y + (body.height/4)*Math.sin(theta);
			}
			
			// Press Buttons!
			// right now, implemented buttons that go back to original state after pressed,
			// this can change, this was just easier (I think)
			for (var mm:String in buttonGroup.members) {
				var button:FlxSprite = buttonGroup.members[mm];
				var buttonState:Boolean = buttonStateArray[mm];
				if ((hand.overlaps(button) && !buttonState) || (button.overlaps(blockGroup) && !buttonState)) { // should change this to make it only recognize the space where the button is visually
					button.play("down");
					buttonStateArray[mm] = true;
					buttonReactionArray[mm]();
					//FlxG.log("pressed button");
				}/* else if (!hand.overlaps(button)) {
					button.play("up");
					buttonStateArray[mm] = false;
				}*/
			}
			
			// Bring midground to life
			if (reinvigorated) {
				
				// Steam
				
				// Spin Gears // should eventually make them accel in/out of spinning
				var gear:FlxSprite;
				for (var jjj:String in gearInGroup.members) {
					gear = gearInGroup.members[jjj];
					gear.angle += 0.5;
					if (gear.angle > 360) {gear.angle = 0;}
				}
				for (jjj in gearOutGroup.members) {
					gear = gearOutGroup.members[jjj];
					gear.angle -= 0.5;
					if (gear.angle < 0) {gear.angle = 360;}
				}
			}
			
			/* Begin Audio */
			if (SOUND_ON) {
				
				// Something's not quite right here...
				// The hand jumped
				if ((!bodyMode && !cannonMode) && FlxG.keys.justPressed("UP") && hand.touching && hand.facing != FlxObject.DOWN) {
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
				if ((bodyMode || cannonMode) && !handOut) {
					grappleExtendSound.stop();
					if ((FlxG.keys.RIGHT || FlxG.keys.LEFT) && -270 < hand.angle - body.angle && hand.angle - body.angle < -90) {
						robodyAimSound.play();
					} else {
						robodyAimSound.stop();
					}
				}
				// The hand is launching out of the body
				else if (bodyMode && handOut) {
					robodyLandOnWallSound.stop();
					robodyAimSound.stop();
					if (FlxG.keys.justReleased("SPACE") || FlxG.keys.justPressed("SPACE")) {
						grappleExtendSound.stop();
					}
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
				if (bodyMode && handOut && hand.overlaps(body) && ((hand.angle < body.angle - 270) || (body.angle - 90 < hand.angle))) {
					robodyLandOnWallSound.play();
				}
			}
			/* End Audio */
			
			/* Begin Animations */
			// The hand is not attached to a body
			if (!bodyMode && !cannonMode) {
				// The hand is about to mount a body
				if (FlxG.keys.justPressed("DOWN")) {
					bodyTargetAngle = hand.angle;
				}
				// The hand is crawling along a flat surface
				if (hand.touching) {
					// Set the Angle of the hand
					if (hand.facing == FlxObject.DOWN) {hand.angle = 0;}
					else if (hand.facing == FlxObject.LEFT) {hand.angle = 90;}
					else if (hand.facing == FlxObject.UP) {hand.angle = 180;}
					else if (hand.facing == FlxObject.RIGHT) {hand.angle = 270;}
					// The hand is changing direction
					// (because the sprite's not ambidexterous)
					if (FlxG.keys.LEFT) {handDir = FlxObject.LEFT;}
					if (FlxG.keys.RIGHT) {handDir = FlxObject.RIGHT;}
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
					if (FlxG.keys.justPressed("UP")) {
						if (handDir == FlxObject.LEFT) {hand.play("fall left");} //<- placeholder {hand.play("jump left");}
						else if (handDir == FlxObject.RIGHT) {hand.play("fall right");} //<- placeholder {hand.play("jump right");}
					}
				}
				// The hand is rounding a convex corner
				else if (!handFalling) {
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
				// The hand ran off a wooden platform
				else if (lastTouchedWood) {
					FlxG.log("hi");
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
					else if (timeFallen > 0.44) {//if (timeFallen > 0.66) {
						
						var vSquared:Number = Math.pow(hand.velocity.x,2) + Math.pow(hand.velocity.y,2);
						
						if (handDir == FlxObject.LEFT) {hand.angle += vSquared/8000;}//{hand.angle += 10;}
						else if (handDir == FlxObject.RIGHT) {hand.angle -= vSquared/8000;}//{hand.angle -= 10;}
					}
				}
			}
			
			// The hand is attached to a body
			else if (bodyMode || cannonMode) {
				// The hand is idling in the body
				if (!handOut) {
					hand.angle = arrow.angle - 90;
					body.angle = bodyTargetAngle;
					
					//FlxG.log(body.angle);
					
					if (body.angle == 0) {body.facing = FlxObject.DOWN;}
					else if (body.angle == 270) {body.facing = FlxObject.RIGHT;}
					else if (body.angle == 180) {body.facing = FlxObject.UP;}
					else if (body.angle == 90) {body.facing = FlxObject.LEFT;}
					
					
					if (handDir == FlxObject.LEFT) {hand.play("idle body left");}
					else {hand.play("idle body right");}
					// The hand is about to dismount 
					if (FlxG.keys.justPressed("DOWN")) {
						// play falling animations?
					}
					// Keep arms hidden
					for (var i:String in arms.members) {
						arms.members[i].visible = false;
					}
				}
				// The hand is extended
				else if (handOut) {
					
					
					if (FlxG.keys.SPACE && !hand.touching) {
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
						if (!FlxG.keys.SPACE) {
							if (bodyTargetAngle > body.angle) {
								body.angle += 4;
							} else if (bodyTargetAngle < body.angle) {
								body.angle -= 4;
							}
						}
					}
					// The hand is retracting without having touched anything
					if (!FlxG.keys.SPACE && !hand.touching) {
						
					}
				}
			}
			
			if (hand.touching && !lastTouchedWood) {
				electricity.play("electricute");
				electricity.angle = hand.angle;
				electricity.x = hand.x;
				electricity.y = hand.y;
			} else {
				electricity.play("stop");
			}
			
			/* End Animations */
			
			/*
			if (bodyMode && !handOut) {
				setGravity(body,body.facing,true);
			} else if (bodyMode) {
				setGravity(body,body.facing,false);
			}
			*/
			
			if (bodyMode || cannonMode) {
				body.velocity.x = 0;
				body.velocity.y = 0;
				hand.velocity.x = 0;
				hand.velocity.y = 0;
				if (handOut) {
					var diffX:Number = hand.x-body.x;
					var diffY:Number = hand.y-body.y;
					//rad = Math.atan2(diffY, diffX);
					//arrow.angle = 180*rad/Math.PI;
					rad = arrow.angle*Math.PI/180;
					if (FlxG.keys.SPACE) {
						if (hand.touching <= 0 && Math.sqrt(Math.pow(diffX, 2) + Math.pow(diffY, 2)) < GRAPPLE_LENGTH) {
							hand.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
							hand.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
						}
					} else {
						rad = Math.atan2(diffY, diffX);
						if ((hand.touching > 0 && hand.facing == hand.touching) /*|| (handBlockFlag < uint.MAX_VALUE && blockGroup.members[handBlockFlag].mass > body.mass)*/) {
							body.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
							body.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
							showArrow();
						} else {
							hand.velocity.x = -GRAPPLE_SPEED * Math.cos(rad);
							hand.velocity.y = -GRAPPLE_SPEED * Math.sin(rad);
							arrow.angle = shootAngle;
							handReturnedToBody = true;
						}
						if (Math.abs(diffX) <= Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.cos(rad)) &&
							Math.abs(diffY) <= Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.sin(rad))) {
							handOut = false;
							if (handBlockFlag < uint.MAX_VALUE) {
								setBlockState(blockGroup.members[handBlockFlag], 2);
								handBlockFlag = uint.MAX_VALUE;
							}
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
							} else {
								body.x = hand.x;
								body.y = hand.y;
							}
							hand.allowCollisions = FlxObject.ANY;
							//showArrow();
						}
					}
				} else {
					if (FlxG.keys.LEFT) {
						arrow.angle -= ROTATE_RATE;
						if (arrow.angle < arrowStartAngle - 90) {arrow.angle = arrowStartAngle - 90;}
					} if (FlxG.keys.RIGHT) {
						arrow.angle += ROTATE_RATE;
						if (arrow.angle > arrowStartAngle + 90) {arrow.angle = arrowStartAngle + 90;}
					}
					if (FlxG.keys.justPressed("DOWN")) {
						bodyMode = false;
						cannonMode = false;
						//arrow.visible = false;
						setGravity(hand, hand.facing, true);
					}
					rad = Math.PI*arrow.angle/180;
					if (FlxG.keys.justPressed("SPACE") && bodyMode) {
						shootAngle = arrow.angle;
						handOut = true;
						//arrow.visible = false;
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
					} else if (FlxG.keys.justPressed("SPACE") && cannonMode) {
						cannonMode = false;
						rad = Math.PI*arrow.angle/180;
						hand.velocity.x = CANNON_VEL * Math.cos(rad);
						hand.velocity.y = CANNON_VEL * Math.sin(rad);
						setGravity(hand,FlxObject.DOWN,true);
						//FlxG.log("cannon fire!");
					}
				}
			} else {
				var hoc:uint = handOverlapsCannon();
				if (FlxG.keys.justPressed("DOWN") && hoc < uint.MAX_VALUE) {
					curCannon = hoc;
					body = cannonGroup.members[curCannon];
					cannonMode = true;
					hand.velocity.x = 0;
					hand.velocity.y = 0;
					hand.acceleration.x = 0;
					hand.acceleration.y = 0;
					hand.x = body.x;
					hand.y = body.y;
					showArrow();
				}
				
				
				var hob:uint = handOverlapsBody();
				if (FlxG.keys.justPressed("DOWN") && hob < uint.MAX_VALUE) {
					curBody = hob;
					body = bodyGroup.members[curBody];
					bodyGear = bodyGearGroup.members[curBody];
					bodyMode = true;
					hand.velocity.x = 0;
					hand.velocity.y = 0;
					hand.acceleration.x = 0;
					hand.acceleration.y = 0;
					hand.x = body.x;
					hand.y = body.y;
					showArrow();
				} else {
					if (onGround) {
						if (hand.facing == FlxObject.DOWN || hand.facing == FlxObject.UP) {
							hand.acceleration.x = 0;
						} else if (hand.facing == FlxObject.LEFT || hand.facing == FlxObject.RIGHT) {
							hand.acceleration.y = 0;
						}
						if (FlxG.keys.LEFT) {
							if (handIsFacing(FlxObject.DOWN) && !handIsFacing(FlxObject.LEFT)) {
								hand.acceleration.x = -MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.LEFT) && !handIsFacing(FlxObject.UP)) {
								hand.acceleration.y = -MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.UP) && !handIsFacing(FlxObject.RIGHT)) {
								hand.acceleration.x = MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.RIGHT)) {
								hand.acceleration.y = MOVE_ACCEL;
							}
						} if (FlxG.keys.RIGHT) {
							if (handIsFacing(FlxObject.DOWN) && !handIsFacing(FlxObject.RIGHT)) {
								hand.acceleration.x = MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.RIGHT) && !handIsFacing(FlxObject.UP)) {
								hand.acceleration.y = -MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.UP) && !handIsFacing(FlxObject.LEFT)) {
								hand.acceleration.x = -MOVE_ACCEL;
							} else if (handIsFacing(FlxObject.LEFT)) {
								hand.acceleration.y = MOVE_ACCEL;
							}
						} if (FlxG.keys.justPressed("UP")) {
							handFalling = true;
							if (hand.isTouching(FlxObject.DOWN)) {
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
			
			handMetalFlag = uint.MAX_VALUE;
			handWoodFlag = uint.MAX_VALUE;
			//handBlockFlag = uint.MAX_VALUE;
			FlxG.collide(level, hand, levelHandCallback);
			FlxG.collide(blockGroup, hand, blockCallback);
			FlxG.collide(doorGroup, hand);
			FlxG.collide(level, bodyGroup);
			if (bodyMode) {
				FlxG.collide(blockGroup, body, blockCallback);
			} else {
				FlxG.collide(blockGroup, bodyGroup, blockCallback);
			}
			FlxG.collide(level, blockGroup, levelBlockCallback);
			//FlxG.log(handWoodFlag);
			//FlxG.log(blockGroup.members[0].immovable);
			//FlxG.collide(blockGroup); //Need to figure out how to make this work
			if (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE) {
				/* since Flixel only ever calls one tile callback function, the one corresponding to the topmost or leftmost corner 
				of the hand against the surface, we must do this check for the other corner to compensate
				WARNING: since the switch to 8x8 tiles, this only checks one other tile (on the opposite end), while the player is
				colliding with >=4 */
				var indX:uint = handWoodFlag % level.widthInTiles;
				var indY:uint = handWoodFlag / level.widthInTiles;
				if (hand.isTouching(FlxObject.UP) && indX < level.widthInTiles - 1 && isMetal(level.getTile(indX+1,indY))) {
					handMetalFlag = indY*level.widthInTiles + indX+1;
				} else if ((hand.isTouching(FlxObject.LEFT) || hand.isTouching(FlxObject.RIGHT)) && indY < level.heightInTiles - 1 && isMetal(level.getTile(indX,indY+1))) {
					handMetalFlag = (indY+1)*level.widthInTiles + indX;
				}
			}
			if (bodyMode) {
				if (onGround && handBlockFlag < uint.MAX_VALUE) {
					var curBlock:FlxSprite = blockGroup.members[handBlockFlag];
					//if (curBlock.mass < body.mass) {
						if (curBlock.immovable) {
							setBlockState(curBlock, 1);
							handBlockRel = new FlxPoint(curBlock.x - hand.x, curBlock.y - hand.y);
						}
						if (handOut) {
							curBlock.x = hand.x + handBlockRel.x;
							curBlock.y = hand.y + handBlockRel.y;
							FlxG.collide(level, blockGroup);
						} else {
							//prolly won't be reached any more due to handBlockFlag resetting with handOut
							setBlockState(curBlock, 2);
							handBlockFlag = uint.MAX_VALUE;
						}
					//}
				}
			} else {
				if (onGround && (!hand.isTouching(hand.facing) || (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE && !hand.isTouching(FlxObject.DOWN)))) {
					onGround = false;
					
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
				}
			}
		}
		
		public function levelHandCallback(a:FlxObject, b:FlxObject):void {
			//FlxG.log("okay");
		}
		
		public function metalCallback(tile:FlxTile, spr:FlxSprite):void {
			if (spr == hand) {
				handMetalFlag = tile.mapIndex;
				lastTouchedWood = false;
				fixGravity(spr);
			} else if (spr in bodyGroup) {
				fixGravity(spr);
			}
		}
		
		public function woodCallback(tile:FlxTile, spr:FlxSprite):void {
			if (spr == hand) {
				handWoodFlag = tile.mapIndex;
				lastTouchedWood = true;
			}
		}
		
		public function blockCallback(spr1:FlxSprite, spr2:FlxSprite):void {
			if (spr2 == hand) {
				if (bodyMode) {
					handBlockFlag = blockGroup.members.indexOf(spr1);
				} else {
					handMetalFlag = 1;
					fixGravity(spr2);
					lastTouchedWood = false;
				}
			/*} else if (spr2 in bodyGroup && spr1.mass > spr2.mass) {
				fixGravity(spr2);*/
			} else if (spr2 in blockGroup) {
				if (spr1 == hand) {
					if (bodyMode) {
						handBlockFlag = blockGroup.members.indexOf(spr2);
					} else {
						handMetalFlag = 1;
						fixGravity(spr1);
						lastTouchedWood = false;
					}
				}/* else if (spr1 in bodyGroup && spr2.mass > spr1.mass) {
					fixGravity(spr1);
				}*/
			}
		}
		
		public function levelBlockCallback(spr1:FlxTilemap, spr2:FlxSprite):void {
			if (spr2.isTouching(FlxObject.DOWN)) {
				setBlockState(spr2, 0);
			}
		}
		
		public function fixGravity(spr:FlxSprite):void {
			if ((spr.touching & spr.facing) >= spr.facing) {
				if (spr.justTouched(FlxObject.DOWN)) {
					setGravity(spr, FlxObject.DOWN, false);
				} else if (spr.justTouched(FlxObject.UP)) {
					setGravity(spr, FlxObject.UP, false);
				} else if (spr.justTouched(FlxObject.LEFT)) {
					setGravity(spr, FlxObject.LEFT, false);
				} else if (spr.justTouched(FlxObject.RIGHT)) {
					setGravity(spr, FlxObject.RIGHT, false);
				}
			} else {
				if (spr.isTouching(FlxObject.DOWN)) {
					setGravity(spr, FlxObject.DOWN, true);
				} else if (spr.isTouching(FlxObject.UP)) {
					setGravity(spr, FlxObject.UP, true);
				} else if (spr.isTouching(FlxObject.LEFT)) {
					setGravity(spr, FlxObject.LEFT, true);
				} else if (spr.isTouching(FlxObject.RIGHT)) {
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
		}
		
		public function handIsFacing(dir:uint):Boolean {
			return (hand.facing & dir) > 0;
		}
		
		public function showArrow():void {
			// PRECONDITION: curBody < uint.MAX_VALUE
			//arrow.visible = true;
			//arrow.x = bodyGroup.members[curBody].x;
			//arrow.y = bodyGroup.members[curBody].y;
			/*
			if (handIsFacing(FlxObject.DOWN)) {
				arrow.angle = -90;
			} else if (handIsFacing(FlxObject.UP)) {
				arrow.angle = 90;
			} else if (handIsFacing(FlxObject.LEFT)) {
				arrow.angle = 0;
			} else if (handIsFacing(FlxObject.RIGHT)) {
				arrow.angle = 180;
			}
			*/
			arrow.angle = bodyTargetAngle - 90;
			arrowStartAngle = arrow.angle;
		}
		
		public function isMetal(tile:uint):Boolean {
			return (tile >= METAL_MIN && tile <= METAL_MAX);
		}
		
		public function handOverlapsBody():uint {
			for (var b:int = 0; b < bodyGroup.length; b++) {
				if (hand.overlaps(bodyGroup.members[b])) {
					return(b);
				}
			}
			return(uint.MAX_VALUE);
		}
		
		public function handOverlapsCannon():uint {
			for (var b:int = 0; b < cannonGroup.length; b++) {
				if (hand.overlaps(cannonGroup.members[b])) {
					return(b);
				}
			}
			return(uint.MAX_VALUE);
		}
		
		public function pointForTile(tile:uint,map:FlxTilemap):FlxPoint {
			var X:Number = 8*(int)(tile%map.widthInTiles);
			var Y:Number = 8*(int)(tile/map.widthInTiles);
			var p:FlxPoint = new FlxPoint(X,Y);
			return p;
		}
		/* 0 = rest
		1 = grabbed
		2 = in air*/
		public function setBlockState(b:FlxSprite, n:uint):void {
			if (n == 0) {
				b.immovable = true;
				b.drag.x = Number.MAX_VALUE;
				b.drag.y = Number.MAX_VALUE;
				b.acceleration.y = 0;
			} else if (n == 1) {
				b.immovable = false;
				b.drag.x = Number.MAX_VALUE;
				b.drag.y = Number.MAX_VALUE;
				b.acceleration.y = 0;
			} else {
				b.immovable = false;
				b.drag.x = 0;
				b.drag.y = 0;
				b.acceleration.y = GRAV_RATE;
			}
		}
		
		public function buttonReaction():void {
			if (buttonStateArray.indexOf(false) == -1) {
				Registry.iteration++;
				FlxG.resetState();
			}
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
		}
	}
}