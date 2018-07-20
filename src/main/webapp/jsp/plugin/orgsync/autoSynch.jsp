<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>hand</title>
<%@include file="header_autoSynch.jsp"%>
<script type="text/javascript">
	   //导航菜单
	   showCtpLocation("F21_OrgSync_Opt");
</script>
</head>
<script type="text/javascript">
	var accountIdsArray = [];
	function getChildrenChecked(node){
		if(node && node.childNodes){
			var children = node.childNodes;
			for(var i = 0; i< children.length; i++){
				var c = children[i];
				if(c.getChecked()){
					accountIdsArray[accountIdsArray.length] = c.businessId;
				}
				getChildrenChecked(c);
			}
		}
	}
	
	function autoSynchron(form){
		var handRadioObj = document.getElementById("handRadio");
		var autoRadioObj = document.getElementById("autoRadio");
		if(handRadioObj.checked){
			var count = validateCheckbox("orgIds");
			if(count <= 0 && ${v3x:getSysFlagByName('sys_isEnterpriseVer')!=true}){
				alert("<fmt:message key='orgsync.org.synchron.hand.selectOrg'/>");
				return false;
			}
		       var requestCaller= new XMLHttpRequestCaller(this, "orgSyncManager", "isSyningHand",false);
				 var ds= requestCaller.serviceRequest();
				 if(ds=='true'){
					 alert("<fmt:message key='orgsync.org.hand.syning'/>");
					 return false;
				 }
		       document.getElementById("submitButton").disabled = true;
		}
		else if(autoRadioObj.checked){
			if(document.getElementById("isStart1").checked && document.getElementById("intervalTimeRadio").checked){
				if(document.all.intervalDay.value=='0' && document.all.intervalHour.value=='0' && document.all.intervalMin.value=='0'){
					alert("<fmt:message key='orgsync.org.synchron.timeSetting.timeMustGT0'/>");
					return false;
				}
			}
		    document.all.submitButton.disabled = true;
		}
		
		//getA8Top().startProc('');
		return true;
	}
	function switchSynchType(SynchType){
		var handOptionObj = document.getElementById("handSynchOption");
		var autoOptionObj = document.getElementById("autoSynchOption");
		if(SynchType == 'auto'){
			handOptionObj.style.display="none";
			autoOptionObj.style.display="";
			document.getElementById("submitButton").disabled = false;
		}
		else{
			handOptionObj.style.display="";
			autoOptionObj.style.display="none";
		}
			intervalometer();
	}
	function setOptionEnable(flag){
		var radio1Obj = document.all.setTimeRadio;
		var radio2Obj = document.all.intervalTimeRadio;
		var typeObj = document.getElementById("typeSel");
		var hourObj = document.all.hour;
		var minObj = document.all.min;
		var intervalDayObj = document.all.intervalDay;
		var intervalHourObj = document.all.intervalHour;
		var intervalMinObj = document.all.intervalMin;
	
		if(flag){
			if(radio1Obj.checked == true){
				clickSetTimeRadio();
			}
			if(radio2Obj.checked == true){
				clickIntervalTimeRadio();
			}
			
		}
		else{
			radio1Obj.disabled = true;
			radio2Obj.disabled = true;
			typeObj.disabled = true;
			hourObj.disabled = true;
			minObj.disabled = true;
			intervalDayObj.disabled = true;
			intervalHourObj.disabled = true;
			intervalMinObj.disabled = true;
		}
	}
	
	function clickSetTimeRadio(){
		var radio1Obj = document.all.setTimeRadio;
		var radio2Obj = document.all.intervalTimeRadio;
		var typeObj = document.getElementById("typeSel");
		var hourObj = document.all.hour;
		var minObj = document.all.min;
		var intervalDayObj = document.all.intervalDay;
		var intervalHourObj = document.all.intervalHour;
		var intervalMinObj = document.all.intervalMin;
	
		radio1Obj.disabled = false;
		radio2Obj.disabled = false;
		typeObj.disabled = false;
		hourObj.disabled = false;
		minObj.disabled =  false;
		intervalDayObj.disabled = true;
		intervalHourObj.disabled = true;
		intervalMinObj.disabled = true;
	}
	function clickIntervalTimeRadio(){
		var radio1Obj = document.all.setTimeRadio;
		var radio2Obj = document.all.intervalTimeRadio;
		var typeObj = document.getElementById("typeSel");
		var hourObj = document.all.hour;
		var minObj = document.all.min;
		var intervalDayObj = document.all.intervalDay;
		var intervalHourObj = document.all.intervalHour;
		var intervalMinObj = document.all.intervalMin;
	
		radio1Obj.disabled = false;
		radio2Obj.disabled = false;
		typeObj.disabled = true;
		hourObj.disabled = true;
		minObj.disabled =  true;
		intervalDayObj.disabled = false;
		intervalHourObj.disabled = false;
		intervalMinObj.disabled = false;
	}
	//定时调用
	function intervalometer(){
		var requestCaller= new XMLHttpRequestCaller(this, "orgSyncManager", "isSyningHand",false);
		var ds= requestCaller.serviceRequest();
		synchStateMark = ds;
		if( ds == 'false' ){
			document.getElementById("synchState").style.display = 'none';
			document.getElementById("submitButton").disabled = false;
		}
	}
	
	function checkSynchState(synchType){
		var synchHandState = ${isHandSynching};
		if(synchHandState){
			document.getElementById("synchState").style.display = 'block';
			if( synchType != 'auto'){
				document.getElementById("submitButton").disabled = true;
			}		
			window.setInterval("intervalometer()",1000);
		}
	}
	function init(){
		checkSynchState('${v3x:escapeJavascript(synchType)}');
		switchSynchType('${v3x:escapeJavascript(synchType)}');
		if( '${isStart}'=='true'){
			if('${synchTimeType}'=='0'){
				clickSetTimeRadio();
			}else{
				clickIntervalTimeRadio();
			}
		}
	}
