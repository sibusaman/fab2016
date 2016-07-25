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

                $fn = 64; //smoother render, this number gives how many frangments are used for a circle

                l = 155;
                b = 915;
                h = 130;

                base_raise = 30; //height from the floor to the base plate

                beam_width= .35;
                thick = 6;
                number_of_slots_base_len = 2;
                number_of_slots_base_wid = 10;
                number_of_slots_wall = 3;


                num_slots_base_l = number_of_slots_base_len * 2;
                num_slots_base_b = number_of_slots_base_wid * 2;
                num_slots_wall_side = number_of_slots_wall * 2;
                base_slot_width_l = l / ( num_slots_base_l + 1);
                base_slot_width_b = b / ( num_slots_base_b + 1);
                fit_base_slot_width_l = base_slot_width_l + beam_width;
                fit_base_slot_width_b = base_slot_width_b + beam_width;
                wall_slot_width = h / ( num_slots_wall_side + 1);
                fit_wall_slot_width = wall_slot_width + beam_width;
                slot_depth = thick;
                wall_length = l;
                wall_width = b;
                wall_height = h;




                //base
                union(){
      //fix corners

      //              copy_mirror_opp(vec=[1,0,0])  //bottom corners
      //              translate([-l/2-slot_depth,b/2,0])
      //              square(size=[slot_depth, slot_depth], center = false);

      //              copy_mirror_opp(vec=[1,0,0]) //top corners
      //              translate([-l/2-slot_depth,-b/2-slot_depth,0])
      //              square(size=[slot_depth, slot_depth], center = false);

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
                  }
                  for ( i = [ 0: 2: num_slots_wall_side ] )
                      translate ( [ l, b+1+2*thick, 0 ] )
                      translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] )
                      square( size = [ slot_depth, wall_slot_width], center = true );

                  for ( i = [ 0: 2: num_slots_wall_side ] )
                      translate ( [ -slot_depth, b+1+2*thick, 0 ] )
                      translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] )
                      square (size = [ slot_depth, wall_slot_width ], center = true );
                  translate([-1.5*thick, b+2.85*thick+wall_height, 0]) //2.85 is calculted from the below numbers 3 and 1.3
                  difference ()
                  {
                      circle(d=( 3*thick));    //outer diameter
                      circle(d=1.3*thick);        //inner diameter root(2)times the thickness, 1.35 for a tight fit
                  }

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

      //lid
              lid_b = b + 2 * thick;
              lid_l = l + 3.3 * thick;
              translate ( [ l/2 + wall_height + 2 + 2*thick, -lid_b/2, 0] )
              difference()
              {
                  square ( size = [lid_l, lid_b], center = false);    // overall shape of the lid
                  translate ( [ thick, 0, 0] )
                  square ( size = [.87*thick, thick], center = false);                  // bottom cutout
                  translate ( [ thick, lid_b -thick, 0] )
                  square ( size = [.87*thick, thick], center = false);                  //top cutout .87 = thicknes of the anular disk + tolerance
              } 
