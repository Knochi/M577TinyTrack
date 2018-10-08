

/* [Show] */
showCogWheels=true;
showMotors=true;
motorType="TT"; //[TT,N20]
showTracks=true;
showBody=true;
showChassis=true;
showPCB=true;
showBattery=true;
batteryType="AirSoft"; //[JM1,X1,18650,AirSoft]


/* [Track] */
cogWheelDia=32;
//trackWdth=1;
//trackLngth=1;

/* [Positions]  */
posPCB=[-78,0,28];
posJM1Bat=[-20,0,43];
posX1Bat=[-20,0,43];
pos18650Bat=[-18,12,20];
posASBat=[0,0,35];



/* [Axis Parameters] */
axisFrntX=36.7;
axisBckX=-73.7;
axisWdth= 51;
axisMtrsY= 43;
axisHght=18;

/* [Hidden] */
M577origDims= [1.37+1.57,0.575*2,0];
factor=65;
N20axsLngth=9.3;
TTaxsLngth=8.3;


fudge=0.1;

color("purple")
if (showMotors){
  if (motorType == "N20") {
  translate([ axisFrntX, -axisMtrsY/2, axisHght ]) rotate([0,0,90]) import("N20_gear_motor.stl"); //front motor
  translate([ axisBckX, axisMtrsY/2, axisHght ]) rotate([0,0,-90]) import("N20_gear_motor.stl");  
  }
  else if (motorType == "TT")
  {
    translate([ axisBckX, axisMtrsY/2, axisHght ])
      rotate([180,180,0]) TTMotor();
    //translate([-53,-11.2,0]) import("DC_Motor_20mm.stl");
        
    translate([ axisFrntX, -axisMtrsY/2, axisHght ])
      rotate([0,0,0]) TTMotor();
    //translate([-53,-11.2,0]) import("DC_Motor_20mm.stl");
  } 
}

*translate([-110,0,M577origDims[2]*factor/2-4.3])
  rotate(90)
    scale(factor)
      import("M577body.stl");

if (showBody)
%scale(23) import("M577bodydetail.stl");

if (showChassis)
  color("darkgrey")
  chassis();

if (showBattery){
  
  if (batteryType=="JM1")
   color("orange")
    translate(posJM1Bat) rotate(90) {
      translate([0,0,-2])batJM1();
      translate([0,0,2]) batJM1();
    }
  if (batteryType=="X1")
    color("orange") translate([-17,-23,axisHght]) batX1();
  
  if (batteryType=="18650")
    color("orange") translate([pos18650Bat[0],0,pos18650Bat[2]]) rotate(0){
      translate([0,9+pos18650Bat[1],0]) bat18650();
      translate([0,-(9+pos18650Bat[1]),0]) bat18650();
      }
  if (batteryType=="AirSoft")
    color("orange") translate(posASBat) batTNano();
}
//electronis
if (showPCB)
  color("lightgreen")
    translate([-34.5/2,-25.6/2,0]+posPCB)
      rotate([90,0,-90])
        import("WEMOS_D1mini.stl");

//FPV Cam
color("lightblue")
translate([59,0,15])
  rotate([90,0,90])
    FPV1000TVL();



//Track
if (showCogWheels){
  translate([axisFrntX,-axisWdth/2,axisHght]) rotate([90,90,0]) cogWheel(showTrack=showTracks,driveWheel=true); //front right
  translate([axisBckX,-axisWdth/2,axisHght]) rotate([90,-90,0]) cogWheel(showTrack=showTracks,driveWheel=false);//back right
  translate([axisFrntX,axisWdth/2,axisHght]) rotate([-90,-90,0]) cogWheel(showTrack=showTracks,driveWheel=false); //front left
  translate([axisBckX,axisWdth/2,axisHght]) rotate([-90,90,0]) cogWheel(showTrack=showTracks,driveWheel=true); //front left
  
  if (showTracks)
  for (i=[0:8.3:axisFrntX-axisBckX-8]){
    translate([axisFrntX-i,-axisWdth/2,axisHght+cogWheelDia/2]) rotate(180) track(cogWheelDia,jntDia=5);//top right
    translate([axisFrntX-i-8.3,axisWdth/2,axisHght+cogWheelDia/2]) rotate([0,0,0]) track(cogWheelDia,jntDia=5);//top left
    translate([axisFrntX-i-8.3,-axisWdth/2,axisHght-cogWheelDia/2]) rotate([180,0,0]) track(cogWheelDia,jntDia=5);//bottom right
    translate([axisFrntX-i,axisWdth/2,axisHght-cogWheelDia/2]) rotate([180,0,180]) track(cogWheelDia,jntDia=5);//bottom left
  }
}

