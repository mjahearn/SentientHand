package {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import flashx.textLayout.formats.Float;
	
	import org.flixel.*;
	import org.flixel.system.FlxTile;
	
	public class PlayState extends FlxState {
						
		private var hintPointsLeftRight:FlxGroup;
		private var hintPointsJump:FlxGroup;
		private var hintPointsAttachDetach:FlxGroup;
		
		private var isTransitioningToNextLevel:Boolean;
		
		
		public static var current:PlayState;
		
		public const FLOOR_JUMP_VEL:Number = 200; //initial velocity (in pixels per second) of a hand jumping from the floor
		
		public const EMPTY_SPACE:uint = 0; // index of empty space in tilemap
				
		public var levelFunctional:FlxTilemap;
		
		public const GEAR_MIN:uint = 1;
		public const GEAR_MAX:uint = 18;
		public const TRASH_SPAWN:uint = 31;
		//public const JUMP_HINT_SPAWN:uint = 32;
		//public const SIGN_SPAWN:uint = 33;
		
		//button animation frames
		//public const BUTTON_PRESSED:uint = 0;
		//public const BUTTON_INIT:uint = 1;
		
		public var pause:PauseState;
		
		public var touchedExitPoint:Boolean = false;
		
		public var time:Number = 0;
		public var IDLE_TIME:Number = 15;
		
		public var pulseTimer:Number = 0;
		public var pulseTimeMax:Number = 2.2;
		public var pulseDir:Number = 1;
		
		public var dbg:int;
		
		//public var jumpHintGroup:FlxGroup = new FlxGroup();
		
		public var electricityNum:int = 1;
		
		public var levelCosmeticFront:FlxTilemap;
		
		public var sprControllableGroup:FlxGroup;

		public var hand:SprHand;

		public var bodyGroup:FlxGroup;
		public var curBody:uint;
		public var curCannon:uint;
		public var bodyGearGroup:FlxGroup;
		public var bodyHeadGroup:FlxGroup;
		
		public var bodyArmBaseGroup:FlxGroup = new FlxGroup();
		public var cannonArmBaseGroup:FlxGroup = new FlxGroup();
		
		public var overlay:FlxSprite = new FlxSprite();
		
		public var arms:FlxGroup = new FlxGroup();
		public const numArms:int = 22;
		
		public var lastVel:FlxPoint; //last nonzero hand velocity - used for convex corners
		
		public var gearInGroup:FlxGroup = new FlxGroup();
		public var gearOutGroup:FlxGroup = new FlxGroup();
		
		//public var handReturnedToBody:Boolean = false;
		
		public var buttonGroup:FlxGroup = new FlxGroup();
		//public var buttonStateArray:Array = new Array();
		//public var buttonReactionArray:Array = new Array();
		//public var buttonMode:uint;
		//public var buttonBangGroup:FlxGroup = new FlxGroup();
		
		public var markerLine:FlxSprite;
		//public var hintArrow:FlxSprite = new FlxSprite();
		//public var exitArrow:FlxSprite = new FlxSprite();
		public var exitRad:Number;
		//public var exitOn:Boolean;
		public var col:uint; //pulse color
		public var alp:Number; //pulse alpha
		
		public var cannonGroup:FlxGroup = new FlxGroup();
		
		public var exitPoint:FlxPoint = new FlxPoint();
		
		public var trashGroup:FlxGroup = new FlxGroup();
		public var lastTouchedDirt:Boolean;
		
		public var reversePolarity:Boolean;
		
		[Embed("assets/sprites/spr_cannon.png")] public var cannonSheet:Class;
		
		//[Embed("assets/trash.png")] public var trashSheet:Class;
		
		[Embed("assets/sprites/spr_arm_base.png")] public var armBaseSheet:Class;
		
		//[Embed("assets/sprites/arrow.png")] public var arrowSheet:Class;
		[Embed("assets/sprites/spr_arm.png")] public var armSheet:Class;
		[Embed("assets/sprites/spr_body.png")] public var bodySheet:Class;
		
		//[Embed("assets/gear_64x64.png")] public var gear64x64Sheet:Class;
		//[Embed("assets/gear_32x32.png")] public var gear32x32Sheet:Class;
		//[Embed("assets/gear_16x16.png")] public var gear16x16Sheet:Class;
		
		//[Embed("assets/sprites/sign.png")] public var signSheet:Class;
		
		[Embed("assets/sprites/spr_bodygear.png")] public var bodyGearSheet:Class;
				
		[Embed("assets/audio/Grapple_Extend.mp3")] public var grappleExtendSFX:Class;
		[Embed("assets/audio/Robody_Aim.mp3")] public var robodyAimSFX:Class;
		[Embed("assets/audio/Pipe_Walk.mp3")] public var pipeWalkSFX:Class;
		[Embed("assets/audio/Robody_LandOnPipe.mp3")] public var robodyLandOnPipeSFX:Class;
		[Embed("assets/audio/Robody_LandOnWall.mp3")] public var robodyLandOnWallSFX:Class;
		[Embed("assets/audio/Hand_Landing_On_Metal.mp3")] public var handLandingOnMetalSFX:Class;
		[Embed("assets/audio/Hand_Landing_On_Nonstick_Metal.mp3")] public var handLandingOnNonstickMetalSFX:Class;
		[Embed("assets/audio/Ambient_Gears.mp3")] public var ambientGearsSFX:Class;

		[Embed("assets/audio/Land_On_Dirt.mp3")] public var handLandingOnDirtSFX:Class;
		
		public var grappleExtendSound:FlxSound = new FlxSound().loadEmbedded(grappleExtendSFX);
		public var robodyAimSound:FlxSound = new FlxSound().loadEmbedded(robodyAimSFX);
		public var pipeWalkSound:FlxSound = new FlxSound().loadEmbedded(pipeWalkSFX);
		public var robodyLandOnPipeSound:FlxSound = new FlxSound().loadEmbedded(robodyLandOnPipeSFX);
		public var robodyLandOnWallSound:FlxSound = new FlxSound().loadEmbedded(robodyLandOnWallSFX);
		public var handLandingOnMetalSound:FlxSound = new FlxSound().loadEmbedded(handLandingOnMetalSFX);
		public var handLandingOnNonstickMetalSound:FlxSound = new FlxSound().loadEmbedded(handLandingOnNonstickMetalSFX);
		public var ambientGearsSound:FlxSound = new FlxSound().loadEmbedded(ambientGearsSFX,true);
		
		public var handLandingOnDirtSound:FlxSound = new FlxSound().loadEmbedded(handLandingOnDirtSFX);
		
		
		[Embed("assets/sprites/spr_head.png")] public var headSheet:Class;
		//[Embed("assets/sky.png")] public var skySheet:Class;
		//[Embed("assets/factory.png")] public var factorySheet:Class;
		
		//[Embed("assets/body_marker_line.png")] public var bodyMarkerLineSheet:Class;
		//public var bodyMarkerLine:FlxSprite = new FlxSprite();
		
		private var hintArrowKeysGroup:FlxGroup;
		private var dripperEvent:EventTimer;
		private var dripGroup:FlxGroup;
		private var roachGroup:FlxGroup;
		private var exitChuteGroup:FlxGroup;
		
		private var musOverlay:FlxSound;
		
		override public function create():void {
			
			current = this;
			setUpAudio();
			
			dbg = 0;
			lastTouchedDirt = false; //ditto
			//doorsDead = false;
			reversePolarity = false;
			sprControllableGroup = new FlxGroup();
			
			FlxG.bgColor = 0xff000000;
			//if (RegistryLevels.isLastLevel()) {
				//FlxG.bgColor = 0xff442288;
				//0xffaaaaaa; //and... if we want motion blur... 0x22000000
				//var sky:FlxSprite = new FlxSprite(0,0,skySheet);
				//sky.scrollFactor = new FlxPoint(0,0);
				//add(sky);
			//}
			
			setUpLevelFunctional();
			// add cosmetic maps in order
			addLevelCosmeticBackBack();
			addLevelCosmeticBack();
			addLevelCosmeticSemiBack();
			addLevelCosmeticMid();
			//addLevelCosmeticFront();
			// add chutes after front layer, so they can go over vent backings
			addExitChutes();
			
			// if there's no cosmetic level, we'll want to see the functional level (in debug)
			if (Registry.DEBUG_ON && levelCosmeticFront.totalTiles <= 0) {add(levelFunctional);}
			
			// the camera needs some special setup because of rotation stuff
			setUpCamera();
			
			// Hand, part 1
			// part 2 is below all the body stuff- we're initializing up here for the benefit of the exit chute, which is layered beneath the bodies and needs the hand's coordinates (should we spawn the hand from the exit chute's coordinates for the sake of code cleanliness?)
			hand = groupFromSpawn(RegistryLevels.kSpawnHand,SprHand,levelFunctional).members[0];
			
			// TEST EXIT CHUTE
			var $exitChute:SprExitChute = new SprExitChute(true,hand.x+hand.width/2-32,hand.y+hand.height/2-48);
			add($exitChute);
			$exitChute.spit();
			
			// CANNONS
			cannonGroup = groupFromSpawn(RegistryLevels.kSpawnLauncher,SprBody,levelFunctional);
			for (var i:uint = 0; i < cannonGroup.length; i++) {
				var cannon:FlxSprite = cannonGroup.members[i];
				cannon.loadGraphic(cannonSheet);
				cannon.facing = FlxObject.DOWN;
				cannon.angle = 0;
			}
			add(cannonGroup);
			cannonArmBaseGroup = groupFromSpawn(RegistryLevels.kSpawnLauncher,FlxSprite,levelFunctional);
			for (i = 0; i < cannonArmBaseGroup.length; i++) {
				var armBase:FlxSprite = cannonArmBaseGroup.members[i];
				armBase.loadGraphic(armBaseSheet);
				armBase.facing = FlxObject.DOWN;
			}
			add(cannonArmBaseGroup);
			
			addButtons();
			
			bodyGearGroup = new FlxGroup();
			bodyHeadGroup = new FlxGroup();
			bodyGroup = groupFromSpawn(RegistryLevels.kSpawnGrappler,SprBody,levelFunctional);
			for (i = 0; i < bodyGroup.length; i++) {
				var body:FlxSprite = bodyGroup.members[i];
				body.loadGraphic(bodySheet);
				var bodyGear:FlxSprite = new FlxSprite(body.x,body.y,bodyGearSheet);
				bodyGearGroup.add(bodyGear);
				// the positioning should be based on angle too
				var bodyHead:FlxSprite = new FlxSprite(body.x,body.y,headSheet);
				bodyHead.y -= bodyHead.height;
				bodyHeadGroup.add(bodyHead);
				
				bodyArmBaseGroup.add(new FlxSprite(body.x,body.y,armBaseSheet));
				body.facing = FlxObject.DOWN;
				
				var theta:Number = (body.angle-90)*Math.PI/180.0;
				
				bodyHead.x = body.x + body.width/2.0 - bodyHead.width/2.0 + (bodyHead.height*1.5)*Math.cos(theta);
				bodyHead.y = body.y + body.height/2.0 - bodyHead.height/2.0 + (bodyHead.height*1.5)*Math.sin(theta);
				bodyHead.angle = body.angle;
				
				bodyGear.x = body.x + body.width/2.0 - bodyGear.width/2.0 + (bodyGear.width/2.0)*Math.cos(theta-Math.PI/2.0);
				bodyGear.y = body.y + body.height/2.0 - bodyGear.height/2.0 + (bodyGear.width/2.0)*Math.sin(theta-Math.PI/2.0);
			}
			add(bodyGroup);
			add(bodyGearGroup);
			add(bodyHeadGroup);
			add(bodyArmBaseGroup);
			
			var arm:FlxSprite;
			for (i = 0; i < numArms; i++) {
				arm = new FlxSprite(0,0,armSheet); //originally body.x/y
				arm.visible = false;
				arms.add(arm);
			}
			add(arms);
			
			addDripperEvent();
			
			// Hand, part 2
			hand.addMarker();
			add(hand);
			hand.addElectricity();
			
			curBody = uint.MAX_VALUE;
			lastVel = new FlxPoint();
			
			pause = new PauseState();
			pause.setAll("exists", false);
			add(pause);
			
			addRoaches();
			
			overlay.makeGraphic(FlxG.width,FlxG.height,0xff000000);
			
			stupidCollisionThing(); // because I took out the hiding part of spawning, but didn't want to create new groups for wood and metal collisions
			
			/*
			// TEST BULB
			var $bulb:SprBulb = new SprBulb(hand.x, hand.y);
			add($bulb);
			// TEST EXIT SIGN
			var $exitSign:SprExit = new SprExit(SprExit.kL,hand.x+hand.width*2,hand.y);
			add($exitSign);
			// TEST WINDOW
			var $window:SprWindow = new SprWindow(hand.x,hand.y-hand.height*8);
			add($window);
			// TEST GRATE
			var $grate:SprGrate = new SprGrate(SprGrate.kBroken0,hand.x,hand.y+hand.height*2);
			add($grate);*/
			// TEST EXIT SIGN
			
		}
		
		private function stupidCollisionThing():void {
			for (var i:uint = 0; i < RegistryLevels.kSpawnEmpty.length; i++) {
				var tmpArray:Array = levelFunctional.getTileInstances(RegistryLevels.kSpawnEmpty[i]);
				if (tmpArray) {
					for (var j:uint = 0; j < tmpArray.length; j++) {
						levelFunctional.setTileByIndex(tmpArray[j],0,false);
					}
				}
			}
		}
		
		private function setUpLevelFunctional():void {
			levelFunctional = RegistryLevels.lvlFunc();
			// this section used to deal with all the collision shit- but then tile-based callbacks were removed
			// remember when we had wood? heh...
			
			var $point:FlxPoint;
			// HINT POINTS L/R
			hintPointsLeftRight = new FlxGroup();
			var $callbackLeftRight:Function = function($map:FlxTilemap,$tile:uint):void {
				$point = pointForTile($tile,$map)
				var $spr2:FlxSprite = new FlxSprite($point.x,$point.y);
				hintPointsLeftRight.add($spr2);
				$map.setTileByIndex($tile,0);
			};
			applyFunctionToTile(RegistryLevels.kSpawnHintLeftRight,$callbackLeftRight,levelFunctional);
			// HINT POINTS JUMP
			hintPointsJump = new FlxGroup();
			var $callbackJump:Function = function($map:FlxTilemap,$tile:uint):void {
				$point = pointForTile($tile,$map)
				var $spr1:FlxSprite = new FlxSprite($point.x,$point.y);
				hintPointsJump.add($spr1);
				$map.setTileByIndex($tile,0);
			};
			applyFunctionToTile(RegistryLevels.kSpawnHintJump,$callbackJump,levelFunctional);
			// HINT POINTS ATTACH/DETACH
			hintPointsAttachDetach = new FlxGroup();
			var $callbackAttachDetach:Function = function($map:FlxTilemap,$tile:uint):void {
				$point = pointForTile($tile,$map)
				var $spr0:FlxSprite = new FlxSprite($point.x,$point.y);
				hintPointsAttachDetach.add($spr0);
				$map.setTileByIndex($tile,0);
			};
			applyFunctionToTile(RegistryLevels.kSpawnHintAttachDetach,$callbackAttachDetach,levelFunctional);
		}
		
		private function setUpCamera():void {
			// first handle where the bounds are (for panning)
			FlxG.worldBounds = new FlxRect(0, 0, levelFunctional.width,levelFunctional.height);
			if (Registry.extendedCamera) {
				FlxG.camera.bounds = new FlxRect(-FlxG.width/2, -FlxG.height/2, levelFunctional.width+FlxG.width, levelFunctional.height+FlxG.height);
			} else {
				FlxG.camera.bounds = FlxG.worldBounds;
			}
			//FlxG.camera.zoom = 1.5;
			FlxG.camera.x = -95;
			FlxG.camera.y = -95;
		}
		
		private function setUpAudio():void {
			if (!Registry.SOUND_ON) {
				SoundMixer.soundTransform = new SoundTransform(0);	
			}
			
			var $curMus:FlxSound = RegistryLevels.currentMusic;
			var $curMusOverlay:FlxSound = RegistryLevels.currentMusicOverlay;
			
			var $preMus:FlxSound = RegistryLevels.previousMusic;
			var $preMusOverlay:FlxSound = RegistryLevels.previousMusicOverlay;
			
			musOverlay = $curMusOverlay;
			
			if ($preMus && $curMus != $preMus) {
				add($preMus);
				add($preMusOverlay);
				$preMus.fadeOut(2.2);
				$preMusOverlay.fadeOut(2.2);
			}
			$curMus.play();
			$curMusOverlay.play();
			hideMusicOverlayInstantly();
		}
		
		private function addLevelCosmeticBackBack():void {
			var $lvlCosmBackBack:FlxTilemap = RegistryLevels.lvlCosmBackBack();
			if ($lvlCosmBackBack.totalTiles <= 0) {return;}
			
			$lvlCosmBackBack.scrollFactor = new FlxPoint(0.25, 0.25);
			
			add($lvlCosmBackBack);
		}
		
		private function addLevelCosmeticBack():void {
			var $lvlCosmBack:FlxTilemap = RegistryLevels.lvlCosmBack();
			if ($lvlCosmBack.totalTiles <= 0) {return;}
			
			$lvlCosmBack.scrollFactor = new FlxPoint(0.5, 0.5);
			
			add($lvlCosmBack);
		}
		
		private function addLevelCosmeticSemiBack():void {
			var $lvlCosmSemiBack:FlxTilemap = RegistryLevels.lvlCosmSemiBack();
			if ($lvlCosmSemiBack.totalTiles <= 0) {return;}
			// set the scroll factor, which the objcets it sets will use
			// don't add it, though, because it's all spawn points. gross.
			$lvlCosmSemiBack.scrollFactor = new FlxPoint(0.75, 0.75);
			// add objects from the spawn points
			addBulbs($lvlCosmSemiBack);
		}
		
		private function addBulbs($map:FlxTilemap):void {
			var $bulbGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnSemiBackBulb,SprBulb,$map);
			add($bulbGroup);
			for (var i:uint = 0; i < $bulbGroup.length; i++) {
				var $bulb:SprBulb = $bulbGroup.members[i];
				$bulb.setScrollFactor($map.scrollFactor);
			}
		}
		
		private function addLevelCosmeticMid():void {
			var $lvlCosmMid:FlxTilemap = RegistryLevels.lvlCosmMid();
			if ($lvlCosmMid.totalTiles <= 0) {addLevelCosmeticFront();return;}
			
			add($lvlCosmMid);
			addLevelCosmeticFront(); // for now doing this, should change hints later...
			addHints($lvlCosmMid);
			
			
			/*
			// GEARS
			for (var i:int = GEAR_MIN; i <= GEAR_MAX; i++) {
				var gearArray:Array = $lvlCosmMid.getTileInstances(i);
				if (gearArray) {
					for (var j:int = 0; j < gearArray.length; j++) {
						
						// Decide gear spin (In or Out)
						// n.b. Every other gear in the sheet is In or Out
						var gearGroup:FlxGroup;
						if (i%2 == 0) {gearGroup = gearInGroup;}
						else {gearGroup = gearOutGroup;}
						
						// Decide gear size
						// n.b. Gears are grouped by 3 speeds, then by 2 sizes, then 2 spins
						var gearSheet:Class;
						var gearGaugeNumber:Number = (i-GEAR_MIN)%6;
						if (gearGaugeNumber < 2) {gearSheet = gear64x64Sheet;}
						else if (gearGaugeNumber < 4) {gearSheet = gear32x32Sheet;}
						else {gearSheet = gear16x16Sheet;}
						
						// do something for gear speed...?  Do we need gears to spin at different speeds?  Maybe not...
						
						var gearPoint:FlxPoint = pointForTile(gearArray[j],$lvlCosmMid);
						var gear:FlxSprite = new FlxSprite(gearPoint.x,gearPoint.y,gearSheet);
						gearGroup.add(gear);
					}
				}
			}
			add(gearInGroup);
			add(gearOutGroup);
			
			// TRASH
			var trashArray:Array = $lvlCosmMid.getTileInstances(TRASH_SPAWN);
			if (trashArray) {
				var trashValidFrames:Array = [0,1,2,3,4,5,6,7];//,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,27,28,29,33,34];
				var trashValidAngles:Array = [90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270];
				for (j = 0; j < trashArray.length; j++) {
					var trashPoint:FlxPoint = pointForTile(trashArray[j],$lvlCosmMid);
					var trash:FlxSprite = new FlxSprite(trashPoint.x,trashPoint.y);
					trash.loadGraphic(trashSheet,true,false,32,32,true);
					trash.color = 0xff555555;
					trash.frame = trashValidFrames[int(Math.random()*(trashValidFrames.length-1))];
					trash.angle = trashValidAngles[int(Math.random()*(trashValidAngles.length-1))];
					trash.immovable = true;
					trashGroup.add(trash);
				}
			}
			add(trashGroup);
			*/
			
			//addBulbs($lvlCosmMid);
		}
		
		private function addLevelCosmeticFront():void {
			levelCosmeticFront = RegistryLevels.lvlCosmFront();
			if (levelCosmeticFront.totalTiles <= 0) {return;}
			
			/*
			// sign
			var signArray:Array = midground.getTileInstances(SIGN_SPAWN);
			if (signArray) {
			midground.setTileProperties(SIGN_SPAWN,FlxObject.NONE);
			for (j = 0; j < signArray.length; j++) {
			var signPoint:FlxPoint = pointForTile(signArray[j],midground);
			midground.setTileByIndex(signArray[j],0);
			add(new FlxSprite(signPoint.x, signPoint.y, signSheet));
			}
			}*/
			
			add(levelCosmeticFront);
		}
		
		private function addExitChutes():void {
			exitChuteGroup = new FlxGroup();
			var $exitChuteTmpGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnExit,FlxSprite,levelFunctional);
			for (var i:uint = 0; i < $exitChuteTmpGroup.length; i++) {
				var $spr:FlxSprite = $exitChuteTmpGroup.members[i];
				//$spr.x += 20;
				//$spr.y += 20;
				var $exitChute:SprExitChute = new SprExitChute(false,$spr.x,$spr.y);
				exitChuteGroup.add($exitChute);
			}
			add(exitChuteGroup);
		}
		
		private function addButtons():void {
			buttonGroup = new FlxGroup();
			
			var i:uint;
			var tmpBtn:SprButton;
			
			// DOWN
			var buttonDGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnButtonD,SprButton,levelFunctional);
			for (i = 0; i < buttonDGroup.length; i++) {
				tmpBtn = buttonDGroup.members[i];
				tmpBtn.orientation = SprButton.kDown;
			}
			addMembersInGroupToGroup(buttonDGroup,buttonGroup);
			
			// RIGHT
			var buttonRGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnButtonR,SprButton,levelFunctional);
			for (i = 0; i < buttonRGroup.length; i++) {
				tmpBtn = buttonRGroup.members[i];
				tmpBtn.orientation = SprButton.kRight;
			}
			addMembersInGroupToGroup(buttonRGroup,buttonGroup);
			
			// UP
			var buttonUGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnButtonU,SprButton,levelFunctional);
			for (i = 0; i < buttonUGroup.length; i++) {
				tmpBtn = buttonUGroup.members[i];
				tmpBtn.orientation = SprButton.kUp;
			}
			addMembersInGroupToGroup(buttonUGroup,buttonGroup);
			
			// LEFT
			var buttonLGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnButtonL,SprButton,levelFunctional);
			for (i = 0; i < buttonLGroup.length; i++) {
				tmpBtn = buttonLGroup.members[i];
				tmpBtn.orientation = SprButton.kLeft;
			}
			addMembersInGroupToGroup(buttonLGroup,buttonGroup);
			
			for (i = 0; i < buttonGroup.length; i++) {
				tmpBtn = buttonGroup.members[i];
				tmpBtn.reactionToPress = buttonReaction;
			}
			
			add(buttonGroup);
		}
		
		private function addMembersInGroupToGroup(tmpFrom:FlxGroup,tmpTo:FlxGroup):void {
			for (var i:uint = 0; i < tmpFrom.length; i++) {
				tmpTo.add(tmpFrom.members[i]);
			}
		}
		
		private function addHints($lvl:FlxTilemap):void {
			
			var $hintGroup:FlxGroup = new FlxGroup();
			
			var i:uint;
			var $hint:SprHint;
			
			var $debugCounter:uint = 0;
			
			// HINT 0
			var $hint0Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint0,SprHint,$lvl);
			for (i = 0; i < $hint0Group.length; i++) {
				$hint = $hint0Group.members[i];
				$hint.text = "SCRAP cannot press the LEFT or RIGHT ARROW KEYS to MOVE.";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 1
			var $hint1Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint1,SprHint,$lvl);
			for (i = 0; i < $hint1Group.length; i++) {
				$hint = $hint1Group.members[i];
				$hint.text = "Do NOT push the button. It's very bad. Very, very bad.";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 2
			var $hint2Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint2,SprHint,$lvl);
			for (i = 0; i < $hint2Group.length; i++) {
				$hint = $hint2Group.members[i];
				$hint.text = "SCRAP definitely cannot enter ducts.";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 3
			var $hint3Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint3,SprHint,$lvl);
			for (i = 0; i < $hint3Group.length; i++) {
				$hint = $hint3Group.members[i];
				$hint.text = "SCRAP certainly is unable to press UP to detach from surfaces";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 4
			var $hint4Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint4,SprHint,$lvl);
			for (i = 0; i < $hint4Group.length; i++) {
				$hint = $hint4Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 5
			var $hint5Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint5,SprHint,$lvl);
			for (i = 0; i < $hint5Group.length; i++) {
				$hint = $hint5Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 6
			var $hint6Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint6,SprHint,$lvl);
			for (i = 0; i < $hint6Group.length; i++) {
				$hint = $hint6Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			// HINT 7
			var $hint7Group:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnMidHint7,SprHint,$lvl);
			for (i = 0; i < $hint7Group.length; i++) {
				$hint = $hint7Group.members[i];
				$hint.text = "HINT " + $debugCounter + " NOT YET IMPLEMENTED";
				$hint.angle = 0;
				$hintGroup.add($hint);
			}
			$debugCounter++;
			
			for (i = 0; i < $hintGroup.length; i++) {
				$hint = $hintGroup.members[i];
				$hint.x += Number($lvl.width/$lvl.widthInTiles)/2.0 - $hint.width/2.0;
				$hint.y += Number($lvl.height/$lvl.heightInTiles)/2.0 - $hint.height/2.0;
			}
			
			add($hintGroup);
			
		}
		
		private function addDripperEvent():void {
			
			/*
			dripGroup = new FlxGroup();
			
			var $dripMarkerGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnDrip,FlxSprite,level);
			for (var i:uint = 0; i < $dripMarkerGroup.length; i++) {
				var $spr:FlxSprite = $dripMarkerGroup.members[i];
				
				var $drip:SprDrip = new SprDrip($spr.x,$spr.y);
				dripGroup.add($drip);
				
				var $maybeDrip:Function = function():void {
					//if (!$drip.alive && maybe()) {
						$drip.x = $spr.x;
						$drip.y = $spr.y;
						add($drip);
					//}
				};
				
				var $dripperTimer:EventTimer = new EventTimer(1.1 + Math.random()*2.2,$maybeDrip);
				add($dripperTimer);
			}*/
			
			
			dripGroup = new FlxGroup();
			var tmpMaybeDrip:Function = function():void {
				
				var tmpDripGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnDrip,SprDrip,levelCosmeticFront);
				
				for (var i:uint = 0; i < tmpDripGroup.length; i++) {
					var tmpDrip:SprDrip = tmpDripGroup.members[i];
					if (maybe()) {
						add(tmpDrip);
						dripGroup.add(tmpDrip);
					}
				}
			};
			
			dripperEvent = new EventTimer(2.2,tmpMaybeDrip);
			add(dripperEvent);
			
			
			
			/*
			dripGroup = new FlxGroup();
			
			var $dripSpriteGroup:FlxGroup = groupFromSpawn(RegistryLevels.kSpawnDrip,SprDrip,levelCosmeticFront);
			var $dripSprite:SprDrip;
			var $maybeDrip:Function;
			var $dripEvent:EventTimer;
			
			for (var i:uint = 0; i < $dripSpriteGroup.length; i++) {
				$dripSprite = $dripSpriteGroup.members[i];
				
				var $x:Number = $dripSprite.x;
				Registry.log($x);
				
				$maybeDrip = function():void {
					if (maybe()) {
						var $newDripSprite:SprDrip = $dripSprite.refreshedCopy();
						add($newDripSprite);
						dripGroup.add($newDripSprite);
						
						Registry.log($x);
					}
				};
				
				$dripEvent = new EventTimer(2.2 + Math.random()*2.2,$maybeDrip);
				add($dripEvent);
			}
			*/
			
			
			
		}
		
		private function maybe():Boolean {
			return Math.random()*2 > 1;
		}
		
		private function addRoaches():void {
			roachGroup = groupFromSpawn(RegistryLevels.kSpawnRoaches,SprRoach,levelCosmeticFront);
			add(roachGroup);
		}
		
		private function checkIfHandExitedViaChute():void {
			// don't do this if the hand is in a body
			if (hand.isAttachedToBody() && !hand.isFalling()) {return;}
			// get the overlapped chute (can use for exit anim positioning)
			var $exitChute:SprExitChute = overlappedChute();
			// only continue if there's an overlap
			if (!$exitChute) {return;}
			/*
			// then exit on the action key press
			if (FlxG.keys.justPressed(RegistryControls.BODY_KEY)) {
				// just place it in the center for now
				//hand.x = $exitChute.x + $exitChute.width/2 - hand.width/2;
				//hand.y = $exitChute.y + $exitChute.height/2 - hand.height/2;
				goToNextLevel();
			}*/
			// we want the hand to be fully enclosed by the chute
			if (hand.x >= $exitChute.x &&
				hand.x + hand.width <= $exitChute.x + $exitChute.width &&
				hand.y >= $exitChute.y &&
				hand.y + hand.height <= $exitChute.y + $exitChute.height) {
				goToNextLevel();
				
				// then stick the hand in the center for now
				hand.x = $exitChute.x + $exitChute.width/2 - hand.width/2;
				hand.y = $exitChute.y + $exitChute.height/2 - hand.height/2;
			}
		}
		
		private function overlappedChute():SprExitChute {
			for (var i:uint = 0; i < exitChuteGroup.length; i++) {
				var $exitChute:SprExitChute = exitChuteGroup.members[i];
				if (hand.overlaps($exitChute)) {
					return $exitChute;
				}
			}
			return null;
		}
				
		override public function update():void {
			
			checkHintBubbles();
			
			checkIfHandExitedViaChute();
			
			pulseTimer += pulseDir*FlxG.elapsed;
			if (pulseTimer >= pulseTimeMax) {pulseTimer = pulseTimeMax;}
			if (pulseTimer <= 0) {pulseTimer = 0;}
			if (pulseTimer <= 0 || pulseTimer >= pulseTimeMax) {
				pulseDir *= -1;
			}
			
			/*
			steamTimer += FlxG.elapsed;
			if (steamTimer > steamTimerMax) {
				steamTimer = 0;
			}*/
				
			if (RegistryLevels.isLastLevel()) {overlay.alpha = 1 - Math.abs(levelFunctional.width - hand.x)/levelFunctional.width;}
			//if (Registry.levelNum >= 5) {overlay.alpha = 1 - Math.abs(level.width - hand.x)/level.width;}
			
			if (hand.isAttachedToBody() && !hand.isExtending() && (!FlxG.keys.RIGHT && !FlxG.keys.LEFT)) {
			//if ((bodyMode || hand.isAttachedToCannon()) && !hand.isExtending() && (!FlxG.keys.RIGHT && !FlxG.keys.LEFT)) {
				time += FlxG.elapsed;
			} else if (!hand.isAttachedToBody() && hand.velocity.x == 0 && hand.velocity.y == 0) {
			//} else if ((!bodyMode && !hand.isAttachedToCannon()) && hand.velocity.x == 0 && hand.velocity.y == 0) {
				time += FlxG.elapsed;
			} else {
				time = 0;
			}
			if (time > IDLE_TIME) {
				time = IDLE_TIME;
			}
			if (FlxG.paused) {
				time = 0;
			}
			
			// escape for debugging (should remove later)
			if (FlxG.keys.justPressed("ESCAPE") && Registry.DEBUG_ON) {
				FlxG.switchState(new LevelSelect);
			}
			
			if (hand.x > FlxG.worldBounds.right || hand.x < FlxG.worldBounds.left ||
				hand.y > FlxG.worldBounds.bottom || hand.y < FlxG.worldBounds.top) {
				//if (doorsDead || RegistryLevels.isLastLevel()) {
				//maybe replace the old doorsDead check with a check to see if the hand is in the right place?
					//goToNextLevel();
				//} else {
					FlxG.resetState();
				//}
			}
			
			RegistryControls.update();
			
			//time += FlxG.elapsed;
			// PRECONDITION: if bodyMode, then curBody < uint.MAX_VALUE
			var body:SprBody;
			var bodyGear:FlxSprite;
			var bodyHead:FlxSprite;
			var armBase:FlxSprite;

			var enteringCannon:Boolean = false;
			var enteringBody:Boolean = false;
			
			if (!hand.isAttachedToBody()) {
			//if (!bodyMode && !hand.isAttachedToCannon()) {
				curBody = handOverlapsBody();
				curCannon = handOverlapsCannon();
			
				if (curBody < uint.MAX_VALUE && curCannon < uint.MAX_VALUE) {
					var closeBody:SprBody = bodyGroup.members[curBody];
					var closeCannon:SprBody = cannonGroup.members[curCannon];
					var handToBody:Number = Math.pow(hand.x + hand.width/2.0 - closeBody.x - closeBody.width/2.0,2) + Math.pow(hand.y + hand.height/2.0 - closeBody.y - closeBody.height/2.0,2);
					var handToCannon:Number = Math.pow(hand.x + hand.width/2.0 - closeCannon.x - closeCannon.width/2.0,2) + Math.pow(hand.y + hand.height/2.0 - closeCannon.y - closeCannon.height/2.0,2);
					if (handToCannon < handToBody) {
						enteringCannon = true;
						hand.setTarget(closeCannon, SprHand.CANNON);
					} else {
						enteringBody = true;
						hand.setTarget(closeBody, SprHand.GRAPPLER);
					}
				} else if (curBody < uint.MAX_VALUE) {
					enteringBody = true;
					hand.setTarget(bodyGroup.members[curBody], SprHand.GRAPPLER);
				} else if (curCannon < uint.MAX_VALUE) {
					enteringCannon = true;
					hand.setTarget(cannonGroup.members[curCannon], SprHand.CANNON);
				} else {
					hand.setTarget(null, SprHand.NONE);
				}
			}
			
			//var touchingMetal:Boolean = (hand.isOnGround() && hand.isMetalInDir(hand.facing)); //USE ONLY FOR GRAPHICS + AUDIO; THIS MAY CHANGE DURING CONTROLS SECTION
			
			if (enteringBody || hand.isAttachedToGrappler()) {
			//if (enteringBody || bodyMode) {
				body = bodyGroup.members[curBody];
				bodyGear = bodyGearGroup.members[curBody];
				bodyHead = bodyHeadGroup.members[curBody];
				armBase = bodyArmBaseGroup.members[curBody];
			} else if (enteringCannon || hand.isAttachedToCannon()) {
				body = cannonGroup.members[curCannon];
				armBase = cannonArmBaseGroup.members[curCannon];
			}
			
			/*
			if (bodyMode) {
				body = bodyGroup.members[curBody];
				bodyGear = bodyGearGroup.members[curBody];
				bodyHead = bodyHeadGroup.members[curBody];
				armBase = bodyArmBaseGroup.members[curBody];
			} if (hand.isAttachedToCannon()) {
				body = cannonGroup.members[curCannon];
				armBase = cannonArmBaseGroup.members[curCannon];
			}*/
			
			if (hand.overlapsPoint(exitPoint)) {
				touchedExitPoint = true;
			}
			
			/*if (exitOn) {
				if (exitPoint.x < FlxG.camera.scroll.x || exitPoint.x >= FlxG.camera.scroll.x + FlxG.width ||
					exitPoint.y < FlxG.camera.scroll.y || exitPoint.y >= FlxG.camera.scroll.y + FlxG.height) {
					if (!exitArrow.visible) {
						if (!touchedExitPoint) {
							exitArrow.visible = true;
						}
					}
					var exitX:Number = exitPoint.x - FlxG.camera.scroll.x - FlxG.width/2;
					var exitY:Number = exitPoint.y - FlxG.camera.scroll.y - FlxG.height/2;
					var exitA:Number = Math.atan2(exitY, exitX);
					exitArrow.angle = exitA*180/Math.PI;
					exitArrow.x = FlxG.width/2 + Math.cos(exitA) * exitRad - exitArrow.width/2;
					exitArrow.y = FlxG.height/2 + Math.sin(exitA) * exitRad - exitArrow.height/2;
				} else if (exitArrow.visible) {
					exitArrow.visible = false;
				}
			}*/
			
			/* else if (hand.isAttachedToCannon()) {
				rad = arrow.angle*Math.PI/180;
				startX = hand.x+hand.width/2.0;
				startY = hand.y+hand.height/2.0;
				endX = startX + GRAPPLE_LENGTH * Math.cos(rad) / 4.0;
				endY = startY + GRAPPLE_LENGTH * Math.sin(rad) / 4.0;
				markerLine.drawLine(startX,startY,endX,endY,0xFFad0222,2);
			}
			markerLine.alpha = 0.22 + 0.78*pulseTimer/pulseTimeMax;
			*/
			/*
			// hint arrow
			hintArrow.fill(0x00000000);
			
			
			if (doorsDead) {
				startX = hand.x+hand.width/2.0;
				startY = hand.y+hand.height/2.0;
				endX = exitPoint.x;
				endY = exitPoint.y;
				hintArrow.drawLine(startX,startY,endX,endY,0xFFad0222,2);
			}
			*/
			
			// hint system
			//theta = (hand.angle)*Math.PI/180.0;
			/*
			hint.x = hand.x + hand.width - hint.width/2.0;// + (hint.width/2.0)*Math.sin(theta);
			hint.y = hand.y + hand.height - hint.height;// - (hint.height/2.0)*Math.cos(theta);
			//hint.angle = hand.angle;
			*/
			
			// marker glow (for hand overlapping)
			hand.setColor(poleCol); //retrieved through get function below
			for (var mmm:String in bodyGroup.members) {
				bodyGroup.members[mmm].color = 0xaaaaaa;
				bodyArmBaseGroup.members[mmm].color = 0xffffff;
				bodyGearGroup.members[mmm].color = 0xaaaaaa;
				bodyHeadGroup.members[mmm].color = 0xaaaaaa;
			}
			for (mmm in cannonGroup.members) {
				cannonGroup.members[mmm].color = 0xaaaaaa;
				cannonArmBaseGroup.members[mmm].color = 0xffffff;
			}
			for (mmm in arms.members) {
				arms.members[mmm].color = poleCol;
			}
			
			var handOnJumpGroup:Boolean = false;/*
			for (var tt:uint = 0; tt < jumpHintGroup.length; tt++) {
				if (hand.overlaps(jumpHintGroup.members[tt])) {
					handOnJumpGroup = true;
				}
			}*/
			
			var pulseNum:Number = int((pulseTimer/pulseTimeMax)*5) + 7;
			if (pulseNum >= 15) {pulseNum = 15;}
			if (pulseNum <= 7) {pulseNum = 7;}
			//col = pulseNum*Math.pow(16,4) + pulseNum*Math.pow(16,5);
			col = pulseNum*Math.pow(16,2) + pulseNum*Math.pow(16,3);
			alp = 0.22 + 0.78*pulseTimer/pulseTimeMax;
			
			if (!hand.isAttachedToBody()) {
			//if (!hand.isAttachedToCannon() && !bodyMode) {
				/*
				if (time >= IDLE_TIME) {
					hint.play("enter");
				} else if ((enteringBody || enteringCannon ) && Registry.neverEnteredBodyOrCannon) {
					hint.play("Z");
				}*/
				// arrow hint (uncomment if you want it, I think it's kind of ugly though...)
				/*
				else if (Registry.neverCrawled) {
					if (hand.velocity.x != 0 || hand.velocity.y != 0 && hand.isOnGround()) {
						Registry.neverCrawled = false;
					} else {
						hint.play("arrows");
					}
				}
				*/
				//
				/*
				else if (Registry.neverJumped && handOnJumpGroup && hand.angle == 90) {
					hint.play("X");
				} else {
					hint.play("idle");
				}
				*/
				if (enteringBody) {
					hand.color = col;
					body.color = col;
					armBase.color = col;
					bodyGear.color = col;
					bodyHead.color = col;
				} else if (enteringCannon) {
					hand.color = col;
					body.color = col;
					armBase.color = col;
				}
			} else if (hand.isAttachedToBody()) {
			//} else if (hand.isAttachedToCannon() || bodyMode) {
				/*
				if (time >= IDLE_TIME) {
					hint.play("enter");
				} else if (Registry.neverAimedBodyOrCannon) {
					hint.play("arrows");
				} else if (Registry.neverFiredBodyOrCannon) {
					hint.play("left X right");
				} else {
					hint.play("idle");
				}*/
				if (hand.isAttachedToCannon()) {
					body.color = poleCol;
					armBase.color = poleCol;
				} else if (hand.isAttachedToGrappler()) {
					body.color = poleCol;
					armBase.color = poleCol;
					bodyGear.color = poleCol;
					bodyHead.color = poleCol;
				}
			}
			/*
			if (FlxG.paused) {
				hint.play("idle");
			}
			*/
			/* Begin Audio */
			// Something's not quite right here...
			
			// The hand is in the body, aiming
			if (hand.isAttachedToBody() && hand.isIdle()) {
			//if ((bodyMode || hand.isAttachedToCannon()) && !hand.isExtending() && !handIn) {
				grappleExtendSound.stop();
				if ((FlxG.keys.RIGHT || FlxG.keys.LEFT) && -270 < hand.angle - body.angle && hand.angle - body.angle < -90) {
					robodyAimSound.play();
				} else {
					robodyAimSound.stop();
				}
			}
				// The hand is launching out of the body
			else if (hand.isAttachedToGrappler() && (hand.isExtending() || hand.isRetracting())) {
			//else if (bodyMode && (hand.isExtending() || handIn)) {
				robodyLandOnWallSound.stop();
				robodyAimSound.stop();
				if (hand.velocity.x !=0 || hand.velocity.y != 0 || body.velocity.x != 0 || body.velocity.y != 0) {
					grappleExtendSound.play();
				} else {
					grappleExtendSound.stop();
				}
			} else {
				grappleExtendSound.stop();
				robodyAimSound.stop();
			}
			
			// The body just hit a wall
			if (hand.isAttachedToGrappler() && hand.isRetracting() && hand.overlaps(body) && ((hand.angle < body.angle - 270) || (body.angle - 90 < hand.angle))) {
			//if (bodyMode && hand.isRetracting() && hand.overlaps(body) && ((hand.angle < body.angle - 270) || (body.angle - 90 < hand.angle))) {
				robodyLandOnWallSound.play();
			}
			
			// hand electricity
			/*if (touchingMetal) {
				ambientElectricalHumSound.play();
			} else {
				ambientElectricalHumSound.stop();
			}*/
			
			// hand landed
			//if ((lastVel.x != 0 && lastVel.y != 0) || handFalling) {
			if (!lastTouchedDirt) {
				if (hand.justTouched(FlxObject.ANY)) {
					handLandingOnDirtSound.stop();
					if (!hand.isMetalInDir(hand.facing)) {
						handLandingOnMetalSound.stop();
						handLandingOnMetalSound.play();
					} else {
						handLandingOnNonstickMetalSound.stop();
						handLandingOnNonstickMetalSound.play();
					}
				}
			} else if (hand.justTouched(FlxObject.ANY)) {
				handLandingOnNonstickMetalSound.stop();
				handLandingOnMetalSound.stop();
				handLandingOnDirtSound.play();
			}
			//}
			
			
			// button press, gears, steam
			/*
			for (var qq:uint = 0; qq < buttonGroup.length; qq++) {
				var button:FlxSprite = buttonGroup.members[qq];
				var buttonState:Boolean = buttonStateArray[qq];
				if (button.frame != BUTTON_PRESSED && (hand.overlaps(button) && !buttonState)) {
					buttonPressSound.stop();
					buttonPressSound.play();
				}
			*/
				/*
				if (button.frame == 2) {
					ambientGearsSound.play();
				}
				if (button.frame == 3) {
					ambientSteamSound.play();
				}
				*/
				/*
			}*/
			
			checkIfButtonPressedByHand();
			
			/*
			for (var qq:uint = 0; qq < steams.length; qq++) {
				if (steams.members[qq].frame == 1) {
					ambientSteamSound.stop();
					ambientSteamSound.play();
				}
			}*/
			
			
			// door open
			/*for (var ab:int = doorGroup.length-1; ab >= 0; ab--) {
				if (doorGroup.members[ab].frame == 1) {
					doorOpenSound.stop();
					doorOpenSound.play();
					ambientGearsSound.play();
				}
			}*/
			/* End Audio */
			
			// less janky way of getting gears/heads to move with body...
			if (hand.isAttachedToGrappler()) {
			//if (bodyMode) {
				
				var theta:Number = (body.angle-90)*Math.PI/180.0;
				
				bodyHead.x = body.x + body.width/2.0 - bodyHead.width/2.0 + (bodyHead.height*1.5)*Math.cos(theta);
				bodyHead.y = body.y + body.height/2.0 - bodyHead.height/2.0 + (bodyHead.height*1.5)*Math.sin(theta);
				bodyHead.angle = body.angle;
				
				bodyGear.x = body.x + body.width/2.0 - bodyGear.width/2.0 + (bodyGear.width/2.0)*Math.cos(theta-Math.PI/2.0);
				bodyGear.y = body.y + body.height/2.0 - bodyGear.height/2.0 + (bodyGear.height/2.0)*Math.sin(theta-Math.PI/2.0);
				bodyGear.angle = -hand.angle;
			}
			if (hand.isAttachedToBody()) {
			//if (bodyMode || hand.isAttachedToCannon()) {
				if (!hand.isExtending()) {
					armBase.angle = hand.angle - 180;
				}
				armBase.x = body.x;
				armBase.y = body.y;
			}
			
			// make arrow pulse
			/*exitArrow.alpha = (6.0 - exitArrow.frame)/6.0 + 0.22;*/
			
			/*
			// Press Buttons!
			for (var mm:uint = 0; mm < buttonGroup.length; mm++) {
				button = buttonGroup.members[mm];
				buttonState = buttonStateArray[mm];
				var bangFrame:Number = buttonBangGroup.members[mm].frame;
				buttonBangGroup.members[mm].alpha = (6.0 - bangFrame)/6.0 + 0.22;
				if (button.frame != BUTTON_PRESSED && hand.overlaps(button) && !buttonState && hand.isOnGround()) { // should change this to make it only recognize the space where the button is visually
					button.frame = BUTTON_PRESSED;
					buttonStateArray[mm] = true;
					buttonReactionArray[mm]();
					//buttonBangGroup.members[mm].kill();*/
					/*for (var bb:String in doorGroup.members) {
						var door:FlxSprite = doorGroup.members[bb];
						if (door.frame == 13) {door.play("pulse 1");}
						else if (14 <= door.frame && door.frame <= 17) {door.play("pulse 2");}
					}*//*
				} else if (button.frame == BUTTON_PRESSED && !hand.overlaps(button) && buttonState) { // should change this to make it only recognize the space where the button is visually
					button.frame = BUTTON_INIT;
					buttonStateArray[mm] = false;
				}
			}*/
			
			// Bring midground to life
				
				// Steam
				
				// Spin Gears // should eventually make them accel into spin
			var gear:FlxSprite;
			for (var jjj:String in gearInGroup.members) {
				gear = gearInGroup.members[jjj];
				gear.angle += 0.5*(64.0/gear.width);
				if (gear.angle > 360) {gear.angle = 0;}
			}
			for (jjj in gearOutGroup.members) {
				gear = gearOutGroup.members[jjj];
				gear.angle -= 0.5*(64.0/gear.width);
				if (gear.angle < 0) {gear.angle = 360;}
			}
			
			/* Begin Animations */
			// The hand is attached to a body
			if (hand.isAttachedToBody()) {
				// The hand is idling in the body
				if (hand.isIdle()) {
					/*body.angle = bodyTargetAngle;
					if (body.angle == 0) {body.facing = FlxObject.DOWN;}
					else if (body.angle == 270) {body.facing = FlxObject.RIGHT;}
					else if (body.angle == 180) {body.facing = FlxObject.UP;}
					else if (body.angle == 90) {body.facing = FlxObject.LEFT;}*/
					
					//formerly adjustBody - can delete?
					if (body.facing == FlxObject.DOWN) {
						body.angle = 0;
					} else if (body.facing == FlxObject.LEFT) {
						body.angle = 90;
					} else if (body.facing == FlxObject.UP) {
						body.angle = 180;
					} else if (body.facing == FlxObject.RIGHT) {
						body.angle = 270;
					}
					
					// Keep arms hidden
					for (var i:String in arms.members) {
						arms.members[i].visible = false;
					}
				}
				// The hand is extended
				else if (hand.isExtending() || hand.isRetracting()) {
					
					// Properly space and rotate the arm segments
					var deltaX:Number = -body.x + hand.x;
					var deltaY:Number = -body.y + hand.y;
					
					var arm:FlxSprite;
					var stupid:int = 0;
					for (var jj:String in arms.members) {
						arm = arms.members[jj];
						arm.visible = true;
						arm.x = body.x + deltaX*(stupid)/numArms + hand.frameWidth/2.0-arm.frameWidth/2.0;
						arm.y = body.y + deltaY*(stupid)/numArms + hand.frameHeight/2.0-arm.frameHeight/2.0;
						stupid = stupid + 1;
						arm.angle = hand.getAimAngle() + 90;
					}
					
					// The hand has come in contact with a wall
					/*if (touchingMetal && !lastTouchedWood) {
						// The arm is retracting while holding
						if (hand.isRetracting() && hand.facing != body.facing) {
							//bodyTargetAngle = hand.angle; 
							//to prevent corner bug, this ^ needs to be set when the body begins to be pulled in (otherwise hand.isRetracting() is false by here if the pulling takes 1 frame)
							
						}
					}*/
				}
			}
			
			/*if (touchingMetal) {
				electricity.play("electricute");
				electricity.angle = hand.angle;
				electricity.x = hand.x;
				electricity.y = hand.y;
				electricity.alpha = (6.0 - electricity.frame)/6.0 + 0.22;
				//electricity.alpha += electricityNum*0.022;
				//if (electricity.alpha <= 0.5 || electricity.alpha >= 1) {
					//electricityNum *= -1;
				//}
			} else {
				electricity.play("stop");
				electricity.alpha = 1;
			}*/
			
			/*
			for (var mn:uint = 0; mn < steams.length; mn++) {
				if (steamsNumberArray[mn] < steamsNumber && int(10*steamTimer) == 10*(steamsNumberArray[mn])) {
					steams.members[mn].play("puff");
					steams.members[mn].x = steamsStartPoint[mn].x - 4.4*steamsDXY[mn].x*steams.members[mn].frame;
					steams.members[mn].y = steamsStartPoint[mn].y - 4.4*steamsDXY[mn].y*steams.members[mn].frame;
					steams.members[mn].alpha = 1 - steams.members[mn].frame/3.0 + 0.5;
				}
			}*/
			
			/* End Animations */
			
			if (hand.isAttachedToBody()) {
				
				// Fixes some bugs with grappling, maybe also redundant?
				if (!hand.overlaps(body)) {
					body.allowCollisions = FlxObject.NONE;
				} else {
					body.allowCollisions = FlxObject.ANY;
					/*if (body.justTouched(FlxObject.ANY)) {
						body.x = hand.x;
						body.y = hand.y;
						setDir(body,hand.facing);
					}
					if (hand.velocity.x == 0 && hand.velocity.y == 0 && body.velocity.x == 0 && body.velocity.y == 0 && !hand.touching) {
						hand.x = body.x;
						hand.y = body.y;
					}*/
				}
				
				//not sure why this is here- maybe body falling?  Uncomment if debugging something relevant to body
				/*if (body.acceleration.y == 0) {
					body.velocity.x = 0;
					body.velocity.y = 0;
					hand.velocity.x = 0;
					hand.velocity.y = 0;
				}*/
				//if out/in/idle 
			}/* else {
				hand.handleSoloMovement();
			}*/
			
			super.update();
			
			if (hand.velocity.x != 0) {
				lastVel.x = hand.velocity.x;
			}
			if (hand.velocity.y != 0) {
				lastVel.y = hand.velocity.y;
			}
			
			for (var mmmmm:uint = 0; mmmmm < roachGroup.length; mmmmm++) {
				var tmpRoach:SprRoach = roachGroup.members[mmmmm];
				tmpRoach.goAwayFromSprite(hand);
			}
			
			FlxG.collide(dripGroup,levelFunctional);
			FlxG.collide(levelFunctional, sprControllableGroup, sprControllableCallback);
			
			/*			
			// Pause
			if (FlxG.keys.justPressed("ENTER")) {
				FlxG.paused = !FlxG.paused;
				pause.setAll("exists", FlxG.paused);
				//IDLE_TIME = 22;
			}*/
			
			if (FlxG.paused) {
				if (hand.isAttachedToBody()) {
					pause.con.play("attached");
				} else {
					pause.con.play("detached");
				}
			}
			if (FlxG.paused && FlxG.keys.justPressed("R")) {
				// sound stuff
				stopAllSounds(); //should this be stopAllSounds()?
				FlxG.resetState();
			}
		}
		
		public function sprControllableCallback(level:FlxTilemap, spr:SprControllable):void {
			spr.collideCallback();
		}
		
		/*
		public function hitUp(spr1:FlxSprite, spr2:FlxSprite):void {
			var spr:FlxSprite;
			if (spr2 == hand) {
				spr = spr1;
			} else {
				spr = spr2;
			}
			//spr.acceleration.y = MAX_GRAV_VEL;
			//spr.acceleration.x = -MAX_GRAV_VEL;
			spr.angle += 2.2*hand.velocity.x/MAX_MOVE_VEL;
			spr.velocity.y = -MAX_MOVE_VEL;
			spr.velocity.x = -MAX_MOVE_VEL;
		}
		*/
		
		public function handOverlapsBody():uint {
			var hasOverlapped:Boolean = false;
			var b_max:int;
			var b_distSq_Min:Number;
			for (var b:int = 0; b < bodyGroup.length; b++) {
				var b_body:FlxSprite = bodyGroup.members[b];
				if (hand.overlaps(b_body)) {
					//return(b);
					var b_distSq:Number = Math.pow(hand.x + hand.width/2.0 - b_body.x - b_body.width/2.0,2) + Math.pow(hand.y + hand.height/2.0 - b_body.y - b_body.height/2.0,2);
					if (!hasOverlapped) {
						b_max = b;
						b_distSq_Min = b_distSq;
						hasOverlapped = true;
					} else if (b_distSq < b_distSq_Min) {
						b_max = b;
						b_distSq_Min = b_distSq;
					}
				}
			}
			if (hasOverlapped) {
				return(b_max);
			}
			return(uint.MAX_VALUE);
		}
		
		public function handOverlapsCannon():uint {
			var hasOverlapped:Boolean = false;
			var b_max:int;
			var b_distSq_Min:Number;
			for (var b:int = 0; b < cannonGroup.length; b++) {
				var b_cannon:FlxSprite = cannonGroup.members[b];
				if (hand.overlaps(b_cannon)) {
					//return(b);
					var b_distSq:Number = Math.pow(hand.x + hand.width/2.0 - b_cannon.x - b_cannon.width/2.0,2) + Math.pow(hand.y + hand.height/2.0 - b_cannon.y - b_cannon.height/2.0,2);
					if (!hasOverlapped) {
						b_max = b;
						b_distSq_Min = b_distSq;
						hasOverlapped = true;
					} else if (b_distSq < b_distSq_Min) {
						b_max = b;
						b_distSq_Min = b_distSq;
					}
				}
			}
			if (hasOverlapped) {
				return(b_max);
			}
			return(uint.MAX_VALUE);
		}
		
		/*
		public function pointForTile(tile:uint,map:FlxTilemap):FlxPoint {
			var X:Number = 8*(int)(tile%map.widthInTiles);
			var Y:Number = 8*(int)(tile/map.widthInTiles);
			var p:FlxPoint = new FlxPoint(X,Y);
			return p;
		}*/
		
		public function buttonReaction():void {
			
			//steamTimer = 0;
			
			//steamsNumber++;
			/*
			if (reinvigorated) {
				reinvigorated = false;
				for (var m:String in steams.members) {
					var steam:FlxSprite = steams.members[m];
					steam.play("idle");
				}
				
			} else {
				reinvigorated = true;
				for (m in steams.members) {
					steam = steams.members[m];
					steam.play("puff");
				}
			}
			*/
			reversePolarity = !reversePolarity;
		}
		
		public function goToNextLevel():void {
			if (isTransitioningToNextLevel) {return;}
			isTransitioningToNextLevel = true;
			
			
			// for testing
			// the level num must be incremented so that the switch state will choose the next level
			RegistryLevels.num++;
			// this'll fire at the end of the fade
			var $exitFunction:Function = function():void {
				stopAllSounds();
				var $state:FlxState = (RegistryLevels.num > 11) ? new EndState : new PlayState;
				if (RegistryLevels.num > 11) {RegistryLevels.num = 0;}
				FlxG.switchState($state);
			};
			
			/*
			// the level num must be incremented so that the switch state will choose the next level
			RegistryLevels.num++;
			// this'll fire at the end of the fade
			var $exitFunction:Function = function():void {
				stopAllSounds();
				FlxG.switchState(new PlayState);
			};*/
			// the fade just makes things look cooler
			FlxG.fade(0xff000000,1,$exitFunction);
		}
		
		private function stopAllSounds():void {
			ambientGearsSound.stop();
			hand.stopElectricityEffects(); //not just sound, though
		}
		
		private function groupFromSpawn(_spawn:Array,_class:Class,_map:FlxTilemap):FlxGroup {
			var _group:FlxGroup = new FlxGroup();
			for (var i:uint = 0; i <_spawn.length; i++) {
				var _array:Array = _map.getTileInstances(_spawn[i]);
				if (_array) {
					for (var j:uint = 0; j < _array.length; j++) {
						var _point:FlxPoint = pointForTile(_array[j],_map);
						_group.add(new _class(_point.x,_point.y));
					}
				}
			}
			return _group;
		}
		
		private function applyFunctionToTile($spawn:Array,$function:Function,$map:FlxTilemap):void {
			for (var i:uint = 0; i <$spawn.length; i++) {
				var $array:Array = $map.getTileInstances($spawn[i]);
				if ($array) {
					for (var j:uint = 0; j < $array.length; j++) {
						$function($map,$array[j]);
					}
				}
			}
		}
		
		private function pointForTile(_tile:uint,_map:FlxTilemap):FlxPoint {
			var _x:Number = (_map.width/_map.widthInTiles)*(int)(_tile%_map.widthInTiles);
			var _y:Number = (_map.width/_map.widthInTiles)*(int)(_tile/_map.widthInTiles);
			var _point:FlxPoint = new FlxPoint(_x,_y);
			return _point;
		}
		
		private function checkIfButtonPressedByHand():void {
			
			var tmpShouldToggleAll:Boolean;
			var i:uint;
			var tmpBtn:SprButton;
			
			for (i = 0; i < buttonGroup.length; i++) {
				tmpBtn = buttonGroup.members[i];
				if (tmpBtn.canBePressed() && hand.overlaps(tmpBtn)) {
					tmpBtn.press();
					tmpShouldToggleAll = true;
				} else if (!tmpBtn.canBePressed() && !hand.overlaps(tmpBtn)) {
					tmpBtn.unpress();
				}
			}
			
			if (tmpShouldToggleAll) {
				for (i = 0; i < buttonGroup.length; i++) {
					tmpBtn = buttonGroup.members[i];
					tmpBtn.toggleColor();
					if (!hand.overlaps(tmpBtn)) {
						tmpBtn.unpress();
					}
				}
			}
		}
		
		public function addHeartHappy():void {
			return;
			//var $heart:SprHeart = new SprHeart(hand);
			//add($heart);
			//$heart.makeHappy();
		}
		
		public function addHeartSad():void {
			return;
			//var $Heart:SprHeart = new SprHeart(hand);
			//add($Heart);
			//$Heart.makeSad();
		}
		
		private function hideMusicOverlayInstantly():void {
			musOverlay.volume = 0;
		}
		
		public function hideMusicOverlay():void {
			// the timer will decrement volume each frame
			var $timer:EventTimer;
			// the set vol to the max first
			musOverlay.volume = 1;
			// the event ensures that the volume's down all the way by the end time
			// (also, remove the timer so that it stops updating)
			var $event:Function = function():void {
				remove($timer);
				musOverlay.volume = 0;
			};
			// this action's fired every frame. probably not ideal that this relies on clock speed...
			var $pulse:Function = function():void {
				musOverlay.volume -= 0.05;
			};
			$timer = new EventTimer(0.5,$event,false,true,$pulse);
			// don't forget to add the timer so that it updates each frame
			add($timer);
		}
		
		public function showMusicOverlay():void {
			// the timer will increment volume each frame
			var $timer:EventTimer;
			// the set vol to the min first
			musOverlay.volume = 0;
			// the event ensures that the volume's up all the way by the end time
			// (also, remove the timer so that it stops updating)
			var $event:Function = function():void {
				remove($timer);
				musOverlay.volume = 1;
			};
			// this action's fired every frame. probably not ideal that this relies on clock speed...
			var $pulse:Function = function():void {
				musOverlay.volume += 0.05;
			};
			$timer = new EventTimer(0.5,$event,false,true,$pulse);
			// don't forget to add the timer so that it updates each frame
			add($timer);
		}
		
		public function get poleCol():uint {
			return reversePolarity?0xff0000:0xffff00;
		}
		
		private function isBody(spr:FlxSprite):Boolean {
			return bodyGroup.members.indexOf(spr) > -1;
		}
		
		
		
		
		private function checkHintBubbles():void {
			var $overlapsSomethingHintworthy:Boolean = false;
			var i:uint;
			for (i = 0; i < hintPointsLeftRight.length; i++) {
				var $pointLR:FlxSprite = hintPointsLeftRight.members[i];
				if (hand.overlaps($pointLR)) {
					$overlapsSomethingHintworthy = true;
					hand.hintShow();
					hand.bubble.string = "Press LEFT\nor RIGHT\nto move";
				}
			}
			for (i = 0; i < hintPointsJump.length; i++) {
				var $pointJump:FlxSprite = hintPointsJump.members[i];
				if (hand.overlaps($pointJump)) {
					$overlapsSomethingHintworthy = true;
					hand.hintShow();
					hand.bubble.string = "Press UP\n to fall";
				}
			}
			for (i = 0; i < hintPointsAttachDetach.length; i++) {
				var $pointAttachDetach:FlxSprite = hintPointsAttachDetach.members[i];
				if (hand.overlaps($pointAttachDetach)) {
					if (!hand.isAttachedToBody() && RegistryLevels.num <= 6) {
						$overlapsSomethingHintworthy = true;
						hand.hintShow();
						hand.bubble.string = "Press DOWN\nto enter\na mechanism";
					} else if (hand.isAttachedToCannon()) {
						$overlapsSomethingHintworthy = true;
						hand.hintShow();
						hand.bubble.string = "Press LEFT or\nRIGHT to\naim, and\nUP to fire.";
					} else if (hand.isAttachedToGrappler()) {
						$overlapsSomethingHintworthy = true;
						hand.hintShow();
						hand.bubble.string = "Press DOWN\n to detach";
					}
				}
			}
			if (!$overlapsSomethingHintworthy) {
				hand.hintHide();
			}
		}
	}
}