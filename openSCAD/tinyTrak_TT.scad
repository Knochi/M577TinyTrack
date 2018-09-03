useN20s=false;

/* [Hidden] */
M577origDims= [1.37+1.57,0.575*2,0.65];
factor=60;
fudge=0.1;

axisWidth= 52;


if (useN20s){
  translate([ 25.20, -26, 11.48 ]) rotate([0,0,90]) import("N20_gear_motor.stl");
  translate([ -73.09, 26, 11.03 ]) rotate([0,0,-90]) import("N20_gear_motor.stl");  
}
else
{
translate([ -73.71, 26, 14 ])
  rotate([90,180,0])
    translate([-53,-11.2,0])
    import("DC_Motor_20mm.stl");
    
translate([ 25.78, -26, 14 ])
  rotate([-90,0,0]) 
  translate([-53,-11.2,0])
    import("DC_Motor_20mm.stl");
}



%translate([-110,0,M577origDims[2]*factor/2-20])
rotate(90)
  scale(factor)
    import("M577body.stl");

//electronis    
translate([-80,-22,30])
  rotate([90,0,-90])
  //motorShield();
import("WEMOS_D1mini.stl");



//batteries
translate([-60,-14,2]) batX1();

//FPV Cam    
translate([40,14,22])
  rotate([90,0,90])
  FPV1000TVL();

//Track
translate([25,-28,12]) rotate([90,90,0]) cogWheel();
  
module motorShield(){
  cube([59,43,19],true);
}

module bat18650(){
  rotate([0,90,0]) cylinder(h=65,d=18,center=true);
}


module batX1(){
  //Extron 650mAh 2S LiPo
  translate([0,0,25/2]) cube([50,18,25],true);
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

!cogWheel(true);
module cogWheel(showTrack=true){
  $fn=50;
  bearingDia=22;
  bearingThick=7;
  ovDia=30; //
  ovDiaOffset=1.5;
  ovThick=10;
  X=5;
  
  impTrackOff=[-20,0,-5];
  trackDia=6;
  
  if (showTrack)
  for (ang=[30:30:180])
  rotate(ang)  
      rotate([90,0,0]) translate([ovDia/2,0,0]) rotate([0,90+15,0]) track(ovDia,jntDia=5);//import("Track.stl");
  
  difference(){
    //cylinder(d=ovDia-ovDiaOffset,h=ovThick,center=true);
    chamfWheel(ovDia-ovDiaOffset,ovThick,(ovThick-4)/2);
    translate([0,0,-(ovThick+fudge)/2])cylinder(d=bearingDia,h=bearingThick+fudge);
    cylinder(d=bearingDia-4,h=ovThick+fudge,center=true);
    
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
      



module track(cogDia=20,cogAng=30,jntDia=6,showProfile=false){
  $fn=50;
  
  //Dimensions
  ovWdth=20; //36
  //ovLngth=9.3; //Length of Track from joint center2center
  ovLngth=2*(cogDia/2)*sin(cogAng/2); //ovLength from Dia and Angle
  ovHght=3;    //body height above joint center
  
  //joints
  //jntDia=6;
  jntClrnc=0.5;//clearance between inner and outer joint cylinder
  inJntWdth=ovWdth*0.65;//width of inner joint cylinder
  outJntWdth=(ovWdth-inJntWdth)/2;
  lckDpth=(jntDia)/2; //locking depth below joint center
  lckWdth=inJntWdth/3; //width of the locking feature
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

//chamfer(3,20);
module chamfer(s,l){
  linear_extrude(l)
    polygon([[-fudge/2,-fudge/2],[-fudge/2,s+fudge/2],[s+fudge/2,-fudge/2]]);
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

module microStepper(){
  $fn=50;
  //Pollin 310776
  cylinder(d=1.5,h=15); //axis
  cylinder(d=10,h=12); //motor
  
}