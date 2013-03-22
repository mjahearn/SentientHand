package {
	
	import flashx.textLayout.formats.Float;
	
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	public class PlayState extends FlxState {
		
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
		
		/* Spawn point info
		
		Spawn point indices:
		hand: 191
		bodies (weights 1-6): 190-185
		blocks 32x32 (weights 1-6): 184-179
		blocks 64x64 (weights 1-6): 178-173
		blocks 96x96 (weights 1-6): 172-167
		
		Spawn point markings:
		hand: H
		bodies: arabic numerals
		blocks: relative block size, roman numerals
		*/
		public const HAND_SPAWN:uint = 191;
		public const BODY_MIN:uint = 185;
		public const BODY_MAX:uint = 190;
		public const BLOCK_MIN:uint = 167;
		public const BLOCK_MAX:uint = 184;
		
		public const BUTTON_MIN:uint = 163;
		public const BUTTON_MAX:uint = 166;
		
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
		public var arrow:FlxSprite;
		//public var bodyGear:FlxSprite;
		public var bodyGearGroup:FlxGroup;
		
		public var bodyTargetAngle:Number;
		
		public var arms:FlxGroup = new FlxGroup();
		public var numArms:int = 22;
		public var handDir:uint;
		
		public var handFalling:Boolean;
		public var bodyMode:Boolean;
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
		
		[Embed("assets/level-tiles.png")] public var tileset:Class;
		[Embed("assets/background-tiles.png")] public var backgroundset:Class;
		[Embed("assets/midground-tiles.png")] public var midgroundset:Class;
		
		[Embed("assets/testArrow.png")] public var arrowSheet:Class;
		[Embed("assets/hand.png")] public var handSheet:Class;
		[Embed("assets/arm.png")] public var armSheet:Class;
		//[Embed("assets/body.png")] public var bodySheet:Class;
		
		[Embed("assets/body_w1.png")] public var bodyw1Sheet:Class;
		[Embed("assets/body_w2.png")] public var bodyw2Sheet:Class;
		[Embed("assets/body_w3.png")] public var bodyw3Sheet:Class;
		[Embed("assets/body_w4.png")] public var bodyw4Sheet:Class;
		[Embed("assets/body_w5.png")] public var bodyw5Sheet:Class;
		[Embed("assets/body_w6.png")] public var bodyw6Sheet:Class;
		
		[Embed("assets/gear_64x64.png")] public var gear64x64Sheet:Class;
		[Embed("assets/gear_32x32.png")] public var gear32x32Sheet:Class;
		[Embed("assets/gear_16x16.png")] public var gear16x16Sheet:Class;
		
		
		[Embed("assets/testMap.csv", mimeType = 'application/octet-stream')] public static var testMap:Class;
		[Embed("assets/factory-demo.csv", mimeType = 'application/octet-stream')] public static var factoryDemoMap:Class;
		[Embed("assets/factory-demo-background.csv", mimeType = 'application/octet-stream')] public static var backgroundMap:Class;
		[Embed("assets/factory-demo-midground.csv", mimeType = 'application/octet-stream')] public static var midgroundMap:Class;
		
		[Embed("assets/block_32x32_w1.png")] public var block32x32w1Sheet:Class;
		[Embed("assets/block_32x32_w2.png")] public var block32x32w2Sheet:Class;
		[Embed("assets/block_32x32_w3.png")] public var block32x32w3Sheet:Class;
		[Embed("assets/block_32x32_w4.png")] public var block32x32w4Sheet:Class;
		[Embed("assets/block_32x32_w5.png")] public var block32x32w5Sheet:Class;
		[Embed("assets/block_32x32_w6.png")] public var block32x32w6Sheet:Class;
		
		[Embed("assets/button.png")] public var buttonSheet:Class;
		
		[Embed("assets/bodygear.png")] public var bodyGearSheet:Class;
		
		[Embed("assets/Metal_Footsteps.mp3")] public var metalFootstepsSFX:Class;
		[Embed("assets/Wood_Footsteps.mp3")] public var woodFootstepsSFX:Class;
		public var metalCrawlSound:FlxSound = new FlxSound().loadEmbedded(metalFootstepsSFX);
		public var woodCrawlSound:FlxSound = new FlxSound().loadEmbedded(woodFootstepsSFX);
		
		[Embed("assets/steam.png")] public var steamSheet:Class;
		
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
						//FlxG.log(gearGaugeNumber);
						if (gearGaugeNumber < 3) {gearSheet = gear64x64Sheet;}
						else if (gearGaugeNumber < 5) {gearSheet = gear32x32Sheet;}
						else {gearSheet = gear16x16Sheet;}
						
						// do something for gear speed...
						
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
			FlxG.worldBounds = new FlxRect(0, 0, 640, 480);
			FlxG.camera.bounds = FlxG.worldBounds;
			
			for (i = WOOD_MIN; i <= WOOD_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, woodCallback);
			}
			
			for (i = METAL_MIN; i <= METAL_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, metalCallback);
			}
			
			// Bodies
			bodyGroup = new FlxGroup();
			bodyGearGroup = new FlxGroup();
			for (i = BODY_MIN; i <= BODY_MAX; i++) {
				level.setTileProperties(i,FlxObject.NONE);
				var bodyArray:Array = level.getTileInstances(i);
				if (bodyArray) {
					for (var jjj:int = 0; jjj < bodyArray.length; jjj++) {
						var bodyPoint:FlxPoint = pointForTile(bodyArray[jjj],level);
						var bmass:Number = (BODY_MAX-i+1)%(BODY_MAX-BODY_MIN);
						if (bmass == 0) {bmass = 6;}
						
						var bodyImgClass:Class;
						if (bmass == 1) {bodyImgClass = bodyw1Sheet;}
						else if (bmass == 2) {bodyImgClass = bodyw2Sheet;}
						else if (bmass == 3) {bodyImgClass = bodyw3Sheet;}
						else if (bmass == 4) {bodyImgClass = bodyw4Sheet;}
						else if (bmass == 5) {bodyImgClass = bodyw5Sheet;}
						else if (bmass == 6) {bodyImgClass = bodyw6Sheet;}
						
						var body:FlxSprite = new FlxSprite(bodyPoint.x,bodyPoint.y,bodyImgClass); // need to adjust graphic
						//FlxG.log(body.mass);
						bodyTargetAngle = body.angle;
						body.mass = bmass;
						setGravity(body,FlxObject.DOWN,true);
						bodyGroup.add(body);
						var bodyGear:FlxSprite = new FlxSprite(body.x,body.y,bodyGearSheet);
						bodyGearGroup.add(bodyGear);
					}
				}
			}			
			add(bodyGroup);
			add(bodyGearGroup);
			
			// Blocks
			blockGroup = new FlxGroup();
			for (i = BLOCK_MIN; i <= BLOCK_MAX; i++) {
				level.setTileProperties(i,FlxObject.NONE);
				var blockArray:Array = level.getTileInstances(i);
				if (blockArray) {
					for (var jj:int = 0; jj < blockArray.length; jj++) {
						var mass:Number = (BLOCK_MAX-i+1)%(BLOCK_MAX-BLOCK_MIN);
						if (mass == 0) {mass = 6};
						var blockPoint:FlxPoint = pointForTile(blockArray[jj],level);
						
						var imgClass:Class;
						if (mass == 1) {imgClass = block32x32w1Sheet;}
						else if (mass == 2) {imgClass = block32x32w2Sheet;}
						else if (mass == 3) {imgClass = block32x32w3Sheet;}
						else if (mass == 4) {imgClass = block32x32w4Sheet;}
						else if (mass == 5) {imgClass = block32x32w5Sheet;}
						else if (mass == 6) {imgClass = block32x32w6Sheet;}
						
						var testBlock:FlxSprite = new FlxSprite(blockPoint.x,blockPoint.y,imgClass);
						setBlockState(testBlock,0);
						testBlock.mass = mass;
						//FlxG.log(testBlock.mass);
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
						var buttonPoint:FlxPoint = pointForTile(buttonArray[j],level);
						
						var button:FlxSprite = new FlxSprite(buttonPoint.x,buttonPoint.y);
						button.loadGraphic(buttonSheet,true,false,32,32,true);
						button.addAnimation("up",[0]);
						button.addAnimation("down",[1]);
						button.play("up");
						
						// Decide button angle
						// n.b. Steam is grouped in 3 frequencies, 4 angles
						var buttonGaugeNumber:Number = (i-BUTTON_MIN)%4
						if (buttonGaugeNumber == 0) {button.angle = 90;}
						else if (buttonGaugeNumber == 1) {button.angle = 180;}
						else if (buttonGaugeNumber == 2) {button.angle = 270;}
						
						buttonGroup.add(button);
						buttonStateArray.push(false);
						
						// not sure how to handle different buttons doing different things?
						// presumably, they sholud be linked to specific things in the room?
						// I'm... not quite sure...
						var buttonReaction:Function = function():void {
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
							
						buttonReactionArray.push(buttonReaction);
					}
				}
			}
			add(buttonGroup);
			
			// Hand + Arms
			level.setTileProperties(HAND_SPAWN,FlxObject.NONE);
			var array:Array = level.getTileInstances(HAND_SPAWN);
			var handPoint:FlxPoint = pointForTile(array[0],level);
			
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
			hand.addAnimation("idle body", [21],10,true);
			handDir = FlxObject.RIGHT;
			hand.play("idle right");
			hand.maxVelocity.x = MAX_MOVE_VEL;
			hand.maxVelocity.y = MAX_MOVE_VEL;
			hand.drag.x = MOVE_DECEL;
			hand.drag.y = MOVE_DECEL;
			setGravity(hand, FlxObject.DOWN, true);
			onGround = true;
			add(hand);
			
			bodyMode = false;
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
			
			/*
			var steam:FlxSprite = new FlxSprite(32,32);
			steam.loadGraphic(steamSheet,true,false,32,32,true);
			steam.addAnimation("idle",[0]);
			steam.addAnimation("puff",[1,2,3,0,0,0,0,0,0],11,true);
			steam.play("puff");
			steams.add(steam);
			add(steams);
			*/
			
		}
		
		override public function update():void {
			// PRECONDITION: if bodyMode, then curBody < uint.MAX_VALUE
			var body:FlxSprite;
			var bodyGear:FlxSprite;
			if (bodyMode) {
				body = bodyGroup.members[curBody];
				bodyGear = bodyGearGroup.members[curBody];
			}
			
			if (hand.touching) {handFalling = false;}
			
			// janky way of moving body gear (this only works for one body, should really classify it)
			if (bodyMode) {
				bodyGear.x = body.x;
				bodyGear.y = body.y;
				bodyGear.angle = -arrow.angle;
			}
			
			// Press Buttons!
			// right now, implemented buttons that go back to original state after pressed,
			// this can change, this was just easier (I think)
			for (var mm:String in buttonGroup.members) {
				var button:FlxSprite = buttonGroup.members[mm];
				var buttonState:Boolean = buttonStateArray[mm];
				if (hand.overlaps(button) && !buttonState) { // should change this to make it only recognize the space where the button is visually
					button.play("down");
					buttonStateArray[mm] = true;
					buttonReactionArray[mm]();
					//FlxG.log("pressed button");
				} else if (!hand.overlaps(button)) {
					button.play("up");
					buttonStateArray[mm] = false;
				}
			}
			
			// Bring Midground to Life!
			/*
			if (FlxG.keys.justPressed("A")) {// for debugging
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
			*/
			
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
				
				// The hand is crawling on wood or metal
				if (!bodyMode && hand.touching && (hand.velocity.x != 0 || hand.velocity.y != 0)) {
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
			}
			
			/* End Audio */
			
			/* Begin Animations */
			
			// The hand is not attached to a body
			if (!bodyMode) {
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
						if (handDir == FlxObject.LEFT) {hand.play("idle left");} //<- placeholder {hand.play("jump left");}
						else if (handDir == FlxObject.RIGHT) {hand.play("idle right");} //<- placeholder {hand.play("jump right");}
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
						hand.play("idle left"); //<- placeholder {hand.play("jump left");
						//}
					} else if (handDir == FlxObject.RIGHT) {
						/*if ((hand.facing == FlxObject.UP && hand.angle < 270) ||
						(hand.facing == FlxObject.DOWN && hand.angle < 90) ||
						(hand.facing == FlxObject.LEFT && hand.angle < 180) ||
						(hand.facing == FlxObject.RIGHT && hand.angle < 360)) { <- this line's not working
						*/
						hand.angle += 2.2;
						hand.play("idle right"); //<- placeholder {hand.play("jump right");
						//}
					}
				}
				// The hand is falling (with style!)
				else {
					if (hand.angle > 0 && hand.angle < 360) {
						if (handDir == FlxObject.LEFT) {
							hand.play("idle left"); //<- placeholder hand.play("fall left");
							hand.angle += 10;
						} else if (handDir == FlxObject.RIGHT) {
							hand.play("idle right"); //<- placeholder hand.play("fall right");
							hand.angle -= 10;
						}
					}
				}
			}
			
			// The hand is attached to a body
			else if (bodyMode) {
				// The hand is idling in the body
				if (!handOut) {
					hand.angle = arrow.angle - 90;
					body.angle = bodyTargetAngle;
					hand.play("idle body");
					// The hand is about to dismount 
					if (FlxG.keys.justPressed("DOWN")) {
						//
					}
					// Keep arms hidden
					for (var i:String in arms.members) {
						arms.members[i].visible = false;
					}
				}
				// The hand is extended
				else if (handOut) {
					
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
						//
					}
				}
			}
		
			/* End Animations */
			
			if (bodyMode) {
				body.velocity.x = 0;
				body.velocity.y = 0;
				hand.velocity.x = 0;
				hand.velocity.y = 0;
				if (handOut) {
					var diffX:Number = hand.x-body.x;
					var diffY:Number = hand.y-body.y;
					rad = Math.atan2(diffY, diffX);
					arrow.angle = 180*rad/Math.PI;
					if (FlxG.keys.SPACE) {
						if (hand.touching <= 0 && Math.sqrt(Math.pow(hand.x-body.x, 2) + Math.pow(hand.y-body.y, 2)) < GRAPPLE_LENGTH) {
							hand.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
							hand.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
						}
					} else {
						if ((hand.touching > 0 && hand.facing == hand.touching) || (handBlockFlag < uint.MAX_VALUE && blockGroup.members[handBlockFlag].mass > body.mass)) {
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
						//arrow.visible = false;
						setGravity(hand, hand.facing, true);
					}
					rad = Math.PI*arrow.angle/180;
					if (FlxG.keys.justPressed("SPACE")) {
						shootAngle = arrow.angle;
						handOut = true;
						//arrow.visible = false;
						hand.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
						hand.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
					}
				}
			} else {
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
			FlxG.collide(level, hand);
			FlxG.collide(blockGroup, hand, blockCallback);
			FlxG.collide(level, bodyGroup);
			FlxG.collide(blockGroup, bodyGroup, blockCallback);
			FlxG.collide(level, blockGroup, levelBlockCallback);
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
					if (curBlock.mass < body.mass) {
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
					}
				}
			} else {
				if (onGround && (!hand.isTouching(hand.facing) || (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE && !hand.isTouching(FlxObject.DOWN)))) {
					onGround = false;
					
					if (handFalling || lastTouchedWood) {
						setGravity(hand,FlxObject.DOWN,true);
					} else if (hand.velocity.x > 0 && (hand.facing == FlxObject.UP || hand.facing == FlxObject.DOWN)) {
						//hand.velocity.x = -MAX_MOVE_VEL*0.00000022;
						setGravity(hand,FlxObject.LEFT,true);
					} else if (hand.velocity.x < 0 && (hand.facing == FlxObject.UP || hand.facing == FlxObject.DOWN)) {
						//hand.velocity.x = MAX_MOVE_VEL*0.00000022;
						setGravity(hand,FlxObject.RIGHT,true);
					} else if (hand.velocity.y > 0 && (hand.facing == FlxObject.LEFT || hand.facing == FlxObject.RIGHT)) {
						//hand.velocity.y = -MAX_MOVE_VEL*0.00000022;
						setGravity(hand,FlxObject.UP,true);
					} else if (hand.velocity.y < 0 && (hand.facing == FlxObject.LEFT || hand.facing == FlxObject.RIGHT)) {
						//hand.velocity.y = MAX_MOVE_VEL*0.00000022;
						setGravity(hand,FlxObject.DOWN,true);
					}
					
					hand.drag.x = 0;
					hand.drag.y = 0;
					hand.maxVelocity.x = MAX_GRAV_VEL;
					hand.maxVelocity.y = MAX_GRAV_VEL;
				} else if (!onGround && hand.isTouching(hand.facing) && (handWoodFlag == uint.MAX_VALUE || handMetalFlag < uint.MAX_VALUE || hand.isTouching(FlxObject.DOWN))) {
					onGround = true;
					setGravity(hand, hand.facing, true);
					hand.drag.x = MOVE_DECEL;
					hand.drag.y = MOVE_DECEL;
					hand.maxVelocity.x = MAX_MOVE_VEL;
					hand.maxVelocity.y = MAX_MOVE_VEL;
				}
			}
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
			} else if (spr2 in bodyGroup && spr1.mass > spr2.mass) {
				fixGravity(spr2);
			} else { //spr2 is probably a block
				if (spr1 == hand) {
					if (bodyMode) {
						handBlockFlag = blockGroup.members.indexOf(spr2);
					} else {
						handMetalFlag = 1;
						fixGravity(spr1);
						lastTouchedWood = false;
					}
				} else if (spr1 in bodyGroup && spr2.mass > spr1.mass) {
					fixGravity(spr1);
				}
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
	}
}