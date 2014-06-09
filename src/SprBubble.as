package
{
	import org.flixel.*;
	
	public class SprBubble extends FlxSprite
	{
		private const kAnimIdle:String = "kAnimIdle";
		private const kAnimHideFrameStart:uint = 1;
		private const kAnimHideFrameEnd:uint = 0;
		private const kAnimShowFrameStart:uint = 0;
		private const kAnimShowFrameEnd:uint = 1;
		private const kFrameRate:Number = 1.0/22.0;
		
		private var timer:Number;
		private var isHiding:Boolean;
		private var isShowing:Boolean;
		
		private var label:FlxText;
		
		public function SprBubble($x:Number=0,$y:Number=0) {
			super($x,$y);
			loadGraphic(Registry.kBubble,true,false,64,64);
			addAnimation(kAnimIdle,[0,1,2],10,true);
			timer = 0;
			isShowing = false;
			isHiding = false;
			label = new FlxText(x,y,200);
			label.alignment = "center";
			visible = false;
		}
		
		override public function draw():void {
			if (!visible) {return;}
			super.draw();
			label.draw();
		}
		
		public function set string($string:String):void {
			label.text = $string;
		}
		
		private function idle():void {
			play(kAnimIdle);
		}
		
		public function show():void {
			isShowing = true;
			visible = true;
			frame = kAnimShowFrameStart;
		}
		private function updateShow():void {
			if (!isShowing) {return;}
			frame ++;
			if (frame >= kAnimShowFrameEnd) {
				isShowing = false;
				idle();
			}
		}
		
		public function hide():void {
			isHiding = true;
			frame = kAnimHideFrameStart;
		}
		private function updateHide():void {
			if (!isHiding) {return;}
			frame --;
			if (frame <= kAnimHideFrameEnd) {
				isHiding = false;
				visible = false;
			}
		}
		
		override public function update():void {
			super.update();
			label.x = x + width/2 - label.width/2;
			label.y = y + height/2 - label.height;
			label.update();
			timer += FlxG.elapsed;
			if (timer > kFrameRate) {
				updateHide();
				updateShow();
			}
		}
	}
}