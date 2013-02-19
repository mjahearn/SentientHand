package
{
	import org.flixel.*;
	
	[SWF(width="800", height="600", backgroundColor="#000000")]
	
	public class SentientHand extends FlxGame
	{
		public function SentientHand()
		{
			super(400,300,PlayState,2,60,30,true);
			forceDebugger = true;
		}
	}
}