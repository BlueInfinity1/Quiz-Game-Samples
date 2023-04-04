draw_set_color(c_white)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_set_font(fntBigTitleFont)

var titleYPos = room_height/2 - round(windowHeight*0.5) + 32 //orig. y = 32

draw_text(room_width/2,titleYPos,argument0)//categoryName) 

//show_message("Draw title text")
//draw_text(200, room_height/2 + 100, "AASAAAAA") 