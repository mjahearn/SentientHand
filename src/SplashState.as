package
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class SplashState extends FlxState
	{
		public function SplashState()
		{
			super();
		}
		
		override public function create():void {
			var tmpText:FlxText = new FlxText(0,FlxG.height/2.0,FlxG.width,"SPLASH SCREEN");
			tmpText.alignment = "center";
			add(tmpText);
		}
		
		override public function update():void {
			if (FlxG.keys.any()) {
				FlxG.switchState(new PlayState);
			}
		}
	}
}