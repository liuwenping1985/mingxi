<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<html>
<head>
<%@ include file="edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/register.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

var selectType = 1;

function setPeopleFields(elements) {
	for(var i=0; i<elements.length; i++) {
		if(selectType==1) {
			sendToId += elements[i].type+"|"+elements[i].id+",";
			sendToUnit += elements[i].name+"、";
		} else if(selectType==2) {
			copyToId += elements[i].type+"|"+elements[i].id+",";
			copyToUnit += elements[i].name+"、";
		} else if(selectType==4) {
			distributerId = elements[i].id;
			distributer = elements[i].name;
		}
	}
	if(sendToId!="") {
		sendToId = sendToId.substring(0, sendToId.length-1);
		sendToUnit = sendToUnit.substring(0, sendToUnit.length-1); 
	}
	if(copyToId!="") {
		copyToId = copyToId.substring(0, copyToId.length-1);
		copyToUnit = copyToUnit.substring(0, copyToUnit.length-1); 
	}
	if(selectType==1) {
		$("#sendForm").find("[@name='sendToId']").val(sendToId);
		$("#sendForm").find("[@name='sendTo']").val(sendToUnit);
	} else if(selectType==2) {
		$("#sendForm").find("[@name='copyToId']").val(copyToId);
		$("#sendForm").find("[@name='copyTo']").val(copyToUnit);
	} else if(selectType==4) {
		$("#sendForm").find("[@name='distributerId']").val(distributerId);
		$("#sendForm").find("[@name='distributer']").val(distributer);
	}
}



window.onload = function() {
	
	//if(${canUpdateAtOutRegist} && ${bean.createUserId==curUser.id} && ${bean.distributeState}==0) {
	if(${bean.createUserId}==${curUser.id} && ${bean.distributeState}==0) {

		/*$.each($("form").find("[@show='divType']"), function() {
			$(this).css("display", "none");
		});
		$.each($("form").find("[@show='formType']"), function() {
			$(this).css("display", "block");
		});*/
		
	}
	
}

function relationSendEdoc(){
	/*
  //关联发文
  var relSends = "${relSends}";
  if(relSends == "haveMany"){
	  document.getElementById("relationSend").style.display="block";
   }*/
}



</script>
</head>

<body style="overflow: auto;" onload="relationSendEdoc()">

<%--puyc 登记单 收文关联发文 --%>
<div id="relationSend" style="display:none;"><a href="#" onclick="relationSendV()" ><font color=red><fmt:message key='edoc.associated.posting'/></font></a></div>
<%--puyc --%>
<form>

<v3x:selectPeople id="sendToSelect" 
	  panels="Account,Department,ExchangeAccount,OrgTeam" 
	  selectType="Account,Department,ExchangeAccount,OrgTeam" 
	  jsFunction="setPeopleFields(elements)" 
	  originalElements="${sendToSelect}"  
	  viewPage="" 
	  minSize="0"/>

<v3x:selectPeople id="copyToSelect" 
	  panels="Account,Department,ExchangeAccount,OrgTeam" 
	  selectType="Account,Department,ExchangeAccount,OrgTeam" 
	  jsFunction="setPeopleFields(elements)" 
	  originalElements="${copyToSelect}"
	  viewPage="" 
	  minSize="0"  />	  

