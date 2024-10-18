module honeycomb_cell_round(radius, edge_radius) {
    width=radius * cos(30);
    union() {
        hull() {
            translate([0, radius, 0]) sphere(edge_radius);
            translate([radius * cos(30), radius * sin(30), 0]) sphere(edge_radius);
        }
        hull() {
            translate([radius * cos(30), radius * sin(30), 0]) sphere(edge_radius);
            translate([radius * cos(30), -radius * sin(30), 0]) sphere(edge_radius);
        }
        hull() {
            translate([radius * cos(30), -radius * sin(30), 0]) sphere(edge_radius);
            translate([0, -radius, 0]) sphere(edge_radius);
        }
        hull() {
            translate([0, -radius, 0]) sphere(edge_radius);
            translate([-radius * cos(30), -radius * sin(30), 0]) sphere(edge_radius);
        }
        hull() {
            translate([-radius * cos(30), -radius * sin(30), 0]) sphere(edge_radius);
            translate([-radius * cos(30), radius * sin(30), 0]) sphere(edge_radius);

        }
        hull() {
            translate([-radius * cos(30), radius * sin(30), 0]) sphere(edge_radius);
            translate([0, radius, 0]) sphere(edge_radius);
        }
    }          
}
module honeycomb_cell_plane(radius, edge_radius) {
    union() {
        hull() {
            translate([0, radius, 0]) circle(edge_radius);
            translate([radius * cos(30), radius * sin(30), 0]) circle(edge_radius);
        }
        hull() {
            translate([radius * cos(30), radius * sin(30), 0]) circle(edge_radius);
            translate([radius * cos(30), -radius * sin(30), 0]) circle(edge_radius);
        }
        hull() {
            translate([radius * cos(30), -radius * sin(30), 0]) circle(edge_radius);
            translate([0, -radius, 0]) circle(edge_radius);
        }
        hull() {
            translate([0, -radius, 0]) circle(edge_radius);
            translate([-radius * cos(30), -radius * sin(30), 0]) circle(edge_radius);
        }
        hull() {
            translate([-radius * cos(30), -radius * sin(30), 0]) circle(edge_radius);
            translate([-radius * cos(30), radius * sin(30), 0]) circle(edge_radius);

        }
        hull() {
            translate([-radius * cos(30), radius * sin(30), 0]) circle(edge_radius);
            translate([0, radius, 0]) circle(edge_radius);
        }
    }          
}
module honeycomb_round(edge_count, unit_radius, edge_radius, center=false) {
    module hexagon_line(edge_count, unit_radius, edge_radius) {
        for(i = [0: edge_count-1]) {
            translate([unit_radius*cos(30)*2*i, 0, 0]) honeycomb_cell_round(unit_radius, edge_radius);
        }
    }
    module hexagon_mesh_base(edge_count, unit_radius, edge_radius) {
        for (i = [0: edge_count-1]) {
            if (i % 2==1) {
                translate([unit_radius*cos(30),i*1.5*unit_radius,  0]) hexagon_line(edge_count, unit_radius, edge_radius);
            } else {
                translate([0,i*1.5*unit_radius, 0]) hexagon_line(edge_count, unit_radius, edge_radius);
            }
        }
    }
    if (center){
    } else {
        translate([cos(30)*unit_radius, unit_radius, 0]) hexagon_mesh_base(edge_count, unit_radius, edge_radius);
    }
}
module honeycomb_plane(edge_count, unit_radius, edge_radius, center=false) {
    module hexagon_line(edge_count, unit_radius, edge_radius) {
        for(i = [0: edge_count-1]) {
            translate([unit_radius*cos(30)*2*i, 0, 0]) honeycomb_cell_plane(unit_radius, edge_radius);
        }
    }
    module hexagon_mesh_base(edge_count, unit_radius, edge_radius) {
        for (i = [0: edge_count-1]) {
            if (i % 2==1) {
                translate([unit_radius*cos(30),i*1.5*unit_radius,  0]) hexagon_line(edge_count, unit_radius, edge_radius);
            } else {
                translate([0,i*1.5*unit_radius, 0]) hexagon_line(edge_count, unit_radius, edge_radius);
            }
        }
    }
    if (center){
    } else {
        translate([cos(30)*unit_radius, unit_radius, 0]) hexagon_mesh_base(edge_count, unit_radius, edge_radius);
    }
}
honeycomb_round(4, 1, 0.2, false);
translate([-10, 0, 0]) linear_extrude(2) honeycomb_plane(4, 1, 0.2, false);