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
		public static var cameraRotates:Boolean = true;
		public static var cameraFollowsHand:Boolean = false; //this means rotationally, FYI- camera follows positionally no matter what
		public static var extendedCamera:Boolean = true;
		public static var jumpSpace:Boolean = false;
		
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
		
		[Embed("assets/spr_hand.png")] public static const kHandSheet:Class;
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
		[Embed("assets/spr_heart.png")] public static const kHeartSheet:Class;
		[Embed("assets/spr_bulb_base.png")] public static const kBulbBaseSheet:Class;
		[Embed("assets/spr_bulb_anim.png")] public static const kBulbAnimSheet:Class;
		[Embed("assets/spr_bulb_illumination.png")] public static const kBulbIlluminationSheet:Class;
		[Embed("assets/spr_bulb_support.png")] public static const kBulbSupportSheet:Class;
		[Embed("assets/spr_exit_sign.png")] public static const kExitSignSheet:Class;
		[Embed("assets/spr_exit_sign_on_c.png")] public static const kExitSignCSheet:Class;
		[Embed("assets/spr_exit_sign_on_l.png")] public static const kExitSignLSheet:Class;
		[Embed("assets/spr_exit_sign_on_r.png")] public static const kExitSignRSheet:Class;
		[Embed("assets/spr_window.png")] public static const kWindowSheet:Class;
		[Embed("assets/spr_window_rain.png")] public static const kWindowRainSheet:Class;
		[Embed("assets/spr_grate.png")] public static const kGrateSheet:Class;
		[Embed("assets/spr_exit_chute.png")] public static const kExitChuteSheet:Class;
		[Embed("assets/spr_exit_chute_in.png")] public static const kExitChuteInSheet:Class;
		[Embed("assets/spr_exit_chute_door.png")] public static const kExitChuteDoorSheet:Class;
		[Embed(source="assets/spr_splash_bkg_detailed-01.png")] public static const kSplashDetailed:Class;
		
		[Embed("assets/Attach_Happy1.mp3")] public static const kAttachHappySFX:Class;
		public static const kAttachHappySound:FlxSound = new FlxSound().loadEmbedded(kAttachHappySFX);
		
		[Embed("assets/Attach_Sad1.mp3")] public static const kAttachSadSFX:Class;
		public static const kAttachSadSound:FlxSound = new FlxSound().loadEmbedded(kAttachSadSFX);
		
		[Embed("assets/Reverse_Polarity1.mp3")] public static const kButtonPressSFX:Class;
		public static const kButtonPressSound:FlxSound = new FlxSound().loadEmbedded(kButtonPressSFX);
		
		[Embed("assets/Jump.mp3")] public static const kJumpSFX:Class;
		public static var kJumpSound:FlxSound = new FlxSound().loadEmbedded(kJumpSFX);
		
		[Embed("assets/Neon Hum 1.mp3")] public static const kNeonHumSFX:Class;
		public static var kNeonHumSound:FlxSound = new FlxSound().loadEmbedded(kNeonHumSFX);
		[Embed("assets/Neon Surge Off 1.mp3")] public static const kNeonSurgeOffSFX:Class;
		public static var kNeonSurgeOffSound:FlxSound = new FlxSound().loadEmbedded(kNeonSurgeOffSFX);
		[Embed("assets/Neon Surge On 1.mp3")] public static const kNeonSurgeOnSFX:Class;
		public static var kNeonSurgeOnSound:FlxSound = new FlxSound().loadEmbedded(kNeonSurgeOnSFX);
		[Embed("assets/Rusty Hatch Close 1.mp3")] public static const kRustyHatchCloseSFX:Class;
		public static var kRustyHatchCloseSound:FlxSound = new FlxSound().loadEmbedded(kRustyHatchCloseSFX);
		[Embed("assets/Rusty Hatch Open 1.mp3")] public static const kRustyHatchOpenSFX:Class;
		public static var kRustyHatchOpenSound:FlxSound = new FlxSound().loadEmbedded(kRustyHatchOpenSFX);
		[Embed("assets/Hatch Open and Close 1.mp3")] public static const kRustyHatchOpenAndCloseSFX:Class;
		public static var kRustyHatchOpenAndCloseSound:FlxSound = new FlxSound().loadEmbedded(kRustyHatchOpenAndCloseSFX);
		
		[Embed("assets/Flourescent Hum1.mp3")] public static const kFluorescentHumSFX:Class;
		public static var kFluorescentHumSound:FlxSound = new FlxSound().loadEmbedded(kFluorescentHumSFX);
		[Embed("assets/Cockroach Skitter1.mp3")] public static const kCockroachSkitterSFX:Class;
		public static var kCockroachSkitterSound:FlxSound = new FlxSound().loadEmbedded(kCockroachSkitterSFX);
		[Embed("assets/Droplet1.mp3")] public static const kDroplet1SFX:Class;
		public static var kDroplet1Sound:FlxSound = new FlxSound().loadEmbedded(kDroplet1SFX);
		[Embed("assets/Droplet2.mp3")] public static const kDroplet2SFX:Class;
		public static var kDroplet2Sound:FlxSound = new FlxSound().loadEmbedded(kDroplet2SFX);
		[Embed("assets/Droplet3.mp3")] public static const kDroplet3SFX:Class;
		public static var kDroplet3Sound:FlxSound = new FlxSound().loadEmbedded(kDroplet3SFX);
		
		[Embed("assets/SplashScreen v1.mp3")] public static const kSplashScreenMus:Class;
		public static var kSplashScreenMusic:FlxSound = new FlxSound().loadEmbedded(kSplashScreenMus,true);
	}
}