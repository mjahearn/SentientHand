package {
	
	import org.flixel.*;
	
	public class RegistryControls {
		
		public static const ACTION_KEY:String = Registry.jumpSpace?"SPACE":"UP";
		public static const BODY_KEY:String = "DOWN";
		public static const LEFT_KEY:String = "LEFT";
		public static const RIGHT_KEY:String = "RIGHT";
		
		protected static var _controlDirs:Array = new Array();
		
		public static function update():void {
			if (FlxG.keys.justPressed(RIGHT_KEY) && _controlDirs.indexOf(FlxObject.RIGHT) == -1) {
				_controlDirs.push(FlxObject.RIGHT);
			}
			if (FlxG.keys.justPressed(LEFT_KEY) && _controlDirs.indexOf(FlxObject.LEFT) == -1) {
				_controlDirs.push(FlxObject.LEFT);
			}
			if (FlxG.keys.justPressed(ACTION_KEY) && _controlDirs.indexOf(FlxObject.UP) == -1) {
				_controlDirs.push(FlxObject.UP);
			}
			if (FlxG.keys.justPressed(BODY_KEY) && _controlDirs.indexOf(FlxObject.DOWN) == -1) {
				_controlDirs.push(FlxObject.DOWN);
			}
			if (FlxG.keys.justReleased(RIGHT_KEY)) {
				remove(FlxObject.RIGHT);
			}
			if (FlxG.keys.justReleased(LEFT_KEY)) {
				remove(FlxObject.LEFT);
			}
			if (FlxG.keys.justReleased(ACTION_KEY)) {
				remove(FlxObject.UP);
			}
			if (FlxG.keys.justReleased(BODY_KEY)) {
				remove(FlxObject.DOWN);
			}
		}
		
		public static function reset():void {
			_controlDirs = new Array();
		}
		
		public static function isPressed(dir:uint):Boolean {
			if (dir == FlxObject.LEFT) {
				return _controlDirs.indexOf(FlxObject.LEFT) > _controlDirs.indexOf(FlxObject.RIGHT);
			} else if (dir == FlxObject.RIGHT) {
				return _controlDirs.indexOf(FlxObject.LEFT) < _controlDirs.indexOf(FlxObject.RIGHT);
			} else if (dir == FlxObject.UP) {
				return _controlDirs.indexOf(FlxObject.UP) > -1;
			} else if (dir == FlxObject.DOWN) {
				return _controlDirs.indexOf(FlxObject.DOWN) > -1;
			}
			return false;
		}
		
		public static function remove(dir:uint):void {
			var cD:int = _controlDirs.indexOf(dir);
			if (cD != -1) {
				_controlDirs.splice(cD, 1);
			}
		}
	}
}