try {
    getA8Top().endProc();
}
catch(e) {
}

var detailURL = "bbs.do";

/*单位管理员－讨论设置*/

/**
 * 新建
 */
function createBoard(){
	var spaceId = document.getElementById("_spaceId").value;
	var spaceType = document.getElementById("_spaceType").value;
	parent.detailFrame.location.href = detailURL + "?method=listBoardAdd&spaceType="+spaceType+"&spaceId="+spaceId;
}

/**
 * 修改
 */
function editBoard(){
	var id_checkbox = document.getElementsByName("id");
	var spaceId = document.getElementById("_spaceId").value;
	var spaceType = document.getElementById("_spaceType").value;
	if (!id_checkbox) {
   	 	return;
	}
	var len = id_checkbox.length;
	var checkedNum = 0;
	var id ;
	for (var i = 0; i < len; i++) {
   	 	if (id_checkbox[i].checked) {
        	checkedNum ++;
        	id = id_checkbox[i].value;
    	}
	}
	if (checkedNum == 0) {
	    alert(v3x.getMessage("BBSLang.bbs_bbsmanage_alert_update"));	
    	return false;
	}
	if(checkedNum > 1){
		alert(v3x.getMessage("BBSLang.bbs_bbsmanage_alert_chooseObe"));
		return false;
	}
	parent.detailFrame.location.href = detailURL + "?method=listBoardModify&id=" + id + "&spaceType="+spaceType+"&spaceId=" + spaceId;
}

/**
 * 打开连接地址
 */
function articleDetail(articleId){
	var acturl = "/seeyon/bbs.do?method=showPost&articleId="+articleId+"&resourceMethod=listLatestFiveArticleAndAllBoard&group=";
	openWin(acturl);
}

/**
 * 删除
 */
function deleteBoard(){
	var spaceId = document.getElementById("_spaceId").value;
	var spaceType = document.getElementById("_spaceType").value;
	var ids = document.getElementsByName('id');
	var id = '';
	for(var i = 0; i < ids.length; i ++){
		var idCheckBox = ids[i];
		if(idCheckBox.checked){
		/**
			if(delBsMap.get(idCheckBox.value) == 'true'){
				
          	}else{
          		if(confirm(v3x.getMessage("BBSLang.bbs_bbsmanage_delConfirmed"))){
					fm.action = detailURL + "?method=delBoard";
					fm.submit();
				}
          	}*/
			id = id + idCheckBox.value + ',';
		}
	}
	if(id == ''){
		alert(v3x.getMessage("BBSLang.bbs_bbsmanage_alert_delete"));
		return;
	}
	if(confirm(v3x.getMessage("BBSLang.bbs_board_hasArticle"))){
		fm.action = detailURL + "?method=delBoard&spaceType="+spaceType+"&spaceId="+spaceId;
		fm.submit();
	}
}

/**
 * 排序
 */
function bbsBoardOrder(){
	var spaceId = document.getElementById("_spaceId").value;
	var spaceType = document.getElementById("_spaceType").value;
	var returnValue=v3x.openWindow({
		url : detailURL + "?method=orderBbsBoard&spaceType="+spaceType+"&spaceId="+spaceId,
		width : "350",
		height : "317",
		resizable : "false"
	});
	if(returnValue != null && returnValue != undefined){
	var theForm = document.forms[0];
	for(var i=0; i<returnValue.length; i++){
	   var element = document.createElement("input");
	   element.setAttribute('type','hidden');
	   element.setAttribute('name','projects');
	   element.setAttribute('value',returnValue[i]);
	   theForm.appendChild(element);
	}
	theForm.action = detailURL + "?method=saveOrder&spaceType="+spaceType+"&spaceId="+spaceId;
	theForm.target = "_self";
	theForm.method = "post";
    theForm.submit();
	}
}

/**
 * 单击查看
 */
function modifyBoard(id){
	parent.detailFrame.location.href=detailURL + "?method=listBoardModify&id=" + id +"&isDetail=readOnly";
}

/**
 * 双击修改
 */
function dbModifyBoard(id){
	parent.detailFrame.location.href=detailURL + "?method=listBoardModify&id=" + id;
}

/**
 * 验证标题名称是否重复
 */
