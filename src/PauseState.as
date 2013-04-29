package
{
	import org.flixel.*;
	
	public class PauseState extends FlxGroup
	{
		public var controls:FlxButton;
		public var ctlText:FlxText;
		public var text:FlxText;
		public var playState:PlayState;
		
		public function PauseState(state:PlayState,MaxSize:uint=0)
		{			
			
			playState = state;
			Registry.music.pause();
			
		
			text = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"This is the PAUSE SCREEN :0");
			playState.add(text);
			/*ctlText = new FlxText(100, 150, 400, "Controls (click to change):");
			controls = new FlxButton(100, 200, "Cam-Relative", changeControls);
			if (Registry.handRelative) {
				controls.label.text = "Hand-Relative";
			}
			playState.add(ctlText);
			playState.add(controls);
			*/
			super(MaxSize);
			
		}
		
		override public function update():void {
			
			//FlxG.log("paused");
			
			if (FlxG.keys.justPressed("P")) {
				
				FlxG.log("P pressed");
				text.visible = false;
				text.kill();
				
				/*
				playState.remove(text);
				playState.remove(ctlText);
				playState.remove(controls);*/
				FlxG.paused = !FlxG.paused;
			}
			
			super.update();
		}
		
		public function changeControls():void {
			Registry.handRelative = !Registry.handRelative;
			if (Registry.handRelative) {
				controls.label.text = "Hand-Relative";
			} else {
				controls.label.text = "Cam-Relative";
			}
		}
	}
}