package
{
	import org.flixel.FlxTilemap;
	
	public class RegistryLevels
	{
		public static const kSpawnEmpty:Array = [0];
		public static const kSpawnWood:Array = [1];
		public static const kSpawnMetal:Array = [2];
		public static const kSpawnHand:Array = [3];
		public static const kSpwanGrappler:Array = [4];
		public static const kSpawnLauncher:Array = [5];
		public static const kSpawnButton:Array = [6,7,8,9];
		public static const kSpawnDoor:Array = [10,11];
		public static const kSpwanExitArrow:Array = [12];
		
		public static function currentFlxTilemapFunctional():FlxTilemap {
			var map:FlxTilemap = new FlxTilemap();
			map.loadMap(new currentCSV,kTilesFunc,widthFunc,heightFunc);
			return map;
		}
		
		private static const widthFunc:uint = 8;
		private static const heightFunc:uint = 8;
		
		[Embed("assets/tiles_functional.png")] public static const kTilesFunc:Class;
		
		[Embed("assets/mapCSV_functional_001.csv",mimeType="application/octet-stream")] private static const kFunc001Sheet:Class;
		[Embed("assets/mapCSV_functional_001.csv",mimeType="application/octet-stream")] private static const kFunc002Sheet:Class;
		[Embed("assets/mapCSV_functional_001.csv",mimeType="application/octet-stream")] private static const kFunc003Sheet:Class;
		[Embed("assets/mapCSV_functional_001.csv",mimeType="application/octet-stream")] private static const kFunc004Sheet:Class;
		[Embed("assets/mapCSV_functional_001.csv",mimeType="application/octet-stream")] private static const kFunc005Sheet:Class;
		[Embed("assets/mapCSV_functional_001.csv",mimeType="application/octet-stream")] private static const kFunc006Sheet:Class;
		
		//protected static var _num:uint = 0;
		public static function get num():uint {
			//return _num;
			return Registry.levelNum;
		}
		/*
		public static function set num(setNum:uint):void {
			_num = (setNum < csvs.length) ? setNum : csvs.length;
		}
		*/
		
		private static const csvs:Array = [kFunc001Sheet,kFunc002Sheet,kFunc003Sheet,kFunc004Sheet,kFunc005Sheet,kFunc006Sheet];
		private static function get currentCSV():Class {
			return csvs[num];
		}
	}
}