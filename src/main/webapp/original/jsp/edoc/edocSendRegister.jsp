<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="edocHeader.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.isearch.resources.i18n.ISearchResources" var="isearchI18N"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">


function edocSearch() {
  //将小查询清空
  $("#condition").val("");
  var $p = $("#condition").parent().parent();
  $("div.hidden",$p).css("display","none");
  
  $("#canExcel").val("1");
	var begin,end;
	<c:choose>
	<c:when test="${param.edocType == 0}">
		begin = document.getElementById("signingDateA").value;
		end = document.getElementById("signingDateB").value;
		if(begin=='' && end=='' && document.getElementById("sendQueryTimeType").value!=0){
		   alert(_("edocLang.edoc_please_select_time"));
		   return;
		}
	</c:when>
	<c:when test="${param.edocType == 1}">
		begin = document.getElementById("registerDateB").value;
		end = document.getElementById("registerDateE").value;
	</c:when>
	</c:choose>
	if(new Date(begin.replace(/-/g,"/")) > new Date(end.replace(/-/g,"/"))){
		alert("<fmt:message key='edoc.timevalidate'/>");
		return;
	}
	document.getElementById("outExecl").style.borderBottom="0px";
	var customSearch = document.getElementById("customSearch");
	var colId = "";
	if(customSearch.checked){
		colId = document.getElementById("displayCol").value;
	}else{
	    colId = "";
	    document.getElementById("displayCol").value="";
	    document.getElementById("displayColName").value="<<fmt:message key="edoc.custom.type.msg" />>";
	}
	
	var edocType = '${param.edocType}';
	var url = edocType == 0 ? "${edoc}?method=listSendEdocSearchReultByDocManager&displayCol="+colId :
							  "${edoc}?method=listRecEdocSearchReultByDocManager&displayCol="+colId;
	myform.action=url;
	myform.target="dataIFrame";
	myform.submit();
}

function edocSearch2() {
  //OA-33942 发文登记簿，查询后，单击导出，提示，需要先查询
  $("#canExcel").val("1");
    var edocType = '${param.edocType}';
	var begin,end;
	var sendQueryTimeType="";
	
	<c:choose>
	<c:when test="${param.edocType == 0}">
		begin = document.getElementById("createDateDiv1").value;
		end = document.getElementById("createDateDiv2").value;
		sendQueryTimeType=document.getElementById("sendQueryTimeType").value;
		document.getElementById("signingDateA_copy").value = document.getElementById("signingDateA").value;
		document.getElementById("signingDateB_copy").value = document.getElementById("signingDateB").value
	</c:when>
	<c:when test="${param.edocType == 1}">
	if(document.getElementById("condition").value=='registerDate'){
		begin = document.getElementById("registerDateDiv1").value;
		end = document.getElementById("registerDateDiv2").value;
	}else{
		begin = document.getElementById("recieveDateDiv1").value;
		end = document.getElementById("recieveDateDiv2").value;
	}
	document.getElementById("registerDateB_copy").value = document.getElementById("registerDateB").value
	document.getElementById("registerDateE_copy").value = document.getElementById("registerDateE").value
	</c:when>
	</c:choose>
	var customSearch = document.getElementById("customSearch");
	var colId = "";
	if(customSearch.checked){
		colId = document.getElementById("displayCol").value;
	}else{
	    colId = "";
	    document.getElementById("displayCol").value="";
	    document.getElementById("displayColName").value="<<fmt:message key="edoc.custom.type.msg" />>";
	}
	var url = edocType == 0 ? "${edoc}?method=listSendEdocSearchReultByDocManager&displayCol="+colId+"&sendQueryTimeType="+sendQueryTimeType :
						   "${edoc}?method=listRecEdocSearchReultByDocManager&displayCol="+colId;
	 searchForm.action=url;
	 searchForm.target="dataIFrame";
	 
	 //OA-13681 发文登记簿中先按时间查询，在查询的结果中进行小查询，先在公文标题，后公文文号，再次切换到公文标题，还能保持上次的查询条件（输入的条件）
	 var theForm = document.getElementsByName("searchForm")[0];
		 if(theForm.condition.value == "createDate"||theForm.condition.value == "registerDate"||theForm.condition.value == "recieveDate"){
			if(new Date(begin.replace(/-/g,"/")) > new Date(end.replace(/-/g,"/"))){
				alert("<fmt:message key='edoc.timevalidate'/>");
				return;
			}
		}
	 var options = theForm.condition.options;
      for (var i = 0; i < options.length; i++) {
        if (theForm.condition.value == options[i].value){
          continue;
        }

        var d = document.getElementById(options[i].value + "Div");
        
          if (d) {
             var ip = $("input",d);
             for(var j=0;j<ip.length;j++){
               ip[j].value="";
             }
          }
      }
      //OA-13681 发文登记簿中先按时间查询，在查询的结果中进行小查询，先在公文标题，后公文文号，再次切换到公文标题，还能保持上次的查询条件（输入的条件）-end
	 
	 searchForm.submit(); 
	 //doSearch();
}

