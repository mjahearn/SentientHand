package
{
	import org.flixel.FlxSprite;
	
	public class SprButton extends FlxSprite
	{
		public static const kDown:uint = 0;
		public static const kRight:uint = 1;
		public static const kUp:uint = 2;
		public static const kLeft:uint = 4;
		
		private var isPressed:Boolean;
		private var reaction:Function;
		private var isYellow:Boolean;
		
		private const kAnimPress:String = "kAnimPress";
		private const kAnimUnpressRed:String = "kAnimUnpressRed";
		private const kAnimUnpressYellow:String = "kAnimUnpressYellow";
		
		private const kImgW:Number = 32;
		private const kImgH:Number = 8;
		
		public function SprButton(X:Number=0, Y:Number=0)
		{
			super(X, Y, Registry.kHandSheet);
		}
		
		public function set orientation(tmpOrientation:uint):void {
			
			var tmpSimpleGraphic:Class;
			var tmpW:Number;
			var tmpH:Number;
			
			if (tmpOrientation == kDown) {
				tmpSimpleGraphic = Registry.kButtonDSheet;
				tmpW = kImgW;
				tmpH = kImgH;
			}
			else if (tmpOrientation == kRight) {
				tmpSimpleGraphic = Registry.kButtonRSheet;
				tmpW = kImgH;
				tmpH = kImgW;
			}
			else if (tmpOrientation == kUp) {
				tmpSimpleGraphic = Registry.kButtonUSheet;
				tmpW = kImgW;
				tmpH = kImgH;
			}
			else if (tmpOrientation == kLeft) {
				tmpSimpleGraphic = Registry.kButtonLSheet;
				tmpW = kImgH;
				tmpH = kImgW;
			}
			else {
				Registry.log(this+" given incorrect orientation: "+tmpOrientation);
				return;
			}
			
			loadGraphic(tmpSimpleGraphic,true,false,tmpW,tmpH);
			
			addAnimation(kAnimPress,[0]);
			addAnimation(kAnimUnpressRed,[1]);
			addAnimation(kAnimUnpressYellow,[2]);
			
			unpress();
		}
		
		/**
		 * Pressed down button.
		 * Fire reaction
		 */
		public function press():void {
			isPressed = true;
			play(kAnimPress);
			reaction();
		}
		
		public function unpress():void {
			isPressed = false;
			play((isYellow ? kAnimUnpressYellow : kAnimUnpressRed));
		}
		
		public function canBePressed():Boolean {
			return !isPressed;
		}
		
		public function set reactionToPress(tmpCallback:Function):void {
			reaction = tmpCallback;
		}
		
		public function toggleColor():void {
			isYellow = !isYellow;
		}
	}
}