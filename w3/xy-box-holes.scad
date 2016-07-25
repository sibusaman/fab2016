module copy_mirror_adj(vec=[1,1,0])
      {
        children();
        mirror([1,0,0])mirror(vec) children();
      }
module copy_mirror_opp(vec=[0,1,0])
      {
        children();
        mirror(vec) children();
      }
module copy_tran(vec=[0,0,0])
      {
        children();
        translate(vec) children();
      }

      $fn = 64; //smoother render, this number gives how many fragments are used for a circle

      l = 60;
      b = 60;
      h = 30;

      base_raise = 0;

      beam_width= .3;
      thick = 4;

      g_rod_1_dia = 5.95;
      g_rod_2_dia = 7.95;
      t_rod_dia = 8 ;

      number_of_slots_base_len = 5;
      number_of_slots_base_wid = 3;
      number_of_slots_wall = 2;

      wall_length = l;
      wall_width = b;
      wall_height = h+2*thick;

      num_slots_base_l = number_of_slots_base_len * 2;
      num_slots_base_b = number_of_slots_base_wid * 2;
      num_slots_wall_side = number_of_slots_wall * 2;
      base_slot_width_l = l / ( num_slots_base_l + 1);
      base_slot_width_b = b / ( num_slots_base_b + 1);
      fit_base_slot_width_l = base_slot_width_l + beam_width;
      fit_base_slot_width_b = base_slot_width_b + beam_width;
      wall_slot_width = wall_height / ( num_slots_wall_side + 1);
      fit_wall_slot_width = wall_slot_width + beam_width;
      slot_depth = thick;

//base and top
      copy_tran([l + 2*thick +1,b + 2*thick +1, 0])
      union(){
          translate([-l/2,-b/2,0])
          union(){
            for ( i = [ 1: 2: num_slots_base_l ] ) //top and bottom slots
            {
                translate ( [ 0, b, 0 ] )
                translate ( [ (i+.5) * base_slot_width_l , slot_depth/2, 0 ] )
                square ( size = [ fit_base_slot_width_l, slot_depth ], center = true );

                translate ( [ 0, -slot_depth, 0 ] )
                translate ( [ (i+.5) * base_slot_width_l , slot_depth/2, 0 ] )
                square ( size = [ fit_base_slot_width_l, slot_depth ], center = true );
            }

            for ( i = [ 1: 2: num_slots_base_b ] ) //left and right slots
            {
                translate ( [ l, 0, 0 ] )
                translate ( [ slot_depth/2, (i+.5) * base_slot_width_b, 0 ] )
                square( size = [ slot_depth, fit_base_slot_width_b ], center = true );

                translate ( [ -slot_depth, 0, 0 ] )
                translate ( [ slot_depth/2, (i+.5) * base_slot_width_b, 0 ] )
                square (size = [ slot_depth, fit_base_slot_width_b ], center = true );
            }
            square ( size = [l, b], center = false );
            }
    }

//wallls
//top and bottom walls
    copy_mirror_opp(vec=[0,1,0])
    translate([-l/2,-b/2,0])
    union()
    {
        difference()
        {
            translate ( [ 0, b+1+2*thick, 0 ] )
            square ( size = [wall_length, wall_height], center = false );

            for ( i = [ 1: 2: num_slots_base_l ] )
                {
                    translate ( [ 0, b + 1 + 2*thick + base_raise, 0 ] )
                    translate ( [ (i+.5) * base_slot_width_l, slot_depth/2, 0 ] )
                    square ( size = [ base_slot_width_l, slot_depth ], center = true );
                }
            for ( i = [ 1: 2: num_slots_base_l ] )
                {
                    translate ( [ 0, b + 1 + thick + base_raise + wall_height, 0 ] )
                    translate ( [ (i+.5) * base_slot_width_l, slot_depth/2, 0 ] )
                    square ( size = [ base_slot_width_l, slot_depth ], center = true );
                }

            translate([3*thick, b + 1 + 3*thick + base_raise + g_rod_1_dia + h/3, 0 ])
            circle(d=g_rod_1_dia);

            translate([l-3*thick, b + 1 + 3*thick + base_raise + g_rod_1_dia + h/3, 0 ])
            circle(d=g_rod_1_dia);

            translate([l/2, b  + 3*thick + base_raise + t_rod_dia + h/3, 0 ])
            circle(d=t_rod_dia);
        }
        for ( i = [ 0: 2: num_slots_wall_side ] )
            translate ( [ l, b+1+2*thick, 0 ] )
            translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] )
            square( size = [ slot_depth, wall_slot_width], center = true );

        for ( i = [ 0: 2: num_slots_wall_side ] )
            translate ( [ -slot_depth, b+1+2*thick, 0 ] )
            translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] )
            square (size = [ slot_depth, wall_slot_width ], center = true );
    }

//left and right walls
    copy_mirror_opp(vec=[1,0,0])
    mirror([1, 1, 0])
    translate([-b/2,-l/2,0])
    union()
    {
        difference()
        {
            translate ( [ 0, l+1+2*thick, 0 ] )
            square ( size = [wall_width, wall_height], center = false );

            for ( i = [ 1: 2: num_slots_base_b ] )
            {
                translate ( [ 0, l + 1 + 2*thick + base_raise, 0 ] )
                translate ( [ (i+.5) * base_slot_width_b, slot_depth/2, 0 ] )
                square ( size = [ base_slot_width_b, slot_depth ], center = true );
            }
            for ( i = [ 1: 2: num_slots_base_b ] )
            {
                translate ( [ 0, l + 1 + thick + base_raise + wall_height, 0 ] )
                translate ( [ (i+.5) * base_slot_width_b, slot_depth/2, 0 ] )
                square ( size = [ base_slot_width_b, slot_depth ], center = true );
            }

            translate([3*thick, l + 3*thick + base_raise + g_rod_2_dia + h/3, 0 ])
            circle(d=g_rod_2_dia);

            translate([b-3*thick, l + 3*thick + base_raise + g_rod_2_dia + h/3, 0 ])
            circle(d=g_rod_2_dia);

            translate([b/2, l  + 3*thick + base_raise + t_rod_dia + h/3 , 0 ])
            circle(d=t_rod_dia);
        }

        for ( i = [ 1: 2: num_slots_wall_side ] )
            translate ( [ wall_width, l+1+2*thick, 0 ] )
            translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] )
            square( size = [ slot_depth, fit_wall_slot_width], center = true );

        for ( i = [ 1: 2: num_slots_wall_side ] )
            translate ( [ -slot_depth, l+1+2*thick, 0 ] )
            translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] )
            square (size = [ slot_depth, fit_wall_slot_width ], center = true );
    }