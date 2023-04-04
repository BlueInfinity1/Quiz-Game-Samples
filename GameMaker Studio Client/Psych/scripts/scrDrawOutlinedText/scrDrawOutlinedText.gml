/// @description draw_text_outline(x, y, text, textColor, outlineColor,outlineWidth, spacing,widthPerLine);
/// @param x
/// @param y
/// @param text
/// @param textColor
/// @param outlineColor
/// @param outlineWidth
/// @param spacing
/// @param widthPerLine

var xx=argument0;
var yy=argument1;
var text=argument2;
var tcolor=argument3;
var ocolor=argument4;
var outlineWidth = argument5
var spacing = argument6;
var maxTextWidth = argument7
   
draw_set_color(ocolor);

/*for (var i = 1; i < outlineWidth+1; i += 1)
{

	draw_text_ext(xx-i, yy, text, spacing, maxTextWidth);
	draw_text_ext(xx+i, yy, text, spacing, maxTextWidth);
	draw_text_ext(xx, yy-i, text, spacing, maxTextWidth);
	draw_text_ext(xx, yy+i, text, spacing, maxTextWidth);

	if outlineWidth != 1
	{
		draw_text_ext(xx-i, yy-i, text, spacing, maxTextWidth);
		draw_text_ext(xx-i, yy+i, text, spacing, maxTextWidth);
		draw_text_ext(xx+i, yy-i, text, spacing, maxTextWidth);
		draw_text_ext(xx+i, yy+i, text, spacing, maxTextWidth);
	}
}*/
 

	draw_text_ext(xx-outlineWidth, yy, text, spacing, maxTextWidth);
	draw_text_ext(xx+outlineWidth, yy, text, spacing, maxTextWidth);
	draw_text_ext(xx, yy-outlineWidth, text, spacing, maxTextWidth);
	draw_text_ext(xx, yy+outlineWidth, text, spacing, maxTextWidth);

	if argument5 != 1
	{
		draw_text_ext(xx-outlineWidth, yy-outlineWidth, text, spacing, maxTextWidth);
		draw_text_ext(xx-outlineWidth, yy+outlineWidth, text, spacing, maxTextWidth);
		draw_text_ext(xx+outlineWidth, yy-outlineWidth, text, spacing, maxTextWidth);
		draw_text_ext(xx+outlineWidth, yy+outlineWidth, text, spacing, maxTextWidth);
	}

 
draw_set_color(tcolor);
draw_text_ext(xx, yy, text, spacing, maxTextWidth);