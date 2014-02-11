package
{
	import org.flixel.FlxSprite;
	
	public class SprExitChute extends FlxSprite
	{
		private var door:FlxSprite;
		
		private const kAnimOpen:String = "kAnimOpen";
		private const kAnimShut:String = "kAnimShut";
		private const kAnimSpit:String = "kAnimSpit";
		
		public function SprExitChute($hasDoor:Boolean,$x:Number=0,$y:Number=0)
		{
			super($x,$y,Registry.kExitChuteSheet);
						
			// generate a door only if there is one
			if (!$hasDoor) {return;}
			
			door = new FlxSprite();
			door.loadGraphic(Registry.kExitChuteDoorSheet,true,false,80,80);
			door.x = x + width/2.0 - door.width/2.0;
			door.y = y + height/2.0 - door.height/2.0;
			door.addAnimation(kAnimShut,[2,1,0],22,false);
			door.addAnimation(kAnimOpen,[0,1,2],22,false);
			door.addAnimation(kAnimSpit,[0,1,2,2,2,2,2,2,2,1,0],22,false);
		}
		
		public function shut():void {door.play(kAnimShut);}
		public function open():void {door.play(kAnimOpen);}
		public function spit():void {door.play(kAnimSpit);}
		
		override public function draw():void {
			super.draw();
			if (door) {door.draw();}
		}
		
		override public function update():void {
			super.update();
			if (door) {door.update();}
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			if (door) {door.preUpdate();}
		}
		
		override public function postUpdate():void {
			super.postUpdate();
			if (door) {door.postUpdate();}
		}
	}
}