
/**
 * 加签窗口
 */
function edocPreInsertPeople(summaryId, processId, affairId, appName, isForm){
	if(!checkModifyingProcessAndLock(processId, summaryId,appName)){
		return;
	}
	
	//检测xmls是否已经被加载
	initCaseProcessXML();
	
	var edoc = "";
	var targetWindow  = getA8Top();
	if(appName != "collaboration"){
		edoc = "&edoc=edoc";
		targetWindow = window;
	}

	if(v3x.getBrowserFlag('pageBreak')){
	    //mark by xuqiangwei Chrome37修改，这里应该没有用了
		var rv = v3x.openWindow({
	        url: edocURL + "?method=preInsertPeople&summaryId=" + summaryId + "&affairId=" + affairId + "&appTypeName=" + appTypeName+"&appName=" + appName + "&isForm=" + isForm + "&processId=" + processId + edoc,
	        width: 800,
	        height: 580
	    });
	    rvInsertPeople(rv);
	}else{
		var divObj = "<div id=\"insertPeopleWin\" closed=\"true\">" +
					 	"<iframe id=\"insertPeopleWin_Iframe\" name=\"insertPeopleWin_Iframe\" width=\"100%\" height=\"100%\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
					 "</div>";
		targetWindow.$(divObj).appendTo("body");
		targetWindow.$("#insertPeopleWin").dialog({
			title: v3x.getMessage("collaborationLang.insertPeople"),
			top: 50,
			left:50,
			width: 630,
			height: 510,
			closed: false,
			modal: true,
			buttons:[{
						text:v3x.getMessage("collaborationLang.submit"),
						handler:function(){
							var rv = targetWindow.$("#insertPeopleWin_Iframe").get(0).contentWindow.OK();
							rvInsertPeople(rv);
						}
					},{
						text:v3x.getMessage("collaborationLang.cancel"),
						handler:function(){
						targetWindow.$('#insertPeopleWin').dialog('destroy');
						}
					}]
		});
		targetWindow.$("#insertPeopleWin_Iframe").attr("src",edocURL + "?method=preInsertPeople&summaryId=" + summaryId + "&affairId=" + affairId + "&appName=" + appName + "&isForm=" + isForm + "&processId=" + processId + edoc);
	}
}



/**
 * 当前会签窗口
 */
function preColAssign(summaryId, processId, affairId){
	if(!checkModifyingProcessAndLock(processId, summaryId)){
		return;
	}
	
	//检测xmls是否已经被加载
	initCaseProcessXML();
	
	var appName = "";
	try{
	    appName = document.getElementById("appName").value;
	}catch(e){}
	var targetWindow  = getA8Top();
	var app = "";
	if(appName == "4"){
		app = "&from=edoc&appName=4";
		targetWindow = window;
	}else{
	    app = "&from=collaboration&appName=1";
	}
	
	if(v3x.getBrowserFlag('pageBreak')){
	    //mark by xuqiangwei Chrome37修改，这里应该没有用了
		var rv = v3x.openWindow({
        	url: colWorkFlowURL + "?method=preColAssign&summaryId=" + summaryId + "&affairId=" + affairId + "&processId=" + processId + app,
        	width: 400,
        	height: 280
    	});
    	rvColAssign(rv);
	}else{
		var divObj = "<div id=\"colAssignWin\" closed=\"true\">" +
					 	"<iframe id=\"colAssignWin_Iframe\" name=\"colAssignWin_Iframe\" width=\"100%\" height=\"100%\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
					 "</div>";
		targetWindow.$(divObj).appendTo("body");
		targetWindow.$("#colAssignWin").dialog({
			title: v3x.getMessage("collaborationLang.colAssign"),
			top: 50,
			left:50,
			width: 630,
			height: 480,
			closed: false,
			modal: true,
			buttons:[{
						text:v3x.getMessage("collaborationLang.submit"),
						handler:function(){
							var rv = targetWindow.$("#colAssignWin_Iframe").get(0).contentWindow.OK();
							rvColAssign(rv);
						}
					},{
						text:v3x.getMessage("collaborationLang.cancel"),
						handler:function(){
						targetWindow.$('#colAssignWin').dialog('destroy');
						}
					}]
		});
		targetWindow.$("#colAssignWin_Iframe").attr("src",colWorkFlowURL + "?method=preColAssign&summaryId=" + summaryId + "&affairId=" + affairId + "&processId=" + processId + app);
	}
}





