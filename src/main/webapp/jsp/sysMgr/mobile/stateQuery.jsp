<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<%@include file="../header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>集团管理员-移动应用-状态查询</title>
<script type="text/javascript">
//getA8Top().showLocation(2008, "<fmt:message key='mobile.stateQuery.label'/>");
var hasIssueArea = false;
function submitQuery(){
	var startDate =	document.getElementById("startDate").value;
	var toDate = document.getElementById("toDate").value;
	var tjId= document.getElementById("tjValue").value;
	var tjValue= tjId==''?'':document.getElementById("tjValueName").value;
	var tjTypes= document.getElementsByName("tjType");
	var tjType="";
	var tjName="";
	if(tjTypes){
       for(var i=0;i<tjTypes.length;i++){
           if(tjTypes[i].checked){
             tjType=tjTypes[i].value;
             tjName=tjTypes[i].alt;
           }
       }
	}
  //if(tjId==''){
  //  alert(tjName+v3x.getMessage("sysMgrLang.system_statequery_alert_null"));  
  //  return false;
  //}
	document.getElementById("fm").action="${mobileManagerURL}?method=stateQuery&startDate="+startDate+"&toDate="+toDate+"&tjType="+tjType+"&tjId="+tjId+"&tjValue="+tjValue;
	document.getElementById("fm").submit();
  	//location.href="${mobileManagerURL}?method=stateQuery&startDate="+startDate+"&toDate="+toDate+"&tjType="+tjType+"&tjId="+tjId+"&tjValue="+tjValue;
} 

function setSelectDate(){
	var selectDateStr = whenstart('${pageContext.request.contextPath}','',675,140);
	if(!selectDateStr){
		document.getElementById("startDate").value=''
		document.getElementById("toDate").value = '';
		return;
	}
	var startDate =	formatDate(parseDate(selectDateStr).getMonthStart(selectDateStr));
	var toDate = formatDate(parseDate(selectDateStr).getMonthEnd(selectDateStr));
	document.getElementById("startDate").value = startDate;
	document.getElementById("toDate").value = toDate;
}

