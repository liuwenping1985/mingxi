<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="../../WEB-INF/jsp/project/projectHeader.jsp"%>
<html id="test">
<head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Expires" CONTENT="0">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='project.body.phase.label' /></title>
<script type="text/javascript">
	function addPhase(){
		var obj  = window.dialogArguments;
		//alert(obj.document.all.begintime.value)
		//项目开始、结束时间
		var parentBeginDate;
		var parentEndDate;
		if(obj.length==0){
			parentBeginDate = obj.document.all.begintime.value;
			parentEndDate = obj.document.all.closetime.value;
		}else if(obj.length==1){
			parentBeginDate = obj.document.all.begintime.value;
			parentEndDate = obj.document.all.closetime.value;
		}else if(obj.length==2){
			parentBeginDate = obj.document.all.begintime.value;
			parentEndDate = obj.document.all.closetime.value;
		}else{
			parentBeginDate = obj[2].document.all.begintime.value;
			parentEndDate = obj[2].document.all.closetime.value;
		}
		var myForm = document.all.addForm;
		//进度
		var schedule = document.all.jindu.value;
		//项目开始时间格式化
		var pbdArr;
		var pbd;
		var pedArr;
		var ped;
		var bdArr;
		var bd;
		var edArr;
		var ed;
		
		if(!checkForm(myForm)){
			return;
		}
		
		if(document.all.begintime.value==''||document.all.begintime.value.length==0){
			alert(v3x.getMessage("ProjectLang.project_phase_startdate_can_not_null"));
			return;
		}else{
			bdArr = document.all.begintime.value.split('-');
			bd = new Date(bdArr[1]+'/'+bdArr[2]+'/'+bdArr[0]);
		}
		
		if(parentBeginDate==''||parentBeginDate.length==0){
			alert(v3x.getMessage("ProjectLang.please_fill_project_begindate"));
			return;
		}else{
			pbdArr = parentBeginDate.split('-');
			pbd = new Date(pbdArr[1]+'/'+pbdArr[2]+'/'+pbdArr[0]);
		}
		
		if(document.all.closetime.value==''||document.all.closetime.value.length==0){
			alert(v3x.getMessage("ProjectLang.project_phase_enddate_can_not_null"));
			return;
		}else{
			edArr = document.all.closetime.value.split('-');
			ed = new Date(edArr[1]+'/'+edArr[2]+'/'+edArr[0]);
		}
		
		if(parentEndDate==''||parentEndDate.length==0){
			alert(v3x.getMessage("ProjectLang.please_fill_project_enddate"));
			return;
		}else{
			pedArr = parentEndDate.split('-');
			ped = new Date(pedArr[1]+'/'+pedArr[2]+'/'+pedArr[0]);
		}
		
		if(bd<pbd){
			alert(v3x.getMessage("ProjectLang.phase_startdate_must_late_than_project_startdate"));
			return;
		}else if(bd>ped){
			alert(v3x.getMessage("ProjectLang.phase_startdate_can_not_late_than_project_enddate"));
			return;
		}
		
		if(ed<pbd){
			alert(v3x.getMessage("ProjectLang.phase_enddate_must_late_than_project_startdate"));
			return;
		}else if(ed>ped){
			alert(v3x.getMessage("ProjectLang.phase_enddate_can_not_late_than_project_enddate"));
			return;
		}
		
		if(bd>ed){
			alert(v3x.getMessage("ProjectLang.phase_startdate_can_not_late_than_enddate"));
			return;
		}
		
		if(schedule.search('-')!=-1){
			alert(v3x.getMessage("ProjectLang.jindu_can_not_be_negative"));
			document.all.jindu.focus();
			return;
		}
		if(schedule > 100){
		
	     	alert(v3x.getMessage("ProjectLang.jindu_can_not_be_too_large"));
			return;
			}
		
		
		if(!isNumber(document.all.jindu)){
			return;
		}
		
	    var pindex;
	    if(obj.length==0){
		    pindex=obj.projectArr.length;
		    if(document.addForm.phaseName.value!=""){
		    	//obj.document.projectForm.ptest.value=document.addForm.phaseName.value;
		        obj.projectArr[pindex]="";
		        obj.projectArr[pindex]={
		        	pid:document.addForm.phaseId.value,
		        	pname:document.addForm.phaseName.value,
		            begintime:document.addForm.begintime.value,
		            closetime:document.addForm.closetime.value,
		            gusuan:document.addForm.jindu.value,
		            memo:document.addForm.jindudesc.value
		        };
		    }
		   	//alert(pindex);
		    obj.updateTable(pindex);
	    }else if(obj.length==1){
	    	pindex=obj.projectArr.length;
		    if(document.addForm.phaseName.value!=""){
		        obj.projectArr[pindex]="";
		        obj.projectArr[pindex]={
		        	pid:document.addForm.phaseId.value,
		        	pname:document.addForm.phaseName.value,
		            begintime:document.addForm.begintime.value,
		            closetime:document.addForm.closetime.value,
		            gusuan:document.addForm.jindu.value,
		            memo:document.addForm.jindudesc.value
		        };
		    }
		   	//alert(pindex);
		    obj.updateTable(pindex);
	    }else if(obj.length==2){
	    	pindex=obj.projectArr.length;
		    if(document.addForm.phaseName.value!=""){
		        obj.projectArr[pindex]="";
		        obj.projectArr[pindex]={
		        	pid:document.addForm.phaseId.value,
		        	pname:document.addForm.phaseName.value,
		            begintime:document.addForm.begintime.value,
		            closetime:document.addForm.closetime.value,
		            gusuan:document.addForm.jindu.value,
		            memo:document.addForm.jindudesc.value
		        };
		    }
		   	//alert(pindex);
		    obj.updateTable(pindex);
	    }else{
             pindex=obj[1];
             if(document.addForm.phaseName.value !=""){
		         obj[2].projectArr[pindex]="";
		         obj[2].projectArr[pindex]={
		         	pid:document.addForm.phaseId.value,
		        	pname:document.addForm.phaseName.value,
		            begintime:document.addForm.begintime.value,
		            closetime:document.addForm.closetime.value,
		            gusuan:document.addForm.jindu.value,
		            memo:document.addForm.jindudesc.value
		         };
		    }
		    obj[2].updateEditTable(pindex);
	    }
	    
	    window.close();
   }
   
   	function window.onload(){
   		var obj = window.dialogArguments
   		//alert(obj.length)
		if(obj.length!=0&&obj.length!=1&&obj.length!=2){//paramArr
			document.addForm.phaseId.value=obj[0].pid;
			document.addForm.phaseName.value=obj[0].pname;
			document.addForm.begintime.value=obj[0].begintime;
			document.addForm.closetime.value=obj[0].closetime;
			document.addForm.jindu.value=obj[0].gusuan;
			document.addForm.jindudesc.value=obj[0].memo;
		}
   }
   
   	var i=0;//定义个全局变量
   
   function sign(){
   	i++;   	
   }
   function cancle(){
   	if(i==0){
   		window.close();
   	}else{
   		if(window.confirm("阶段有变动，是否保存？")){
   			addPhase();
   		}else{
   			window.close();
   		}
   	}
   }
   
