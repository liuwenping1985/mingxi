<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript">
function OK(){
	var result =[];
	var resMap = new Set();
	
	var allcol = false;
	var colObj = document.getElementById("App_Col");
	if(colObj) allcol = colObj.checked; 
	
	var allfa = false;
	var faObj =document.getElementById("App_Fa")
	if(faObj) allfa = faObj.checked; 

	var allshou = false;
	var shouObj = document.getElementById("App_Shou");
	if(shouObj) allshou =shouObj.checked; 

	var allqian = false;
	var qianObj = document.getElementById("App_Qian");
	if(qianObj) allqian = qianObj.checked; 
	
	var allMeeting = false;
	var meetingObj = document.getElementById("App_Meeting");
	if(meetingObj) allMeeting = meetingObj.checked; 
	
	
	if(allcol) resMap.add("A___1");
	if(allfa) resMap.add("A___19");
	if(allshou) resMap.add("A___20");
	if(allqian) resMap.add("A___21");
	if(allMeeting) resMap.add("A___30");
	
	var allInput = document.getElementsByTagName("input");
	if(allInput){
		for(var i = 0 ; i < allInput.length;i++){
			if(!allInput[i].checked){
				continue;
			}
				
			var relId = allInput[i].getAttribute("relId");
			if((allcol && relId == 'App_Col')
				|| (allfa && relId == 'App_Fa')
				|| (allshou && relId == 'App_Shou')
				|| (allqian && relId == 'App_Qian')
				|| (allMeeting && relId == 'App_Meeting')
				){
				continue;
			}
			
			var name = allInput[i].getAttribute("name");
			if(!name){
				var value = allInput[i].getAttribute("value");
				resMap.add(value);
			}
		}
		
		var allValue = resMap.toArray();

		if(allValue.length != 0){
			result[0] = allValue;
		} else {
			result[0] = [];//应对portal-common.js中的统一至少选择一项的提示判断，增加代码
		}
	}
	
	return result;
}
window.onload = function(){
	var col=true; 
	var fa=true;
	var shou=true;
	var qian=true;
	var meeting=true;
	var values = parent.paramValue;
	var allInput = document.getElementsByTagName("input");
	if(allInput && values){
		// values 格式(V3.5): P19___zhihui,P20___zhihui
		// values 格式(V3.5之前): P___zhihui,P___zhihui
		values = values.split(",");
		
		for(var i = 0 ; i < allInput.length;i++){
			var value = allInput[i].getAttribute("value");
			var appName = allInput[i].getAttribute("name");
			for(var j = 0 ; j < values.length;j++){
				if(values[j] == value){
					allInput[i].checked = true;
					allInput[i].setAttribute("checked","checked");
				} 
				/**
				 * 兼容 升级 V3.5 之前的数据
				 * 例如： 升级前选中的为协同的审批(升级签为选中一个审批节点默认选中全部审批节点)，升级到 V3.5之后仍要选中叫审批的所有节点
				 *     将升级之后的数据 例：P19___zhihui，进行拆分，并组装成 P___zhihui格式与老数据P___zhihui进行匹配， 以
				 *     达到兼容V3.50之前的数据
				 */
				else 
				{	
					// 新数据拆分
					var arrNew = value.split("___"); 
					if (appName != "App" && arrNew != null) {
						var newToOld = arrNew[0].substring(0,1)+"___"+arrNew[1];
						if (newToOld == values[j]) {
							allInput[i].checked = true;
							allInput[i].setAttribute("checked","checked");
						}
					}
				}
				if (values[j] == "A___16" || values[j] == "A___22" || values[j] == "A___24" || values[j] == "A___23") {
					if(document.getElementById("app_23")){
						document.getElementById("app_23").checked = true ;
					}
				} else if (values[j] == "A___7" || values[j] == "A___8") {
					document.getElementById("app_8").checked = true ;
				}
			}	
		}
		
		for(var j = 0 ; j < values.length;j++){
			if(values[j] == "A___1"){
				col = true;
				checkAll("App_Col");
			}
			else if(values[j] == "A___19"){
				fa = true;
				checkAll("App_Fa");
			}
			else if(values[j] == "A___20"){
				shou = true;
				checkAll("App_Shou");
			}
			else if(values[j] == "A___21"){
				qian = true;
				checkAll("App_Qian");
			}
			else if(values[j] == "A___30"){
				meeting=true;
				checkAll("App_Meeting");
			}
			
		}
	}
	
	for(var i = 0 ; i < allInput.length;i++){
		var refId = allInput[i].getAttribute("relId")
		if (refId != null && refId=="App_Col" && !allInput[i].checked) {
			col=false;
		} else if (refId != null && refId=="App_Fa" && !allInput[i].checked){
			fa=false;
		} else if (refId != null && refId=="App_Shou" && !allInput[i].checked){
			shou=false;
		} else if (refId != null && refId=="App_Qian" && !allInput[i].checked){
			qian=false;
		} else if (refId != null && refId=="App_Meeting" && !allInput[i].checked){
			meeting=false;
		}
	}
	var colObj =document.getElementById("App_Col");
	if (col && colObj )
		colObj.checked=true;
	var faObj = document.getElementById("App_Fa") ;
	if (fa && faObj)
		faObj.checked=true;

	var shouObj = document.getElementById("App_Shou");
	if (shou && shouObj)
		shouObj.checked=true;

	var qianObj  = document.getElementById("App_Qian");
	if (qian && qianObj)
		qianObj.checked=true;
	
	var meetingObj  = document.getElementById("App_Meeting");
	if (meeting && meetingObj)
		meetingObj.checked=true;
}

