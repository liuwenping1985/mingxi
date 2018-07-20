<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.common.metadata.*" %>
<%@ include file="../edocHeader.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/selectbox.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/stat.js" />"></script>
<style>
.tab-body-bg{
	border-left: solid 1px #CDCDCD;
	border-right: solid 1px #CDCDCD;
	border-bottom: solid 1px #CDCDCD;
	padding: 0px 0px 0px 0px;
	vertical-align: top;
}
</style>
<script type="text/javascript">

$(function(){
	var cccObj=$("#content");
	cccObj.height(cccObj.parent().height()+$("#onlyShow").height());
})
<!--	

//showCtpLocation("F07_edocStat", {surffix :"<fmt:message key='edoc.stat.label.title' />"});
	showCtpLocation("F07_edocStat");

//  function manageBigStreamPage() {
//  
////大流水号新建和编辑窗口
//var bigStreamWin = getA8Top().$.dialog({
//
//  title:'<fmt:message key="edoc.docmark.title" />',
//  url: edocMarkURL + "?method=manageBigStreamIframe",
//  targetWindow : getA8Top(),
//  width:"650",
//  height:"300",
//  closeParam:{
//      show:true,
//      autoClose:false,
//      handler:function() {
//          bigStreamWin.close();
//          var a = detailForm.categoryId.options[detailForm.categoryId.options.selectedIndex].value;
//          $(function(){
//              var options = {
//                  url: '${mark}?method=changeBigStreamOptions',
//                  params: {},
//                  success: function(json) {
//                      var options = '<option value="0" selected><fmt:message key="edoc.docmark.selectbigstream"/></option>';                    
//                      for (var i = 0; i < json.length; i++) {                        
//                          options += '<option temp_minNo="' + json[i].optionMinNo + '" temp_maxNo="' + json[i].optionMaxNo + '" temp_curNo="' + json[i].optionCurrentNo + '" temp_yearEnabled="' + json[i].optionYearEnabled + '" temp_readonly="' + json[i].optionReadonly + '" value="' + json[i].optionValue + '">' + json[i].optionName + '</option>';
//                      }
//                      $("select#categoryId").html(options);
//                      $("select#categoryId").handle(returnFromBigStreamListPage(a));
//                  }
//              };
//              getJetspeedJSON(options);            
//          });        
//      }
//  }
//});
//}

	showAccountShortname_grantedDepartId = "auto";
	var showDepartmentMember4Search_grantedDepartId = true;

	function check(){
        var info = document.getElementById("errorInfo");
        if(document.getElementById("organizationId").value==""){
            //info.innerHTML="<font color='red'><fmt:message key="common.pleaseSelect.label"/><fmt:message key="edoc.stat.org"/>!</font>";
            alert("<fmt:message key="common.pleaseSelect.label"/><fmt:message key="edoc.stat.org"/>!");
            return false;
        }
        //时间判断
        var timeTypes = document.getElementsByName("timeType");
        var k = 0;
        for(i=0;i<timeTypes.length;i++){
            if(timeTypes[i].checked){
                k=i;
                break;
            }
        }
        var flag = 0;
        //年
        if(k==0){
            var sy = document.getElementById("yeartype-startyear").value;
            var ey = document.getElementById("yeartype-endyear").value;
            if(sy>ey){
                flag = 1;
            }
        }
        //季度
        else if(k == 1){
            var sy = document.getElementById("seasontype-startyear").value;
            var ey = document.getElementById("seasontype-endyear").value;
            if(sy>ey){
                flag = 1;
            }else if(sy == ey){
                var ss = document.getElementById("seasontype-startseason").value;
                var es = document.getElementById("seasontype-endseason").value;
                if(eval(ss)>eval(es))flag = 1;
            }
        }
        //月
        else if(k == 2){
            var sy = document.getElementById("monthtype-startyear").value;
            var ey = document.getElementById("monthtype-endyear").value;
            if(sy>ey){
                flag = 1;
            }else if(sy == ey){
                var sm = document.getElementById("monthtype-startmonth").value;
                var em = document.getElementById("monthtype-endmonth").value;
                if(eval(sm)>eval(em))flag = 1; 
            }
        }
        //日
        else if(k == 3){
            var sy = document.getElementById("daytype-startday").value;
            var ey = document.getElementById("daytype-endday").value;
 
            if(sy == ""){
            	alert(v3x.getMessage("edocLang.begintime_is_not_allow_null_alert"));
            	return false;
            }
            if(ey == ""){
            	alert(v3x.getMessage("edocLang.endtime_is_not_allow_null_alert"));
            	return false;
            }
            var msg = v3x.getMessage("edocLang.edoc_year_min");//"年份不能小于1990年";
            var startyear = sy.substr(0,4);
            if(parseInt(startyear) < 1990){
                alert(msg);
                return false;
            }
            var endyear = ey.substr(0,4);
            if(parseInt(endyear) < 1990){
                alert(msg);
                return false;
            }
            
            if(new Date(sy.replace(/-/g,"/")) > new Date(ey.replace(/-/g,"/"))){
                flag = 1;
            }
        }
        
    
        if(flag == 1){
            //info.innerHTML="<font color='red'>开始时间不能大于结束时间!</font>";  
            alert(v3x.getMessage("edocLang.edoc_timeValidate"));//alert("开始时间不能大于结束时间!");
            return false;
        }
        if(document.getElementById("sendContentId").value==""&&
            document.getElementById("processSituationId").value==""&&
            document.getElementById("sendNodeCode").value==""&&
            document.getElementById("recNodeCode").value==""){
             //info.innerHTML="<font color='red'><fmt:message key="common.pleaseSelect.label"/><fmt:message key="edoc.stat.content"/>!</font>";  
             alert("<fmt:message key="common.pleaseSelect.label"/><fmt:message key="edoc.stat.content"/>!");
             return false;
         }
        
        return true;
	}
	
	function doStat(){
		if(!check()){
		  return;
		}
		document.getElementById("onlyShow").style.display = "none";
		document.getElementById("content").style.border = "0px";
		
		myform.action = "${edocStat}?method=doStat";
		myform.target = "content";
		myform.submit();
		try{getA8Top().startProc('')}catch(e){};
	}	

	function checkMore(){
		if (myform.morecond.checked == true) {
			document.getElementById("more").style.display = "";
		}
		else {
			document.getElementById("more").style.display = "none";
		}
	}	

	function tuisong(){
	    
	    
          
    	if(!check()){
    	    return;
        }
    	var param = "";
        var form = document.getElementById("myform");
        var elements = form.elements;
        for(var i=0;i<elements.length;i++){
            var element = elements[i];
            var tagName = element.tagName;
            if(tagName == 'INPUT' && (element.type=='hidden' || element.type=='text')){
              param += "&"+element.name + "="+element.value;
            }
            if(tagName == 'INPUT' && element.type == 'radio' && element.checked){
               param += "&"+element.name + "="+element.value;
            }
            if(tagName == 'SELECT'){
              param += "&"+element.name + "="+element.value;
            }
        }
        //OA-28593 公文统计，统计组织选择职务级别，推送到首页后显示为乱码。
        param = encodeURI(param.substring(1));
        
        $.ajax({                                                 
        type: "POST",                                     
        url: "${edocStat}?method=addStatCondition",                                     
        data: param,  
        success: function(msg){                 
          alert("<fmt:message key='edoc.push.success'/>");                  
        }
        });
        
        //$.get('${edocStat}?method=addStatCondition', 
          //{statisticsDimension:1});
        /*$('#myform').ajaxSubmit({
          url : "${edocStat}?method=addStatCondition&"+param,
          type : 'post',
          async : false,
          success : function(data) {
            alert("<fmt:message key='edoc.push.success'/>"); 
          }
        });*/
        
	}
	
	//选人界面只显示登录单位
	var onlyLoginAccount_grantedDepartId = true;
	var onlyLoginAccount_grantedDepartId2 = true;

	//不显示部门岗位
	hiddenPostOfDepartment_grantedDepartId = true;
	hiddenPostOfDepartment_grantedDepartId2 = true;
