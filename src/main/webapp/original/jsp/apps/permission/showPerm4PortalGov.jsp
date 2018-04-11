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
	
	var allcol = document.getElementById("App_Col");
	if(allcol){
		allcol=allcol.checked;
	}
	var allfa = document.getElementById("App_Fa");
	if(allfa){
		allfa=allfa.checked;
	}
	var allshou = document.getElementById("App_Shou");
	if(allshou){
		allshou=allshou.checked;
	}
	var allqian = document.getElementById("App_Qian");
	if(allqian){
		allqian=allqian.checked;
	}
	var banwen = document.getElementById("banwen");
	if(banwen){
		banwen=banwen.checked;
	}
	var yuewen = document.getElementById("yuewen");
	if(yuewen){
		yuewen=yuewen.checked;
	}
	var info = document.getElementById("App_Info");
	if(info){
		info=info.checked
	}
	var zhbg = document.getElementById("App_Office");
	if(zhbg){
		zhbg=zhbg.checked
	}
	var meeting = document.getElementById("App_Meeting");
	if(meeting){
		meeting=meeting.checked;
	}
	
	if(allcol) resMap.add("A___1");
	if(allfa){
		resMap.add("A___19");//发文
		resMap.add("A___16");//交换
		resMap.add("A___22");//分发==待发送
	}
	if(allshou){
		resMap.add("A___20");
		resMap.add("A___23");//签收
		resMap.add("A___24");//登记
		resMap.add("A___34");//分发
	}
	if(allqian) resMap.add("A___21");
	if(info) resMap.add("A___32");
	if(meeting) resMap.add("A___6");
	
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
				|| (banwen && relId == 'banwen')
				|| (yuewen && relId == 'yuewen')
				|| (info && relId == 'App_Info')
				|| (zhbg && relId == 'App_Office')
				|| (meeting && relId == 'App_Meeting')
				){
				continue;
			}
			
			var name = allInput[i].getAttribute("name");
			if(!name){
				var value = allInput[i].getAttribute("value");
				if(!value){
					continue;
				}
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
	var banwen=true;
	var yuewen=true;
	var info=true;
	var zhbg=true;
	var meeting=true;
	var values = parent.paramValue;
	var allInput = document.getElementsByTagName("input");
	if(allInput && values){
		// values 格式(V3.5): P19___zhihui,P20___zhihui
		// values 格式(V3.5之前): P___zhihui,P___zhihui
		values = values.split(",");
		
		for(var i = 0 ; i < allInput.length;i++){
			var value = allInput[i].getAttribute("value");
			for(var j = 0 ; j < values.length;j++){
				if(values[j] == value){
					allInput[i].checked = true;
					allInput[i].setAttribute("checked","checked");
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
			}else if (values[j] == "S9___all"){
				banwen = true;
				checkAll("banwen");
			}else if (values[j] == "S10___all"){
				yuewen = true;
				checkAll("yuewen");
			}else if (values[j] == "A___32"){
				info = true;
				checkAll("App_Info");
			}else if (values[j] == "A___26"){
				zhbg = true;
				checkAll("App_Office");
			}else if (values[j] == "A___6"){
				meeting = true;
				checkAll("App_Meeting");
			}
		}
	}
	//保留 当用户新增节点权限时，只查以前勾选的
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
		} else if (refId != null && refId=="banwen" && !allInput[i].checked){
			banwen=false;
		} else if (refId != null && refId=="yuewen" && !allInput[i].checked){
			yuewen=false;
		} else if (refId != null && refId=="App_Info" && !allInput[i].checked){
			info=false;
		} else if (refId != null && refId=="App_Office" && !allInput[i].checked){
			zhbg=false;
		} else if (refId != null && refId=="App_Meeting" && !allInput[i].checked){
			meeting=false;
		}
	}
	
	if (col)
		var app_col=document.getElementById("App_Col");
		if(app_col){
			document.getElementById("App_Col").checked=true;
		}
	if (fa)
		var app_fa=document.getElementById("App_Fa");
		if(app_fa){
			document.getElementById("App_Fa").checked=true;
		}
	if (shou)
		var show=document.getElementById("App_Shou");
		if(show){
			document.getElementById("App_Shou").checked=true;
		}
	if (qian)
		var app_qian=document.getElementById("App_Qian");
		if(app_qian){
			document.getElementById("App_Qian").checked=true;
		}
	if (banwen)
		var banwen=document.getElementById("banwen");
		if(banwen){
			document.getElementById("banwen").checked=true;
		}
	if (yuewen)
		var yuewen=document.getElementById("yuewen");
		if(yuewen){
			document.getElementById("yuewen").checked=true;
		}
	if (info)
		var app_info=document.getElementById("App_Info");
		if(app_info){
			document.getElementById("App_Info").checked=true;
		}
	if (zhbg)
		var app_office=document.getElementById("App_Office");
		if(app_office){
			document.getElementById("App_Office").checked=true;
		}
	if (meeting)
		var app_meeting=document.getElementById("App_Meeting");
		if(app_meeting){
			document.getElementById("App_Meeting").checked=true;
		}
}