function validateBoardName(isGroup, boardId){
	var boardName = document.fm.name.value.trim();
	try {
		var requestCaller;
		if(isGroup){
			requestCaller = new XMLHttpRequestCaller(this, "ajaxValidateBoardNameManager", "validateGroupBoardName", false);
		}else{
			requestCaller = new XMLHttpRequestCaller(this, "ajaxValidateBoardNameManager", "validateBoardName", false);
		}
		requestCaller.addParameter(1, "String", boardName);
		requestCaller.addParameter(2, "Long", boardId);
		var ds = requestCaller.serviceRequest();
		return ds;
	}
	catch (ex1) {
		alert("Exception : " + ex1);
	}
}

/**
 * 排序－上移
 */
function up(selObj)
{
  var i;
  var optValue,optTxt;
  for(i=0;i<selObj.options.length;i++)
  {
    if(selObj.options[i].selected==true)
	{
	  if(i==0){return;}
	  optValue=selObj.options[i-1].value;
	  optTxt=selObj.options[i-1].text;
	  selObj.options[i-1].value=selObj.options[i].value;
	  selObj.options[i-1].text=selObj.options[i].text;
	  selObj.options[i].value=optValue;
	  selObj.options[i].text=optTxt;
	  selObj.options[i].selected=false;
	  selObj.options[i-1].selected=true;
	}
  }
}

/**
 * 排序－下移
 */
function down(selObj)
{
  var i;
  var optValue,optTxt;  
  for(i=selObj.options.length-1;i>=0;i--)
  {
    if(selObj.options[i].selected==true)
	{
	  if(i==(selObj.options.length-1)){return;}
	  optValue=selObj.options[i+1].value;
	  optTxt=selObj.options[i+1].text;
	  selObj.options[i+1].value=selObj.options[i].value;
	  selObj.options[i+1].text=selObj.options[i].text;
	  selObj.options[i].value=optValue;
	  selObj.options[i].text=optTxt;
	  selObj.options[i].selected=false;
	  selObj.options[i+1].selected=true;
	}
  }
}

/**
 * 保存排序结果
 */
function saveOrder(){
	 var oSelect = document.getElementById("projectsObj");
	 if(!oSelect) return false;
	 var ids = [];
	 for(var selIndex=0; selIndex<oSelect.options.length; selIndex++)
     {
        ids[selIndex] = oSelect.options[selIndex].value;
     }
	 transParams.parentWin.bbsBoardOrdersCollBack(ids);
}

/*板块管理员－讨论管理*/

/**
 * 设置讨论 1设置置顶 2取消置顶 3设置精华 4 取消精华
 */
function setArticle(type, boardId, dept, group){		
	var id_checkbox = document.getElementsByName("id");
	if (!id_checkbox) {
   	 	return;
	}
	var topNum_Sequence = document.getElementsByName("topSequence");
	var len = id_checkbox.length;
	var checkedNum = 0;
	for (var i = 0; i < len; i++) {
   	 	if (id_checkbox[i].checked) {
     	 	 if(type=='1'&&topNum_Sequence[i].value>0){
     	 	       var editValue= document.getElementById("topName_"+id_checkbox[i].value);
     	 	       alert(v3x.getMessage("BBSLang.bbs_bbsmanage_alert_topSequence",editValue.value));
     	 	       return ;
     	 	 }
         checkedNum ++; 
    	}
	}
	if (checkedNum == 0) {
		var message;
		if(type == '1'){
	    	message = "BBSLang.bbs_boardmanager_boardM_putter";
		}else if(type == '2'){
			message = "BBSLang.bbs_boardmanager_boardM_cancleTopic";
		}else if(type == '3'){
			message = "BBSLang.bbs_boardmanager_boardM_setElite";
		}else if(type == '4'){
			message = "BBSLang.bbs_boardmanager_boardM_cancelElite";
		}
		alert (v3x.getMessage(message));
    	return false;
	}
	if(type == '1'){
		var topNum_Hidden = document.getElementsByName("topSequence");
		var len2 = topNum_Hidden.length;
		var toppedNum = 0;
		for (var j = 0; j < len2; j++) {
	   	 	if (topNum_Hidden[j].value>0) {
	        	toppedNum ++;
	    	}
		}
		var sumTopNum = document.fm2.topNum.value;
		if(checkedNum + toppedNum > sumTopNum){
			alert(v3x.getMessage("BBSLang.bbs_boardmanager_boardM_noexcess") + sumTopNum);
			return false;
		}
	}
	var method;
	if(type == '1'){
    	method = "topArticle";
	}else if(type == '2'){
		method = "cancelTopArticle";
	}else if(type == '3'){
		method = "eliteArticle";
	}else if(type == '4'){
		method = "cancelEliteArticle";
	}
	var spaceId = document.getElementById("spaceId").value;
	var spaceType = document.getElementById("spaceType").value;
	if(document.getElementById("_custom").value) {
		document.listForm.action=detailURL + "?method=" + method + "&boardId=" + boardId + "&dept=" + dept + "&group=" + group + "&custom=true" + "&spaceType=" + spaceType + "&spaceId=" + spaceId;
	} else {
		document.listForm.action=detailURL + "?method=" + method + "&boardId=" + boardId + "&dept=" + dept + "&group=" + group + "&spaceType=" + spaceType + "&spaceId=" + spaceId;
	}
	document.listForm.submit();
}

