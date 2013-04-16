package
{
	import org.flixel.*;
	
	public class LevelSelect extends FlxState
	{	
		override public function create():void {
			var text:FlxText = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"Press one of the following: \n A -> tsh_1evel01.csv \n B -> tsh_level02.csv \n C -> tsh_level03.csv \n D -> testMap.csv \n E -> factory-demo.csv \n F -> tallMap.csv");
			add(text);
		}
		
		override public function update():void {
			
			if (FlxG.keys.justPressed("A")) {
				FlxG.switchState(new PlayState(Registry.level01,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("B")) {
				FlxG.switchState(new PlayState(Registry.level02,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("C")) {
				FlxG.switchState(new PlayState(Registry.level03,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("D")) {
				FlxG.switchState(new PlayState(Registry.testMap,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("E")) {
				FlxG.switchState(new PlayState(Registry.factoryDemoMap,Registry.midgroundMap,Registry.backgroundMap));
			}  else if (FlxG.keys.justPressed("F")) {
				FlxG.switchState(new PlayState(Registry.tallMap,Registry.midgroundMap,Registry.backgroundMap));
			}
			
			super.update();
		}
	}
}