//TTMotor();
module TTMotor(drill=0,axs=false,recess=false){
  $fn=50;
  shaftLngth=8;
  shaftDia=5.4;
  axsLngth=8.8;
  axsDia=7.2;
  lckFeatXOff=11;
  lckFeatDia=4;
  lckFeatHght=2;
  drillXOff=20.3; //31.8-11.2 from datasheet
  drillZOff=17.5/2;
  drillDia=3.2;
  
  if (!(axs || recess || drill)){
  rotate([-90,0,0]) translate([-53,-11.2,0])
        import("DC_Motor_20mm.stl");
    //2nd axis
    translate([0,27.5,0]) rotate([-90,0,0]) cylinder(d=shaftDia,h=axsLngth);
  }
  
  if (axs){
    translate([0,axsLngth,0]) rotate([90,0,0]) cylinder(d=axsDia+fudge,h=axsLngth+fudge);
  }
  
  if (recess){
    translate([-lckFeatXOff,axsLngth,0]) rotate([90,0,0]) cylinder(d=lckFeatDia+fudge,h=lckFeatHght+fudge);
    translate([-33+2,axsLngth-0.75,0]) cube([4,1.4,5],true);
  }
  
  if (drill) {
    translate([-drillXOff,axsLngth-fudge,drillZOff]) rotate([90,0,0]) cylinder(d=drillDia,h=drill+fudge);
    translate([-drillXOff,axsLngth-fudge,-drillZOff]) rotate([90,0,0]) cylinder(d=drillDia,h=drill+fudge);
  }
  
}

module chassis(){
  $fn=50;
  minWallThick=1.6; //minimum Wall Thickness
  axsDist=(axisFrntX-axisBckX);
  ovLngth=axsDist+38;
  ovWdth=13*2+minWallThick*2;
  ovHght=22.5+2*minWallThick;
  xOffset=axisFrntX-axsDist/2;
  
  axisLngth=5+axisWdth/2-ovWdth/2-fudge;
  
  translate([0,0,axisHght])
    difference(){
      union(){
        translate([xOffset,0,0]) cube([ovLngth,ovWdth,ovHght],true); //chassis body
        translate([axisFrntX,ovWdth/2-fudge,0]) cube([15,8,ovHght],true);
      }
      translate([xOffset,0,(minWallThick+fudge)/2]) 
        cube([ovLngth-minWallThick*2,ovWdth-minWallThick*2,ovHght-minWallThick+fudge],true); //hollow
      translate([axisFrntX,-axisMtrsY/2,0]) rotate([0,0,0]) TTMotor(drill=6,axs=true,recess=true); //openings for frnt TT Motor
      translate([axisFrntX,ovWdth/2-fudge,minWallThick/2]) cube([8,4,ovHght-minWallThick+fudge],true);
    }
    
    //holders for undriven cogwheels
    translate([axisFrntX,ovWdth/2-fudge,axisHght]){
        rotate([-90,0,0]){
          cylinder(d=8,h=axisLngth+fudge);//frnt
          cylinder(d=10,h=5.8+fudge);//frnt
        }
      }
      
    
    translate([axisBckX,-(ovWdth/2-fudge),axisHght]) rotate([90,0,0]){
      cylinder(d=8,h=axisLngth+fudge);//frnt
      cylinder(d=10,h=5.8+fudge);//frnt
    }
    
}
  
module motorShield(){
  cube([59,43,19],true);
}

module bat18650(){
  rotate([0,90,0]) cylinder(h=65,d=18,center=true);
}


module batX1(){
  //Extron 650mAh 2S LiPo
  cube([50,18,25],true);
}

module batTNano(){
  /*
  cube([45,17,12],true); //Turnigy Nano 300mAh
  cube([56,30.5,9.8],true); //Turnigy Nano 350mAh
  cube([63,32,9],true); //Turnigy Nano 370mAh
  cube([55,30,10],true); //Turnigy Nano 460mAh
  */
  cube([127,20,12],true); //Turningy Nano Airsoft 1200mAh (NG1200A.2S.15)
}

*batJM1();
module batJM1(){
  $fn=30;
  ovWdth=44;
  ovHght=4;
  ovLngth=65;
  
