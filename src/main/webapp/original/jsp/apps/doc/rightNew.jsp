<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="docHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<%@ include file="../../common/INC/noCache.jsp"%>
<%@page import="java.util.List" %>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/thirdMenu.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" href="<c:url value="/skin/default/skin.css"/>">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/doc/css/doc.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/ui/seeyon.ui.tooltip-debug.js${v3x:resSuffix()}" />"></script>
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript">
	var currentUserId = "${v3x:currentUser().id}";
	var isNewView = "";
	var myFavority = false;
	var parentIsNewView = parent.document.getElementById("treeFrame").contentWindow.document.getElementById("isNewView");
	function showOrhiddenDoc() {
		var parentLayout = parent.document.getElementById("layout");
		if(parentLayout){
			if(parentLayout.cols == "0,*") {
				parentLayout.cols = "127,*";
				parent.document.getElementById("treeFrame").noResize=false;
				//getA8Top().contentFrame.document.getElementById('LeftRightFrameSet').cols = "0,*";
			}else {
				parentLayout.cols = "0,*";
				parent.document.getElementById("treeFrame").noResize=true;
			}
			try{
				getA8Top().contentFrame.leftFrame.closeLeft();
			}catch(e){
			}
		}
	}
	function toBack(){
		var exUrl = "&resId=" + docResId + "&frType=" + frType + "&docLibId=" + docLibId 
						+ "&docLibType=" + docLibType + "&isShareAndBorrowRoot=" + isShareAndBorrowRoot
						+ "&all=" + all + "&edit=" + edit + "&add=" + add + "&readonly=" + readonly 
						+ "&browse=" + browse + "&list=" + list;
	
		var url1 = jsURL + "?method=rightNew" + exUrl;
		try{
			//文档查询后，frameset，恢复到默认宽度且不可拖动(防止换行显示)，点击‘返回’按钮，恢复默认状态
			if(parent.layout){
				if(parent.layout.cols != "0,*") {
					parent.layout.cols="140,*";
					//parent.document.getElementById("treeFrame").noResize=false;	
				}
			}	
		}catch(e){}
		location.href = url1;
	}
	
	function readyToPersonalLearn(flag){
		if(hasSelectedData())
				//右键菜单
			if('pop' == flag){
					//只有全部权限 才能发送其他人
				if(allAcl1=='true'){
					selectPeopleFun_perLearnPop();
				}else{
					sendToLearn([{id:currentUserId,type:"Member"}],flag);
				}
			}else{
					//只有全部权限 才能发送其他人
				if(docListAclAll){
					selectPeopleFun_perLearn();
				}else{
					sendToLearn([{id:currentUserId,type:"Member"}],flag);
				}
			}
			return;
	}

	window.onload = function() {
		var qm = '${param.method}';
		if('${param.queryFlag}' == 'true' && qm != 'advancedQuery'){
			var conditionValue = '';
			var textfieldValue = '';
			var textfield1Value = '';
			if('rightNew' == qm ){
				textfieldValue = '${param.pingHoleSelect}';	
				conditionValue = 'pingHoleAlready';				
			}else {
				conditionValue = '${simpleQueryModel.propertyName}|${simpleQueryModel.propertyType}|${simpleQueryModel.simple}';
				textfieldValue = "${v3x:escapeJavascript(simpleQueryModel.value1)}";	
				textfield1Value = "${v3x:escapeJavascript(simpleQueryModel.value2)}";
			}
			docMenuShowCondition(conditionValue, textfieldValue, textfield1Value);
		}
		if(parentIsNewView!=null && parentIsNewView.value == ""){
			parentIsNewView.value = false;
			$("input[name='isNewView']").attr("value",false);
		}else{
			if(parentIsNewView!=null && parentIsNewView.value == "true"){
				$(".tableBtn").css("background","#8d929b");
				$(".tableBtn").children("em").removeClass("table_cur_icon16");
				$(".tableBtn").children("em").addClass("table_icon16");
				var list=$(".listBtn",".changeBtn");
				list.css("background","#fff");
				list.children("em").removeClass("list_icon16");
				list.children("em").addClass("list_cur_icon16");
				$("input[name='isNewView']").attr("value",true);
			}else{
				$("input[name='isNewView']").attr("value",false);
			}
		}
		
		$(".firstA:last").removeClass("firstA").addClass("firstB");
	}
	
	function docMenuShowCondition(condition, value, value1){
		var conditionObj = document.getElementById("condition");
		selectUtil(conditionObj, condition);
	    showNextCondition(conditionObj);
	    setFlag(condition);

	    if(condition == 'pingHoleAlready') {
	    	var pingHoleSelectObj = document.getElementById("pingHoleSelectValue");
			selectUtil(pingHoleSelectObj, value);
	    }else if(condition=='frType') {
	    	selectUtil(document.getElementById("frTypeValue"), value);
	    }else {
			try {
		    	document.getElementById("${simpleQueryModel.paramName1}").value = value;
				if("${simpleQueryModel.paramName2}" != ""){
					document.getElementById("${simpleQueryModel.paramName2}").value = value1;
				}
			} catch(e) {}
	    }
	}
	var isNeedSort = '${isNeedSort}';

	//截取公共的列表行选中事件
	function selectRow(currentTd){
		var e = v3x.getEvent();
		var tmp;
		if (ie5){
			tmp = e.srcElement;
		}else if (dom){
			tmp = e.target;
		}
		if(tmp.tagName == 'INPUT'){
			return;
		}

		//清零权限列表
		docListAclMap = new Properties();
		docListAclMap.put('parent', new docListAcl('${param.all}', '${param.edit}', '${param.add}',
			'${param.readonly}', '${param.browse}', '${param.list}', 'false', 'false', 'false', appData.doc, 'false'));
		var isV5Member = '${CurrentUser.externalType == 0}';
		if(isV5Member == "true"){
			ctrlDocMenuByAclMap();
		}
		
		var currentTr = getParent(currentTd, "TR");
		var currentTbody = getParent(currentTr, "tbody");
		if(currentTr != null && currentTbody != null){
			redoStyle();
			changeSelectedStyle(currentTr);
			currentSelectTr = currentTr;
			var thisCheckbox = getCheckboxFromTr(currentTr);
			if(thisCheckbox != undefined && thisCheckbox != null) {
				noSelected(thisCheckbox.name);
				if(thisCheckbox.disabled != true){
					thisCheckbox.click();
				}
			}
		}
	}
