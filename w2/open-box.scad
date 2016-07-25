 module copy_mirror_adj(vec=[1,1,0])
 {
   children();
   mirror([1,0,0])mirror(vec) children();
 }

 l = 65;
 h = 20;

 beam_width= .25;
 thick = 3.2;
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
 //wallls

 copy_mirror_adj()
 copy_mirror_adj()
 copy_mirror_adj() //these copy_mirror modules rotates and duplicates one wall into four.
 translate([-l/2,-l/2,0])
 union(){
   for ( i = [ 1: 2: num_slots_base ] )
   {
       translate ( [ 0, l + 1 + thick, 0 ] )
       translate ( [ (i+.5) * base_slot_width, slot_depth/2, 0 ] )
       square ( size = [ fit_base_slot_width, slot_depth ], center = true );
   }

   translate ( [ 0, l+1+2*thick, 0 ] )
   square ( size = [wall_length, wall_height], center =false );

   for ( i = [ 1: 2: num_slots_wall_side ] )
       translate ( [ l, l+1+2*thick, 0 ] )
       translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] )
       square( size = [ slot_depth, fit_wall_slot_width], center = true );

   for ( i = [ 0: 2: num_slots_wall_side ] )
       translate ( [ -slot_depth, l+1+2*thick, 0 ] )
       translate ( [ slot_depth/2, (i+.5)*wall_slot_width, 0 ] )
       square (size = [ slot_depth, wall_slot_width ], center = true );
 }