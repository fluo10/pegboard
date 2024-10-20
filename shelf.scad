use <modules/pin.scad>;
use <modules/honeycomb.scad>;
hole_pitch=25;
hole_radius=2.5;
holizontal_pin_count=6;
vertical_pin_count=2;
margin=2;
width=holizontal_pin_count*hole_pitch-margin;
height=vertical_pin_count*hole_pitch-margin;
depth=100;
thickness=5;

module pins() {
    module unit() {
        translate([0, 0, (vertical_pin_count-1)*hole_pitch/2]) top_pin();
        translate([0, 0, -(vertical_pin_count-1)*hole_pitch/2]) bottom_pin();
    }
    translate([0, 0, height/2 - (vertical_pin_count-1)*hole_pitch/2-hole_radius]) {
        translate([(holizontal_pin_count-1)*hole_pitch/2, 0, 0]) unit();
        translate([-(holizontal_pin_count-1)*hole_pitch/2, 0, 0]) unit();
    }
    
}
module body() {
    translate([0, depth/2, -height/2+thickness/2]) cube([width, depth, thickness], center=true);
    translate([0, thickness/2, 0]) cube([width, thickness, height], center=true);
}

module stay() {
    stay_length=sqrt((height - thickness) ^2 + (depth - thickness)^2);
    stay_tilt=asin((height-thickness)/stay_length);
    module stay_unit() {
        translate([0, (depth-thickness)/2+thickness/2,0]) rotate([-stay_tilt, 0, 0]) cube([thickness, stay_length, thickness], center=true);
        
        rotate([90, 0, 90]) linear_extrude(thickness, center=true) intersection() {
            polygon([[thickness/2, height/2-hole_radius], [thickness/2, hole_radius-height/2], [depth-thickness, hole_radius-height/2]]);
            translate([0, -height/2, 0]) honeycomb_plane(10, 5, 1, false);
            
        }
        
    }
    translate([width/2-thickness/2, 0, 0]) stay_unit();
    translate([-width/2+thickness/2, 0, 0]) stay_unit();
}

union() {
    pins();
    body();
    stay();
}