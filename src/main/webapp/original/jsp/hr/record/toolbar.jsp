<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<script type="text/javascript">
<!--
 
 function card() {
	parent.detailFrame.location.href = hrRecordURL+"?method=card";
 }

 function callForm(fKey) {
  	var options = {
   		url: '${hrFormURL}?method=getTemplete',
   		params: {key: fKey},
   		success: function(json) {
			var collURL = "${collaboration}?method=newColl";
			if (json[0].templeteId != -1) {
				collURL = collURL + "&templeteId="+json[0].templeteId;
				parent.parent.window.location.href = collURL;
			}		
			else{
			   alert(v3x.getMessage("HRLang.hr_form_notExist_label"));
			}
   		}
	};
	getJetspeedJSON(options);
 }

 function leave() {
 	callForm(1);
 }

 function evection() {
 	callForm(3);
 }

 function overtime() {
 	callForm(2);
 }
 
 function statistic() {
	 document.getElementById('isShowStatic').value="true";
	 var fromTime = document.searchForm.fromTime.value;
	 var toTime = document.searchForm.toTime.value;
	   if(fromTime==""||toTime==""){
	       alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
	       return false;
	   }
	   	if(compareDate(fromTime,toTime)>0)
		{
			window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
			return false;	
		}
	 parent.detailFrame.location.href = hrRecordURL+"?method=statistic&fromTime="+fromTime+"&toTime="+toTime;
 }

 function print() {
		   var aa= "";
		   var mm = parent.listFrame.document.getElementById("salaryform").innerHTML;
		   var list1 = new PrintFragment(aa,mm);
		   var tlist = new ArrayList();
		   tlist.add(list1);
		   var cssList=new ArrayList();
		   cssList.add("<c:url value="${v3x:getSkin()}/skin.css" />");
		   printList(tlist,cssList);
 }
 
 function selectDateTime(whoClick,width,height){
  var date = whenstart('${pageContext.request.contextPath}', null, width, height);
  var newDate = new Date();
  var strDate = newDate.getYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
  strDate = formatDate(strDate);
    if(whoClick.name=='fromTime'){
      if(document.getElementById('toTime').value!="" && 
        date>document.getElementById('toTime').value){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_startdoesnotlateend"));
      }
      else{
      	if (date != null){
        	whoClick.value = date; 
        }
      }
    }
    if(whoClick.name=='toTime'){
      if(document.getElementById('fromTime').value!="" && 
        date<document.getElementById('fromTime').value){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_enddoeslatestart"));
      }
      else if(strDate<date){
        alert(v3x.getMessage("HRLang.hr_message_checkdate_endcannotlatenow"));
      }
      else{
      	if (date != null){
        	whoClick.value = date;
        }
      }
    }
 }
 
 
 function compareDate(dateStr1, dateStr2){
	var date1 = parseDate(dateStr1);
	var date2 = parseDate(dateStr2);
	
	return date1.getTime() - date2.getTime();
}
 function searchRecord(){
   var fromTime = document.searchForm.fromTime.value;
   var toTime = document.searchForm.toTime.value;
   if(fromTime==""||toTime==""){
       alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
       return false;
   }
   	if(compareDate(fromTime,toTime)>0)
	{
		window.alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
		return false;	
	}
   parent.listFrame.location.href = hrRecordURL+"?method=searchRecord&fromTime="+fromTime+"&toTime="+toTime+"&isShowDetail=false";
   if(document.getElementById('isShowStatic').value == "true"){
	   parent.detailFrame.location.href = hrRecordURL+"?method=statistic&fromTime="+fromTime+"&toTime="+toTime;
   }
}
//-->
</script>
</head>
<body bgcolor="rgb(237,237,237)">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td width="50%" class="webfx-menu-bar">
	<script type="text/javascript">
	var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}'/>");
	
	myBar1.add(new WebFXMenuButton("card", "<fmt:message key='hr.record.card.label' bundle='${v3xHRI18N}' />","card()",[13,3], "", null));
	myBar1.add(new WebFXMenuButton("statistic", "<fmt:message key='hr.record.statisticInfo.label' bundle='${v3xHRI18N}' />", "statistic()" ,[1,2], "", null));
	myBar1.add(new WebFXMenuButton("print", "<fmt:message key='hr.record.application.print.label' bundle='${v3xHRI18N}'/>",  "print()" ,[1,8], "", null));	
	
	document.write(myBar1);
	document.close();
	</script>
	</td>
	<td class="webfx-menu-bar" width="50%" height="100%">
	<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
		<input type="hidden" id="isShowStatic" value="false"/>
		<div class="div-float-right" style="height:20px;line-height: 20px;vertical-align: middle;">
			<div id="subjectDiv" class="div-float">
				<fmt:message key='hr.userDefined.type.date.label' bundle='${v3xHRI18N}' />:&nbsp;&nbsp;&nbsp;
			</div>
			<div id="subjectDiv" class="div-float">			
				<input type="text" inputName="<fmt:message key="plan.body.endtime.label"/>"  style="cursor:hand"
           		validate="notNull" name="fromTime" id="fromTime"  onClick="whenstart(v3x.baseURL,this,775,150)" readonly
           		value="<fmt:formatDate value="${fromTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
           	</div>
            <div id="subjectDiv" class="div-float">
             &nbsp;&nbsp;-&nbsp;
            </div>
			<div id="subjectDiv" class="div-float">
				<input type="text" inputName="<fmt:message key="plan.body.endtime.label"/>"  style="cursor:hand"
           		validate="notNull" name="toTime" id="toTime"  onClick="whenstart(v3x.baseURL,this,1075,150)" readonly
           		value="<fmt:formatDate value="${toTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
			</div>
			<div onclick="javascript:searchRecord()" class="div-float condition-search-button"></div>
		</div>
	</form>
	</td>
  </tr>
</table>
</body>
</html>