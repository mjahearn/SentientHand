package
{
	import org.flixel.*;
	
	[SWF(width="640", height="640", backgroundColor="#222222")]
	[Frame(factoryClass="Preloader")]
	
	public class SentientHand extends FlxGame
	{
		public function SentientHand()
		{
			
			var startClass:Class = (Registry.DEBUG_ON) ? LevelSelect : SplashState;
			
			super(1000,1000,startClass,0.64,60,60,true);
			
			forceDebugger = Registry.DEBUG_ON;
		}
	}
}