package
{
	import org.flixel.*;
	
	public class SprRoach extends FlxSprite
	{
		private const kFearDistSq:Number = Math.pow(128,2);
		private const kMoveAccel:Number = 1600;
		private const kMaxVel:Number = 160;
		
		public function SprRoach(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, Registry.kRoachSheet);
			
			maxVelocity.x = kMaxVel;
			maxVelocity.y = kMaxVel;
		}
		
		public function goAwayFromSprite(tmpSprite:FlxSprite):void {
			if (tooCloseTo(tmpSprite)) {
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
			}
		}
		
		private function tooCloseTo(tmpSprite:FlxSprite):Boolean {
			var tmpDistSq:Number = Math.pow(tmpSprite.x - x,2) + Math.pow(tmpSprite.y - y,2);
			return (tmpDistSq < kFearDistSq);
		}
	}
}