    module copy_mirror_adj(vec=[1,1,0])
          {
            children();
            mirror([1,0,0])mirror(vec) children();
          }
    module copy_mirror_opp_y(vec=[0,1,0])
          {
            children();
            mirror(vec) children();
          }
    module copy_mirror_opp_x(vec=[1,0,0])
          {
            children();
            mirror(vec) children();
          }
          
          $fn = 64; //smoother render, this number gives how many frangments are used for a circle

          l = 40;
          h = 20;

          beam_width= .5;
          thick = 3;
          number_of_slots_base = 3;
          number_of_slots_wall = 2;


          num_slots_base = number_of_slots_base * 2;
          num_slots_wall_side = number_of_slots_wall * 2;
          base_slot_width = l / ( num_slots_base + 1);
          fit_base_slot_width = base_slot_width + beam_width;
          wall_slot_width = h / ( num_slots_wall_side + 1);
          fit_wall_slot_width = wall_slot_width + beam_width;
          slot_depth = thick;
          wall_length = l;
          wall_height = h;

//base
          union(){
//fix corners
              copy_mirror_opp_x()
              copy_mirror_adj() 
              translate([-l/2-slot_depth,-l/2-slot_depth,0]) 
              square(size=[slot_depth, slot_depth], center = false);
              translate([-l/2,-l/2,0])
              union(){
                for ( i = [ 0: 2: num_slots_base ] )
                {
                    translate ( [ 0, l, 0 ] ) 
                    translate ( [ (i+.5) * base_slot_width , slot_depth/2, 0 ] ) 
                    square ( size = [ base_slot_width, slot_depth ], center = true );
                    
                    translate ( [ 0, -slot_depth, 0 ] ) 
                    translate ( [ (i+.5) * base_slot_width , slot_depth/2, 0 ] ) 
                    square ( size = [ base_slot_width, slot_depth ], center = true );
                }

                for ( i = [ 0: 2: num_slots_base ] )
                {
                    translate ( [ l, 0, 0 ] ) 
                    translate ( [ slot_depth/2, (i+.5) * base_slot_width, 0 ] ) 
                    square( size = [ slot_depth, base_slot_width ], center = true );
                
                    translate ( [ -slot_depth, 0, 0 ] ) 
                    translate ( [ slot_depth/2, (i+.5) * base_slot_width, 0 ] ) 
                    square (size = [ slot_depth, base_slot_width ], center = true );
                }
                square ( size = [l, l], center = false );          
                }
        }
//wallls

//top and bottom
          copy_mirror_opp_y()
          translate([-l/2,-l/2,0])
          union(){
            for ( i = [ 1: 2: num_slots_base ] )
            {
              translate ( [ 0, l + 1 + thick, 0 ] ) 
              translate ( [ (i+.5) * base_slot_width, slot_depth/2, 0 ] ) 
              square ( size = [ fit_base_slot_width, slot_depth ], center = true );
            }

            translate ( [ 0, l+1+2*thick, 0 ] ) 
            square ( size = [wall_length, wall_height], center = false );
            
            for ( i = [ 0: 2: num_slots_wall_side ] )
                translate ( [ l, l+1+2*thick, 0 ] ) 
                translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] ) 
                square( size = [ slot_depth, wall_slot_width], center = true );
            
            for ( i = [ 0: 2: num_slots_wall_side ] )
                translate ( [ -slot_depth, l+1+2*thick, 0 ] ) 
                translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] ) 
                square (size = [ slot_depth, wall_slot_width ], center = true );
            
            translate([-1.5*thick, l+1+2.5*thick+wall_height, 0]) 
            difference ()
            {
                circle(d=(6+1.4*thick));
                circle(d=1.4*thick);
            }
          }
          
//left and right
          copy_mirror_opp_x()
          mirror([1, 1, 0])
          translate([-l/2,-l/2,0])
          union(){
            for ( i = [ 1: 2: num_slots_base ] )
            {
              translate ( [ 0, l + 1 + thick, 0 ] ) 
              translate ( [ (i+.5) * base_slot_width, slot_depth/2, 0 ] ) 
              square ( size = [ fit_base_slot_width, slot_depth ], center = true );
            }

            translate ( [ 0, l+1+2*thick, 0 ] ) 
            square ( size = [wall_length, wall_height], center = false );
            
            for ( i = [ 1: 2: num_slots_wall_side ] )
                translate ( [ l, l+1+2*thick, 0 ] ) 
                translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] ) 
                square( size = [ slot_depth, fit_wall_slot_width], center = true );
            
            for ( i = [ 1: 2: num_slots_wall_side ] )
                translate ( [ -slot_depth, l+1+2*thick, 0 ] ) 
                translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] ) 
                square (size = [ slot_depth, fit_wall_slot_width ], center = true );
        }


//lid   
        lid_size = l + 2 * thick;
        translate ( [ l/2 + wall_height + 2 + 2*thick, -lid_size/2, 0] )
        difference()
        {   
            square ( size = [lid_size+thick, lid_size], center = false);
            translate ( [ thick, 0, 0] )
            square ( size = [7/2, thick], center = false);
            translate ( [ thick, lid_size -thick, 0] )
            square ( size = [7/2, thick], center = false);
        }