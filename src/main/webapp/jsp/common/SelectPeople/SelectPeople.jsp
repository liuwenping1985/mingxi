<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set value="${ctp:currentUser().userSSOFrom}" var="topFrameName" />
<html id="selectPeoples" class="h100b ${(topFrameName!=null && topFrameName == true)?'':'over_hidden'}">
<head>
<title>${ctp:i18n("selectPeople.page.title")}</title>
<%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp"%>
<style>
	#ExchangeAccountDataBody{
		height:100%!important
	}
</style>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/SelectPeople/js/orgDataCenter.js${ctp:resSuffix()}" />"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=edocObjTeamManager"></script>
<script type="text/javascript">
var isSecretAdmin = "${isSecretAdmin}";
<!--
var ua = navigator.userAgent;
if(ua.indexOf('Android') > -1 || ua.indexOf('iPhone') > -1){
	$("#selectPeoples").removeClass("over_hidden"); 
}
function getIsCheckSelectedData(){
    try {
        return getBottomRadio("sequence").checked == false;
    }
    catch (e) {
        return true;
    }
}

function OK(){
    var data = null;
    
    try{
        data = getSelectedPeoples();
    }
    catch(e){
        if(e != 'continue'){
            $.alert({
              msg:e,
              targetWindow:parent.window
            });
        }
        return -1;
    }
    
    var obj = null;
    
    var showFlowTypeRadio = getParentWindowData("showFlowTypeRadio");
    if(showFlowTypeRadio){
        var flowtypes = parent.document.getElementsByName("flowtype");
        if(flowtypes == null){
            flowtypes = document.getElementsByName("flowtype");
        }
        
        for(var i = 0; i < flowtypes.length; i++){
            if(flowtypes[i].checked){
                flowtypes = flowtypes[i].value;
                break;
            }
        }

        obj = [data, flowtypes];
    }
    else{
        obj = data; //Element[]
    }
    
    var returnValueNeedType = getParentWindowData("returnValueNeedType", true);
    
    //正常返回数据，如果没有人，则data是一个length为0的数组，即data = []
    var v = {
        "value" :   getIdsString(data, returnValueNeedType),
        "text" :    getNamesString(data, "${ctp:i18n('common.separator.label')}"),
        "obj":      obj
    };
    
    <c:if test="${param.isFromModel eq 'true'}">
    window.returnValue = v;
    window.close();
    </c:if>
    
    return v;
}

var basePath = "${pageContext.request.contextPath}";

var topWindow = null;

function findTopWindow(thisObj, iterative){
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
          findTopWindow(parentObj, iterative - 1);
        }
    }
    
    return null;
}

//当前页面是dialog
var parentWindowData = null;
if(window.parentDialogObj){
    parentWindowData = window.parentDialogObj["SelectPeopleDialog"].getTransParams();
}
else{
    parentWindowData = window.dialogArguments;
}

var parentWindow = parentWindowData._window;

try{
    findTopWindow(parentWindow, 5);
}
catch(e){
}
if(topWindow == null){
    topWindow = this;
}
var dan = "${param.dan}";
try{
	if(!(typeof(dan)!="undefined" && dan==1)){
		if(parentWindow){
			var data = parentWindowData["params"];
			if(data != null){
				dan = data.dan;
			}
		}
	}
}
catch(e){}
var flowSecretLevel_wf = null;
//fb---获取涉密信息密级---Start
var secretObj = parent.document.getElementById("secretLevel");//新建协同、公文点击两个小人的图标以及节点权限
if(!secretObj && parentWindow){
	secretObj = parentWindow.document.getElementById("secretLevel");//列表中转发按钮
}
if(!secretObj && window.dialogArguments && window.dialogArguments._window
		&& window.dialogArguments._window.dialogArguments && window.dialogArguments._window.dialogArguments.returnValueWindow){
	secretObj = window.dialogArguments._window.dialogArguments.returnValueWindow.document.getElementById("secretLevel");//列表中编辑流程
}
if(!secretObj && parent.main && parent.main.summary){//列表summary iframe中记录
	secretObj = parent.main.summary.document.getElementById("secretLevel");
}
var curSecretLevel = "${param.secretLevel}";
if(secretObj){
	flowSecretLevel_wf = secretObj.value;
	if(typeof(flowSecretLevel_wf) == "undefined" || flowSecretLevel_wf == null){
		flowSecretLevel_wf = "${secretLevel}";
	}
	if(dan == 1){
		flowSecretLevel_wf = "";
	}
}else if(curSecretLevel){
	flowSecretLevel_wf = curSecretLevel;
}

