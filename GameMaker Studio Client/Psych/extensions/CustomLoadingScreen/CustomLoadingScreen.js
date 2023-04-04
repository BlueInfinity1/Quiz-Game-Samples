function drawCustomLoadingScreen(graphics, width, height, total, current, loadingScreen) 
{
	//bar settings

	var bar = document.getElementById("Loading Bar");
	var canvas = document.getElementById("canvas");

	var d = new Date();
	var n = d.getTime();

	var barWidth = 228;
	var barHeight = 18;	//height of the loading bar image
	var barScale = 1; //scale of the bar, 1.5 by default

	var x = (width - barWidth*barScale)/2;	//horizontal position of the bar in the image
	var y = (height - barHeight*barScale)/ 2; //vertical position of the bar
	var w = (barWidth / total) * current; //the width of the loading bar during the loading

			
	if (window.innerWidth >= 900 && window.innerHeight >= 600) //the full image will fit, so no need to scale
		var s = 1; //scaleFactor of the splash image
	else //scale the image so that it will fit
	{
		var horScale = window.innerWidth/900;
		var verScale = window.innerHeight/600;

		//use whichever scale is smaller to ensure that the whole image will fit
		if (horScale < verScale)
		var s = horScale;
		else
		var s = verScale;
		
		//recalculate bar position and width now that we've changed the canvas size
		x = (width*s - barWidth*barScale*s)/2;	//horizontal position of the bar in the image
		y = (height*s - barHeight*barScale*s)/ 2; //vertical position of the bar		

		//access the canvas style and change the default offsets
        	var marLeft = -450*s + "px"
        	var marTop = -300*s + "px"
        	canvas.style.transform = "translate("+marLeft+","+marTop+")";
	}
	

	//draw the splash screen
	if (loadingScreen)
	{
		graphics.clearRect(0,0,width,height);
		graphics.drawImage(loadingScreen, 0, 0, width*s, height*s);
	} 

	//draw the loading image
        //TODO: Rotate 
        /*rotationAngle = n/200;
	graphics.save();
	graphics.translate(x, y+100*barScale*s);
	graphics.rotate(rotationAngle*(Math.PI / 180));*/
	//graphics.drawImage(bar, 0, 0, w, barHeight, x+0.5,y+56.5*barScale*s, w*barScale*s, barHeight*barScale*s); //-44 is the offset in the 320x480 image		

	//graphics.restore();
	//alert("sto1p");
}
