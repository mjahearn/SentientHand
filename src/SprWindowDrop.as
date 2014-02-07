package
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	public class SprWindowDrop extends FlxSprite
	{
		private const kAnimDrip:String = "kAnimDrip";
		
		public function SprWindowDrop($x:Number=0, $y:Number=0)
		{
			super($x, $y);
			loadGraphic(Registry.kWindowRainSheet,true,false,8,32);
			addAnimation(kAnimDrip,[0,1,2,3,4,5,6,7,7,7,7,7,7,7,7,7],Math.random()*5+1,false);
			playDrip();
			alpha = Math.random()*0.11;
		}
		
		public function playDrip():void {
			play(kAnimDrip);
		}
		
		public function canBeKilled():Boolean {
			return finished;
		}
		
		override public function update():void {
			super.update();
			alpha -= 0.00022;
		}

	}
}