function initTitle(){
	if(${startDate!=null}){
		var selectDate = "${startDate}";
		if(document.getElementById("queryResultTitle")){
		  document.getElementById("queryResultTitle").innerHTML = "<b>" + selectDate.substring(0, selectDate.lastIndexOf("-")) + "</b>";
		}
	}
}
function resetQuery(){
  var tjTypes= document.getElementsByName("tjType");
  var tjValue="";
  if(tjTypes){
    tjTypes[0].checked=true;
    tjValue=tjTypes[0].alt;
  }
  document.getElementById("tjValueName").value="<点击选择>";
  document.getElementById("tjValue").value="";
  document.getElementById("startDate").value = "";
  document.getElementById("toDate").value = "";
  document.getElementById("showSpan").innerHTML=tjValue;
}
function changeShow(obj){
  document.getElementById("showSpan").innerHTML=obj.alt;
  document.getElementById("tjValue").value="";
  document.getElementById("tjValueName").value="<点击选择>";
}
function selectPeopleByCount(){
  var tjTypes= document.getElementsByName("tjType");
  var tjType="";
  if(tjTypes){
     for(var i=0;i<tjTypes.length;i++){
         if(tjTypes[i].checked){
           tjType=tjTypes[i].value;
         }
     }
  }
  if(tjType=='1'){
    selectPeopleFun_count1();
  }else if(tjType=='2'){
    selectPeopleFun_count2();
  }else if(tjType=='3'){
    selectPeopleFun_count3();
  }
}
function setPeopleFields(elements){
  if(!elements){
      return;
  }
  document.getElementById("tjValue").value=getIdsString(elements, false);
  document.getElementById("tjValueName").value=getNamesString(elements);   
  hasIssueArea = true;
}
</script>
</head>
<body scroll="yes" class="padding5" onload="initTitle()">
<c:set var="isGroup" value="${v3x:currentUser().groupAdmin}" />
<fmt:message var="isUnit" key='system.statequery.unit' bundle='${v3xSysI18N}' />
<fmt:message var="isStaff"  key='system.statequery.Staff' bundle='${v3xSysI18N}'  />
<fmt:message var="isDepartment"  key='system.statequery.Department' bundle='${v3xSysI18N}'  />
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" 
						onclick="javascript:location.href='${mobileManagerURL}?method=popedomManage'">
					 <fmt:message key="mobile.popedomManage.label"/>
					</div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>	
					
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" 
						onclick="javascript:location.href='${mobileManagerURL}?method=msgGateManage'">
					 <fmt:message key="mobile.msgGateManage.label"/>
					</div>
					<div class="tab-tag-right"></div>					
					<div class="tab-separator"></div>	

					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel" onclick="location.reload();">
					 <fmt:message key="mobile.messageCount.label"/>
					</div>
					<div class="tab-tag-right-sel"></div>

				</div>
		  </td>
	  </tr>

	  <tr>
	    <td valign="top" class="tab-body-bg" align="center">
	    <div class="scrollList">
			<br>
			<fieldset style="padding: 20px; width: 80%">
        	<legend><b><fmt:message key="system.statequery.Statisticsconditions" bundle="${v3xSysI18N}"/></b></legend>
        	    <div>
        	       <form action="" id="fm" method="post" name="fm">
        	       <table>
        	           <tr>
        	               <td><b><fmt:message key="system.statequery.StatisticsTo" bundle="${v3xSysI18N}"/>:</b></td>
        	               <td>
        	               <c:if test="${isGroup}">
        	                   
        	                    <input type="radio" <c:if test="${tjType=='1'}">checked="checked"</c:if>  name="tjType" id="defaultRadio" value="1" alt="${isUnit}" onclick="changeShow(this);">${isUnit}
        	               </c:if>
        	               <input type="radio" <c:if test="${tjType=='2'}">checked="checked"</c:if> name="tjType"  value="2" alt="${isDepartment }" onclick="changeShow(this);">${isDepartment }
        	               <input type="radio" <c:if test="${tjType=='3'}">checked="checked"</c:if>  name="tjType"  value="3" alt="${isStaff }"  onclick="changeShow(this);">${isStaff }
        	               </td>
        	               <td align="center"><b>
        	               <c:set value="" var="defValue"/>
        	               <c:if test="${tjType=='1'}">
        	                    <c:set var="defValue" value="${isUnit}" ></c:set>
        	               </c:if>
        	               <c:if test="${tjType=='2'}">
                                <c:set var="defValue" value="${isDepartment}" ></c:set>
                           </c:if>
                           <c:if test="${tjType=='3'}">
                                <c:set var="defValue" value="${isStaff}" ></c:set>
                           </c:if>
        	               <span id="showSpan">${defValue}</span>:</b></td>
        	               <td class="new-column , bbs-tb-padding-topAndBottom">
        	               <fmt:message key="system.statequery.ClickSelect" var="defName" bundle="${v3xSysI18N}" />
        	                <v3x:selectPeople id="count1" originalElements="${tjId}" panels="Account" selectType="Account" jsFunction="setPeopleFields(elements,'tjValue','tjValueName')" maxSize="50" />  
                            <v3x:selectPeople id="count2" originalElements="${tjId}" panels="Department,Outworker" selectType="Department,Outworker" jsFunction="setPeopleFields(elements,'tjValue','tjValueName')" maxSize="50" />  
                            <v3x:selectPeople id="count3" originalElements="${tjId}" panels="Department,Outworker" selectType="Member,Outworker" jsFunction="setPeopleFields(elements,'tjValue','tjValueName')" maxSize="50" />  
                        
                            <input type="hidden" value="${tjId }" name="tjValue" id="tjValue"> 
                            <input type="text" name="tjValueName"  class="comp" id="tjValueName"
                                value="${tjName==''?defName:tjName}" 
                                readonly class="cursor-hand input-100per" onclick="selectPeopleByCount();" 
                                deaultValue="${defName}">
                             
                           </td>
        	          
        	           </tr>
        	           <tr>
                           <td><b><fmt:message key='system.statequery.SelectMonth' bundle='${v3xSysI18N}'/>:</b></td>
                           <td>
                           <input type="text" class="input-date cursor-hand" id="startDate" name="startDate" onclick="setSelectDate()" value="${startDate}" readonly>
                           -<input type="text" class="input-date cursor-hand" id="toDate" name="toDate" onclick="setSelectDate()" value="${toDate}" readonly>
                           </td>
                           <td><input type="button" class="button-default-2" value="<fmt:message key='common.button.condition.search.label' bundle="${v3xCommonI18N}" />" onclick="submitQuery()"></td>
                           <td><input type="button" class="button-default-2" value="<fmt:message key='system.statequery.Reset' bundle='${v3xSysI18N}'/>" onclick="resetQuery()"></td>
                       </tr>
        	       </table>
        	       </form>
        	    </div>
			</fieldset>
			<br><br>
			<fieldset style="padding: 20px; width: 80%">
        	<!-- <legend id="queryResultTitle"><b><fmt:message key="mobile.count.usedInfo.label"/></b></legend>             -->
        	<legend ><b><fmt:message key="system.statequery.SMSUsageStatisticsResults" bundle="${v3xSysI18N}"/></b></legend>         
			<p></p>
			<table align="center" class="page2-list-border sort" width="90%" border="0" cellpadding="0" cellspacing="0">
				<thead>
				 <c:if test="${tjType=='1'}">
					<tr>
	                    <td width="40%" height="36">
	                        <fmt:message key='org.account.label' bundle='${v3xMainI18N}'/>
	                    </td>
	                    <td width="30%">
	                        <fmt:message key="mobile.SMS.label.section"/>
	                    </td>
	                    <c:if test="${canUseWapPush}">
	                    <td width="30%">
	                        <fmt:message key="mobile.WapPush.label"/>
	                    </td>
	                    </c:if>
	                </tr>
				 </c:if>
				  <c:if test="${tjType=='2'}">
                    <tr>
                        <td width="40%" height="36">
                            <fmt:message key='org.department.label' bundle='${v3xMainI18N}'/>
                        </td>
                        <td width="30%">
                            <fmt:message key="mobile.SMS.label.section"/>
                        </td>
                        <c:if test="${canUseWapPush}">
                        <td width="30%">
                            <fmt:message key="mobile.WapPush.label"/>
                        </td>
                        </c:if>
                    </tr>
                 </c:if>
                  <c:if test="${tjType=='3'}">
                    <tr>
                        <td width="20%" height="36">
                            <fmt:message key='org.department.label' bundle='${v3xMainI18N}'/>
                        </td>
                        <td width="20%" height="36">
                            <fmt:message key='org.member.label' bundle='${v3xMainI18N}'/>
                        </td>
                        <td width="30%">
                            <fmt:message key="mobile.SMS.label.section"/>
                        </td>
                        <c:if test="${canUseWapPush}">
                        <td width="30%">
                            <fmt:message key="mobile.WapPush.label"/>
                        </td>
                        </c:if>
                    </tr>
                 </c:if>
				</thead>
 				<c:set value="0" var="smsSum"/>
 				<c:set value="0" var="wappushSum"/>
 				<c:if test="${tjType=='1'}">
                   <c:forEach items="${accountList}" var="account" varStatus="status">
	                <c:if test="${!account.group}">
	                    <tr>
	                        <td id="L${status.index}" height="24" class="sort" onclick="changeTRColor(${status.index})">${account.name}</td>
	                        <td id="M${status.index}" class="sort" onclick="changeTRColor(${status.index})"><b>${SMSCountMap[account.id]}</b></td>
	                        <c:if test="${canUseWapPush}">
	                        <td id="R${status.index}" class="sort" onclick="changeTRColor(${status.index})"><b>${WappushCountMap[account.id]}</b></td>
	                        </c:if>
	                    </tr>
	                    <c:set value="${smsSum + SMSCountMap[account.id]}" var="smsSum"/>
	                    <c:set value="${wappushSum + WappushCountMap[account.id]}" var="wappushSum"/>
	                </c:if>
	               </c:forEach>
                 </c:if>
				 <c:if test="${tjType=='2'}">
                   <c:forEach items="${departmentList}" var="account" varStatus="status">
                    <c:if test="${!account.group}">
                        <tr>
                            <td id="L${status.index}" height="24" class="sort" onclick="changeTRColor(${status.index})">${account.name}(${v3x:getAccount(account.orgAccountId).name})</td>
                            <td id="M${status.index}" class="sort" onclick="changeTRColor(${status.index})"><b>${SMSCountMap[account.id]}</b></td>
                            <c:if test="${canUseWapPush}">
                            <td id="R${status.index}" class="sort" onclick="changeTRColor(${status.index})"><b>${WappushCountMap[account.id]}</b></td>
                            </c:if>
                        </tr>
                        <c:set value="${smsSum + SMSCountMap[account.id]}" var="smsSum"/>
                        <c:set value="${wappushSum + WappushCountMap[account.id]}" var="wappushSum"/>
                    </c:if>
                   </c:forEach>
                 </c:if>
                  <c:if test="${tjType=='3'}">
                   <c:forEach items="${memberList}" var="account" varStatus="status">
                    <c:if test="${true}">
                        <tr>
                            <td id="L${status.index}" height="24" class="sort" onclick="changeTRColor(${status.index})">${v3x:getDepartment(account.orgDepartmentId).name}(${v3x:getAccount(account.orgAccountId).name})</td>
                            <td id="Q${status.index}" height="24" class="sort" onclick="changeTRColor(${status.index})">${account.name}(${v3x:getAccount(account.orgAccountId).name})</td>
                            <td id="M${status.index}" class="sort" onclick="changeTRColor(${status.index})"><b>${SMSCountMap[account.id]}</b></td>
                            <c:if test="${canUseWapPush}">
                            <td id="R${status.index}" class="sort" onclick="changeTRColor(${status.index})"><b>${WappushCountMap[account.id]}</b></td>
                            </c:if>
                        </tr>
                        <c:set value="${smsSum + SMSCountMap[account.id]}" var="smsSum"/>
                        <c:set value="${wappushSum + WappushCountMap[account.id]}" var="wappushSum"/>
                    </c:if>
                   </c:forEach>
                 </c:if>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td height="28" align="left" class="sort"><b><fmt:message key="mobile.count.sum.label"/></b></td>
					<c:if test="${tjType=='3'}">
                       <td>&nbsp;</td>
                    </c:if>
					<td class="sort"><b>${smsSum}</b></td>
					<c:if test="${canUseWapPush}">
					<td class="sort"><b>${wappushSum}</b></td>
					</c:if>
				</tr>
			</table>
			</fieldset>
			</div>
	    </td>
	  </tr>
	  <tr>
			<td height="42" align="center" class="tab-body-bg bg-advance-bottom">
				<input type="button" onclick="getA8Top().backToHome();" 
				value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
</body>
</html>