//fb---获取涉密信息密级---Start

var Constants_Component    = new Properties();

Constants_Component.put(Constants_Account,          "${ctp:i18n('org.account.label')}");
Constants_Component.put(Constants_Department,       "${ctp:i18n('org.department.label')}");
Constants_Component.put(Constants_Team,             "${ctp:i18n('org.team.label')}");
Constants_Component.put(Constants_Post,             "${ctp:i18n('org.post.label')}");
Constants_Component.put(Constants_Level,            "${ctp:i18n('org.level.label')}");
Constants_Component.put(Constants_Member,           "${ctp:i18n('org.member.label')}");
Constants_Component.put(Constants_Role,             "${ctp:i18n('org.role.label')}");
Constants_Component.put(Constants_Outworker,        "${ctp:i18n('org.outworker.label')}");
Constants_Component.put(Constants_ExchangeAccount,  "${ctp:i18n('org.exchangeAccount.label')}");
Constants_Component.put(Constants_OrgTeam,          "${ctp:i18n('org.orgTeam.label')}");
Constants_Component.put(Constants_RelatePeople,     "${ctp:i18n('org.RelatePeople.label')}");
Constants_Component.put(Constants_FormField,        "${ctp:i18n('form.selectPeople.extend')}");
Constants_Component.put(Constants_OfficeField,      "${ctp:i18n('office.selectPeople.extend')}");
Constants_Component.put(Constants_Admin,            "${ctp:i18n('org.admin.label')}");
Constants_Component.put(Constants_Node,             "${ctp:i18n('org.node.label')}");
Constants_Component.put(Constants_WfSuperNode,             "超级节点");
Constants_Component.put(Constants_OrgRecent,        "${ctp:i18n('org.orgrecent.label')}");

var PeopleRelate_TypeName = {
    1 : "${ctp:i18n('relate.type.leader')}",
    2 : "${ctp:i18n('relate.type.assistant')}",
    3 : "${ctp:i18n('relate.type.junior')}",
    4 : "${ctp:i18n('relate.type.confrere')}"
};


topWindow.PeopleRelate_TypeName = PeopleRelate_TypeName;

var isAdministrator = ${CurrentUser.administrator}; //单位管理员
var groupAdmin = ${CurrentUser.groupAdmin} || ${CurrentUser.auditAdmin}; //集团管理员 审计管理员
var systemAdmin = ${CurrentUser.systemAdmin}; //系统管理员

var isAdmin = isAdministrator || groupAdmin || systemAdmin;

var isInternal = ${CurrentUser.internal}; //是否是内部人员

var myAccountId = "${CurrentUser.accountId}";
var loginAccountId = "${CurrentUser.loginAccount}";

