package
{
	import org.flixel.system.*;
	
	public class Preloader extends FlxPreloader
	{
		public function Preloader():void
		{
			className = "SentientHand";
			super();
			//minDisplayTime = 4; //uncomment this if you want to see it in action when compiling
		}
	}
}