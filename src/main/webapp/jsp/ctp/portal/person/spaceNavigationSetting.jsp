<%--
 $Author: leikj $
 $Rev: 4195 $
 $Date:: 2012-09-19 18:18:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>空间排序</title>
<script type="text/javascript" src="${path}/decorations/js/shortcut.js"></script>
<script type="text/javascript" src="${path}/decorations/js/spaceNavigation.js"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=spaceManager"></script>
<script>
  $(document).ready(function() {
	  var w = ($("#selectTable").width() - 100) / 2;
	  $("#spaceSourceSelect").width(w);
	  $("#systemSourceSelect").width(w);
	  $("#projectSourceSelect").width(w);
	  $("#spaceTargetSelect").width(w);
	  $("#originalSpaceTargetSelect").append($("#spaceTargetSelect").find("option").clone());
	  
	  //调整备选框高度
	  var spaceSelectSizes = parseInt($("#spaceSourceSelect").attr("size"));
	  var systemSelectSizes = ${v3x:getSysFlagByName('linkSystem_display') == 'true' ? 0 : 7};
	  var projectSelectSizes = ${v3x:getSysFlagByName('project_notShow') == 'false' ? 0 : 7};
	  $("#spaceSourceSelect").attr("size", (spaceSelectSizes + systemSelectSizes + projectSelectSizes));
  });
  
  <%-- 判断是否调整过导航顺序 --%>
  function isReSort(){
	  var options = $("#spaceTargetSelect").find("option");
	  var originalOptions = $("#originalSpaceTargetSelect").find("option");
	  if(options.length != originalOptions.length){
		  return true;
	  }
	  for(var i = 0; i < options.length; i++){
		  var option = options[i];
		  var originalOption = originalOptions[i];
		  if($(option).val() != $(originalOption).val()){
			  return true;
		  }
	  }
	  return false;
  }
  
  function save(){
	if(isReSort()){
	  $("#isReSort").val("1");
	} else {
	  getCtpTop().onbeforunloadFlag = false;
      getCtpTop().isOpenCloseWindow = false;
      getCtpTop().isDirectClose = false;
      getCtpTop().location.href = "${path}/main.do?method=changeLoginAccount&login.accountId=${currentAccountId}";
	  return;
	}
    showMask();
    var spaceSource = new Array();
    $.each($("#spaceSourceSelect").find("option"),function(i,obj){
        spaceSource.push(obj.value);
    });
    $("#spaceSourceSelectInput").val($.toJSON(spaceSource));
    
    var systemSource = new Array();
    $.each($("#systemSourceSelect").find("option"),function(i,obj){
      systemSource.push(obj.value);
    });
    $("#systemSourceSelectInput").val($.toJSON(systemSource));
    
    var projectSource = new Array();
    $.each($("#projectSourceSelect").find("option"),function(i,obj){
      projectSource.push(obj.value);
    });
    $("#projectSourceSelectInput").val($.toJSON(projectSource));
    
    var spaceTarget = new Array();
    $.each($("#spaceTargetSelect").find("option"),function(i,obj){
      spaceTarget.push(obj.value);
    });
    $("#spaceTargetSelectInput").val($.toJSON(spaceTarget));
    new spaceManager().saveSpaceSort($("#selectTable").formobj(),{
      success : function(){
        $.messageBox({
          'title': "${ctp:i18n('common.prompt')}",
          'type': 0,
          'msg': "<span class='msgbox_img_0 left'></span><span class='margin_l_5 padding_5'>${ctp:i18n('common.successfully.saved.label')}</span>",
           ok_fn: function() {
             //getCtpTop().refreshNavigation();
             getCtpTop().onbeforunloadFlag = false;
             getCtpTop().isOpenCloseWindow = false;
             getCtpTop().isDirectClose = false;
             getCtpTop().location.href = "${path}/main.do?method=changeLoginAccount&login.accountId=${currentAccountId}";
          }
        });
        hideMask();
      }
    });
  }
  function cancel(){
    window.location.reload();
  }
</script>
</head>
<body class="h100b over_auto align_center font_size12">
    <table id="selectTable" width="60%" height="100%" align="center" class="margin_t_10">
        <input type="hidden" id="spaceSourceSelectInput" />
        <input type="hidden" id="systemSourceSelectInput" />
        <input type="hidden" id="projectSourceSelectInput" />
        <input type="hidden" id="spaceTargetSelectInput" />
        <input type="hidden" id="isReSort" value="0" />
        <tr>
            <td valign="top" height="100%">
            <p align="center" class="margin_b_5">${ctp:i18n('space.standby.label')}</p>
            <select id="spaceSourceSelect" size="10" multiple="" class="w100b" ondblclick="selectThis(this)">
                <c:forEach items="${unSelectedSpaces}" var="space">
                    <option fflag='spaceSource'  value="${space[6]},${space[1]==null ? space[0] : space[1]}" title="${v3x:toHTML(space[3])}">${v3x:toHTML(space[3])}</option>
                </c:forEach>
            </select>
            <c:if test="${v3x:getSysFlagByName('linkSystem_display') == 'true'}">
	            <p align="center" class="margin_b_5 margin_t_5">${ctp:i18n('relatedsystem.standby.label')}</p>
	            <select id="systemSourceSelect" size="5" multiple="" class="w100b" ondblclick="selectThis(this)">
	            	<c:forEach items="${linkSpaces}" var="lsp">
						<option fflag='systemSource' value="11,${lsp[0]}" title="${v3x:toHTML(lsp[3])}">${v3x:toHTML(lsp[3])}</option>
					</c:forEach>
	            </select>
            </c:if>
            <c:if test="${v3x:getSysFlagByName('project_notShow') == 'false'}">
            <p align="center" class="margin_b_5 margin_t_5">${ctp:i18n('relatedproject.standby.label')}</p>
            <select id="projectSourceSelect" size="5" multiple="" class="w100b" ondblclick="selectThis(this)">
           		<c:forEach items="${relatedProjects}" var="rp">
					<option fflag='projectSource' value="12,${rp[0]}" title="${v3x:toHTML(rp[3])}">${v3x:toHTML(rp[3])}</option>
				</c:forEach>
            </select>
            </c:if>
            </td>
            <td width="50" valign="middle">
                <span class="select_selected" onClick="selectThis()"> </span><br><br>
                <span class="select_unselect" onClick="removeThis()"> </span>
            </td>
            <td valign="top" height="100%">
                <p align="center" class="margin_b_5">${ctp:i18n('channel.selected.label')}</p>
                <select id="spaceTargetSelect" size="23" multiple="" class="w100b" ondblclick="removeThis()">
                    <c:forEach items="${selectedSpaces}" var="space" varStatus="status">
                    <option 
                      	<c:choose>
                           <c:when test="${space[6]==11}">fflag='systemSource'</c:when>
                           <c:when test="${space[6]==12}">fflag='projectSource'</c:when>
                           <c:otherwise>fflag='spaceSource'</c:otherwise>
                       	</c:choose>
                       	value="${space[6]},${space[1]==null ? space[0] : space[1] }" title="${v3x:toHTML(space[3])}" ${(status.first && !canSetDefaultSpace)?"disabled":""}>${v3x:toHTML(space[3])}</option>
                    </c:forEach>
                </select>
                <select id="originalSpaceTargetSelect" style="display: none"></select>
            </td>
            <td width="50" valign="middle">
                <span id="sort_up" class="sort_up" onclick="moveUp('space')"> </span><br><br>
                <span id="sort_down" class="sort_down" onclick="moveDown('space')"> </span>
            </td>
        </tr>
    </table>
</body>
</html>