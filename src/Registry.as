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
		[Embed("assets/SentientHandTrackA.mp3")] public static const musicBackgroundA:Class;
		[Embed("assets/SentientHandTrackB.mp3")] public static const musicBackgroundB:Class;
		
		public static const levelOrder:Array = new Array(level01, level03);
		public static const soundOrder:Array = new Array(musicBackgroundA,musicBackgroundB);
		public static var music:FlxSound = new FlxSound();
		public static var stupid:Boolean = true;
		public static var dumb:Boolean = false;
		
		//public static var firstButton:Array = new Array();
		//public static var secondButton:Array = new Array();
		
		//public static var iteration:uint = 0;
		public static var levelNum:uint = 0;
		public static var levelNumPrevious:uint = levelNum;
		
		// hint system stuff
		public static var neverEnteredBodyOrCannon:Boolean = true;
		public static var neverFiredBodyOrCannon:Boolean = true;
		public static var neverAimedBodyOrCannon:Boolean = true;
		
		public static function update():void {
			
			//FlxG.log(levelNum);
			
			if (stupid && levelNum < soundOrder.length) {
				stupid = false;
				Registry.music.loadEmbedded(Registry.soundOrder[Registry.levelNum],false);
			}
			if (levelNum != levelNumPrevious) {
				dumb = true;
			}
			if (dumb) {
				Registry.music.volume -= 0.0022;
			}
			if (Registry.music.volume == 0 && levelNum < soundOrder.length) {
				dumb = false;
				Registry.music.loadEmbedded(Registry.soundOrder[Registry.levelNum],false);
			}
			if (!dumb && Registry.music.volume != 1) {
				Registry.music.volume += 0.0022;
			}
			
			levelNumPrevious = levelNum;
			
			Registry.music.play();
		}
	}
}