<v3x:selectPeople id="distributerSelect" 
	panels="Department,Post,Team" 
	selectType="Department,Member,Post,Team" 
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
 	jsFunction="setPeopleFields(elements, 'detailIframe')" 
 	viewPage="" 
 	minSize="0" 
 	maxSize="1" 
 	/>
 
	
	<div align="center">
		<table style="BORDER-BOTTOM: medium none; BORDER-LEFT: medium none; WIDTH: 624px; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-RIGHT: medium none" class="xdLayout" border="1" borderColor="buttontext">
			<colgroup>
				<col style="WIDTH: 106px"/>
				<col style="WIDTH: 179px"/>
				<col style="WIDTH: 101px"/>
				<col style="WIDTH: 238px"/>
			</colgroup>
			<tbody vAlign="top">
				<%-- 收文登记单 --%>
				<tr style="MIN-HEIGHT: 30px">
					<td colSpan="4" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #000000 1pt; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div align="center"><font color="#ff0000" size="6"><fmt:message key="edoc.element.receive.register_form" /> </font></div>
					</td>
				</tr>
				<%-- 标题 --%>
				<tr style="MIN-HEIGHT: 30px">
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="exchange.edoc.title" bundle="${exchangeI18N }"/></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="subject" show="divType">${v3x:toHTML(bean.subject)}</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 收文编号  --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.serial_no" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div id="serialNo" show="divType">${bean.serialNo}</div>
					</td>
					<%-- 来文字号  来文文号--%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4">来文文号</font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="docMark" show="divType">${bean.docMark}</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 公文种类 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.doctype" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<v3x:metadataItemLabel metadata="${edocTypeMetadata}" value="${bean.docType}"/>
					</td>
					<%-- 来文类别 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.send_unit_type" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="sendUnitType" show="divType">
							<v3x:metadataItemLabel metadata="${sendUnitTypeData}" value="${bean.sendUnitType}"/>
						</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 打印份数  --%>
					<td style="border-width: 1.5pt 1.5pt 1.5pt 1pt; border-style: solid solid solid none; border-color: rgb(255, 0, 0) rgb(255, 0, 0) rgb(255, 0, 0) rgb(0, 0, 0); padding: 1px 10px; vertical-align: middle; background-color: transparent;">
                        <div style="text-align: right;">
                            <font face="宋体" color="#ff0000" size="4"><fmt:message key="edoc.prints" /></font>
                        </div>
                    </td>
                    <td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
                            <div id="copies" show="divType">${bean.copies }</div>
                    </td>
					<%-- 密级 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.dense" /></font></div>
					</td>
					<td style="border-width: 1.5pt 1pt 1.5pt 1.5pt; border-style: solid none solid solid; border-color: rgb(255, 0, 0) rgb(0, 0, 0) rgb(255, 0, 0) rgb(255, 0, 0); padding: 1px 10px; vertical-align: middle; background-color: transparent;">
						<div id="secretLevel" show="divType">
							<v3x:metadataItemLabel metadata="${edocSecretLevelData}" value="${bean.secretLevel}"/>
						</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 紧急程度 --%>
					<td style="border-width: 1.5pt 1.5pt 1.5pt 1pt; border-style: solid solid solid none; border-color: rgb(255, 0, 0) rgb(255, 0, 0) rgb(255, 0, 0) rgb(0, 0, 0); padding: 1px 10px; vertical-align: middle; background-color: transparent;">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.urgentlevel" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="urgentLevel" show="divType">
							<v3x:metadataItemLabel metadata="${edocUrgentLevelData}" value="${bean.urgentLevel}"/>
						</div>
					</td>
					<%-- 保密期限 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="exchange.edoc.keepperiod2" bundle="${exchangeI18N }"/></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="keepPeriod" show="divType">
							<v3x:metadataItemLabel metadata="${edocKeepPeriodData}" value="${bean.keepPeriod}"/>
						</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 成文日期 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.edoc_date" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div id="edocDate" show="divType">${bean.edocDate }</div>
					</td>
					 <%-- 公文级别 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;">
							<font face="宋体" color="#ff0000" size="4"><fmt:message key="edoc.unitLevel.label" /></font>
						</div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						
						<div id="unitLevel" show="divType">
							<v3x:metadataItemLabel metadata="${edocUnitLevelData}" value="${bean.unitLevel}"/>
						</div>
					</td>
					
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 成文单位 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.edoc_unit" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="edocUnit" show="divType">${v3x:toHTML(bean.edocUnit)}</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 主送单位 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.sendtounit" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="sendTo" show="divType">${v3x:toHTML(bean.sendTo) }</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 抄送单位 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.copytounit" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="copyTo" show="divType">${v3x:toHTML(bean.copyTo)}</div>
					</td>
				</tr>
				
				<%-- 
				根据国家行政公文规范,去掉主题词
				<tr style="MIN-HEIGHT: 32px">
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div><font color="#ff0000" size="4"><fmt:message key="edoc.element.keyword" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="keywords" show="divType">${v3x:toHTML(bean.keywords) }</div>
					</td>
				</tr> --%>
				
				

				<tr style="MIN-HEIGHT: 31px">
					<%-- 登记人 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.edoctitle.regPerson.label" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div id="registerUserName">${v3x:toHTML(bean.registerUserName)}</div>
					</td>
					<%-- 登记日期 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.edoctitle.regDate.label" /></font></div>
					</td>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="registerDate">
							<fmt:formatDate value='${bean.registerDate}' type='both' dateStyle='full' pattern='yyyy-MM-dd' var="registerDate"/>	${registerDate }
						</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 分发人 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.distributer" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="distributer" show="divType">${v3x:toHTML(bean.distributer)}</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 30px">
					<%-- 附件说明 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.att_note" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="attNote" show="divType">${v3x:toHTML(bean.attNote) }</div>
					</td>
				</tr>
				
				<tr style="MIN-HEIGHT: 31px">
					<%-- 附注 --%>
					<td style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #000000 1pt; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #ff0000 1.5pt solid; PADDING-TOP: 1px">
						<div style="text-align: right;"><font color="#ff0000" size="4"><fmt:message key="edoc.element.receive.note_append" /></font></div>
					</td>
					<td colSpan="3" style="BORDER-BOTTOM: #ff0000 1.5pt solid; BORDER-LEFT: #ff0000 1.5pt solid; PADDING-BOTTOM: 1px; BACKGROUND-COLOR: transparent; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; VERTICAL-ALIGN: middle; BORDER-TOP: #ff0000 1.5pt solid; BORDER-RIGHT: #000000 1pt; PADDING-TOP: 1px">
						<div id="noteAppend" show="divType">${v3x:toHTML(bean.noteAppend) }</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>


</form>
</body>


</html>