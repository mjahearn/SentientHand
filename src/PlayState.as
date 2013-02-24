package {
	
	import org.flixel.*;
	
	public class PlayState extends FlxState {
		
		public var dbg:int;
		
		public var level:FlxTilemap;
		public var hand:FlxSprite;
		public var body:FlxSprite;
		
		public var levelHandCollided:Boolean;
		
		[Embed("assets/testTile.png")] public var tileset:Class;
		
		override public function create():void {
			FlxG.bgColor = 0xffaaaaaa;
			
			var data:Array = new Array(
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(data,20), tileset, 32, 32);
			add(level);
			
			hand = new FlxSprite(FlxG.width/2 - 16, 416);
			hand.makeGraphic(32,32,0xffaa1111);
			hand.maxVelocity.x = 200;
			hand.maxVelocity.y = 200;
			hand.acceleration.y = 400;
			hand.drag.x = hand.maxVelocity.x*4;
			hand.drag.y = hand.maxVelocity.y*4;
			hand.facing = FlxObject.DOWN;
			add(hand);
			
			body = new FlxSprite(544, 416);
			body.makeGraphic(32,32,0xff1111aa);
			body.acceleration.y = 400;
			add(body);
		}
		
		override public function update():void {
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
				} else if (handIsFacing(FlxObject.LEFT) && hand.overlaps(body)) {
					
				}
			} if (FlxG.keys.RIGHT) {
				if (handIsFacing(FlxObject.DOWN) || handIsFacing(FlxObject.UP)) {
					hand.acceleration.x = hand.maxVelocity.x*4;
				} else if (handIsFacing(FlxObject.LEFT) && hand.isTouching(FlxObject.LEFT)) {
					hand.velocity.x = hand.maxVelocity.x/2;
				} else if (handIsFacing(FlxObject.RIGHT) && hand.overlaps(body)) {
					
				}
			} if (FlxG.keys.UP) {
				if (handIsFacing(FlxObject.LEFT) || handIsFacing(FlxObject.RIGHT)) {
					hand.acceleration.y = -hand.maxVelocity.y*4;
				} else if (handIsFacing(FlxObject.DOWN) && hand.isTouching(FlxObject.DOWN)) {
					hand.velocity.y = -hand.maxVelocity.y/2;
				} else if (handIsFacing(FlxObject.UP) && hand.overlaps(body)) {
					
				}
			} if (FlxG.keys.DOWN) {
				if (handIsFacing(FlxObject.LEFT) || handIsFacing(FlxObject.RIGHT)) {
					hand.acceleration.y = hand.maxVelocity.y*4;
				} else if (handIsFacing(FlxObject.UP) && hand.isTouching(FlxObject.UP)) {
					hand.velocity.y = hand.maxVelocity.y/2;
				} else if (handIsFacing(FlxObject.DOWN) && hand.overlaps(body)) {
					
				}
			}
			
			super.update();
			
			FlxG.collide(level, hand, levelHandCollideCallback);
			FlxG.collide(level, body);
		}
		
		public function levelHandCollideCallback(a:FlxObject, b:FlxObject):void {
			if ((hand.touching & hand.facing) >= hand.facing) {
				if (hand.justTouched(FlxObject.DOWN)) {
					setGravity(FlxObject.DOWN, false);
				} else if (hand.justTouched(FlxObject.UP)) {
					setGravity(FlxObject.UP, false);
				} else if (hand.justTouched(FlxObject.LEFT)) {
					setGravity(FlxObject.LEFT, false);
				} else if (hand.justTouched(FlxObject.RIGHT)) {
					setGravity(FlxObject.RIGHT, false);
				}
			} else {
				if (hand.isTouching(FlxObject.DOWN)) {
					setGravity(FlxObject.DOWN, true);
				} else if (hand.isTouching(FlxObject.UP)) {
					setGravity(FlxObject.UP, true);
				} else if (hand.isTouching(FlxObject.LEFT)) {
					setGravity(FlxObject.LEFT, true);
				} else if (hand.isTouching(FlxObject.RIGHT)) {
					setGravity(FlxObject.RIGHT, true);
				}
			}
		}
		
		public function setGravity(dir:uint, reset:Boolean):void {
			if (reset) {
				hand.facing = dir;
				hand.acceleration.x = 0;
				hand.acceleration.y = 0;
			} else {
				hand.facing = hand.facing | dir;
			}
			if (dir == FlxObject.DOWN) {
				hand.acceleration.y = 400;
			} else if (dir == FlxObject.UP) {
				hand.acceleration.y = -400;
			} else if (dir == FlxObject.LEFT) {
				hand.acceleration.x = -400;
			} else if (dir == FlxObject.RIGHT) {
				hand.acceleration.x = 400;
			}
		}
		
		public function handIsFacing(dir:uint):Boolean {
			return (hand.facing & dir) > 0;
		}
	}
}