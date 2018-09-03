useN20s=false;

/* [Show] */
showCogWheel=true;
showMotors=true;
showBody=true;
showChassis=true;

/* [Hidden] */
M577origDims= [1.37+1.57,0.575*2,0];
factor=65;

axisFrntX=36.7;
axisBckX=-73.7;
axisWdth= 51;
axisMtrsY= 36.5;
axisHght=18;

fudge=0.1;

if (useN20s){
  translate([ 25.20, -26, 11.48 ]) rotate([0,0,90]) import("N20_gear_motor.stl");
  translate([ -73.09, 26, 11.03 ]) rotate([0,0,-90]) import("N20_gear_motor.stl");  
}
else if (showMotors)
{
translate([ axisBckX, axisMtrsY/2, axisHght ])
  rotate([90,180,0])
    translate([-53,-11.2,0])
     color("purple") import("DC_Motor_20mm.stl");
    
translate([ axisFrntX, -axisMtrsY/2, axisHght ])
  rotate([-90,0,0]) 
  translate([-53,-11.2,0])
    color("purple") import("DC_Motor_20mm.stl");
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

//electronis  
color("lightgreen")
translate([-80,-12,33])
  rotate([90,0,-90])
  //motorShield();
import("WEMOS_D1mini.stl");



//batteries
color("orange") translate([-17,-23,axisHght]) batX1();


//FPV Cam
color("lightblue")
translate([59,0,15])
  rotate([90,0,90])
    FPV1000TVL();

//Track
if (showCogWheel)
translate([axisFrntX,-axisWdth/2,axisHght]) rotate([90,90,0]) cogWheel();


module chassis(){
  $fn=50;
  translate([axisFrntX,-axisWdth/2-1,axisHght])
    rotate([-90,0,0])
    difference(){
      cylinder(d=12,h=14);
      translate([0,0,-fudge/2]) cylinder(d=9,h=14+fudge);
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

*cogWheel();
module cogWheel(showTrack=true,showBearing=true){
  //https://www.banggood.com/6901ZZ-12x24x6mm-Steel-Sealed-Deep-Groove-Ball-Bearing-p-979798.html
  
  $fn=50;
  bearingOutDia=24;
  bearingInDia=12;
  bearingThick=6;
  ovDia=32; //
  ovDiaOffset=1.5;
  ovThick=10;
  X=5;
  
  //motor Flange
  motFlangeLngth=20;
  
  impTrackOff=[-20,0,-5];
  trackDia=6;
  
  if (showTrack)
    for (ang=[30:30:180])
    rotate(ang)  
        rotate([90,0,0]) translate([ovDia/2,0,0]) rotate([0,90+15,0]) track(ovDia,jntDia=5);//import("Track.stl");
  if (showBearing)
    color("grey") translate([0,0,-X+fudge/2+bearingThick/2])
    difference(){
      cylinder(d=bearingOutDia,h=bearingThick,center=true);
      cylinder(d=bearingInDia,h=bearingThick+fudge,center=true);
    }
  translate([0,0,-motFlangeLngth+ovThick/2]) rotate([0,0,90]) motAdapt(8,motFlangeLngth);  
    
  difference(){
    //cylinder(d=ovDia-ovDiaOffset,h=ovThick,center=true);
    chamfWheel(ovDia-ovDiaOffset,ovThick,(ovThick-4)/2);
    translate([0,0,-(ovThick+fudge)/2])cylinder(d=bearingOutDia,h=bearingThick+fudge);
    cylinder(d=bearingOutDia-4,h=ovThick+fudge,center=true);
    
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
  echo("lckWdth",lckWdth);
  
  
  //Profile
  prfHght=1;   //Height of Profile
  prfAng=atan((jntDia/2)/(inJntWdth/2));     //Angle of Profile
  prfX1=-jntDia/2;
  prfY1=tan(90-prfAng)*(jntDia/2);
  prfX2=tan(prfAng)*(ovWdth/2);
  prfY2=ovWdth;
  prfLngth=prfX2/sin(prfAng);
  prfDia=2.5;
  echo(prfAng,prfLngth);
  
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