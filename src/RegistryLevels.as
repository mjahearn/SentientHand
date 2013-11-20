package
{
	import org.flixel.FlxSound;
	import org.flixel.FlxTilemap;
	
	public class RegistryLevels
	{
		// FUNCTIONAL SPAWNS
		public static const kSpawnEmpty:Array = [0,3,4,5,6,7,8,9,10,11,12];
		public static const kSpawnWood:Array = [1];
		public static const kSpawnMetal:Array = [2];
		public static const kSpawnHand:Array = [3];
		public static const kSpawnGrappler:Array = [4];
		public static const kSpawnLauncher:Array = [5];
		//public static const kSpawnButton:Array = [6,7,8,9];
		public static const kSpawnButtonD:Array = [6];
		public static const kSpawnButtonU:Array = [7];
		public static const kSpawnButtonL:Array = [8];
		public static const kSpawnButtonR:Array = [9];
		public static const kSpawnDoor:Array = [10,11];
		public static const kSpawnExitArrow:Array = [12];
		
		// COSMETIC SPAWNS
		public static const kSpawnHintArrowKeys:Array = [293];
		public static const kSpawnDrip:Array = [294];
		public static const kSpawnRoaches:Array = [295];
		
		/**
		 * The current functional tilemap.
		 * Calls <code>currentFuncCSV</code> to determine the specific tilemap to load.
		 */
		public static function lvlFunc():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			map.loadMap(new currentFuncCSV,kTilesFunc,tileWidth,tileHeight);
			return map;
		}
		
		/**
		 * The current cosmetic front tilemap.
		 * Calls <code>currentCosmCSVFront</code> to determine the specific tilemap to load.
		 */
		public static function lvlCosmFront():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			if (currentCosmCSVFront != null) {
				map.loadMap(new currentCosmCSVFront,kTilesCosmFront,tileWidth,tileHeight);
			}
			return map;
		}
		
		/**
		 * The current cosmetic front tilemap.
		 * Calls <code>currentCosmCSVMid</code> to determine the specific tilemap to load.
		 */
		public static function lvlCosmMid():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			if (currentCosmCSVMid != null) {
				map.loadMap(new currentCosmCSVMid,kTilesCosmMid,tileWidth,tileHeight);
			}
			return map;
		}
		
		/**
		 * The current cosmetic front tilemap.
		 * Calls <code>currentCosmCSVBack</code> to determine the specific tilemap to load.
		 */
		public static function lvlCosmBack():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			if (currentCosmCSVBack != null) {
				map.loadMap(new currentCosmCSVBack,kTilesCosmBack,tileWidth,tileHeight);
			}
			return map;
		}
		
		// DIMENSIONS
		private static const tileLength:uint = 8;
		private static const tileWidth:uint = tileLength;
		private static const tileHeight:uint = tileLength;
		
		// FUNCTIONAL TILES
		[Embed("assets/tiles_functional.png")] public static const kTilesFunc:Class;
		// FUNCTIONAL LEVELS
		[Embed("assets/mapCSV_functional_001.csv",mimeType="application/octet-stream")] private static const kFunc001Sheet:Class;
		[Embed("assets/mapCSV_functional_002.csv",mimeType="application/octet-stream")] private static const kFunc002Sheet:Class;
		[Embed("assets/mapCSV_functional_003.csv",mimeType="application/octet-stream")] private static const kFunc003Sheet:Class;
		[Embed("assets/mapCSV_functional_004.csv",mimeType="application/octet-stream")] private static const kFunc004Sheet:Class;
		[Embed("assets/mapCSV_functional_005.csv",mimeType="application/octet-stream")] private static const kFunc005Sheet:Class;
		[Embed("assets/mapCSV_functional_006.csv",mimeType="application/octet-stream")] private static const kFunc006Sheet:Class;
		[Embed("assets/mapCSV_functional_m01.csv",mimeType="application/octet-stream")] private static const kFuncm01Sheet:Class;
		// COSMETIC TILES
		[Embed("assets/level-tiles.png")] public static const kTilesCosmFront:Class;
		[Embed("assets/midground-tiles.png")] public static const kTilesCosmMid:Class;
		[Embed("assets/background-tiles.png")] public static const kTilesCosmBack:Class;
		// COSMETIC LEVELS
		//// FRONT
		[Embed("assets/mapCSV_cosmetic_001_front.csv",mimeType="application/octet-stream")] private static const kCosm001FrontSheet:Class;
		[Embed("assets/mapCSV_cosmetic_002_front.csv",mimeType="application/octet-stream")] private static const kCosm002FrontSheet:Class;
		[Embed("assets/mapCSV_cosmetic_003_front.csv",mimeType="application/octet-stream")] private static const kCosm003FrontSheet:Class;
		[Embed("assets/mapCSV_cosmetic_004_front.csv",mimeType="application/octet-stream")] private static const kCosm004FrontSheet:Class;
		[Embed("assets/mapCSV_cosmetic_005_front.csv",mimeType="application/octet-stream")] private static const kCosm005FrontSheet:Class;
		[Embed("assets/mapCSV_cosmetic_006_front.csv",mimeType="application/octet-stream")] private static const kCosm006FrontSheet:Class;
		//// MID
		[Embed("assets/mapCSV_cosmetic_001_mid.csv",mimeType="application/octet-stream")] private static const kCosm001MidSheet:Class;
		[Embed("assets/mapCSV_cosmetic_002_mid.csv",mimeType="application/octet-stream")] private static const kCosm002MidSheet:Class;
		[Embed("assets/mapCSV_cosmetic_003_mid.csv",mimeType="application/octet-stream")] private static const kCosm003MidSheet:Class;
		[Embed("assets/mapCSV_cosmetic_004_mid.csv",mimeType="application/octet-stream")] private static const kCosm004MidSheet:Class;
		[Embed("assets/mapCSV_cosmetic_005_mid.csv",mimeType="application/octet-stream")] private static const kCosm005MidSheet:Class;
		[Embed("assets/mapCSV_cosmetic_006_mid.csv",mimeType="application/octet-stream")] private static const kCosm006MidSheet:Class;
		//// BACK
		[Embed("assets/mapCSV_cosmetic_001_back.csv",mimeType="application/octet-stream")] private static const kCosm001BackSheet:Class;
		[Embed("assets/mapCSV_cosmetic_002_back.csv",mimeType="application/octet-stream")] private static const kCosm002BackSheet:Class;
		[Embed("assets/mapCSV_cosmetic_003_back.csv",mimeType="application/octet-stream")] private static const kCosm003BackSheet:Class;
		[Embed("assets/mapCSV_cosmetic_004_back.csv",mimeType="application/octet-stream")] private static const kCosm004BackSheet:Class;
		[Embed("assets/mapCSV_cosmetic_005_back.csv",mimeType="application/octet-stream")] private static const kCosm005BackSheet:Class;
		[Embed("assets/mapCSV_cosmetic_006_back.csv",mimeType="application/octet-stream")] private static const kCosm006BackSheet:Class;
		// MUSIC
		// MUSIC
		[Embed("assets/SentientHandTrackA.mp3")] private static const kMusicAFile:Class;
		private static const kMusicA:FlxSound = new FlxSound().loadEmbedded(kMusicAFile,true);
		[Embed("assets/SentientHandTrackB.mp3")] private static const kMusicBFile:Class;
		private static const kMusicB:FlxSound = new FlxSound().loadEmbedded(kMusicBFile,true);
		
		protected static var _num:uint = 0;
		public static function get num():uint {
			return _num;
		}
		public static function set num(setNum:uint):void {
			_num = (setNum < kFuncCsvs.length) ? setNum : kFuncCsvs.length;
		}
		public static function reset():void {
			_num = 0;
		}
		
		private static const kFuncCsvs:Array = [kFunc001Sheet,kFunc002Sheet,kFunc003Sheet,kFunc004Sheet,kFunc005Sheet,kFunc006Sheet, kFuncm01Sheet];
		private static const kCosmCsvsFront:Array = [kCosm001FrontSheet,kCosm002FrontSheet,kCosm003FrontSheet,kCosm004FrontSheet,kCosm005FrontSheet,kCosm006FrontSheet, null];
		private static const kCosmCsvsMid:Array = [kCosm001MidSheet,kCosm002MidSheet,kCosm003MidSheet,kCosm004MidSheet,kCosm005MidSheet,kCosm006MidSheet, null];
		private static const kCosmCsvsBack:Array = [kCosm001BackSheet,kCosm002BackSheet,kCosm003BackSheet,kCosm004BackSheet,kCosm005BackSheet,kCosm006BackSheet, null];
		private static const kMusic:Array = [kMusicA,kMusicA,kMusicB,kMusicB,kMusicB,kMusicA,kMusicA];
		
		// GET CSVS
		private static function get currentFuncCSV():Class {
			return kFuncCsvs[num];
		}
		private static function get currentCosmCSVFront():Class {
			return kCosmCsvsFront[num];
		}
		private static function get currentCosmCSVMid():Class {
			return kCosmCsvsMid[num];
		}
		private static function get currentCosmCSVBack():Class {
			return kCosmCsvsBack[num];
		}
		
		public static function get currentMusic():FlxSound {
			return kMusic[num];
		}
		public static function get previousMusic():FlxSound {
			if (num-1 >= 0) {
				return kMusic[num-1];
			}
			return null;
		}
	}
}