package
{
	import org.flixel.*;
	
	public class EndState extends FlxState
	{	
		public var timer:Number = 0;
		//public var fadeInTime:Number = 22;
		public var fadeInTime:Number = 1.22;
		[Embed("assets/audio/Dirt_Footsteps.mp3")] public var dirtFootstepsSFX:Class;

		public var dirtFootstepsSound:FlxSound = new FlxSound().loadEmbedded(dirtFootstepsSFX);
		public var text:FlxText;
		public var delta:Number = 0.022;
		
		override public function create():void {
			FlxG.camera.x = -95;
			//FlxG.camera.y = -95;

			text = new FlxText(0,FlxG.height/4.0,FlxG.width,"THE END");
			text.alpha = 0;
			text.size = 22;
			text.font = "Capture it";
			text.alignment = "center";
			add(text);
			
			var $demoText:FlxText = new FlxText(0,FlxG.height*0.55,FlxG.width,"press enter to restart");
			
			$demoText.alignment = "center";
			$demoText.font = "Capture it";
			$demoText.size = 22;
			add($demoText);
		}
		
		override public function update():void {
			
			
			timer += FlxG.elapsed;
			
			if (timer < fadeInTime) {
				
				if (timer >= fadeInTime) {timer = fadeInTime;}
				text.alpha = 1 - Math.abs(fadeInTime - timer)/fadeInTime;
			}/*
			text.x += Math.pow(-1,int(Math.random()*10))*0.01;
			text.y += Math.pow(-1,int(Math.random()*10))*0.01;
			
			if (FlxG.width/2 - delta > text.x || text.x > FlxG.width/2 + delta) {
				text.x = FlxG.width/2;
			}
			if (FlxG.height/2 - delta > text.y || text.y > FlxG.height/2 + delta) {
				text.y = FlxG.height/2
			}*/
			
			if (/*timer > 4.22 || */FlxG.keys.justPressed("ENTER")) {
				var $exitFunction:Function = function():void {
					FlxG.switchState(new SplashState);
				};
				FlxG.fade(0xff000000,1,$exitFunction);
			}
			
			
			/*if (FlxG.keys.RIGHT || FlxG.keys.LEFT) {
				dirtFootstepsSound.play();
			} else {
				dirtFootstepsSound.stop();
			}*/
			
			
		}
	}
}