package
{
	import org.flixel.*;
	
	public class SprHand extends SprControllable
	{
		//make these private/protected?
		public static const NONE:int = 0;
		public static const GRAPPLER:int = 1;
		public static const CANNON:int = 2;
		
		public static const GROUND:int = 0;
		public static const FALLING:int = 1;
		public static const CORNER:int = 2;
		
		public static const IDLE:int = 0;
		public static const EXTENDING:int = 1;
		public static const RETRACTING:int = 2;
		
		public static const kAnimCrawlRight:String = "crawl right";
		public static const kAnimIdleRight:String = "idle right";
		public static const kAnimCrawlLeft:String = "crawl left";
		public static const kAnimIdleLeft:String = "idle left";
		public static const kAnimIdleBodyRight:String = "idle body right";
		public static const kAnimIdleBodyLeft:String = "idle body left";
		public static const kAnimFallRight:String = "fall right";
		public static const kAnimFallLeft:String = "fall left";
		public static const kAnimExtendRight:String = "extend right";
		public static const kAnimExtendLeft:String = "extend left";
		public static const kAnimGrabLeft:String = "grab left";
		public static const kAnimGrabRight:String = "grab right";
		
		private const EPSILON:Number = 0.001;
		
		private const MOVE_ACCEL:Number = 1600; //acceleration/deceleration (in pixels per second per second) of the hand when moving along a wall
		private const WALL_JUMP_VEL:Number = 100; //initial velocity (in pixels per second) of the hand when jumping from the wall
		private const CEIL_JUMP_VEL:Number = 50; //initial velocity (in pixels per second) of the hand when jumping from the ceiling
		
		private const BODY_ROTATE_RATE:Number = 2; //the speed (in degrees per frame) with which the hand rotates before grappling
		private const GRAPPLE_SPEED:Number = 300; //the velocity (in pixels per second) of the grappling arm when extending or retracting
		private const GRAPPLE_LENGTH:uint = 320; // maximum length of the grappling arm
		private const CANNON_VEL:Number = 6400; //the initial velocity (in pixels per second) of the hand upon launch from a cannon
		
		private const DOT_SPACING:uint = 10;
		private const DOT_SPEED:uint = 3;
		
		private const kMaxVel:FlxPoint = new FlxPoint(200,200);
		
		protected var _camTag:FlxSprite;
		protected var _camAngle:Number;
		
		protected var _isLeft:Boolean;
		protected var _isRight:Boolean;
		protected var _movementState:int;
		protected var _bodyState:int;
		protected var _isInGrappler:Boolean;
		protected var _isInCannon:Boolean;
		protected var _timeFallen:Number;
		
		protected var _targetBody:SprBody;
		protected var _targetBodyType:int;
		protected var _wasTouchingMetal:Boolean;
		
		protected var _aimAngle:Number;
		protected var _rad:Number; //_aimAngle in radians
		protected var _startAimAngle:Number; //change to radians?
		protected var _bodyMarkerGroup:FlxGroup;
		protected var _bodyMarkerTimer:Number;
		protected var _markerEnd:SprHandMarker;
		protected var _markerEndGroup:FlxGroup;
		
		[Embed("assets/cannon_marker_line.png")] protected var _cannonMarkerLineSheet:Class;
		protected var _cannonMarkerLine:FlxSprite = new FlxSprite();
		
		//protected var _heart:FlxSprite;
		
		[Embed("assets/Metal_Footsteps.mp3")] public var metalFootstepsSFX:Class;
		[Embed("assets/Wood_Footsteps.mp3")] public var woodFootstepsSFX:Class;
		[Embed("assets/Dirt_Footsteps.mp3")] public var dirtFootstepsSFX:Class;
		[Embed("assets/Cannon_Shot.mp3")] public var cannonShotSFX:Class;
		public var metalCrawlSound:FlxSound = new FlxSound().loadEmbedded(metalFootstepsSFX);
		public var woodCrawlSound:FlxSound = new FlxSound().loadEmbedded(woodFootstepsSFX);
		public var dirtFootstepsSound:FlxSound = new FlxSound().loadEmbedded(dirtFootstepsSFX);
		public var cannonShotSound:FlxSound = new FlxSound().loadEmbedded(cannonShotSFX);
		
		private var gravityArrow:FlxSprite;
		
		public function SprHand(X:Number=0, Y:Number=0)
		{
			//make sure PlayState also calls addMarker
			super(X, Y);
			loadGraphic(Registry.kHandSheet,true,false,32,32,true);
			
			gravityArrow = new FlxSprite();
			gravityArrow.loadGraphic(Registry.kGravityArrow);
			
			addAnimation(kAnimCrawlRight,[0,1,2,3,4,5,6],22,true);
			addAnimation(kAnimIdleRight,[7,7,7,7,7,7,7,8,9,9,9,9,9,9,8],10,true);
			addAnimation(kAnimCrawlLeft,[20,19,18,17,16,15,14],22,true);
			addAnimation(kAnimIdleLeft, [13,13,13,13,13,13,13,12,11,11,11,11,11,11,12],10,true);
			addAnimation(kAnimIdleBodyRight, [21,21,21,21,21,21,21,22,23,23,23,23,23,23,22],10,true);
			addAnimation(kAnimIdleBodyLeft, [25,25,25,25,25,25,25,26,27,27,27,27,27,27,26],10,true);
			addAnimation(kAnimFallRight,[29]);
			addAnimation(kAnimFallLeft,[33]);
			addAnimation(kAnimExtendRight,[35,36],22,false);
			addAnimation(kAnimExtendLeft,[40,41],22,false);
			addAnimation(kAnimGrabLeft,[32],22,false);
			addAnimation(kAnimGrabRight,[30],22,false);
			
			//play(kAnimIdleRight); //should it be kAnimFallRight? - Mike
			play(kAnimFallRight);
			maxVelocity = kMaxVel;
			drag = new FlxPoint(MOVE_ACCEL,MOVE_ACCEL);
			
			/*
			_heart = new FlxSprite().loadGraphic(Registry.kHeartSheet,true,false,32,32);
			hideHeart();
			*/
			
			_targetBody = null;
			_targetBodyType = NONE;
			_isInGrappler = false;
			_isInCannon = false;
			_isLeft = false;
			_isRight = true;
			_movementState = FALLING;
			_bodyState = IDLE;
			_wasTouchingMetal = false;
			_aimAngle = 0;
			_rad = 0;
			_timeFallen = 0;
			
			_camTag = new FlxSprite(x,y);
			
			setDir(FlxObject.DOWN, true);
			FlxG.camera.follow(_camTag, Registry.extendedCamera?FlxCamera.STYLE_LOCKON:FlxCamera.STYLE_TOPDOWN);
			
			scale.x = 0; //what are these for again?
			scale.y = 0;
		}
		
		public function addMarker():void {
			_bodyMarkerGroup = new FlxGroup();
			_bodyMarkerTimer = 0;
			PlayState.current.add(_bodyMarkerGroup);
			
			_cannonMarkerLine = new FlxSprite(0,0,_cannonMarkerLineSheet);
			_cannonMarkerLine.visible = false;
			PlayState.current.add(_cannonMarkerLine);
			
			_markerEnd = new SprHandMarker(0,0,null/*,raytraceCallback*/);
			_markerEnd.loadGraphic(Registry.kHandSheet,true,false,32,32);
			_markerEnd.frame = 30;
			_markerEnd.alpha = 0.75;
			_markerEnd.visible = false;
			_markerEndGroup = new FlxGroup();
			_markerEndGroup.add(_markerEnd);
			PlayState.current.add(_markerEndGroup);
		}
		
		override public function draw():void {
			super.draw();
			gravityArrow.draw();
		}
		
		override public function update():void {
			
			gravityArrow.x = x;
			gravityArrow.y = y + gravityArrow.height*2;
			gravityArrow.update();
			
			if (scale.x < 1 && scale.y < 1) {
				scale.x += 0.03;
				scale.y += 0.03;
				//color = 0xff000000;
			}
			if (scale.x > 1 || scale.y > 1) {
				scale.x = 1;
				scale.y = 1;
			}
			
			
			moveCamTag();
			
			if (isAttachedToBody()) {
				handleBodyMovement();
			} else {
				handleSoloMovement();
			}
			
			super.update();
			
			if (!isAttachedToBody()) {
				if (velocity.x == 0 && velocity.y == 0) { //instead of this check, include as part of the callback provided in this class when those finally work
					stopCrawlEffects();
				}
				if (isOnGround()) {
					changeHandGravity(); //for convex corners and walking onto/off non-polar surfaces
				}
			}
			
			_wasTouchingMetal = (isOnGround() && isMetalInDir(facing));
		}
		
		override public function setDir(dir:uint, grav:Boolean=false, setAngle:Boolean=true):void {
			super.setDir(dir, grav, setAngle);
			if (grav) {
				drag = new FlxPoint();
			} else {
				drag = new FlxPoint(MOVE_ACCEL,MOVE_ACCEL);
				hitGround();
				_camTag.angle = trueAngle(_camTag.angle);
			}
			if (Registry.cameraRotates) {
				if (dir == FlxObject.DOWN) {
					_camAngle = 0;
				} else if (dir == FlxObject.UP) {
					if (_camAngle < 0) {
						_camAngle = -180;
					} else {
						_camAngle = 180;
					}
				} else if (dir == FlxObject.LEFT) {
					if (_camTag.angle < -90) {
						_camTag.angle += 360;
					}
					_camAngle = 90;
				} else if (dir == FlxObject.RIGHT) {
					if (_camTag.angle > 90) {
						_camTag.angle -= 360;
					}
					_camAngle = -90;
				}
			}
		}
		
		public function moveCamTag():void {
			if (Registry.cameraFollowsHand) {
				if (isOnGround()) {
					_camTag.angle += angleDifference(_camAngle, _camTag.angle)/Registry.cameraTurnRate;
				} else {
					_camTag.angle += angleDifference(angle, _camTag.angle)/Registry.cameraTurnRate;
				}
			} else if (_camTag.angle != _camAngle) {
				_camTag.angle += angleDifference(_camAngle, _camTag.angle)/Registry.cameraTurnRate;
			}
			FlxG.camera.angle = -_camTag.angle;
			
			if (isAttachedToGrappler() && isIdle()) {
				_camTag.x += (-_camTag.x + _markerEnd.x)/44.0;
				_camTag.y += (-_camTag.y + _markerEnd.y)/44.0;
			} else {
				_camTag.x += (-_camTag.x + x)/8.0;
				_camTag.y += (-_camTag.y + y)/8.0;
			} 
		}
		
		public function handleBodyMovement():void {
			if (isExtending()) {
				handleBodyExtendingMovement();
			}
			if (isRetracting()) {
				handleBodyRetractingMovement();
			} 
			if (isIdle()) {
				handleBodyIdleMovement();
			}
		}
		
		public function handleBodyExtendingMovement():void {
			var diffX:Number = getMidpoint().x - _targetBody.getMidpoint().x;
			var diffY:Number = getMidpoint().y - _targetBody.getMidpoint().y;
			if (touching <= 0 && Math.pow(diffX, 2) + Math.pow(diffY, 2) < Math.pow(GRAPPLE_LENGTH,2)) {
				velocity.x = GRAPPLE_SPEED * Math.cos(_rad);
				velocity.y = GRAPPLE_SPEED * Math.sin(_rad);
			} else {
				_bodyState = RETRACTING;
				velocity = new FlxPoint();
			}
			if (_isLeft) {
				play(kAnimExtendLeft);
			} else if (_isRight) {
				play(kAnimExtendRight);
			}
		}
		
		public function handleBodyRetractingMovement():void {
			var diffX:Number = getMidpoint().x - _targetBody.getMidpoint().x;
			var diffY:Number = getMidpoint().y - _targetBody.getMidpoint().y;
			//we should really have a separate variable for if the hand is extended and sticking to something instead of this indirect check
			//in fact, I think that's what the unused variable "handGrab" from PlayState was supposed to be
			if (facing != _targetBody.facing) {
				var ang:Number = Math.atan2(diffY, diffX);
				_targetBody.velocity.x = GRAPPLE_SPEED * Math.cos(ang);
				_targetBody.velocity.y = GRAPPLE_SPEED * Math.sin(ang);
				if (angle > _targetBody.angle) {
					_targetBody.angle += 4; //Math.min with difference between angles?  Seems like it'd be necessary
				} else if (angle < _targetBody.angle) {
					_targetBody.angle -= 4;
				}
				if (_isLeft) {
					play(kAnimGrabLeft);
				} else if (_isRight) {
					play(kAnimGrabRight);
				}
			} else {
				velocity.x = -GRAPPLE_SPEED * Math.cos(_rad);
				velocity.y = -GRAPPLE_SPEED * Math.sin(_rad);
				if (_isLeft) {
					play(kAnimIdleBodyLeft);
				} else if (_isRight) {
					play(kAnimIdleBodyRight);
				}
			}

			if (Math.abs(diffX) <= Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.cos(_rad)) + EPSILON &&
				Math.abs(diffY) <= Math.abs(GRAPPLE_SPEED * FlxG.elapsed * Math.sin(_rad)) + EPSILON) {
				_bodyState = IDLE;
				velocity.x = 0;
				velocity.y = 0;
				acceleration.x = 0;
				acceleration.y = 0;
				_targetBody.velocity.x = 0;
				_targetBody.velocity.y = 0;
				_targetBody.acceleration.x = 0;
				_targetBody.acceleration.y = 0;
				if (facing == _targetBody.facing) {
					x = _targetBody.x;
					y = _targetBody.y;
				} else {
					_targetBody.x = x;
					_targetBody.y = y;
					_targetBody.setDir(facing);
				}
				showArrow();
				allowCollisions = FlxObject.ANY;
				if (_targetBody.isMetalInDir(_targetBody.facing)) {
					showBodyMarker();
				} else {
					_targetBody.setDir(FlxObject.DOWN,true);
					setDir(FlxObject.DOWN,true);
				}
				idleBodyEffects();
			}
		}
		
		public function handleBodyIdleMovement():void {
			if (RegistryControls.isPressed(FlxObject.LEFT)) {
				addToAimAngle(-BODY_ROTATE_RATE);
				if (_aimAngle < _startAimAngle - 90) {
					setAimAngle(_startAimAngle - 90);
				}
				if (Registry.neverAimedBodyOrCannon) {
					Registry.neverAimedBodyOrCannon = false;
				}
				if (isAttachedToGrappler()) {
					updateRaytrace();
				}
			} if (RegistryControls.isPressed(FlxObject.RIGHT)) {
				addToAimAngle(BODY_ROTATE_RATE);
				if (_aimAngle > _startAimAngle + 90) {
					setAimAngle(_startAimAngle + 90);
				}
				if (Registry.neverAimedBodyOrCannon) {
					Registry.neverAimedBodyOrCannon = false;
				}
				if (isAttachedToGrappler()) {
					updateRaytrace();
				}
			}
			idleBodyEffects();
			angle = _aimAngle - 90;
			updateBodyMarker();
			if (RegistryControls.isPressed(FlxObject.DOWN)) {
				RegistryControls.reset();
				if (isAttachedToGrappler()) {
					detachFromGrappler();
				} else if (isAttachedToCannon()) {
					detachFromCannon();
				}
				hideBodyMarker();
				setDir(_targetBody.facing);
			}
			if (RegistryControls.isPressed(FlxObject.UP)) {
				RegistryControls.remove(FlxObject.UP);
				if (isAttachedToGrappler()) {
					fireGrappler(_rad);
				} else if (isAttachedToCannon()) {
					fireCannon(_rad);
				}
				if (Registry.neverFiredBodyOrCannon) {
					Registry.neverFiredBodyOrCannon = false;
				}
			}
		}
		
		private function fireGrappler(rad:Number):void {
			_bodyState = EXTENDING;
			hideBodyMarker();
			maxVelocity.x = Number.MAX_VALUE;
			maxVelocity.y = Number.MAX_VALUE;
			drag.x = 0;
			drag.y = 0;
			velocity.x = GRAPPLE_SPEED * Math.cos(rad);
			velocity.y = GRAPPLE_SPEED * Math.sin(rad);
			
			allowCollisions = 0; //is this stuff even necessary without blocks?
			if (velocity.x > 0) {
				allowCollisions |= FlxObject.RIGHT;
			} else if (velocity.x < 0) {
				allowCollisions |= FlxObject.LEFT;
			}
			if (velocity.y > 0) {
				allowCollisions |= FlxObject.DOWN;
			} else if (velocity.y < 0) {
				allowCollisions |= FlxObject.UP;
			}
			
			if (Registry.neverFiredBodyOrCannon) {
				Registry.neverFiredBodyOrCannon = false;
			}
		}
		
		private function fireCannon(rad:Number):void {
			detachFromCannon();
			
			drop();
			angle = _aimAngle - 90;
			velocity.x = CANNON_VEL * Math.cos(rad);
			velocity.y = 1.5 * CANNON_VEL * Math.sin(rad);
			
			cannonShotSound.stop();
			cannonShotSound.play();
		}
		
		public function handleSoloMovement():void {
			if (RegistryControls.isPressed(FlxObject.DOWN)) {
				RegistryControls.remove(FlxObject.DOWN);
				if (_targetBodyType == GRAPPLER) {
					attachToGrappler();
				} else if (_targetBodyType == CANNON) {
					attachToCannon();
				}
			} else if (isOnGround()) {
				_timeFallen = 0; // move this to the moment it lands
				if (facing == FlxObject.DOWN || facing == FlxObject.UP) {
					acceleration.x = 0;
				} else if (facing == FlxObject.LEFT || facing == FlxObject.RIGHT) {
					acceleration.y = 0;
				}
				if (RegistryControls.isPressed(FlxObject.LEFT)) {
					moveLeft();
				} else if (RegistryControls.isPressed(FlxObject.RIGHT)) {
					moveRight();
				} else {
					stopCrawlEffects(); //test if this is called when hand hits wall
				}
				
				if (RegistryControls.isPressed(FlxObject.UP)) {
					RegistryControls.remove(FlxObject.UP);
					if (facing != FlxObject.DOWN) {
						jump();
					}
				}
			} else if (isRoundingCorner()) {
				if (_isLeft) {
					angle -= 2.2;
					play(kAnimFallLeft); //<- placeholder {hand.play("jump left");
				} else if (_isRight) {
					angle += 2.2;
					play(kAnimFallRight); //<- placeholder {hand.play("jump right");
				}
			} else if (isFalling()) {
				_timeFallen += FlxG.elapsed;
				if (angle > 0 && angle < 360) {
					if (_isLeft) {
						play(kAnimFallLeft);
						angle += 10;
					} else if (_isRight) {
						play(kAnimFallRight);
						angle -= 10;
					}
				}
				else if (_timeFallen > 0.44) {
					var vSquared:Number = Math.pow(velocity.x,2) + Math.pow(velocity.y,2);
					
					if (_isLeft) {angle += vSquared/8000;}
					else if (_isRight) {angle -= vSquared/8000;}
				}
			}
		}
		
		public function attachToGrappler():void {
			_isInGrappler = true;
			attachToTargetBody();
			
			FlxG.play(Registry.kAttachHappySFX);
			PlayState.current.addHeartHappy();
			PlayState.current.showMusicOverlay();
		}
		
		public function detachFromGrappler():void {
			_isInGrappler = false;
			
			FlxG.play(Registry.kAttachSadSFX);
			PlayState.current.addHeartSad();
			PlayState.current.hideMusicOverlay();
			
			detachFromTargetBody();
		}
		
		public function attachToCannon():void {
			_isInCannon = true;
			attachToTargetBody();
		}
		
		public function detachFromCannon():void {
			_isInCannon = false;
			detachFromTargetBody();
		}
		
		private function attachToTargetBody():void {
			RegistryControls.reset();
			_movementState = GROUND;
			
			velocity.x = 0;
			velocity.y = 0;
			acceleration.x = 0;
			acceleration.y = 0;
			x = _targetBody.x;
			y = _targetBody.y;
			
			facing = _targetBody.facing;
			
			stopCrawlEffects();
			showArrow();
			idleBodyEffects();
			
			if (Registry.neverEnteredBodyOrCannon) {
				Registry.neverEnteredBodyOrCannon = false;
			}
		}
		
		private function idleBodyEffects():void {
			if (_isLeft) {
				play(kAnimIdleBodyLeft);
			} else if (_isRight) {
				play(kAnimIdleBodyRight);
			}
		}
		
		private function detachFromTargetBody():void {
			hideBodyMarker();
			setDir(_targetBody.facing);
			setTarget(null, NONE);
		}
		
		public function showArrow():void { //should probably also set hand to that angle
			_startAimAngle = _targetBody.angle - 90;
			setAimAngle(_startAimAngle);
			showBodyMarker();
		}
		
		public function jump():void {
			var f:uint = facing;
			drop();
			Registry.neverJumped = false;
			
			if (f == FlxObject.UP) {
				velocity.y = CEIL_JUMP_VEL;
			} else if (f == FlxObject.LEFT) {
				velocity.x = WALL_JUMP_VEL;
			} else if (f == FlxObject.RIGHT) {
				velocity.x = -WALL_JUMP_VEL;
			}
			
			stopCrawlEffects();
			Registry.kJumpSound = FlxG.play(Registry.kJumpSFX);
			
			if (_isLeft) {
				play(kAnimFallLeft); //placeholder for proper jumping animation?
			} else {
				play(kAnimFallRight);
			}
		}
		
		public function moveLeft():void {
			_isLeft = true;
			_isRight = false;
			
			if (facing == FlxObject.DOWN) {
				acceleration.x = -MOVE_ACCEL;
			} else if (facing == FlxObject.LEFT) {
				acceleration.y = -MOVE_ACCEL;
			} else if (facing == FlxObject.UP) {
				acceleration.x = MOVE_ACCEL;
			} else if (facing == FlxObject.RIGHT) {
				acceleration.y = MOVE_ACCEL;
			}
			
			crawlEffects();
		}
		
		public function moveRight():void {
			_isLeft = false;
			_isRight = true;
			
			if (facing == FlxObject.DOWN) {
				acceleration.x = MOVE_ACCEL;
			} else if (facing == FlxObject.RIGHT) {
				acceleration.y = -MOVE_ACCEL;
			} else if (facing == FlxObject.UP) {
				acceleration.x = -MOVE_ACCEL;
			} else if (facing == FlxObject.LEFT) {
				acceleration.y = MOVE_ACCEL;
			}
			
			crawlEffects();
		}
		
		public function crawlEffects():void {
			if (isMetalInDir(facing)) {
				woodCrawlSound.stop();
				dirtFootstepsSound.stop();
				metalCrawlSound.play();
			} else if (isNeutralInDir(facing)) {
				metalCrawlSound.stop();
				dirtFootstepsSound.stop();
				woodCrawlSound.play();
			} else { //there's currently no kSpawnDirt in RegistryLevels
				metalCrawlSound.stop();
				woodCrawlSound.stop();
				dirtFootstepsSound.play();
			}
			
			if (_isLeft) {
				play(kAnimCrawlLeft);
			} else if (_isRight) {
				play(kAnimCrawlRight);
			}
		}
		
		public function stopCrawlEffects():void {
			woodCrawlSound.stop();
			metalCrawlSound.stop();
			dirtFootstepsSound.stop();
			
			if (_isLeft) {
				play(kAnimIdleLeft);
			} else if (_isRight) {
				play(kAnimIdleRight);
			}
		}
		
		public function changeHandGravity():void {
			if (isNothingInDir(facing)) {
				if (_wasTouchingMetal) { //was the player touching metal the last frame?
					wrapAroundCorner();
				} else {
					drop();
				}
			} else if (facing != FlxObject.DOWN && !isMetalInDir(facing)) { //replacing || lastTouchedWood
				drop();
			}
		}
		
		public function wrapAroundCorner():void {
			_movementState = CORNER;
			if (facing == FlxObject.LEFT) {
				if (_isRight) {
					setDir(FlxObject.UP,true,false);
					acceleration.y -= MOVE_ACCEL;
				} else {
					setDir(FlxObject.DOWN,true,false);
					acceleration.y += MOVE_ACCEL;
				}
				acceleration.x = -GRAV_RATE;
			} else if (facing == FlxObject.RIGHT) {
				if (_isLeft) {
					setDir(FlxObject.UP,true,false);
					acceleration.y -= MOVE_ACCEL;
				} else {
					setDir(FlxObject.DOWN,true,false);
					acceleration.y += MOVE_ACCEL;
				}
				acceleration.x = GRAV_RATE;
			} else if (facing == FlxObject.DOWN) {
				if (_isRight) {
					setDir(FlxObject.LEFT,true,false);
					acceleration.x -= MOVE_ACCEL;
				} else {
					setDir(FlxObject.RIGHT,true,false);
					acceleration.x += MOVE_ACCEL;
				}
				acceleration.y = GRAV_RATE;
			} else if (facing == FlxObject.UP) {
				if (_isLeft) {
					setDir(FlxObject.LEFT,true,false);
					acceleration.x -= MOVE_ACCEL;
				} else {
					setDir(FlxObject.RIGHT,true,false);
					acceleration.x += MOVE_ACCEL;
				}
				acceleration.y = -GRAV_RATE;
			}
		}
		
		public function drop():void {
			_movementState = FALLING;
			setDir(FlxObject.DOWN,true,false);
		}
		
		public function hitGround():void {
			_movementState = GROUND;
			Registry.kJumpSound.stop();
		}
		
		override public function collideCallback():void {
			if (!isAttachedToBody() || !isIdle()) {
				super.collideCallback();
			}
		}
		
		override public function collideWithWood(grav:Boolean):void {
			if (!isExtending() && !isRetracting()) {
				super.collideWithWood(grav);
			}
		}
		
		public function setGrappleOkay():void {
			_bodyMarkerGroup.setAll("color", 0xffffff);
		}
		
		public function setGrappleButton():void {
			_markerEnd.visible = true;
			_markerEnd.color = PlayState.current.col;
			_bodyMarkerGroup.setAll("color", PlayState.current.col);
		}
		
		public function showBodyMarker():void {
			if (isAttachedToGrappler()) {
				_markerEnd.visible = true;
				if (_isRight) {
					_markerEnd.frame = 30;
				} else if (_isLeft) {
					_markerEnd.frame = 32;
				}
				_bodyMarkerGroup.visible = true;
				updateRaytrace();
				updateGrapplerMarker();
			} else if (isAttachedToCannon()) {
				_cannonMarkerLine.visible = true;
				updateCannonMarker();
			}
		}
		
		public function hideBodyMarker():void {
			_markerEnd.visible = false;
			_bodyMarkerGroup.visible = false;
			_cannonMarkerLine.visible = false;
		}
		
		public function updateBodyMarker():void {
			if (isAttachedToGrappler()) {
				updateGrapplerMarker();
			} else if (isAttachedToCannon()) {
				updateCannonMarker();
			}
		}
		
		public function updateGrapplerMarker():void {
			_bodyMarkerTimer += FlxG.elapsed*DOT_SPEED;
			if (_bodyMarkerTimer > 1) {
				_bodyMarkerTimer -= 1;
			}
			var dotNum:int = int(Math.sqrt(Math.pow(_markerEnd.x-_targetBody.x, 2) + Math.pow(_markerEnd.y-_targetBody.y, 2)))/DOT_SPACING;
			for (var n:int = 0; n <= dotNum; n++) {
				if (_bodyMarkerGroup.length <= n) {
					_bodyMarkerGroup.add(new FlxSprite().makeGraphic(2, 2, 0xffffffff));
					// the following is to make sure the initial dot is the right color before propagating it to everything else
					if (_bodyMarkerGroup.length == 1) {
						updateRaytrace();
					}
				}
				if (n > 0) {
					_bodyMarkerGroup.members[n].color = _bodyMarkerGroup.members[n-1].color;
				}
				_bodyMarkerGroup.members[n].x = _targetBody.getMidpoint().x + Math.cos(_rad)*DOT_SPACING*(n + _bodyMarkerTimer);
				_bodyMarkerGroup.members[n].y = _targetBody.getMidpoint().y + Math.sin(_rad)*DOT_SPACING*(n + _bodyMarkerTimer);
				_bodyMarkerGroup.members[n].alpha = PlayState.current.alp;
			}
			for (; n < _bodyMarkerGroup.length; n++) {
				_bodyMarkerGroup.members[n].alpha = 0;
			}
			_bodyMarkerGroup.visible = true;
		}
		
		public function updateCannonMarker():void {
			_cannonMarkerLine.x = x + width/2.0 + (_cannonMarkerLine.height/2.0)*Math.cos(_rad);
			_cannonMarkerLine.y = y + height/2.0 - _cannonMarkerLine.height/2.0 + (_cannonMarkerLine.height/2.0)*Math.sin(_rad);
			_cannonMarkerLine.angle = _aimAngle-90;
			_cannonMarkerLine.alpha = PlayState.current.alp;
		}
		
		public function updateRaytrace():void {
			_markerEnd.angle = _aimAngle-90; //set to hand's angle?
			_markerEnd.x = x; //change these and while statement back to hand.x/y if making _markerEnd its own class
			_markerEnd.y = y;
			_markerEnd.velocity.x = GRAPPLE_SPEED*Math.cos(_rad);
			_markerEnd.velocity.y = GRAPPLE_SPEED*Math.sin(_rad);
			_markerEnd.maxVelocity.x = Number.MAX_VALUE;
			_markerEnd.maxVelocity.y = Number.MAX_VALUE;
			_markerEnd.drag.x = 0;
			_markerEnd.drag.y = 0;
			//_markerEnd.color = Math.min(col*2, 0x00ff00/*0xff0000*/);
			_markerEnd.visible = false;
			_bodyMarkerGroup.setAll("color", 0xff0000);
			while (Math.sqrt(Math.pow(_markerEnd.x-x, 2) + Math.pow(_markerEnd.y-y, 2)) < GRAPPLE_LENGTH) {
				_markerEndGroup.update();
				if (FlxG.collide(PlayState.current.levelFunctional, _markerEnd, _markerEnd.raytraceCallback)) {
					break;
				}
			}
			if (FlxG.overlap(_markerEnd, PlayState.current.buttonGroup)) { //reword as callback?
				setGrappleButton();
			}
			_markerEnd.velocity.x = 0;
			_markerEnd.velocity.y = 0;
		}
		
		public function setTarget(body:SprBody, type:int):void {
			_targetBody = body;
			_targetBodyType = type;
		}
		
		public function isAttachedToGrappler():Boolean {
			return _isInGrappler;
		}
		
		public function isAttachedToCannon():Boolean {
			return _isInCannon;
		}
		
		public function isAttachedToBody():Boolean {
			return _isInGrappler || _isInCannon;
		}
		
		public function isOnGround():Boolean {
			return _movementState == GROUND;
		}
		
		public function isFalling():Boolean {
			return _movementState == FALLING;
		}
		
		public function isRoundingCorner():Boolean {
			return _movementState == CORNER;
		}
		
		public function isIdle():Boolean {
			return isOnGround() && _bodyState == IDLE;
		}
		
		public function isExtending():Boolean {
			return _bodyState == EXTENDING;
		}
		
		public function isRetracting():Boolean {
			return _bodyState == RETRACTING;
		}
		
		//sets a as an angle with the range (-180, 180]
		private function trueAngle(a:Number):Number {
			var r:Number = a % 360;
			if (r <= -180) {
				r += 360;
			} else if (r > 180) {
				r -= 360;
			}
			return r;
		}
		
		//finds smallest difference between two angles
		private function angleDifference(a:Number, b:Number):Number {
			var tA:Number = trueAngle(a);
			var tB:Number = trueAngle(b);
			
			var d1:Number = tA-tB;
			var d2:Number = d1>=0?d1-360:d1+360;
			if (Math.abs(d1) < Math.abs(d2)) {
				return d1;
			}
			return d2;
		}
		
		private function addToAimAngle(a:Number):void {
			_aimAngle += a;
			_rad = Math.PI*_aimAngle/180;
		}
		
		private function setAimAngle(a:Number):void {
			_aimAngle = a;
			_rad = Math.PI*_aimAngle/180;
		}
		
		public function getAimAngle():Number { // when arm function is moved in, delete this
			return _aimAngle;
		}
		
		/*
		private function hideHeart():void {
		_heart.visible = false;
		}
		
		private function showHeart():void {
		_heart.visible = true;
		}
		
		override public function draw():void {
		super.draw();
		if (_heart.visible) {
		_heart.x = x;
		_heart.y = y;
		_heart.draw();
		}
		}
		*/
	}
}