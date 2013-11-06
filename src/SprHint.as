package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class SprHint extends FlxSprite
	{
		protected var _flxText:FlxText;
		
		public function SprHint(X:Number=0,Y:Number=0,msg:String="")
		{
			super(X,Y,Registry.kHintSheet);
			
			initFlxText();
			text = msg;
		}
		
		private function initFlxText():void {
			var tmpBuffer:uint = 4;
			
			_flxText = new FlxText(x,y,width-tmpBuffer*2);
			_flxText.alignment = "center";
			_flxText.color = 0xff8888;
		}
		
		private function parseMsg(msg:String):String {
			
			var parsingKey:Boolean = false;
			const kKeyChar:String = "#";
			
			var retMsg:String = "";
			
			for (var i:uint = 0; i < msg.length; i++) {
				var curChar:String = msg.charAt(i);
				if (curChar == kKeyChar) {
					parsingKey = !parsingKey;
				} else {
					retMsg += curChar;
				}
			}
			return retMsg;
		}
		
		public function get text():String {
			if (!_flxText) {return "";}
			return _flxText.text;
		}
		
		public function set text(msg:String):void {
			if (!msg || !_flxText) {return;}
			_flxText.text = parseMsg(msg);
		}
		
		override public function draw():void {
			super.draw();
			
			var tmpTheta:Number = (angle)*Math.PI/180.0;
			
			_flxText.angle = angle;
			_flxText.x = x + width/2.0 - _flxText.width/2.0;
			_flxText.y = y + height/2.0 - _flxText.height/2.0;
			_flxText.draw();
		}
	}
}