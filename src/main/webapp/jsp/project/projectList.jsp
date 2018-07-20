<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="projectHeader.jsp"%>
<%response.setHeader("cache-control","public"); %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="<c:url value='/apps_res/project/js/projectList.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/project/js/commonFuncs.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--
    var sessionScopeParam = "${currentUserId}";
    var basicURLParam = "${basicURL}";
    onlyLoginAccount_projectManager = true;
    //var htmlStr = "<span class='margin_r_10'>当前位置123:</span><a href='javascript:showMenu(\"/seeyon/portal/portalController.do?method=personalInfo\")'>个人事务</a><span class='common_crumbs_next margin_lr_5'>-</span><a href='javascript:void(0)'>关联项目设置</a>"
    //showCtpLocation("F02_projectConfigPage");
    //隐藏外部框架的按钮
    //var parentDocument = window.parent.parent.document; 
    //$("#submitbtn",parentDocument).hide(); 
    //$("#toDefaultBtn",parentDocument).hide(); 
    //$("#cancelbtn",parentDocument).hide(); 
    //if($(".stadic_layout_footer",parentDocument).css("display")!="none"){
    //  $("#personalSetContent",parentDocument).height($("#personalSetContent",parentDocument).height()+$(".stadic_layout_footer",parentDocument).height());
    //}
    //$(".stadic_layout_footer",parentDocument).css("display","none");
    
    function mySearch(){
        var theForm = document.getElementsByName("searchForm")[0];
        var condition = $("#condition").val();
        if(condition == "projectDate"){
            var textfield = $("#begintime").val();
            var textfield1 = $("#closetime").val();
            var beginTimeStrs = textfield.split("-");
            var beginTimeDate = new Date();
            beginTimeDate.setFullYear(beginTimeStrs[0],beginTimeStrs[1]-1,beginTimeStrs[2]);
            var endTimeStrs = textfield1.split("-");
            var endTimeDate = new Date();
            endTimeDate.setFullYear(endTimeStrs[0],endTimeStrs[1]-1,endTimeStrs[2]);
            if(endTimeDate<beginTimeDate){
                window.alert(v3x.getMessage("ProjectLang.startdate_cannot_late_than_enddate"));
                $("#closetime").val(textfield);
                return;
            }
        }
        doSearch();
    }
    
    function showA6Location(url,hrefName){
        var top = getA8Top();
        if(top.$){    
              var key = '当前位置：';
              if(top.$){
                key = top.$.i18n('seeyon.top.nowLocation.label');
              }
              var html = '<span class="nowLocation_ico"><img src="' + v3x.baseURL + '/main/skin/frame/harmony/menuIcon/personal.png"></span><span class="nowLocation_content">';
              var items = [];
              items.push("<a>${ctp:i18n('menu.personal.affair')}</a>");
              items.push("<a class=\"hand\" onclick=\"showMenu('" + v3x.baseURL+url + "')\">"+hrefName+"</a>");
              html+= items.join(' &gt; ');
              html+= "</span>";
              //首页显示当前位置
              top.showLocation(html);
        }
      }
    
    window.onload = function() {
        var isA6 = "${isA6}";
        var  resource = "${resource}";
        if(isA6 == "true" || resource == "false") {
            var urlPath = "/project.do?method=myTemplateBorderMain";
            var hrefName = "关联项目配置";
            showA6Location(urlPath,hrefName);
        } else {
            showCtpLocation("F02_projectPersonPage");
        }
        showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "${param.textfield1}");
    }
