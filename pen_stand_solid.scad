use <modules/pin.scad>;
width=48;;
hole_pitch = 25;
vertical_hole_count=4;
height=vertical_hole_count*hole_pitch-4;

hole_radius = 2.5;
stand_depth=sqrt(height^2 - width^2);
tilt=acos(stand_depth/height);

depth=stand_depth/height*width*2;

thickness=2.5;
vertical_pin_distance = (vertical_hole_count -1)*hole_pitch;


module pins(){
        translate([0, 0, height/2 - vertical_pin_distance/2 - hole_radius]) {
        translate([-hole_pitch/2, 0, vertical_pin_distance/2]) top_pin();
        translate([hole_pitch/2, 0, vertical_pin_distance/2]) top_pin();
        translate([-hole_pitch/2, 0, -vertical_pin_distance/2]) bottom_pin();
        translate([hole_pitch/2, 0, -vertical_pin_distance/2]) bottom_pin();
        }
}
module stand_body() {
    translate([0, depth/2, 0]) rotate([-tilt, 0, 0]) cube([width, width, stand_depth], center=true);
}
module stand_hollow() {
    translate([0, depth/2, 0]) rotate([-tilt, 0, 0]) translate([0, 0, thickness]) cube([width-2*thickness, width-2*thickness, stand_depth], center=true);
}
module stand_stay() {
    stay_height=max(vertical_pin_distance+hole_radius*2, stand_depth*cos(tilt));
    translate([-hole_pitch/2, stand_depth/height*width/2, height/2 - stay_height/2]) cube([hole_radius*2, stand_depth/height*width, stay_height], center=true);
    translate([hole_pitch/2, stand_depth/height*width/2, height/2 - stay_height/2]) cube([hole_radius*2, stand_depth/height*width, stay_height], center=true);
    
}
difference() {
    union(){
        pins();
        stand_body();
        stand_stay();
    }
    stand_hollow();
}