/**
 * 删除
 */
function delArticle(boardId, dept, group){
	var id_checkbox = document.getElementsByName("id");
 		if (!id_checkbox) {
       	 	return;
    	}
    	var len = id_checkbox.length;
    	var checkedNum = 0;
    	for (var i = 0; i < len; i++) {
       	 	if (id_checkbox[i].checked) {
            	checkedNum ++;
        	}
    	}
    	if (checkedNum == 0) {
   		  alert(v3x.getMessage("BBSLang.bbs_boardmanager_boardM_delMotif"));
		  return false;
		}
	if(window.confirm(v3x.getMessage("BBSLang.bbs_boardmanager_boardM_delFullnote"))){
		var spaceId = document.getElementById("spaceId").value;
		var spaceType = document.getElementById("spaceType").value;
		document.listForm.action=detailURL + "?method=delArticle&boardId=" + boardId + "&dept=" + dept + "&group=" + group + "&spaceType=" + spaceType + "&spaceId=" + spaceId;
		getA8Top().startProc();
		document.listForm.submit();
	}
}

/**
 * 统计
 */
function countBoard(boardId, group, dept){
	if(document.getElementById("_custom").value) {
		viewStatistics(detailURL + "?method=countArticle&countType=0&boardId=" + boardId + "&group=" + group + "&dept=" + dept + "&custom=true");
	} else {
		var spaceId = document.getElementById("spaceId").value;
		var spaceType = document.getElementById("spaceType").value;
		viewStatistics(detailURL + "?method=countArticle&countType=0&boardId=" + boardId + "&group=" + group + "&dept=" + dept + "&spaceType=" + spaceType + "&spaceId=" + spaceId);
	}
	
}

/**
 * 切换板块
 */
function changeType(boardId, group, dept){
	var spaceId = document.getElementById("spaceId").value;
	var spaceType = document.getElementById("spaceType").value;
	document.location.href = detailURL + "?method=listArticleMain&boardId=" + boardId + "&group=" + group + "&dept=" + dept + "&spaceType=" + spaceType + "&spaceId=" + spaceId;
}

/**
 * 切换部门
 */
function changeDepartment(deId){
	document.location.href = detailURL + "?method=listArticleMain&dept=dept&boardId=" + deId;
}

/**
 * 单位空间中公共信息管理－讨论区管理
 */
function manageBoardArticle(boardId, dept, group, where){		
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxBbsBoardManager", "isBoardExist", false);
	requestCaller.addParameter(1, "Long", boardId);
	var ds = requestCaller.serviceRequest();
	if(ds=='false'){
		alert(v3x.getMessage("BBSLang.bbs_board_has_del"));
		window.location.reload(true);
		return;
	}
	var spaceType = document.getElementById("spaceTypes").value;
	var spaceId = document.getElementById("spaceIds").value;
	location.href = detailURL + "?method=listArticleMain&boardId="+boardId+"&dept="+dept+"&group="+group+"&spaceType="+spaceType+"&spaceId="+spaceId+"&where="+where;
}

