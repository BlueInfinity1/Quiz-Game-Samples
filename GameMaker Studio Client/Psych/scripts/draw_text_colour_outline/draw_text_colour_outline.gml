///@description draw_text_colour_outline(x, y, string, textColor1, textColor2, textAlpha, outlineColor1, outlineColor2, outlineAlpha, outlineThickness, outlineQuality, xscale, yscale, angle);
///@param x
///@param y
///@param string
///@param tColor1
///@param tColor2
///@param tAlpha
///@param oColor1
///@param oColor2
///@param oAlpha
///@param oThickness
///@param oQuality
///@param xscale
///@param yscale
///@param angle


var i;
for (i = 0; i < 360; i += 360 / argument10){
    draw_text_transformed_color(argument0 + lengthdir_x(argument9, i), argument1 + lengthdir_y(argument9, i), string(argument2), argument11, argument12, argument13, argument6, argument6, argument7, argument7, argument8);
}
draw_text_transformed_color(argument0, argument1, string(argument2), argument11, argument12, argument13, argument3, argument3, argument4, argument4, argument5);