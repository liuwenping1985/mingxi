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
	
	var allInfo = false;
	var infoObj = document.getElementById("App_Info");
	if(infoObj) allInfo = infoObj.checked; 
	
	if(allcol) resMap.add("A___1");
	if(allfa) resMap.add("A___19");
	if(allshou) resMap.add("A___20");
	if(allqian) resMap.add("A___21");
	if(allMeeting) resMap.add("A___30");
	if(allInfo) resMap.add("A___32");
	
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
				|| (allMeeting && relId == 'App_Info')
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
	var info = true;
	var values = window.parentDialogObj["setPanelValue_id"].getTransParams();
	var isOpenBanwenYuewen="${showBanwenYuewen}";
	var allInput = document.getElementsByTagName("input");
	if(allInput && values){
		// values 格式(V3.5): P19___zhihui,P20___zhihui
		// values 格式(V3.5之前): P___zhihui,P___zhihui
		values = values.split(",");
		
		for(var i = 0 ; i < allInput.length;i++){
			var value = allInput[i].getAttribute("value");
			var allValueTemp="";
			var appName = allInput[i].getAttribute("name");

			for(var j = 0 ; j < values.length;j++){
				var valueTemp=values[j];
				if(isOpenBanwenYuewen=="false"&&valueTemp.indexOf("P20")!=-1){
					if(valueTemp.lastIndexOf("_ban")==(valueTemp.length-4)||valueTemp.lastIndexOf("_yue")==(valueTemp.length-4)){
						var banStr=valueTemp.substring(0,valueTemp.length-4);
						if(allValueTemp.indexOf(banStr)==-1){
							valueTemp=valueTemp.substring(0,valueTemp.length-4);
						}else if(allValueTemp.indexOf(yueStr)==-1){
							valueTemp=valueTemp.substring(0,valueTemp.length-4);
						}
					}
				}
				allValueTemp+=valueTemp+",";
				if(valueTemp == value){
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
				$("#yuewenDiv :checkbox").attr("checked", true);
				$("#banwenDiv :checkbox").attr("checked", true);
			}
			else if(values[j] == "A___21"){
				qian = true;
				checkAll("App_Qian");
			}
			else if(values[j] == "A___30"){
				meeting=true;
				checkAll("App_Meeting");
			}
			else if(values[j] == "A___32"){
				info=true;
				checkAll("App_Info");
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
		} else if (refId != null && refId=="App_Info" && !allInput[i].checked){
			info=false;
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
		
	var infoObj  = document.getElementById("App_Info");
	if (info && infoObj)
		infoObj.checked=true;
		
	$("span[name=stylecomp]").css("display","inline");
	//绑定办文按钮
	$("#banSpan").bind("click",function(){
		if($("#banSpan").attr('class')=='ico16 arrow_2_b'){
			$("#banSpan").removeClass("ico16 arrow_2_b");
	 		$("#banSpan").addClass("ico16 arrow_2_t");
		}else{
			$("#banSpan").removeClass("ico16 arrow_2_t");
	 		$("#banSpan").addClass("ico16 arrow_2_b");
		}
	 	$("#banwenDiv").slideToggle();
	 	
	});
	//绑定阅文按钮
	$("#yueSpan").bind("click",function(){
		if($("#yueSpan").attr('class')=='ico16 arrow_2_b'){
			$("#yueSpan").removeClass("ico16 arrow_2_b");
	 		$("#yueSpan").addClass("ico16 arrow_2_t");
		}else{
			$("#yueSpan").removeClass("ico16 arrow_2_t");
	 		$("#yueSpan").addClass("ico16 arrow_2_b");
		}
		$("#yuewenDiv").slideToggle();
	});
	$("#yuewenInput").bind("click",function(){
		if($("#yuewenInput").attr("checked")=="checked"){
			$("#yuewenDiv :checkbox").attr("checked", true);
		}else{
			$("#yuewenDiv :checkbox").attr("checked", false);
		}
		//判断“收文”项是否应该勾选或者取消
		var theRelId=this.getAttribute("relId");
		this.setAttribute("relId","App_Shou");
		setNoCheckAll(this);
		this.setAttribute("relId",theRelId);
	});
	$("#banwenInput").bind("click",function(){
		if($("#banwenInput").attr("checked")=="checked"){
			$("#banwenDiv :checkbox").attr("checked", true);
		}else{
			$("#banwenDiv :checkbox").attr("checked", false);
		}
		//判断“收文”项是否应该勾选或者取消
		var theRelId=this.getAttribute("relId");
		this.setAttribute("relId","App_Shou");
		setNoCheckAll(this);
		this.setAttribute("relId",theRelId);
	});
	var shouWenCount="${shouSize}";//收文的节点权限个数
	if($("#banwenDiv :checked").size() == shouWenCount){
		$("#banwenInput").attr("checked",true);
	}

	if($("#yuewenDiv :checked").size() == shouWenCount){
		$("#yuewenInput").attr("checked",true);
	}
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
	//如果是收文 需要分别设置 办文 和 阅文
	if(relId=="App_Shou"){
		$("#banwenDiv :checkbox").attr("checked", selectAll.checked);
		$("#yuewenDiv :checkbox").attr("checked", selectAll.checked);
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
	if(theRelId=="banwenInput"||theRelId=="yuewenInput"){
		//判断“收文”项是否应该勾选或者取消
		args.setAttribute("relId","App_Shou");
		setNoCheckAll(args);
		args.setAttribute("relId",theRelId);
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
							<label for="${col.flowPermId}" title="${col.label}"><input type="checkbox" relId="App_Col" onclick="setNoCheckAll(this)" id="${col.flowPermId}" name="" value="P1___${col.name}" ><span class="padding_l_5" name='stylecomp'></span>${v3x:getLimitLengthString(col.label,12,'...')}</label>
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
	<c:if test="${ctp:hasPlugin('edoc')}"><c:if test ="${(v3x:getSysFlagByName('edoc_notShow')!='true')}">
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
							<label for="${col.flowPermId}" title="${col.label}"><input type="checkbox"  relId="App_Fa" id="${col.flowPermId}" onclick="setNoCheckAll(this);" name="" value="P19___${col.name}" ><span class="padding_l_5" name='stylecomp'></span>${v3x:getLimitLengthString(col.label,12,'...')}</label>
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
	</c:if></c:if>
	</tr>
	<tr>
	<c:if test="${ctp:hasPlugin('edoc')}"><c:if test ="${(v3x:getSysFlagByName('edoc_notShow')!='true')}">
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
						<!--关闭了区分阅文、办文开关  -->
						<c:if test="${!showBanwenYuewen}">
							<c:if test="${isG6Version and isOpenRegister and openFrom eq 'pendingSection'}">
								<!--G6登记 -->
								<tr>
									<td>
										<label for="11111"><input type="checkbox" relId="App_Shou" id="11111" onclick="setNoCheckAll(this);" name="" value="P20___regist" ><span class="padding_l_5" name='stylecomp'></span>${ctp:i18n('node.policy.regist')}</label>
									</td>
								</tr>
							</c:if>
							<tr>
							<c:forEach items="${listShou}" var="col" varStatus="status">
								<td>
								<label for="${col.flowPermId}" title="${col.label}"><input type="checkbox" relId="App_Shou" id="${col.flowPermId}" onclick="setNoCheckAll(this);" name="" value="P20___${col.name}" ><span class="padding_l_5" name='stylecomp'></span>${v3x:getLimitLengthString(col.label,12,'...')}</label>
								</td>
								<c:if test="${status.index%2!=0}">
	  							</tr>
								<tr>
								</c:if>
							</c:forEach>
							</tr>
						</c:if>
						<!--开启了区分阅文、办文开关  -->
						<c:if test="${showBanwenYuewen}">
							<c:if test="${isG6Version and isOpenRegister and openFrom eq 'pendingSection'}">
								<!--G6登记 -->
								<tr>
									<td>
										<label for="11111"><input type="checkbox" relId="App_Shou" id="11111" onclick="setNoCheckAll(this);" name="" value="P20___regist" ><span class="padding_l_5" name='stylecomp'></span>${ctp:i18n('node.policy.regist')}</label>
									</td>
								</tr>
							</c:if>
							<!--A8登记，G6分发 -->
							<c:if test="${openFrom eq 'pendingSection'}">
								<tr>
									<td>
										<label for="${dengjiPerm.flowPermId}" title="${dengjiPerm.label}"><input type="checkbox" relId="App_Shou" id="${dengjiPerm.flowPermId}" onclick="setNoCheckAll(this);" name="" value="P20___${dengjiPerm.name}" ><span class="padding_l_5" name='stylecomp'></span>${v3x:getLimitLengthString(dengjiPerm.label,12,'...')}</label>
									</td>
								</tr>
							</c:if>
							<!--办文 -->
							<tr>
								<td>
									<label for="banwenLabel">
										<input type="checkbox" relId="App_Shou" id="banwenInput" onclick="" name="banwenInput" value="办文" ><span class="padding_l_5" name='stylecomp'>${ctp:i18n('col.process.type.BW')}</span>
									</label>
									<span id="banSpan" class="ico16 arrow_2_b"></span>
								</td>
							</tr>

							<tr>
								<td>
								<div id="banwenDiv" style="display:none">
									<table>
										<tr>
										<c:forEach items="${listShou}" var="col" varStatus="status">
											<td>
												<label for="${col.flowPermId}" title="${col.label}"><input type="checkbox" relId="banwenInput" id="${col.flowPermId}" onclick="setNoCheckAll(this);" name="" value="P20___${col.name}_ban" ><span class="padding_l_5" name='stylecomp'></span>${v3x:getLimitLengthString(col.label,12,'...')}</label>
											</td>
											<c:if test="${status.index%2!=0}">
												</tr>
												<tr>
					  						</c:if>
										</c:forEach>
										</tr>
									</table>
								</div>
								</td>
							</tr>
							
							<!--阅文 -->
							<tr>
								<td>
									<label for="yuewenLabel">
										<input type="checkbox" relId="App_Shou" id="yuewenInput" onclick="" name="yuewenInput" value="办文" ><span class="padding_l_5" name='stylecomp'>${ctp:i18n('edoc.read')}</span>
									</label>
									<span id="yueSpan" class="ico16 arrow_2_b"></span>
								</td>
							</tr>
							
							<tr>
								<td>
								<div id="yuewenDiv" style="display:none">
									<table>
										<tr>
										<c:forEach items="${listShou}" var="col" varStatus="status">
											<td>
												<label for="${col.flowPermId}" title="${col.label}"><input type="checkbox" relId="yuewenInput" id="${col.flowPermId}" onclick="setNoCheckAll(this);" name="" value="P20___${col.name}_yue" ><span class="padding_l_5" name='stylecomp'></span>${v3x:getLimitLengthString(col.label,12,'...')}</label>
											</td>
											<c:if test="${status.index%2!=0}">
												</tr>
												<tr>
					  						</c:if>
										</c:forEach>
										</tr>
									</table>
								</div>
								</td>
							</tr>
							
						</c:if>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
		</c:if>
	</td>
	</c:if></c:if>
		<c:if test="${ctp:hasPlugin('edoc')}"><c:if test ="${(v3x:getSysFlagByName('edoc_notShow')!='true')}">
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
							<label for="${col.flowPermId}" title="${col.label}"><input type="checkbox" onclick="setNoCheckAll(this);" relId="App_Qian" id="${col.flowPermId}" name="" value="P21___${col.name }" ><span class="padding_l_5" name='stylecomp'></span>${v3x:getLimitLengthString(col.label,12,'...')}</label>
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
	</c:if></c:if>
	   <%-- 信息报送(待办、跟踪栏目不显示信息报送) --%>
		<c:if test="${isG6Version && ctp:hasPlugin('infosend') && !(param.type ne null && param.type ne '') && param.openFrom != 'doneSection'}">
			<tr>
			<td width="50%" height="100%" valign="top">
				<table border="0" width="100%" cellspacing="10" cellpadding="0">
					<tr>
						<td>
						<fieldset>
							<legend>
			 					<label for="App_Info">
			 						<input type="checkbox" id="App_Info" name="info"  onclick="checkAll('App_Info')" value="A___32" ><span class="padding_l_5">${ctp:i18n('application.32.label')}</span>
			 					</label>
							</legend>
							<table width="100%" style="border-spacing: 5px;">
								<tr>
									<td><%--待审核信息--%>
										<label for="app_32">
											<input type="checkbox" relId="App_Info" onclick="setNoCheckAll(this);" value="A___32___0" id="app_0">
		                                    <span class="padding_l_5">${ctp:i18n('infosend.pending.information')}</span>
										</label>
									</td>
									<c:if test="${openFrom ne 'trackSection' }">
										<td><%--待审核期刊--%>
											<label for="app_32">
												<input type="checkbox" relId="App_Info" onclick="setNoCheckAll(this);" value="A___32___2" id="app_2">
			                                    <span class="padding_l_5">${ctp:i18n('infosend.pending.journal')}</span>
											</label>
										</td>
									</c:if>
								</tr>
								<c:if test="${openFrom ne 'trackSection' }">
									<tr>
										<td><%--待发布期刊--%>
											<label for="app_32">
												<input type="checkbox" relId="App_Info" onclick="setNoCheckAll(this);" value="A___32___3" id="app_3">
			                                    <span class="padding_l_5">${ctp:i18n('infosend.journals.published')}</span>
											</label>
										</td>
										<td></td>
									</tr>
								</c:if>
							</table>
						</fieldset>
						</td>
					</tr>
				</table>
			</td>
			<td>
			</td>
			</tr>
		</c:if>
		
	
	</tr>
	<tr>
		<%--会议 已办不显示--%>
		<c:if test="${ctp:hasPlugin('meeting') && !(param.type ne null && param.type ne '')  && openFrom ne 'trackSection'}">
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
		                                    <span class="padding_l_5"></span>${ctp:i18n('collaboration.pending.meetingNotice.label')}
										</label>
									</td>
									<c:if test ="${(v3x:getSysFlagByName('edoc_notShow')!='true')}">
									<td><%--会议室审核--%>
										<label for="app_29">
											<input type="checkbox" relId="App_Meeting" onclick="setNoCheckAll(this);" value="A___29" id="app_29">
		                                    <span class="padding_l_5"></span>${ctp:i18n('collaboration.pending.meetingRoom.label')}
										</label>
									</td>
									</c:if>
								</tr>
							</table>
						</fieldset>
						</td>
					</tr>
				</table>
			</td>
		</c:if>
			<%--其它 已办不显示--%>
        <c:if test="${!(param.type ne null && param.type ne '') && openFrom ne 'doneSection' && openFrom ne 'trackSection'}">
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
                                <c:if test="${openFrom == 'pendingSection'}">
								<td><%--待填写调查 --%>
									<label for="app_10">
										<input type="checkbox" relId="App_Other" value="A___10___1" id="app_10">
										<span class="padding_l_5"></span>${ctp:i18n('common.inquiry.approval')}
									</label>
								</td>
                                </c:if>
								<!--<c:if test="${isInternal}"><c:if test ="${(v3x:getSysFlagByName('edoc_notShow')!='true')}">
									<td><%--公文交换 --%>
										<label for="app_23">
											<input type="checkbox"  relId="App_Other" value="A___16" id="app_23">
											<span class="padding_l_5"></span>${ctp:i18n('common.edoc.doc.exchange')}
										</label>
									</td>
								</c:if></c:if>-->
							</tr>
							
							<tr>
                                <c:if test="${openFrom == 'pendingSection'}">
								<td><%--公共信息审批 --%>
									<label for="app_8">
										<input type="checkbox"  relId="App_Other" value="A___8" id="app_8">
										<span class="padding_l_5"></span>${ctp:i18n('common.public.info.approval')}
									</label>
								</td>
								<td><%--综合办公审批 --%>
									<label for="app_26">
										<input type="checkbox"  relId="App_Other" value="A___26" id="app_26">
										<span class="padding_l_5"></span>${ctp:i18n('common.office.audit')}
									</label>
								</td>
                                </c:if>
							</tr>
							
						</table>
					</fieldset>
					</td>
				</tr>
			</table>
		</td>
	   </c:if>
	</tr>
</table>
</div>
</body>
</html>