/*在此文件中定义了督办使用的提示信息、警告信息及确认信息等提示框，使用此文件，需要框架all-min.js文件支持和dialog.css*/
/*此处有个问题，当id定义为一样时，不知道对弹出框是否有影响，$.dialog的ID不能一样*/
function dbAlert(Y,targetWin){
	var id = "db"+Math.floor(Math.random() * 100000000);//db3423432434
	var X = null;
    if (typeof(Y) == "object") {
        X = Y
    }
    X = X == null ? {}: X;
    if (typeof(Y) != "object") {
        X.msg = Y
    }
    X.id=id;
	$.alert(X);
	divAddClass(id,targetWin);
}

function dbInfor(Y,targetWin){
	var id = "db"+Math.floor(Math.random() * 100000000);//db3423432434
	var X = null;
    if (typeof(Y) == "object") {
        X = Y
    }
    X = X == null ? {}: X;
    if (typeof(Y) != "object") {
        X.msg = Y
    }
    X.id=id;
	$.infor(X);
	divAddClass(id,targetWin);
}

function dbConfirm(X,targetWin){
	var id = "db"+Math.floor(Math.random() * 100000000);//db3423432434
	X.id=id;
	$.confirm(X);
	divAddClass(id,targetWin);
}

function divAddClass(id,targetWin){
	if(typeof(targetWin)!='undefined' && $("#"+id,targetWin.document).length>0){
		$("#"+id,targetWin.document).addClass("supervision");
	}else if($("#"+id).length>0){
		$("#"+id).addClass("supervision");
	}else{
		$("#"+id,getCtpTop().document).addClass("supervision");
	}
}

