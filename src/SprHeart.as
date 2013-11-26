package
{
	import org.flixel.FlxSprite;
	
	public class SprHeart extends FlxSprite
	{
		private const kAnimHappy:String = "kAnimHappy";
		private const kAnimSad:String = "kAnimSad";
		private const kHeartMoveDist:Number = 16;
		private const kScaleSmall:Number = 0.22;
		private const kScaleLarge:Number = 1.0;
		private const kScaleIncr:Number = 0.02;
		
		private var hand:SprHand;
		
		public function SprHeart($hand:SprHand)
		{
			super($hand.x, $hand.y);
			loadGraphic(Registry.kHeartSheet,true,false,32,32);
			
			scale.x = kScaleSmall;
			scale.y = kScaleSmall;
			
			hand = $hand;
			
			addAnimation(kAnimHappy,[0,0,0,0,0,0,0,0,0,0],10,false);
			addAnimation(kAnimSad,[0,0,0,0,1,1,1,1,1,1],10,false);
			
			var $animationCallback:Function = function($animationName:String,$frameNumber:uint,$frameIndex:uint):void {
				if (($animationName == kAnimSad || $animationName == kAnimHappy) && finished) {
					kill();
				}
			};
			
			addAnimationCallback($animationCallback);
		}
		
		override public function update():void {
			super.update();
			
			if (scale.x < kScaleLarge && scale.y < kScaleLarge) {
				scale.x += kScaleIncr;
				scale.y += kScaleIncr;
			}
			
			var $dx:Number = (hand.x) - x;
			var $dy:Number = (hand.y - hand.height) - y;
			var $dist:Number = Math.pow($dx,2) + Math.pow($dy,2);
			
			if ($dist == 0 || y < (hand.y - hand.height)) {return;}
			
			x += kHeartMoveDist*$dx/$dist;
			y += kHeartMoveDist*$dy/$dist;
		}
		
		public function makeHappy():void {
			play(kAnimHappy);
		}
		
		public function makeSad():void {
			play(kAnimSad);
		}
	}
}