function exportExcel() {
    //OA-33942 发文登记簿，查询后，单击导出，提示，需要先查询
	if($("#canExcel").val() == "0"){
		alert("<fmt:message key='edoc.query.first'/>!");
		return;
	}
	//var colId = dataIFrame.window.document.getElementById("colId").value;
	//var colId = window.frames["dataIFrame"].document.getElementById("colId").value;
	var colId = document.getElementById("displayCol").value;
	var url= "${edoc}?method=exportQueryToExcel&edocType=${param.edocType}&colId="+colId;
	
	//OA-25190  在发文登记簿中查询，结果是空，导出的excel中却有数据  
	var condition = $("#condition").val();
	if(condition !=""){
        var textfield;
        var textfield1;
        if("createDate" == condition){
          textfield = $("#searchForm #"+condition+"Div #createDateDiv1").val();
          textfield1 = $("#searchForm #"+condition+"Div #createDateDiv2").val();
          if(textfield){
            url += "&"+condition+"Div1="+textfield;
          }
          if(textfield1){
            url += "&"+condition+"Div2="+textfield1;
          }
        }else if("recieveDate" == condition){
          textfield = $("#searchForm #"+condition+"Div #recieveDateDiv1").val();
          textfield1 = $("#searchForm #"+condition+"Div #recieveDateDiv2").val();
          if(textfield){
            url += "&"+condition+"Div1="+textfield;
          }
          if(textfield1){
            url += "&"+condition+"Div2="+textfield1;
          }
        }else if("registerDate" == condition){
          textfield = $("#searchForm #"+condition+"Div #registerDateDiv1").val();
          textfield1 = $("#searchForm #"+condition+"Div #registerDateDiv2").val();
          if(textfield){
            url += "&"+condition+"Div1="+textfield;
          }
          if(textfield1){
            url += "&"+condition+"Div2="+textfield1;
          }
        }else if("secretLevel" == condition || "urgentLevel" == condition ){
          textfield = $("#searchForm #"+condition+"Div select").val();
          if(textfield){
            url += "&"+condition+"Div="+textfield;
          }
        }
        else{
          textfield = $("#searchForm #"+condition+"Div #textfield").val();
          if(textfield){
            url += "&"+condition+"Div="+textfield;
          }
        }
        url += "&condition="+condition;
	}
	myform.action = url;
	myform.target = "temp_iframe";
    myform.submit();
}

function viewDocSetting(obj){
	var t = document.getElementById("customQuery");
	if(obj.checked){
		t.style.display = "";//如果设为block,会换行显示
	}else{
		t.style.display = "none";
	}
}

function openDocSetting(){
	var winWidth = 600;
	var winHeight =440;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";

	var displayCol = document.getElementById("displayCol").value;
	var url = "edocController.do?method=openEdocSetting&edocType=${param.edocType}&displayCol="+displayCol+"&date="+new Date().getTime();
	
	getA8Top().win123 = getA8Top().$.dialog({
		title:'<fmt:message key='edoc.custom.classification'/>',
		transParams:{'parentWin':window},
	    url   : url,
	    width : winWidth,
	    height  : winHeight,
	    resizable : "no"
	  });
}
	
