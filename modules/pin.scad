hole_radius=2.5;
pin_radius=2.3;
pin_base_length= 6.0;
pin_slit_radius=1;
pin_slit_depth=1;
pin_curve_inner_radius = pin_base_length;
pin_curve_outer_radius = ((pin_base_length + pin_radius) ^2 + (pin_base_length/2)^2);
pin_curve_edge_near_radius = sqrt((pin_base_length - pin_radius) ^2 + (pin_base_length/2) ^2);
pin_curve_edge_far_radius = sqrt(((pin_base_length + pin_radius)^2 + (pin_base_length/2)^2));
pin_curve_edge_circle_ratio= (pin_curve_edge_far_radius - pin_curve_edge_near_radius) / pin_radius /2;
$fn=32;
//assert((pin_curve_edge_near_radius + pin_curve_edge_far_radius)/2 == sqrt(((pin_base_length)^2 + (pin_base_length/2)^2)));
module board() {
    difference(){
        cube([10, 5.5, 10], center=true);
        rotate([90, 0, 0]) cylinder(h=5.6, r=2.4, center=true);
    }
}
module pin_slit() {
    translate([0, -pin_slit_radius, pin_slit_depth]) rotate([90, 0, 0])rotate_extrude() union() {
    translate([pin_radius + pin_slit_radius,0 ,0]) circle(r=pin_slit_radius);
    translate([pin_radius + 2*pin_slit_radius, 0, 0]) square(pin_slit_radius*2, center=true);
    }
}
module half_sphere(radius) {
    difference(){
        sphere(radius);
        translate([0, 0, -radius/2]) cube([radius*2, radius*2, radius], center=true);
    }
}
module top_pin_base() {
    union() {
        translate([0, -pin_base_length/4, 0]) rotate([90, 0, 0]) cylinder(h=pin_base_length/2, r=pin_radius, center=true);
        translate([0, -pin_base_length/2, pin_base_length]) rotate([-90, 0, -90]) rotate_extrude(angle=90) translate([pin_base_length, 0, 0]) circle(pin_radius);
        translate([0, -pin_base_length*1.5,  , pin_base_length*1.25]) cylinder(h=pin_base_length/2, r=pin_radius, center=true);
    }
}
module top_pin_hole() {
    union() {
        translate([0, -pin_base_length/2, pin_base_length])rotate([270, 0, 270]) rotate_extrude(angle=90) translate([pin_curve_inner_radius, 0, 0]) difference() {
                square(hole_radius*4, center=true);
                circle(pin_radius);
        }
        translate([0, -pin_base_length/2, pin_base_length]) rotate([270, 45, 90]) rotate_extrude(angle=180) translate([(pin_curve_edge_near_radius + pin_curve_edge_far_radius)/2, 0, 0]) scale([pin_curve_edge_circle_ratio, 1, 1]) difference(){
                square(hole_radius*4, center=true);
                circle(pin_radius);
        }
    }
}
module top_pin() {
    union(){
        difference() {
            top_pin_base();
            top_pin_hole();
            pin_slit();
        }
        translate([0, -pin_base_length*1.5,  , pin_base_length*1.5]) half_sphere(pin_radius);
        
            

    }
}
module bottom_pin() {
    difference() {
        union() {
            rotate([90, 0, 0]) linear_extrude(pin_base_length) circle(pin_radius);
            translate([0, -pin_base_length, 0]) sphere(r=pin_radius);
        }
        pin_slit();
    }
}

translate([0, 0, 12.5]) top_pin();
translate([0, 0, -12.5]) bottom_pin();