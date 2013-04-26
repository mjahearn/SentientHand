package
{
	import org.flixel.*;
	
	public class EndState extends FlxState
	{	
		
		override public function create():void {
			var text:FlxText = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"end");
			add(text);
		}
	}
}