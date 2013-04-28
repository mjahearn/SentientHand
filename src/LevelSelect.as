package
{
	import org.flixel.*;
	
	public class LevelSelect extends FlxState
	{	
		public var controls:FlxButton;
		override public function create():void {
			
			Registry.midground = Registry.midgroundMap;
			Registry.background = Registry.backgroundMap;
		
			var text:FlxText = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"Press one of the following: \n A -> tsh_1evel01.csv \n B -> tsh_level02.csv \n C -> tsh_level03.csv \n D -> testMap.csv \n E -> factory-demo.csv \n F -> tallMap.csv \n G -> tsh_level04.csv \n H -> tsh_level05.csv");
			add(text);
			var ctlText:FlxText = new FlxText(100, 150, 400, "Controls (click to change):");
			controls = new FlxButton(100, 200, "Cam-Relative", changeControls);
			if (Registry.handRelative) {
				controls.label.text = "Hand-Relative";
			}
			add(ctlText);
			add(controls);
		}
		
		override public function update():void {
			
			if (FlxG.keys.justPressed("A")) {
				Registry.level = Registry.level01;
				FlxG.switchState(new PlayState);//(Registry.level01,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("B")) {
				Registry.level = Registry.level02;
				FlxG.switchState(new PlayState);//(Registry.level02,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("C")) {
				Registry.level = Registry.level03;
				FlxG.switchState(new PlayState);//(Registry.level03,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("D")) {
				Registry.level = Registry.testMap;
				FlxG.switchState(new PlayState);//(Registry.testMap,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("E")) {
				Registry.level = Registry.factoryDemoMap;
				FlxG.switchState(new PlayState);//(Registry.factoryDemoMap,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("F")) {
				Registry.level = Registry.tallMap;
				FlxG.switchState(new PlayState);//(Registry.tallMap,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("G")) {
				Registry.level = Registry.level04;
				FlxG.switchState(new PlayState);
			} else if (FlxG.keys.justPressed("H")) {
				Registry.level = Registry.level05;
				FlxG.switchState(new PlayState);
			}
			
			super.update();
		}
		
		public function changeControls():void {
			Registry.handRelative = !Registry.handRelative;
			if (Registry.handRelative) {
				controls.label.text = "Hand-Relative";
			} else {
				controls.label.text = "Cam-Relative";
			}
		}
	}
}