use <modules/pin.scad>;
hole_pitch=25;
hole_radius=2.5;
holizontal_pin_count=6;
vertical_pin_count=2;
margin=2;
width=holizontal_pin_count*hole_pitch-margin;
height=vertical_pin_count*hole_pitch-margin;
depth=100;
thickness=2.5;
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
    translate([0, depth/2, 0])difference(){
        cube([width, depth, height], center=true);
        translate([0, 0, thickness]) cube([width-2*thickness, depth - 2*thickness, height], center=true);
    }
}

union() {
    pins();
    body();
}