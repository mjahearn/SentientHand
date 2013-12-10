package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class SprHint extends FlxSprite
	{
		protected var _flxText:FlxText;
		protected var _flxTextXLocal:Number;
		protected var _flxTextYLocal:Number;
		
		public function SprHint(X:Number=0,Y:Number=0,msg:String="")
		{
			super(X,Y,Registry.kHintSheet);
			
			initFlxText();
			text = msg;
		}
		
		private function initFlxText():void {
			
			var $xBuffer:uint = 14;
			var $yBuffer:int = -14;
			
			_flxText = new FlxText(0,0,width-$xBuffer*2);
			_flxText.size = 11;
			_flxText.alignment = "center";
			_flxText.color = 0x221c1c;
			_flxText.x += width/2.0 - _flxText.width/2.0;
			_flxText.y += height/2.0 - _flxText.height/2.0 + $yBuffer;
			_flxTextXLocal = _flxText.x;
			_flxTextYLocal = _flxText.y;
			_flxText.shadow = 0x000000;
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
			
			var $theta:Number = -(angle)*Math.PI/180.0;
			
			_flxText.angle = angle;
			_flxText.x = x + _flxTextXLocal;//+ _flxTextXLocal*Math.cos($theta) + _flxTextYLocal*Math.sin($theta);
			_flxText.y = y + _flxTextYLocal; //- _flxTextXLocal*Math.sin($theta) + _flxTextYLocal*Math.cos($theta);
			_flxText.draw();
		}
	}
}