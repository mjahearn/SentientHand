package
{
	import org.flixel.*;
	
	public class LevelSelect extends FlxState
	{
		[Embed("assets/testMap.csv", mimeType = 'application/octet-stream')] public static var testMap:Class;
		[Embed("assets/factory-demo.csv", mimeType = 'application/octet-stream')] public static var factoryDemoMap:Class;
		[Embed("assets/factory-demo-background.csv", mimeType = 'application/octet-stream')] public static var backgroundMap:Class;
		[Embed("assets/factory-demo-midground.csv", mimeType = 'application/octet-stream')] public static var midgroundMap:Class;
		[Embed("assets/tallMap.csv", mimeType = 'application/octet-stream')] public static var tallMap:Class;
		[Embed("assets/tsh_level01.csv", mimeType = 'application/octet-stream')] public static var level01:Class;
		[Embed("assets/tsh_level02.csv", mimeType = 'application/octet-stream')] public static var level02:Class;
		[Embed("assets/tsh_level03.csv", mimeType = 'application/octet-stream')] public static var level03:Class;
		
		override public function create():void {
			
			var text:FlxText = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"Press one of the following: \n A -> level 1 \n B -> level 2 \n C -> level 3 \n D -> testMap \n E -> factory-demo \n F -> tallMap");
			add(text);
		}
		
		override public function update():void {
			
			if (FlxG.keys.justPressed("A")) {
				FlxG.switchState(new PlayState(level01,midgroundMap,backgroundMap));
			} else if (FlxG.keys.justPressed("B")) {
				FlxG.switchState(new PlayState(level02,midgroundMap,backgroundMap));
			} else if (FlxG.keys.justPressed("C")) {
				FlxG.switchState(new PlayState(level03,midgroundMap,backgroundMap));
			} else if (FlxG.keys.justPressed("D")) {
				FlxG.switchState(new PlayState(testMap,midgroundMap,backgroundMap));
			} else if (FlxG.keys.justPressed("E")) {
				FlxG.switchState(new PlayState(factoryDemoMap,midgroundMap,backgroundMap));
			}  else if (FlxG.keys.justPressed("F")) {
				FlxG.switchState(new PlayState(tallMap,midgroundMap,backgroundMap));
			}
			
			super.update();
		}
	}
}