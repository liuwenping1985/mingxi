//原左侧导航收起
function onLoadLeft(){
	try {
		if(getA8Top().contentFrame.document.getElementById("LeftRightFrameSet").cols != "132,*"){
			getA8Top().contentFrame.leftFrame.closeLeft("yes");
		}
	} catch(e) {}
}

//原左侧导航展开
function unLoadLeft(){
	try {
		getA8Top().contentFrame.leftFrame.closeLeft();
	} catch(e) {}
}