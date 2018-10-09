
linFlexure(5,25,35,1.5);

module linFlexure(count, angle, distance, flexWdth, flexLngth=3, thick=3){
  
  $fn=50;
  bWdth=3*flexWdth;
  bLngth1 = distance / cos(angle);
  bLngth2 = tan(angle)*bWdth;
  bLngth=bLngth1 + bLngth2;
  //bHght=beamDims[2];
  bWdth2=norm([bWdth,bLngth2]);//horizontal thickness
  xOffset=sin(angle)*bLngth1;
  fudge=0.1;
  
  difference(){
    rotate(-angle) cube([bWdth,bLngth,thick]);
    translate([-fudge/2,-bLngth2,-fudge/2]) cube([bWdth2+fudge,bLngth2,thick+fudge]);
    translate([xOffset-fudge/2,distance,-fudge/2]) cube([bWdth2+fudge,bLngth2,thick+fudge]);
    
    rotate(-angle) translate([0,bLngth2,0]) slot();
    translate([bWdth2,0,0]) rotate(-angle) slot();
    rotate(-angle) translate([0,bLngth1,0]) rotate(180) slot();
    translate([bWdth2,0,0]) rotate(-angle) translate([0,bLngth1-bLngth2,0]) rotate(180) slot();
    //rotate(-angle) translate([0,bLngth1-flexWdth*4,0]) slot();
    
  }
  
  module slot(){
    translate([0,flexWdth,-fudge/2]) cylinder(r=flexWdth,thick+fudge);
    translate([-flexWdth,flexWdth,-fudge/2]) cube([flexWdth*2,flexLngth,thick+fudge]);
    translate([0,flexWdth+flexLngth,-fudge/2]) cylinder(r=flexWdth,thick+fudge);
  }
  

  
    *for (i=[0:count]){
      translate([i*2*bWdth,0,0]){
        difference(){
        rotate(-angle)
          union(){
            translate([-bWdth/2,0,0]) cube(beamDims);
            cylinder(d=bWdth,h=bHght);
            translate([0,bLngth,0]) cylinder(d=bWdth,h=bHght);
          }
        translate([-(bWdth+fudge)/2,-bWdth/2-fudge,-fudge/2]) cube([bWdth+fudge,bWdth/2+fudge,bHght+fudge]);    
        #translate([-(bWdth+fudge)/2,bLngth+fudge,-fudge/2]) cube([bWdth+fudge,bWdth/2+fudge,bHght+fudge]);    
        }
        }
      }
      
    //
    //translate([-bWdth,bWdth/2+bLngth+fudge,-fudge/2]) cube([bWdth*2*(count+1),bWdth/2+fudge,bHght+fudge]);
}
    
  
