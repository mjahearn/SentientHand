package
{
	import org.flixel.*;
	
	public class EndState extends FlxState
	{	
		public var timer:Number = 0;
		public var fadeInTime:Number = 22;
		[Embed("assets/Dirt_Footsteps.mp3")] public var dirtFootstepsSFX:Class;

		public var dirtFootstepsSound:FlxSound = new FlxSound().loadEmbedded(dirtFootstepsSFX);
		public var text:FlxText;
		public var delta:Number = 0.022;
		
		override public function create():void {
			text = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"FREEDOM.");//"The factory was producing death machines or was a giant death machine or something.  You just reactivated it.  Awesome.  \nend");
			text.alpha = 0;
			add(text);
		}
		
		override public function update():void {
			
			
			if (timer < fadeInTime) {
				timer += FlxG.elapsed;
				if (timer >= fadeInTime) {timer = fadeInTime;}
				text.alpha = 1 - Math.abs(fadeInTime - timer)/fadeInTime;
			}/*
			text.x += Math.pow(-1,int(Math.random()*10))*0.01;
			text.y += Math.pow(-1,int(Math.random()*10))*0.01;
			
			if (FlxG.width/2 - delta > text.x || text.x > FlxG.width/2 + delta) {
				text.x = FlxG.width/2;
			}
			if (FlxG.height/2 - delta > text.y || text.y > FlxG.height/2 + delta) {
				text.y = FlxG.height/2
			}*/
			
			
			if (FlxG.keys.RIGHT || FlxG.keys.LEFT) {
				dirtFootstepsSound.play();
			} else {
				dirtFootstepsSound.stop();
			}
		}
	}
}