package
{
	import org.flixel.FlxSound;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	
	public class RegistryLevels
	{
		// FUNCTIONAL SPAWNS
		public static const kSpawnEmpty:Array = [0,3,4,5,6,7,8,9,10,11,12,14];
		public static const kSpawnWood:Array = [1];
		public static const kSpawnMetal:Array = [2];
		public static const kSpawnNeutral:Array = [13];
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
		public static const kSpawnExit:Array = [14];
		public static const kSpawnHintLeftRight:Array = [15];
		public static const kSpawnHintJump:Array = [16];
		public static const kSpawnHintAttachDetach:Array = [17];
		
		// COSMETIC SPAWNS
		public static const kSpawnHintArrowKeys:Array = [293]; // update this
		public static const kSpawnDrip:Array = [304,305];//[45,77];
		public static const kSpawnRoaches:Array = [295]; // update this
		
		public static const kSpawnMidHint0:Array = [48];
		public static const kSpawnMidHint1:Array = [49];
		public static const kSpawnMidHint2:Array = [50];
		public static const kSpawnMidHint3:Array = [51];
		public static const kSpawnMidHint4:Array = [52];
		public static const kSpawnMidHint5:Array = [53];
		public static const kSpawnMidHint6:Array = [54];
		public static const kSpawnMidHint7:Array = [55];
		
		public static const kSpawnSemiBackBulb:Array = [1];
		
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
		 * The current cosmetic mid tilemap.
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
		 * The current cosmetic back tilemap.
		 * Calls <code>currentCosmCSVBack</code> to determine the specific tilemap to load.
		 */
		public static function lvlCosmBack():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			if (currentCosmCSVBack != null) {
				map.loadMap(new currentCosmCSVBack,kTilesCosmBack,tileWidth,tileHeight);
			}
			return map;
		}
		
		/**
		 * The current cosmetic back back tilemap.
		 * Calls <code>currentCosmCSVBackBack</code> to determine the specific tilemap to load.
		 */
		public static function lvlCosmBackBack():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			if (currentCosmCSVBackBack != null) {
				map.loadMap(new currentCosmCSVBackBack,kTilesCosmBackBack,tileWidth,tileHeight);
			}
			return map;
		}
		
		/**
		 * The current cosmetic semi back tilemap.
		 * Calls <code>currentCosmCSVSemiBack</code> to determine the specific tilemap to load.
		 */
		public static function lvlCosmSemiBack():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			if (currentCosmCSVSemiBack != null) {
				map.loadMap(new currentCosmCSVSemiBack,kTilesCosmSemiBack,tileWidth,tileHeight);
			}
			return map;
		}
		
		// DIMENSIONS
		private static const tileLength:uint = 8;
		private static const tileWidth:uint = tileLength;
		private static const tileHeight:uint = tileLength;
		
		// FUNCTIONAL TILES
		[Embed("assets/level_creation/tiles_functional.png")] public static const kTilesFunc:Class;
		// FUNCTIONAL LEVELS
		[Embed("assets/level_csvs/mapCSV_functional_tutorial1.csv",mimeType="application/octet-stream")] private static const kFunct01Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_tutorial2.csv",mimeType="application/octet-stream")] private static const kFunct02Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_tutorial2.5.csv",mimeType="application/octet-stream")] private static const kFunct02_5Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_tutorial3.csv",mimeType="application/octet-stream")] private static const kFunct03Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_tutorial4.csv",mimeType="application/octet-stream")] private static const kFunct04Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_tutorial5.csv",mimeType="application/octet-stream")] private static const kFunct05_Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_cannon1.csv",mimeType="application/octet-stream")] private static const kFuncb01Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_plain1.csv",mimeType="application/octet-stream")] private static const kFuncb02Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_grapple1.csv",mimeType="application/octet-stream")] private static const kFuncb03Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_cannon2.csv",mimeType="application/octet-stream")] private static const kFuncb04Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_grapple2.csv",mimeType="application/octet-stream")] private static const kFuncb05Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_Map11.csv",mimeType="application/octet-stream")] private static const kFuncb06Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_Map12.csv",mimeType="application/octet-stream")] private static const kFuncb07Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_Map13.csv",mimeType="application/octet-stream")] private static const kFuncb08Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_Map14.csv",mimeType="application/octet-stream")] private static const kFuncb09Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_001.csv",mimeType="application/octet-stream")] private static const kFunc001Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_006.csv",mimeType="application/octet-stream")] private static const kFunc006Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_m01.csv",mimeType="application/octet-stream")] private static const kFuncm01Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_m02.csv",mimeType="application/octet-stream")] private static const kFuncm02Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_m03.csv",mimeType="application/octet-stream")] private static const kFuncm03Sheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_combo1.csv",mimeType="application/octet-stream")] private static const kFuncbComboSheet:Class;
		[Embed("assets/level_csvs/mapCSV_functional_grapple3.csv",mimeType="application/octet-stream")] private static const kFuncGrapple3Sheet:Class;
		// COSMETIC TILES
		[Embed("assets/level_creation/tiles_cosmetic_front.png")] public static const kTilesCosmFront:Class;
		[Embed("assets/level_creation/tiles_cosmetic_mid.png")] public static const kTilesCosmMid:Class;
		[Embed("assets/level_creation/tiles_cosmetic_back.png")] public static const kTilesCosmBack:Class;
		[Embed("assets/level_creation/tiles_cosmetic_back_back.png")] public static const kTilesCosmBackBack:Class;
		[Embed("assets/level_creation/tiles_cosmetic_semi_back.png")] public static const kTilesCosmSemiBack:Class;
		// COSMETIC LEVELS
		//// FRONT
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_tutorial1.csv",mimeType="application/octet-stream")] private static const kCosm001FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_tutorial2.csv",mimeType="application/octet-stream")] private static const kCosm002FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_tutorial2.5.csv",mimeType="application/octet-stream")] private static const kCosm002_5FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_tutorial3.csv",mimeType="application/octet-stream")] private static const kCosm003FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_tutorial4.csv",mimeType="application/octet-stream")] private static const kCosm004FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_tutorial5.csv",mimeType="application/octet-stream")] private static const kCosm005_FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_cannon1.csv",mimeType="application/octet-stream")] private static const kCosm005FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_plain1.csv",mimeType="application/octet-stream")] private static const kCosm006FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_grapple1.csv",mimeType="application/octet-stream")] private static const kCosm007FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_cannon2.csv",mimeType="application/octet-stream")] private static const kCosm008FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_grapple2.csv",mimeType="application/octet-stream")] private static const kCosm009FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_Map10.csv",mimeType="application/octet-stream")] private static const kCosmNOT010FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_Map11.csv",mimeType="application/octet-stream")] private static const kCosm010FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_Map12.csv",mimeType="application/octet-stream")] private static const kCosm012FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_Map13.csv",mimeType="application/octet-stream")] private static const kCosm013FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_m01_front.csv",mimeType="application/octet-stream")] private static const kCosmm01FrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_Map13.csv",mimeType="application/octet-stream")] private static const kCosmComboFrontSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_front_grapple3.csv",mimeType="application/octet-stream")] private static const kCosmGrapple3FrontSheet:Class;

		//// MID
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_tutorial1.csv",mimeType="application/octet-stream")] private static const kCosm001MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_tutorial2.csv",mimeType="application/octet-stream")] private static const kCosm002MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_tutorial3.csv",mimeType="application/octet-stream")] private static const kCosm003MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_tutorial4.csv",mimeType="application/octet-stream")] private static const kCosm004MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_tutorial2.5.csv",mimeType="application/octet-stream")] private static const kCosm002_5MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_tutorial5.csv",mimeType="application/octet-stream")] private static const kCosm005_MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_cannon1.csv",mimeType="application/octet-stream")] private static const kCosm005MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_plain1.csv",mimeType="application/octet-stream")] private static const kCosm006MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_grapple1.csv",mimeType="application/octet-stream")] private static const kCosm007MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_cannon2.csv",mimeType="application/octet-stream")] private static const kCosm008MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_grapple2.csv",mimeType="application/octet-stream")] private static const kCosm009MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_m01_mid.csv",mimeType="application/octet-stream")] private static const kCosmm01MidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_Map13.csv",mimeType="application/octet-stream")] private static const kCosmComboMidSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_mid_grapple3.csv",mimeType="application/octet-stream")] private static const kCosmGrapple3MidSheet:Class;

		//// Semi Back
		[Embed("assets/level_csvs/mapCSV_cosmetic_semi_back_tutorial1.csv",mimeType="application/octet-stream")] private static const kCosm001SemiBackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_semi_back_tutorial2.csv",mimeType="application/octet-stream")] private static const kCosm002SemiBackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_semi_back_tutorial3.csv",mimeType="application/octet-stream")] private static const kCosm003SemiBackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_semi_back_tutorial4.csv",mimeType="application/octet-stream")] private static const kCosm004SemiBackSheet:Class;
		//// BACK
		[Embed("assets/level_csvs/mapCSV_cosmetic_back_back_tutorial1.csv",mimeType="application/octet-stream")] private static const kCosm001BackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_back_tutorial2.csv",mimeType="application/octet-stream")] private static const kCosm002BackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_back_tutorial3.csv",mimeType="application/octet-stream")] private static const kCosm003BackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_back_tutorial4.csv",mimeType="application/octet-stream")] private static const kCosm004BackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_005_back.csv",mimeType="application/octet-stream")] private static const kCosm005BackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_006_back.csv",mimeType="application/octet-stream")] private static const kCosm006BackSheet:Class;
		//// BACK BACK
		[Embed("assets/level_csvs/mapCSV_cosmetic_back_back_tutorial1.csv",mimeType="application/octet-stream")] private static const kCosm001BackBackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_back_back_tutorial2.csv",mimeType="application/octet-stream")] private static const kCosm002BackBackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_back_back_tutorial3.csv",mimeType="application/octet-stream")] private static const kCosm003BackBackSheet:Class;
		[Embed("assets/level_csvs/mapCSV_cosmetic_back_back_tutorial4.csv",mimeType="application/octet-stream")] private static const kCosm004BackBackSheet:Class;

		
		// MUSIC
		[Embed("assets/audio/SentientHandTrackA.mp3")] private static const kMusicAFile:Class;
		private static const kMusicA:FlxSound = new FlxSound().loadEmbedded(kMusicAFile,true);
		[Embed("assets/audio/SentientHandTrackB.mp3")] private static const kMusicBFile:Class;
		private static const kMusicB:FlxSound = new FlxSound().loadEmbedded(kMusicBFile,true);
		
		[Embed("assets/audio/SentientHandTrackA_Rev5_Overlay.mp3")] private static const kMusicAOverlayFile:Class;
		private static const kMusicAOverlay:FlxSound = new FlxSound().loadEmbedded(kMusicAOverlayFile,true);
		[Embed("assets/audio/ScrapheapTrackB_OverlayOnly.mp3")] private static const kMusicBOverlayFile:Class;
		private static const kMusicBOverlay:FlxSound = new FlxSound().loadEmbedded(kMusicBOverlayFile,true);
		
		protected static var _num:uint = 0;
		public static function get num():uint {
			return _num;
		}
		public static function set num(setNum:uint):void {
			_num = (setNum < kLevels.length) ? setNum : kLevels.length;
		}
		public static function reset():void {
			_num = 0;
		}

		private static const kCSVKeyFunc:String = "kCSVKeyFunc";
		private static const kCSVKeyFront:String = "kCSVKeyFront";
		private static const kCSVKeyMid:String = "kCSVKeyMid";
		private static const kCSVKeyBack:String = "kCSVKeyBack";
		private static const kCSVKeyBackBack:String = "kCSVKeyBackBack";
		private static const kCSVKeySemiBack:String = "kCSVKeySemiBack";
		private static const kCSVKeyMusic:String = "kCSVKeyMusic";
		private static const kCSVKeyMusicOverlay:String = "kCSVKeyMusicOverlay";
		
		/**
		 * An array containing dictionaries of level data
		**/
		private static const kLevels:Array = [
			{
				// TUTORIAL1
				kCSVKeyFunc : kFunct01Sheet,
				kCSVKeyFront : kCosm001FrontSheet,
				kCSVKeyMid : kCosm001MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : kCosm001SemiBackSheet,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// TUTORIAL2
				kCSVKeyFunc : kFunct02Sheet,
				kCSVKeyFront : kCosm002FrontSheet,
				kCSVKeyMid : kCosm002MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : kCosm002SemiBackSheet,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// TUTORIAL2.5
				kCSVKeyFunc : kFunct02_5Sheet,
				kCSVKeyFront : kCosm002_5FrontSheet,
				kCSVKeyMid : kCosm002_5MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// TUTORIAL3
				kCSVKeyFunc : kFunct03Sheet,
				kCSVKeyFront : kCosm003FrontSheet,
				kCSVKeyMid : kCosm003MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : kCosm003SemiBackSheet,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// TUTORIAL4
				kCSVKeyFunc : kFunct04Sheet,
				kCSVKeyFront : kCosm004FrontSheet,
				kCSVKeyMid : kCosm004MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : kCosm004SemiBackSheet,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// TUTORIAL5
				kCSVKeyFunc : kFunct05_Sheet,
				kCSVKeyFront : kCosm005_FrontSheet,
				kCSVKeyMid : kCosm005_MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// CANNON1
				kCSVKeyFunc : kFuncb01Sheet,
				kCSVKeyFront : kCosm005FrontSheet,
				kCSVKeyMid : kCosm005MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// PLAIN1
				kCSVKeyFunc : kFuncb02Sheet,
				kCSVKeyFront : kCosm006FrontSheet,
				kCSVKeyMid : kCosm006MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// GRAPPLE1
				kCSVKeyFunc : kFuncb03Sheet,
				kCSVKeyFront : kCosm007FrontSheet,
				kCSVKeyMid : kCosm007MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// CANNON2
				kCSVKeyFunc : kFuncb04Sheet,
				kCSVKeyFront : kCosm008FrontSheet,
				kCSVKeyMid : kCosm008MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// GRAPPLE2
				kCSVKeyFunc : kFuncb05Sheet,
				kCSVKeyFront : kCosm009FrontSheet,
				kCSVKeyMid : kCosm009MidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// GRAPPLE3
				kCSVKeyFunc : kFuncGrapple3Sheet,
				kCSVKeyFront : kCosmGrapple3FrontSheet,
				kCSVKeyMid : kCosmGrapple3MidSheet,
				kCSVKeyBack : null,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : kCosm001SemiBackSheet,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicBOverlay
			},
			{
				// COMBO1
				kCSVKeyFunc : kFuncbComboSheet,
				kCSVKeyFront : kCosmComboFrontSheet,
				kCSVKeyMid : kCosmComboMidSheet,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			}/*,
			{
				// M01
				kCSVKeyFunc : kFuncm01Sheet,
				kCSVKeyFront : null,
				kCSVKeyMid : null,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// M02
				kCSVKeyFunc : kFuncm02Sheet,
				kCSVKeyFront : null,
				kCSVKeyMid : null,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},
			{
				// M03
				kCSVKeyFunc : kFuncm03Sheet,
				kCSVKeyFront : null,
				kCSVKeyMid : null,
				kCSVKeyBack : kCosm001BackSheet,
				kCSVKeyBackBack : kCosm001BackBackSheet,
				kCSVKeySemiBack : null,
				kCSVKeyMusic : kMusicA,
				kCSVKeyMusicOverlay : kMusicAOverlay
			},*/
			];
		
		// GET CSVS
		private static function get currentFuncCSV():Class {
			return kLevels[num][kCSVKeyFunc];
		}
		private static function get currentCosmCSVFront():Class {
			return kLevels[num][kCSVKeyFront];
		}
		private static function get currentCosmCSVMid():Class {
			return kLevels[num][kCSVKeyMid];
		}
		private static function get currentCosmCSVBack():Class {
			return kLevels[num][kCSVKeyBack];
		}
		private static function get currentCosmCSVBackBack():Class {
			return kLevels[num][kCSVKeyBackBack];
		}
		private static function get currentCosmCSVSemiBack():Class {
			return kLevels[num][kCSVKeySemiBack];
		}
		
		public static function get currentMusic():FlxSound {
			return kLevels[num][kCSVKeyMusic];
		}
		public static function get previousMusic():FlxSound {
			if (num-1 >= 0) {
				return kLevels[num-1][kCSVKeyMusic];
			}
			return null;
		}
		
		public static function get currentMusicOverlay():FlxSound {
			return kLevels[num][kCSVKeyMusicOverlay];
		}
		public static function get previousMusicOverlay():FlxSound {
			if (num-1 >= 0) {
				return kLevels[num-1][kCSVKeyMusicOverlay];
			}
			return null;
		}
		
		public static function isLastLevel():Boolean {
			return (num >= kLevels.length-1);
		}
		
		public static function get numLevels():int {
			return kLevels.length;
		}
	}
}