/**
 * 回显搜索条件
 */
function showcondtionRep(conditionValue, numConditionValue ,textfieldValue){
	if(!conditionValue){
		return ;
	}
	var conditionObj = document.getElementById("condition")
	selectUtil(conditionObj, conditionValue); //选择条件
    showNextCondition(conditionObj); //显示条件值区域
    
    if(numConditionValue){
	     var numconditionObj = document.getElementById("numContaction")
		 selectUtil(numconditionObj, numConditionValue); //选择条件
	     showNextCondition(numconditionObj); //显示条件值区域
    }
    
    var theDiv = document.getElementById(conditionValue + "Div");

    if (theDiv) {
        var nodes = theDiv.childNodes;

        if (nodes) {
            for (var j = 0; j < nodes.length; j++) {
                var node = nodes.item(j);
                if (node.tagName == "INPUT") {
                    eval("node.value = " + node.name + "Value;")
                }
                else if (node.tagName == "SELECT") {
                    eval("selectUtil(node, " + node.name + "Value)")
                }
            }
        }
    }
}
/**
 * 搜索
 */
function doMySearch(){
		var condition = document.getElementsByName("searchForm")[0].condition;
		/*
		 * 只有当以发布时间为条件进行查询时，才需要进行开始日期是否晚于结束日期的判断
		 * 否则由于其值仍会保留，当切换到其他条件进行查询时，此判断仍会进行并可能导致无法正常查询
		 * 抽取到bbs.js中便于单点维护  modified by Meng Yang at 2009-06-03
		*/
		if(condition.value == 'issueTime') {			
			var startDate = document.getElementById('startdate').value;
			var endDate = document.getElementById('enddate').value;
			if(startDate!=""&&endDate!=""){
				if(compareDate(startDate,endDate)>0){
					alert(v3x.getMessage("BBSLang.bbs_startDate_late_than_endDate"));
					return;
				}
			}
		}
		doSearch();
}
function doBbsSearch(){
  var condition = document.getElementsByName("searchForm")[0].condition;
  /*
   * 只有当以发布时间为条件进行查询时，才需要进行开始日期是否晚于结束日期的判断
   * 否则由于其值仍会保留，当切换到其他条件进行查询时，此判断仍会进行并可能导致无法正常查询
   * 抽取到bbs.js中便于单点维护  modified by Meng Yang at 2009-06-03
  */
  if(condition.value == 'issueTime') {      
    var startDate = document.getElementById('textfield').value;
    var endDate = document.getElementById('textfield1').value;
    if(startDate!=""&&endDate!=""){
      if(compareDate(startDate,endDate)>0){
        alert(v3x.getMessage("BBSLang.bbs_startDate_late_than_endDate"));
        return;
      }
    }
  }
  doSearch();
}
/**
 * 部门讨论区下拉列表切换
 */
function changeDeptBBS() {
	var deptId = "";
	var selectObj = document.all.departmentIdSelect;
	if(selectObj){
		deptId = selectObj.value;
	}
	location.href = detailURL + "?method=deptlistAllArticle&departmentId="+deptId;
}

/**
 * 删除讨论
 */
function deleteArticle(articleId,resourceMethod,boardId,group){
	var boardId = document.getElementById("boardId").value;
	if(confirm(v3x.getMessage("BBSLang.bbs_delete_article_notice"))){
		document.postForm.action=detailURL + "?method=deleteArticle&articleId="+articleId+"&resourceMethod="+resourceMethod+"&boardId="+boardId+"&group="+group;
		document.postForm.submit();
	}
}

/**
 * 删除回复
 */
function deleteReplyPost(postId,articleId,group,size,fromPigeonhole){
	var boardId = document.getElementById("boardId").value;
	if (confirm(v3x.getMessage("BBSLang.bbs_delete_reply_notice"))){
		var pageSize = getPageSize();
		var nowPageStr = document.getElementById("nowPage").value.trim();
		if(!isInt(nowPageStr)) {
			nowPageStr = '1';
		}
		var nowPage = parseInt(nowPageStr);
		var totalRecords = parseInt(size);
		if(totalRecords>0)
			totalRecords--;
		var newTotalPages = getTotalPages(totalRecords, pageSize);
		if(nowPage>newTotalPages) {
			nowPage = newTotalPages;
		}
		if(nowPage<=0) {
			nowPage = 1;
		}
		document.postForm.action=detailURL + "?method=deleteReplyPost&postId="+postId+"&articleId="+articleId+"&resourceMethod=listBoardArticle&boardId="+boardId+"&group="+group+"&pageSizePara="+pageSize+"&nowPagePara="+nowPage+"&fromPigeonhole="+fromPigeonhole;
		document.postForm.submit();
	}
}
	