</script>
</head>
<body class="border-left border-right"  style="overflow:auto;" onload="init()">
<div class="scrollList">
<form action="${urlNCSynchron}?method=operation" name="autoForm" method="post" onsubmit="return autoSynchron(this)">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td height="100%" class="categorySet-head" valign="top">
		<table width="90%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td height="40" nowrap>
					<b><fmt:message key="orgsync.org.synchron.type"/>:</b>&nbsp;&nbsp;
					<label for="handRadio">
						<input id="handRadio" type="radio" name="synchType" value="hand" ${synchType=='auto'? '':'checked'} onclick="switchSynchType('hand')"><fmt:message key="orgsync.org.synchron.type.hand"/>
					</label>&nbsp;&nbsp;
					<label for="autoRadio">
						<input id="autoRadio" type="radio" name="synchType" value="auto" ${synchType=='auto'? 'checked':''} onclick="switchSynchType('auto')"><fmt:message key="orgsync.org.synchron.type.auto"/>
					</label>
					<label for="SyncAll">
						<input id="SyncAll" type="radio" name="AllInc" value="all"><fmt:message key="orgsync.org.synchron.type.all"/>
					</label>
					<label for="SyncInc">
						<input id="SyncInc" type="radio" name="AllInc" value="inc" checked ><fmt:message key="orgsync.org.synchron.type.inc"/>
					</label>
				</td>
			</tr>
			<tr>
				<td height="20" nowrap>
					<font color="red"><p id="synchState" style="display: none;"><fmt:message key="orgsync.org.synching"/></p></font>
				</td>
			</tr>
			
			<tr>
				<td height="100%" valign="top">
					<fieldset style="vertical-align: top">
						<legend style="height: 20px; padding-top: 5px;"><b><fmt:message key="orgsync.org.synchron.option"/></b></legend>
						<table width="100%" height="300" id="handSynchOption">
							<%--  
							<c:if test="${v3x:getSysFlagByName('sys_isEnterpriseVer')!=true}">
							--%>
							<tr>
								<td valign="top" height="100%" style="padding-left: 30px;">
									<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" class="sort" style="border-bottom: 0px;">
						   				<tr>
						   					<td class="padding-L" valign="top" height="100%">
												<c:forEach items="${accountlist}" var="account" varStatus="status">
													<c:if test="${account.v3xOrgAccount != '0000'}">
												       <label for="chk${status.index}">
														<input id="chk${status.index}" type="checkbox" name="orgIds" value="${account.v3xOrgAccount.id}"> ${account.v3xOrgAccount.name}
														</label><br/>
													</c:if>
												</c:forEach>
												<%-- 
												<iframe name="accountsTreeFrame" width="90%" height="100%" frameborder="1" src="${urlNCAutoSynch}?method=showAccountsTree">
												</iframe>
												--%>
											</td>
						   				</tr>
						   			</table>
								</td>
							</tr>
							
			   				<%--  </c:if> --%>
			   				<tr>
			   				<td height="30" style="padding-left: 30px;">
								<font color="red">*</font><fmt:message key="orgsync.org.hand.starttime" />:
								<input type="text" name="startTime" id="startTime" class="cursor-hand" inputName="startTime" validate="notNull" value="${starttimenow}" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');" ${v3x:outConditionExpression(edit == "1", 'disabled', 'readonly')}/>
								</td>
							</tr>
						</table>
						<table width="100%" id="autoSynchOption" style="display: none;">
							<tr>
								<td width="60%" class="padding-L">
									<table width="100%">
										<tr>
								    		<td width="100" height="50" nowrap="nowrap" align="right"><font color="red">*</font><fmt:message key="orgsync.org.synchron.auto.enable" />：</td>
								    		<td colspan="2">
								    			<label for="isStart1">
								      			<input id="isStart1" name="isStart" type="radio" value="1" onclick="setOptionEnable(true)" ${isStart?'checked':''}><fmt:message key="common.yes" bundle="${v3xCommonI18N}"/>
								      			</label>&nbsp;&nbsp;
								    			<label for="isStart2">
								      				<input id="isStart2" name="isStart" type="radio" value="0" onclick="setOptionEnable(false)" ${isStart?'':'checked'}><fmt:message key="common.no" bundle="${v3xCommonI18N}"/>
			   					    			</label>
			   					    		</td>
			        			  		</tr>
			        			  		<tr>
			        			  			<td rowspan="2" nowrap="nowrap" align="right">
			        			  				<font color="red">*</font><fmt:message key="orgsync.org.synchron.timeSetting"/>：
			        			  			</td>
											<td width="80" nowrap="nowrap"><label for="setTimeRadio"><input id="setTimeRadio" type="radio" name="synchTimeType" ${synchTimeType==0?'checked':''} ${isStart?'':'disabled'} value="setTime" onclick="clickSetTimeRadio()"><fmt:message key="orgsync.org.synchron.timeSetting.0"/>：</label></td>
											<td>
												<select id="typeSel" name="type" ${isStart?'':'disabled'}>
						        			      <option value="0" ${type == '0'?'selected':''}><fmt:message key="orgsync.org.auto.everyday" /></option>
						        			      <option value="1" ${type == '1'?'selected':''}><fmt:message key="orgsync.org.auto.sunday" /></option>
						        			      <option value="7" ${type == '7'?'selected':''}><fmt:message key="orgsync.org.auto.saturday" /></option>
						        			      <option value="6" ${type == '6'?'selected':''}><fmt:message key="orgsync.org.auto.friday" /></option>
						        			      <option value="5" ${type == '5'?'selected':''}><fmt:message key="orgsync.org.auto.thursday" /></option>
						        			      <option value="4" ${type == '4'?'selected':''}><fmt:message key="orgsync.org.auto.wednesday" /></option>
						        			      <option value="3" ${type == '3'?'selected':''}><fmt:message key="orgsync.org.auto.tuesday" /></option>
						        			      <option value="2" ${type == '2'?'selected':''}><fmt:message key="orgsync.org.auto.monday" /></option>
						        			    </select>
												<select name="hour" ${isStart?'':'disabled'}>
													<option value="0" ${hour == '0'?'selected':''}>0</option>
													<option value="1" ${hour == '1'?'selected':''}>1</option>
													<option value="2" ${hour == '2'?'selected':''}>2</option>
													<option value="3" ${hour == '3'?'selected':''}>3</option>
													<option value="4" ${hour == '4'?'selected':''}>4</option>
													<option value="5" ${hour == '5'?'selected':''}>5</option>
													<option value="6" ${hour == '6'?'selected':''}>6</option>
													<option value="7" ${hour == '7'?'selected':''}>7</option>
													<option value="8" ${hour == '8'?'selected':''}>8</option>
													<option value="9" ${hour == '9'?'selected':''}>9</option>
													<option value="10" ${hour == '10'?'selected':''}>10</option>
													<option value="11" ${hour == '11'?'selected':''}>11</option>
													<option value="12" ${hour == '12'?'selected':''}>12</option>
													<option value="13" ${hour == '13'?'selected':''}>13</option>
													<option value="14" ${hour == '14'?'selected':''}>14</option>
													<option value="15" ${hour == '15'?'selected':''}>15</option>
													<option value="16" ${hour == '16'?'selected':''}>16</option>
													<option value="17" ${hour == '17'?'selected':''}>17</option>
													<option value="18" ${hour == '18'?'selected':''}>18</option>
													<option value="19" ${hour == '19'?'selected':''}>19</option>
													<option value="20" ${hour == '20'?'selected':''}>20</option>
													<option value="21" ${hour == '21'?'selected':''}>21</option>
													<option value="22" ${hour == '22'?'selected':''}>22</option>
													<option value="23" ${hour == '23'?'selected':''}>23</option>
												</select>
												<fmt:message key="orgsync.org.auto.hour" />
						        			    <select name="min" ${isStart?'':'disabled'}>
						        			      <option value="0" ${min == '0'?'selected':''}>0</option>
						        			      <option value="5" ${min == '5'?'selected':''}>5</option>
						        			      <option value="10" ${min == '10'?'selected':''}>10</option>
						        			      <option value="15" ${min == '15'?'selected':''}>15</option>
						        			      <option value="20" ${min == '20'?'selected':''}>20</option>
						        			      <option value="30" ${min == '30'?'selected':''}>30</option>
						        			      <option value="40" ${min == '40'?'selected':''}>40</option>
						        			      <option value="50" ${min == '50'?'selected':''}>50</option>
						        			    </select>
						        			    <fmt:message key="orgsync.org.auto.min" />
									        </td>
										</tr>
										<tr>
											<td nowrap="nowrap"><label for="intervalTimeRadio"><input ${isStart?'':'disabled'} id="intervalTimeRadio" type="radio" name="synchTimeType" ${synchTimeType!=0?'checked':''} value="intervalTime" onclick="clickIntervalTimeRadio()"><fmt:message key="orgsync.org.synchron.timeSetting.1"/>：</label></td>
											<td>
												<select name="intervalDay" ${isStart?'':'disabled'}>
													<option value="0" ${intervalDay == '0'?'selected':''}>0</option>
													<option value="1" ${intervalDay == '1'?'selected':''}>1</option>
													<option value="2" ${intervalDay == '2'?'selected':''}>2</option>
													<option value="3" ${intervalDay == '3'?'selected':''}>3</option>
													<option value="4" ${intervalDay == '4'?'selected':''}>4</option>
													<option value="5" ${intervalDay == '5'?'selected':''}>5</option>
													<option value="6" ${intervalDay == '6'?'selected':''}>6</option>
												</select>
												<fmt:message key="orgsync.org.synchron.timeSetting.day"/>
												<select name="intervalHour" ${isStart?'':'disabled'}>
													<option value="0" ${intervalHour == '0'?'selected':''}>0</option>
													<option value="1" ${intervalHour == '1'?'selected':''}>1</option>
													<option value="2" ${intervalHour == '2'?'selected':''}>2</option>
													<option value="3" ${intervalHour == '3'?'selected':''}>3</option>
													<option value="4" ${intervalHour == '4'?'selected':''}>4</option>
													<option value="5" ${intervalHour == '5'?'selected':''}>5</option>
													<option value="6" ${intervalHour == '6'?'selected':''}>6</option>
													<option value="8" ${intervalHour == '8'?'selected':''}>8</option>
													<option value="10" ${intervalHour == '10'?'selected':''}>10</option>
													<option value="12" ${intervalHour == '12'?'selected':''}>12</option>
													<option value="24" ${intervalHour == '24'?'selected':''}>24</option>
												</select>
												<fmt:message key="orgsync.org.synchron.timeSetting.hour"/>
						        			    <select id="type" name="intervalMin" ${isStart?'':'disabled'}>
						        			      <option value="0" ${intervalMin == '0'?'selected':''}>0</option>
						        			      <option value="5" ${intervalMin == '5'?'selected':''}>5</option>
						        			      <option value="10" ${intervalMin == '10'?'selected':''}>10</option>
						        			      <option value="15" ${intervalMin == '15'?'selected':''}>15</option>
						        			      <option value="20" ${intervalMin == '20'?'selected':''}>20</option>
						        			      <option value="30" ${intervalMin == '30'?'selected':''}>30</option>
						        			      <option value="40" ${intervalMin == '40'?'selected':''}>40</option>
						        			      <option value="50" ${intervalMin == '50'?'selected':''}>50</option>
						        			      <option value="60" ${intervalMin == '60'?'selected':''}>60</option>
						        			    </select>
						        			    <fmt:message key="orgsync.org.synchron.timeSetting.min"/>
									        </td>
										</tr>
										</table>
										</td>
										</tr>
									</table>
					</fieldset>
				</td>
			</tr>
			</table>
		</td>
	</tr>		
	<tr>
		<td height="20" align="center" class="bg-advance-bottom" style="border: 0px">
			<input type="submit" name="submitButton" id="submitButton" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
			<input type="button" onclick="getA8Top().backToHome()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
</div>
<iframe name="addConfigFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>