</script>
</head>

<body bgColor="#f6f6f6" scroll="no" onkeydown="listenerKeyESC()">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<form action="" method="post" name="addForm">
<input type="hidden" name="phaseId" value="">
  <tr>
		<td height="20" class="PopupTitle" colspan="3">
			<script type="text/javascript">
				var obj = window.dialogArguments
				if(obj.length!=0&&obj.length!=1&&obj.length!=2){
					document.write(v3x.getMessage("ProjectLang.project_edit"));
				}else{
					document.write(v3x.getMessage("ProjectLang.project_add"));
				}
			</script>
			<fmt:message key='project.body.phase.label' />
		</td>
  </tr>
  <tr>
	    <td align="right" width="30%"><font color="red">*</font><fmt:message key='project.phase.name.label' />:</td>
	    <Td align="left" width="60%">
	      <input type="text" name="phaseName" class="input-100per" onchange="sign();"	validate="notNull" maxlength="30" inputName="<fmt:message key='project.phase.name.label' />"/>
	    </td>
	    <td></td>
  </tr>
  <tr>
	    <td align="right"><font color="red">*</font><fmt:message key='project.body.startdate.label' />:</td>
	    <td align="left">
	    	<input type="text" name="begintime" onchange="sign();" readonly="readonly" class="input-100per" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'date');" />
	    </td>
	    <td></td>
  </tr>
  <tr>
	    <td align="right"><font color="red">*</font><fmt:message key='project.body.enddate.label' />:</td>
	    <td align="left">
	    	<input type="text" name="closetime" onchange="sign();" readonly="readonly" class="input-100per" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'date');" />
	    </td>
	    <td></td>
  </tr>
  <tr>
	    <td align="right"><font color="red">*</font><fmt:message key='project.phase.percent.label' />:</td>
	    <td align="left">
	      <input name="jindu" type="text" style="width: 15%;" onchange="sign();" value="0" validate="notNull,isInteger" class="input-100per" inputName="<fmt:message key='project.phase.percent.label' />" maxlength="3">%
	    </td>
	    <td></td>
  </tr>
  <tr>
	    <td align="right" valign="top"><fmt:message key='project.body.desc.label' />:</td>
	    <Td align="left" valign="top"><textarea style="resize: none;" name="jindudesc" maxSize="200" onchange="sign();" inputName="<fmt:message key='project.body.desc.label' />" validate="maxLength" class="input-100per" rows="3" class="textarea-style-2" inputName="<fmt:message key='project.body.desc.label' />"></textarea></td>
	    <td></td>
  </tr>
  <tr>
	   <td colspan="3" align="right" class="bg-advance-bottom">   
	   <table width="100%" border="0" cellspacing="0" cellpadding="0">
	     <tr>
	       <td align="right"><input type="hidden" name="ptest" value="">
	           <input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="addPhase();">&nbsp;
			   <input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="cancle();">
	       </td>   
	     </tr>
	   </table>
	   </td>
  </tr>
  </form>
</table>
</body>
</html>