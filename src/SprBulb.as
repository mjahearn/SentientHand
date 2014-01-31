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
		
		public function SprBulb(X:Number=0, Y:Number=0)
		{
			isOn = false;
			
			super(X, Y, Registry.kBulbBaseSheet);
			
			anims = new FlxSprite(x,y);
			anims.loadGraphic(Registry.kBulbAnimSheet,true,false,width,height);
			anims.addAnimation(kAnimOn,[1,2,3],10);
			anims.addAnimation(kAnimOff,[0]);
			anims.alpha = 0.33;
			
			playTurnOff();
			
			illumination = new FlxSprite();
			illumination.loadGraphic(Registry.kBulbIlluminationSheet);
			illumination.x = x + width/2.0 - illumination.width/2.0;
			illumination.y = y + height/2.0 - illumination.height/2.0;
		}
		
		public function playTurnOn():void {anims.play(kAnimOn); isOn = true;}
		public function playTurnOff():void {anims.play(kAnimOff); isOn = false;}
		
		override public function draw():void {
			super.draw();
			anims.draw();
			if (illumination.visible) {illumination.draw();}
		}
		
		override public function update():void {
			super.update();
			anims.update();
			illumination.update();
			
			if (isOn) {
				var $scaleFactor:Number = Math.random()%0.11 + 1.44;
				illumination.alpha = (Math.random()%0.1) + $scaleFactor/9.0;
				illumination.scale = new FlxPoint($scaleFactor,$scaleFactor);
			} else {
				illumination.visible = false;
			}
			
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			anims.postUpdate();
			illumination.postUpdate();
		}
	}
}