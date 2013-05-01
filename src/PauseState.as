package
{
	import org.flixel.*;
	
	public class PauseState extends FlxGroup
	{
		public var controls:FlxButton;
		public var ctlText:FlxText;
		public var text:FlxText;
		public var conText:FlxText;
		public var continuity:FlxButton;
		
		public function PauseState(MaxSize:uint=0)
		{			
			//Registry.music.pause();
			super(MaxSize);
			refresh();
		}
		
		public function refresh():void {
			text = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"This is the PAUSE SCREEN :0");
			add(text);
			ctlText = new FlxText(100, 150, 400, "Controls (click to change):");
			controls = new FlxButton(100, 180, "Cam-Relative", changeControls);
			if (Registry.handRelative) {
			controls.label.text = "Hand-Relative";
			}
			conText = new FlxText(100, 250, 400, "Continuity (click to change):");
			continuity = new FlxButton(100, 280, "On", changeContinuity);
			if (!Registry.continuityUntilRelease) {
				continuity.label.text = "Off";
			}
			add(ctlText);
			add(controls);
			add(conText);
			add(continuity);
			setAll("scrollFactor",new FlxPoint(0,0));
		}
		
		public function scrap():void {
			text.kill();
			ctlText.kill();
			controls.kill();
		}
		
		/*override public function update():void {
			
			if (FlxG.keys.justPressed("P")) {
				
				FlxG.log("P pressed");
				
				
				//playState.remove(text);
				//playState.remove(ctlText);
				//playState.remove(controls);
				FlxG.paused = !FlxG.paused;
				
				scrap();
			}
			
			super.update();
		}*/
		
		public function changeControls():void {
			Registry.handRelative = !Registry.handRelative;
			if (Registry.handRelative) {
				controls.label.text = "Hand-Relative";
			} else {
				controls.label.text = "Cam-Relative";
			}
		}
		
		public function changeContinuity():void {
			Registry.continuityUntilRelease = !Registry.continuityUntilRelease;
			if (Registry.continuityUntilRelease) {
				continuity.label.text = "On";
			} else {
				continuity.label.text = "Off";
			}
		}
	}
}