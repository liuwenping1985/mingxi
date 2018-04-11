<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/bbs" prefix="bbs"%>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource" var="collI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.calendar.resources.i18n.CalendarResources" var="calI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.project.resources.i18n.ProjectResources"/>
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource"/>

<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html:link renderURL="/apps_res/project/addProject.jsp" var="addURL" />
<html:link renderURL="/apps_res/project/phaseSort.jsp" var="sortURL" />
<html:link renderURL="/project.do" var="basicURL" />
<html:link renderURL="/project/project.do" var="newbasicURL" />
<html:link renderURL="/collaboration/collaboration.do" var="colURL" />
<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL="/mtMeeting.do" var="mtURL" />
<html:link renderURL="/plan/plan.do" var="planURL" />
<html:link renderURL="/calendar/calEvent.do" var="calEventURL" />
<html:link renderURL="/bbs.do" var="bbsURL" />
<html:link renderURL="//bbs.do?method=delArticle&isFromProject=true" var="delBbsURL" />
<html:link renderURL='/genericController.do' var="genericController" />
<html:link renderURL="/template/template.do" var="temURL" />
<html:link renderURL="/taskmanage/taskinfo.do" var="taskManageURL" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/project/css/css.css${v3x:resSuffix()}" />">
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/guestbook.js${v3x:resSuffix()}" />"></script>

<fmt:message key="common.date.sample.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<%@ include file="../common/INC/noCache.jsp" %>

<c:set value="${v3x:currentUser()}" var="currentUser"/>
<c:set value="${currentUser.id}" var="currentUserId"/>
<c:set value="${currentUser.name}" var="currentUserName"/>
<c:set value="${currentUser.departmentId}" var="currentUserDepartmentId"/>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/projectandtask/js/project.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
var genericControllerURL = "${genericController}?ViewPage=";
var taskManageUrl = '${taskManageURL}';

<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
v3x.loadLanguage("/apps_res/project/i18n");
v3x.loadLanguage("/apps_res/doc/i18n");
// v3x.loadLanguage("/apps_res/taskmanage/js/i18n");
var projectUrl ='${basicURL}';
var colURL = '${colURL}';
var jsColURL = '${colURL}';
var templateURL = '${temURL}';
<html:link renderURL="/project.do?method=saveOrderProject" var="projectOrderURL" />
var projectOrderURL="${projectOrderURL}";
<html:link renderURL="/project.do?method=addProjectPhase" var="addPhaseURL" />
var addPhaseURL = "${addPhaseURL}";
//-->

var flagV3x = "objectFlag";

function addCal(flag,calEventId,canUpdate){
        var theURL = null;
        if(flag == "1"){
            theURL = "<html:link renderURL='/calendar/calEvent.do' />?method=editCalEvent&flagV3x=objectFlag&appID=14&id=" + calEventId;
        }else if(flag == "0"){
        	var projectIdvalue1 = document.getElementById("hiddenProjectId").value;
        	var  s = projectIdvalue1;
            theURL ="${calEventURL}?method=createCalEvent&shareType=3&appID=14&projectID=${v3x:toHTML(projectId)}&from_projectId=" + s;
        }
        
        if(flag == "1"){
            var calDialogTest = v3x.openDialog({
            id: "calDialog",
            title: v3x.getMessage("MainLang.view_cal_label"),
            url:theURL,
            width:600,
            height:550,
            targetWindow : getA8Top(),
            buttons:[{
              id:'sure',
              emphasize: true,
              text: v3x.getMessage("MainLang.okbtn"),
              handler:function(){
                var rv = calDialogTest.getReturnValue();
                if(rv) {
                   setTimeout(function(){calDialogTest.close();refresh();},500);
                }  
              }
            },{
              id:'update',
              text: v3x.getMessage("MainLang.update"),
              handler:function(){
                var rv = calDialogTest.getReturnValue();
              }
            },{
              id:'Cancel',
              text: v3x.getMessage("MainLang.close"),
              handler: function(){
                     calDialogTest.close();
                 }
            }]
        });
            if(canUpdate!="true"){
            	parent.parent.document.getElementById("update").style.display = "none";
            }
            parent.parent.document.getElementById("sure").style.display = "none";
        }else if(flag == "0"){
        
        var calDialog = v3x.openDialog({
            id: "calDialog",
            title: v3x.getMessage("MainLang.new_cal_label"),
            url:theURL,
            width:580,
            height:550,
            targetWindow : getA8Top(),
            buttons:[{
              id:'OK',
              text: v3x.getMessage("MainLang.okbtn"),
              emphasize: true,
              handler:function(){
                var rv = calDialog.getReturnValue();
                if(rv) {
                	setTimeout(function(){calDialog.close();refresh();},500);
                }  
              }
            },{
              id:'Cancel',
              text: v3x.getMessage("MainLang.cancelbtn"),
              handler: function(){
                     calDialog.close();
                 }
            }]
        });
        }
}

function refresh(){
    window.location.reload();
}



</script>