package
{
	import org.flixel.FlxSprite;
	
	public class SprGrate extends FlxSprite
	{
		public static const kBroken0:uint = 0;
		public static const kBroken1:uint = 1;
		public static const kBroken2:uint = 2;
		public static const kBroken3:uint = 3;
		
		public function SprGrate($degreeOfBroken:uint,$x:Number=0,$y:Number=0)
		{
			var $graphic:Class = Registry.kGrateSheet;// something here to select based on degree of broken
			super($x,$y,$graphic);
		}
	}
}