<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" var="v3xOrganizationI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.peoplerelate.resources.i18n.RelateResources" var="relateResourcesI18N"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/css/css.css${v3x:resSuffix()}" />" />
${v3x:skin()}
<style type="text/css">
	ul.ztree {margin-top:10px; border:1px solid #617775; background:#fff; width:241px; height:161px; overflow-y:auto; overflow-x:auto;}
	.tab-tag{padding-bottom:2px;}
</style>
<script type="text/javascript">
<!--
var basePath = "${pageContext.request.contextPath}";

var topWindow = null;

function findParentWindow(thisObj, iterative){
	//为了适应精灵消息中选人界面(适合本页面引入orgDataCenter.js,并有选人界面相关常量的情况下)
	if(thisObj && thisObj.orgDataCenterFlag){
		topWindow = thisObj;
		return;
	}
	
	if(thisObj && thisObj.getA8Top().orgDataCenterFlag){
		topWindow = thisObj.getA8Top();
		return;
	}
	var parentObj = null;
	var parentObj = thisObj.getA8Top().dialogArguments;	
	if(!parentObj){
		parentObj = thisObj.getA8Top().opener;
	}
	
	if(parentObj && parentObj.getA8Top().orgDataCenterFlag){
		topWindow = parentObj.getA8Top();
	}
	else{
		if(iterative > 0){
			findParentWindow(parentObj, iterative - 1);
		}
	}
	
	return null;
}
function findParentWindowIpad(){
	topWindow =window.parent;
}

var parentWindow = null;


if(v3x.getBrowserFlag('selectPeople') == true){
	findParentWindow(window,5);
	parentWindow = window.dialogArguments;
	if(parentWindow == null){
		parentWindow = window.opener;
	}
}else{
	//协同公文处理加签等合并
	if(window.parent.top == window.parent.self){
		findParentWindowIpad();
		parentWindow = window.parent;
	}else{
		findParentWindow(window,5);
		parentWindow = window.dialogArguments;
		if(parentWindow == null){
			parentWindow = window.opener;
		}
	}
}

if(parentWindow && parentWindow.mainFrame) {//通过win popup打开的
    var temObj = parentWindow.mainFrame;
    
    var flag = null;
	eval("flag = temObj.selectPeopleFun_" + spId);
	
    if(flag){
    	parentWindow = temObj;
    }
}

<c:if test="${param.include == 'true'}">
	parentWindow = parent;
</c:if>

var Constants_Account      = topWindow.Constants_Account;
var Constants_Department   = topWindow.Constants_Department;
var Constants_Team         = topWindow.Constants_Team;
var Constants_Post         = topWindow.Constants_Post;
var Constants_Level        = topWindow.Constants_Level;
var Constants_Member       = topWindow.Constants_Member;
var Constants_Role         = topWindow.Constants_Role;
var Constants_Outworker    = topWindow.Constants_Outworker;
var Constants_ExchangeAccount    = topWindow.Constants_ExchangeAccount;
var Constants_concurentMembers   = topWindow.Constants_concurentMembers;
var Constants_OrgTeam    = topWindow.Constants_OrgTeam;
var Constants_RelatePeople    = topWindow.Constants_RelatePeople;
var Constants_FormField    = topWindow.Constants_FormField;
var Constants_Admin        = topWindow.Constants_Admin;
var Constants_Component = topWindow.Constants_Component;

var PeopleRelate_TypeName = {
	1 : "<fmt:message key='relate.type.leader' bundle='${relateResourcesI18N}' />",
	2 : "<fmt:message key='relate.type.assistant' bundle='${relateResourcesI18N}' />",
	3 : "<fmt:message key='relate.type.junior' bundle='${relateResourcesI18N}' />",
	4 : "<fmt:message key='relate.type.confrere' bundle='${relateResourcesI18N}' />"
}

var isAdministrator = ${v3x:currentUser().administrator}; //单位管理员
var groupAdmin = ${v3x:currentUser().groupAdmin} || ${v3x:currentUser().auditAdmin}; //集团管理员 审计管理员
var systemAdmin = ${v3x:currentUser().systemAdmin}; //系统管理员

var isInternal = ${v3x:currentUser().internal}; //是否是内部人员

var myAccountId = "${v3x:currentUser().accountId}";
var loginAccountId = "${v3x:currentUser().loginAccount}";

var isGroupEdition = '${v3x:getSysFlagByName("sys_isGroupVer")}';
var isGroupAccessable = ${isGroupAccessable};
var accessableRootAccountId = "${accessableRootAccountId}";
//-->
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/SelectPeople/js/Panel.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/tree/xtree.css${v3x:resSuffix()}" />" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/SelectPeople/tree/xtree.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/zTree/js/jquery.ztree.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/zTree/css/zTreeStyle/zTreeStyle.css${v3x:resSuffix()}" />">
<script>
<!--
currentMemberId  = "${v3x:currentUser().id}";

ShowMe       = <c:out value="${param.ShowMe}" default="true" />;
SelectType   = '${ctp:escapeJavascript(param.SelectType)}';
Panels       = '${ctp:escapeJavascript(param.Panels)}';

<c:set value="${v3x:getSysFlagByName('selectPeople_showAccounts')}" var="showAccounts" />

<c:set value="${v3x:currentUser().loginAccount}" var="defaultLoginAccount" />
<c:if test="${v3x:currentUser().systemAdmin || v3x:currentUser().groupAdmin || v3x:currentUser().auditAdmin}">
	<c:set value="${firstAccountId}" var="defaultLoginAccount" />
</c:if>
<c:if test="${not empty param.accountId}">
	<c:set value="${param.accountId}" var="defaultLoginAccount" />
</c:if>
accountId = "${defaultLoginAccount}" || getParentWindowData("accountId") || accountId;

memberId     = '${ctp:escapeJavascript(param.memberId)}';
departmentId = "${ctp:escapeJavascript(param.departmentId)}" || "${v3x:currentUser().departmentId}";
postId       = '${ctp:escapeJavascript(param.postId)}';
levelId      = '${ctp:escapeJavascript(param.levelId)}';

maxSize = <c:out value="${param.maxSize}" default="1000" />;
minSize = <c:out value="${param.minSize}" default="1" />;

spId = "${param.id}";

selectTypes.addAll(SelectType.split(","));

panels.addAll(Panels.split(","));

showAccountPanel = getParentWindowData("showAccountPanel");

if(showAccountPanel == false){
	panels.remove(Constants_Account)
}

<c:if test="${!showAccounts}">
	panels.remove(Constants_Account);
</c:if>

<c:forEach items="${allAccounts}" var="ac">
	allAccounts.put('${ac.id}', new Account('${ac.id}', '${ac.superior}', "${v3x:escapeJavascript(ac.name)}", ${fn:length(ac.childrenAccounts) > 0}, "${v3x:escapeJavascript(ac.shortname)}", '${ac.levelScope}', ''));
	
	<c:if test="${ac.isRoot == true}">
		rootAccount = new Account('${ac.id}', '${ac.superior}', "${v3x:escapeJavascript(ac.name)}", ${fn:length(ac.childrenAccounts) > 0}, "${v3x:escapeJavascript(ac.shortname)}", '${ac.levelScope}', '');
	</c:if>
</c:forEach>

<c:forEach items="${accessableAccounts}" var="account">
	accessableAccounts.put('${account.id}', new Account('${account.id}', '${account.superior}', "${v3x:escapeJavascript(account.name)}", ${fn:length(account.childrenAccounts) > 0}, "${v3x:escapeJavascript(account.shortname)}", '${account.levelScope}', ''));
	accessableAccountIds.add(new Object({id:'${account.id}', superior:'${account.superior}'}));
</c:forEach>

<c:forEach items="${groupLevels}" var="l" varStatus="s">
groupLevels["${l.id}"] = ${s.index + 1};
</c:forEach>

function openAddExternalUnitDlg(){
	var rv = v3x.openWindow({
	        url:'exchangeEdoc.do?method=addExchangeAccountFromEodc',
	        width:"400",
	        height:"300",
	        resizable:"0",
	        scrollbars:"true",
	        dialogType:"modal"
	        });
	topWindow.initOrgModel(accountId, currentMemberId);
	selPanel("ExchangeAccount");
}
//-->
</script>
</head>
<body onkeypress="listenerKeyESC()"  style="background: #ededed;">
<script type="text/javascript">
<!--
var str;
if(navigator.userAgent.indexOf("MSIE")>0){
	str  = '<div id="procDiv" style="position:absolute;top:160px;width:100%;height:100%;z-index:50;">';
} else {
	str  = '<div id="procDiv" style="position:absolute;top:160px;left:184px;width:100%;height:100%;z-index:50;">';
}
	str += "<table align='center' width=\"240\" style=\"height:80px\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" bgcolor='#F6F6F6' style='border:solid 2px #DBDBDB;'>";
	str += "  <tr>";
	str += "    <td align='center' valign='bottom'><span id='uploadingDiv'>Loading...</span></td>";
	str += "  </tr>";
	str += "  <tr>";
	str += "    <td align='center' height='30'><span class='process' id='processTR'>&nbsp;</span></td>";
	str += "  </tr>";
	str += "</table>";
	str += '</div>';
	
	document.write(str);
	document.close();

	var setting = {
		view: {
			dblClickExpand: false,
			selectedMulti: false
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			onClick: onClick
		}
	};

	<c:if test="${showAccounts}">
	var zNodes = [
		${v3x:selectTree(accessableAccounts4Tree, 'id', 'superior', 'name', pageContext)}
	];
	</c:if>

	function onClick(e, treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("accountTree");
		var nodes = zTree.getSelectedNodes();
		var aId = nodes[0].id;
		var aName = nodes[0].name; 
		
		$("#currentAccountId").val(aName);
		hideMenu();
		chanageAccount(aId);
	}

	function showMenu() {
		var selectDisabled = $('#select_input_div').attr("disabled");
		if(selectDisabled == true || selectDisabled == "true"){
			return;
		}
		var accountObj = $("#currentAccountId");
		var accountOffset = accountObj.offset();
		$("#accountContent").css({left:accountOffset.left - 1 + "px", top:accountOffset.top + accountObj.outerHeight() + "px"}).slideDown("fast");

		var treeObj = $.fn.zTree.getZTreeObj("accountTree");
		var node = treeObj.getNodeByParam("id", accountId, null);
		if(node){
			treeObj.selectNode(node);
		}
		
		$("body").bind("mousedown", onBodyDown);
	}
	
	function hideMenu() {
		$("#accountContent").fadeOut("fast");
		$("body").unbind("mousedown", onBodyDown);
	}
	
	function onBodyDown(event) {
		if (!(event.target.id == "accountContent" || $(event.target).parents("#accountContent").length > 0)) {
			hideMenu();
		}
	}
	
	$(document).ready(function(){
		<c:if test="${showAccounts}">
		$.fn.zTree.init($("#accountTree"), setting, zNodes);
		</c:if>
	});
//-->
</script>
<div id="accountContent" style="display:none; position:absolute;">
	<ul id="accountTree" class="ztree" style="margin-top:0;"></ul>
</div>
<table id="selectPeopleTable" width="100%" height="100%" border="0" class="bg-body" align="center" cellpadding="0" cellspacing="0" style="display: none;">
	<tr valign="top">
		<td  class="" valign="top">
		<table width="100%" border="0" height="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				<table border="0" cellpadding="0" width="100%" cellspacing="0">
					<tr valign="top" id="tdPanel">
						<td width="1" height="26" ></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td style="border-top:1px solid #fff; border-bottom: 1px #d8d8d8 solid;padding-left: 5px;">
				<div class="scrollList" style="height: 397px; _height:368px; _overflow-x:hidden;">
				<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td class="padding7-10">
						<table border="0" cellspacing="0" width="100%"  cellpadding="0">
							<tr>
								<td valign="top">
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<c:if test="${showAccounts}">
										<td>
											<div id="select_input_div" class="select_input_div_width" onClick="showMenu(); return false;">
							                	<input name="currentAccountId" id="currentAccountId" type="text" class="select_input_width" readonly="readonly" value="" />
											</div>
										</td>
										</c:if>
										<td class="td-left-5">
											<table border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td class="cursor-hand" id="button1" onClick="showParentTree()" title="<fmt:message key='selectPeople.showparent.title' />"><img height=16 src="<c:url value="/common/SelectPeople/images/xs.gif"/>" width=17 align=absMiddle></td>
												</tr>
											</table>
										</td>
										<td class="td-left-5">
											<table border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td class="cursor-hand" id="button2" onClick="hiddenArea1()" title="<fmt:message key='selectPeople.hidden1.title' />"><img src="<c:url value="/common/SelectPeople/images/hb.gif"/>" width="16" height="16" align="absmiddle"></td>
												</tr>
											</table>
										</td>
										<td align="right" class="td-left-5" nowrap="nowrap"><span id="searchArea"><input onKeyPress="if(event.keyCode == 13) searchItems()"
											id="q" class="q-${showAccounts}" type="text" value="" maxlength="10" /><img
											src="<c:url value="/common/SelectPeople/images/search_button_rest.gif"/>"
											border="0" align="absmiddle" class="cursor-hand" height="18" onclick="searchItems()" /></span></td>
									</tr>
								</table>
								</td>
								<td colspan="2">
									<div class="div-float">
										<c:if test="${showAccounts}">
											<span id="seachGroupMember" class="hidden">
												&nbsp;<label for="seachGroup"><input type="checkbox" id="seachGroup" name="seachGroup" onClick="hideSeparatorDIV(this)" /><span>&nbsp;<fmt:message key="selectPeople.search.group.label${v3x:suffix()}" /></span></label>
											</span>
										</c:if>
									</div>
									<div class="div-float-right">
										<a class="like-a" onClick="openAddExternalUnitDlg()" style="display: none;" id="addExternalAccountDiv"><fmt:message key="selectPeople.externalAccountAdd.lable" /> </a>
									</div>
									<div class="div-float-right"><c:if test="${v3x:getBrowserFlagByUser('SelectPeople', v3x:currentUser())==true}"><a class="like-a" onClick="saveAsTeam()" id="saveAsTeamDiv">[<fmt:message key="selectPeople.saveAsTeam.lable" />]</a></c:if></div>
								</td>
								<td width="30">&nbsp;</td>
							</tr>
							<tr>
								<td width="251" valign="top">
								<table width="251" border="0" cellspacing="0" cellpadding="0">
									<tr style="display: none;" id="AreaTop1">
										<td height="24px">
											<select style="width:251px;font-family: Arial, Helvetica, sans-serif" id="areaTopList1" name="areaTopList1" onChange="initList('Post')">
											<option value="AllPosts"><fmt:message key="selectPeople.post.all" /></option>
											<v3x:metadataItem metadata="${postTypes}" showType="option" name="" bundle="${v3xOrganizationI18N}" />
											</select>
										</td>
									</tr>
									<tr onselectstart="return false" valign="top">
										<td height="155px"   id="Area1" class="iframe"></td>
									</tr>
									<tr>
										<td height="26" id="Separator1" valign="middle" style="text-align:left;">
											<div id="separatorDIV_Department" style="display: none;">
												<label for="sep_per" id="sep_per_l" style="display: none;"><input type="radio" name="sep" id="sep_per" value="Member" onClick="showList2OfDep(this.value)" checked="checked"><span><fmt:message key="org.member.label" /></span></label>
												<label  class="padding-left16" for="sep_post" id="sep_post_l" style="display: none;"><input type="radio" name="sep" id="sep_post" value="Post" onClick="showList2OfDep(this.value)"><span><fmt:message key="org.post.label" /></span></label>
												<label for="sep_role padding-left16" id="sep_role_l" style="display: none;"><input type="radio" name="sep" id="sep_role" value="Role" onClick="showList2OfDep(this.value)"><span><fmt:message key="org.role.label" /></span></label>
											</div>
											<div id="separatorDIV_Team" style="display: none;">
												<label for="sep_team"><input type="checkbox" name="sep_team" id="sep_team" onClick="showTeamRelativeMembers()"><span><fmt:message key="org.team.showRelative.label" /></span></label>
											</div>
											<div id="separatorDIV_Post" style="display: none;">
												<span onClick="showDetailPost()" class="cursor-hand like-a"><fmt:message key="selectPeople.post.showDetail.label" /></span>
											</div>
										</td>
									</tr>
									<tr onselectstart="return false">
										<td height="174" id="Area2" valign="top">
											<c:choose>
												<c:when test="${v3x:getBrowserFlagByUser('selectPeopleShowType', v3x:currentUser())==true}">
													<select id="memberDataBodyOrginal" multiple="multiple" style="width:251px;" size="14"></select>
												</c:when>
												<c:otherwise>
													<div class="div-select" id="memberDataBodyOrginal"></div>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</table>
								</td>
								<td width="35" align="center">
								<p>
								
								<img src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>"
									alt='<fmt:message key="selectPeople.alt.select"/>' width="24"
									height="24" class="cursor-hand" onclick="selectOne()">
								
								
									</p><br/>
								<p><img src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>"
									alt='<fmt:message key="selectPeople.alt.unselect"/>' width="24"
									height=24 class="cursor-hand" onclick="removeOne()"></p>
								</td>
								<td width="251" style="height:346px; height:326px;" valign="top">
									<c:choose>
										<c:when test="${v3x:getBrowserFlagByUser('selectPeopleShowType', v3x:currentUser())==true}">
											<select id="List3" onclick="" ondblclick="removeOne(this.value, this)" 
												multiple="multiple" style="height:346px;width:251px;" size="28" >
											</select>
										</c:when>
										<c:otherwise>
											<div id="List3" class="div-select-list3" onselectstart="return false"></div>
										</c:otherwise>
									</c:choose>
								</td>
								<td width="30" align="center">
								<p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>"
									alt='<fmt:message key="selectPeople.alt.up"/>'width="24"
									height="24" class="cursor-hand" onclick="exchangeList3Item('up')"></p><br/>
								<p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>"
									alt='<fmt:message key="selectPeople.alt.down"/>' width="24"
									height="24" class="cursor-hand" onclick="exchangeList3Item('down')"></p>
								</td>
							</tr>
						</table>
						</td>
					</tr>
				</table>
				</div>
				</td>
			</tr>
		</table>
		</td>
	</tr>