  union(){
    translate([(ovWdth-ovHght)/2,0,0]) rotate([90,0,0]) cylinder(d=ovHght,h=ovLngth,center=true);
    translate([-(ovWdth-ovHght)/2,0,0]) rotate([90,0,0]) cylinder(d=ovHght,h=ovLngth,center=true);
    cube([ovWdth-ovHght,ovLngth,ovHght],true);
  }
}

module FPV(size="mini"){
  //standard=28mm, mini=21, micro=19mm
  dim= size=="standard" ? 28 : size == "mini" ? 21 : 19;
  translate([0,0,17.25/2]) cube([dim,dim,17.25],center=true);
  translate([0,0,17]) cylinder(d=14,h=10);
}

module FPV1000TVL(){
  $fn=50;
  translate([0,0,6]) cube([18,17.5,12],true);
  translate([0,0,12-fudge]) cylinder(d=14,h=16+fudge);
  translate([(18+2.5)/2,0,0]) cylinder(d=4,h=12);
  translate([-(18+2.5)/2,0,0]) cylinder(d=4,h=12);
}

module D1mini(){
  height=18;
  translate([0,0,height/2]) cube([25.6,34.2,height],true);
}


module FireFly(){
  //FireFly micro Cam
  //https://www.gearbest.com/action-cameras/pp_1588214.html
  cube([32,24,24],true);
}


module cogWheel(showTrack=false,showBearing=true,driveWheel=false){
  //https://www.banggood.com/6901ZZ-12x24x6mm-Steel-Sealed-Deep-Groove-Ball-Bearing-p-979798.html
  //https://www.pollin.de/p/kugellager-608zz-440430 --> 8x22x7mm 0,90€
  
  $fn=50;
  bearingOutDia=22;
  bearingInDia=8;
  bearingThick=7;
  ovDia=32; //
  ovDiaOffset=1.5;
  ovThick=10;
  
  //bearing to top or bottom
  bearingZPos=  driveWheel ? -(bearingThick-ovThick)/2 +fudge : (bearingThick-ovThick)/2 -fudge;
  
  //motor Flange
  motFlangeLngth=10;
  
  impTrackOff=[-20,0,-5];
  trackDia=6;
  
  if (showTrack)
    for (ang=[0:30:150])
      rotate(ang)  
        rotate([90,0,0]) translate([ovDia/2,0,0]) rotate([0,90+15,0]) track(ovDia,jntDia=5);//import("Track.stl");
    
  if (showBearing)
    color("grey") translate([0,0,bearingZPos])
    difference(){
      cylinder(d=bearingOutDia,h=bearingThick,center=true);
      cylinder(d=bearingInDia,h=bearingThick+fudge,center=true);
    }
  
  if (driveWheel)  
    translate([0,0,-motFlangeLngth-ovThick/2+fudge]) rotate([0,0,90]) motAdapt(8,motFlangeLngth);  
    
  difference(){
    //cylinder(d=ovDia-ovDiaOffset,h=ovThick,center=true);
    chamfWheel(ovDia-ovDiaOffset,ovThick,(ovThick-4)/2);
    translate([0,0,bearingZPos])cylinder(d=bearingOutDia,h=bearingThick+fudge,center=true);
    translate([0,0,ovThick-bearingThick-1]) cylinder(d=bearingOutDia-4,h=ovThick+fudge,center=true);
    
    for (ang=[0:30:330]){
      rotate(ang)
        translate([ovDia/2,0,-fudge/2]) 
          cylinder(d=trackDia,h=bearingThick*1.5+fudge,center=true);
  }
}
}

//projection(true) 
  //rotate([0,-90,0]) 
    //translate([-3.1,0,0]) 
//track();

module track(cogDia=30,cogAng=30,jntDia=5,showProfile=false){
  $fn=50;
  
  //Dimensions
  ovWdth=20; //36
  //ovLngth=9.3; //Length of Track from joint center2center
  ovLngth=2*(cogDia/2)*sin(cogAng/2); //ovLength from Dia and Angle
  ovHght=4;    //body height above joint center
  
  //joints
  //jntDia=6;
  jntClrnc=0.5;//clearance between inner and outer joint cylinder
  inJntWdth=ovWdth*0.5;//width of inner joint cylinder
  outJntWdth=(ovWdth-inJntWdth)/2;
  lckDpth=(jntDia)/2; //locking depth below joint center
  lckWdth=13/3; //width of the locking feature
  pinDia=1.75;
    