//-->
</script>
<style>
.webfx-menu-bar-gray{border-top:none;}
</style>
</head>
<body class="">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar-gray border-left border-right">
        <div class="div-float" style="width:300px;margin-top:4px;">
            <script type="text/javascript">
            <!--
                var managerMap = new Properties();
                var stateMap = new Properties();
                var projectNameMap = new Properties();
                var createrMap = new Properties();
                
                var myBar = new WebFXMenuBar("${pageContext.request.contextPath}", "gray");
                
                var isProjectBuilder = "${isProjectBuilder}";
                if(v3x.getBrowserFlag('hideMenu')){
                    <c:if test="${projectAdd == 'yes'}">
                        myBar.add(new WebFXMenuButton("addBtn", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "addProject('${basicURL}?method=projectTransfer&transferId=1')", [1,1], "", null));
                    </c:if>
                    myBar.add(new WebFXMenuButton("edtBtn", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "editProject();", [1,2], "", null));
                    myBar.add(new WebFXMenuButton("delBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "delProject();", [1,3], "", null));
                    myBar.add(new WebFXMenuButton("orderBtn", "<fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}'/>", "projectOrder();", [8,9], "", null));
                }
                
                document.write(myBar);
            //-->
            </script>
         </div>
         <div class="div-float-right condition-search-div" style="margin-top:5px;">
            <form action="" name="searchForm" id="searchForm" method="post" style="margin: 0px" onsubmit="return false" onkeydown="doSearchEnter()">
                <input type="hidden" value="${param.method}" name="method">
                <input type="hidden" value="${param.projectTypeName}" name="projectTypeName">
                <input type="hidden" value="${param.state}" name="state">
                <div class="div-float-right">
                    <div class="div-float">
                        <select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
                            <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
                            <option value="projectName"><fmt:message key="project.body.projectName.label" /></option>
                            <option value="projectNumber"><fmt:message key="project.body.projectNum.label" /></option>
                            <option value="projectManager"><fmt:message key="project.body.responsible.label" /></option>
                            <option value="projectDate"><fmt:message key="project.body.search.projecttime" /></option>
                            <option value="projectState"><fmt:message key="project.body.state.label" /></option>
                            <option value="projectRole"><fmt:message key="project.body.search.myrole" /></option>
                        </select>
                    </div>
                    
                    <div id="projectNameDiv" class="div-float hidden">
                        <input type="text" id="projectName" name="textfield" class="textfield" maxlength="100"/>
                    </div>
                    
                    <div id="projectNumberDiv" class="div-float hidden">
                        <input type="text" id="projectNumber" name="textfield" class="textfield" maxlength="50"/>
                    </div>
                    
                    <div id="projectManagerDiv" class="div-float hidden">
<!--                        <input type="hidden" name="textfield" id="projectManagerId" />-->
                        <input type="text" name="textfield" id="projectManagerName" class="textfield" />
                    </div>
                    
                    <div id="projectDateDiv" class="div-float hidden">
                        <input type="text" name="textfield" id="begintime" class="input-date cursor-hand"  onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
                        -
                        <input type="text" name="textfield1" id="closetime" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
                    </div>
                    
                    <div id="projectStateDiv" class="div-float hidden">
                        <select id="projectState" name="textfield" class="textfield">
                            <option value="0"><fmt:message key="project.body.projectstate.0" /></option>
                            <option value="2"><fmt:message key="project.body.projectstate.2" /></option>
                        </select>   
                    </div>
                    <!-- 本人角色 -->
                    <div id="projectRoleDiv" class="div-float hidden">
                        <select id="projectRole" name="textfield"  class="textfield">
                            <option value="0"><fmt:message key="project.body.responsible.label" /></option>
                            <option value="5"><fmt:message key="project.body.assistant.label" /></option>
                            <option value="2"><fmt:message key="project.body.members.label" /></option>
                            <option value="1"><fmt:message key="project.body.manger.label" /></option>
                            <option value="3"><fmt:message key="project.body.related.label" /></option>
                        </select>
                    </div>
                    <div onclick="javascript:mySearch();" class="div-float condition-search-button"></div>
                </div>
            </form>
        </div>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
        <form name="form" id="form" action="">
            <v3x:table htmlId="projectComposeList" data="${projectComposeList}" var="projectCompose" className="sort ellipsis">
                <c:set var="detail" value="detailProject('${projectCompose.projectSummary.id}')"></c:set>
                <c:set var="onDoubleClick" value="doubleClick('${projectCompose.projectSummary.id}')"></c:set>
                <v3x:column width="5%" align="center" label="<input type='checkbox' title='全选' onclick='selectAll(this, \"id\")'/>">
                    <input type='checkbox' name='id' value="<c:out value="${projectCompose.projectSummary.id}"/>" />
                    <c:set var="projectNameN" value="${v3x:toHTML(projectCompose.projectSummary.projectName)}" />
                    <c:set var="projectCreatorC" value="${v3x:toHTML(projectCompose.projectSummary.projectCreator)}" />
                    <script>
                    <!--
                        var managerList = new ArrayList();
                        <c:forEach items="${projectCompose.principalLists}" var="p">
                            managerList.add('${p.id}');
                        </c:forEach>
                        <c:forEach items="${projectCompose.assistantLists}" var="a">
                            managerList.add('${a.id}');
                        </c:forEach>
                        managerMap.put('${projectCompose.projectSummary.id}', managerList);
                        stateMap.put('${projectCompose.projectSummary.id}','${projectCompose.projectSummary.projectState}');
                        projectNameMap.put('${projectCompose.projectSummary.id}','${projectNameN}');
                        createrMap.put('${projectCompose.projectSummary.id}','${projectCreatorC}');
                    //-->
                    </script>
                </v3x:column>
                <v3x:column type="String" width="30%" label="project.body.projectName.label" value="${projectCompose.projectSummary.projectName}" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort" alt="${projectCompose.projectSummary.projectName}"></v3x:column>
                <v3x:column type="String" width="10%" label="project.body.projectNum.label" value="${projectCompose.projectSummary.projectNumber}" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort" alt="${projectCompose.projectSummary.projectNumber}"></v3x:column>
                <v3x:column type="String" label="project.group.label" value="${projectCompose.projectSummary.projectTypeName}" width="14%" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort" maxLength="15" alt="${projectCompose.projectSummary.projectTypeName}" symbol="..."></v3x:column>
                <v3x:column type="String" label="project.body.responsible.label" value="${v3x:showOrgEntities(projectCompose.principalLists, 'id', 'entityType', pageContext)}" width="10%" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort" maxLength="15" alt="${v3x:showOrgEntities(projectCompose.principalLists, 'id', 'entityType', pageContext)}" symbol="..."></v3x:column>
                <v3x:column type="Date" label="project.body.startdate.label" width="10%" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand  sort">
                    <fmt:formatDate value="${projectCompose.projectSummary.begintime}" type="both" dateStyle="full" pattern="yyyy-MM-dd" />
                </v3x:column>
                <v3x:column type="Date" label="project.body.enddate.label" width="10%" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort">
                    <fmt:formatDate value="${projectCompose.projectSummary.closetime}" type="both" dateStyle="full" pattern="yyyy-MM-dd" />
                </v3x:column>
                <v3x:column type="String" label="project.body.state.label" width="10%" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort">
                    <fmt:message key="project.body.projectstate.${projectCompose.projectSummary.projectState}" />
                </v3x:column>
            </v3x:table>
        </form>
    </div>
  </div>
</div>
<script type="text/javascript">
    showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.project' bundle='${v3xMainI18N}'/>", [2,2], pageQueryMap.get('count'), _("ProjectLang.detail_info_805_2"));   
    initIpadScroll("scrollListDiv",550,870);
</script>
</body>
</html>