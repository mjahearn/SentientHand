package
{
	import org.flixel.*;
	
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
		
		protected var _isInGrappler:Boolean;
		protected var _isInCannon:Boolean;
		protected var _isLeft:Boolean;
		protected var _isRight:Boolean;
		
		//protected var _heart:FlxSprite;
		
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
			
			//play(kAnimIdleRight); //should it be kAnimFallRight? - Mike
			play(kAnimFallRight);
			maxVelocity = kMaxVel;
			drag = kDrag;
			
			/*
			_heart = new FlxSprite().loadGraphic(Registry.kHeartSheet,true,false,32,32);
			hideHeart();
			*/
			
			_isInGrappler = false;
			_isInCannon = false;
		}
		
		/*
		private function hideHeart():void {
			_heart.visible = false;
		}
		
		private function showHeart():void {
			_heart.visible = true;
		}
		
		override public function draw():void {
			super.draw();
			if (_heart.visible) {
				_heart.x = x;
				_heart.y = y;
				_heart.draw();
			}
		}
		*/
		
		override public function update():void {
			super.update();
			
			if (_isInGrappler) {
				
			}
			else {
				
			}
			
			_isLeft = false;
			_isRight = false;
		}
		
		public function attachToGrappler():void {
			// any stuff we want here, like sfx etc
			_isInGrappler = true;
		}
		
		public function detachFromGrappler():void {
			// sfx etc
			_isInGrappler = false;
		}
		
		public function attachToCannon():void {
			// sfx etc
			_isInCannon = true;
		}
		
		public function detachFromCannon():void {
			// sfx etc
			_isInCannon = false;
		}
		
		public function moveLeft():void {
			_isLeft = true;
		}
		
		public function moveRight():void {
			_isRight = true;
		}
		
		public function isAttachedToGrappler():Boolean {
			return _isInGrappler;
		}
		
		public function isAttachedToCannon():Boolean {
			return _isInCannon;
		}
		
		public function isAttachedToBody():Boolean {
			return _isInGrappler || _isInCannon;
		}
	}
}