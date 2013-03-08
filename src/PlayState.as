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
		public const METAL_MAX:uint = 159; //maximum index number of metal in the tilemap
		public const WOOD_MIN:uint = 1; //minimum index number of wood in the tilemap
		public const WOOD_MAX:uint = 47; // maximum index number of wood in the tilemap
		//public const SPAWN:unit = ???; // index of player spawn point in tilemap (mjahearn: this should probably be a FlxPoint variable, set in create() after we read the tilemap)
		public const EMPTY_SPACE:uint = 0; // index of empty space in tilemap
		
		public var dbg:int;
		public var rad:Number;
		
		public var level:FlxTilemap;
		public var levelBack:FlxTilemap;
		public var hand:FlxSprite;
		public var body:FlxSprite;
		public var arrow:FlxSprite;
		public var bodyGear:FlxSprite;
		
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
		
		public var gears:FlxGroup = new FlxGroup();
		
		[Embed("assets/level-tiles.png")] public var tileset:Class;
		[Embed("assets/background-tiles.png")] public var backgroundset:Class;
		
		[Embed("assets/testArrow.png")] public var arrowSheet:Class;
		[Embed("assets/hand.png")] public var handSheet:Class;
		[Embed("assets/arm.png")] public var armSheet:Class;
		[Embed("assets/body.png")] public var bodySheet:Class;
		
		[Embed("assets/gear_64x64.png")] public var gearSheet:Class;
		
		[Embed("assets/testMap.csv", mimeType = 'application/octet-stream')] public static var testMap:Class;
		[Embed("assets/factory-demo.csv", mimeType = 'application/octet-stream')] public static var factoryDemoMap:Class;
		[Embed("assets/factory-demo-background.csv", mimeType = 'application/octet-stream')] public static var backgroundMap:Class;
		
		[Embed("assets/block_32x32_w6.png")] public var block32x32w6Sheet:Class;
		
		[Embed("assets/bodygear.png")] public var bodyGearSheet:Class;
		
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
			
			// background
			levelBack = new FlxTilemap();
			levelBack.loadMap(new backgroundMap,backgroundset,8,8);
			add(levelBack);
			
			// midground objects
			var gear000:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			
			/*
			var gear001:FlxSprite = new FlxSprite(64,480-64,gearSheet);
			var gear002:FlxSprite = new FlxSprite(96,480-64,gearSheet);
			var gear003:FlxSprite = new FlxSprite(128,480-64,gearSheet);
			var gear004:FlxSprite = new FlxSprite(0,480-128,gearSheet);
			var gear005:FlxSprite = new FlxSprite(64,480-128,gearSheet);
			var gear006:FlxSprite = new FlxSprite(96,480-128,gearSheet);
			var gear007:FlxSprite = new FlxSprite(128,480-128,gearSheet);
			var gear008:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear009:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear010:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear011:FlxSprite = new FlxSprite(64,480-64,gearSheet);
			var gear012:FlxSprite = new FlxSprite(96,480-64,gearSheet);
			var gear013:FlxSprite = new FlxSprite(128,480-64,gearSheet);
			var gear014:FlxSprite = new FlxSprite(0,480-128,gearSheet);
			var gear015:FlxSprite = new FlxSprite(64,480-128,gearSheet);
			var gear016:FlxSprite = new FlxSprite(96,480-128,gearSheet);
			var gear017:FlxSprite = new FlxSprite(128,480-128,gearSheet);
			var gear018:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear019:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear020:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear021:FlxSprite = new FlxSprite(64,480-64,gearSheet);
			var gear022:FlxSprite = new FlxSprite(96,480-64,gearSheet);
			var gear023:FlxSprite = new FlxSprite(128,480-64,gearSheet);
			var gear024:FlxSprite = new FlxSprite(0,480-128,gearSheet);
			var gear025:FlxSprite = new FlxSprite(64,480-128,gearSheet);
			var gear026:FlxSprite = new FlxSprite(96,480-128,gearSheet);
			var gear027:FlxSprite = new FlxSprite(128,480-128,gearSheet);
			var gear028:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear029:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear030:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear031:FlxSprite = new FlxSprite(64,480-64,gearSheet);
			var gear032:FlxSprite = new FlxSprite(96,480-64,gearSheet);
			var gear033:FlxSprite = new FlxSprite(128,480-64,gearSheet);
			var gear034:FlxSprite = new FlxSprite(0,480-128,gearSheet);
			var gear035:FlxSprite = new FlxSprite(64,480-128,gearSheet);
			var gear036:FlxSprite = new FlxSprite(96,480-128,gearSheet);
			var gear037:FlxSprite = new FlxSprite(128,480-128,gearSheet);
			var gear038:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			var gear039:FlxSprite = new FlxSprite(0,480-64,gearSheet);
			*/
			
			gears.add(gear000);
			/*
			gears.add(gear001);
			gears.add(gear002);
			gears.add(gear003);
			gears.add(gear004);
			gears.add(gear005);
			gears.add(gear006);
			gears.add(gear007);
			gears.add(gear008);
			gears.add(gear009);
			gears.add(gear010);
			gears.add(gear011);
			gears.add(gear012);
			gears.add(gear013);
			gears.add(gear014);
			gears.add(gear015);
			gears.add(gear016);
			gears.add(gear017);
			gears.add(gear018);
			gears.add(gear019);
			gears.add(gear020);
			gears.add(gear021);
			gears.add(gear022);
			gears.add(gear023);
			gears.add(gear024);
			gears.add(gear025);
			gears.add(gear026);
			gears.add(gear027);
			gears.add(gear028);
			gears.add(gear029);
			gears.add(gear030);
			gears.add(gear031);
			gears.add(gear032);
			gears.add(gear033);
			gears.add(gear034);
			gears.add(gear035);
			gears.add(gear036);
			gears.add(gear037);
			gears.add(gear038);
			gears.add(gear039);
			*/
			
			for (var jj:String in gears.members) {add(gears.members[jj]);}
			
			// foreground
			level = new FlxTilemap();
			//level.loadMap(FlxTilemap.arrayToCSV(data,20), tileset, 32, 32);
			//level.loadMap(new testMap,tileset,8,8);
			level.loadMap(new factoryDemoMap,tileset,8,8);
			add(level);
			
			for (var i:int = WOOD_MIN; i <= WOOD_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, woodCallback);
			}
			for (i = METAL_MIN; i <= METAL_MAX; i++) {
				level.setTileProperties(i, FlxObject.ANY, metalCallback);
			}
			
			body = new FlxSprite(160, 416,bodySheet);
			bodyTargetAngle = body.angle;
			setGravity(body, FlxObject.DOWN, true);
			add(body);
			bodyGear = new FlxSprite(body.x,body.y,bodyGearSheet);
			add(bodyGear);
			
			bodyMode = false;
			handOut = false;
			handGrab = false;
			handMetalFlag = uint.MAX_VALUE;
			handWoodFlag = uint.MAX_VALUE;
			handBlockFlag = uint.MAX_VALUE;
			handBlockRel = new FlxPoint();
			rad = 0;
			
			var arm:FlxSprite;
			for (i = 0; i < numArms; i++) {
				arm = new FlxSprite(body.x,body.y,armSheet);
				arm.visible = false;
				add(arm);
				arms.add(arm);
			}
			
			hand = new FlxSprite(64, 416);
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
			
			blockGroup = new FlxGroup();
			var testBlock:FlxSprite = new FlxSprite(450, 416,block32x32w6Sheet);//.makeGraphic(32, 32, 0xff007fff);
			testBlock.immovable = true;
			blockGroup.add(testBlock);
			add(blockGroup);
			
			arrow = new FlxSprite(body.x, body.y);
			arrow.loadGraphic(arrowSheet);
			arrow.visible = false;
			add(arrow);
		}
		
		override public function update():void {
			
			if (hand.touching) {handFalling = false;}
			
			// janky way of moving body gear (this only works for one body, should really classify it)
			bodyGear.x = body.x;
			bodyGear.y = body.y;
			bodyGear.angle = -arrow.angle;
			
			// spin midground gears
			var gear:FlxSprite;
			for (var jjj:String in gears.members) {
				gear = gears.members[jjj];
				gear.angle += 0.5;
				if (gear.angle > 360) {gear.angle = 0;}
			}
			
			// rudimentary animation
			if (!bodyMode && hand.touching){
				for (var i:String in arms.members) {
					arms.members[i].visible = false;
				}
				// first set facing of hand sprite
				if (hand.facing == FlxObject.DOWN) {hand.angle = 0;}
				else if (hand.facing == FlxObject.LEFT) {hand.angle = 90;}
				else if (hand.facing == FlxObject.UP) {hand.angle = 180;}
				else if (hand.facing == FlxObject.RIGHT) {hand.angle = 270;}
				// then do left/rigt animations (sprite's not ambidexterous...)
				if (FlxG.keys.RIGHT) {
					handDir = FlxObject.RIGHT;
					hand.play("crawl right");
				} else if (FlxG.keys.LEFT) {
					handDir = FlxObject.LEFT;
					hand.play("crawl left");
				} else if (hand.velocity.x == 0 && hand.velocity.y == 0) {
					if (handDir == FlxObject.LEFT) {hand.play("idle left");}
					else if (handDir == FlxObject.RIGHT) {hand.play("idle right");}
				}	
			} else if (!bodyMode && !hand.touching && hand.angle > 0 && hand.angle < 360) {
				if (handDir == FlxObject.LEFT) {
					hand.play("idle left"); //placeholder
					//hand.play("left fall");
					hand.angle += 10;
				} else if (handDir == FlxObject.RIGHT) {
					hand.play("idle right"); //placeholder
					//hand.play("right fall");
					hand.angle -= 10;
				}
			} else if (bodyMode){
				hand.angle = arrow.angle - 90;
				hand.play("idle body");
				
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
					arm.angle = hand.angle;
				}
				
				if (handOut && hand.touching) {
					// first set facing of hand sprite
					if (hand.facing == FlxObject.DOWN) {hand.angle = 0;}
					else if (hand.facing == FlxObject.LEFT) {hand.angle = 90;}
					else if (hand.facing == FlxObject.UP) {hand.angle = 180;}
					else if (hand.facing == FlxObject.RIGHT) {hand.angle = 270;}
					
					// for now, just changing direction immediately, but should really swivel into place as the hand moves
					// maybe set a destination, then swivel to it?
					if (hand.facing == FlxObject.DOWN) {bodyTargetAngle = 0;}
					else if (hand.facing == FlxObject.LEFT) {bodyTargetAngle = 90;}
					else if (hand.facing == FlxObject.UP) {bodyTargetAngle = 180;}
					else if (hand.facing == FlxObject.RIGHT) {bodyTargetAngle = 270;}
				}
				
				if (!FlxG.keys.SPACE) {
					if (bodyTargetAngle > body.angle) {
						body.angle += 2;
					} else if (bodyTargetAngle < body.angle) {
						body.angle -= 2;
					}
				}
				if (!handOut) {body.angle = bodyTargetAngle;}
				
			}
			////
			
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
						if (hand.touching <= 0) {
							hand.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
							hand.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
						}
					} else {
						if (hand.touching > 0 && hand.facing == hand.touching) {
							body.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
							body.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
						} else {
							hand.velocity.x = -GRAPPLE_SPEED * Math.cos(rad);
							hand.velocity.y = -GRAPPLE_SPEED * Math.sin(rad);
						}
						if (Math.abs(diffX) < Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.cos(rad)) &&
							Math.abs(diffY) < Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.sin(rad))) {
							handOut = false;
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
							showArrow();
						}
					}
				} else {
					if (FlxG.keys.LEFT) {
						arrow.angle -= ROTATE_RATE;
					} if (FlxG.keys.RIGHT) {
						arrow.angle += ROTATE_RATE;
					} if (FlxG.keys.justPressed("DOWN")) {
						bodyMode = false;
						arrow.visible = false;
						setGravity(hand, hand.facing, true);
					}
					rad = Math.PI*arrow.angle/180;
					if (FlxG.keys.justPressed("SPACE")) {
						handOut = true;
						arrow.visible = false;
						hand.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
						hand.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
					}
				}
			} else {
				if (FlxG.keys.justPressed("DOWN") && hand.overlaps(body)) {
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
							//handFalling = true;
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
			var prevHandBlockFlag:uint = handBlockFlag;
			handBlockFlag = uint.MAX_VALUE;
			FlxG.collide(level, hand);
			FlxG.collide(blockGroup, hand, blockCallback);
			FlxG.collide(level, body);
			FlxG.collide(blockGroup, body, blockCallback);
			FlxG.collide(level, blockGroup);
			if (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE) {
				/* since Flixel only ever calls one tile callback function, the one corresponding to the topmost or leftmost corner 
				of the hand against the surface, we must do this check for the other corner to compensate*/
				var indX:uint = handWoodFlag % level.widthInTiles;
				var indY:uint = handWoodFlag / level.widthInTiles;
				if (hand.isTouching(FlxObject.UP) && indX < level.widthInTiles - 1 && isMetal(level.getTile(indX+1,indY))) {
					handMetalFlag = indY*level.widthInTiles + indX+1;
				} else if ((hand.isTouching(FlxObject.LEFT) || hand.isTouching(FlxObject.RIGHT)) && indY < level.heightInTiles - 1 && isMetal(level.getTile(indX,indY+1))) {
					handMetalFlag = (indY+1)*level.widthInTiles + indX;
				}
			}
			if (bodyMode) {
				/*if (onGround && handBlockFlag < uint.MAX_VALUE) {
					var curBlock:FlxSprite = blockGroup.members[handBlockFlag];
					if (handBlockFlag != prevHandBlockFlag) {
						curBlock.immovable = false;
						curBlock.drag.x = Number.MAX_VALUE;
						curBlock.drag.y = Number.MAX_VALUE;
						handBlockRel = new FlxPoint(curBlock.x - hand.x, curBlock.y - hand.y);
					}
					FlxG.log(handBlockRel.x);
					curBlock.x = hand.x + handBlockRel.x;
					curBlock.y = hand.y + handBlockRel.y;
				}*/
			} else {
				if (onGround && ( !hand.isTouching(hand.facing) || (handWoodFlag < uint.MAX_VALUE && handMetalFlag == uint.MAX_VALUE && !hand.isTouching(FlxObject.DOWN)))) {
					onGround = false;
					
					// needs fixing
					if (FlxG.keys.justPressed("UP")) {
						setGravity(hand, FlxObject.DOWN, true);
					} else if (FlxG.keys.LEFT) {
						if (hand.facing == FlxObject.UP) {
							setGravity(hand,FlxObject.LEFT,true);
						} else if (hand.facing == FlxObject.DOWN) {
							setGravity(hand,FlxObject.RIGHT,true);
						} else if (hand.facing == FlxObject.RIGHT) {
							setGravity(hand,FlxObject.UP,true);
						} else if (hand.facing == FlxObject.LEFT) {
							setGravity(hand,FlxObject.DOWN,true);
						}
					} else if (FlxG.keys.RIGHT) {
						if (hand.facing == FlxObject.UP) {
							setGravity(hand,FlxObject.RIGHT,true);
						} else if (hand.facing == FlxObject.DOWN) {
							setGravity(hand,FlxObject.LEFT,true);
						} else if (hand.facing == FlxObject.RIGHT) {
							setGravity(hand,FlxObject.DOWN,true);
						} else if (hand.facing == FlxObject.LEFT) {
							setGravity(hand,FlxObject.UP,true);
						}
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
			}
			fixGravity(spr);
		}
		
		public function woodCallback(tile:FlxTile, spr:FlxSprite):void {
			if (spr == hand) {
				handWoodFlag = tile.mapIndex;
			}
		}
		
		public function blockCallback(spr1:FlxSprite, spr2:FlxSprite):void {
			if (spr2 == hand) {
				//handBlockFlag = blockGroup.members.indexOf(spr1);
				handMetalFlag = 1;
				fixGravity(spr2);
			} else if (spr2 == body) {
				fixGravity(spr2);
			} else { //spr2 is probably a block
				if (spr1 == hand) {
					//handBlockFlag = blockGroup.members.indexOf(spr2);
					handMetalFlag = 1;
					fixGravity(spr1);
				} else if (spr1 == body) {
					fixGravity(spr1);
				}
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
			arrow.visible = true;
			arrow.x = body.x;
			arrow.y = body.y;
			if (handIsFacing(FlxObject.DOWN)) {
				arrow.angle = -90;
			} else if (handIsFacing(FlxObject.UP)) {
				arrow.angle = 90;
			} else if (handIsFacing(FlxObject.LEFT)) {
				arrow.angle = 0;
			} else if (handIsFacing(FlxObject.RIGHT)) {
				arrow.angle = 180;
			}
		}
		
		public function isMetal(tile:uint):Boolean {
			return (tile >= METAL_MIN && tile <= METAL_MAX);
		}
	}
}