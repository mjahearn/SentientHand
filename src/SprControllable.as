package
{
	import org.flixel.*;
	
	//superclass for SprHand and SprBody- handles collision with level; changes in gravity
	
	public class SprControllable extends FlxSprite {
		
		public const GRAV_RATE:Number = 1600; //acceleration (in pixels per second per second) due to gravity
		public const MAX_MOVE_VEL:Number = 200; //maximum velocity (in pixels per second) of the hand's movement
		public const MAX_GRAV_VEL:Number = 400; //terminal velocity (in pixels per second) of gravity
		
		public function SprControllable(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			PlayState.current.sprControllableGroup.add(this);
		}
		
		public function setDir(dir:uint, grav:Boolean=false, setAngle:Boolean=true):void {
			facing = dir;
			acceleration.x = 0;
			acceleration.y = 0;
			if (grav) {
				if (dir == FlxObject.DOWN) {
					acceleration.y = GRAV_RATE;
				} else if (dir == FlxObject.UP) {
					acceleration.y = -GRAV_RATE;
				} else if (dir == FlxObject.LEFT) {
					acceleration.x = -GRAV_RATE;
				} else if (dir == FlxObject.RIGHT) {
					acceleration.x = GRAV_RATE;
				}
				maxVelocity.x = MAX_GRAV_VEL;
				maxVelocity.y = MAX_GRAV_VEL;
			} else {
				maxVelocity.x = MAX_MOVE_VEL;
				maxVelocity.y = MAX_MOVE_VEL;
			}
			if (setAngle) {
				angle = dirToDeg(dir);
			}
		}
		
		private function dirToDeg(dir:uint):Number {
			if (dir == FlxObject.LEFT) {
				return 90;
			} else if (dir == FlxObject.UP) {
				return 180;
			} else if (dir == FlxObject.RIGHT) {
				return 270;
			}
			return 0; //else if dir == DOWN
		}
		
		private function getTilesInDir(dir:uint):Array {
			var level:FlxTilemap = PlayState.current.levelFunctional;
			var fixedX:Boolean = (dir == FlxObject.LEFT || dir == FlxObject.RIGHT);
			var forwards:Boolean = (dir == FlxObject.DOWN || dir == FlxObject.RIGHT);
			var indX:uint = int(x/8);
			var indY:uint = int(y/8);
			var result:Array = new Array();
			var max:int;
			if ((fixedX?y:x) % 8 == 0) {
				max = 3;
			} else {
				max = 4;
			}
			for (var a:uint = 0; a <= max; a++) {
				if (fixedX && indY < level.heightInTiles - a) {
					result.push(level.getTile(indX+(forwards?4:-1), indY+a));
				} else if (!fixedX && indX < level.widthInTiles - a) {
					result.push(level.getTile(indX+a, indY+(forwards?4:-1)));
				}
			}
			return result;
		}
		
		public function isNothingInDir(dir:uint):Boolean {
			var tiles:Array = getTilesInDir(dir);
			for (var i:uint = 0; i < tiles.length; i++) {
				if (!isUntouchable(tiles[i])) {
					return false;
				}
			}
			return true;
		}
		
		private function isUntouchable(tile:uint):Boolean {
			for (var i:uint = 0; i < RegistryLevels.kSpawnEmpty.length; i++) {
				var index:uint = RegistryLevels.kSpawnEmpty[i];
				if (tile == index) {
					return true;
				}
			}
			return false;
		}
		
		public function isMetalInDir(dir:uint):Boolean {
			var tiles:Array = getTilesInDir(dir);
			for (var i:uint = 0; i < tiles.length; i++) {
				if (isMetal(tiles[i])) {
					return true;
				}
			}
			return false;
		}
		
		private function isMetal(tile:uint):Boolean {
			if (PlayState.current.reversePolarity) {
				return RegistryLevels.kSpawnWood.indexOf(tile) != -1;
			}
			return RegistryLevels.kSpawnMetal.indexOf(tile) != -1;
		}
		
		public function isNeutralInDir(dir:uint):Boolean {
			var tiles:Array = getTilesInDir(dir);
			for (var i:uint = 0; i < tiles.length; i++) {
				if (isNeutral(tiles[i])) {
					return true;
				}
			}
			return false;
		}
		
		private function isNeutral(tile:uint):Boolean {
			if (PlayState.current.reversePolarity) {
				return (RegistryLevels.kSpawnMetal.indexOf(tile) != -1 || RegistryLevels.kSpawnNeutral.indexOf(tile) != -1);
			}
			return (RegistryLevels.kSpawnWood.indexOf(tile) != -1 || RegistryLevels.kSpawnNeutral.indexOf(tile) != -1);
		}
		
		public function collideCallback():void {
			if (isTouching(FlxObject.DOWN)) {
				if (isMetalInDir(FlxObject.DOWN)) {
					collideWithMetal(FlxObject.DOWN);
				} else {
					collideWithWood(false);
				}
			} else if (isTouching(FlxObject.UP) && isMetalInDir(FlxObject.UP)) { //shorten this to isMetalInDir(touching)?
				collideWithMetal(FlxObject.UP);
			} else if (isTouching(FlxObject.LEFT) && isMetalInDir(FlxObject.LEFT)) {
				collideWithMetal(FlxObject.LEFT);
			} else if (isTouching(FlxObject.RIGHT) && isMetalInDir(FlxObject.RIGHT)) {
				collideWithMetal(FlxObject.RIGHT);
			} //The corner-reversed-gravity bug was caused by this else if statement. I fixed it (by adding the second condition), but come to think of it, I'm not sure it's necessary to handle this case at all... 
			/*else if (facing != FlxObject.DOWN && !isMetalInDir(facing)) { //if the hand only hit wood after being shot by cannon
				collideWithWood(true);
			}*/
		}
		
		public function collideWithMetal(dir:uint):void {
			setDir(dir);
		}
		
		public function collideWithWood(grav:Boolean):void {
			setDir(FlxObject.DOWN, grav);
		}
	}
}