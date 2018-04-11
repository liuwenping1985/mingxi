<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.exchange.util.Constants"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../exchangeHeader.jsp" %>
<%@ include file="../../edoc/edocHeader.jsp" %>
<title></title>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet"
	href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>	
<script type="text/javascript">
	function showByStatus(){
		window.document.searchForm.submit();
	}

	function editItem(id, modelType){
		var exchangeURL = "${exchange}?id="+id+"&modelType="+modelType+"&nodeAction=swWaitRegister&";
		if(modelType=="toReceive") {
			exchangeURL += "method=receiveDetail&userId=${current_user_id}";
		} else {
			exchangeURL += "method=edit";
		}

		//if(v3x.getBrowserFlag('pageBreak')){
		//	parent.detailFrame.window.location = exchangeURL+"&fromlist=true";
		//} else {
		v3x.openWindow({
	     	url: exchangeURL,
	     	dialogType:'open',
	     	FullScrean: 'yes'
		});
		//}
	}

	function deleteItem() {
		var checkedIds = document.getElementsByName('id');
		var len = checkedIds.length;
		var str = "";
		for(var i = 0; i < len; i++) {
	  		var checkedId = checkedIds[i];
			if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.parentNode.tagName == "TR"){			
				str += checkedId.value;
				str +=","
			}
		}
	 	if(str==null || str==""){
	  		alert("<fmt:message key='edoc.delete.alert.label' bundle='${edocI18N}'/>");
	  		return false;
	  	}
		str = str.substring(0,str.length-1);
		if(window.confirm("<fmt:message key='edoc.deleteconfirm.alert.label' bundle='${edocI18N}'/>")){
			document.location.href='${exchange}?method=edocDelete&type=sign&id='+str;
		}
	}	

	//签收后调用方法
	function doEndSign(url) {
		location.reload();
	}

	function doSearch2(){
		var flag = true;
		var recTime = document.getElementById("recTimeDiv");
		if(recTime && recTime.style.display == "block"){
			var begin = document.getElementById("recTimeBegin").value;
			var end = document.getElementById("recTimeEnd").value;
			flag = timeValidate(begin,end);
		}
		if(flag){
			/** 打开进度条 */
			//try { getA8Top().startProc(); } catch(e) {}
			doSearch();
		}
	}

	$(function(){
		$(".nbtn").parent("div").css("padding","0");
		$(".nbtn").click(function(e){
			var nul=$(".nUL"); //菜单div
			var left=parseInt($(this)[0].offsetLeft)-nul.width()+10; //计算div偏移量
			nul.toggleClass("hidden");
			nul.css({"left":left+"px","top":"25px"});
			addEvent(document.body,"mousedown",clickOther);
		});
		//OA-20177  收文-待登记，有脚本错误。  
		//在js中写EL表达式最好带上引号
		if("${hasSubjectWrap}" == "true"){
			var obj = document.getElementById("showAllSubjectId");
			obj.checked = true;
			subjectWrapSettting();
		}
	});
	function init(){}
	
	function registerZhiRecEdoc(){
	  location.href="edocController.do?method=newEdoc&edocType=1&listType=listV5Register";
	}
	
	function registerRecEdoc(){
		var oCheckbox = document.getElementsByName("id");
		var count =0;
		var recieveId = "";
		var registerId = "";
	    for(var i=0;i<oCheckbox.length;i++) {
	    	if(oCheckbox[i].checked) {
	    		registerId=oCheckbox[i].value;
	    		recieveId = oCheckbox[i].getAttribute("recieveId");
	    		count++;
	    	}
	    }
	    if(count==0) {
			alert(_("edocLang.edoc_alertDontSelectMulti"));
			return;
	    } else if(count>1) {
		    //OA-47450 收文管理下的待登记，全选后点击电子登记，弹出提示语有误。后期整理G6时此处需要验证，G6有分发提示，而V5没有
			//alert(_("edocLang.edoc_alertOnlyOneSelectMultiToFenfa"));
			alert(_("edocLang.edoc_alertOnlyOneSelectMultiToRegister"));
			return;
		} else {
			//本地安装的是永中office，正文类型是wps给出提示
	        var isWpsBodyType = checkWpsBodyType(registerId);
	        var isYoZoOffice = parent.isYoZoOffice();
	        if(isWpsBodyType && isYoZoOffice){
	     	   	//本地安装的Office环境不支持此公文正文类型的保存和发送，无法正常登记，请安装WPS或微软Office软件！
	        	alert(_("edocLang.edoc_alertWpsYozoOffice"));
	     	   	return;
	        }
		    //location.href="edocController.do?method=newEdoc&comm=distribute&edocType=1&listType=listV5Register&recieveId="+recieveId
            location.href="edocController.do?method=newEdoc&comm=register&edocType=1&listType=listV5Register&recieveId="+recieveId+"&registerId="+registerId;
		}
	}
	/**
	 * 检查待登记公文的正文类型是否是wps
	 */
	function checkWpsBodyType(registerId){
		var retValue=false;
		if(registerId && registerId != ""){
			var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "getRegisterBodyType",false);
			requestCaller.addParameter(1, "String", registerId);
			var tempBodyType = requestCaller.serviceRequest();
			if(tempBodyType && (tempBodyType == "WpsWord" || tempBodyType == "WpsExcel")){
				retValue = true; 
			}
		}
		return retValue;
	}

	function zhuanfawen(){
		var objcts = document.getElementsByName("id");
		  var checked="";
		  var checkedId=0;
		  var count =0;
		  var checkOption="";
		  var newContactReceive = "";
		  var recieveId = "";
		  var edocId;
		  for (var i = 0; i < objcts.length; i++) {
			if(objcts[i].checked) {
			  checked='1';
			  count++;
			  //待登记关联发文时，关联id用签收id
			  recieveId = objcts[i].getAttribute("recieveId");
			  edocId = objcts[i].getAttribute("edocId");
			}
		  }
		  if(checked != '1'){
			alert(_("edocLang.batch_select_forwardsend"));
			  return ;
		  }else if(count>1){
			alert(_("edocLang.batch_select_onlyOne_forwardsend"));
			  return ;
		  }else{
			//document.getElementById("edocId").value= checkedId;
			var _url= "edocController.do?method=forwordOption&recieveRecordId=" + recieveId;
			var re= v3x.openWindow({
			  url: _url,
			  height : 206,
			  width  : 300
			  });
			if(re=='True'){
			  //隐藏域的form表单
			  var newContactReceive = document.getElementById("newContactReceive");
			   checkOption = document.getElementById("forwardCheckOption").value;

			   if(newContactReceive != null){
				 newContactReceive = newContactReceive.value;
				 //OA-34023 从收文管理-待登记页面勾选一个公文转发文，页面没有进入拟文页面，而是进入了发文的待办列表
				 parent.parent.location.href="edocController.do?method=listIndex&listType=newEdoc&edocType=0&comm=forwordtosend&edocId="+edocId+"&recieveId="+recieveId+"&checkOption="+checkOption+"&newContactReceive="+newContactReceive;
			   }else{
			     parent.parent.location.href="edocController.do?method=listIndex&listType=newEdoc&edocType=0&comm=forwordtosend&edocId="+edocId+"&checkOption="+checkOption;
				 //parent.parent.location.href="edocController.do?method=listIndex&from=newEdoc&edocType=0&comm=forwordtosend&edocId="+edocId+"&checkOption="+checkOption;
			   }
			}
		  }
	}

	function recRegisterDan(){
		var _url= "edocController.do?method=recRegister&edocType=1";
		v3x.openWindow({
		  url: _url,
		  FullScrean: 'yes'
		  });
	}
