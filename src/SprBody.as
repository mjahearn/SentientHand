package
{
	import org.flixel.*;
	
	public class SprBody extends SprControllable {
		public function SprBody(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
		}
		
		override public function setDir(dir:uint, grav:Boolean=false, setAngle:Boolean=true):void {
			super.setDir(dir, grav, setAngle);
			PlayState.current.hand.showArrow(); //there's GOTTA be a better place to put this
		}
	}
	
	//make cannon and grappler subclasses; make components like gears a part of the body
}