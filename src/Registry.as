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
		
		[Embed("assets/Attach_Happy1.mp3")] public static const kAttachHappySFX:Class;
		public static const kAttachHappySound:FlxSound = new FlxSound().loadEmbedded(kAttachHappySFX);
		
		[Embed("assets/Attach_Sad1.mp3")] public static const kAttachSadSFX:Class;
		public static const kAttachSadSound:FlxSound = new FlxSound().loadEmbedded(kAttachSadSFX);
		
		[Embed("assets/Reverse_Polarity1.mp3")] public static const kButtonPressSFX:Class;
		public static const kButtonPressSound:FlxSound = new FlxSound().loadEmbedded(kButtonPressSFX);
		
		[Embed("assets/Jump.mp3")] public static const kJumpSFX:Class;
		public static var kJumpSound:FlxSound = new FlxSound().loadEmbedded(kJumpSFX);
	}
}