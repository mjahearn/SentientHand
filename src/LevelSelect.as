package
{
	import org.flixel.*;
	
	public class LevelSelect extends FlxState
	{	
		public var camera:FlxButton;
		public var range:FlxButton;
		public var jump:FlxButton;
		override public function create():void {
			
			//Registry.midground = Registry.midgroundMap;
			//Registry.background = Registry.backgroundMap;
		
			//var text:FlxText = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"Press one of the following: \n A -> tsh_1evel01.csv \n B -> tsh_level02.csv \n C -> tsh_level03.csv \n D -> testMap.csv \n E -> factory-demo.csv \n F -> tallMap.csv \n G -> tsh_level04.csv \n H -> tsh_level05.csv \n I -> tsh_level06.csv");
			var text:FlxText = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0);
			text.text = "Press one of the following:";
			text.text += "\n\nTutorial levels:\n";
			text.text += "\nA -> tutorial1";
			text.text += "\nB -> tutorial2";
			text.text += "\nC -> tutorial3";
			text.text += "\nD -> tutorial4";
			text.text += "\n\nBen's unsorted levels:\n";
			text.text += "\nE -> cannon1";
			text.text += "\nF -> plain1";
			text.text += "\nG -> grapple1";
			text.text += "\nH -> cannon2";
			text.text += "\nI -> grapple2";
			text.text += "\n\nMike's unsorted levels:\n";
			text.text += "\nJ -> m01";
			text.text += "\nK -> m02";
			text.text += "\n\nOld levels:\n";
			text.text += "\nL -> 001";
			text.text += "\nM -> 006";
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
			
			var jumpText:FlxText = new FlxText(100, 300, 400, "Jump Button:");
			jump = new FlxButton(100, 330, "Up Arrow", changeJump);
			if (Registry.jumpSpace) {
				jump.label.text = "Spacebar";
			}
			add(jumpText);
			add(jump);
		}
		
		override public function update():void {
			
			for (var a:Number = 0; a < RegistryLevels.numLevels; a++) {
				if (FlxG.keys.justPressed(String.fromCharCode(65+a))) { // works until letter Z (26)
					RegistryLevels.num = a;
					FlxG.switchState(new SplashState);
					break;
				}
			}
			
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
		
		public function changeJump():void {
			Registry.jumpSpace = !Registry.jumpSpace;
			if (Registry.jumpSpace) {
				jump.label.text = "Spacebar";
			} else {
				jump.label.text = "Up Arrow";
			}
		}
	}
}