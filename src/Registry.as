package {
	
	import org.flixel.*;
	
	public class Registry {
		
		public static function log(tmpData:Object):void {FlxG.log(tmpData);}
		//[Embed("assets/SentientHandTrackA.mp3")] public static const musicBackgroundA:Class;
		//[Embed("assets/SentientHandTrackB.mp3")] public static const musicBackgroundB:Class;
		
		//public static const soundOrder:Array = new Array(musicBackgroundA,musicBackgroundA,musicBackgroundB,musicBackgroundB,musicBackgroundB,musicBackgroundA);
		public static var music1:FlxSound = new FlxSound();
		public static var music2:FlxSound = new FlxSound();
		public static var musicSwitch:Boolean = true;
		public static var stupid:Boolean = true;
		public static var dumb:Boolean = false;
		public static var cameraFollowsHand:Boolean = false;
		public static var extendedCamera:Boolean = true;
		
		public static const SOUND_ON:Boolean = true;
		public static const DEBUG_ON:Boolean = true;
		
		// hint system stuff
		public static var neverEnteredBodyOrCannon:Boolean = true;
		public static var neverFiredBodyOrCannon:Boolean = true;
		public static var neverAimedBodyOrCannon:Boolean = true;
		public static var neverCrawled:Boolean = true;
		public static var neverJumped:Boolean = true;
		
		public static function music():FlxSound {
			if (musicSwitch) {
				return music1;
			}
			return music2;
		}
		
		public static function update():void {
			//FlxG.log(":: MUSIC PLAYING BROKEN TEMPORARILY ::");
			if (SOUND_ON) {
				/*				
				if (stupid && levelNum < soundOrder.length) {
					stupid = false;
					Registry.music().loadEmbedded(Registry.soundOrder[Registry.levelNum],false);
				}
				if (levelNum != levelNumPrevious && soundOrder[levelNum] != soundOrder[levelNumPrevious]) {
					dumb = true;
					musicSwitch = !musicSwitch;
					Registry.music().loadEmbedded(Registry.soundOrder[Registry.levelNum],false);
				}
				if (dumb) {
					if (musicSwitch) {
						Registry.music2.volume -= 0.0022;
					} else {
						Registry.music1.volume -= 0.0022;
					}
				}
				if (!dumb && Registry.music().volume != 1) {
					if (musicSwitch) {
						Registry.music2.volume += 0.0022;
					} else {
						Registry.music1.volume += 0.0022;
					}
				}
				
				levelNumPrevious = levelNum;
				
				Registry.music().play();
				*/
			}
		}
		
		[Embed("assets/hand.png")] public static const kHandSheet:Class;
		[Embed("assets/spr_keyboard_key.png")] public static const kKeyboardKeySheet:Class;
		[Embed("assets/spr_hint.png")] public static const kHintSheet:Class;
		[Embed("assets/spr_drip.png")] public static const kDripSheet:Class;
		[Embed("assets/spr_roach.png")] public static const kRoachSheet:Class;
		[Embed("assets/button_d.png")] public static const kButtonDSheet:Class;
		[Embed("assets/button_l.png")] public static const kButtonLSheet:Class;
		[Embed("assets/button_u.png")] public static const kButtonUSheet:Class;
		[Embed("assets/button_r.png")] public static const kButtonRSheet:Class;
		[Embed("assets/splash.png")] public static const kSplashSheet:Class;
		[Embed("assets/prompt.png")] public static const kSplashPromptSheet:Class;
		
		[Embed("assets/ButtonPress.mp3")] private static const kButtonPressSFX:Class;
		public static const kButtonPressSound:FlxSound = new FlxSound().loadEmbedded(kButtonPressSFX);
	}
}