  //Profile
  prfHght=1;   //Height of Profile
  prfAng=atan((jntDia/2)/(inJntWdth/2));     //Angle of Profile
  prfX1=-jntDia/2;
  prfY1=tan(90-prfAng)*(jntDia/2);
  prfX2=tan(prfAng)*(ovWdth/2);
  prfY2=ovWdth;
  prfLngth=prfX2/sin(prfAng);
  prfDia=2.5;
    
  fudge=0.1;
  
  //%rotate([90,0,0])translate([-10.7,0,0]) import("Track.stl");
  
  translate([0,-ovWdth/2,0])
  rotate([-90,0,0]) 
    difference(){
    union(){
      cylinder(d=jntDia,h=ovWdth);
      rotate([90,0,0]) cube([ovLngth,ovWdth,ovHght]);
      translate([ovLngth,0,(ovWdth-inJntWdth)/2-fudge/2]) cylinder(d=jntDia,h=inJntWdth+fudge);
      
      difference(){
        translate([0,-fudge,outJntWdth]) cube([ovLngth,lckDpth+fudge,inJntWdth]);
        translate([ovLngth,(jntDia+1)/2,outJntWdth-fudge/2]) rotate([0,0,180]) chamfer(0.5,inJntWdth+fudge);
        translate([ovLngth,lckDpth,ovWdth/2]) 
          rotate([-90,90,90]) linear_extrude(ovLngth) 
            polygon([[-lckDpth-lckWdth/2,-fudge/2],
                     [-lckWdth/2,lckDpth],
                     [lckWdth/2,lckDpth],
                     [lckWdth/2+lckDpth,-fudge/2]]);
      }//diff
    }//union
    translate([0,0,-fudge/2]) cylinder(d=pinDia,h=ovWdth+fudge);
    translate([ovLngth,0,-fudge/2]) cylinder(d=pinDia,h=ovWdth+fudge);
    translate([0,0,(ovWdth-inJntWdth)/2-jntClrnc]) cylinder(d=jntDia,h=inJntWdth+jntClrnc*2);
    translate([0,(-ovHght+lckDpth)/2,outJntWdth+inJntWdth/2]) cube([jntDia,ovHght+lckDpth+fudge,inJntWdth+2*jntClrnc],true);
    translate([ovLngth,(-ovHght+lckDpth)/2,outJntWdth/2-fudge/2]) cube([jntDia,ovHght+lckDpth+fudge,outJntWdth+fudge],true);
    translate([ovLngth,(-ovHght+lckDpth)/2,ovWdth-outJntWdth/2+fudge/2]) cube([jntDia,ovHght+lckDpth+fudge,outJntWdth+fudge],true);
    
  }
  if (showProfile){
    translate([ovLngth-1.5,0,ovHght]) rotate([-90,0,prfAng]) 
      profile(prfLngth,prfDia);
    translate([ovLngth-1.5,0,ovHght]) rotate([90,0,-prfAng]) 
      profile(prfLngth,prfDia);
  }
}

module profile(lngth,dia){
  union(){
    translate([0,0,0]) sphere(d=dia);
    translate([0,0,0]) cylinder(d=dia,h=lngth-dia/2);
    translate([0,0,lngth-dia/2]) sphere(d=dia);
  }
}

*chamfWheel(23,10,2);
module chamfWheel(dia, thck, chamf){
  $fn=100;
  rotate_extrude()
  polygon([[0,thck/2],
           [dia/2-chamf,thck/2],
           [dia/2,thck/2-chamf],
           [dia/2,-thck/2+chamf],
           [dia/2-chamf,-thck/2],
           [0,-thck/2]]
          );
}

module chamfer(s,l){
  linear_extrude(l)
    polygon([[-fudge/2,-fudge/2],[-fudge/2,s+fudge/2],[s+fudge/2,-fudge/2]]);
}

module microStepper(){
  $fn=50;
  //Pollin 310776
  cylinder(d=1.5,h=15); //axis
  cylinder(d=10,h=12); //motor
}

//!motAdapt(7,10);

module motAdapt(dia,length,depth=8){
  $fn=80;
  innerDia=5.4;
  flatners=(innerDia-3.7)/2;
  difference(){
    cylinder(d=dia,h=length);
    translate([0,0,-fudge]) difference(){
      cylinder(d=innerDia,h=depth+fudge);
      translate([0,(innerDia-flatners+fudge)/2,depth/2]) cube([innerDia,flatners+fudge,depth+2*fudge],true);
      translate([0,-(innerDia-flatners+fudge)/2,depth/2]) cube([innerDia,flatners+fudge,depth+2*fudge],true);
    }
  }
}