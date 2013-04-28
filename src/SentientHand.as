package
{
	import org.flixel.*;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class SentientHand extends FlxGame
	{
		public function SentientHand()
		{
			
			var startClass:Class;
			if (Registry.DEBUG_ON) {
				startClass = LevelSelect;
				forceDebugger = true;
			} else {
				startClass = PlayState;
				forceDebugger = false;
			}
			super(640,480,startClass,1,60,60,true);
			//if (Registry.DEBUG_ON) {forceDebugger = true;}
		}
	}
}