var theForm = "";
var recieveId = "";
var registerId = "";
var competitionAction="no";//用来验证当前是不是竞争执行
	function huitui(){
		theForm = document.getElementsByName("listForm")[0];
		if (!theForm) {
			return false;
		}

		var id_checkbox = document.getElementsByName("id");
		if (!id_checkbox) {
			return true;
		}

		var hasMoreElement = false;
		var len = id_checkbox.length;
		var countChecked = 0;
		var obj;
		for (var i = 0; i < len; i++) {
			if (id_checkbox[i].checked) {
				obj = id_checkbox[i];
				hasMoreElement = true;
				countChecked++;
			    if(id_checkbox[i].getAttribute("exchangeMode")==1){
					alert(v3x.getMessage("edocLang.edoc_exchange_sursen"));
					return;
				}  
			}
		}

		if (!hasMoreElement) {
			alert(v3x.getMessage("edocLang.edoc_alertStepBackItem"));
			return true;
		}
		
		if(countChecked > 1){
			alert(v3x.getMessage("edocLang.edoc_alertSelectStepBackOnlyOne"));
			return true;
		}
		recieveId = obj.getAttribute("recieveId");
		registerId = obj.value;
				//验证是否有公文交换权限
				    //V5SP2工作项-V51-1-222公文交换完善（签收-登记阶段）
					var canSubmit = false;//初始提交元素为false状态
					//通过当前签收数据ID，获取签收人ID，然后通过AJAX判断当前签收人及当前单位是否有权限
		        	var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "checkEdocRecieveMember", false);
		        	//传递签收ID
		            requestCaller.addParameter(1, 'String', recieveId);
		            var re = requestCaller.serviceRequest();
		            //获取返回值
		            if(re[0] == 'false') {
			            //[0]=false当前签收人已经无公文交换的权限
		            	if(re[1] == 'true') {//发送人已经不是收发员了，是否让其它收发员竞争
		            		if(confirm(v3x.getMessage('ExchangeLang.edoc_register_stepBack_ToOther_exchangeRole'))) {
		            			competitionAction="yes";
		            			canSubmit = true;
		            		}
		            	} else {//发送人已经不是收发员了，并且发送单位已经没有收发员了
		            		alert(v3x.getMessage('ExchangeLang.edoc_register_stepBack_hasnot_exchangeRole'));
		            		return;
		            	}
		            } else if(re[0]=='true'|| re[0] == 'null') {
		            	canSubmit = true;
		            }
		  
		            //条件满足后，进行提交回退操作
		        	if(canSubmit) {
		          		if (window.confirm(v3x.getMessage("edocLang.edoc_confirmRecessionItem"))) {
			    				getA8Top().win123 = getA8Top().$.dialog({
			    				title:'<fmt:message key='exchange.stepBack'/>',
			    				transParams:{'parentWin':window},
			    				url:'exchangeEdoc.do?method=openStepBackDlg4Resgistering&resgisteringEdocId='+recieveId,
			    				width:"400",
			    				height:"300",
			    				resizable:"0",
			    				scrollbars:"true",
			    				dialogType:"modal"
			    			});
		          		}
		        	}
	}
	function huituiCallback(returnValues){
		if(returnValues!=null && returnValues != undefined){
			if(1==returnValues[0]){
                theForm.action = 'exchangeEdoc.do?method=stepBackRecievedEdoc&recieveId='+recieveId+'&registerId='+registerId+'&stepBackInfo='+encodeURIComponent(returnValues[3])+'&competitionAction='+competitionAction;
                theForm.method = "POST";
				theForm.submit();
				}
			} 
	}
    function barCodeRecEdoc(){
        location.href="edocController.do?method=newEdoc&edocType=1&barCode=true&registerType=3";
    }
    function getSursenSummary(){ 
    	location.href='exchangeEdoc.do?method=getSursenSummary';
    }
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body onload="setMenuState('sign');init();">
<%--转发文 --%>
    <input type="hidden" value="0" name="forwardCheckOption" id="forwardCheckOption"/>
    <input type="hidden" name="newContactReceive" id="newContactReceive"/>
