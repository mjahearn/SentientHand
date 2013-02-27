package {
	
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	public class PlayState extends FlxState {
		
		public const ROTATE_RATE:Number = 2;
		public const GRAPPLE_SPEED:Number = 300;
		
		public var dbg:int;
		public var rad:Number;
		
		public var level:FlxTilemap;
		public var hand:FlxSprite;
		public var body:FlxSprite;
		public var arrow:FlxSprite;
		
		public var bodyMode:Boolean;
		public var handOut:Boolean;
		public var handGrab:Boolean;
		public var handMetalFlag:Boolean;
		public var handWoodFlag:Boolean;
		
		[Embed("assets/testTile.png")] public var tileset:Class;
		[Embed("assets/testArrow.png")] public var arrowSheet:Class;
		
		override public function create():void {
			FlxG.bgColor = 0xffaaaaaa;
			
			var data:Array = new Array(
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
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(data,20), tileset, 32, 32);
			add(level);
			
			level.setTileProperties(1, FlxObject.ANY, metalCallback);
			level.setTileProperties(2, FlxObject.ANY, woodCallback);
			
			body = new FlxSprite(128, 416);
			body.makeGraphic(32,32,0xff1111aa);
			setGravity(body, FlxObject.DOWN, true);
			add(body);
			
			bodyMode = false;
			handOut = false;
			handGrab = false;
			handMetalFlag = false;
			handWoodFlag = false;
			rad = 0;
			
			hand = new FlxSprite(64, 416);
			hand.makeGraphic(32,32,0xffaa1111);
			hand.maxVelocity.x = 200;
			hand.maxVelocity.y = 200;
			hand.drag.x = hand.maxVelocity.x*4;
			hand.drag.y = hand.maxVelocity.y*4;
			setGravity(hand, FlxObject.DOWN, true);
			add(hand);
			
			arrow = new FlxSprite(body.x, body.y);
			arrow.loadGraphic(arrowSheet);
			arrow.visible = false;
			add(arrow);
		}
		
		override public function update():void {
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
						if (hand.touching > 0 && hand.touching != body.touching) {
							body.velocity.x = -GRAPPLE_SPEED * Math.cos(rad);
							body.velocity.y = -GRAPPLE_SPEED * Math.sin(rad);
						} else {
							hand.velocity.x = GRAPPLE_SPEED * Math.cos(rad);
							hand.velocity.y = GRAPPLE_SPEED * Math.sin(rad);
						}
					} else {
						if (hand.touching > 0 && hand.touching != body.touching) {
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
							if (body.touching == 0) {
								body.x = hand.x;
								body.y = hand.y;
							} else {
								hand.x = body.x;
								hand.y = body.y;
							}
							showArrow();
						}
					}
				} else {
					if (FlxG.keys.LEFT) {
						if (hand.facing == FlxObject.DOWN) {
							arrow.angle -= ROTATE_RATE;
						} else if (hand.facing == FlxObject.UP) {
							arrow.angle += ROTATE_RATE;
						} else if (handIsFacing(FlxObject.LEFT)) {
							bodyMode = false;
							arrow.visible = false;
						}
					} if (FlxG.keys.RIGHT) {
						if (hand.facing == FlxObject.DOWN) {
							arrow.angle += ROTATE_RATE;
						} else if (hand.facing == FlxObject.UP) {
							arrow.angle -= ROTATE_RATE;
						} else if (handIsFacing(FlxObject.RIGHT)) {
							bodyMode = false;
							arrow.visible = false;
						}
					} if (FlxG.keys.UP) {
						if (hand.facing == FlxObject.LEFT) {
							arrow.angle -= ROTATE_RATE;
						} else if (hand.facing == FlxObject.RIGHT) {
							arrow.angle += ROTATE_RATE;
						} else if (handIsFacing(FlxObject.UP)) {
							bodyMode = false;
							arrow.visible = false;
						}
					} if (FlxG.keys.DOWN) {
						if (hand.facing == FlxObject.LEFT) {
							arrow.angle += ROTATE_RATE;
						} else if (hand.facing == FlxObject.RIGHT) {
							arrow.angle -= ROTATE_RATE;
						} else if (handIsFacing(FlxObject.DOWN)) {
							bodyMode = false;
							arrow.visible = false;
						}
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
				if (FlxG.keys.SPACE && hand.overlaps(body)) {
					bodyMode = true;
					hand.velocity.x = 0;
					hand.velocity.y = 0;
					hand.acceleration.x = 0;
					hand.acceleration.y = 0;
					hand.x = body.x;
					hand.y = body.y;
					showArrow();
				} else {
					if (hand.facing == FlxObject.DOWN || hand.facing == FlxObject.UP) {
						hand.acceleration.x = 0;
					} else if (hand.facing == FlxObject.LEFT || hand.facing == FlxObject.RIGHT) {
						hand.acceleration.y = 0;
					}
					if (FlxG.keys.LEFT) {
						if (handIsFacing(FlxObject.DOWN) || handIsFacing(FlxObject.UP)) {
							hand.acceleration.x = -hand.maxVelocity.x*4;
						} else if (handIsFacing(FlxObject.RIGHT) && hand.isTouching(FlxObject.RIGHT)) {
							hand.velocity.x = -hand.maxVelocity.x/2;
						} /*else if (handIsFacing(FlxObject.LEFT)) {
							
						}*/
					} if (FlxG.keys.RIGHT) {
						if (handIsFacing(FlxObject.DOWN) || handIsFacing(FlxObject.UP)) {
							hand.acceleration.x = hand.maxVelocity.x*4;
						} else if (handIsFacing(FlxObject.LEFT) && hand.isTouching(FlxObject.LEFT)) {
							hand.velocity.x = hand.maxVelocity.x/2;
						}/* else if (handIsFacing(FlxObject.RIGHT)) {
							
						}*/
					} if (FlxG.keys.UP) {
						if (handIsFacing(FlxObject.LEFT) || handIsFacing(FlxObject.RIGHT)) {
							hand.acceleration.y = -hand.maxVelocity.y*4;
						} else if (handIsFacing(FlxObject.DOWN) && hand.isTouching(FlxObject.DOWN)) {
							hand.velocity.y = -hand.maxVelocity.y/2;
						} /*else if (handIsFacing(FlxObject.UP)) {
							
						}*/
					} if (FlxG.keys.DOWN) {
						if (handIsFacing(FlxObject.LEFT) || handIsFacing(FlxObject.RIGHT)) {
							hand.acceleration.y = hand.maxVelocity.y*4;
						} else if (handIsFacing(FlxObject.UP) && hand.isTouching(FlxObject.UP)) {
							hand.velocity.y = hand.maxVelocity.y/2;
						}/* else if (handIsFacing(FlxObject.DOWN)) {
							
						}*/
					}
				}
			}
			
			super.update();
			
			handMetalFlag = false;
			handWoodFlag = false;
			FlxG.collide(level, hand);
			FlxG.collide(level, body);
			if (!bodyMode && handWoodFlag && !handMetalFlag) {
				setGravity(hand, FlxObject.DOWN, true);
			}
		}
		
		public function metalCallback(tile:FlxTile, spr:FlxSprite):void {
			if (spr == hand) {
				handMetalFlag = true;
			}
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
		
		public function woodCallback(tile:FlxTile, spr:FlxSprite):void {
			if (spr == hand) {
				handWoodFlag = true;
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
				spr.acceleration.y = 400;
			} else if (dir == FlxObject.UP) {
				spr.acceleration.y = -400;
			} else if (dir == FlxObject.LEFT) {
				spr.acceleration.x = -400;
			} else if (dir == FlxObject.RIGHT) {
				spr.acceleration.x = 400;
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
	}
}