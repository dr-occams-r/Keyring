// KeyRing - TPU
//   Designed for TPU
//   Pull through lock

// Prerequisite:
//   BOSL2 https://github.com/BelfrySCAD
include <BOSL2-local/std.scad>

/* [Zip Tie] */
MaleLength = 70; // [0:1:100]
MaleWidth = 2; // [0:0.1:20]
MaleChamfer = 0.0; // [0:0.1:5]
// Lead to pull through lock, tapered to Male Width.
LeadTipWidth = 1; // [0:0.1:20]
LeadLength = 30; // [0:0.1:50]
FemaleSideThickness = 1; // [0:0.1:10]
FemaleTolerance = 0.8; // [0:0.1:2]

/* [Barb] */
BarbLength = 1; // [0:0.1:10]
BarbProtrude = 1; // [0:0.1:10]
BarbAngle = 75; // [0:1:90]
// Stopper Length can be shorter than barb since it doesn't receive much force
StopperLength = 1.2; // [0:0.1:10]

/* [General] */
VeryThin = 0.001; //[0:0.0001:2]

/* [Finalization] */
PrintKeyring = true;
Smooth = true;
FragmentsSmooth = 100; // 5:1:1000
FragmentsRegular = 10; // 5:1:1000
fnCalc = Smooth ? FragmentsSmooth : FragmentsRegular;
$fn = fnCalc;
//echo("fnCalc:", fnCalc);

// Male
MaleWidthHalf = MaleWidth / 2;
MaleHeight = MaleWidth;

// Female
FemaleLength = MaleHeight;
FemaleWidth = MaleWidth + FemaleTolerance;
FemaleHeight = MaleHeight;

// Lead
LeadTipHeight = LeadTipWidth;
LeadTipRight = MaleLength;

// Barb
BarbHeight = MaleHeight;
BarbOuterLength = BarbLength;
BarbInnerLengthExtra = tan(BarbAngle);
BarbInnerLength = BarbOuterLength + BarbInnerLengthExtra;
BarbInnerOffset = MaleWidthHalf;
BarbOuterOffset = BarbInnerOffset + BarbProtrude;
BarbPlacedRight = MaleLength - BarbInnerLength;

// Stopper
BarbWidthTotal = BarbOuterOffset * 2;;
//StopperLength = BarbLength;
StopperWidth = BarbWidthTotal;
StopperHeight = MaleHeight;
StopperPlacedRight = BarbPlacedRight - FemaleHeight;



module MaleBody(){
  cuboid(
    size=[MaleLength, MaleWidth, MaleHeight],
    chamfer=MaleChamfer,
    edges="X",
    anchor=LEFT+BOT
  );
}
//MaleBody();


module Lead(){
  hull(){
    cuboid(
      size=[LeadLength, LeadTipWidth, LeadTipHeight],
      chamfer=MaleChamfer,
      edges="X",
      anchor=LEFT+BOT
    );
  }
}
//Lead();

module MaleTipHulled(){
  hull(){
    MaleBody();
    right(LeadTipRight){
      Lead();
    }
  }
}
//MaleTipHulled();


module BarbInner(){
  // Barb Inner Part to Hull
  back(BarbInnerOffset){
    cuboid(
      size=[BarbInnerLength, VeryThin, BarbHeight],
      anchor=LEFT+BOT
    );
  }
}

module BarbOuter(){
  // Barb Outer Part to Hull
  back(BarbOuterOffset){
    cuboid(
      size=[BarbOuterLength, VeryThin, BarbHeight],
      anchor=LEFT+BOT
    );
  }
}

module BarbHalf(){
  hull(){
    BarbInner();
    BarbOuter();
  }
}

module BarbCenter(){
  // To fill in Male Chamfer gaps, if option is used.
  hull(){
    yflip_copy(){
      BarbInner();
    }
  }
}

module Barb(){
  yflip_copy(){
    BarbHalf();
  }
  BarbCenter();
}


module BarbPlaced(){
  right(BarbPlacedRight){
    Barb();
  }
}
//BarbPlaced();

module Stopper(){
  cuboid(
    size=[StopperLength, StopperWidth, StopperHeight],
    anchor=RIGHT+BOT
  );
}
//Stopper();

module StopperPlaced(){
  right(StopperPlacedRight){
    Stopper();
  }
}

module Female(){
  rect_tube(
    isize=[FemaleLength, FemaleWidth],
    height=FemaleHeight,
    wall=FemaleSideThickness,
    anchor=BOT+RIGHT
  );
}

module Keyring(){
  Female();
  MaleTipHulled();
  StopperPlaced();
  BarbPlaced();
}


module Final(){
  if(PrintKeyring){
    Keyring();
  }
}


Final();

