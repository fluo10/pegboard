use <modules/pin.scad>;
use <modules/honeycomb.scad>;
hole_pitch=25;
hole_radius=2.5;
holizontal_pin_count=5;
vertical_pin_count=2;
margin=2;
width=holizontal_pin_count*hole_pitch-margin;
height=vertical_pin_count*hole_pitch-margin;
depth=100;
front_top_tilt=60;
front_bottom_tilt=60;
front_height=height/2;
side_bottom_edge_length=depth - front_height/tan(front_bottom_tilt);
side_top_edge_length=depth - (height-front_height)/tan(front_top_tilt);
honeycomb_front_offset_y=-4;

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
    module side_panel() {
        rotate([90, 0, 90])linear_extrude(thickness, center=true) 
        union(){
            intersection() {
                polygon([
                    [thickness/2, height/2-hole_radius],
                    [side_top_edge_length - thickness/2, height/2-hole_radius],
                    [depth-thickness/2, front_height-height/2], 
                    [side_bottom_edge_length - thickness/2, -height/2+hole_radius],
                    [thickness/2, hole_radius-height/2]
                ]);
                translate([0, -height/2+honeycomb_front_offset_y, 0]) honeycomb_plane(11, 5, 1, false);
            }
            difference() {
                polygon([
                    [0, height/2],
                    [side_top_edge_length, height/2],
                    [depth, front_height-height/2], 
                    [side_bottom_edge_length, -height/2],
                    [0,-height/2]
                ]);
                polygon([
                    [thickness, height/2-thickness],
                    [side_top_edge_length - thickness/tan((180-front_top_tilt)/2), height/2-thickness],
                    [depth-thickness/sin(front_top_tilt), front_height-height/2], 
                    [side_bottom_edge_length - thickness/tan((180-front_bottom_tilt)/2), -height/2+thickness],
                    [thickness, thickness-height/2]
                ]);
            }
        }
    }
    module back_panel() {
        rotate([90, 0, 0]) linear_extrude(thickness, center=true) 
        union(){
            intersection() {
                square([width, height], center=true);
                translate([-width/2, -height/2, 0]) honeycomb_plane(14, 5, 1, false);
            }
            difference() {
                square([width, height], center=true);
                square([width-2*thickness, height-2*thickness], center=true);
            }


        }
        translate([(holizontal_pin_count-1)*hole_pitch/2, 0, 0]) cube([hole_radius*2, thickness, height], center=true);
        translate([-(holizontal_pin_count-1)*hole_pitch/2, 0, 0]) cube([hole_radius*2, thickness, height], center=true);
    }
    module front_panel() {
        linear_extrude(thickness, center=true) 
        union(){
            intersection() {
                square([width, front_height/sin(front_bottom_tilt)], center=true);
                translate([-width/2, -height/2, 0]) honeycomb_plane(14, 5, 1, false);
            }
            difference() {
                square([width, front_height/sin(front_bottom_tilt)], center=true);
                square([width-2*thickness, front_height/sin(front_bottom_tilt)-2*thickness], center=true);
            }


        }
    }
    translate([width/2-thickness/2, 0, 0]) side_panel();
    translate([-width/2+thickness/2, 0, 0]) side_panel();
    back_panel();
    translate([0, side_bottom_edge_length/2, -height/2+thickness/2]) cube([width, side_bottom_edge_length, thickness], center=true);
    translate([0, depth - front_height/tan(front_bottom_tilt)+thickness/sin(front_bottom_tilt)*2, -height/2+front_height/2 + thickness/tan(front_bottom_tilt)/2]) rotate([front_bottom_tilt, 0, 0]) front_panel();
}

union() {
    pins();
    body();
}