function decodeURIString(uriString)
{
    return decodeURIComponent(uriString);
}

function strLastIndexOf(substr, str)
{
	return str.lastIndexOf(substr);
}

function windowGetXScroll()
{
	return window.pageXOffset;
}

function windowGetYScroll()
{
	return window.pageYOffset;
}

function resizeCanvas(w, h)
{
	var canvas = document.getElementById("canvas");
	canvas.width = w;
	canvas.height = h;
}