//-->
</script>
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
</head>
<body scroll="no" onload="onLoadLeft()" onunload="unLoadLeft()">

<v3x:selectPeople id="grantedDepartId" panels="Department,Level,Post" minSize="0" maxSize="1" selectType="Account,Department,Post,Level,Member" jsFunction="setPeopleFields(elements)" originalElements="" showAllAccount="false" />
<v3x:selectPeople id="grantedDepartId2" panels="Department,Level,Post" minSize="0" selectType="Account,Department,Post,Level,Member" jsFunction="setPeopleFields(elements)" originalElements="" showAllAccount= "false"/>
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
<form id="myform" name="myform" method="post">

<!-- 组织类型(本单位 Account|(1),部门 Department|(2),
职务   3  Department_Post|-2676763115351880013_5235530654617519331  ,级别 (Level|)4等)，也是从选择组织控件中传递到该页面 -->
<input type="hidden" size=200 name="organizationId" id="organizationId" />

<!-- 统计内容-->

<!-- 发文情况 id -->
<input type="hidden" name="sendContentId" id="sendContentId"/>
<!-- 流程节点 编码 例如 shenpi -->
<!-- 发文节点-->
<input type="hidden" name="sendNodeCode" id="sendNodeCode"/>
<!-- 收文节点-->
<input type="hidden" name="recNodeCode" id="recNodeCode"/>
<!-- 流程节点id -->
<input type="hidden" name="workflowNodeId" id="workflowNodeId"/>
<!-- 收文办理情况  例如 阅文 -->
<input type="hidden"  name="processSituationId" id="processSituationId"/>

