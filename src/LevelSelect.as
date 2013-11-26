package
{
	import org.flixel.*;
	
	public class LevelSelect extends FlxState
	{	
		public var camera:FlxButton;
		public var range:FlxButton;
		override public function create():void {
			
			//Registry.midground = Registry.midgroundMap;
			//Registry.background = Registry.backgroundMap;
		
			//var text:FlxText = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"Press one of the following: \n A -> tsh_1evel01.csv \n B -> tsh_level02.csv \n C -> tsh_level03.csv \n D -> testMap.csv \n E -> factory-demo.csv \n F -> tallMap.csv \n G -> tsh_level04.csv \n H -> tsh_level05.csv \n I -> tsh_level06.csv");
			var text:FlxText = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0);
			text.text = "Press one of the following:";
			text.text += "\n\nBen's unsorted levels:\n";
			text.text += "\nA -> mapCSV_functional_b01.csv";
			text.text += "\nB -> mapCSV_functional_b02.csv";
			text.text += "\nC -> mapCSV_functional_b03.csv";
			text.text += "\nD -> mapCSV_functional_b04.csv";
			text.text += "\nE -> mapCSV_functional_b05.csv";
			text.text += "\n\nMike's unsorted levels:\n";
			text.text += "\nF -> mapCSV_functional_m01.csv";
			text.text += "\n\nOld levels:\n";
			text.text += "\nG -> mapCSV_functional_001.csv";
			text.text += "\nH -> mapCSV_functional_006.csv";
			add(text);
			
			var camText:FlxText = new FlxText(100, 100, 400, "Camera Rotation:");
			camera = new FlxButton(100, 130, "Follow Gravity", changeCamera);
			if (Registry.cameraFollowsHand) {
				camera.label.text = "Follow Hand";
			}
			add(camText);
			add(camera);
			
			var rangeText:FlxText = new FlxText(100, 200, 400, "Camera Range:");
			range = new FlxButton(100, 230, "Level Bounds", changeRange);
			if (Registry.extendedCamera) {
				range.label.text = "Extended";
			}
			add(rangeText);
			add(range);
		}
		
		override public function update():void {
			
			if (FlxG.keys.justPressed("A")) {
				RegistryLevels.num = 0;
				//FlxG.switchState(new PlayState);
				FlxG.switchState(new SplashState);
			}
			
			if (FlxG.keys.justPressed("B")) {
				RegistryLevels.num = 1;
				FlxG.switchState(new SplashState);
			}
			
			if (FlxG.keys.justPressed("C")) {
				RegistryLevels.num = 2;
				FlxG.switchState(new SplashState);
			}
			
			if (FlxG.keys.justPressed("D")) {
				RegistryLevels.num = 3;
				FlxG.switchState(new SplashState);
			}
			
			if (FlxG.keys.justPressed("E")) {
				RegistryLevels.num = 4;
				FlxG.switchState(new SplashState);
			}
			
			if (FlxG.keys.justPressed("F")) {
				RegistryLevels.num = 5;
				FlxG.switchState(new SplashState);
			}
			
			if (FlxG.keys.justPressed("G")) {
				RegistryLevels.num = 6;
				FlxG.switchState(new SplashState);
			}
			
			if (FlxG.keys.justPressed("H")) {
				RegistryLevels.num = 7;
				FlxG.switchState(new SplashState);
			}
			
			
			/*
			if (FlxG.keys.justPressed("A")) {
				Registry.level = Registry.level01;
				Registry.background = Registry.back01;
				Registry.midground = Registry.mid01;
				FlxG.switchState(new PlayState);//(Registry.level01,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("B")) {
				Registry.background = Registry.back02;
				Registry.level = Registry.level02;
				Registry.midground = Registry.mid02;
				FlxG.switchState(new PlayState);//(Registry.level02,Registry.midgroundMap,Registry.backgroundMap));
			} else if (FlxG.keys.justPressed("C")) {
				Registry.level = Registry.level03;
				Registry.background = Registry.back03;
				Registry.midground = Registry.mid03;
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
				Registry.midground = Registry.mid04;
				Registry.background = Registry.back04;
				FlxG.switchState(new PlayState);
			} else if (FlxG.keys.justPressed("H")) {
				Registry.level = Registry.level05;
				Registry.midground = Registry.mid05;
				Registry.background = Registry.back05;
				FlxG.switchState(new PlayState);
			} else if (FlxG.keys.justPressed("I")) {
				
				Registry.level = Registry.level06;
				Registry.background = Registry.back06;
				Registry.midground = Registry.mid06;
				
				Registry.levelNum = 5;
				FlxG.switchState(new PlayState);
			}*/
			
			super.update();
		}
		
		public function changeCamera():void {
			Registry.cameraFollowsHand = !Registry.cameraFollowsHand;
			if (Registry.cameraFollowsHand) {
				camera.label.text = "Follow Hand";
			} else {
				camera.label.text = "Follow Gravity";
			}
		}
		
		public function changeRange():void {
			Registry.extendedCamera = !Registry.extendedCamera;
			if (Registry.extendedCamera) {
				range.label.text = "Extended";
			} else {
				range.label.text = "Level Bounds";
			}
		}
	}
}