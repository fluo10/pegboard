use <modules/pin.scad>;
hook_radius = 2.5;
$fn=16;
hook_curve_radius = 5;
hook_angle=45;
module hook_back() {
    module back_part() {
        union() {
            translate([0, hook_radius, 0]) sphere(r=hook_radius);
            translate([0, 2/hook_radius, 0]) rotate([90,0,0])cylinder(h=hook_radius, r=hook_radius, center=true);
        }
    }
    hull() {
        translate([0,0,12.5]) back_part();
        translate([0, 0, -12.5]) back_part();
    }
}

module hook_base() {
    translate([0, hook_radius, -2.5]) cylinder(h=25, r=hook_radius, center=true);
    translate([0, hook_curve_radius + hook_radius, -15]) rotate([270, 0, 270]) rotate_extrude(angle=180-hook_angle) translate([hook_curve_radius, 0,0]) circle(r=hook_radius);
    translate([0, hook_curve_radius + hook_radius, -15]) translate([0, sin(45)*hook_curve_radius, -sin(45)*hook_curve_radius]) hull() {
        sphere(hook_radius);
        translate([0, 5, 5]) sphere(hook_radius);
    }
        


    
}

union() {
    translate([0, 0, 12.5]) top_pin();
    translate([0,0, -12.5]) bottom_pin();
    hook_base();
    hook_back();
}