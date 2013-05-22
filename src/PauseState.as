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
		public var jump:FlxButton;
		public var jumpText:FlxText;
		public var con:FlxSprite;
		
		[Embed("assets/controls.png")] public var controlsSheet:Class;

		
		public function PauseState(MaxSize:uint=0)
		{			
			//Registry.music.pause();
			super(MaxSize);
			refresh();
		}
		
		public function refresh():void {
			/*
			text = new FlxText(FlxG.width/2.0,FlxG.height/4.0,FlxG.width/2.0,"This is the PAUSE SCREEN :0");
			add(text);
			
			ctlText = new FlxText(100, 150, 400, "Controls (click to change):");
			controls = new FlxButton(100, 180, "Cam-Relative", changeControls);
			if (Registry.handRelative) {
			controls.label.text = "Hand-Relative";
			}
			add(ctlText);
			add(controls);
			
			conText = new FlxText(100, 250, 400, "Continuity (click to change):");
			continuity = new FlxButton(100, 280, "On", changeContinuity);
			if (!Registry.continuityUntilRelease) {
				continuity.label.text = "Off";
			}
			add(conText);
			add(continuity);
			
			jumpText = new FlxText(100, 350, 400, "Jumping:");
			jump = new FlxButton(100, 380, "On", changeJumping);
			if (!Registry.jumping) {
				jump.label.text = "Off";
			}
			add(jumpText);
			add(jump);
			*/
			
			con = new  FlxSprite(0,0);//(FlxG.width/2,FlxG.height/2);
			con.loadGraphic(controlsSheet,true,false,640,480);
			//con.x -= con.width/2;
			//con.y -= con.height/2;
			con.scrollFactor = new FlxPoint(0,0);
			con.addAnimation("detached",[0],10,true);
			con.addAnimation("attached",[1],10,true);
			//con.alpha = 0.75;
			add(con);
			
			
			
			setAll("scrollFactor",new FlxPoint(0,0));
		}
		
		public function scrap():void {
			/*
			text.kill();
			ctlText.kill();
			controls.kill();
			*/
			//con.kill();
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
		
		public function changeJumping():void {
			Registry.jumping = !Registry.jumping;
			if (Registry.jumping) {
				jump.label.text = "On";
			} else {
				jump.label.text = "Off";
			}
		}
	}
}