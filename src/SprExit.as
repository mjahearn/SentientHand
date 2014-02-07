package
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	public class SprExit extends FlxSprite
	{
		// lights (when turned on)
		private var lightC:FlxSprite;
		private var lightArrow:FlxSprite;
		
		// used to set the direction of the exit arrow
		public static const kL:uint = 0;
		public static const kR:uint = 1;
		
		// obvious
		private var isOn:Boolean;
		
		// times the next potential brightness jump
		private var brightnessTimer:Number;
		private var brightnessPeriod:Number;
		
		public function SprExit($leftOrRight:uint,$x:Number=0,$y:Number=0)
		{
			super($x,$y,Registry.kExitSignSheet);
			
			lightC = new FlxSprite($x,$y,Registry.kExitSignCSheet);
			lightArrow = new FlxSprite($x,$y,($leftOrRight == SprExit.kL ? Registry.kExitSignLSheet:Registry.kExitSignRSheet));
			lightC.color = 0xffff0000;//0xff00ff00;
			lightArrow.color = 0xffff0000;//0xff00ff00;
			lightC.alpha = 0;
			lightArrow.alpha = 0;
			
			turnOn();
			resetBrightnessTimer();
			jumpBrightness(Math.random());
		}
		
		override public function draw():void {
			super.draw();
			// also draw the lights (if they're on)
			if (!isOn) {return;}
			lightArrow.draw();
			lightC.draw();
		}
		
		// controls for the light
		public function turnOn():void {isOn = true;}
		public function turnOff():void {isOn = false;}
		
		override public function update():void {
			super.update();
			// don't proceed if the light's not on
			if (!isOn) {return;}
			brightnessTimer += FlxG.elapsed;
			//FlxG.log(brightnessTimer);
			if (brightnessTimer >= brightnessPeriod) {
				maybeJumpBrightness();
				resetBrightnessTimer();
			}
			if (brightnessTimer >= brightnessPeriod/2) {
				fadeBrightnessOverTime();
			}
		}
		
		private function maybeJumpBrightness():void {
			var rand:Number = Math.random();
			if (rand*3 > 1.5) {return;}
			jumpBrightness(rand);
		}
		
		private function jumpBrightness($rand:Number):void {
			var brightness:Number = $rand*0.66;
			// don't replace with a lower brightness
			if (brightness <= lightC.alpha) {return;}
			lightC.alpha = brightness;
			lightArrow.alpha = brightness;
		}
		
		private function fadeBrightnessOverTime():void {
			var fade:Number = 0.0088;
			lightC.alpha -= fade;
			lightArrow.alpha -= fade;
		}
		
		private function resetBrightnessTimer():void {
			brightnessTimer = 0;
			brightnessPeriod = Math.random()+0.22;
		}
	}
}