var isGroupAccessable = ${isGroupAccessable};
var accessableRootAccountId = [${accessableRootAccountId}];
//-->
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/css/css.css${ctp:resSuffix()}" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/tree/xtree.css${ctp:resSuffix()}" />" />

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/SelectPeople/js/Panel.js${ctp:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/SelectPeople/tree/xtree.js${ctp:resSuffix()}" />"></script>

<c:set value="${v3x:getSysFlagByName('selectPeople_showAccounts')}" var="showAccounts" />
<c:set value="${CurrentUser.loginAccount}" var="defaultLoginAccount" />
<c:if test="${CurrentUser.systemAdmin || CurrentUser.groupAdmin || CurrentUser.auditAdmin}">
    <c:set value="${firstAccountId}" var="defaultLoginAccount" />
</c:if>
<c:if test="${not empty param.accountId}">
    <c:set value="${param.accountId}" var="defaultLoginAccount" />
</c:if>

<script type="text/javascript">
<!--
currentMemberId  = "${CurrentUser.id}";

//是否是多组织吧
var isGroupVer = ${v3x:getSysFlagByName("sys_isGroupVer")};

ShowMe       = getParentWindowData("showMe", true);
SelectType   = getParentWindowData("selectType", "");
Panels       = getParentWindowData("panels", "");
//首先聚焦那个页签 lilong 20140411
tempNowPanel = Constants_Panels.get(getParentWindowData("nowPanel", ""));
showRecent     = getParentWindowData("showRecent", true);

accountId    = "${defaultLoginAccount}" || getParentWindowData("accountId") || accountId;

memberId     = getParentWindowData("memberId");
departmentId = getParentWindowData("departmentId") || "${currentDepartment}";
postId       = getParentWindowData("postId");
levelId      = getParentWindowData("levelId");

maxSize = getParentWindowData("maxSize", 1000);
minSize = getParentWindowData("minSize", 1);

spId = "-1";

selectTypes.addAll(SelectType.split(","));

panels.addAll(Panels.split(","));

showAccountPanel = getParentWindowData("showAccountPanel");

if(showAccountPanel == false){
    panels.remove(Constants_Account);
}

selectTypes.remove(Constants_RelatePeople);

<c:if test="${!showAccounts}">
    panels.remove(Constants_Account);
</c:if>

<c:forEach items="${allAccounts}" var="ac">
    allAccounts.put('${ac.id}', new Account('${ac.id}', '${ac.superior}', '${ac.path}', "${v3x:escapeJavascript(ac.name)}", true, "${v3x:escapeJavascript(ac.shortName)}", '${ac.levelScope}', ''));
    <c:if test="${ac.group == true}">
    rootAccount = new Account('${ac.id}', '${ac.superior}', '${ac.path}', "${v3x:escapeJavascript(ac.name)}", true, "${v3x:escapeJavascript(ac.shortName)}", '${ac.levelScope}', '');
    </c:if>
</c:forEach>

<c:forEach items="${accessableAccounts}" var="account">
    accessableAccountIds.add(new Object({id:'${account.id}', superior:'${account.superior}'}));
</c:forEach>
for(var i = 0; i < accessableAccountIds.size(); i++){
    var accessableAccountId = accessableAccountIds.get(i).id;
    var ac = allAccounts.get(accessableAccountId);
    if(ac){
        accessableAccounts.put(accessableAccountId, ac);

        var parentAccountId = accessableAccountIds.get(i).superior;
        var pac = allAccounts.get(parentAccountId);
        if(pac){
            pac.accessChildren.add(ac);
        }
    }
}

<c:forEach items="${groupLevels}" var="l" varStatus="s">
groupLevels["${l.id}"] = ${s.index + 1};
</c:forEach>

function openAddExternalUnitDlg(){

	if(typeof(getA8Top().$.dialog)!='undefined'){
	getA8Top().win123 = getA8Top().$.dialog({
      id : "saveAsTeamDialog",
      url :"/seeyon/exchangeEdoc.do?method=addExchangeAccountFromEodc",
      width : 380,
      height: 400,
      title : $.i18n("selectPeople.externalAccountAdd.lable.js"),
      isDrag :false,
      targetWindow : getA8Top().window,
      transParams : {
          _window : window,
		  _callbackRefresh:refreshEdocExternalUnit
      }
    });
	}else if(typeof(getA8Top().v3x.openDialog)!='undefined'){
	 getA8Top().win123 = getA8Top().v3x.openDialog({
      id : "saveAsTeamDialog",
      url :"/seeyon/exchangeEdoc.do?method=addExchangeAccountFromEodc",
      width : 380,
      height: 300,
      isDrag :false,
      targetWindow : getA8Top().window,
      transParams : {
          _window : window,
		  _callbackRefresh:refreshEdocExternalUnit
      }
    });
	}
   
   
}
function refreshEdocExternalUnit(){
    topWindow.initOrgModel(accountId, currentMemberId);
    selPanel("ExchangeAccount");
}
//-->
</script>
</head>
<body class="font_size12 h100b ${(topFrameName!=null && topFrameName == true)?'':'over_hidden'} page_color">
<script type="text/javascript">
<!--
    var proce = $.progressBar();

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

    function onClick(e, treeId, treeNode) {
        var nodes = $("#accessableAccounts4Tree").treeObj().getSelectedNodes();
        var aId = nodes[0].id;
        var aName = nodes[0].name || ""; 
        
        $("#currentAccountId").val(aName.getLimitLength(22));
        $("#currentAccountId").attr("title", aName);
        
        hideMenu();
        chanageAccount(aId);
    }

    function showMenu() {
        var selectDisabled = $('#select_input_div').attr("disabled");
        if(selectDisabled == true || selectDisabled == "true" || selectDisabled == "disabled"){
            return;
        }
        var accountObj = $("#select_input_div");
        var accountOffset = accountObj.offset();
        $("#accountContent").height($("#Area1").height()).css({left:accountOffset.left - 1 + "px", top:accountOffset.top + accountObj.outerHeight()+ 6 + "px"}).show();
        $("#accountContentIframe").height($("#Area1").height()).css({left:accountOffset.left - 1 + "px", top:accountOffset.top + accountObj.outerHeight() + "px"}).show();

        var treeObj = $.fn.zTree.getZTreeObj("accessableAccounts4Tree");
        var node = treeObj.getNodeByParam("id", accountId, null);
        if(node){
            treeObj.expandNode(node, true);
            treeObj.selectNode(node);
        }
        
        $("body").bind("mousedown", onBodyDown);
    }
    
    function hideMenu() {
        $("#accountContent").hide();
        $("#accountContentIframe").hide();
        $("body").unbind("mousedown", onBodyDown);
    }
    
    function onBodyDown(event) {
        if (!(event.target.id == "accountContent" || $(event.target).parents("#accountContent").length > 0)) {
            hideMenu();
        }
    }
    
    $(document).ready(function(){
        <c:if test="${showAccounts}">
        $("#accessableAccounts4Tree").tree({
            idKey   : "id",
            pIdKey  : "superior",
            nameKey : "name",
            onClick : onClick
        });
        </c:if>
    });
//-->
</script>
<div id="accountContent" style="display:none; position:absolute;background: #ffffff; width:301px; height:430px;z-index: 10" class="border_all">
    <div style="margin-top:0px; width:301px; height:100%; display: block; overflow: auto">
        <ul id="accessableAccounts4Tree" class="ztree"></ul>
    </div>
</div>
<iframe id="accountContentIframe" height="430px" width="301" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display:none; position:absolute;background: #ffffff; width:301px; height:430px;z-index: 9"></iframe>    
<table id="selectPeopleTable" width="100%" height="100%" border="0" class="bg-body1" align="center" cellpadding="0" cellspacing="0" style="display: none;">
    <tr valign="top">
        <td>
        <table width="100%" border="0" height="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td height="33" valign="bottom">
                    <table border="0" cellpadding="0" width="100%" cellspacing="0">
                        <tr valign="top" id="tdPanel">
                            <td width="1" height="26"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="border_t padding_l_10 padding_r_10 padding_t_5">
                    <table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="padding_b_5">
                                <table border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <c:if test="${showAccounts}">
                                        <td>
                                            <div id="select_input_div" class="border_all padding_l_5 padding_r_5 bg_color_white" onClick="showMenu(); return false;">
                                                <input name="currentAccountId" id="currentAccountId" type="text" class="select_input_width arrow_6_b hand" style="height: 24px; border: 0px" readonly="readonly" value="" />
                                            </div>
                                        </td>
                                        </c:if>
                                        <td align="right" class="${showAccounts ? 'td-left-5' : ''}" nowrap="nowrap">
                                            <ul class="common_search">
                                                <li id="inputBorder" class="common_search_input"><input id="q" class="search_input" style="width: ${showAccounts ? 92 : 260}px" type="text" onclick="checkSearchAlt()" onfocus="checkSearchAlt()" onblur="checkSearchAlt(true)" onkeydown="if(event.keyCode == 13)searchItems()"></li>
                                                <li><a class="common_button common_button_gray search_buttonHand" onclick="searchItems()"><em></em></a></li>
                                            </ul> 
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td colspan="2" class="padding_r_10">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td nowrap="nowrap" class="padding_l_5">
                                            <c:if test="${showAccounts}">
                                                <span id="seachGroupMember" class="hidden">
                                                    <label for="seachGroup"><input type="checkbox" id="seachGroup" name="seachGroup" onClick="hideSeparatorDIV(this)" /><span>&nbsp;${ctp:i18n("selectPeople.search.group.label")}</span></label>
                                                </span>
                                            </c:if>
                                        </td>
                                        <td nowrap="nowrap">
                                            <a class="like-a" onClick="openAddExternalUnitDlg()" style="display: none;" id="addExternalAccountDiv">${ctp:i18n("selectPeople.externalAccountAdd.lable")} </a>
                                        </td>
                                        <td nowrap="nowrap" align="right" width="145" class="padding_l_5">
                                            <ul id="SearchButton3_1" class="common_search hidden">
                                                <li id="q3Li" class="common_search_input"><input id="q3" class="search_input" style="width: 100px" type="text" onkeydown="if(event.keyCode == 13)searchItems3()" onblur="showSearchButton3(false)" value=""></li>
                                                <li><a class="common_button common_button_gray search_buttonHand" onclick="searchItems3()" id="ok_msg_btn_first2" title="${ctp:i18n('selectPeople.search3.alt')}"><em></em></a></li>
                                            </ul>
                                            <div id="SearchButton3_2" class="search_b hand" onclick="showSearchButton3(true)" title="${ctp:i18n('selectPeople.search3.alt')}"></div>
                                        </td>
                                        <td nowrap="nowrap" align="right" width="70" id="saveAsTeamDiv">
                                            <c:if test="${v3x:getBrowserFlagByUser('SelectPeople', CurrentUser)==true}">
                                              <c:if test="${loginName != 'secret-admin'}">
                                                <a class="color_gray2" onClick="saveAsTeam()">[${ctp:i18n("selectPeople.saveAsTeam.lable")}]</a>
                                              </c:if>
                                            </c:if>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="30">&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="301" valign="top">
                                <table width="301" border="0" cellspacing="0" cellpadding="0">
                                    <tr style="display: none;" id="AreaTop1_Post">
                                        <td height="24px">
                                            <select style="width:301px;font-family: Arial, Helvetica, sans-serif" class="codecfg" codecfg="codeId: 'organization_post_types'" id="areaTopList1_Post" name="areaTopList1_Post" onChange="initList('Post')">
                                                <option value="AllPosts">${ctp:i18n("selectPeople.post.all")}</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr style="display: none;" id="AreaTop1_RelatePeople">
                                        <td height="24px">
                                            <select style="width:301px;font-family: Arial, Helvetica, sans-serif" id="areaTopList1_RelatePeople" name="areaTopList1_RelatePeople" onChange="initList('RelatePeople')">
                                                <option value="All">${ctp:i18n("selectPeople.relatepeople.all")}</option>
                                                <option value="1">${ctp:i18n("relate.type.leader")}</option>
                                                <option value="2">${ctp:i18n("relate.type.assistant")}</option>
                                                <option value="3">${ctp:i18n("relate.type.junior")}</option>
                                                <option value="4">${ctp:i18n("relate.type.confrere")}</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr onselectstart="return false" valign="top">
                                        <td height="195px" id="Area1" class="iframe"></td>
                                    </tr>
                                    <tr>
                                        <td height="30" id="Separator1" valign="middle" style="text-align:left;">
                                            <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td id="Separator1_0" align="center" class="border_b border_l border_r w100b margin_0 padding_0" style="height:8px;font-size:2px;"><span class="ico16 arrow_1_t margin_0 padding_0" style="height: 8px;background-position: -32px -4px" onclick="hiddenArea1()"></span></td>
                                                </tr>
                                                <tr>
                                                    <td id="Separator1_1" height="26px">
                                                        <div id="separatorDIV_Department" style="display: none;">
                                                            <label for="sep_per"  id="sep_per_l"  style="display: none;" class="margin_t_5 hand"><input type="radio" name="sep" id="sep_per"  class="radio_com" value="Member" onClick="showList2OfDep(this.value)" checked="checked"><span>${ctp:i18n("org.member.label")}</span></label>&nbsp;
                                                            <label for="sep_post" id="sep_post_l" style="display: none;" class="margin_t_5 hand"><input type="radio" name="sep" id="sep_post" class="radio_com" value="Post" onClick="showList2OfDep(this.value)"><span>${ctp:i18n("org.post.label")}</span></label>&nbsp;
                                                            <label for="sep_role" id="sep_role_l" style="display: none;" class="margin_t_5 hand"><input type="radio" name="sep" id="sep_role" class="radio_com" value="Role" onClick="showList2OfDep(this.value)"><span>${ctp:i18n("org.role.label")}</span></label>
                                                        </div>
                                                        <div id="separatorDIV_Team" style="display: none;">
                                                            <label for="sep_team"><input type="checkbox" name="sep_team" id="sep_team" onClick="showTeamRelativeMembers()">&nbsp;&nbsp;<span>${ctp:i18n("org.team.showRelative.label")}</span></label>
                                                        </div>
                                                        <div id="separatorDIV_Post" style="display: none;">
                                                            <span onClick="showDetailPost()" class="hand">${ctp:i18n("selectPeople.post.showDetail.label")}</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td id="Separator1_2" align="center" class="border_t border_l border_r w100b margin_0 padding_0"  style="height:8px;font-size:2px;"><span class="ico16 arrow_1_b margin_0 padding_0" style="height: 8px;background-position: 0px -4px" onclick="hiddenArea2()"></span></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr onselectstart="return false">
                                        <td height="200" id="Area2" valign="top">
                                            <c:choose>
                                                <c:when test="${v3x:getBrowserFlagByUser('selectPeopleShowType', CurrentUser)==true}">
                                                    <select id="memberDataBodyOrginal" multiple="multiple" style="width:301px;" size="13"></select>
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
                                    <span class="select_selected" title='${ctp:i18n("selectPeople.alt.select")}' onclick="selectOne()"></span>
                                </p>
                                <br/>
                                <p>
                                    <span class="select_unselect" title='${ctp:i18n("selectPeople.alt.unselect")}' onclick="removeOne()"></span>
                                </p>
                            </td>
                            <td width="301" style="height:406px;" valign="top">
                                <c:choose>
                                    <c:when test="${v3x:getBrowserFlagByUser('selectPeopleShowType', CurrentUser)==true}">
                                        <select id="List3" onclick="" ondblclick="removeOne(this.value, this)" multiple="multiple" style="padding-top: 1px;height:426px;width:301px;" size="28" >
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <div id="List3" class="div-select-list3" onselectstart="return false"></div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td width="30" align="center">
                                <p>
                                    <span class="sort_up" title='${ctp:i18n("selectPeople.alt.up")}' onclick="exchangeList3Item('up')"></span>
                                </p>
                                <br/>
                                <p>
                                    <span class="sort_down" title='${ctp:i18n("selectPeople.alt.down")}' onclick="exchangeList3Item('down')"></span>
                                </p>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        </td>
    </tr>
    <c:if test="${param.isFromModel eq 'true'}">
    <tr>
        <td height="44" id="btns" class="bg-button-select" style="padding-right:30px;">
            <table width="100%" border="0" height="100%" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="60%" align="left">
                        <table id="flowTypeDiv" class="hidden" border="0" height="100%" align="left" cellpadding="0" cellspacing="0">
                            <td id="concurrentType">&nbsp;&nbsp;&nbsp;&nbsp;
                                <label for="concurrent">
                                    <input id="concurrent" name="flowtype" type="radio" value="1" checked><span>${ctp:i18n("selectPeople.flowtype.concurrent.lable")}</span>
                                </label>
                            </td>
                            <td id="sequenceType">&nbsp;&nbsp;&nbsp;
                                <label for="sequence">
                                    <input id="sequence" name="flowtype" type="radio" value="0"><span>${ctp:i18n("selectPeople.flowtype.sequence.lable")}</span>
                                </label>
                            </td>
                            <td id="multipleType">&nbsp;&nbsp;&nbsp;
                                <label for="multiple">
                                    <input id="multiple" name="flowtype" type="radio" value="2"><span>${ctp:i18n("selectPeople.flowtype.multiple.lable")}</span>
                                </label>
                            </td>
                            <td id="colAssignType">&nbsp;&nbsp;&nbsp;
                                <label for="colAssign">
                                    <input id="colAssign" name="flowtype" type="radio" value="3"><span>${ctp:i18n("selectPeople.flowtype.colAssign.lable")}</span>
                                </label>
                            </td>
                        </table>
                    </td>
                    <td align="right">
                        <input name="Submit" type="button" onClick="OK();" class="common_button common_button_gray"
                            value='${ctp:i18n("common.button.ok.label")}'>&nbsp;&nbsp;
                        <input name="close" type="button" onclick="window.close()" class="common_button common_button_gray"
                            value='${ctp:i18n("common.button.cancel.label")}'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    </c:if>
</table>
<script type="text/javascript">
<!--
function getBottomRadio(name){
    var pObj = parent.document.getElementById(name);
    return pObj == null ? document.getElementById(name) : pObj;
}

var showFlowTypeRadio = getParentWindowData("showFlowTypeRadio");
if(showFlowTypeRadio == true){
    getBottomRadio("flowTypeDiv").className = "";
}

var invalidationMultipleRadio = getParentWindowData("invalidationMultipleRadio");
if(invalidationMultipleRadio == true){
    getBottomRadio("multipleType").disabled = true;
}

var hiddenMultipleRadio = getParentWindowData("hiddenMultipleRadio");
if(hiddenMultipleRadio == true){
    getBottomRadio("multipleType").style.display = "none";
}

var invalidationColAssignRadio = getParentWindowData("invalidationColAssignRadio");
if(invalidationColAssignRadio == true){
    getBottomRadio("colAssignType").disabled = true;
}

var hiddenColAssignRadio = getParentWindowData("hiddenColAssignRadio");
if(hiddenColAssignRadio == true){
    getBottomRadio("colAssignType").style.display = "none";
}

var _flowtype = getParentWindowData("flowtype");
if(_flowtype){
    var flowtypeObj = getBottomRadio(_flowtype);
    if(flowtypeObj){
        flowtypeObj.checked = true;
    }
}
//-->
</script>
</body>
</html>
