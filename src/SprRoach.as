package
{
	import org.flixel.*;
	
	public class SprRoach extends FlxSprite
	{
		private const kFearDistSq:Number = Math.pow(128,2);
		private const kMoveAccel:Number = 1600;
		private const kMaxVel:Number = 160;
		
		private const kAnimIdle:String = "kAnimIdle";
		private const kAnimScuttle:String = "kAnimScuttle"
		
		public function SprRoach(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y);
			loadGraphic(Registry.kRoachSheet,true,false,8,8);
			
			addAnimation(kAnimIdle,[Math.random()*2,Math.random()*2,Math.random()*2,Math.random()*2,Math.random()*2,Math.random()*2,Math.random()*2],Math.random()*5 + 3,true);
			play(kAnimIdle);
			addAnimation(kAnimScuttle,[3,4],22,true);
			
			angle = Math.random()*360;
			
			maxVelocity.x = kMaxVel;
			maxVelocity.y = kMaxVel;
		}
		
		public function goAwayFromSprite(tmpSprite:FlxSprite):void {
			if (tooCloseTo(tmpSprite)) {
				angle = 0;
				if (tmpSprite.x < x) {
					acceleration.x = kMoveAccel;
				}
				else if (tmpSprite.x > x) {
					acceleration.x = kMoveAccel;
				}
				
				if (tmpSprite.y < y) {
					acceleration.y = kMoveAccel;
				}
				else if (tmpSprite.y > y) {
					acceleration.y = kMoveAccel;
				}
				
				//angle = Math.atan(velocity.y/velocity.x); something something angle
				
				play(kAnimScuttle);
			}
		}
		
		private function tooCloseTo(tmpSprite:FlxSprite):Boolean {
			var tmpDistSq:Number = Math.pow(tmpSprite.x - x,2) + Math.pow(tmpSprite.y - y,2);
			return (tmpDistSq < kFearDistSq);
		}
	}
}