//-->
var currentUserId = ${CurrentUser.id};
function fnCloseAllDialog() {
	getA8Top().$('.mask').remove()
	getA8Top().$('.mxt-window').remove();
	getA8Top().$('.shield').remove();
	getA8Top().$('.dialog_box').remove();
}
</script>
<c:set value="${v3x:getSysFlagByName('sys_isGovVer') ? '.rep' : ''}" var="govLabel" />
<%@ include file="rightHead.jsp"%>
<style>
/***layout*row1+row2***/
.main_div_row2 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row2 {
 width: 100%;
 height: 100%;
 _padding:54px 0px 0px 0px;
}
.main_div_row2>.right_div_row2 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row2 {
 width: 100%;
 height: 100%;
 /*background-color:#00CCFF;*/
 overflow:auto;
}
.right_div_row2>.center_div_row2 {
 height:auto;
 position:absolute;
 top:82px;
 bottom:0px;
}
.top_div_row2 {
 height:82px;
 width:100%;
 /*background-color:#9933FF;*/
 position:absolute;
 top:0px;
}
/***layout*row1+row2****end**/
.sort img{
	vertical-align: middle;
}
.border_t {
  border-top: 1px solid #dfdfdf;
}
.webfx-menu-bar{ padding-left: 0; }
.mxt-window-footer {line-height: 40px;}
</style>
</head>
<body class="page_color" onbeforeunload="fnCloseAllDialog()">
<div class="main_div_row2">
	<c:set value="${v3x:currentUser()}" var="currentUser" />
  <div class="right_div_row2 iframeRight border-right" style="border-right-width:0px">
    <div class="top_div_row2" style="min-width:800px">
		<table height="40" border="0" width="100%" cellspacing="0" cellpadding="0" >
				
			<tr>
				<td id="rightMenuBar" height="40" class="webfx-menu-bar"  valign="top">	
				<div class="right" style="margin-top: 7px;">
					<ul class="changeBtn ">
						<li class=" tableBtn currentLi">
							<em class="modulIcon16 table_cur_icon16"></em>
						</li>
						<li class=" listBtn">
							<em class="modulIcon16 list_icon16"></em>
						</li>
					</ul>  	
				</div>	
					<script>
						//知识管理工具栏菜单
						//新建二级菜单
						
						var isV5Member = ${CurrentUser.externalType == 0};
					    var newSubItems = new WebFXMenu;
						newSubItems.add(new WebFXMenuItem("html", "<fmt:message key='doc.menu.new.document.label'/>", "createDoc(10);", "<c:url value='/apps_res/doc/images/docIcon/html_small.gif'/>", "", ""));
						if(v3x.isOfficeSupport()){//v3x.getBrowserFlag("officeMenu") == true && ${v3x:isOfficeOcxEnable()}
							var pw = getA8Top();
							if(v3x.isMSIE && ${v3x:isOfficeOcxEnable()}){
   								try{
         								var ocxObj=new ActiveXObject("HandWrite.HandWriteCtrl");
         								pw.installDoc= ocxObj.WebApplication(".doc");
         								pw.installXls=ocxObj.WebApplication(".xls");
         								pw.installWps=ocxObj.WebApplication(".wps");
         								pw.installEt=ocxObj.WebApplication(".et");
     								}catch(e){
     									pw.installDoc=false;
     									pw.installXls=false;
     									pw.installWps=false;
     									pw.installEt=false;
     								}
							}
							if(!v3x.isMSIE){
								pw.installDoc=true;
								pw.installXls=true;
								pw.installWps=true;
								pw.installEt=true;
							}
							
							if(pw.installDoc)newSubItems.add(new WebFXMenuItem("word", "<fmt:message key='doc.menu.new.word.label'/>", "createDoc(41);", "<c:url value='/apps_res/doc/images/docIcon/doc_small.gif'/>", "", ""));
							if(pw.installXls)newSubItems.add(new WebFXMenuItem("excel", "<fmt:message key='doc.menu.new.excel.label'/>", "createDoc(42);", "<c:url value='/apps_res/doc/images/docIcon/xls_small.gif'/>", "", ""));
							if(pw.installWps)newSubItems.add(new WebFXMenuItem("wpsword", "<fmt:message key='common.body.type.wpsword.label' bundle='${v3xCommonI18N}'/>", "createDoc(43)", "<c:url value='/common/images/toolbar/bodyType_wpsword.gif'/>"));
							if(pw.installEt)newSubItems.add(new WebFXMenuItem("wpsexcel", "<fmt:message key='common.body.type.wpsexcel.label' bundle='${v3xCommonI18N}'/>", "createDoc(44)", "<c:url value='/common/images/toolbar/bodyType_wpsexcel.gif'/>"));
						}
						newSubItems.add(new WebFXMenuItem("folder", "<fmt:message key='doc.menu.new.folder.label'/>", "createFolder('${parent.versionEnabled}', '${parent.commentEnabled}', '${parent.recommendEnable}');", "<c:url value='/apps_res/doc/images/docIcon/folder_close.gif'/>"));	
						if(isEdocLib == 'true' && isV5Member) {
							newSubItems.add(new WebFXMenuItem("edocFolder", "<fmt:message key='doc.menu.new.folder.edoc'/>", "createEdocFolder('${parent.commentEnabled}',null,'<fmt:message key='doc.jsp.createEdoc.title' />');", "<c:url value='/apps_res/doc/images/docIcon/edoc_close.gif'/>"));
						}
						
						// 发送到二级菜单
						var sendToSubItems = new WebFXMenu;
						// 高级二级菜单
						var forwardSubItems = new WebFXMenu;
						if(isV5Member){
							sendToSubItems.add(new WebFXMenuItem("favorite", "<fmt:message key='doc.menu.sendto.favorite.label'/>", "addMyFavorite('undefined');", ""));
							sendToSubItems.add(new WebFXMenuItem("deptDoc", "<fmt:message key='doc.menu.sendto.deptDoc.label'/>", "sendToDeptDoc('${depAdminSize}', 'right')", ""));
							sendToSubItems.add(new WebFXMenuItem("publish", "<fmt:message key='doc.menu.sendto.space.label'/>", "publishDoc('undefined');", ""));	
							sendToSubItems.add(new WebFXMenuItem("group", "<fmt:message key='doc.menu.sendto.group${govLabel}'/>", "sendToGroup('undefined');", ""));	
						
							sendToSubItems.add(new WebFXMenuItem("learning", "<fmt:message key='doc.menu.sendto.learning.label'/>", "readyToPersonalLearn('top')", ""));	
							sendToSubItems.add(new WebFXMenuItem("deptLearn", "<fmt:message key='doc.menu.sendto.deptLearn.label'/>", "sendToDeptLearn('${depAdminSize}', 'right')", ""));
							sendToSubItems.add(new WebFXMenuItem("accountLearn", "<fmt:message key='doc.menu.sendto.accountLearn.label'/>", "sendToAccountLearn('right')", ""));	
							sendToSubItems.add(new WebFXMenuItem("groupLearn", "<fmt:message key='doc.menu.sendto.group.learning'/>", "sendToGroupLearn('right')", ""));	
						
							sendToSubItems.add(new WebFXMenuItem("link", "<fmt:message key='doc.menu.sendto.other.label'/>", "selectDestFolder('undefined','${param.resId}','${param.docLibId}','${param.docLibType}','link');", ""));
							if(isEdocLib != 'true') {
								forwardSubItems.add(new WebFXMenuItem("col", "<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' />", "sendToCollFromMenu()", ""));
								//A6s去掉转发邮件
								var onlyA6s="${onlyA6s}";
								if(onlyA6s!="true"){
									forwardSubItems.add(new WebFXMenuItem("mail", "<fmt:message key='common.toolbar.transmit.mail.label' bundle='${v3xCommonI18N}' />", "sendToMailFromMenu()", ""));
								}
							}
			
							if(all== 'true'){
						        if('${param.frType}'!=101&&'${param.frType}'!=102&&'${param.frType}'!=34&&'${param.frType}'!=35&&'${param.frType}'!=110&&'${param.frType}'!=111&&'${param.frType}'!=103&&'${param.frType}'!=32&&'${param.frType}'!=43&&'${param.frType}'!=44&&'${param.frType}'!=45&&'${param.frType}'!=46)
						        	forwardSubItems.add(new WebFXMenuItem("orderBtn","<fmt:message key='doc.contenttype.wenjian'/><fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}' />","docResourcesOrder('${parent.id}','${parent.frType}','${isNeedSort}')","","",null));
							}
							if(isEdocLib != 'true'  && getA8Top().xmlDoc != null ){
								forwardSubItems.add(new WebFXMenuItem("downloadFile", "<fmt:message key='doc.menu.downloadFile.label'/>", "doloadFile('${v3x:currentUser().id}')", ""));
							}
							
							if('${isAllowArchivePigeonhole}' == 'true'){
								forwardSubItems.add(new WebFXMenuItem("pigArchive", "<fmt:message key='doc.archive.sync.js'/>", "pigeonholeArchive()", ""));
							}
							//添加文档日志按钮(管理员可以有该权限查看,即所有权限.我的文档不能查看)
							if(all== 'true' && docLibType != 1){
								forwardSubItems.add(new WebFXMenuItem("docAllLogs", "<fmt:message key='doc.jsp.log.title'/>", "logView('"+docResId+"',false,'',true)", ""));
							}
						}
						
						var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
						myBar.add(new WebFXMenuButton("new", "<fmt:message key='doc.menu.new.label'/>", "", [1,1],"<fmt:message key='doc.menu.new.label'/>", newSubItems));
						if(v3x.getBrowserFlag("hideMenu") == true){
							myBar.add(new WebFXMenuButton("upload", "<fmt:message key='doc.menu.upload.label'/>", "fileUpload('upload');", [1,6],"<fmt:message key='doc.menu.upload.label'/>", null));
						}
						if(isV5Member){
							myBar.add(new WebFXMenuButton("sendto", "<fmt:message key='doc.menu.sendto.label'/>", "",[9,1],"<fmt:message key='doc.menu.sendto.label'/>", sendToSubItems));
							myBar.add(new WebFXMenuButton("move", "<fmt:message key='doc.menu.move.label'/>", "selectDestFolder('undefined','${param.resId}','${param.docLibId}','${param.docLibType}','move');",[2,1],"<fmt:message key='doc.menu.move.label'/>", null));
						}
						myBar.add(new WebFXMenuButton("del", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "delF('topOperate','topOperate')",[1,3],"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", null));
						if(isV5Member){
							myBar.add(new WebFXMenuButton("forward", "<fmt:message key='common.advance.label' bundle='${v3xCommonI18N}'/>", "",[17,1],"<fmt:message key='common.advance.label' bundle='${v3xCommonI18N}'/>", forwardSubItems));
						}
		
						var shareAndBorrow = '${param.isShareAndBorrowRoot}';
						
					 	<v3x:showThirdMenus rootBarName="myBar" parentBarName="forwardSubItems" addinMenus="${AddinMenus}"/>
							
						//myBar.add(new WebFXMenuButton("show", "<fmt:message key='doc.menu.hidden.label'/>", "showOrhiddenDoc()",[3,3],"<fmt:message key='doc.menu.hidden.label'/>", null));		
						
						document.write(myBar);
						
						// 控制菜单操作权限
						initFun(all, edit, add, readonly, browse, list, isPrivateLib, folderEnabled, a6Enabled, officeEnabled, uploadEnabled, isGroupLib, isEdocLib, isShareAndBorrowRoot,"${onlyA6}","${onlyA6s}");
						
						if('${param.queryFlag}' == 'true'){							
							docDisable('new');
							docDisable('upload');
						}
						
					</script>
					
					<%
						List addinMenus = (List)request.getAttribute("AddinMenus");
					%>
							
				</td>
			</tr>
			<tr>
				<td colspan="2" class="main-bg" valign="top">
					<c:if test ='${param.frType!=101&&param.frType!=102&&param.frType!=110&&param.frType!=111&&param.frType!=103&&param.frType!=32&&param.frType!=43&&param.frType!=44&&param.frType!=45&&param.frType!=46}'>
						<%@ include file="simplesearch.jsp"%>
					</c:if>
					<div class="body_location" style="border-left:none;border-right:none;border-top:none;border-bottom: none;padding-left: 10px; background-color: white; height: 40px; line-height: 40px; padding:0 10px 0 10px;">
						<span class="location_text">
							<span id="nowLocation"></span>        
						</span>
						<script type="text/javascript">
							var queryfix = "";
							var locDocZone="";
							var sLocation= locDocZone + "<a class='firstA'><fmt:message key='doc.tree.struct.lable' /></a> &gt; ";//"";
							if('${param.queryFlag}' == 'true'){
							    queryfix = " &gt; " + "<fmt:message key='doc.loc.search.result' />";
							}
							showLocationText(sLocation + "${docLoc}" + queryfix);
						</script>
					</div>
					<div class="border_t"></div>
				</td>
			</tr>
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv" style="overflow: hidden;">
		<%@ include file="advancedsearch.jsp"%>
		<form action="" name="theForm" id="theForm" method="post" style='display: none'></form>
		