<%--转发文  结束--%>

<div class="main_div_row2">
  <div class="right_div_row2" style="padding-top:15px;position:static;">
    <div class="top_div_row2 webfx-menu-bar">
<c:set value="<%=Constants.C_iStatus_Recieved%>" var="un_rec" />
<c:set value="<%=Constants.C_iStatus_Registered%>" var="rec" />
<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="border-left padding_l_5">
			<script type="text/javascript">
			if("${modelType}"=="received") {
				var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
				
				if('${param.listType}' == 'listV5Register'){
					if(!v3x.isMac) {
					    myBar.add(
	                        new WebFXMenuButton(
	                            "newBtn", 
	                            "<fmt:message key='edoc.toolbar.paper.label' bundle='${edocI18N}'/>", 
	                            "registerZhiRecEdoc();", 
	                            [18,1], 
	                            "", 
	                            null
	                        )
	                    );
					    if("${v3x:hasPlugin('barCode')}"=='true'){
							myBar.add(
		                        new WebFXMenuButton(
		                            "newBtn", 
		                            "<fmt:message key='edoc.toolbar.Two_dimensional_code.label' bundle='${edocI18N}'/>", 
		                            "barCodeRecEdoc();", 
		                            [18,3], 
		                            "", 
		                            null
		                        )
		                    );
					    }
					    
						myBar.add(
	                        new WebFXMenuButton(
	                            "newBtn", 
	                            "<fmt:message key='edoc.toolbar.Electronic.label' bundle='${edocI18N}'/>", 
	                            "registerRecEdoc();", 
	                            [18,2], 
	                            "", 
	                            null
	                        )
	                    );
						if("${showBanwenYuewen}"=="true"){
							myBar.add(
			                        new WebFXMenuButton(
			                            "newBtn", 
			                            "<fmt:message key='edoc.toolbar.batchRegist.label' bundle='${edocI18N}'/>", 
			                            "showReadBatchWDRegist("+"${canSelfCreateFlow}"+");", 
			                            [18,2], 
			                            "", 
			                            null
			                        )
			                    );
						}
						//var resourceKey = "F07_sendNewEdoc";
						var resourceKey = "F07_sendManager";
			    		if(hasEdocResourceCode(resourceKey) && "${isG6Ver}"=="true") {
							myBar.add(
		                        new WebFXMenuButton(
		                            "newBtn", 
		                            "<fmt:message key='edoc.toolbar.Forwarding_text.label' bundle='${edocI18N}'/>", 
		                            "zhuanfawen();", 
		                            [10,2], 
		                            "", 
		                            null
		                        )
		                    );
						}
					}
					myBar.add(
                        new WebFXMenuButton(
                            "newBtn", 
                            "<fmt:message key='edoc.toolbar.rollback.label' bundle='${edocI18N}'/>", 
                            "huitui()", 
                            [4,1], 
                            "", 
                            null
                        )
                    );

				}
				else{
				  myBar.add(
                      new WebFXMenuButton(
                          "newBtn", 
                          "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
                          "deleteItem();", 
                          [1,3], 
                          "", 
                          null
                      )
                  );
				}
				<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
				document.write(myBar.toString());	
				document.close();
			}
			</script>
		</td>
		<td class="webfx-menu-bar border-right">
			<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<input type="hidden" value="<c:out value='${modelType}' />" name="modelType">
				<input type="hidden" value="<c:out value='${listType}' />" name="listType">
				<input type="hidden" value="" name="selectedValue" />
						<div class="div-float-right">
				<div class="div-float" id="selectDiv" name="selectDiv">
					<select name="condition" id="condition" onChange="showNextSpecialCondition(this);" class="condition">
							<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							<!--
							<option value="total" <c:if test="${condition == 'total'}">selected</c:if>><fmt:message key="exchange.element.total" /></option>
							-->
                            <%--OA-30463  应用检查：待登记小查询，去掉条件：成文单位，此条件为G6的条件   --%>
                            <c:if test="${isG6 == 'true'}">
							<option value="sendUnit"  <c:if test="${condition == 'sendUnit'}">selected</c:if>><fmt:message key="edoc.element.receive.edoc_unit" bundle="${edocI18N}"/></option>
							</c:if>
                            <option value="subject" <c:if test="${condition == 'subject'}">selected</c:if>><fmt:message key="exchange.edoc.title" /></option>

							
							<option value="docMark" <c:if test="${condition == 'docMark'}">selected</c:if>><fmt:message key="edoc.element.wordno.label" bundle="${edocI18N}"/></option>
							<c:choose>
							<c:when test="${modelType eq 'received'}">
								<option value="recTime" <c:if test="${condition == 'docMark'}">selected</c:if>><fmt:message key="edoc.element.receipt_date" bundle="${edocI18N}" /></option>
							</c:when>
							</c:choose> 
							<c:if test="${v3x:hasPlugin('sursenExchange')}"> 
								<option value="exchangeMode"  <c:if test="${condition == 'exchangeMode'}">selected</c:if>><fmt:message key="edoc.exchangeMode" /></option>  <%-- 交换方式 --%>
							</c:if>
							
						</select>
					</div>
					<!--
			  	<div id="totalDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield" <c:if test="${condition == 'total'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
			  	</div>
				-->
				
				<c:if test="${isG6 == 'true'}">
			  	<div id="sendUnitDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield" <c:if test="${condition == 'sendUnit'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
			  	</div>
			  	</c:if>
			  	<div id="subjectDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield" <c:if test="${condition == 'subject'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
			  	</div>
			  	<div id="docMarkDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield" <c:if test="${condition == 'docMark'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
			  	</div>	 
			  	
			  	<c:choose>
					<c:when test="${modelType eq 'received'}">
			  	<div id="recTimeDiv" class="div-float hidden">
			  		<input type="text" name="textfield" id="recTimeBegin" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
			  		-
			  		<input type="text" name="textfield1" id="recTimeEnd" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
			  	</div>
			  	</c:when>
				</c:choose>
				<c:if test="${v3x:hasPlugin('sursenExchange')}">
				  	<div id="exchangeModeDiv" class="div-float hidden">
						<select name="textfield">
							<option value=0><fmt:message key='edoc.exchangeMode.internal'/></option>   <%-- 内部公文交换 --%>
							<option value=1><fmt:message key='edoc.exchangeMode.sursen'/></option>  <%-- 书生公文交换 --%>
						</select>
				  	</div>
				</c:if>
						<!--  input type="button" value="查询" onclick="showByStatus();"-->
						
				
			  	<div id="grayButton" onclick="javascript:doSearch2()" class="condition-search-button"></div>
			  	
				</div>
			</form>
		</td>
	</tr>
	</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
    		<ul class="nUL hidden" id="showAllSubject">
    			<li><input type="checkbox" id="showAllSubjectId" onclick="javascript:subjectWrapSettting('ajax');"/><fmt:message key="edoc.subject.wrap" /></li>
    		</ul>
			<form name="listForm">
			<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true" bundle="${edocI18N}">
				<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>"   edocId="${bean.edocId}" recieveId="${bean.recieveId }" exchangeMode="${bean.exchangeMode}"/>
				</v3x:column>
                <v3x:column width="22%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');" label="exchange.edoc.title" className="cursor-hand sort proxy-${bean.proxy} mxtgrid_black" importantLevel="${bean.urgentLevel}" value="${bean.subject}" alt="${bean.subject}">
                </v3x:column>
                
                
                <v3x:column width="${listType=='listRecieveRetreat'?13:7}%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');" label="exchange.edoc.secretlevel" className="cursor-hand sort" maxLength="10" >
					<v3x:metadataItemLabel metadata="${colMetadata['edoc_secret_level']}" value="${bean.secretLevel}" />
				</v3x:column>
				<v3x:column width="${listType=='listRecieveRetreat'?16:11}%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');" label="exchange.edoc.category" className="cursor-hand sort" maxLength="20">
				<v3x:metadataItemLabel metadata="${colMetadata['edoc_doc_type']}" value="${bean.docType}" />	
				</v3x:column>
				<v3x:column width="16%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');" label="edoc.element.wordno.label" className="cursor-hand sort" value="${bean.docMark}" alt="${bean.docMark}">
				</v3x:column>
				
                <v3x:column width="${listType=='listRecieveRetreat'?17:16}%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');" label="edoc.element.sendunit" className="cursor-hand sort" maxLength="16"  symbol="..." value="${bean.sendUnit}" alt="${bean.sendUnit}">
				</v3x:column>
                
                <v3x:column width="16%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');" label="exchange.edoc.sendToNames" className="cursor-hand sort" maxLength="40"  symbol="..." 
                    value="${bean.sendTo}" alt="${bean.sendTo}">
                </v3x:column>
				<v3x:column width="19%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');" label="exchange.edoc.receivedperson" className="cursor-hand sort" maxLength="10"  symbol="..." value="${bean.recieveUserName}">
					</v3x:column>
				<v3x:column width="14%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');" label="exchange.edoc.receiveddate" className="cursor-hand sort" maxLength="20">
					<span title="<fmt:formatDate value="${bean.recTime}" pattern="yyyy-MM-dd HH:mm"/>">
						<fmt:formatDate value="${bean.recTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd" />&nbsp;
					</span>
				</v3x:column>
				<c:if test="${v3x:hasPlugin('sursenExchange')}"> 
					<v3x:column width="10%" type="String" onClick="editItem('${bean.recieveId}', '${modelType }');"
						label="edoc.exchangeMode" className="cursor-hand sort" symbol="...">  <%-- 交换方式 --%> 
						<c:if test="${bean.exchangeMode==0}"><fmt:message key='edoc.exchangeMode.internal'/></c:if> <%-- 内部公文交换 --%> 
						<c:if test="${bean.exchangeMode==1}"><fmt:message key='edoc.exchangeMode.sursen'/></c:if> <%-- 书生公文交换 --%>
					</v3x:column>
				</c:if>
				
			</v3x:table>
			</form>
		</div>
  </div>
</div>
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
var info = "";
var list = "${param.list}";
if(list=="toRecieve" || list=="toRecieveFromInner" || list=="toRecieveFromOuter") {
	info = "<fmt:message key='common.toolbar.presign.label' bundle='${v3xCommonI18N}'/>";
} else {
	info = "<fmt:message key='common.toolbar.sign.label' bundle='${v3xCommonI18N}'/>";
}
showDetailPageBaseInfo("detailFrame", info, [1,2], pageQueryMap.get('count'), _("ExchangeLang.detail_info_6013"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
function subjectWrapSettting(needUpdate){
	var obj = document.getElementById("showAllSubjectId");
	var edocType = "${param.edocType}";
	//3:收文-签收
	var listType = 3;
	isWrap(obj.checked, edocType, listType, needUpdate);
	document.getElementById("showAllSubject").className = "nUL hidden";
}
</script>
<form id="readBatchRegistForm" name="readBatchRegistForm" action="">
<input type="hidden" id="registerStr" name="registerStr" value="1"/>
<input type="hidden" id="processXml" name="processXml" value="1"/>
<input type="hidden" id="comment" name="comment" value="1"/>
</form>
</body>
</html>