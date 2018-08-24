
M577origDims= [1.37+1.57,0.575*2,0.65];
factor=60;
fudge=0.1;

axisWidth= 52;

mirror([0,1,0]){
translate([-23,-(27.5-19.5+axisWidth/2),0])
  rotate([-90,180,0]) 
    import("DC_Motor_20mm.stl");
    
translate([-28,(27.5-19.2+axisWidth/2),0])
  rotate([90,0,0]) 
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
translate([-60,-12,2]) batX1();

//FPV Cam    
translate([40,14,22])
  rotate([90,0,90])
  FPV1000TVL();

//Track
translate([25,-40,12]) rotate([90,90,0]) cogWheel();
  
module motorShield(){
  cube([59,43,19],true);
}

module bat18650(){
  rotate([0,90,0]) cylinder(h=65,d=18,center=true);
}


module batX1(){
  //Extron 650mAh 2S LiPo
  translate([0,0,18/2]) cube([50,25,18],true);
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


module cogWheel(showTrack=true){
  $fn=50;
  bearingDia=22;
  bearingThick=7;
  ovDia=36.2;
  ovThick=10;
  X=5;
  
  impTrackOff=[-20,0,-18];
  trackDia=7;
  
  if (showTrack)
  for (ang=[30:30:180])
  rotate(ang)  
    translate([ovDia/2,0,ovThick/2]) 
      rotate(75) translate(impTrackOff) 
        rotate([90,0,0]) import("Track.stl");
  
  difference(){
    cylinder(d=ovDia-1,h=ovThick);
    translate([0,0,-fudge/2]) cylinder(d=bearingDia,h=bearingThick+fudge);
    translate([0,0,-fudge/2]) cylinder(d=bearingDia-4,h=ovThick+fudge);
    
    for (ang=[0:30:330]){
      rotate(ang)
        translate([ovDia/2,0,-fudge/2]) 
          cylinder(d=trackDia,h=bearingThick*1.5+fudge);
  }
}
}