<div id="ScrollDIV" class="border_l">
<c:choose>
    <c:when test="${isNewView==1}">
        <%@ include file="newView.jsp"%>
    </c:when>
    <c:otherwise>
        <%@ include file="rightTable.jsp"%>
    </c:otherwise>
</c:choose>
</div>
		<iframe name="delIframe" style="display:none;" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
		<form action="" method="post" name="thirdMenuForm" id="thirdMenuForm">
			<input type="hidden" name="thirdMenuIds" id="thirdMenuIds">
		</form>
		<iframe name="orderIframe" style="display:none;" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
		<div id="pubDate"></div>
		<IFRAME height="0%" name="empty" style="display:none;" id="empty" width="0%" frameborder="0"></IFRAME>
		<iframe id="emptyIframe" style="display:none;" name="emptyIframe" frameborder="0"
			height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
		<iframe height="100%" name="dataIFrame" scroll="no" id="dataIFrame" width="100%" frameborder="0" style="display:none;"></iframe>
    </div>
  </div>
</div>
<script type="text/javascript">
	//document.getElementById("bDivdocgrid").style.height = document.body.clientHeight - 400;
	//document.getElementById("bDivdocgrid").style.width = document.body.clientWidth - 400;
	//bindOnresize('bDivdocgrid',0,80);