function tuisong(){
	var type;
	var starttime = "";
	var endtime = "";
	//小查询条件和值
	var conditionV="";
	var textfield_value=""; //值
	var textfield1_value="";
	var textfield_Name=""; //参数名
	var textfield1_Name="";
	var sendQueryTimeType="";
	
	if('${param.edocType}'==0){
	  type = 1;
	  starttime = document.getElementById("signingDateA").value;
	  endtime = document.getElementById("signingDateB").value; 
	  sendQueryTimeType=document.getElementById("sendQueryTimeType").value;
	  
	  conditionV=document.getElementById("condition").value;
	  if(conditionV && conditionV!=""){
		  if(conditionV=="createDate"){
		    textfield_Name=conditionV+"Div1";
			textfield_value = document.getElementsByName(textfield_Name)[0].value;
			textfield1_Name = conditionV+"Div2";
		    textfield1_value = document.getElementsByName(textfield1_Name)[0].value;
		  }else if("secretLevel" == conditionV || "urgentLevel" == conditionV ){
		  	textfield_Name=conditionV+"Div";
			textfield_value = $("#searchForm #"+conditionV+"Div select").val();
		  }else{
			textfield_Name=conditionV+"Div";
			textfield_value = $("#searchForm #"+conditionV+"Div #textfield").val();
		  }
	  }



	}else{
	  type = 2;
	  starttime = document.getElementById("registerDateB").value;
	  endtime = document.getElementById("registerDateE").value;
	  
	  conditionV=document.getElementById("condition").value;
	  if(conditionV!=""){
	  	if(conditionV=="recieveDate" || conditionV=="registerDate"){
	      textfield_Name=conditionV+"Div1";
		  textfield_value = document.getElementsByName(textfield_Name)[0].value;
		  textfield1_Name = conditionV+"Div2";
	      textfield1_value = document.getElementsByName(textfield1_Name)[0].value;
	    }else{
		  textfield_Name=conditionV+"Div";
		  textfield_value = $("#searchForm #"+conditionV+"Div #textfield").val();
	    }
	  }


	}
	
	if(new Date(starttime.replace(/-/g,"/")) > new Date(endtime.replace(/-/g,"/"))){
        alert("<fmt:message key='edoc.timevalidate'/>");
        return;
    }
	var queryCol = document.getElementById("displayCol").value;
	var dataStr=(sendQueryTimeType==""?"":"&sendQueryTimeType="+sendQueryTimeType)+"&type="+type+"&queryCol="+queryCol+"&starttime="+starttime+"&endtime="+endtime+"&condition="+conditionV+(textfield_Name==""?"":"&"+textfield_Name+"="+textfield_value)+(textfield1_Name==""?"":"&"+textfield1_Name+"="+textfield1_value);
	$.ajax({                                                 
		type: "POST",                                     
		url: "edocController.do?method=addEdocRegisterCondition",
		data: dataStr,    
		success: function(msg){                 
			alert("<fmt:message key='edoc.push.success'/>");                  
		}
	});
}

function edocStatPage() {		
	window.location.href = "${edocStat}?method=statCondition";		
}

function sendChangeTimeSelect(){
  var selectTimeValue=document.getElementById("sendQueryTimeType").value;
  if(selectTimeValue==0){
     document.getElementById("signingDateA").disabled="true";
     document.getElementById("signingDateB").disabled="true";
  }else if(selectTimeValue==1 || selectTimeValue==2 || selectTimeValue==3 ){
     document.getElementById("signingDateA").disabled="";
     document.getElementById("signingDateB").disabled="";
  }
  
  document.getElementById("signingDateA").value="";
  document.getElementById("signingDateB").value="";

}
	
window.onload = function() {
	initIe10AutoScroll('registerResult', 160);
	document.getElementById('registerResult').style.overflow = 'hidden';
}

</script>

<c:set value="${pageContext.request.contextPath}" var="path" />
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />

