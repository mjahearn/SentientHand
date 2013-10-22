package
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class SprHand extends FlxSprite
	{
		private const kMaxVel:FlxPoint = new FlxPoint(200,200);
		private const kDrag:FlxPoint = new FlxPoint(1600,1600);
		
		public static const kAnimCrawlRight:String = "crawl right";
		public static const kAnimIdleRight:String = "idle right";
		public static const kAnimCrawlLeft:String = "crawl left";
		public static const kAnimIdleLeft:String = "idle left";
		public static const kAnimIdleBodyRight:String = "idle body right";
		public static const kAnimIdleBodyLeft:String = "idle body left";
		public static const kAnimFallRight:String = "fall right";
		public static const kAnimFallLeft:String = "fall left";
		public static const kAnimExtendRight:String = "extend right";
		public static const kAnimExtendLeft:String = "extend left";
		
		public function SprHand(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y);
			loadGraphic(Registry.kHandSheet,true,false,32,32,true);
			
			addAnimation(kAnimCrawlRight,[0,1,2,3,4,5,6],22,true);
			addAnimation(kAnimIdleRight,[7,7,7,7,7,7,7,8,9,9,9,9,9,9,8],10,true);
			addAnimation(kAnimCrawlLeft,[20,19,18,17,16,15,14],22,true);
			addAnimation(kAnimIdleLeft, [13,13,13,13,13,13,13,12,11,11,11,11,11,11,12],10,true);
			addAnimation(kAnimIdleBodyRight, [21,21,21,21,21,21,21,22,23,23,23,23,23,23,22],10,true);
			addAnimation(kAnimIdleBodyLeft, [25,25,25,25,25,25,25,26,27,27,27,27,27,27,26],10,true);
			addAnimation(kAnimFallRight,[29]);
			addAnimation(kAnimFallLeft,[33]);
			addAnimation(kAnimExtendRight,[35,36],22,false);
			addAnimation(kAnimExtendLeft,[40,41],22,false);
			
			play(kAnimIdleRight); //should it be kAnimFallRight? - Mike
			maxVelocity = kMaxVel;
			drag = kDrag;
		}
	}
}