<input type="hidden" name="statcontent"/>
	<tr class = "tab-body-bg">
	  <td >
	  <div class="scrollList" height="100%" style="overflow:hidden">
		<table width="100%" border="0" height="100%" cellpadding="0" cellspacing="0">
		 <tr>
		   <td height="30" style="background:#F3F3F3;padding-buttom:0px;"><!-- 统计维度 -->
		   		<div class="portal-layout-cell" style="margin-bottom:0px">
		   			<!-- 
		   			<div class="portal-layout-cell_head">
		   				<div class="portal-layout-cell_head_l"></div>
		   				<div class="portal-layout-cell_head_r"></div>
		   			</div> -->
		   		<table width="100%" border="0" class="portal-layout-cell-right" cellpadding="0" cellspacing="0">
		   			<tbody>
		   				<!-- 
		   				<tr>
		   					<td class="sectionTitleLine sectionTitleLineBackground">
		   					<div class="sectionSingleTitleLine_single">
		   						<div class="sectionTitleMiddel" style="margin-left:12px;"><fmt:message key="edoc.stat.dimension"/></div>
		   					</div>
		   					</td>
		   				</tr> -->
		   				<tr>
		   					<td class="sectionBody sectionBodyBorder" style="padding-bottom:0px">
		   						<TABLE width="100%" class="border_all" style="margin-top:2px;background:#F3F3F3;">
									<tr height="5"><td></td></tr>
		   							<tr>
										<td style="padding-top:2px;padding-left:5px;" valign="top"></td>
										<td VALIGN="top" align="center" style="margin-top:2px;background:#F3F3F3;">
									
		   						<table width="90%" align="center" border="0" cellpadding="0" cellspacing="0" style="background:#F3F3F3;"> 
				
									<tr>
										<td class="bg-gray" width="20%" nowrap="nowrap"><fmt:message key="edoc.stat.dimension"/>:&nbsp;&nbsp;</td>
										<td class="new-column" nowrap="nowrap" width="30%">
											<label for="timeDimension">
											<input type="radio" id="timeDimension" name="statisticsDimension" value="1" checked onclick="changeDimension(this);"/><fmt:message key='menu.tools.calendar.time' bundle='${v3xMainI18N}' />
											</label>
											<label for="organizationDimension">
											<input type="radio" id="organizationDimension" name="statisticsDimension" value="2" onclick="changeDimension(this);" style="margin-left:2px;" /><fmt:message key='common.personnel.label' bundle='${v3xCommonI18N}' />
											</label>
										</td>
										<td align="right" width="20%">
                                        <c:choose>
                                        <c:when test ="${isG6=='true'}">
                                        	<%--发文种类 --%>
                                            &nbsp;&nbsp;<fmt:message key="edoc.element.sendedoctype"/>:&nbsp;&nbsp;
                                        </c:when>
                                        <c:otherwise>
                                            &nbsp;&nbsp;<fmt:message key="edoc.element.doctype"/>:&nbsp;&nbsp;
                                        </c:otherwise>
                                        </c:choose>
                                        </td>
										<td width="15%">
											<input type="text" style="cursor:hand;" name="sendContent" id="sendContent" style="width:150px;" value="<<fmt:message key="edoc.stat.select.sendcontent"/>>" onclick="openContentWindow(1);" readonly="readonly"/>
										</td>
										<td width="15%">&nbsp;</td>
									</tr>
									
									<tr>
										<td class="bg-gray" nowrap="nowrap"><fmt:message key="edoc.stat.org"/>:&nbsp;&nbsp;</td>
										<td class="new-column" nowrap="nowrap">
										    <!-- 组织显示名称 后台应该显示出来，用于统计表左侧的显示 -->
										    <div  id = "selectPeople0">
										      <input type="text" style="cursor:hand;" name="organizationName" id="selectPeople0_text" style="width:200px;" value="<<fmt:message key="edoc.stat.select.statorg"/>>" onclick ="selectPeopleFun_grantedDepartId()" readonly="readonly"/>
										    </div>
										    <div  style = "display:none" id= "selectPeople2">
										      <input type="text" style="cursor:hand;" name="organizationName" id="selectPeople2_text" style="width:200px;" value="<<fmt:message key="edoc.stat.select.statorg"/>>" onclick ="selectPeopleFun_grantedDepartId2()" readonly="readonly"/>					
											</div>
											<input type="hidden" id="orgtitle" value="<<fmt:message key="edoc.stat.select.statorg"/>>"/>
										</td>
										<td align="right"><fmt:message key="edoc.stat.workflownode"/>:&nbsp;&nbsp;</td>
										<td>
											<input type="text" style="cursor:hand;" name="workflowNode" id="workflowNode" style="width:150px;" onclick="openContentWindow(2);" value="<<fmt:message key="edoc.stat.select.workflownode"/>>" readonly="readonly"/>	
										</td>
										<td>&nbsp;</td>
									</tr>
									
									<tr>
										<td class="bg-gray" width="20%" nowrap="nowrap"><fmt:message key="edoc.stat.time"/>&nbsp;:&nbsp;</td>
										<td class="new-column" nowrap="nowrap">
											<label for="year">
											<input type="radio" id="year" name="timeType" value="1" checked onclick="timeTypeChange(this);" /><fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />&nbsp;&nbsp; 
											</label>
											<label for="quarter">
											<input type="radio" id="quarter" name="timeType" value="2" onclick="timeTypeChange(this);" style="margin-left:10px;" /><fmt:message key='common.quarter.label' bundle='${v3xCommonI18N}' />&nbsp;&nbsp; 
											</label>
											<label for="month">
											<input type="radio" id="month" name="timeType" value="3" onclick="timeTypeChange(this);" style="margin-left:10px;" /><fmt:message key='menu.tools.calendar.yue' bundle='${v3xMainI18N}' />&nbsp;&nbsp; 
											</label>
											<label for="day">
											<input type="radio" id="day" name="timeType" value="4" onclick="timeTypeChange(this);" style="margin-left:10px;" /><fmt:message key='menu.tools.calendar.ri' bundle='${v3xMainI18N}' />&nbsp;&nbsp; 
											</label>
										</td>
										<td align="right"><fmt:message key='common.toolbar.showAffair.label' bundle='${v3xCommonI18N}' />:&nbsp;&nbsp;</td>
										<td>
											<input type="text" style="cursor:hand;" id="processSituation" name="processSituation" onclick="openContentWindow(3);" style="width:150px;" value="<<fmt:message key="edoc.stat.select.handle"/>>" readonly="readonly"/>
										</td>
										<td>&nbsp;</td>
									</tr>				
									<tr>
										<td>&nbsp;</td>
										<td>
											<div id="yearselect">
											<select name="yeartype-startyear" id="yeartype-startyear" style="width:90px">
												<%for(int i=1990;i<2051;i++){%>
											     <c:set var="year" value="<%=i%>"/>
											     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
											   <%}%>
											</select>
											<span id="yearselect-right">
											--
											<select name="yeartype-endyear" id="yeartype-endyear" style="width:90px">
												<%for(int i=1990;i<2051;i++){%>
											     <c:set var="year" value="<%=i%>"/>
											     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
											   <%}%>
											</select>
											</span>
											</div>
											
											<div id="seasonselect" style="display:none;">
											<select name="seasontype-startyear" id="seasontype-startyear" style="width:50px">
												<%for(int i=1990;i<2051;i++){%>
											     <c:set var="year" value="<%=i%>"/>
											     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
											   <%}%>
											</select>
											<select name="seasontype-startseason" id="seasontype-startseason" style="width:60px;">
												<option value="1">1<fmt:message key="common.quarter.label" bundle="${v3xCommonI18N}"/></option>
												<option value="2">2<fmt:message key="common.quarter.label" bundle="${v3xCommonI18N}"/></option>
												<option value="3">3<fmt:message key="common.quarter.label" bundle="${v3xCommonI18N}"/></option>
												<option value="4">4<fmt:message key="common.quarter.label" bundle="${v3xCommonI18N}"/></option>
											</select> 
											<span id="seasonselect-right">
											--
											<select name="seasontype-endyear" id="seasontype-endyear" style="width:50px">
												<%for(int i=1990;i<2051;i++){%>
											     <c:set var="year" value="<%=i%>"/>
											     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
											   <%}%>
											</select>
											<select name="seasontype-endseason" id="seasontype-endseason" style="width:60px;">
												<option value="1" <c:if test="${curSeason==1}">selected</c:if>>1<fmt:message key="common.quarter.label" bundle="${v3xCommonI18N}"/></option>
												<option value="2" <c:if test="${curSeason==2}">selected</c:if>>2<fmt:message key="common.quarter.label" bundle="${v3xCommonI18N}"/></option>
												<option value="3" <c:if test="${curSeason==3}">selected</c:if>>3<fmt:message key="common.quarter.label" bundle="${v3xCommonI18N}"/></option>
												<option value="4" <c:if test="${curSeason==4}">selected</c:if>>4<fmt:message key="common.quarter.label" bundle="${v3xCommonI18N}"/></option>
											</select>
											</span>
											</div>
											
											<div id="monthselect" style="display:none;">
											<select name="monthtype-startyear" id="monthtype-startyear" style="width:50px">
												<%for(int i=1990;i<2051;i++){%>
											     <c:set var="year" value="<%=i%>"/>
											     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
											   <%}%>
											</select>
											<select name="monthtype-startmonth" id="monthtype-startmonth" style="width:50px;">
												<option value="1">1<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="2">2<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="3">3<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="4">4<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="5">5<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="6">6<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="7">7<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="8">8<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="9">9<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="10">10<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="11">11<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="12">12<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
											</select>
											<span id="monthselect-right">				
											--
											<select name="monthtype-endyear" id="monthtype-endyear" style="width:50px">
												<%for(int i=1990;i<2051;i++){%>
											     <c:set var="year" value="<%=i%>"/>
											     <option value="<%=i%>" <c:if test="${curYear==year}">selected</c:if>><%=i %></option>
											   <%}%>
											</select>
											<select name="monthtype-endmonth" id="monthtype-endmonth" style="width:50px;">
												<option value="1"  <c:if test="${curMonth==1}">selected</c:if>>1<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="2" <c:if test="${curMonth==2}">selected</c:if>>2<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="3" <c:if test="${curMonth==3}">selected</c:if>>3<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="4" <c:if test="${curMonth==4}">selected</c:if>>4<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="5" <c:if test="${curMonth==5}">selected</c:if>>5<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="6" <c:if test="${curMonth==6}">selected</c:if>>6<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="7" <c:if test="${curMonth==7}">selected</c:if>>7<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="8" <c:if test="${curMonth==8}">selected</c:if>>8<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="9" <c:if test="${curMonth==9}">selected</c:if>>9<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="10" <c:if test="${curMonth==10}">selected</c:if>>10<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="11" <c:if test="${curMonth==11}">selected</c:if>>11<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
												<option value="12" <c:if test="${curMonth==12}">selected</c:if>>12<fmt:message key="menu.tools.calendar.yue" bundle="${v3xMainI18N}"/></option>
											</select>	 
											</span>			
											</div>
											
											<div id="dayselect" style="display:none;">
											<input type="text" name="daytype-startday" id="daytype-startday" value="${curDay}" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
											<span id="dayselect-right">
											--
										  	<input type="text" name="daytype-endday" id="daytype-endday" value="${curDay}" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
											</span>
											</div> 
										</td>
										<td>&nbsp;</td>
										<td align="center">&nbsp;&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
				
									<TR style="height:30px;valign:top;padding-top:5px;">
										<td colspan="1"></td>
										<td align="center" colspan="3">		    	
											&nbsp;&nbsp;<input type="button" onclick="doStat();" name="ok" value="<fmt:message key='edoc.stat.label.simple' />" class="button-default_emphasize">	
											&nbsp;&nbsp;<input type="button" onclick="tuisong();" name="ok" value="<fmt:message key='common.search.PushHome.label' />" class="button-default-2">
										</td>
									</tr>
								</table>
										</td>
									</tr>
								</TABLE>
		   					</td>
		   				</tr>
		   			</tbody>
		   		</table>
		   	</div>
			</td>
			</tr>
			<tr id="onlyShow">
				<td height="20" valign="top">
					<div class="portal-layout-cell" style="margin:0;">
						<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
							<tr>
								<td class="sectionTitleLine" style="background:#F3F3F3;">
									<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td align="left">
												<span class="hand" onclick="alert(v3x.getMessage('edocLang.edoc_please_statistics'));" >
													<span class="hand ico16 export_excel_16 margin_l_10"></span><a href="###"><fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' /></a>
												</span>
												
												<span class="hand" onclick="alert(v3x.getMessage('edocLang.edoc_please_statistics'));" >
													<span class="ico16 print_16 margin_l_10"></span><a href="###"><fmt:message key='edoc.element.print' /></a>
												</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div> 
				</td>
			</tr>
			<tr>
				<td valign="top" align="center">
					<iframe id="content" name="content" width="100%" height="100%" style="border-top:1px solid #a0a0a0;border-left:1px solid #a0a0a0;border-right:1px solid #a0a0a0;border-bottom:1px solid #a0a0a0;" src="" frameborder="0"/>
				<td>
			</tr>
		  </table>
		 </div>		
		</td>
	</tr>
</table>
</form>
</body>