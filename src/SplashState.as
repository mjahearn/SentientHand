package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class SplashState extends FlxState
	{
		private var title:FlxSprite;
		private var prompt:FlxSprite;
		
		private var timerFade:Number;
		private var timerFadePeriod:Number = 4.4;
		private var timerFadeDir:int = 1;
		
		private var timerMaybeTwitch:Number;
		private var timerMaybeTwitchPeriod:Number = 0.22;
		
		private var kAnimPromptIdle:String = "kAnimPromptIdle";
		private var kAnimPromptInit:String = "kAnimPromptInit";
		
		private const kFadeTime:Number = 1.22; // how long it will take to transition into the game
		
		public function SplashState()
		{
			super();
		}
		
		override public function create():void {
			fixCamera();
			/*var tmpText:FlxText = new FlxText(0,FlxG.height/2.0,FlxG.width,"SPLASH SCREEN");
			tmpText.alignment = "center";
			add(tmpText);*/
			addTitle();
			addPrompt();
			resetTimerFade();
			resetTimerMaybeTwitch();
			addMusic();
		}
		
		private function fixCamera():void {
			FlxG.camera.x = FlxG.width/8;//(FlxG.width * FlxG.camera.zoom)/2;
			FlxG.camera.y = FlxG.height/8;//(FlxG.height * FlxG.camera.zoom)/2;
			FlxG.camera.zoom = 1;
		}
		
		private function addMusic():void {
			add(Registry.kSplashScreenMusic);
			Registry.kSplashScreenMusic.fadeIn(0.22);
		}
		
		private function addTitle():void {
			title = new FlxSprite();
			title.loadGraphic(Registry.kSplashSheet,true,false,640,480);
			title.alpha = 0;
			add(title);
		}
		
		private function addPrompt():void {
			
			prompt = new FlxSprite();
			prompt.loadGraphic(Registry.kSplashPromptSheet,true,false,640,480);
			add(prompt);
			
			prompt.addAnimation(kAnimPromptInit,[0,1,2,3,4,5,6,7,8,9,10,11],22,false);
			prompt.addAnimation(kAnimPromptIdle,[12,13,14],22,true);
			
			prompt.play(kAnimPromptInit);
		}
		
		override public function update():void {
			super.update();
			updateControls();
			updateScene();
		}
		
		private function updateControls():void {
			if (FlxG.keys.any()) {
				//FlxG.switchState(new PlayState);
				begin();
			}
		}
		
		private function updateScene():void {
			timerFade += FlxG.elapsed;
			title.alpha += 0.005*timerFadeDir;
			if (timerFade > timerFadePeriod) {
				semiResetTimerFade();
			}
			
			timerMaybeTwitch += FlxG.elapsed;
			if (timerMaybeTwitch > timerMaybeTwitchPeriod) {
				resetTimerMaybeTwitch();
				title.frame = Math.random()*3;
			}
			
			if (prompt.frame == 11) {
				prompt.play(kAnimPromptIdle);
			}
		}
		
		private function resetTimerFade():void {
			timerFade = 0;
		}
		
		private function semiResetTimerFade():void {
			timerFade = timerFadePeriod/2.0;
			timerFadeDir *= -1;
		}
		
		private function resetTimerMaybeTwitch():void {
			timerMaybeTwitch = 0;
		}
		
		private function begin():void {
			// call after the fade
			var $switchState:Function = function():void {
				FlxG.switchState(new PlayState());
			};
			// we want the music to fade out too
			Registry.kSplashScreenMusic.fadeOut(kFadeTime);
			FlxG.fade(0xff000000,kFadeTime,$switchState);
			
		}
		
	}
}