function checkAll(relId){
	if(!relId){
		return;
	}
	var selectAll = document.getElementById(relId);
	if(!selectAll || selectAll.getAttribute("id") == selectAll.getAttribute("relId")){
		//结束递归 当id==relId时退出，防止无限递归
		return;
	}
	var allInput = document.getElementsByTagName("input");
	if(allInput){
		for(var i = 0 ; i < allInput.length;i++){
			var rId = allInput[i].getAttribute("relId");
			if(rId == relId){
				allInput[i].checked = selectAll.checked;
				allInput[i].setAttribute("chekced",selectAll.checked);
				var id = allInput[i].getAttribute("id");
				if(id){
					checkAll(id);//递归
				}
			}
		}
	}
}

function setNoCheckAll(args) {
	if(!args){
		return;
	}
	if(!args.getAttribute("relId") || args.getAttribute("id") == args.getAttribute("relId")){
		//结束递归 当id==relId时退出，防止无限递归
		return;
	}
	var allCheck = true;
	var allId = args.getAttribute("relId");
	if(args.checked == false){
		allCheck = false;
	}else{
		var allInput = document.getElementsByTagName("input");
		for(var i = 0 ; i < allInput.length;i++){
			var rId = allInput[i].getAttribute("relId");
			var id = allInput[i].getAttribute("id");
			if(rId == allId){
				if(allInput[i].checked == false){
					allCheck = false;
					break;
				}else{
					continue;
				}
			}
		}
	}
	var allItem = document.getElementById(allId);
	allItem.checked = allCheck;
	setNoCheckAll(allItem);//递归
}

