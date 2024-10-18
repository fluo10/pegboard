use <modules/pin.scad>;
use <modules/honeycomb.scad>;
width=48;;
hole_pitch = 25;
vertical_hole_count=4;
height=vertical_hole_count*hole_pitch-4;

hole_radius = 2.5;
stand_depth=sqrt(height^2 - width^2);
tilt=acos(stand_depth/height);

depth=stand_depth/height*width*2;

thickness=2;
vertical_pin_distance = (vertical_hole_count -1)*hole_pitch;

honeycomb_unit_radius = 5;
honeycomb_edge_radius = 1;
honeycomb_offset_x = 2.2;
honeycomb_offset_y = 0;


module pins(){
        translate([0, 0, height/2 - vertical_pin_distance/2 - hole_radius]) {
        translate([-hole_pitch/2, 0, vertical_pin_distance/2]) top_pin();
        translate([hole_pitch/2, 0, vertical_pin_distance/2]) top_pin();
        translate([-hole_pitch/2, 0, -vertical_pin_distance/2]) bottom_pin();
        translate([hole_pitch/2, 0, -vertical_pin_distance/2]) bottom_pin();
        }
}
module stand_frame() {
    translate([0, depth/2, 0]) rotate([-tilt, 0, 0]) {
       translate([-width/2+thickness/2, -width/2+thickness/2, 0]) cube([thickness, thickness, stand_depth], center=true);
        translate([-width/2+thickness/2, width/2-thickness/2, 0]) cube([thickness, thickness, stand_depth], center=true);
        translate([width/2-thickness/2, -width/2+thickness/2, 0]) cube([thickness, thickness, stand_depth], center=true);
        translate([width/2-thickness/2, width/2-thickness/2, 0]) cube([thickness, thickness, stand_depth], center=true);
        translate([0, 0, -stand_depth/2 +thickness/2]) cube([width, width, thickness], center=true); 
        translate([0, 0, stand_depth/2 - thickness/2]) linear_extrude(thickness, center=true) difference(){
            square(width, center=true);
            square(width-thickness*2, center=true);
            
        }
        translate([hole_pitch/2, -width/2+thickness/2, 0]) cube([thickness, thickness, stand_depth], center=true);
        translate([-hole_pitch/2, -width/2+thickness/2, 0]) cube([thickness, thickness, stand_depth], center=true);
    }
}
module stand_side() {
    module stand_side_unit() {
        rotate([90, 0, 0]) translate([-width/2, -stand_depth/2, -thickness/2]) linear_extrude(thickness)  intersection() {
            square([width, stand_depth]);
            translate([honeycomb_offset_x, honeycomb_offset_y, 0]) honeycomb_plane(stand_depth/honeycomb_unit_radius, honeycomb_unit_radius, honeycomb_edge_radius, false);  
        }
    }
    translate([0, depth/2, 0]) rotate([-tilt, 0, 0]) {
        translate([0, -width/2+thickness/2, 0]) stand_side_unit();
        translate([0, +width/2-thickness/2, 0]) stand_side_unit();
        translate([-width/2+thickness/2, 0, 0]) rotate([0,0,90]) stand_side_unit();
        translate([width/2-thickness/2, 0, 0]) rotate([0,0,90]) stand_side_unit();
    }
}

module stand_body() {
}
module stand_body_hollow() {
    translate([0, depth/2, 0]) rotate([-tilt, 0, 0]) translate([0, 0, thickness]) cube([width-2*thickness, width-2*thickness, stand_depth], center=true);
}
module stand_stay() {
    stay_height=max(vertical_pin_distance+hole_radius*2, stand_depth*cos(tilt));
    stay_top_width=stand_depth*sin(tilt);
    stay_bottom_width=(stay_height-cos(tilt)*stand_depth)/sin(tilt);
    module unit() {
        module frame() {
            translate([0, thickness/2, height/2 - stay_height/2]) cube([hole_radius*2, thickness, stay_height], center=true);
            translate([0, stand_depth*sin(tilt)/2 ,height/2-thickness/2]) cube([hole_radius*2, stand_depth*sin(tilt), thickness], center=true);
            translate([0, stand_depth*sin(tilt)/2 ,height/2-stay_height + thickness/2 ]) cube([hole_radius*2, stand_depth*sin(tilt), thickness], center=true); 
        }
        module lattice() {
            translate([0, 0, -height/2]) rotate([90, 0, 90])linear_extrude(hole_radius, center=true) {
                intersection() {
                    union() {
                        
                        polygon([[0, height],[stay_top_width, height], [0, height-cos(tilt)*stand_depth]]);
                        polygon([[0,height-stay_height],[stay_bottom_width, height-stay_height], [0, height-cos(tilt)*stand_depth]]);
                    }
                    honeycomb_plane(stand_depth/honeycomb_unit_radius, honeycomb_unit_radius, honeycomb_edge_radius, false);
                }
            }
        }
        union(){
            frame();
            lattice();
        }
    }
    

    translate([-hole_pitch/2, 0,0]) unit();
    translate([hole_pitch/2, 0, 0]) unit();
    
}
difference() {
    union(){
        pins();
        stand_frame();
        stand_stay();
    }
    stand_body_hollow();
}
stand_side();
//linear_extrude(5) honeycomb_plane(10, 10, 2.5);
