package
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class SprWindow extends FlxSprite
	{
		private var dropGroup:FlxGroup;
		
		private var dropTimer:Number;
		private var dropPeriod:Number;
		
		public function SprWindow($x:Number=0,$y:Number=0)
		{
			super($x,$y,Registry.kWindowSheet);
			alpha = 0.11;
			scrollFactor = new FlxPoint(0.5,0.5);
			
			dropGroup = new FlxGroup();
			
			resetDropTimer();
		}
		
		override public function draw():void {
			for (var i:uint = 0; i < dropGroup.length; i++) {
				var $rainDrop:SprWindowDrop = dropGroup.members[i];
				$rainDrop.draw();
			}
			super.draw();
		}
		
		override public function update():void {
			
			dropTimer += FlxG.elapsed;
			if (dropTimer >= dropPeriod) {
				maybeAddDropToWindow();
				resetDropTimer();
			}
			
			destroyDoneDrips();
			
			for (var i:uint = 0; i < dropGroup.length; i++) {
				var $rainDrop:SprWindowDrop = dropGroup.members[i];
				$rainDrop.update();
			}
			super.update();
		}
		
		private function maybeAddDropToWindow():void {
			
			var $randNum:uint = Math.random()*5;			
			for (var i:uint = 0; i < $randNum; i++) {
				var $randX:Number = Math.random()*(width-8);
				var $randY:Number = Math.random()*(height-32);
				var $drop:SprWindowDrop = new SprWindowDrop($randX + x,$randY + y);
				$drop.scrollFactor = scrollFactor;
				dropGroup.add($drop);
			}
		}
		
		private function destroyDoneDrips():void {
			var $destroyGroup:FlxGroup = new FlxGroup();
			for (var i:uint = 0; i < dropGroup.length; i++) {
				var $rainDrop:SprWindowDrop = dropGroup.members[i];
				if ($rainDrop.canBeKilled()) {
					$destroyGroup.add($rainDrop);
				}
			}
			for (var j:uint = 0; j < $destroyGroup.length; j++) {
				var $destroyRainDrop:SprWindowDrop = $destroyGroup.members[j];
				dropGroup.remove($destroyRainDrop,true);
			}
		}
		
		override public function postUpdate():void {
			for (var i:uint = 0; i < dropGroup.length; i++) {
				var $rainDrop:SprWindowDrop = dropGroup.members[i];
				$rainDrop.postUpdate();
			}
			super.postUpdate();
		}
		
		override public function preUpdate():void {
			for (var i:uint = 0; i < dropGroup.length; i++) {
				var $rainDrop:SprWindowDrop = dropGroup.members[i];
				$rainDrop.preUpdate();
			}
			super.preUpdate();
		}
		
		private function resetDropTimer():void {
			dropTimer = 0;
			dropPeriod = Math.random()*0.22;
		}
		
		
	}
}