//引用或直接回复<对主题进行引用或回复>
function replyFromReferenceOrDirectly(replyFlag, fromPigeonhole, isCollCube, fromIsearch) {
	var articleId = document.getElementById("articleId").value;
	document.getElementById("replyArticle").contentWindow.location.href = detailURL + "?method=replyArticle&useReplyFlag=" + replyFlag + "&articleId=" + articleId+ "&fromPigeonhole="+fromPigeonhole + "&fromIsearch=" + fromIsearch + "&isCollCube=" + isCollCube;
}
//引用或直接回复<对回复进行引用或回复>
function replyReplyFromReferenceOrDirectly(id, replyFlag, fromPigeonhole, isCollCube, fromIsearch) {
	var articleId = document.getElementById("articleId").value;
	document.getElementById("replyArticle").contentWindow.location.href = detailURL + "?method=replyArticle&postId=" + id + "&useReplyFlag=" + replyFlag + "&articleId=" + articleId+ "&fromPigeonhole="+fromPigeonhole + "&fromIsearch=" + fromIsearch + "&isCollCube=" + isCollCube;
}
//编辑主题
function editArticle(url, size, from) {
	
	var pageSize = getPageSize();
	var nowPageStr = document.getElementById("nowPage").value.trim();
	if(!isInt(nowPageStr)) {
		nowPageStr = '1';
	}
	var nowPage = parseInt(nowPageStr);
	var newTotalPages = getTotalPages(size, pageSize);
	if(nowPage>newTotalPages) {
		nowPage = newTotalPages;
	}
	if(nowPage<=0) {
		nowPage = 1;
	}
	if(from == 1){
		parent.window.location.href = url + "&pageSizePara="+pageSize+"&nowPagePara="+nowPage+"&isCollCube=1";
	}else{
		getA8Top().location.href = url + "&pageSizePara="+pageSize+"&nowPagePara="+nowPage;
	}
}
//编辑回复
function editReply(postId,articleId,size,fromPigeonhole) {
	var pageSize = getPageSize();
	var nowPageStr = document.getElementById("nowPage").value.trim();
	if(!isInt(nowPageStr)) {
		nowPageStr = '1';
	}
	var nowPage = parseInt(nowPageStr);
	var newTotalPages = getTotalPages(size, pageSize);
	if(nowPage > newTotalPages) {
		nowPage = newTotalPages;
	}
	if(nowPage <= 0) {
		nowPage = 1;
	}
	document.getElementById("replyArticle").contentWindow.location.href = detailURL + "?method=toEditReply&replyOrEdit=edit&postId=" + postId + "&articleId=" + articleId + "&pageSizePara=" + pageSize + "&nowPagePara=" + nowPage+ "&fromPigeonhole="+fromPigeonhole ;
}
//添加回复
function replyPost(){
	saveAttachment();
	var newPageSizeStr = parent.document.getElementById("pageSize").value.trim();
	var newPageSize = 10;
	if(isInt(newPageSizeStr)) {
		newPageSize = parseInt(newPageSizeStr);
		if(newPageSize <= 0) {
			newPageSize = 10;
		}
	} 
	document.replyForm.action = detailURL + "?method=createReplyArticle&pageSizePara=" + newPageSize;
	document.getElementById("reply").disabled = true;
	document.replyForm.submit();
}
//添加回复
function replyPost(fromPigeonhole){
  saveAttachment();
  var newPageSizeStr = parent.document.getElementById("pageSize").value.trim();
  var newPageSize = 10;
  if(isInt(newPageSizeStr)) {
    newPageSize = parseInt(newPageSizeStr);
    if(newPageSize <= 0) {
      newPageSize = 10;
    }
  } 
  document.replyForm.action = detailURL + "?method=createReplyArticle&pageSizePara=" + newPageSize  + "&fromPigeonhole="+fromPigeonhole ;
  document.getElementById("reply").disabled = true;
  document.replyForm.submit();
}
//修改回复
function modifyPost(pageSize, nowPage){
	saveAttachment();
	document.replyForm.action = detailURL + "?method=editReply&pageSizePara=" + pageSize + "&nowPagePara=" + nowPage;
	document.getElementById("reply").disabled = true;
	document.replyForm.submit();	
}
//修改回复
function modifyPost(pageSize, nowPage,fromPigeonhole){
  saveAttachment();
  document.replyForm.action = detailURL + "?method=editReply&pageSizePara=" + pageSize + "&nowPagePara=" + nowPage + "&fromPigeonhole="+fromPigeonhole ;
  document.getElementById("reply").disabled = true;
  document.replyForm.submit();  
}
//校验是否是整数，如果不是整数，则使用默认值：每页10条，第1页
function isInt(num) {
	var re=new RegExp("^-?[ \\d]*$");
	if(re.test(num))
		return !isNaN(parseInt(num));
	else
		return false;
}
//获取用户自定义的每页回复总条数
function getPageSize() {
	var newPageSizeStr = document.getElementById("pageSize").value.trim();
	var newPageSize = 10;
	if(isInt(newPageSizeStr)) {
		newPageSize = parseInt(newPageSizeStr);
		if(newPageSize<=0) {
			newPageSize = 10;
		}
	} 
	return newPageSize;
}
//根据回复总数和新的每页条数计算获取新的总页数
function getTotalPages(totalCount, newPageSize) {
	var totalRecords = parseInt(totalCount);
	var newTotalPages = 1; 
	if((totalRecords%newPageSize)==0 && totalRecords>0) {
		newTotalPages = totalRecords/newPageSize;
	} else {
		newTotalPages = parseInt(totalRecords/newPageSize + 1);
	}
	return newTotalPages;
}
/**
 * 如果回复内容为空，给出提示，并将提交按钮和插入附件按钮置为可用
 */
