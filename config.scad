// The MAXbot
// Parametric Wallace/printrBot derivate/upgrade
// Written with OpenSCAD by Martin Axelsen 2012-2013
// kharar@gmail.com  |  tinyurl.com/maxbot

// 0 = Direct extruder
// 1 = Single Bowden
// 2 = Double Bowden
// 3 = Triple Bowden
extruderSelect		= 0;			// extruder selection

// CONSTANTS
pi					= 3.14159265;	// PI

coolerAddon			= true; 		// specifies if part 4 includes the cooler mounting (experimental)

bearingHeight		= 8;			// belt bearing height (608ZZ=8)
bearingDiameter		= 22;			// belt bearing diameter (608ZZ=22)

xBeltToothSize		= 2.5;			// belt tooth interval (T2.5=2.5 | T5=5)
xBeltToothDepth		= 0.7;			// belt tooth thickness (T2.5=0.7 | T5=1)
xBeltDepth			= 0.9;			// belt additional thickness on smooth side of reinforcement (T2.5=0.9 | T5=0.5)
xBeltSide			= 6;			// belt width (T2.5=6 | T5=5)
xBeltIdlerRodHole	= 8;			// belt bearing rod hole diameter (608ZZ -> M8=8)
xBeltIdlerRodWall	= 7;			// belt bearing rod hole wall thickness

uSwitchLength		= 20;			// microswitch length (along longest side)
uSwitchThickness	= 6.5;			// microswitch thickness (along smallest side and mounting holes)
uSwitchDepth		= 12;			// microswitch depth (measured from rear to front with contact fully pressed)
uSwitchHoleAX		= 9;			// microswitch mounting hole A X-coordinate
uSwitchHoleAY		= 5.5;			// microswitch mounting hole A Y-coordinate
uSwitchHoleBX		= 9;			// microswitch mounting hole B X-coordinate
uSwitchHoleBY		= 15;			// microswitch mounting hole B Y-coordinate
uSwitchMountHole	= 20;			// X-end microswitch mounting hole depth
uSwitchMountHoleDia	= 3.2;			// microswitch mounting holes to parts
uSwitchHoleDia		= 2.25;			// microswitch holes to render
uSwitchPlateOffset	= 2;			// microswitch touching plate offset (X-carriage homing position)

xPulleyTooth		= 16;			// pulley tooth count (to calculate pulley diameter)
xPulleyToothHeight	= 7;			// pulley tooth area length (actual span than belt can reside on)
xPulleyCutout		= 10;			// pulley clearance radius
xPulleyBaseHeight	= 8 +1;			// pulley base height (the part where the set screw is) (+1 for clearance)

xMotorDisplaceY		= 1.275;		//*motorrod clearance (must be kept high enough to avoid motor mount screws, and low enough to avoid motor-rod to intersecting X-rod 2) (1.275@8mmxrod | -1@10mmxrod)
xMotorDisplaceZ		= 0;			// motor base vs X-rod 2 clearance

motorMountWall		= 4;			// motor mount screw wall thickness (valid for part 1)
motorMount			= 3+0.2;		// motor mount screw hole diameter (NEMA17=3)
motorMountDist		= 31;			// motor mount screw hole distance (NEMA17=31)
motorWidth			= 42.3;			// size of motor measured on x and y-axis (NEMA17=42.3)
motorHeight			= 47;			// size of motor measured on z-axis (NEMA17=47)
motorCutoutD		= 22 +1;		// motor center ring diameter (NEMA17=22) (+1 for clearance)
motorCutoutH		= 2;			// motor center ring height (NEMA17=2)
motorRod			= 5 +1;			// motor axis diameter (NEMA17=5) (+1 for clearance)
motorRodLength		= 22.5;			// motor axis length (NEMA17=22.5)

xBeltWall			= 4;			// thickness of clamp/belt mounts
xCarriageBeltMount	= 3+0.2;		// clamp screw hole diameter
xCarriageLift		= 1;			// x-carriage base plate height (must be>0 to avoid collision with Z-rod walls on either side)
xCarriageDefaultZ	= 4;			// x-carriage base thickness
directExtruderWidth	= (48+2*3);	// minimum distance between Z-rod carvings (48=mounting screw interval distance, 2=screw count, 3=screw diameter)
xCarExtGroove		= 0;			// extruder cut-out depth from x-carriage base thickness (xCarriageZ)
xCenterHole			= 22;			// x-carriage base plate hot-end hole diameter
xLmWall				= 4;			// x-carriage linear bearing support wall thickness (determines flexibility of snap-fit/quick-release)
xLmSnap				= 13;			// x-carriage linear bearing support bottom cut-off amount (for easy snap-fit/quick-release functionality) (works with 15)

xRodDist			= 65;			// distance between center of smooth X-rods (40mm fan compatible>=65)(Prusa semi-compatible=50)
xRodHole			= 8;			//*rod diameter (8 or 10)
xRodDepth			= 26;			// X-rod hole depth into X-ends (for direct printrBot compatibility set around 26)
xRodLength			= 320;			// length of X-rods (minimum 116 approx)
xRodEnds			= true;			// [boolean]
xRodFixation		= true;			// [boolean]
xRodFixScrew		= 3;			// hole diameter for X-rod fixation
xRodFixLength		= 2;			// hole expansion for X-rod fixation
xRodFixDist			= 6;			// hole distance from either end of x-rod hole