</head>
<body class="h100b page_color">
<input type="hidden" id="canExcel" value="0"/>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="popupTitleRight">
				<tr>
					<td valign="bottom" height="26" class="tab-tag border_b">
						<div class="div-float">
							<div class="tab-separator"></div>
							<div class="tab-tag-left"></div>
							<div class="tab-tag-middel"><a href="${edocStat}?method=mainEntry" class="non-a"><fmt:message key="edoc.stat.query.label.title"/></a></div>
							<div class="tab-tag-right"></div>
							
							<div class="tab-separator"></div>
							
							<div class="tab-tag-left"></div>
							<div class="tab-tag-middel"><a href="javascript:edocStatPage();" class="non-a"><fmt:message key="edoc.stat.label.title"/></a></div>
							<div class="tab-tag-right"></div>
							<div class="div-float-right"></div>
							
							<div class="tab-separator"></div>
							
							<%-- 发文登记薄--%>
							<c:set var="isCurrentFrom" value="${param.listType=='sendRegister' }" />

								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
							    <div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='edocController.do?method=sendRegister&edocType=0&listType=sendRegister'">	
									<fmt:message key='edoc.send.register' />
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
                            
                            
                            <%-- 收文登记薄 --%>
						    <c:set var="isCurrentFrom_2" value="${param.listType=='recRegister' }" />

								<div class="${isCurrentFrom_2 ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
							    <div class="${isCurrentFrom_2 ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='edocController.do?method=recRegister&edocType=1&listType=recRegister'">	
							     	<fmt:message key='edoc.rec.register' />
								</div>
								<div class="${isCurrentFrom_2 ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>

						</div>
					</td>
				</tr>
<c:if test="${param.edocType==0}">
<c:set var="methodForm" value="listSendEdocSearchReultByDocManager"></c:set>
</c:if>
<c:if test="${param.edocType==1}">
<c:set var="methodForm" value="listRecEdocSearchReultByDocManager"></c:set>
</c:if>

<tr height="100px">

<td  style="pading-left:12px;pading-right:12px;" class="border_b">
<!-- 查询条件设置 -->
<input type="hidden" name="displayCol" id="displayCol">
<form id="myform" name="myform" method="post">
	<div>
		<TABLE cellspacing="0" border="0" style="margin: auto; width:650px;" align="center" class="">
				<TR>
					<TD height="30" align="right" style="width:250px;">
					<c:choose>
						<c:when test="${param.edocType == 0}">
							<fmt:message key='edoc.search.date'/>:
							<select name="sendQueryTimeType" id="sendQueryTimeType" onchange="sendChangeTimeSelect()">
							<option value="0" selected="true">全部</option>
							<option value="1" ><fmt:message key='edoc.edoctitle.createDate.label'/></option>
							<option value="2"><fmt:message key='edoc.element.sendingdate'/></option>
							<option value="3"><fmt:message key='exchange.edoc.stepbackdate'/></option>
							</select>&nbsp;
						</c:when>
						<c:when test="${ctp:getSystemProperty('edoc.isG6')=='true' && param.edocType == 1}">
						    <fmt:message key='edoc.edoctitle.disDate.label'/>:
						</c:when>
						<c:when test="${param.edocType == 1}">
						    <fmt:message key='edoc.edoctitle.regDate.label'/>:	
						</c:when>
					</c:choose>
					</td>
					<td height="30">
						<c:choose>
						<c:when test="${param.edocType == 0}">
							<input type="text" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="signingDateA" id="signingDateA" class="comp input_date" style="width:135px;" disabled="true">
							-
							<input type="text" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="signingDateB" id="signingDateB" class="comp input_date" style="width:135px;" disabled="true">
						</c:when>
						<c:when test="${param.edocType == 1}">
							<input type="text" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="registerDateB" id="registerDateB" class="comp input_date" style="width:135px;">
							-
							<input type="text" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="registerDateE" id="registerDateE" class="comp input_date" style="width:135px;">
						</c:when>
						</c:choose>
					</TD>
				</TR>
				<tr>
					<td height="30" align="right">
						<input type="checkbox" onClick="viewDocSetting(this);" id="customSearch"/><label for="customSearch">&nbsp;<fmt:message key='edoc.custom.query'/></label>:
					</td>
					<td height="30" align="left">
						<span id="customQuery" style="display:none;">
							<input id="displayColName" size="35" type="text" onClick="openDocSetting();" value="&lt;<fmt:message key="edoc.custom.type.msg" />&gt;" style="border: 1px solid #CCC;cursor:pointer;width:280px;height:22px;" />
						</span>
					</td>
				</tr>
				<tr>
					<TD height="30" align="center" colspan="2">
						<input type="button" class="button-default_emphasize" name="btn" onClick="edocSearch();" value="<fmt:message key='common.search.label'/>">
						&nbsp;&nbsp;
						<input type="button" class="button-default-2" name="btn" onClick="tuisong();" value="<fmt:message key='common.search.PushHome.label'/>">
					</TD>
				</tr>
		</TABLE>

	</div>  	