function validateReplyIsNotNull() {
	alert(v3x.getMessage("BBSLang.bbs_reply_can_not_be_null"));
	getA8Top().location.reload(true);
}
/**
 * 关闭并刷新父窗口(如果能够得到的话)
 */
function closeAndRefreshWhenDeleted() {
  var parObj = window.parent;
  if(parObj) {
    var fromObj = v3x.getParentWindow(parObj);
    if(fromObj) {
      try {
      	fromObj.getA8Top().reFlesh();
      } catch(e) {
      	fromObj.location.reload();
      }
      parObj.close();
    } else {
      parObj.getA8Top().reFlesh();
    }
  }
}

/**
 * 部门讨论－发起讨论
 */
function bbsPublish(boardId,spaceType){
	var url = detailURL + "?method=issuePost&showSpaceLacation=true&boardId=" + boardId +"&spaceType="+spaceType;
	if(document.getElementById("_custom").value) {
	    var spaceId = document.getElementById("_spaceId").value;
		url=detailURL + "?method=issuePost&showSpaceLacation=true&custom=true&boardId=" + boardId + "&spaceId=" + spaceId +"&spaceType="+spaceType; 
	}
	openCtpWindow({'url':url});
}

/**
 * 部门讨论－讨论管理
 */
function bbsManage(boardId){
	if(document.getElementById("_custom").value) {
	    var spaceId = document.getElementById("_spaceId").value;
		window.location.href=detailURL + "?method=listArticleMain&dept=dept&custom=true&boardId=" + boardId + "&spaceId=" + spaceId; 
	} else {
		window.location.href=detailURL + "?method=listArticleMain&dept=dept&boardId=" + boardId;
	}
}

/**
 * 讨论预览
 */
function viewPage(url){
	var v1 = document.getElementsByName('resourceFlag');
	for(i = 0; i < v1.length; i++){
		if(v1[i].checked){
			var count = v1[i].value;
			document.getElementById('rFlag').value = count;
			break;
		}
	}
	
	v3x.openWindow({
		url : url,
		workSpace : true,
		scrollbars: false,
		resizable : "false",
		dialogType : "open"
	});
}
