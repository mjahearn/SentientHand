package
{
	import org.flixel.*;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class SentientHand extends FlxGame
	{
		public function SentientHand()
		{
			super(640,480,LevelSelect,1,60,60,true);
			//super(640,480,PlayState(Registry.levelOrder[Registry.levelNum],Registry.midgroundMap,Registry.backgroundMap),1,60,60,true);
			//super(640,480,PlayState,1,60,60,true);
			if (Registry.DEBUG_ON) {forceDebugger = true;}
		}
	}
}