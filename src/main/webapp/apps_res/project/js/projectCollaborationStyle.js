var objWidth=new Object();
//单列表且是全屏 or分辨率是1024(剔除IE7的情况)
//navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/7./i)=="7."
var flag=(columnsStyle==1&&iframeWidth>1000);
//标题默认宽度(单位百分比%)
objWidth.subject=flag?200:100;
//创建时间默认宽度(单位百分比%)
objWidth.createDate=flag?58:58;
//发起人默认宽度(单位百分比%)
objWidth.senderId=flag?48:48;

/**
*初始化栏目高度,计算iframe和标题列宽度
*/
function initCssStyle(){
	//初始化iframe的宽度和高度
	initIframeWidth();
	//计算标题所在li元素所占宽度(包括图标)
	initSubjectLiWidth();
	//根据图标计算标题展示宽度(不包含图标)
	initSubjectWidth();
}

function initIframeWidth(){
	//初始化div宽度
	initDivWidth();
	//初始化栏目panel面板高度
	initPanelWidth();
}

/**
*初始化div宽度
*/
function initDivWidth(){
	if(iframeWidth>1000){
		$("#leftListDiv,#rightListDiv").css("width",columnsStyle=="1"?(iframeWidth-2):(iframeWidth-10)/2);
	}else{
		if(sfyData=="true"){
			//先判断有没有数据
			if((screen.width==1024&&widthSize==5)){
				iframeWidth+=250;
			}else if(widthSize==2){
				iframeWidth+=400;
			}
		}
		$("#leftListDiv,#rightListDiv").css("width",iframeWidth-2);
	} 
}
/**
*初始化栏目panel面板高度
*/
function initPanelWidth(){
	var secId=0;
	try{
		secId=sectionId;
	}catch(e){
	}
	var templeteObj=window.parent.$("#"+secId+"TD iframe");//iframe对象
	templeteObj.height(columnsCount*$("ul li").eq(0).height()+20);
}
/**
*计算标题所在li元素所占宽度(包括图标)
*/
function initSubjectLiWidth(){
	var ifamewidth=95;
	var columnList=columnProperty.split(",");
	var columnWidth=0;
	for(var i=0;i<columnList.length;i++){
		if(columnList[i]!="subject"&&objWidth[columnList[i]]!=undefined){
			if (columnList[i]=="createDate" && $("[name='"+columnList[i]+"']").html() != undefined) {
				columnWidth+=68;
				$("[name='"+columnList[i]+"']").css("width","68px");
			} else {
				columnWidth+=objWidth[columnList[i]];
				$("[name='"+columnList[i]+"']").css("width",objWidth[columnList[i]]+"px");
			}
		}
	}
	var subjectWidth=ifamewidth-columnWidth;
	var stateWidth=$("[name='state']").eq(0).width();
	var forwardWidth=$("[name='canForward']").eq(0).width();
	var createDateWidth=$("[name='createDate']").eq(0).width();
	var senderIdWidth=$("[name='senderId']").eq(0).width();
	var leftDivWidth=$("#leftListDiv").width();
	subjectWidth=leftDivWidth-stateWidth-forwardWidth-createDateWidth-senderIdWidth-2;
	$("ul").find("[name='subject']").css("width",subjectWidth-20);
}

/**
*根据图标计算标题展示宽度(不包含图标)
*/
function initSubjectWidth(){
	var subjectList=$("[name='subject']");
	for(var i=0;i<subjectList.length;i++){
		//标题所在li元素宽度
		var subjectLiWith=$(subjectList[i]).width();
		//li元素下所有图标
		var spanList=$(subjectList[i]).find("span");
		var subjectTitleWidth=$(subjectList[i]).find("a").width();
		var spanWith=0;
		for(var j=0;j<spanList.length;j++){
			spanWith+=$(spanList[j]).width();
		}
		if(subjectTitleWidth+spanWith>subjectLiWith){
			$(subjectList[i]).find("a").eq(0).css("width",subjectLiWith-spanWith-10);
		}
	}
	
}