xLmLength			= 24;			//*linear bearing length (LM8UU=24 | LM10UU=29)
xLmDiameter			= 15+0.1;		//*linear bearing diameter (LM8UU=15 | LM10UU=19) (+0.1 for printer calibration)

zRodThreadedDia		= 8;			// threaded Z-(outer)rod diameter (M8=8)
zRodThreadedLen		= 250;			// threaded Z-(outer)rod length (250) use HiQ stainless or better
zRodSmoothLen		= 380;
zRodSmooth			= 10;			// smooth Z-(inner)rod diameter (usually same size as zRodThreadedDia)
zRodDist			= 29;			// distance between the center of threaded and smooth Z-rods (PrintrBot/Wallace=28)
zRodOffset			= 0;			// Z-rods position relative to x-ends body (normally leave at 0)
zNutHole			= 14.5+0.65;	// Z axis hex-nut outer diagonal
zNutHeight			= 6.2;			// Z axis hex-nut height
zNutWall			= 5;			// support thickness around nut
zLmLength			= 24;			// linear bearing length (LM8UU=24)
zLmDiameter			= 15.1;			// linear bearing diameter (LM8UU=15)

zLmWall				= 4;			// Z-axis linear bearing support wall thickness
zLmSnap				= 6;			// x-carriage linear bearing support bottom cut-off amount (for easy snap-fit/quick-release functionality use any number from 6 and up)
zLmSupportY			= 9;			// support width for the Z-LM tube
zLmSfccAngle		= 20;			// snap-fit corner-cut angle
zLmSfccDepth		= 7;			// snap-fit corner-cut depth

guideWidth			= 16;			// X cable guide hole width
guideHeight			= 16;			// X cable guide height
guideBracketH		= 3;			// X cable guide screw plate height
guideBridgeOffset	= 10;			// X cable guide bridge position offset

zEndstopPosX		= 4;			// Z endstop length placement
zEndstopPosZ		= 40;			// Z endstop height placement
zEndstopWall		= 3;			// Z endstop wall thicknesses

zBedOffset			= 120;			// Lowest position of X bridge on Z axis, only used for displaying
zPosDisp			= 0;			// Z height of X-bridge, only used for displaying


// VARIABLES
coolerMountOffset	= 44;
coolerMountDist		= 13;
xCarriageUseLength	= (extruderSelect == 0) ? directExtruderWidth : 30*extruderSelect;		// minimum distance between Z-rod carvings
xCarriageZ			= (extruderSelect == 0) ? xCarriageDefaultZ : 2*xCarriageDefaultZ;
guideThickness		= motorMount;											// X cable guide element thickness
xPulleyRadius		= (xPulleyTooth*xBeltToothSize/pi)/2;					// x-belt pulley radius
xCarriagePlatform	= xLmDiameter/2+xLmWall+xCarriageLift+xCarriageZ;		// x-carriage plateau Z-distance from origin
xBeltHeight			= xRodHole/2+xPulleyBaseHeight+xBeltSide/2+1;//xLmDiameter/2+xLmWall+xBeltSide/2+1+10;				//*x-belt Z-distance from origin
xPulleyBeltHeight	= xBeltHeight-xPulleyBaseHeight;						// x-belt to base of pulley distance
xBeltMountZdisplace	= xBeltSide+xCarriageBeltMount;							// clamp screw holes Z-distance from belt height on x-carriage
xBeltMountXDist		= 10;													// clamp screw holes X-distance
xBeltIdlerDiameter	= bearingDiameter;  									//xBeltToothCount*xBeltToothSize/pi;		// belt idler diameter
xBody				= xRodDepth; 											// x-size of x-ends
yBody				= xRodDist+2*xRodHole;									// y-size of x-ends
zBody				= 2*xRodHole;											// z-size of x-ends
zRodHole			= zRodThreadedDia + 3;									// holes size for the threaded Z-rods
xMotorDisplaceX		= motorWidth/2-xBody/2;									// motor position (clearance for X-carriage)
renderPartDistance	= xRodLength/2-xRodDepth+xBody/2;						// distance between origins (for renderPart=0 only)
zLmOffset			= -(zLmLength*2-zBody)/2;								// smooth z-rod LM bearing support tube displacement
zLmSupportX			= zLmDiameter/2+zLmWall;								// support for the Z-LM tube
xCarriageMountY		= yBody/2+xMotorDisplaceY-xPulleyRadius-xBeltDepth;	// x-carriage belt mount y-distance from origin
xCarriageLmSpace	= 2;													// x-carriage LM center spacer
xCarriageLmEnd		= 2;													// x-carriage LM end limiter
xCarriageLength		= max(zLmLength*2+xCarriageLmSpace*2+xCarriageLmEnd, xCarriageUseLength+zRodSmooth+2);		// x-carriage length on x-axis
xPulleyDisplaceZ	= xBeltHeight-xPulleyBaseHeight-xPulleyToothHeight/2-xRodHole/2;	//2.5;			// pulley vs X-rod 2 clearance (pulley cut-out plateau)
zPos				= zPosDisp+zBedOffset;			// Z height of X-bridge, only used for displaying
uSwitchOffsetY		= zLmDiameter/2;										// x-microswitch Y-distance from origin
