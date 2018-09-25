

function showMask(){
	// 开始遮罩
	try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();}catch(e){}
}
function hideMask(){
	// 取消遮罩
	try{if(getCtpTop() && getCtpTop().endProc)getCtpTop().endProc();}catch(e){}
}
function getCtpTop(){
  try {
    var A8TopWindow =  getCtpParentWindow(window);
    if(A8TopWindow){
      return A8TopWindow;
    }else{
      return top;
    }
  }
  catch (e) {
    return top;
  }
}
function getCtpParentWindow(win){
  if(win.isCtpTop){
    return win;
  }else{
    getCtpParentWindow(win.parent);
  }
}
