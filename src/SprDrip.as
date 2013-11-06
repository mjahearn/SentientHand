package
{
	import org.flixel.*;
	
	public class SprDrip extends FlxSprite
	{
		private const kGravVelMax:Number = 400; //terminal velocity (in pixels per second) when the hand is falling
		private const kGravAccel:Number = 1600; //acceleration (in pixels per second per second) due to gravity
		
		private const kKillFrame:uint = 5;
		
		private const kAnimIdle:String = "kAnimIdle";
		private const kAnimBounce:String = "kAnimBounce";
		
		public function SprDrip(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y);
			loadGraphic(Registry.kDripSheet,true,false,8,8);
			
			addAnimation(kAnimIdle,[0]);
			addAnimation(kAnimBounce,[1,2,3,4,kKillFrame],22,false);
			
			play(kAnimIdle);
			
			acceleration.y = kGravAccel;
			maxVelocity.y = kGravVelMax;
		}
		
		override public function update():void {
			super.update();
			if (isTouching(FlxObject.DOWN)) {
				acceleration.y = 0;
				velocity.y = 0;
				bounce();
			}
			
			if (frame == kKillFrame) {
				kill();
			}
		}
		
		private function bounce():void {
			play(kAnimBounce);
		}
	}
}