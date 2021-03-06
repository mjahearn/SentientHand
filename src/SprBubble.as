package
{
	import org.flixel.*;
	
	public class SprBubble extends FlxSprite
	{
		private const kAnimIdle:String = "kAnimIdle";
		private const kAnimHideFrameStart:uint = 7;
		private const kAnimHideFrameEnd:uint = 4;
		private const kAnimShowFrameStart:uint = 4;
		private const kAnimShowFrameEnd:uint = 7;
		private const kFrameRate:Number = 1.0/15.0;
		
		private var timer:Number;
		private var isHiding:Boolean;
		private var isShowing:Boolean;
		
		private var label:FlxText;
		
		public function SprBubble($x:Number=0,$y:Number=0) {
			super($x,$y);
			loadGraphic(Registry.kBubble,true,false,128,128);
			addAnimation(kAnimIdle,[0,1,2],10,true);
			timer = 0;
			isShowing = false;
			isHiding = false;
			label = new FlxText(x,y,200);
			label.alignment = "center";
			visible = false;
			alpha = 0.75;
			label.font = "Capture it";
			label.size = 14;
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
			if (isShowing || visible) {return;}
			isShowing = true;
			visible = true;
			frame = kAnimShowFrameStart;
		}
		private function updateShow():void {
			if (!isShowing) {return;}
			FlxG.log("show1 " + frame);
			frame ++;
			if (frame >= kAnimShowFrameEnd) {
				isShowing = false;
				idle();
			}
			FlxG.log("show2 " + frame);
		}
		
		public function hide():void {
			//visible = false; return;
			//if (!visible) {return;}
			if (isHiding || !visible) {return;}
			isShowing = false;
			isHiding = true;
			FlxG.log("hideB " + frame);
			frame = kAnimHideFrameStart;
			FlxG.log("hideA " + frame);
		}
		private function updateHide():void {
			if (!isHiding) {return;}
			FlxG.log("hide1 " + frame);
			frame --;
			if (frame <= kAnimHideFrameEnd) {
				isHiding = false;
				visible = false;
				FlxG.log("got here");
			}
			FlxG.log("hide2 " + frame);
		}
		
		override public function update():void {
			super.update();
			label.x = x + width/2 - label.width/2;
			label.y = y + height*0.5 - label.height*0.85;
			label.update();
			timer += FlxG.elapsed;
			if (timer > kFrameRate) {
				updateShow();
				updateHide();
				timer = 0;
			}
		}
	}
}