</form>
<!-- 查询条件设置结束 -->

</td>

</tr>
<tr>

<td id="outExecl" height="20" style="padding:0 5px;" colspan="3" class="border_b">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td style="height:26px;" style="padding-top:2px;">
				&nbsp;&nbsp;<fmt:message key="isearch.jsp.list.result" bundle="${isearchI18N}"/>:
				<span class="ico16 office42_16"></span>
				<a onclick="javascript:exportExcel();">
					<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />
				</a>
			</td>
			<td style="height:26px;">
				<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false">
					<span style="display:none">
	                    <c:choose>
	                        <c:when test="${param.edocType == 0}">
	                            <input type="hidden" name="signingDateA" id="signingDateA_copy">
	                            -
	                            <input type="hidden" name="signingDateB" id="signingDateB_copy">
	                        </c:when>
	                        <c:when test="${param.edocType == 1}">
	                            <input type="hidden" name="registerDateB" id="registerDateB_copy">
	                            -
	                            <input type="hidden" name="registerDateE" id="registerDateE_copy">
	                        </c:when>
	                    </c:choose>
                    </span>
                
					<input type="hidden" value="<c:out value='${methodForm}' />" name="method">
					<input type="hidden" value="<c:out value='${param.edocType}' />" name="edocType">			
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px;height:20px;padding-buttom:5px;">
								<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
								<option value="subject"><fmt:message key="edoc.element.subject" /></option>
								
								<c:if test="${param.edocType==0}">
                                    <option value="docMark"><fmt:message key="edoc.element.wordno.label"/></option>  <%-- 公文文号--%>
                                    <option value="serialNo"><fmt:message key="edoc.docmark.inner.title" /></option> <!-- 内部文号 -->
									<option value="sendUnit"><fmt:message key="edoc.element.sendunit"/></option><!-- 发文单位 -->
                                    <option value="createPerson"><fmt:message key="edoc.edoctitle.createPerson.label"/></option><!-- 发起人 -->
									<option value="createDate"><fmt:message key="edoc.edoctitle.createDate.label"/></option><!-- 拟文日期 -->
									<option value="sendDepartment"><fmt:message key="edoc.element.senddepartment"/></option><!-- 发文部门 -->
									<option value="secretLevel"><fmt:message key="edoc.element.secretlevel.simple"/></option><!-- 密级 -->
									<option value="urgentLevel"><fmt:message key="edoc.element.urgentlevel"/></option><!-- 紧急程度 -->
								</c:if>	
								<c:if test="${param.edocType==1}">
                                    <option value="docMark"><fmt:message key="edoc.element.docmark"/></option>  <%-- 收文编号--%>
                                    <option value="serialNo"><fmt:message key="edoc.element.receive.serial_no" /></option> <!-- 来文字号 -->
									<option value="sendUnit"><fmt:message key="edoc.element.sendunit"/></option><!-- 发文单位 -->
                                    <option value="recieveDate"><fmt:message key="edoc.element.receive.date"/></option><%--签收时间 --%>>
									<option value="registerDate"><fmt:message key="edoc.element.register.date"/></option><%--登记时间 --%>>
									<option value="registerUserName"><fmt:message key="edoc.edoctitle.regPerson.label"/></option><%--登记人 --%>>
								</c:if>
							</select>
						</div>
						<div id="subjectDiv" class="div-float hidden"><input type="text" id="textfield" name="subjectDiv" class="textfield"></div>
						<div id="docMarkDiv" class="div-float hidden"><input type="text" id="textfield" name="docMarkDiv" class="textfield"></div>
						<div id="serialNoDiv" class="div-float hidden"><input type="text" id="textfield" name="serialNoDiv" class="textfield"></div>
						<div id="sendUnitDiv" class="div-float hidden"><input type="text" id="textfield" name="sendUnitDiv" class="textfield"></div>
						<c:if test="${param.edocType==0}">
							<div id="createPersonDiv" class="div-float hidden"><input type="text" id="textfield" name="createPersonDiv" class="textfield"></div>
							<div id="createDateDiv" class="div-float hidden">
								<input type="text" name="createDateDiv1" id="createDateDiv1" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,120);" readonly>
								<input type="text" name="createDateDiv2" id="createDateDiv2" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,675,120);" readonly>
							</div>
							<div id="sendDepartmentDiv" class="div-float hidden"><input type="text" name="sendDepartmentDiv" class="textfield"></div>
							<div id="secretLevelDiv" class="div-float hidden">
								<select name="secretLevelDiv" class="condition" style="width:90px">
									<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
									<c:forEach var="secret" items="${colMetadata['edoc_secret_level'].items}"> 
										<c:if test="${secret.outputSwitch == 1}">
										<option value="${secret.value}">
											<c:choose>
											<c:when test="${secret.i18n == 1 }">
											<fmt:message key="${secret.label}"/>
											</c:when>
											<c:otherwise>
											${secret.label}
											</c:otherwise>
											</c:choose>
										</option>
										</c:if>
									</c:forEach>
								</select>			
							</div>
							<div id="urgentLevelDiv" class="div-float hidden">
								<select name="urgentLevelDiv" class="condition" style="width:90px">
									<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
									<c:forEach var="urgent" items="${colMetadata['edoc_urgent_level'].items}"> 
										<c:if test="${urgent.outputSwitch == 1}">
										<option value="${urgent.value}">
										<c:choose>
											<c:when test="${urgent.i18n == 1 }">
											<fmt:message key="${urgent.label}"/>
											</c:when>
											<c:otherwise>
											${urgent.label}
											</c:otherwise>
											</c:choose>
										</option>
										</c:if>	
									</c:forEach>
									
								</select>
							</div>
						</c:if>
						<c:if test="${param.edocType==1}">
							<div id="recieveDateDiv" class="div-float hidden">
								<input type="text" name="recieveDateDiv1" id="recieveDateDiv1" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,120);" readonly>
								-
								<input type="text" name="recieveDateDiv2" id="recieveDateDiv2" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,675,120);" readonly>
							</div>
							<div id="registerDateDiv" class="div-float hidden">
								<input type="text" name="registerDateDiv1" id="registerDateDiv1" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,120);" readonly>
								-
								<input type="text" name="registerDateDiv2" id="registerDateDiv2" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,675,120);" readonly>
							</div>
							<div id="registerUserNameDiv" class="div-float hidden"><input type="text" id="textfield" name="registerUserNameDiv" class="textfield"></div>
						</c:if>
						<div onclick="javascript:edocSearch2();" class="div-float condition-search-button"></div>
					</div>
				</form>
			</td>
		</tr>
	</table>
					
	</td>
</tr>

<tr>
	<td align="center" valign="top" style="padding:0 0px;" colspan="3">
		<div id="registerResult" style="overflow:hidden;">
			<IFRAME height="100%" name="dataIFrame" id="dataIFrame" class="border_b" width="100%" frameborder="0"></IFRAME>
		</div>
	</td>
</tr>

</table>

<iframe name="temp_iframe" id="temp_iframe" style="width:0%;height:0%;display:none">&nbsp;</iframe>

<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
//showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.done' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2014"));
showCondition("${param.conditioncondition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
/* initIpadScroll("scrollListDiv",550,870); */
</script>
</body>
</html>