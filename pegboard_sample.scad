hole_radius= 2.5;
hole_pitch= 25;
min_depth= 2.5;
padding=5;
board_width = hole_radius*2 + padding*2;
board_height = hole_pitch + hole_radius*2 + padding*2;
edge_width = 2;
edge_radius = 3;
eps=0.01;
$fn=16;
height=1;
module pegboard_sample(depth) {
    edge_height = max(depth, min_depth);
    module pegboard_sample_base() {
        translate([0, 0, -depth/2]) linear_extrude(depth, center=true) hull() {
            translate([edge_radius - board_width/2, edge_radius - board_height/2, 0]) circle(edge_radius);
            translate([edge_radius - board_width/2, board_height/2 - edge_radius, 0]) circle(edge_radius);
            translate([board_width/2 - edge_radius, edge_radius - board_height/2, 0]) circle(edge_radius);
            translate([board_width/2 - edge_radius, board_height/2 - edge_radius, 0]) circle(edge_radius);
        }
        
    }
    module pegboard_sample_edge() {
        translate([0, 0, -edge_height/2]) union() {
            translate([board_width/2 - edge_width/2, 0, 0]) rotate([90, 0, 0]) linear_extrude(board_height - 2*edge_radius + edge_width, center=true) square([edge_width, edge_height], center=true);
            translate([edge_width/2-board_width/2, 0, 0]) rotate([90, 0, 0]) linear_extrude(board_height - 2*edge_radius, center=true) square([edge_width, edge_height], center=true);
            translate([0, board_height/2 - edge_width/2, 0]) rotate([90, 0, 270]) linear_extrude(board_width - 2*edge_radius, center=true) square([edge_width, edge_height], center=true);
            translate([0, edge_width/2 - board_height/2 , 0]) rotate([90, 0, 90]) linear_extrude(board_width - 2*edge_radius, center=true) square([edge_width, edge_height], center=true);
            translate([board_width/2 - edge_radius, board_height/2 - edge_radius, 0]) rotate_extrude(angle=90) translate([edge_radius - edge_width/2, 0, 0]) square([edge_width, edge_height], center=true);
            translate([board_width/2 - edge_radius, edge_radius - board_height/2 , 0]) rotate([0, 0, -90]) rotate_extrude(angle=90) translate([edge_radius - edge_width/2, 0, 0]) square([edge_width, edge_height], center=true);
            translate([edge_radius - board_width/2, board_height/2 - edge_radius, 0]) rotate([0, 0, 90])  rotate_extrude(angle=90) translate([edge_radius - edge_width/2, 0, 0]) square([edge_width, edge_height], center=true);
            translate([edge_radius - board_width/2, edge_radius - board_height/2, 0]) rotate([0, 0, 180 ])rotate_extrude(angle=90) translate([edge_radius - edge_width/2, 0, 0]) square([edge_width, edge_height], center=true);
        }
    }
    module pegboard_sample_hole() {
        translate([0, -hole_pitch/2, -depth/2]) cylinder(h=depth*2, r = hole_radius, center=true);
        translate([0, hole_pitch/2, -depth/2]) cylinder(h=depth*2, r = hole_radius, center=true);
    }
    module pegboard_sample_label() {
        translate([board_width/2, board_height/2-edge_radius, - edge_height*0.8]) rotate([90, 0, 90])linear_extrude(1, center=true)    text(str("↕", depth, "mm"), size=edge_height*0.8, halign="right", valign="baseline", font="Liberation Mono:style=Regular");
    }

        difference() {
            union() {
            pegboard_sample_edge();
            pegboard_sample_base();
            }
            union() {
            pegboard_sample_hole();
            pegboard_sample_label();
        }
    }
        
}

pegboard_sample(height);
