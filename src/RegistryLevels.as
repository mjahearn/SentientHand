package
{
	import org.flixel.FlxTilemap;
	
	public class RegistryLevels
	{
		// FUNCTIONAL SPAWNS
		public static const kSpawnEmpty:Array = [0];
		public static const kSpawnWood:Array = [1];
		public static const kSpawnMetal:Array = [2];
		public static const kSpawnHand:Array = [3];
		public static const kSpawnGrappler:Array = [4];
		public static const kSpawnLauncher:Array = [5];
		public static const kSpawnButton:Array = [6,7,8,9];
		public static const kSpawnDoor:Array = [10,11];
		public static const kSpawnExitArrow:Array = [12];
		
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
			map.loadMap(new currentCosmCSVFront,kTilesCosmFront,tileWidth,tileHeight);
			return map;
		}
		
		/**
		 * The current cosmetic front tilemap.
		 * Calls <code>currentCosmCSVMid</code> to determine the specific tilemap to load.
		 */
		public static function lvlCosmMid():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			map.loadMap(new currentCosmCSVMid,kTilesCosmMid,tileWidth,tileHeight);
			return map;
		}
		
		/**
		 * The current cosmetic front tilemap.
		 * Calls <code>currentCosmCSVBack</code> to determine the specific tilemap to load.
		 */
		public static function lvlCosmBack():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			map.loadMap(new currentCosmCSVBack,kTilesCosmBack,tileWidth,tileHeight);
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
		
		protected static var _num:uint = 0;
		public static function get num():uint {
			return _num;
		}
		public static function set num(setNum:uint):void {
			_num = (setNum < funcCsvs.length) ? setNum : funcCsvs.length;
		}
		public static function reset():void {
			_num = 0;
		}
		
		private static const funcCsvs:Array = [kFunc001Sheet,kFunc002Sheet,kFunc003Sheet,kFunc004Sheet,kFunc005Sheet,kFunc006Sheet];
		private static const cosmCsvsFront:Array = [kCosm001FrontSheet,kCosm002FrontSheet,kCosm003FrontSheet,kCosm004FrontSheet,kCosm005FrontSheet,kCosm006FrontSheet];
		private static const cosmCsvsMid:Array = [kCosm001MidSheet,kCosm002MidSheet,kCosm003MidSheet,kCosm004MidSheet,kCosm005MidSheet,kCosm006MidSheet];
		private static const cosmCsvsBack:Array = [kCosm001BackSheet,kCosm002BackSheet,kCosm003BackSheet,kCosm004BackSheet,kCosm005BackSheet,kCosm006BackSheet];
		
		// GET CSVS
		private static function get currentFuncCSV():Class {
			return funcCsvs[num];
		}
		private static function get currentCosmCSVFront():Class {
			return cosmCsvsFront[num];
		}
		private static function get currentCosmCSVMid():Class {
			return cosmCsvsMid[num];
		}
		private static function get currentCosmCSVBack():Class {
			return cosmCsvsBack[num];
		}
	}
}