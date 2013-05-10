package {
	
	import org.flixel.*;
	
	public class Registry {
		[Embed("assets/testMap.csv", mimeType = 'application/octet-stream')] public static const testMap:Class;
		[Embed("assets/factory-demo.csv", mimeType = 'application/octet-stream')] public static const factoryDemoMap:Class;
		[Embed("assets/factory-demo-background.csv", mimeType = 'application/octet-stream')] public static const backgroundMap:Class;
		[Embed("assets/factory-demo-midground.csv", mimeType = 'application/octet-stream')] public static const midgroundMap:Class;
		[Embed("assets/tallMap.csv", mimeType = 'application/octet-stream')] public static const tallMap:Class;
		[Embed("assets/tsh_level01.csv", mimeType = 'application/octet-stream')] public static const level01:Class;
		[Embed("assets/tsh_level02.csv", mimeType = 'application/octet-stream')] public static const level02:Class;
		[Embed("assets/tsh_level03.csv", mimeType = 'application/octet-stream')] public static const level03:Class;
		[Embed("assets/tsh_level04.csv", mimeType = 'application/octet-stream')] public static const level04:Class;
		[Embed("assets/tsh_level05.csv", mimeType = 'application/octet-stream')] public static const level05:Class;
		[Embed("assets/SentientHandTrackA.mp3")] public static const musicBackgroundA:Class;
		[Embed("assets/SentientHandTrackB.mp3")] public static const musicBackgroundB:Class;
		
		public static const levelOrder:Array = new Array(level01, level02, level03, level04, level05);
		public static const soundOrder:Array = new Array(musicBackgroundA,musicBackgroundA,musicBackgroundB,musicBackgroundB,musicBackgroundA);
		//public static var music:FlxSound = new FlxSound();
		public static var music1:FlxSound = new FlxSound();
		public static var music2:FlxSound = new FlxSound();
		public static var musicSwitch:Boolean = true;
		public static var stupid:Boolean = true;
		public static var dumb:Boolean = false;
		public static var handRelative:Boolean = true;
		public static var continuityUntilRelease:Boolean = true;
		public static var jumping:Boolean = true;
		
		public static var level:Class;
		public static var midground:Class;
		public static var background:Class;
		
		//public static var firstButton:Array = new Array();
		//public static var secondButton:Array = new Array();
		
		public static const SOUND_ON:Boolean = true;
		public static const DEBUG_ON:Boolean = true;
		
		//public static var iteration:uint = 0;
		public static var levelNum:uint = 0;
		public static var levelNumPrevious:uint = levelNum;
		
		// hint system stuff
		public static var neverEnteredBodyOrCannon:Boolean = true;
		public static var neverFiredBodyOrCannon:Boolean = true;
		public static var neverAimedBodyOrCannon:Boolean = true;
		public static var neverCrawled:Boolean = true;
		
		public static function music():FlxSound {
			if (musicSwitch) {
				return music1;
			}
			return music2;
		}
		
		public static function update():void {
			if (SOUND_ON) {
				
				//FlxG.log(levelNum);
				
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
				/*if (Registry.music().volume == 0 && levelNum < soundOrder.length) {
					dumb = false;
					Registry.music().loadEmbedded(Registry.soundOrder[Registry.levelNum],false);
				}*/
				if (!dumb && Registry.music().volume != 1) {
					if (musicSwitch) {
						Registry.music2.volume += 0.0022;
					} else {
						Registry.music1.volume += 0.0022;
					}
				}
				
				levelNumPrevious = levelNum;
				
				Registry.music().play();
			}
		}
	}
}