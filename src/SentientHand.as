package
{
	import org.flixel.*;
	
	[SWF(width="640", height="640", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class SentientHand extends FlxGame
	{
		public function SentientHand()
		{
			
			var startClass:Class;
			if (Registry.DEBUG_ON) {
				startClass = LevelSelect;
			} else {
				startClass = PlayState;
			}
			
			super(640,640,startClass,1,60,60,true);
			
			//if (Registry.DEBUG_ON) {
				forceDebugger = true;
			//}
		}
	}
}