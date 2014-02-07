package
{
	import org.flixel.*;
	
	public class SprBulb extends FlxSprite
	{
		private var anims:FlxSprite;
		private var illumination:FlxSprite;
		
		private var kAnimOn:String = "kAnimOn";
		private var kAnimOff:String = "kAnimOff";
		
		private var isOn:Boolean;
		private var scaleFactor:Number;
		
		private var brightnessTimer:Number;
		private var brightnessPeriod:Number;
		
		private var onOffTimer:Number;
		private var onOffPeriod:Number;
		
		public function SprBulb(X:Number=0, Y:Number=0)
		{
			isOn = false;
			
			super(X, Y, Registry.kBulbBaseSheet);
			
			anims = new FlxSprite(x,y);
			anims.loadGraphic(Registry.kBulbAnimSheet,true,false,width,height);
			anims.addAnimation(kAnimOn,[1,2,3],10);
			anims.addAnimation(kAnimOff,[0]);
			anims.alpha = 0.44;
			
			playTurnOn();
			
			illumination = new FlxSprite();
			illumination.loadGraphic(Registry.kBulbIlluminationSheet);
			illumination.x = x + width/2.0 - illumination.width/2.0;
			illumination.y = y + height/2.0 - illumination.height/2.0;
			
			resetBrightness();
			resetOnOff();
			changeScaleFactor(Math.random());
		}
		
		public function playTurnOn():void {anims.play(kAnimOn); isOn = true;}
		public function playTurnOff():void {anims.play(kAnimOff); isOn = false;}
		
		override public function draw():void {
			super.draw();
			anims.draw();
			if (isOn) {illumination.draw();}
		}
		
		override public function update():void {
			super.update();
			anims.update();
			illumination.update();
			
			maybeSwitchState();
			
			if (!isOn) {return;}
			brightnessTimer += FlxG.elapsed;
			if (brightnessTimer >= brightnessPeriod) {
				maybeChangeScaleFactor();
				resetBrightness();
			}
			fadeSlowly();
			illumination.alpha = (Math.random()*0.1) + scaleFactor/15.0;
			illumination.scale = new FlxPoint(scaleFactor,scaleFactor);
			
		}
		
		private function maybeSwitchState():void {
			
			onOffTimer+=FlxG.elapsed;
			if (onOffTimer >= onOffPeriod) {
				if (Math.random() > 0.78) {
					if (isOn) {playTurnOff();}
					else {playTurnOn();}
				}
				resetOnOff();
			}
		}
		
		private function maybeChangeScaleFactor():void {
			var $rand:Number = Math.random();
			if ($rand < 0.5) {return;}
			changeScaleFactor($rand);
		}
		
		private function changeScaleFactor($rand:Number):void {
			scaleFactor = $rand*0.11 + 1.44;
		}
		
		private function fadeSlowly():void {
			scaleFactor -= 0.00022;
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			anims.postUpdate();
			illumination.postUpdate();
		}
		
		private function resetBrightness():void {
			brightnessTimer = 0;
			brightnessPeriod = Math.random()*5 + 0.22;
		}
		
		private function resetOnOff():void {
			onOffTimer = 0;
			onOffPeriod = Math.random()*3;
		}
	}
}