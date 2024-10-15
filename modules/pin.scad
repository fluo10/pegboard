pin_radius=2.3;
pin_base_length= 5.5;
pin_slit_radius=1;
pin_slit_depth=1.5;
module board() {
    difference(){
        cube([10, 5.5, 10], center=true);
        rotate([90, 0, 0]) cylinder(h=5.6, r=2.4, center=true);
    }
}

module pin_base() {
    difference() {
        rotate([90, 0, 0]) linear_extrude(pin_base_length) circle(pin_radius);
        translate([0, -pin_slit_radius, pin_slit_depth]) rotate([90, 0, 0])rotate_extrude() union() {
    translate([pin_radius + pin_slit_radius,0 ,0]) circle(r=pin_slit_radius);
    translate([pin_radius + 2*pin_slit_radius, 0, 0]) square(pin_slit_radius*2, center=true);
            
        }
        board_curve();
    }
}
module top_pin() {
    union(){
        pin_base();
        translate([0, -pin_base_length, pin_base_length]) rotate([180, 90, 0]) rotate_extrude(angle=90) translate([pin_base_length, 0, 0]) circle(r=pin_radius);
        translate([0, -2*pin_base_length, pin_base_length]) sphere(r=pin_radius);
    }
}
module bottom_pin() {
    union() {
        pin_base();
        translate([0, -pin_base_length, 0]) sphere(r=pin_radius);
    }
}

translate([0, 0, 12.5]) top_pin();
translate([0, 0, -12.5]) bottom_pin();