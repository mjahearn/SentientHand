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
		
		public static var iteration:uint = 0;
		public static var levelNum:uint = 0;
	}
}