function checkAll(relId){
	var selectAll = document.getElementById(relId);
	var allInput = document.getElementsByTagName("input");
	if(allInput){
		for(var i = 0 ; i < allInput.length;i++){
			var rId = allInput[i].getAttribute("relId");
			if(rId == relId){
				allInput[i].checked = selectAll.checked;
				allInput[i].setAttribute("chekced",selectAll.checked);
			}
		}
	}
}
function setNoCheckAll(args) {
	var theRelId = args.getAttribute("relId");
	if(!args.checked){
		document.getElementById(theRelId).checked = false;
	}
	else{
		var isAllChecked = true;
		var allInput = document.getElementsByTagName("input");
		if(allInput){
			for(var i = 0 ; i < allInput.length;i++){
				var rId = allInput[i].getAttribute("relId");
				if(theRelId == rId && !allInput[i].checked){
					isAllChecked = false;
					break;
				}
			}
		}
		
		document.getElementById(theRelId).checked = isAllChecked;
	}
}
</script>
</head>
<body srcoll="no" style="overflow: auto">
<div class="scrollList" id="scrollListDiv">
<c:set value="${v3x:currentUser().internal}" var="isInternal" />
<table align="center" width="100%" border="0" class="padding_t_5">
	<tr>
	<c:if test="${ctp:hasPlugin('collaboration')}">
	<td width="50%" height="100%" valign="top">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Col">
	 						<input type="checkbox" id="App_Col" name="App" onclick="checkAll('App_Col')" value="A___1" ><span class="padding_l_5">${ctp:i18n('application.1.label')}</span>
	 					</label>
					</legend>
					<table width="100%" style="border-spacing: 5px;">
						<tr>
						<c:forEach items="${listCol}" var="col" varStatus="status">
							<td>
							<label for="${col.flowPermId}"><input type="checkbox" relId="App_Col" onclick="setNoCheckAll(this)" id="${col.flowPermId}" name="" value="P1___${col.name}" ><span class="padding_l_5">${col.label}</span></label>
							</td>
							<c:if test="${status.index%2!=0}">
  							</tr>
							<tr>
							</c:if>
						</c:forEach>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
	</td>
	</c:if>
	<c:if test="${ctp:hasPlugin('edoc')}">
	<td width="50%" height="100%" valign="top">
		<c:if test="${isInternal}">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Fa">
	 						<input type="checkbox" id="App_Fa" name="App"  onclick="checkAll('App_Fa')" value="A___19" ><span class="padding_l_5">${ctp:i18n('application.19.label')}</span>
	 					</label>
					</legend>
					<table width="100%" style="border-spacing: 5px;">
						<tr>
						<c:forEach items="${listFa}" var="col" varStatus="status">
							<td>
							<label for="${col.flowPermId}"><input type="checkbox"  relId="App_Fa" id="${col.flowPermId}" onclick="setNoCheckAll(this);" name="" value="P19___${col.name}" ><span class="padding_l_5">${col.label}</span></label>
							</td>
							<c:if test="${status.index%2!=0}">
  							</tr>
							<tr>
							</c:if>
						</c:forEach>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
		</c:if>
	</td>
	</c:if>
	</tr>
	<tr>
	<c:if test="${ctp:hasPlugin('edoc')}">
	<td width="50%" height="100%" valign="top" class="padding_t_5">
		<c:if test="${isInternal}">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Shou">
	 						<input type="checkbox" id="App_Shou" name="App"  onclick="checkAll('App_Shou')" value="A___20" ><span class="padding_l_5">${ctp:i18n('application.20.label')}</span>
	 					</label>
					</legend>
					<table width="100%" style="border-spacing: 5px;">
						<tr>
						<c:forEach items="${listShou}" var="col" varStatus="status">
							<td>
							<label for="${col.flowPermId}"><input type="checkbox" relId="App_Shou" id="${col.flowPermId}" onclick="setNoCheckAll(this);" name="" value="P20___${col.name}" ><span class="padding_l_5">${col.label}</span></label>
							</td>
							<c:if test="${status.index%2!=0}">
  							</tr>
							<tr>
							</c:if>
						</c:forEach>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
		</c:if>
	</td>
	</c:if>
	<c:if test="${ctp:hasPlugin('edoc')}">
	<td width="50%" height="100%" valign="top" class="padding_t_5">
		<c:if test="${isInternal}">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Qian">
	 						<input type="checkbox" id="App_Qian" name="App" value="A___21" onclick="checkAll('App_Qian')" ><span class="padding_l_5">${ctp:i18n('application.21.label')}</span>
	 					</label>
					</legend>
					<table width="100%" style="border-spacing: 5px;">
						<tr>
						<c:forEach items="${listQian}" var="col" varStatus="status">
							<td>
							<label for="${col.flowPermId}"><input type="checkbox" onclick="setNoCheckAll(this);" relId="App_Qian" id="${col.flowPermId}" name="" value="P21___${col.name }" ><span class="padding_l_5">${col.label}</span></label>
							</td>
							<c:if test="${status.index%2!=0}">
  							</tr>
							<tr>
							</c:if>
						</c:forEach>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
		</c:if>
	</td>
	</c:if>
	</tr>
	<tr>
		<%--会议 --%>
		<td width="50%" height="100%" valign="top">
			<table border="0" width="100%" cellspacing="10" cellpadding="0">
				<tr>
					<td>
					<fieldset>
						<legend>
		 					<label for="App_Meeting">
		 						<input type="checkbox" id="App_Meeting" name="meeting"  onclick="checkAll('App_Meeting')" value="A___30" ><span class="padding_l_5">${ctp:i18n('application.6.label')}</span>
		 					</label>
						</legend>
						<table width="100%" style="border-spacing: 5px;">
							<tr>
								<td><%--会议 通知--%>
									<label for="app_6">
										<input type="checkbox" relId="App_Meeting" onclick="setNoCheckAll(this);" value="A___6" id="app_6">
	                                    <span class="padding_l_5">${ctp:i18n('collaboration.pending.meetingNotice.label')}</span>
									</label>
								</td>
								<td><%--会议室审核--%>
									<label for="app_29">
										<input type="checkbox" relId="App_Meeting" onclick="setNoCheckAll(this);" value="A___29" id="app_29">
	                                    <span class="padding_l_5">${ctp:i18n('collaboration.pending.meetingRoom.label')}</span>
									</label>
								</td>
							</tr>
						</table>
					</fieldset>
					</td>
				</tr>
			</table>
		</td>
		<%--其它 --%>
		<td width="50%" height="100%" valign="top" class="padding_t_5">
			<table border="0" width="100%" cellspacing="10" cellpadding="0">
				<tr>
					<td>
					<fieldset>
						<legend>
		 					<label for="App_Other">
		 						<b>${ctp:i18n('common.other.label')}<fmt:message key="common.other.label" bundle="${v3xCommonI18N}" /></b>
		 					</label>
						</legend>
						<table width="100%" style="border-spacing: 5px;">
							<tr>
								<td><%--待填写调查 --%>
									<label for="app_10">
										<input type="checkbox" relId="App_Other" value="A___10___1" id="app_10">
										<span class="padding_l_5">${ctp:i18n('common.inquiry.approval')}</span>
									</label>
								</td>
								<c:if test="${isInternal}">
									<td><%--公文交换 --%>
										<label for="app_23">
											<input type="checkbox"  relId="App_Other" value="A___23" id="app_23">
											<span class="padding_l_5">${ctp:i18n('common.edoc.doc.exchange')}</span>
										</label>
									</td>
								</c:if>
							</tr>
							
							<tr>
								<td><%--公共信息审批 --%>
									<label for="app_8">
										<input type="checkbox"  relId="App_Other" value="A___8" id="app_8">
										<span class="padding_l_5">${ctp:i18n('common.public.info.approval')}</span>
									</label>
								</td>
								<td><%--综合办公审批 --%>
									<label for="app_26">
										<input type="checkbox"  relId="App_Other" value="A___26" id="app_26">
										<span class="padding_l_5">${ctp:i18n('common.office.audit')}</span>
									</label>
								</td>
							</tr>
							
						</table>
					</fieldset>
					</td>
				</tr>
			</table>
		</td>
	
	</tr>
</table>
</div>
</body>
</html>