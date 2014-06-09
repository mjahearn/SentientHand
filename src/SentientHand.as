package
{

	import flash.events.Event;
	import org.flixel.*;
	
	[SWF(width="450", height="450", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class SentientHand extends FlxGame
	{
		public function SentientHand()
		{
			
			var startClass:Class = (Registry.DEBUG_ON) ? LevelSelect : SplashState;
			
			//super(450,450,startClass,1,60,60,true); // log isn't visible otherwise
			super(640,640,startClass,1,60,60,true);
			
			forceDebugger = Registry.DEBUG_ON;
		}

		override protected function create(FlashEvent:Event):void {
			super.create(FlashEvent);
			stage.removeEventListener(Event.DEACTIVATE,onFocusLost);
			stage.removeEventListener(Event.ACTIVATE,onFocus);
			stage.align = "TOP";
		}
	}
}