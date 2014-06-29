package
{
	import org.flixel.*;
	
	public class SprHandMarker extends SprControllable {
		public function SprHandMarker(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
		}
		
		override public function collideCallback():void {
			raytraceCallback(PlayState.current.levelFunctional, this);
		}
		
		public function raytraceCallback(spr1:FlxObject, spr2:FlxSprite):void {
			if (isTouching(FlxObject.DOWN)) {
				setDir(FlxObject.DOWN);
			} else if (isTouching(FlxObject.UP)) {
				setDir(FlxObject.UP);
			} else if (isTouching(FlxObject.LEFT)) {
				setDir(FlxObject.LEFT);
			} else if (isTouching(FlxObject.RIGHT)) {
				setDir(FlxObject.RIGHT);
			}
			velocity.x = 0;
			velocity.y = 0;
			if (isMetalInDir(facing)) {
				setGrappleOkay();
			} /*else { //for debug
				visible = true;
				color = 0x0000ff;
			}*/
		}
		
		public function setGrappleOkay():void {
			visible = true;
			color = PlayState.current.poleCol;
			PlayState.current.hand.setGrappleOkay(); //hacky workaround just to get this up
		}
		
		//move other setGrapple stuff here, including bodyMarkerGroup
	}
}