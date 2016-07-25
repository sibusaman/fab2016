thick = 3;
beam_width = .2;
link_dia = 25;
slot_width = 10; //width of the center slort, this can't be less thatthe thick ness of the material, also leave enough margin. recomended min is 10mm fo 6mm thick material
fit_depth = 6; //extend of overlap between the pressfit, 10 means each set will have a 5mm slot, so that there is a10mm total frictional contact area

fit_thick = thick - beam_width;
translate ([link_dia + 5, 0, 0])
difference()
{
    circle (d=link_dia);
    
    square ( size = [ slot_width, fit_thick ], center = true );
    square ( size = [ fit_thick, slot_width ], center = true );
   
    for (i = [0:45:360])
    {
        temp1 = link_dia/2;
        //uncomment the following line for testing
        //temp1 = link_dia/2 - fit_depth/2;
        
        
        rotate(i)
            translate([temp1, 0, 0])
                square ( size = [ fit_depth, fit_thick ], center = true );
    }
}

translate ([12, 0, 0])
difference()
{
    square (size = [ slot_width, 40], center = true);
    for (i = [0:180:360])
        {
            
            rotate(i)
            translate([0, 20, 0])
            square ( size = [ fit_thick, fit_depth ], center = true );
        }
}

difference()
{
    square (size = [ slot_width, 20], center = true);
    for (i = [0:180:360])
        {
            
            rotate(i)
            translate([0, 10, 0])
            square ( size = [ fit_thick, fit_depth ], center = true );
        }
}

translate ([-12, 0, 0])
difference()
{
    square (size = [ slot_width, 60], center = true);
    for (i = [0:180:360])
        {
            
            rotate(i)
            translate([0, 30, 0])
            square ( size = [ fit_thick, fit_depth ], center = true );
        }
}
            