</script>
</body>
</html>
<script type="text/javascript">
    try{
        var searchForm = document.getElementById("searchForm");
        document.getElementById("ScrollDIV").style.height = document.body.clientHeight - 55;
    }catch(e){
    }
    
    var resourceCode = 'F04_docIndex';
    if("${isA6}" == "true"){
    	if('${param.docLibType}'=='1'){//个人文档
    		resourceCode = 'F04_myDocLibIndex';
    	}else if('${param.docLibType}'=='2'){//单位文档
    		resourceCode = 'F04_accDocLibIndex';
    	}else if('${param.docLibType}'=='3'){//公文档案
    		resourceCode = 'F04_eDocLibIndex';
    	}else if('${param.docLibType}'=='4'){//项目文档
    		resourceCode = 'F04_proDocLibIndex';
    	}
    }
    
    showCtpLocation(resourceCode);
    //resetCtpLocation();
    
    $(".tableBtn").click(function(){
		$("[name='id']").removeAttr("checked");
		$("[name='newCheckBox']").removeAttr("checked");
		$(".mainDoc.iconList .docList_li").removeClass("current");
		isNewView = true;
		if(parentIsNewView!=null){
			parentIsNewView.value = true;
		}
		$("input[name='isNewView']").attr("value",true);
		$("#adv_isNewView").attr("value",true);
		
		var surl = speUrl(1);
		window.location.href = surl;
	});
	$(".listBtn",".changeBtn").click(function(){
		$("[name='id']").removeAttr("checked");
		$("[name='newCheckBox']").removeAttr("checked");
		$(".mainDoc.iconList .docList_li").removeClass("current");
		isNewView = false;
		if(parentIsNewView!=null){
			parentIsNewView.value = false;
		}
		$("input[name='isNewView']").attr("value",false);
		$("#adv_isNewView").attr("value",false);
		var surl = speUrl(0);
		window.location.href = surl;
	});
	
	
	function speUrl(isNew){
		var isFromSea = "${isFromSea}";
		var surl = "";
		if(isFromSea==1){
			surl = parent.frames["treeFrame"].document.getElementById("seaUrl").value+"&isNew="+isNew;
		}else{
			var parUrl = "resId=${resId}&frType=${frType}&projectTypeId=${projectTypeId}&docLibId=${docLibId}&docLibType=${docLibType}";
			var	aclUrl = "&isShareAndBorrowRoot=${isShareAndBorrowRoot}&all=${all}&edit=${edit}&add=${add}&readonly=${readonly}&browse=${browse}&list=${list}";
			surl = jsURL + "?method=rightNew&"+parUrl+aclUrl+"&v=${v}&isNew="+isNew;
		}
		
		return surl;
	}
</script>