function showNode(tableid){
	var t = document.getElementById(tableid);
	if(t.style.display == "none"){
		t.style.display="block";
	}else{
		t.style.display="none";
	}
	return false;
}
</script>
<style>
fieldset label{word-break:break-all;}
</style>
</head>
<body srcoll="no" style="overflow: auto">
<div class="scrollList" id="scrollListDiv">
<c:set value="${v3x:currentUser().internal}" var="isInternal" />
<table align="center" width="100%" border="0">
	<tr>
	<td width="50%" height="100%" valign="top">
		<c:if test="${isInternal}">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Fa">
	 						<input type="checkbox" id="App_Fa" onClick="checkAll('App_Fa')" value="A___19" ><b><fmt:message key="application.19.label" bundle="${v3xCommonI18N}" /></b>
	 					</label>
					</legend>
					<table width="100%">
						<tr>
							<td width="50%">
							<label><input type="checkbox"  relId="App_Fa"  onclick="setNoCheckAll(this);" name="" value="A___16" ><fmt:message key="application.16.label" bundle="${v3xCommonI18N}" /></label>
							</td><td>
							<label><input type="checkbox"  relId="App_Fa"  onclick="setNoCheckAll(this);" name="" value="A___22" ><fmt:message key="edoc.element.receive.distribute" bundle="${edocI18N}" /></label>
							</td>
						</tr>
						<tr>
						<c:forEach items="${listFa}" var="col" varStatus="status">
							<c:choose>
								<c:when test='${col.type==0}' >
									<fmt:message key="${col.label}"  bundle="${v3xCommonI18N}" var="name" />
								</c:when>
								<c:when test='${col.type==1}' >
									<c:set value = "${col.name}" var="name" />
								</c:when>
							</c:choose>
							<td>
							<label for="${col.flowPermId}"><input type="checkbox"  relId="App_Fa" onClick="setNoCheckAll(this);" name="" value="P19___${col.name}" >${name}</label>
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
	<td width="50%" height="100%" valign="top" rowspan="2">
		<c:if test="${isInternal}">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Shou">
	 						<input type="checkbox" id="App_Shou" onClick="checkAll('App_Shou')" value="A___20" ><b><fmt:message key="application.20.label" bundle="${v3xCommonI18N}" /></b>
	 					</label>
					</legend>
					<table width="100%">
						<tr>
							<td width="50%">
							<label><input type="checkbox"  relId="App_Shou"  onclick="setNoCheckAll(this);" name="" value="A___23" ><fmt:message key="pending.exSign.label.1" bundle="${v3xMainI18N}" /></label>
							</td>
						</tr><tr>
							<td>
							<label><input type="checkbox"  relId="App_Shou"  onclick="setNoCheckAll(this);" name="" value="A___24" ><fmt:message key="edoc.new.type.rec" bundle="${edocI18N}" /></label>
							</td>
						</tr><tr>
							<td>
							<label><input type="checkbox"  relId="App_Shou"  onclick="setNoCheckAll(this);" name="" value="A___34" ><fmt:message key="edoc.element.receive.distribute" bundle="${edocI18N}" /></label>
							</td>
						</tr><tr>
							<td>
							<input type="checkbox" onClick="checkAll('banwen');setNoCheckAll(this);" relId="App_Shou" id="banwen" name="" value="S9___all" /><label><span onClick="showNode('banwenTable');" style="cursor:pointer;"><fmt:message key="edoc.banwen" bundle="${edocI18N}" /><span class="menu_more_sub2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></label>
								<table id="banwenTable" style="display:none;"  width="100%">
									<tr>
									<c:set value="0" var="status1" />
									<c:forEach items="${listShou}" var="col">
									<c:if test="${col.name != 'dengji'}">
										<c:choose>
											<c:when test='${col.type==0}' >
												<fmt:message key="${col.label}"  bundle="${v3xCommonI18N}" var="name" />
											</c:when>
											<c:when test='${col.type==1}' >
												<c:set value = "${col.name}" var="name" />
											</c:when>
										</c:choose>
										<td>
										<label for="${col.flowPermId}"><input type="checkbox" relId="banwen" onClick="setNoCheckAll(this);" name="" value="S9___${col.name}" >${name}</label>
										</td>
										<c:if test="${status1%2!=0}">
  										</tr>
										<tr>
										</c:if>
										<c:set value="${status1 + 1}" var="status1" />
									</c:if>
									</c:forEach>
									</tr>
								</table>
							
							</td>
						</tr><tr>
							<td>
							<input type="checkbox" relId="App_Shou" id="yuewen" onClick="checkAll('yuewen');setNoCheckAll(this);" name="" value="S10___all" /><label><span style="cursor:pointer;" onClick="showNode('yuewenTable');"><fmt:message key="edoc.read" bundle="${edocI18N}" /><span class="menu_more_sub2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></label>
								<table id="yuewenTable" style="display:none;" width="100%">
									<tr>
									<c:set value="0" var="status2" />
									<c:forEach items="${listShou}" var="col">
									<c:if test="${col.name != 'dengji'}">
										<c:choose>
											<c:when test='${col.type==0}' >
												<fmt:message key="${col.label}"  bundle="${v3xCommonI18N}" var="name" />
											</c:when>
											<c:when test='${col.type==1}' >
												<c:set value = "${col.name}" var="name" />
											</c:when>
										</c:choose>
										<td>
										<label for="${col.flowPermId}"><input type="checkbox" relId="yuewen" onClick="setNoCheckAll(this);" name="" value="S10___${col.name}" >${name}</label>
										</td>
										<c:if test="${status2%2!=0}">
  										</tr>
										<tr>
										</c:if>
										<c:set value="${status2 + 1}" var="status2" />
									</c:if>
									</c:forEach>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
		</c:if>
	</td>
	</tr>
	<tr>
	<td width="50%" height="100%" valign="top">
		<c:if test="${isInternal}">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Qian">
	 						<input type="checkbox" id="App_Qian" name="" value="A___21" onClick="checkAll('App_Qian')" ><b><fmt:message key="application.21.label" bundle="${v3xCommonI18N}" /></b>
	 					</label>
					</legend>
					<table width="100%">
						<tr>
						<c:forEach items="${listQian}" var="col" varStatus="status">
							<c:choose>
								<c:when test='${col.type==0}' >
									<fmt:message key="${col.label}"  bundle="${v3xCommonI18N}" var="name" />
								</c:when>
								<c:when test='${col.type==1}' >
									<c:set value = "${col.name}" var="name" />
								</c:when>
							</c:choose>
							<td width="50%">
							<label for="${col.flowPermId}"><input type="checkbox" onClick="setNoCheckAll(this);" relId="App_Qian" name="" value="P21___${col.name }" >${name}</label>
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
	</tr>
	<tr>
	<td width="50%" height="100%" valign="top">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Col">
	 						<input type="checkbox" id="App_Col" name="" onClick="checkAll('App_Col')" value="A___1" ><b><fmt:message key="application.1.label" bundle="${v3xCommonI18N}" /></b>
	 					</label>
					</legend>
					<table width="100%">
						<tr>
						<c:forEach items="${listCol}" var="col" varStatus="status">
							<c:choose>
								<c:when test='${col.type==0}' >
									<fmt:message key="${col.label}"  bundle="${v3xCommonI18N}" var="name" />
								</c:when>
								<c:when test='${col.type==1}' >
									<c:set value = "${col.name}" var="name" />
								</c:when>
							</c:choose>
							<td width="50%">
							<label for="${col.flowPermId}"><input type="checkbox" relId="App_Col" onClick="setNoCheckAll(this)" name="" value="P1___${col.name}" >${name}</label>
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
	<td width="50%" height="100%" valign="top">
		<c:if test="${isInternal}">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Meeting">
	 						<input type="checkbox" id="App_Meeting" onClick="checkAll('App_Meeting')" value="A___6" ><b><fmt:message key="application.6.label" bundle="${v3xCommonI18N}" /></b>
	 					</label>
					</legend>
					<table width="100%">
						<tr>
							<td width="50%">
							<label><input type="checkbox"  relId="App_Meeting"  onclick="setNoCheckAll(this);" name="" value="S5___all" ><fmt:message key="mt.mtMeeting.notice.label" bundle="${meetingI18N}" /></label>
							</td><td>
							<label><input type="checkbox"  relId="App_Meeting"  onclick="setNoCheckAll(this);" name="" value="S6___all" ><fmt:message key="mt.mtMeeting.auditing.label" bundle="${meetingI18N}" /></label>
							</td>
						</tr><tr>
							<td>
							<label><input type="checkbox"  relId="App_Meeting"  onclick="setNoCheckAll(this);" name="" value="S7___all" ><fmt:message key="mtSummary.audit.pending.lable" bundle="${meetingSummaryI18N}" /></label>
							</td><td>
							<label><input type="checkbox"  relId="App_Meeting"  onclick="setNoCheckAll(this);" name="" value="S8___all" ><fmt:message key="mr.tab.review" bundle="${meetingRoomI18N}" /></label>
							</td>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
		</c:if>
	</td>
	</tr>
	<tr>
	<td width="50%" height="100%" valign="top">
		<c:if test="${isInternal}">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Comm">
	 						<input type="checkbox" id="App_Comm" value="" onClick="checkAll('App_Comm')" ><b><fmt:message key="pending.public.label" bundle="${v3xMainI18N}" /></b>
	 					</label>
					</legend>
					<table width="100%">
						<tr>
							<td width="50%">
							<label><input type="checkbox"  relId="App_Comm"  onclick="setNoCheckAll(this);" name="" value="A___8" ><fmt:message key="application.8.label" bundle="${v3xCommonI18N}" /></label>
							</td><td>
							<label><input type="checkbox"  relId="App_Comm"  onclick="setNoCheckAll(this);" name="" value="A___7" ><fmt:message key="application.7.label" bundle="${v3xCommonI18N}" /></label>
							</td>
						</tr><tr>
							<td>
							<label><input type="checkbox"  relId="App_Comm"  onclick="setNoCheckAll(this);" name="" value="A___10" ><fmt:message key="application.10.label" bundle="${v3xCommonI18N}" /></label>
							</td><td>
							</td>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
		</c:if>
	</td>
	<td width="50%" height="100%" valign="top">
		<c:if test="${isInternal}">
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Office">
	 						<input type="checkbox" id="App_Office" onClick="checkAll('App_Office')" value="A___26" ><b><fmt:message key="menu.zhbg" bundle="${v3xMainI18N}" /></b>
	 					</label>
					</legend>
					<table width="100%">
						<tr>
							<td width="50%">
							<label><input type="checkbox"  relId="App_Office"  onclick="setNoCheckAll(this);" name="" value="S2___all" ><fmt:message key="menu.zhbg.asset.pending.label" bundle="${v3xMainI18N}" /></label>
							</td><td>
							<label><input type="checkbox"  relId="App_Office"  onclick="setNoCheckAll(this);" name="" value="S1___all" ><fmt:message key="common.resource.type.acc" bundle="${v3xMainI18N}" /></label>
							</td>
						</tr><tr>
							<td>
							<label><input type="checkbox"  relId="App_Office"  onclick="setNoCheckAll(this);" name="" value="S0___all" ><fmt:message key="common.resource.type.car" bundle="${v3xMainI18N}" /></label>
							</td><td>
							<label><input type="checkbox"  relId="App_Office"  onclick="setNoCheckAll(this);" name="" value="S3___all" ><fmt:message key="menu.zhbg.book.pending.label" bundle="${v3xMainI18N}" /></label>
							</td>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
		</c:if>
	</td>
	</tr>
	<tr>
	<td width="50%" height="100%" valign="top">
		<c:if test='${isInternal && v3x:hasPlugin("govInfoPlugin")}'>
		<table border="0" width="100%" cellspacing="10" cellpadding="0">
			<tr>
				<td>
				<fieldset>
					<legend>
	 					<label for="App_Info">
	 						<input type="checkbox" id="App_Info" name=""  value="A___32" onClick="checkAll('App_Info')" ><b><fmt:message key="menu.info.report" bundle="${v3xMainI18N}" /></b>
	 					</label>
					</legend>
					<table width="100%">
						<tr>
						<c:forEach items="${listInfo}" var="col" varStatus="status">
							<c:choose>
								<c:when test='${col.type==0}' >
									<fmt:message key="${col.label}"  bundle="${v3xCommonI18N}" var="name" />
								</c:when>
								<c:when test='${col.type==1}' >
									<c:set value = "${col.name}" var="name" />
								</c:when>
							</c:choose>
							<td width="50%">
							<label for="${col.flowPermId}"><input type="checkbox" onClick="setNoCheckAll(this);" relId="App_Info" name="" value="P32___${col.name }" >${name}</label>
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
	<td width="50%" height="100%" valign="top">
	</td>
	</tr>
</table>
</div>
</body>
</html>