<%@page import="com.seeyon.ctp.common.flag.BrowserEnum"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common4coll.jsp"%>
<html class="h100b over_hidden">
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=planRefRelationManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>
<%-- <script type="text/javascript" src="<c:url value='/apps_res/project/js/projectSelect.js${v3x:resSuffix()}'/>"></script> --%>
<head>
<c:if test="${simplePlan.isModify=='1'}">
<title>${ctp:i18n("plan.update_plan")}</title>
</c:if>
<c:if test="${simplePlan.isModify!='1'}">
<title>${ctp:i18n("plan.new_plan")}</title>
</c:if>
<style>
.stadic_head_height{
height:135px;
}
.stadic_body_top_bottom{
top:135px;
bottom:0;
overflow:hidden;
}
</style>
<script>
var bIsContentIframe = true;
var bIsContentNewPage = true;
window.onbeforeunload = function() {
  removeCtpWindow('123123123123123123',2);
  removeCtpWindow(null,2);
  if(isFormSubmit) {
    return "";
  }
}
function mainBodyFrameOnLoad(obj){
    //取消正文编辑中的padding值
    try{
        //obj.contentWindow.$(".content_text").css("padding","0");
    }catch(e){}
}
</script>
</head>
<body class="h100b over_hidden page_color border_r" onunload="removeSessionMasterData();">
    <c:if test="${fromType!='department'}">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_planListHome'"></div>
    </c:if>
    <c:if test="${fromType=='department'}">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_createDepartmentPlan'"></div>
    </c:if>
    <div class="stadic_layout" id="colDomain" >
        <div class="" id="formArea">
             <div class="border_t_white border_b">
                    <div id="colToolbar"></div>
                </div>
                <div class="form_area new_page border_t_white" style="margin-bottom:0px;">
                <input type="hidden" id="createTime" name="createTime" value="${simplePlan.createTimeStr}"/>
                <input type="hidden" id="createUserName" name="createUserName" value="${simplePlan.createUserName}"/>
                <input type="hidden" id="createUserDept" name="createUserDept" value="${createUserDepartment}"/>
                <input type="hidden" id="createUserPost" name="createUserPost" value="${createUserPost}"/>
                <form id="planform" name="planform"  method="post" action="${path}/plan/plan.do?method=saveAttachment">
                    <div id="area1">
                        <table id="plan_table" border="0" cellspacing="0" cellpadding="0" width="100%">
                            <input type="hidden" id="planId" name="planId" value="${simplePlan.planId}"/>
                            <input type="hidden" id="type" name="type" value="${simplePlan.type}"/>
                            <input type="hidden" id="contentType" name="contentType" value="${simplePlan.contentType}"/>
                            <input type="hidden" id="planStatus" name="planStatus" value="${simplePlan.planStatus}"/>
                            <input type="hidden" id="publishStatus" name="publishStatus" value="${simplePlan.publishStatus}"/>

                            <input type="hidden" id="isModifyInput" name="isModifyInput" value="${simplePlan.isModify}"/>
                            <input type="hidden" id="pathInput" name="pathInput" value="${path}"/>
                            <input type="hidden" id="templateIdInput" name="templateIdInput" value="${simplePlan.templateId}"/>
                            <input type="hidden" id="relateDepartmentInput" name="relateDepartmentInput" value="${simplePlan.relateDepartment}"/>
                            <input type="hidden" id="relateDepartmentNameInput" name="relateDepartmentNameInput" value="${simplePlan.relateDepartmentName}"/>
                            <input type="hidden" id="planToMainUserInput" name="planToMainUserInput" value="${simplePlan.planToMainUser}"/>
                            <input type="hidden" id="planToMainUserNameInput" name="planToMainUserNameInput" value="${simplePlan.planToMainUserName}"/>
                            <input type="hidden" id="planSubMainUserInput" name="planSubMainUserInput" value="${simplePlan.planSubMainUser}"/>
                            <input type="hidden" id="planSubMainUserNameInput" name="planSubMainUserNameInput" value="${simplePlan.planSubMainUserName}"/>
                            <input type="hidden" id="planTellUserInput" name="planTellUserInput" value="${simplePlan.planTellUser}"/>
                            <input type="hidden" id="planTellUserNameInput" name="planTellUserNameInput" value="${simplePlan.planTellUserName}"/>

							<input type="hidden" id="currentUserid" name="currentUserid" value="${CurrentUser.id}"/>
							<input type="hidden" id="currentUsername" name="currentUsername" value="${CurrentUser.name}"/>
							<input type="hidden" id="depId" name="depId" value="${depId}"/>
							<input type="hidden" id="postId" name="postId" value="${postId}"/>
							<input type="hidden" id="postName" name="postName" value="${postName}"/>
							<input type="hidden" id="depname" name="depname" value="${ctp:getDepartment(depId).name}"/>

							<input type="hidden" id="stime" name="stime" value="${ctp:formatDate(simplePlan.startTime)}"/>
							<input type="hidden" id="etime" name="etime" value="${ctp:formatDate(simplePlan.endTime)}"/>

							<input type="hidden" id="parseElementsOfTypeAndIdplanToMainUser" name="parseElementsOfTypeAndIdplanToMainUser" value="${ctp:parseElementsOfTypeAndId(simplePlan.planToMainUser)}"/>
							<input type="hidden" id="parseElementsOfTypeAndIdplanSubMainUser" name="parseElementsOfTypeAndIdplanSubMainUser" value="${ctp:parseElementsOfTypeAndId(simplePlan.planSubMainUser)}"/>
							<input type="hidden" id="parseElementsOfTypeAndIdplanTellUser" name="parseElementsOfTypeAndIdplanTellUser" value="${ctp:parseElementsOfTypeAndId(simplePlan.planTellUser)}"/>
							<input type="hidden" id="parseElementsOfTypeAndIdrelateDepartment" name="parseElementsOfTypeAndIdrelateDepartment" value="${ctp:parseElementsOfTypeAndId(simplePlan.relateDepartment)}"/>
							<input type="hidden" id="toHTMLWithoutSpacetitle" name="toHTMLWithoutSpacetitle" value="${ctp:toHTMLWithoutSpace(simplePlan.title)}"/>
						
                            <tr>
                            	<td rowspan="5" style="vertical-align: top;"><a class="margin_10 display_inline-block align_center new_btn" id="send">${ctp:i18n('common.toolbar.send.label')}</a></td>
                                <th nowrap="nowrap" width="1%"><label for="text">&nbsp;&nbsp;${ctp:i18n('common.subject.label')}：</label></th>
                                <td width="100%">
                                    <div class="common_txtbox_wrap">
                                        <input  type="text" id="title" class="validate" validate='type:"string",notNull:true,name:"${ctp:i18n("common.subject.label")}",isDefaultValue:false,defaultValue:"${ctp:i18n("plan.new.inputtitle")}",minLength:0,maxLength:50' />
                                    </div>
                                    <input type="hidden" id="subject" name="subject" value=""/>
                               </td>
                                <th nowrap="nowrap" width="1%" style="padding-left:30px;"><label for="text">&nbsp;&nbsp;${ctp:i18n('common.date.begindate.label')}：</label></th>
                                    <td><div class="common_txtbox_wrap">
                                        <input type="text" id="startTime" readonly class="comp validate" validate='type:"string",notNull:true,name:"${ctp:i18n("common.date.begindate.label")}"' comp="type:'calendar',onUpdate:checkStartTime,ifFormat:'%Y-%m-%d',showsTime:false"/>
                                    </div></td>
                                <th nowrap="nowrap" width="1%" style="padding-left:30px;"><label for="text">&nbsp;&nbsp;${ctp:i18n('common.date.enddate.label')}：</label></th>
                                    <td><div class="common_txtbox_wrap">
                                        <input type="text" id="endTime" readonly class="comp validate" validate='type:"string",notNull:true,name:"${ctp:i18n("common.date.enddate.label")}"' comp="type:'calendar',onUpdate:checkEndTime,ifFormat:'%Y-%m-%d',showsTime:false"/>
                                </div></td>
                                <td width="10" nowrap="nowrap" rowspan="3">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	
                                <th nowrap="nowrap" width="1%"><label for="text">&nbsp;&nbsp;${ctp:i18n('plan.toolbar.button.to')}：</label></th>
                                <td width="100%"><div class="common_txtbox_wrap">
                                        <input type="text" id="planToMainUser" readonly name="planToMainUser" class="comp" comp="type:'selectPeople',panels:'Department,Team,Outworker',callback:changeMainPeople,selectType:'Member',showMe:false,minSize:0,isNeedCheckLevelScope:false"/>
                                    </div></td>
                                <th nowrap="nowrap" width="1%"><label for="text">&nbsp;&nbsp;${ctp:i18n('plan.toolbar.button.cc')}：</label></th>
                                <td><div>
                                        <input type="text" id="planSubMainUser" readonly name="planSubMainUser" class="comp" comp="type:'selectPeople',panels:'Department,Team,Outworker',callback:changeSubPeople,selectType:'Member',showMe:false,minSize:0,isNeedCheckLevelScope:false"/>
                                    </div></td>
                                <th nowrap="nowrap" width="1%"><label for="text">&nbsp;&nbsp;${ctp:i18n('plan.toolbar.button.apprize')}：</label></th>
                                <td><div>
                                        <input type="text" id="planTellUser" readonly name="planTellUser" class="comp" comp="type:'selectPeople',panels:'Department,Team,Outworker',callback:changeTellPeople,selectType:'Member',showMe:false,minSize:0,isNeedCheckLevelScope:false"/>
                                    </div></td>
                            </tr>
                            <tr>
                                <th nowrap="nowrap" width="1%">&nbsp;<label class="margin_l_10" for="text">${ctp:i18n('plan.toolbar.button.planformat')}：</label></th>
                                <td width="20%"><div>
                                        <select id="templateId" name="templateId" onchange="changeTemplate()" class="w100b">
                                            <option value="-1">${ctp:i18n('common.none')}</option>
                                            <c:forEach var="normalTemplates" items="${contentTemplates}">
                                                <option title="${normalTemplates.templateName}" value="${normalTemplates.id}">${normalTemplates.templateName}</option>
                                            </c:forEach>
                                            <c:forEach var="formTemplates" items="${templates}">
                                                <option title="${formTemplates.subject}" value="${formTemplates.id}">${formTemplates.subject}</option>
                                            </c:forEach>
                                        </select>
                                    </div></td>
                                <th nowrap="nowrap" width="1%">&nbsp;<label class="margin_l_10" for="text">${ctp:i18n('plan.toolbar.button.relatedep')}：</label></th>
                                <td width="20%"><div class="common_selectbox_wrap">
                                        <input type="text" id="relateDepartment" readonly name="relateDepartment" class="comp" comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Department',maxSize:1,minSize:0" />
                                    </div></td>
                                <th nowrap="nowrap" width="1%">&nbsp;<label class="margin_l_10" for="text">${ctp:i18n('plan.toolbar.button.relateproject')}：</label></th>
                                <td width="20%">
                                	<div id="projectDiv">
                                    </div>
                                </td>
                            </tr>
                              <tr  id="attachmentTR" style="display:none;">
                                  <td nowrap="nowrap" width="1%" valign="top" class="align_right" style="padding-top: 5px;"><div class="div-float" style="margin-top: 7px;"><em class="ico16 affix_16"></em>(<span id="attachmentNumberDiv"></span>)：</div></td>
                                  <td colspan="5" style="padding-top: 5px;"><span style="line-height: 14px; float: left;"></span><div id="attachmentTRDiv" class="comp" comp="type:'fileupload',applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,canFavourite:false" attsdata='${attachments}'></div></td>
                              </tr>
                              <tr id="attachment2TRposition1" style="display:none;">
                                    <td nowrap="nowrap" width="1%" valign="top" class="align_right"><div class="div-float" style="margin-top: 5px;"><em class="ico16 associated_document_16"></em>(<span id="attachment2NumberDivposition1"></span>)：</div>
                                        <td colspan="5"><div id="attachment2TRposition1Div" class="comp" comp="type:'assdoc',attachmentTrId:'position1', modids:'1,3,5'" attsdata='${attachments}'></div></td>
                                    </td>
                              </tr>
                        </table>
                    </div>
                    </form>
                </div>
        </div>
        <%@ include file="/WEB-INF/jsp/apps/plan/planNew.js.jsp" %>
        <script type="text/javascript" src="${path}/apps_res/plan/js/planPrint.js${v3x:resSuffix()}"></script>
		<script type="text/javascript" src="${path}/apps_res/plan/js/planNew.js${v3x:resSuffix()}"></script>
		<%@ include file="/WEB-INF/jsp/common/content/include/include_variables.jsp" %>
        <div id="mainbodyArea">
            <div class="h100b">
                <div id="hengx" class="hidden hr_heng"></div>
                <iframe id="mainbodyFrame" name='mainbodyFrame' onload="loadContent();mainBodyFrameOnLoad(this)" width="100%" height="100%" frameBorder="no"></iframe>
            </div>
        </div>
    </div> 
</body>
<%@ include file="/WEB-INF/jsp/project/project_select.js.jsp"%>
<script>
   $(document).ready(function (){
    var obj=new Object();
	obj["id"]="relateProject";
	obj["class"]="w100b";
	initProjectSelect(obj,"projectDiv","${relateProjectId}");
	
	//初始化计划相关内容
	initPlan();
	
	$("#mainbodyFrame").css("display","block");
   });
</script>
</html>
