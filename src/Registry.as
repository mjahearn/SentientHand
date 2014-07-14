package {
	
	import org.flixel.*;
	
	public class Registry {
		
		public static function log(tmpData:Object):void {FlxG.log(tmpData);}

		public static var cameraRotates:Boolean = true;
		public static var cameraFollowsHand:Boolean = false; //this means rotationally, FYI- camera follows positionally no matter what
		public static var extendedCamera:Boolean = true;
		public static var jumpSpace:Boolean = false;
		public static var cameraTurnRate:Number = 32.0;
		
		public static const SOUND_ON:Boolean = false;
		public static const DEBUG_ON:Boolean = true;
		
		// hint system stuff
		public static var neverEnteredBodyOrCannon:Boolean = true;
		public static var neverFiredBodyOrCannon:Boolean = true;
		public static var neverAimedBodyOrCannon:Boolean = true;
		public static var neverCrawled:Boolean = true;
		public static var neverJumped:Boolean = true;
		
		[Embed("assets/sprites/spr_hand.png")] public static const kHandSheet:Class;
		[Embed("assets/sprites/spr_keyboard_key.png")] public static const kKeyboardKeySheet:Class;
		[Embed("assets/sprites/spr_hint.png")] public static const kHintSheet:Class;
		[Embed("assets/sprites/spr_drip.png")] public static const kDripSheet:Class;
		[Embed("assets/sprites/spr_roach.png")] public static const kRoachSheet:Class;
		[Embed("assets/sprites/button_d.png")] public static const kButtonDSheet:Class;
		[Embed("assets/sprites/button_l.png")] public static const kButtonLSheet:Class;
		[Embed("assets/sprites/button_u.png")] public static const kButtonUSheet:Class;
		[Embed("assets/sprites/button_r.png")] public static const kButtonRSheet:Class;
		//[Embed("assets/splash.png")] public static const kSplashSheet:Class;
		//[Embed("assets/prompt.png")] public static const kSplashPromptSheet:Class;
		[Embed("assets/sprites/spr_heart.png")] public static const kHeartSheet:Class;
		[Embed("assets/sprites/spr_bulb_base.png")] public static const kBulbBaseSheet:Class;
		[Embed("assets/sprites/spr_bulb_anim.png")] public static const kBulbAnimSheet:Class;
		[Embed("assets/sprites/spr_bulb_illumination.png")] public static const kBulbIlluminationSheet:Class;
		[Embed("assets/sprites/spr_bulb_support.png")] public static const kBulbSupportSheet:Class;
		[Embed("assets/sprites/spr_exit_sign.png")] public static const kExitSignSheet:Class;
		[Embed("assets/sprites/spr_exit_sign_on_c.png")] public static const kExitSignCSheet:Class;
		[Embed("assets/sprites/spr_exit_sign_on_l.png")] public static const kExitSignLSheet:Class;
		[Embed("assets/sprites/spr_exit_sign_on_r.png")] public static const kExitSignRSheet:Class;
		[Embed("assets/sprites/spr_window.png")] public static const kWindowSheet:Class;
		[Embed("assets/sprites/spr_window_rain.png")] public static const kWindowRainSheet:Class;
		[Embed("assets/sprites/spr_grate.png")] public static const kGrateSheet:Class;
		[Embed("assets/sprites/spr_exit_chute.png")] public static const kExitChuteSheet:Class;
		[Embed("assets/sprites/spr_exit_chute_in.png")] public static const kExitChuteInSheet:Class;
		[Embed("assets/sprites/spr_exit_chute_door.png")] public static const kExitChuteDoorSheet:Class;
		[Embed("assets/sprites/spr_arrow.png")] public static const kGravityArrow:Class;
		//[Embed("assets/spr_splash_bkg_detailed-01.png")] public static const kSplashDetailed:Class;
		[Embed("assets/sprites/spr_thought.png")] public static const kBubble:Class;
		
		[Embed("assets/audio/Attach_Happy1.mp3")] public static const kAttachHappySFX:Class;
		public static const kAttachHappySound:FlxSound = new FlxSound().loadEmbedded(kAttachHappySFX);
		
		[Embed("assets/audio/Attach_Sad1.mp3")] public static const kAttachSadSFX:Class;
		public static const kAttachSadSound:FlxSound = new FlxSound().loadEmbedded(kAttachSadSFX);
		
		[Embed("assets/audio/Reverse_Polarity1.mp3")] public static const kButtonPressSFX:Class;
		public static const kButtonPressSound:FlxSound = new FlxSound().loadEmbedded(kButtonPressSFX);
		
		[Embed("assets/audio/Jump.mp3")] public static const kJumpSFX:Class;
		public static var kJumpSound:FlxSound = new FlxSound().loadEmbedded(kJumpSFX);
		
		[Embed("assets/audio/Neon Hum 1.mp3")] public static const kNeonHumSFX:Class;
		public static var kNeonHumSound:FlxSound = new FlxSound().loadEmbedded(kNeonHumSFX);
		[Embed("assets/audio/Neon Surge Off 1.mp3")] public static const kNeonSurgeOffSFX:Class;
		public static var kNeonSurgeOffSound:FlxSound = new FlxSound().loadEmbedded(kNeonSurgeOffSFX);
		[Embed("assets/audio/Neon Surge On 1.mp3")] public static const kNeonSurgeOnSFX:Class;
		public static var kNeonSurgeOnSound:FlxSound = new FlxSound().loadEmbedded(kNeonSurgeOnSFX);
		[Embed("assets/audio/Rusty Hatch Close 1.mp3")] public static const kRustyHatchCloseSFX:Class;
		public static var kRustyHatchCloseSound:FlxSound = new FlxSound().loadEmbedded(kRustyHatchCloseSFX);
		[Embed("assets/audio/Rusty Hatch Open 1.mp3")] public static const kRustyHatchOpenSFX:Class;
		public static var kRustyHatchOpenSound:FlxSound = new FlxSound().loadEmbedded(kRustyHatchOpenSFX);
		[Embed("assets/audio/Hatch Open and Close 1.mp3")] public static const kRustyHatchOpenAndCloseSFX:Class;
		public static var kRustyHatchOpenAndCloseSound:FlxSound = new FlxSound().loadEmbedded(kRustyHatchOpenAndCloseSFX);
		
		[Embed("assets/audio/Flourescent Hum1.mp3")] public static const kFluorescentHumSFX:Class;
		public static var kFluorescentHumSound:FlxSound = new FlxSound().loadEmbedded(kFluorescentHumSFX);
		[Embed("assets/audio/Cockroach Skitter1.mp3")] public static const kCockroachSkitterSFX:Class;
		public static var kCockroachSkitterSound:FlxSound = new FlxSound().loadEmbedded(kCockroachSkitterSFX);
		[Embed("assets/audio/Droplet1.mp3")] public static const kDroplet1SFX:Class;
		public static var kDroplet1Sound:FlxSound = new FlxSound().loadEmbedded(kDroplet1SFX);
		[Embed("assets/audio/Droplet2.mp3")] public static const kDroplet2SFX:Class;
		public static var kDroplet2Sound:FlxSound = new FlxSound().loadEmbedded(kDroplet2SFX);
		[Embed("assets/audio/Droplet3.mp3")] public static const kDroplet3SFX:Class;
		public static var kDroplet3Sound:FlxSound = new FlxSound().loadEmbedded(kDroplet3SFX);
		
		[Embed("assets/audio/SplashScreen v1.mp3")] public static const kSplashScreenMus:Class;
		public static var kSplashScreenMusic:FlxSound = new FlxSound().loadEmbedded(kSplashScreenMus,true);
		
		[Embed(source="assets/misc/font.ttf",fontName="Capture it",embedAsCFF="false",mimeType="application/x-font")] private const kFont:Class;
	}
}