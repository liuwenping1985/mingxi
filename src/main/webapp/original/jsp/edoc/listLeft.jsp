<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Insert title here</title>
		<%@ include file="edocHeader.jsp" %>
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
		<link href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
		<script>
			function openCustomerType(){
				var winWidth = 420;
				var winHeight = 385;
				var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
				feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
				feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
				
				var url = "${pageContext.request.contextPath}/edocController.do?method=customerTypes&edocType=${edocType}&from=${param.from}&ndate="+new Date().getTime();
				var retObj = window.showModalDialog(url,window ,feacture);
				if (retObj){
					window.location.reload(); 
				}
			}
		
			
			/**
			 * 显示签收列表
			 */
			function showToReceiveList(listType){
				parent.listFrame.location.href = "exchangeEdoc.do?method=listRecieve&edocType=${edocType}&listType="+listType;
			}
			/**
			 * 显示发文分发列表
			 */
			function showDistributeList(modelType,listType){
				parent.listFrame.location.href = "exchangeEdoc.do?method=list&modelType="+modelType+"&listType="+listType+"&isFenfa=1";
				//lijl添加
				if("toSend"==modelType){
					distributeDone.collapse();
					toSend.expand();
				}else if("sent"==modelType){
					toSend.collapse();
					distributeDone.expand();
				}
			}
			/**
			 * 显示发文分发列表
			 */
			function showRegisterList(listType){
				parent.listFrame.location.href = "edocController.do?method=listRegister&edocType=${edocType}&listType="+listType;
			}
			/**
			 * 显示发文分发列表
			 */
			function showOtherRegisterList(registerType,listType){
				parent.listFrame.location.href = "edocController.do?method=newEdocRegister&edocType=${edocType}&comm=create&registerType=" + registerType + "&&listType="+listType;
			}

			
			/**
			 * 显示发文分发列表
			 */
			function showSWwaitDistributeList(listType){
				parent.listFrame.location.href = "edocController.do?method=listDistribute&edocType=${edocType}&list=aistributining&btnType=2&listType="+listType;
			}
			
			function showSWDistributeList(listType){
				parent.listFrame.location.href = "edocController.do?method=listSent&edocType=${edocType}&list=listSent&listType="+listType;
			}

		    //收文分发草稿箱,退稿箱
		    function showSWDistributeDraft(list,stepBackState){
		    	parent.listFrame.location.href ="edocController.do?method=listWaitSend&edocType=${edocType}&list="+list+"&subState="+stepBackState;
			}

            //待办
			function showPendingList(condition,textfield){
				parent.listFrame.location.href ="edocController.do?method=listPending&edocType=${edocType}&list=notPending&condition="+condition+"&textfield="+textfield;
			}
			//待办全部
			function showPendingList2(){
				parent.listFrame.location.href ="edocController.do?method=listPending&edocType=${edocType}&list=listPending";
			}

            //在办
			function showZcdbList(condition,textfield){
				parent.listFrame.location.href ="edocController.do?method=listZcdb&edocType=${edocType}&list=pending&condition="+condition+"&textfield="+textfield;
			}
			function showZcdbList2(){
				parent.listFrame.location.href ="edocController.do?method=listZcdb&edocType=${edocType}&list=pending";
			}


            //已办(未办结)
			function showDoneList(condition,textfield){
				parent.listFrame.location.href ="edocController.do?method=listDone&edocType=${edocType}&list=notFinish&condition="+(condition?condition:"")+"&textfield="+(textfield?textfield:"");
			}
			//已办（全部）
			function showDoneList2(){
				parent.listFrame.location.href ="edocController.do?method=listDone&edocType=${edocType}&list=listDone";
			}

            //已办结
			function showFinishList(condition,textfield){
				parent.listFrame.location.href ="edocController.do?method=listFinish&edocType=${edocType}&list=doneOver&condition="+condition+"&textfield="+textfield;
			}
			function showFinishList2(){
				parent.listFrame.location.href ="edocController.do?method=listFinish&edocType=${edocType}&list=doneOver";
			}

            //未归档，已归档
			function showArchiveList(condition,textfield,hasArchive){
				parent.listFrame.location.href ="edocController.do?method=listFinish&edocType=${edocType}&list=doneOver&hasArchive="+hasArchive+"&condition="+condition+"&textfield="+textfield;
			}
			function showArchiveList2(hasArchive){
				parent.listFrame.location.href ="edocController.do?method=listFinish&edocType=${edocType}&list=doneOver&hasArchive="+hasArchive;
			}
			//已阅（全部）
			function showReadedList(){
				parent.listFrame.location.href ="edocController.do?method=listReaded&edocType=${edocType}&from=listReaded";
			}
			//已阅未归档，已归档
			function showArchiveListReaded(condition,textfield,hasArchive){
				parent.listFrame.location.href ="edocController.do?method=listReaded&edocType=${edocType}&from=listReaded&hasArchive="+hasArchive+"&condition="+condition+"&textfield="+textfield;
			}
			function showArchiveListReaded2(hasArchive){
				parent.listFrame.location.href ="edocController.do?method=listReaded&edocType=${edocType}&from=listReaded&hasArchive="+hasArchive;
			}

			//拟文
			function showNewEdocList(typeId){
				parent.listFrame.location.href ="edocController.do?method=newEdoc&edocType=${edocType}"+(typeId==''?"":"&subType="+typeId);
				<c:if test="${edocType != 2}">
			        if(listSent){
			          //listSent.collapse();
			        }
					listWaitSend.collapse();
					backBox.collapse();
					<c:if test="${isEdocCreateRole}">
						create.expand();
					</c:if>
				</c:if>
			}
           //已发
			function showSentList(typeId){
				parent.listFrame.location.href ="edocController.do?method=listSent&edocType=${edocType}&list=listSent"+(typeId==''?"":"&subType="+typeId);
				<c:if test="${edocType != 2}">
					listSent.expand();
					if(listWaitSend){
					  listWaitSend.collapse();
					}
					if(backBox){
					  backBox.collapse();
					}
					
					<c:if test="${isEdocCreateRole}">
						create.collapse();
					</c:if>
				</c:if>
			}
           //草稿箱
			function showWaitingSendList(typeId,sendBackState){
				parent.listFrame.location.href ="edocController.do?method=listWaitSend&edocType=${edocType}&list=draftBox"+(typeId==''?"":"&subType="+typeId)+(sendBackState==''?"":"&subState="+sendBackState);
				<c:if test="${edocType != 2}">
					//listSent.collapse();
					listWaitSend.expand();
					backBox.collapse();
					<c:if test="${isEdocCreateRole}">
						create.collapse();
					</c:if>
				</c:if>
			}
           //退稿箱
			function showSendBack(typeId,sendBackState){
				parent.listFrame.location.href ="edocController.do?method=listWaitSend&edocType=${edocType}&list=backBox"+(typeId==''?"":"&subType="+typeId)+(sendBackState==''?"":"&subState="+sendBackState);
				//lijl添加
				//listSent.collapse();
				listWaitSend.collapse();
				backBox.expand();
				<c:if test="${isEdocCreateRole}">
					create.collapse();
				</c:if>
			}

			//签报退稿箱
			function showQbSendBack(typeId,sendBackState){
				parent.listFrame.location.href ="edocController.do?method=listWaitSend&edocType=${edocType}&list=backBox"+(typeId==''?"":"&subType="+typeId)+(sendBackState==''?"":"&subState="+sendBackState);
			}

			var properties = new Properties(0);

			function changeHandler(myListType) {
				webFXTreeHandler.select(properties.get(myListType)); 
			}

			function changeTreeToCreate(){
				create.expand();
				backBox.collapse();
				listWaitSend.collapse();
				//listSent.collapse();
			}

		</script>
	</head>
	<body style="overflow:auto;">
	
	  	<table>
	  	 <tr>
	  	
	  	<td width="210" valign="top">
		<div>
			<script type="text/javascript">

				function setIcon(obj){
					obj.icon = "<c:url value='/apps_res/edoc/images/openfoldericon.png'/>";
					obj.openIcon = "<c:url value='/apps_res/edoc/images/openfoldericon.png'/>";
				}

				var from = "${param.from}";	
				var nowlist = "${param.list}";
				//var waitSendControl = "${v3x:getSystemProperty('edoc.send.pending.page')}";
				//var appending = "${v3x:getSystemProperty('edoc.send.appending.page')}";
				//var newEdoc ="${v3x:getSystemProperty('edoc.send.newEdoc.page')}";
				//var listDone ="${v3x:getSystemProperty('edoc.send.listDone.page')}";
				//var listSent ="${v3x:getSystemProperty('edoc.send.listSent.page')}";
				/************************* 收文 **********************/
				<c:if test="${edocType==1}">
					//签收
					if(from == "listRecieve" || from=="listRecieveRetreat") {
						//待签收
						//xiangfan 添加 达到默认是收缩的效果
						var toReceiveRoot = new WebFXTree("toReceiveRoot", "<fmt:message key='common.toolbar.presign.label' bundle='${v3xCommonI18N}' />", "");
						var toReceive = new WebFXTreeItem("toReceive", "<fmt:message key='common.toolbar.presign.label' bundle='${v3xCommonI18N}' />", "javascript:showToReceiveList('toReceive')");
						toReceiveRoot.add(toReceive);
						//待签收内部来文
						var toReceiveFromInner = new WebFXTreeItem("$toReceiveFromInner","<fmt:message key='edoc.element.receive.send_unit_type.inner'/>","javascript:showToReceiveList('toReceiveFromInner')");
						var toReceiveFromInner1 = new WebFXTreeItem("toReceiveFromInnerToday", "<fmt:message key='edoc.customer.type.today'/>", "javascript:showToReceiveList('toReceiveFromInnerToday')")
						setIcon(toReceiveFromInner1);
						toReceiveFromInner.add(toReceiveFromInner1);
						var toReceiveFromInner2 = new WebFXTreeItem("toReceiveFromInnerLastDay", "<fmt:message key='edoc.customer.type.yesterday'/>", "javascript:showToReceiveList('toReceiveFromInnerLastDay')");
						setIcon(toReceiveFromInner2);
						toReceiveFromInner.add(toReceiveFromInner2);
						var toReceiveFromInner3 = new WebFXTreeItem("toReceiveFromInnerThisWeek", "<fmt:message key='edoc.customer.type.thisweek'/>", "javascript:showToReceiveList('toReceiveFromInnerThisWeek')");
						setIcon(toReceiveFromInner3);
						toReceiveFromInner.add(toReceiveFromInner3);
						var toReceiveFromInner4 = new WebFXTreeItem("toReceiveFromInnerLastWeek", "<fmt:message key='edoc.customer.type.lastweek'/>", "javascript:showToReceiveList('toReceiveFromInnerLastWeek')");
						setIcon(toReceiveFromInner4);
						toReceiveFromInner.add(toReceiveFromInner4);
						var toReceiveFromInner5 = new WebFXTreeItem("toReceiveFromInnerThisMonth", "<fmt:message key='edoc.customer.type.thismonth'/>", "javascript:showToReceiveList('toReceiveFromInnerThisMonth')");
						setIcon(toReceiveFromInner5);
						toReceiveFromInner.add(toReceiveFromInner5);
						var toReceiveFromInner6 = new WebFXTreeItem("toReceiveFromInnerLastMonth", "<fmt:message key='edoc.customer.type.lastmonth'/>", "javascript:showToReceiveList('toReceiveFromInnerLastMonth')");
						setIcon(toReceiveFromInner6);
						toReceiveFromInner.add(toReceiveFromInner6);
						var toReceiveFromInner7 = new WebFXTreeItem("toReceiveFromInnerThisYear", "<fmt:message key='edoc.customer.type.thisyear'/>", "javascript:showToReceiveList('toReceiveFromInnerThisYear')");
						setIcon(toReceiveFromInner7);
						toReceiveFromInner.add(toReceiveFromInner7);
						var toReceiveFromInner8 = new WebFXTreeItem("toReceiveFromInnerLastYear", "<fmt:message key='edoc.customer.type.previous.years'/>", "javascript:showToReceiveList('toReceiveFromInnerLastYear')");
						setIcon(toReceiveFromInner8);
						toReceiveFromInner.add(toReceiveFromInner8);
						//待签收外部来文
						var toReceiveFromOuter = new WebFXTreeItem("toReceiveFromOuter", "<fmt:message key='edoc.element.receive.send_unit_type.outer'/>", "javascript:showToReceiveList('toReceiveFromOuter')");
						var toReceiveFromOuter1 =  new WebFXTreeItem("toReceiveFromOuterToday", "<fmt:message key='edoc.customer.type.today'/>", "javascript:showToReceiveList('toReceiveFromOuterToday')");
						setIcon(toReceiveFromOuter1);
						toReceiveFromOuter.add(toReceiveFromOuter1);
						var toReceiveFromOuter2 = new WebFXTreeItem("toReceiveFromOuterLastDay", "<fmt:message key='edoc.customer.type.yesterday'/>", "javascript:showToReceiveList('toReceiveFromOuterLastDay')");
						setIcon(toReceiveFromOuter2);
						toReceiveFromOuter.add(toReceiveFromOuter2);
						var toReceiveFromOuter3 = new WebFXTreeItem("toReceiveFromOuterThisWeek", "<fmt:message key='edoc.customer.type.thisweek'/>", "javascript:showToReceiveList('toReceiveFromOuterThisWeek')");
						setIcon(toReceiveFromOuter3);
						toReceiveFromOuter.add(toReceiveFromOuter3);
						var toReceiveFromOuter4 = new WebFXTreeItem("toReceiveFromOuterLastWeek", "<fmt:message key='edoc.customer.type.lastweek'/>", "javascript:showToReceiveList('toReceiveFromOuterLastWeek')");
						setIcon(toReceiveFromOuter4);
						toReceiveFromOuter.add(toReceiveFromOuter4);
						var toReceiveFromOuter5 = new WebFXTreeItem("toReceiveFromOuterThisMonth", "<fmt:message key='edoc.customer.type.thismonth'/>", "javascript:showToReceiveList('toReceiveFromOuterThisMonth')");
						setIcon(toReceiveFromOuter5);
						toReceiveFromOuter.add(toReceiveFromOuter5);
						var toReceiveFromOuter6 = new WebFXTreeItem("toReceiveFromOuterLastMonth", "<fmt:message key='edoc.customer.type.lastmonth'/>", "javascript:showToReceiveList('toReceiveFromOuterLastMonth')");
						setIcon(toReceiveFromOuter6);
						toReceiveFromOuter.add(toReceiveFromOuter6);
						var toReceiveFromOuter7 = new WebFXTreeItem("toReceiveFromOuterThisYear", "<fmt:message key='edoc.customer.type.thisyear'/>", "javascript:showToReceiveList('toReceiveFromOuterThisYear')");
						setIcon(toReceiveFromOuter7);
						toReceiveFromOuter.add(toReceiveFromOuter7);
						var toReceiveFromOuter8 = new WebFXTreeItem("toReceiveFromOuterLastYear", "<fmt:message key='edoc.customer.type.previous.years'/>", "javascript:showToReceiveList('toReceiveFromOuterLastYear')");
						setIcon(toReceiveFromOuter8);
						toReceiveFromOuter.add(toReceiveFromOuter8);					
						toReceive.add(toReceiveFromInner);
						toReceive.add(toReceiveFromOuter);	
						
						//已签收
						var receivedRoot = new WebFXTree("receivedRoot", "<fmt:message key='common.toolbar.sign.label' bundle='${v3xCommonI18N}' />", "");
						var received = new WebFXTreeItem("received", "<fmt:message key='common.toolbar.sign.label' bundle='${v3xCommonI18N}' />", "javascript:showToReceiveList('received')");
						receivedRoot.add(received);
						//已签收内部来文
						var receivedFromInner = new WebFXTreeItem("receivedFromInner", "<fmt:message key='edoc.element.receive.send_unit_type.inner'/>", "javascript:showToReceiveList('receivedFromInner')");
						var receivedFromInner1 = new WebFXTreeItem("receivedFromInnerToday", "<fmt:message key='edoc.customer.type.today'/>", "javascript:showToReceiveList('receivedFromInnerToday')")
						setIcon(receivedFromInner1);
						receivedFromInner.add(receivedFromInner1);
						var receivedFromInner2 = new WebFXTreeItem("receivedFromInnerLastDay", "<fmt:message key='edoc.customer.type.yesterday'/>", "javascript:showToReceiveList('receivedFromInnerLastDay')");
						setIcon(receivedFromInner2);
						receivedFromInner.add(receivedFromInner2);
						var receivedFromInner3 = new WebFXTreeItem("receivedFromInnerThisWeek", "<fmt:message key='edoc.customer.type.thisweek'/>", "javascript:showToReceiveList('receivedFromInnerThisWeek')");
						setIcon(receivedFromInner3);
						receivedFromInner.add(receivedFromInner3);
						var receivedFromInner4 = new WebFXTreeItem("receivedFromInnerLastWeek", "<fmt:message key='edoc.customer.type.lastweek'/>", "javascript:showToReceiveList('receivedFromInnerLastWeek')");
						setIcon(receivedFromInner4);
						receivedFromInner.add(receivedFromInner4);
						var receivedFromInner5 = new WebFXTreeItem("receivedFromInnerThisMonth", "<fmt:message key='edoc.customer.type.thismonth'/>", "javascript:showToReceiveList('receivedFromInnerThisMonth')");
						setIcon(receivedFromInner5);
						receivedFromInner.add(receivedFromInner5);
						var receivedFromInner6 = new WebFXTreeItem("receivedFromInnerLastMonth", "<fmt:message key='edoc.customer.type.lastmonth'/>", "javascript:showToReceiveList('receivedFromInnerLastMonth')");
						setIcon(receivedFromInner6);
						receivedFromInner.add(receivedFromInner6);
						var receivedFromInner7 = new WebFXTreeItem("receivedFromInnerThisYear", "<fmt:message key='edoc.customer.type.thisyear'/>", "javascript:showToReceiveList('receivedFromInnerThisYear')");
						setIcon(receivedFromInner7);
						receivedFromInner.add(receivedFromInner7);
						var receivedFromInner8 = new WebFXTreeItem("receivedFromInnerLastYear", "<fmt:message key='edoc.customer.type.previous.years'/>", "javascript:showToReceiveList('receivedFromInnerLastYear')");
						setIcon(receivedFromInner8);
						receivedFromInner.add(receivedFromInner8); 
						//已签收外部来文
						var receivedFromOuter = new WebFXTreeItem("receivedFromOuter", "<fmt:message key='edoc.element.receive.send_unit_type.outer'/>", "javascript:showToReceiveList('receivedFromOuter')");
						var receivedFromOuter1 = new WebFXTreeItem("receivedFromOuterToday", "<fmt:message key='edoc.customer.type.today'/>", "javascript:showToReceiveList('receivedFromOuterToday')")
						setIcon(receivedFromOuter1);
						receivedFromOuter.add(receivedFromOuter1);
						var receivedFromOuter2 = new WebFXTreeItem("receivedFromOuterLastDay", "<fmt:message key='edoc.customer.type.yesterday'/>", "javascript:showToReceiveList('receivedFromOuterLastDay')");
						setIcon(receivedFromOuter2);
						receivedFromOuter.add(receivedFromOuter2);
						var receivedFromOuter3 = new WebFXTreeItem("receivedFromOuterThisWeek", "<fmt:message key='edoc.customer.type.thisweek'/>", "javascript:showToReceiveList('receivedFromOuterThisWeek')");
						setIcon(receivedFromOuter3);
						receivedFromOuter.add(receivedFromOuter3);
						var receivedFromOuter4 = new WebFXTreeItem("receivedFromOuterLastWeek", "<fmt:message key='edoc.customer.type.lastweek'/>", "javascript:showToReceiveList('receivedFromOuterLastWeek')");
						setIcon(receivedFromOuter4);
						receivedFromOuter.add(receivedFromOuter4);
						var receivedFromOuter5 = new WebFXTreeItem("receivedFromOuterThisMonth", "<fmt:message key='edoc.customer.type.thismonth'/>", "javascript:showToReceiveList('receivedFromOuterThisMonth')");
						setIcon(receivedFromOuter5);
						receivedFromOuter.add(receivedFromOuter5);
						var receivedFromOuter6 = new WebFXTreeItem("receivedFromOuterLastMonth", "<fmt:message key='edoc.customer.type.lastmonth'/>", "javascript:showToReceiveList('receivedFromOuterLastMonth')");
						setIcon(receivedFromOuter6);
						receivedFromOuter.add(receivedFromOuter6);
						var receivedFromOuter7 = new WebFXTreeItem("receivedFromOuterThisYear", "<fmt:message key='edoc.customer.type.thisyear'/>", "javascript:showToReceiveList('receivedFromOuterThisYear')");
						setIcon(receivedFromOuter7);
						receivedFromOuter.add(receivedFromOuter7);
						var receivedFromOuter8 = new WebFXTreeItem("receivedFromOuterLastYear", "<fmt:message key='edoc.customer.type.previous.years'/>", "javascript:showToReceiveList('receivedFromOuterLastYear')");
						setIcon(receivedFromOuter8);
						receivedFromOuter.add(receivedFromOuter8);
						received.add(receivedFromInner);
						received.add(receivedFromOuter);
	
						//退件箱
						var retreatRoor = new WebFXTree("retreatRoor", "<fmt:message key='edoc.receive.retreat_box' />", "");
						var retreat = new WebFXTreeItem("retreat", "<fmt:message key='edoc.receive.retreat_box' />", "javascript:showToReceiveList('listRecieveRetreat')");
						setIcon(retreat);
						retreatRoor.add(retreat);
						document.write(toReceive);
						document.write(received);
						document.write(retreat);
						if(from=="listRecieve") {
							if("${param.listType}"=="listRecieveRetreat") {//签收退件箱
								webFXTreeHandler.select(retreat);
							} else {
								webFXTreeHandler.select(toReceive);
							}						
						}

					//登记 (默认) 
					} else if(from == "listRegister" || from == "newEdocRegister") {
						//待登记
						var registerPendingRoot = new WebFXTree("registerPendingRoot", "<fmt:message key='edoc.workitem.state.register' />", "");
						var registerPending = new WebFXTreeItem("registerPending", "<fmt:message key='edoc.workitem.state.register' />", "javascript:showRegisterList('registerPending')");
						var registerByAutomatic = new WebFXTreeItem("registerByAutomatic", "<fmt:message key='edoc.receive.register.automatic' />", "javascript:showRegisterList('registerByAutomatic')");
						var registerByManual = new WebFXTreeItem("registerByManual", "<fmt:message key='edoc.receive.register.manual' />", "javascript:showOtherRegisterList('2','registerByManual')");
						setIcon(registerByAutomatic);
						setIcon(registerByManual);
						
						registerPending.add(registerByAutomatic);
						registerPending.add(registerByManual);
						<c:if test="${!v3x:hasPlugin('barCode')}">
						var registerByCode = new WebFXTreeItem("registerByCode", "<fmt:message key='edoc.receive.register.code' />", "javascript:showOtherRegisterList('3','registerByCode')");
						setIcon(registerByCode);
						registerPending.add(registerByCode);
						</c:if>
						
						
						registerPendingRoot.add(registerPending);
						
						//已登记
						var registerDoneRoot = new WebFXTree("registerDoneRoot", "<fmt:message key='exchange.edoc.registered' bundle='${exchangeI18N}' />", "");
						var registerDone = new WebFXTreeItem("registerDone", "<fmt:message key='exchange.edoc.registered' bundle='${exchangeI18N}' />", "javascript:showRegisterList('registerDone')");
						var registerDoneByAutomatic = new WebFXTreeItem("registerDoneByAutomatic", "<fmt:message key='edoc.receive.register.automatic' />", "javascript:showRegisterList('registerDoneByAutomatic')");				
						var registerDoneByManual = new WebFXTreeItem("registerDoneByManual", "<fmt:message key='edoc.receive.register.manual' />", "javascript:showRegisterList('registerDoneByManual')");
						setIcon(registerDoneByAutomatic);
						setIcon(registerDoneByManual);
						
						registerDone.add(registerDoneByAutomatic);
						registerDone.add(registerDoneByManual);
						<c:if test="${!v3x:hasPlugin('barCode')}">				
						var registerDoneByCode = new WebFXTreeItem("registerDoneByCode", "<fmt:message key='edoc.receive.register.code' />", "javascript:showRegisterList('registerDoneByCode')");
						setIcon(registerDoneByCode);
						registerDone.add(registerDoneByCode);
						</c:if>
						
						
						registerDoneRoot.add(registerDone);

						properties.put("registerDone",registerDone);
						
						//草稿箱
						var registerDraftRoot = new WebFXTree("registerDraftRoot", "<fmt:message key='edoc.receive.draft_box' />", "");
						var registerDraft = new WebFXTreeItem("registerDraft", "<fmt:message key='edoc.receive.draft_box' />", "javascript:showRegisterList('registerDraft')");
						var registerDraftByManual = new WebFXTreeItem("registerDraftByManual", "<fmt:message key='edoc.receive.register.manual' />", "javascript:showRegisterList('registerDraftByManual')");
						setIcon(registerDraftByManual);
						
						registerDraft.add(registerDraftByManual);
						<c:if test="${v3x:hasPlugin('barCode')}">
						var registerDraftByCode = new WebFXTreeItem("registerDraftByCode", "<fmt:message key='edoc.receive.register.code' />", "javascript:showRegisterList('registerDraftByCode')");
						setIcon(registerDraftByCode);
						registerDraft.add(registerDraftByCode);
						</c:if>  
						
						
						registerDraftRoot.add(registerDraft);
						
						//退件箱
						var registerRetreatRoot = new WebFXTree("registerRetreatRoot", "<fmt:message key='edoc.receive.retreat_box' />", "");
						var registerRetreat = new WebFXTreeItem("registerRetreat", "<fmt:message key='edoc.receive.retreat_box' />", "javascript:showRegisterList('registerRetreat')");
						setIcon(registerRetreat);
						registerRetreatRoot.add(registerRetreat);
						
						document.write(registerPending);
						document.write(registerDone);
						if(${hasEdocLeft}){
							document.write(registerDraft);
							document.write(registerRetreat);
						}
						if(from=="listRegister") {
							if("${param.listType}"=="registerDone") {
								webFXTreeHandler.select(registerDone);
							} else if("${param.listType}"=="registerDoneByAutomatic") {
								registerDone.expand();
								webFXTreeHandler.select(registerDoneByAutomatic);
							} else if("${param.listType}"=="registerDoneByManual") {
								registerDone.expand();
								webFXTreeHandler.select(registerDoneByManual);
							} else if("${param.listType}"=="registerDoneByCode") {
								registerDone.expand();
								webFXTreeHandler.select(registerDoneByCode);
							} else if("${param.listType}"=="registerDraft") {
								webFXTreeHandler.select(registerDraft);
							} else if("${param.listType}"=="registerDraftByManual") {
								registerDraft.expand();
								webFXTreeHandler.select(registerDraftByManual);
							} else if("${param.listType}"=="registerDraftByCode") {
								registerDraft.expand();
								webFXTreeHandler.select(registerDraftByCode);
							} else if("${param.listType}"=="registerRetreat") {
								webFXTreeHandler.select(registerRetreat);
							} else {
								webFXTreeHandler.select(registerPending);
							}
						} else if(from=="newEdocRegister") {
							registerPending.expand();
							webFXTreeHandler.select(registerByAutomatic);
						}

					//分发
					} else if(from == "listDistribute" || from == "newEdoc" || from=="listWaitSend") {
						//待分发
						var aistributiningRoot = new WebFXTree("aistributiningRoot", "<fmt:message key='edoc.receive.toAttribute' />", "");
						var aistributining = new WebFXTreeItem("aistributining", "<fmt:message key='edoc.receive.toAttribute' />", "javascript:showSWwaitDistributeList('')");
						aistributiningRoot.add(aistributining);
						var aistributining1 = new WebFXTreeItem("toSendToday", "<fmt:message key='edoc.customer.type.today'/>", "javascript:showSWwaitDistributeList('1')");
						setIcon(aistributining1);
						aistributining.add(aistributining1);
						var aistributining2 = new WebFXTreeItem("toSendLastDay", "<fmt:message key='edoc.customer.type.yesterday'/>", "javascript:showSWwaitDistributeList('2')");
						setIcon(aistributining2);
						aistributining.add(aistributining2);
						var aistributining3 = new WebFXTreeItem("toSendThisWeek", "<fmt:message key='edoc.customer.type.thisweek'/>", "javascript:showSWwaitDistributeList('3')");
						setIcon(aistributining3);
						aistributining.add(aistributining3);
						var aistributining4 = new WebFXTreeItem("toSendLastWeek", "<fmt:message key='edoc.customer.type.lastweek'/>", "javascript:showSWwaitDistributeList('4')");
						setIcon(aistributining4);
						aistributining.add(aistributining4);
						var aistributining5 = new WebFXTreeItem("toSendThisMonth", "<fmt:message key='edoc.customer.type.thismonth'/>", "javascript:showSWwaitDistributeList('5')");
						setIcon(aistributining5);
						aistributining.add(aistributining5);
						var aistributining6 = new WebFXTreeItem("toSendLastMonth", "<fmt:message key='edoc.customer.type.lastmonth'/>", "javascript:showSWwaitDistributeList('6')");
						setIcon(aistributining6);
						aistributining.add(aistributining6);
						var aistributining7 = new WebFXTreeItem("toSendThisYear", "<fmt:message key='edoc.customer.type.thisyear'/>", "javascript:showSWwaitDistributeList('7')");
						setIcon(aistributining7);
						aistributining.add(aistributining7);
						var aistributining8 = new WebFXTreeItem("toSendLastYear", "<fmt:message key='edoc.customer.type.previous.years'/>", "javascript:showSWwaitDistributeList('8')");
						setIcon(aistributining8);
						aistributining.add(aistributining8); 
						
						//草稿箱
						var waitSendRoot = new WebFXTree("waitSendRoot", "<fmt:message key='edoc.receive.draft_box' />", "");
						var waitSend = new WebFXTreeItem("waitSend", "<fmt:message key='edoc.receive.draft_box' />", "javascript:showSWDistributeDraft('draftBox','${stepBackState}')");
						setIcon(waitSend);
						waitSendRoot.add(waitSend);
						//退件箱
						var retreatRoot = new WebFXTree("retreatRoot", "<fmt:message key='edoc.receive.retreat_box' />", "showSWDistributeDraft('backBox','0')"); 
						//var retreat = new WebFXTreeItem("retreat", "<fmt:message key='edoc.receive.retreat_box' />", "javascript:showSWDistributeDraft('retreat','${stepBackState}')");
						var retreat = new WebFXTreeItem("retreat", "<fmt:message key='edoc.receive.retreat_box' />", "javascript:showSWDistributeDraft('retreat','${stepBackState}')");
						setIcon(retreat);
						
						retreatRoot.add(retreat);
						document.write(aistributining);

						if(${hasEdocLeft}){
							document.write(waitSend);
							document.write(retreat);
						}
						
						//if(from=="listWaitSend"){//webFXTreeHandler.select(waitSend);}
						//else 
						if(from=="listDistribute"){webFXTreeHandler.select(aistributining);}
						else{
							webFXTreeHandler.select(aistributining);
							}

					//已分发
					}else if( from=="listSent") {

						//已分发
						var listSentRoot = new WebFXTree("listSentRoot", "<fmt:message key='edoc.receive.attributed' />", ""); 
						var listSent = new WebFXTreeItem("listSent", "<fmt:message key='edoc.receive.attributed' />", "javascript:showSWDistributeList('')");
						listSentRoot.add(listSent);
						var listSent1= new WebFXTreeItem("toSendToday", "<fmt:message key='edoc.customer.type.today'/>", "javascript:showSWDistributeList('1')");
						setIcon(listSent1);
						listSent.add(listSent1);
						var listSent2 = new WebFXTreeItem("toSendLastDay", "<fmt:message key='edoc.customer.type.yesterday'/>", "javascript:showSWDistributeList('2')");
						setIcon(listSent2);
						listSent.add(listSent2);
						var listSent3 = new WebFXTreeItem("toSendThisWeek", "<fmt:message key='edoc.customer.type.thisweek'/>", "javascript:showSWDistributeList('3')");
						setIcon(listSent3);
						listSent.add(listSent3);
						var listSent4 = new WebFXTreeItem("toSendLastWeek", "<fmt:message key='edoc.customer.type.lastweek'/>", "javascript:showSWDistributeList('4')");
						setIcon(listSent4);
						listSent.add(listSent4);
						var listSent5 = new WebFXTreeItem("toSendThisMonth", "<fmt:message key='edoc.customer.type.thismonth'/>", "javascript:showSWDistributeList('5')");
						setIcon(listSent5);
						listSent.add(listSent5);
						var listSent6 = new WebFXTreeItem("toSendLastMonth", "<fmt:message key='edoc.customer.type.lastmonth'/>", "javascript:showSWDistributeList('6')");
						setIcon(listSent6);
						listSent.add(listSent6);
						var listSent7 = new WebFXTreeItem("toSendThisYear", "<fmt:message key='edoc.customer.type.thisyear'/>", "javascript:showSWDistributeList('7')");
						setIcon(listSent7);
						listSent.add(listSent7);
						var listSent8 = new WebFXTreeItem("toSendLastYear", "<fmt:message key='edoc.customer.type.previous.years'/>", "javascript:showSWDistributeList('8')");
						setIcon(listSent8);
						listSent.add(listSent8); 

						document.write(listSent);

						
						webFXTreeHandler.select(listSent);


					//待办
					}else if(from == "listPending" || from=="listZcdb") {
						//待办
						var notPendingRoot = new WebFXTree("notPending", "<fmt:message key='common.toolbar.state.pending.label' bundle='${v3xCommonI18N}'/>", "");
						var notPending = new WebFXTreeItem("notPending", "<fmt:message key='common.toolbar.state.pending.label' bundle='${v3xCommonI18N}'/>", "javascript:showPendingList('','')");
						setIcon(notPending);
						notPendingRoot.add(notPending);
						//在办
						var pendingRoot = new WebFXTree("pending", "<fmt:message key='edoc.receive.appending' />", ""); 
						var pending = new WebFXTreeItem("pending", "<fmt:message key='edoc.receive.appending' />", "javascript:showZcdbList2()");
						setIcon(pending);
						pendingRoot.add(pending);
						<c:forEach items= "${customerTypeList}" var="type">
						 	var typeName = "";
						    if('${type.bigTypeId}' == '3' ){
						     typeName = '${type.typeName}';
						    }
						    //流程节点
						    else if('${type.bigTypeId}' == '1' && '${type.typeName}' == '' ){
							    var code = '${type.typeCode}';
						    	typeName = code.substring("nodePolicy_".length,code.length);
							}
							//公文元素
							else if('${type.bigTypeId}' == '4' && '${type.typeId}'.length > 10 ){
								typeName = '${type.typeName}';
							}
						    else{
						     typeName = "<fmt:message key='${type.typeName}' />";
						    }
							var item1 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showPendingList('${type.condition}','${type.textfield}')");
							setIcon(item1);
							notPending.add(item1);
							var item2 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showZcdbList('${type.condition}','${type.textfield}')");
							setIcon(item2);
							pending.add(item2);
						</c:forEach>

						var allPending = new WebFXTree("allPending", "全部", "javascript:showPendingList2()");
						allPending.add(notPending);
						if(${hasEdocLeft}){
							allPending.add(pending);
						}
						document.write(allPending);
						
						//if(from=="listPending"){webFXTreeHandler.select(notPending);}
						//else if(from=="listZcdb"){webFXTreeHandler.select(pending);}
						if(from=="listPending" && nowlist=="notPending"){webFXTreeHandler.select(notPending);}
						else if(from=="listZcdb"  && nowlist=="pending"){webFXTreeHandler.select(pending);}
						//else{webFXTreeHandler.select(allPending);}

					//已办
					} else if(from == "listDone" || from=="listFinish") {
						//全部
						var alldone = new WebFXTree("alldone", "全部", "javascript:showDoneList2('','')");	

						//未办结
						var done = new WebFXTreeItem("done", "<fmt:message key='edoc.receive.notcomplete' />", "javascript:showDoneList()");
						setIcon(done);		
						<c:forEach items= "${customerTypeList}" var="type">
						    var typeName = "";
						    if('${type.bigTypeId}' == '3' ){
						     typeName = '${type.typeName}';
						    }
						    //流程节点
						    else if('${type.bigTypeId}' == '1' && '${type.typeName}' == '' ){
							    var code = '${type.typeCode}';
						    	typeName = code.substring("nodePolicy_".length,code.length);
							}
							//公文元素
							else if('${type.bigTypeId}' == '4' && '${type.typeId}'.length > 10 ){
								typeName = '${type.typeName}';
							}
						    else{
						     	typeName = "<fmt:message key='${type.typeName}' />";
						    }
						    var item1 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showDoneList('${type.condition}','${type.textfield}')");
						    setIcon(item1);
							done.add(item1);
						</c:forEach>
									
						//已办结
						var doneOver = new WebFXTreeItem("doneOver", "<fmt:message key='edoc.receive.incomplete' />", "javascript:showFinishList2()");
						var weiguidang = new WebFXTreeItem("weiguidang", "<fmt:message key='edoc.workitem.state.noarchive' />", "javascript:showArchiveList2('0')");
						setIcon(weiguidang);
						var yiguidang = new WebFXTreeItem("yiguidang", "<fmt:message key='edoc.workitem.state.archived' />", "javascript:showArchiveList2('1')");
						setIcon(yiguidang);
						<c:forEach items= "${customerTypeList}" var="type">
						<%--<c:if test="${(type.bigTypeId)!=0 && (type.bigTypeId)!=1}">--%>
						    	var typeName = "";
						   	 	if('${type.bigTypeId}' == '3') {
						     		typeName = '${type.typeName}';
						    	} 
						   		//流程节点
							    else if('${type.bigTypeId}' == '1' && '${type.typeName}' == '' ){
								    var code = '${type.typeCode}';
							    	typeName = code.substring("nodePolicy_".length,code.length);
								}
								//公文元素
								else if('${type.bigTypeId}' == '4' && '${type.typeId}'.length > 10 ){
									typeName = '${type.typeName}';
								}
						    	else {
						     		typeName = "<fmt:message key='${type.typeName}' />";
						    	}
						    	var item1 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showArchiveList('${type.condition}','${type.textfield}','0')");
						    	setIcon(item1);
								weiguidang.add(item1);
						    	var item2 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showArchiveList('${type.condition}','${type.textfield}','1')");
						    	setIcon(item2);
								yiguidang.add(item2);
						<%--</c:if>--%>
						</c:forEach>
						doneOver.add(weiguidang);
						doneOver.add(yiguidang);
						alldone.add(done);
						alldone.add(doneOver);
						if(${hasEdocLeft}){
							document.write(alldone);
						}
						//document.write(done);
						//document.write(doneOver);
						
						//已办/全部/未办结/已办结定位
						if(from=="listDone" && nowlist=="notFinish"){webFXTreeHandler.select(done);}
						else if(from=="listFinish"){webFXTreeHandler.select(doneOver);}
						//else{webFXTreeHandler.select(alldone);}

					//已阅
					} else if(from == "listReaded") {
						//全部
						var alldone = new WebFXTree("alldone", "全部", "javascript:showReadedList('','')");	

						var weiguidang = new WebFXTreeItem("weiguidang", "<fmt:message key='edoc.workitem.state.noarchive' />", "javascript:showArchiveListReaded2('0')");
						setIcon(weiguidang);
						var yiguidang = new WebFXTreeItem("yiguidang", "<fmt:message key='edoc.workitem.state.archived' />", "javascript:showArchiveListReaded2('1')");
						setIcon(yiguidang);
						<c:forEach items= "${customerTypeList}" var="type">
						<%--<c:if test="${(type.bigTypeId)!=0 && (type.bigTypeId)!=1}">--%>
						    var typeName = "";
						    if('${type.bigTypeId}' == '3'){
						     	typeName = '${type.typeName}';
						    }
						  	//流程节点
						    else if('${type.bigTypeId}' == '1' && '${type.typeName}' == '' ){
							    var code = '${type.typeCode}';
						    	typeName = code.substring("nodePolicy_".length,code.length);
							}
							//公文元素
							else if('${type.bigTypeId}' == '4' && '${type.typeId}'.length > 10 ){
								typeName = '${type.typeName}';
							}
						    else{
						     	typeName = "<fmt:message key='${type.typeName}' />";
						    }
						    var item1 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showArchiveListReaded('${type.condition}','${type.textfield}','0')");
						    setIcon(item1);
							weiguidang.add(item1);
						    var item2 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showArchiveListReaded('${type.condition}','${type.textfield}','1')");
						    setIcon(item2);
							yiguidang.add(item2);
						<%--</c:if>--%>
						</c:forEach>
						alldone.add(weiguidang);
						alldone.add(yiguidang);
						
						document.write(alldone)
						if("${param.hasArchive}" == "0"){
							webFXTreeHandler.select(weiguidang);
						}else if("${param.hasArchive}" == "1"){
							webFXTreeHandler.select(yiguidang);
						}else{
							webFXTreeHandler.select(alldone);
						}
					}
				</c:if>
				
				<c:if test="${(edocType==0 || edocType==2)}">
					if(from=="newEdoc"||from=="listWaitSend"||from=="backBox"){
						<c:choose>
							<c:when test="${edocType == 0}">
								
								/************************* 发文 **********************/
								//拟文 								
								<c:if test="${isEdocCreateRole}">
									var createRoot = new WebFXTree("createRoot", "<fmt:message key='edoc.new.niwen.drafting'/>", "");
									var create = new WebFXTreeItem("create", "<fmt:message key='edoc.new.niwen.drafting'/>", "javascript:showNewEdocList('')");
									setIcon(create);
									var firstItem;
									var i=0;
									<c:if test="${v3x:getSystemProperty('edoc.system.category')!='false'}">
									<c:forEach items= "${edocCategoryList}" var="type">
										var item = new WebFXTreeItem("customer_${type.id}", "${type.name}", "javascript:showNewEdocList('${type.id}')");
										setIcon(item);
										if(i==0) {
											//GOV-3893 公文拟文的时候，进入页面默认显示的是第一类行政公文，但是文单却显示的是全部文单
											//改为将焦点定位在公文起草上
											//firstItem = item;
										}
										i++;
										create.add(item);
									</c:forEach>
									</c:if>
									createRoot.add(create);
									if(${hasEdocLeft}){
										document.write(create);
									}
									//create.expand();
									
									//properties.put("create", create);
								</c:if>
								//草稿箱
								var listWaitSendRoot = new WebFXTree("listWaitSendRoot", "<fmt:message key='edoc.receive.draft_box' />", "");
								var listWaitSend = new WebFXTreeItem("listWaitSend", "<fmt:message key='edoc.receive.draft_box' />", "javascript:showWaitingSendList('','${sendBackState}')");
								//properties.put("listWaitSend", listWaitSend);
								//退稿箱
								var backBoxRoot = new WebFXTree("backBoxRoot", "<fmt:message key='edoc.sendBack.draftBox' />", "");
								var backBox = new WebFXTreeItem("backBox", "<fmt:message key='edoc.sendBack.draftBox' />", "javascript:showSendBack('','${sendBackState}')");
								<c:forEach items= "${edocCategoryList}" var="type">
									var waitSentObj = new WebFXTreeItem("customer_${type.id}", "${type.name}","javascript:showWaitingSendList('${type.id}','${sendBackState}')");
									setIcon(waitSentObj);
									var sendBackObj = new WebFXTreeItem("customer_${type.id}", "${type.name}", "javascript:showSendBack('${type.id}','${sendBackState}')");
									setIcon(sendBackObj);
									listWaitSend.add(waitSentObj);
									backBox.add(sendBackObj);
								</c:forEach>
								listWaitSendRoot.add(listWaitSend);
								backBoxRoot.add(backBox);
								//properties.put("backBox", backBox);

								if(${hasEdocLeft}){
									document.write(listWaitSend);
									document.write(backBox);
								}
								if(from=="newEdoc") {
									if(${isEdocCreateRole}) {
										if(typeof(firstItem)!="undefined" && firstItem!=null && firstItem!=undefined) {
											webFXTreeHandler.select(firstItem);
										} else {
											//webFXTreeHandler.select(create);
										}
									} else {
										form = "listSent";
									}
								}
								
								else if(from=="listWaitSend") {
									if(typeof(create)!="undefined") {
										//create.collapse();
									}
									<c:choose>
										<c:when test="${param.list=='backBox'}">
											if(typeof(backBox)!="undefined") {
												backBox.expand();
												webFXTreeHandler.select(backBox);
											}
											if(listSent){
											  //listSent.collapse();
											}
											
											listWaitSend.collapse();
										</c:when>
										<c:otherwise>
											//listWaitSend.expand();
											//listSent.collapse();
											//webFXTreeHandler.select(listWaitSend);
										</c:otherwise>
									</c:choose>
								}	
							</c:when>
							<c:otherwise>//签报
								<c:if test="${isEdocCreateRole}">
									var create = new WebFXTree("create", "<fmt:message key='edoc.new.niwen.drafting'/>", "javascript:showNewEdocList('')");
									document.write(create);
								</c:if>
								var listSent = new WebFXTree("listSent", "<fmt:message key='edoc.workitem.state.sended'/>", "javascript:showSentList('')");
								var listWaitSend = new WebFXTree("listWaitSend", "<fmt:message key='edoc.receive.draft_box' />", "javascript:showWaitingSendList('','${sendBackState}')");
								document.write(listSent);
								

								var qbBackBox = new WebFXTree("qbBackBox", "<fmt:message key='edoc.sendBack.draftBox' />", "javascript:showQbSendBack('','${sendBackState}')");
								if(${hasEdocLeft}){
									document.write(listWaitSend);
									document.write(qbBackBox);
								}

								if(from=="newEdoc") {
									webFXTreeHandler.select(create);
								} else if(from=="listSent") {
									webFXTreeHandler.select(listSent);
								} else if(from=="listWaitSend") {
									//webFXTreeHandler.select(listWaitSend);
								}else if(from=="backBox") {
									webFXTreeHandler.select(qbBackBox);
								}
							</c:otherwise>
						</c:choose>


						
					//已发
					}else if(from=="listSent"){
						<c:choose>
						<c:when test="${edocType == 0}">
							
							/************************* 发文 **********************/

							//已发
							var listSentRoot = new WebFXTree("listSentRoot", "<fmt:message key='edoc.workitem.state.sended'/>", "");
							var listSent = new WebFXTreeItem("listSent", "<fmt:message key='edoc.workitem.state.sended'/>", "javascript:showSentList('')");
							//properties.put("listSent", listSent);
							
							<c:forEach items= "${edocCategoryList}" var="type">
								var sentObj = new WebFXTreeItem("customer_${type.id}", "${type.name}", "javascript:showSentList('${type.id}')");
								setIcon(sentObj);
								listSent.add(sentObj);
							</c:forEach>
							listSentRoot.add(listSent);
							if(${hasEdocLeft}) {
								document.write(listSent);
							}
							listSent.expand();
							webFXTreeHandler.select(listSent);
							
							
						</c:when>
						<c:otherwise>//签报
							var listSent = new WebFXTree("listSent", "<fmt:message key='edoc.workitem.state.sended'/>", "javascript:showSentList('')");
							if(listSent!='false'){
								document.write(listSent);
							}

							webFXTreeHandler.select(listSent);

						</c:otherwise>
					</c:choose>

					
					
							
					/////////////////////////将节点添加选中项//////////////////////////
					
				//待办
				} else if(from == "listPending" || from=="listZcdb") {
						//全部
						var allPending = new WebFXTree("allPending", "全部", "javascript:showPendingList2()");

						//待办
						var notPending = new WebFXTreeItem("notPending", "<fmt:message key='common.toolbar.state.pending.label' bundle='${v3xCommonI18N}'/>", "javascript:showPendingList('','')");
						setIcon(notPending);
						//在办
						var pending = new WebFXTreeItem("pending", "<fmt:message key='edoc.receive.appending' />", "javascript:showZcdbList2()");
						setIcon(pending);
						<c:forEach items= "${customerTypeList}" var="type">
						    var typeName = "";
						    if('${type.bigTypeId}' == '3' ){
						     typeName = '${type.typeName}';
						    }
						    //流程节点
						    else if('${type.bigTypeId}' == '0' && '${type.typeName}' == '' ){
							    var code = '${type.typeCode}';
						    	typeName = code.substring("nodePolicy_".length,code.length);
							}
							//公文元素
							else if('${type.bigTypeId}' == '4' && '${type.typeId}'.length > 10 ){
								typeName = '${type.typeName}';
							}
						    else{
						     typeName = "<fmt:message key='${type.typeName}' />";
						    }
						    var item1 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showPendingList('${type.condition}','${type.textfield}')")
						    setIcon(item1);
						    var item2 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showZcdbList('${type.condition}','${type.textfield}')")
						    setIcon(item2);
							pending.add(item2);
							notPending.add(item1);
						</c:forEach>
						allPending.add(notPending);
						if(${hasEdocLeft}){
							allPending.add(pending);
							document.write(allPending);
						}
						
						if(from=="listPending" && nowlist=="notPending"){webFXTreeHandler.select(notPending);}
						else if(from=="listZcdb"  && nowlist=="pending"){webFXTreeHandler.select(pending);}
						else{
							//webFXTreeHandler.select(allPending);
							}

					//已办
					} else if(from == "listDone" ||from=="listFinish") {
						//全部
						var alldone = new WebFXTree("alldone", "全部", "javascript:showDoneList2('','')");	

						//未办结
						//var doneRoot = new WebFXTree("done", "<fmt:message key='edoc.receive.notcomplete' />", "");
						var done = new WebFXTreeItem("done", "<fmt:message key='edoc.receive.notcomplete' />", "javascript:showDoneList()");
						setIcon(done);
						<c:forEach items= "${customerTypeList}" var="type">
					    var typeName = "";
					    if('${type.bigTypeId}' == '3'){
					     typeName = '${type.typeName}';
					    }
					  	//流程节点
					    else if('${type.bigTypeId}' == '0' && '${type.typeName}' == '' ){
						    var code = '${type.typeCode}';
					    	typeName = code.substring("nodePolicy_".length,code.length);
						}
						//公文元素
						else if('${type.bigTypeId}' == '4' && '${type.typeId}'.length > 10 ){
							typeName = '${type.typeName}';
						}

					    else{
					     typeName = "<fmt:message key='${type.typeName}' />";
					    }
					    var item = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showDoneList('${type.condition}','${type.textfield}')");
					    setIcon(item);
						done.add(item);
						</c:forEach>
						//已办结
						var doneOver = new WebFXTreeItem("doneOver", "<fmt:message key='edoc.receive.incomplete' />", "javascript:showFinishList2()");
						var weiguidang = new WebFXTreeItem("weiguidang", "<fmt:message key='edoc.workitem.state.noarchive' />", "javascript:showArchiveList2('0')");
						setIcon(weiguidang);
						var yiguidang = new WebFXTreeItem("yiguidang", "<fmt:message key='edoc.workitem.state.archived' />", "javascript:showArchiveList2('1')");
						setIcon(yiguidang);
						<c:forEach items= "${customerTypeList}" var="type">
						//1 收文节点权限 0发文节点权限 2时间类别 3发文种类 4公文元素
						<%--<c:if test="${(type.bigTypeId)!=0 && (type.bigTypeId)!=1}">--%>
						    var typeName = "";
						    if('${type.bigTypeId}' == '3'){
						     typeName = '${type.typeName}';
						    }
						  	//流程节点
						    else if('${type.bigTypeId}' == '0' && '${type.typeName}' == '' ){
							    var code = '${type.typeCode}';
						    	typeName = code.substring("nodePolicy_".length,code.length);
							}
							//公文元素
							else if('${type.bigTypeId}' == '4' && '${type.typeId}'.length > 10 ){
								typeName = '${type.typeName}';
							}
						    else{
						     typeName = "<fmt:message key='${type.typeName}' />";
						    }
						    var item1 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showArchiveList('${type.condition}','${type.textfield}','0')");
						    setIcon(item1);
						    var item2 = new WebFXTreeItem("customer_${type.typeId}", "<c:if test='${type.edocElementLabel!=null}'><fmt:message key='${type.edocElementLabel}'/>-</c:if>"+typeName, "javascript:showArchiveList('${type.condition}','${type.textfield}','1')");
						    setIcon(item2);
							weiguidang.add(item1);
							yiguidang.add(item2);
						<%--</c:if>--%>
						</c:forEach>
						//doneRoot.add(done);
						doneOver.add(weiguidang);
						doneOver.add(yiguidang);
						alldone.add(done);
						alldone.add(doneOver);
						document.write(alldone)

						if(from=="listDone" && nowlist=="notFinish"){webFXTreeHandler.select(done);}
						else if(from=="listFinish"){webFXTreeHandler.select(doneOver);}
						else{webFXTreeHandler.select(alldone);}

					//分发
					}else if(from == "listFenfa") {
						//待分发
						//lijl添加,给原来的树结构再包了一层,以达到能收缩的功能
						var toSendRoot = new WebFXTree("toSendRoot", "<fmt:message key='edoc.receive.toAttribute' />", "");	
						var toSend = new WebFXTreeItem("toSend", "<fmt:message key='edoc.receive.toAttribute' />", "javascript:showDistributeList('toSend','')");
						var toSend1 = new WebFXTreeItem("toSendToday", "<fmt:message key='edoc.customer.type.today'/>", "javascript:showDistributeList('toSend','1')");
						setIcon(toSend1);
						toSend.add(toSend1);
						var toSend2 = new WebFXTreeItem("toSendLastDay", "<fmt:message key='edoc.customer.type.yesterday'/>", "javascript:showDistributeList('toSend','2')");
						setIcon(toSend2);
						toSend.add(toSend2);
						var toSend3 = new WebFXTreeItem("toSendThisWeek", "<fmt:message key='edoc.customer.type.thisweek'/>", "javascript:showDistributeList('toSend','3')");
						setIcon(toSend3);
						toSend.add(toSend3);
						var toSend4 = new WebFXTreeItem("toSendLastWeek", "<fmt:message key='edoc.customer.type.lastweek'/>", "javascript:showDistributeList('toSend','4')");
						setIcon(toSend4);
						toSend.add(toSend4);
						var toSend5 = new WebFXTreeItem("toSendThisMonth", "<fmt:message key='edoc.customer.type.thismonth'/>", "javascript:showDistributeList('toSend','5')");
						setIcon(toSend5);
						toSend.add(toSend5);
						var toSend6 = new WebFXTreeItem("toSendLastMonth", "<fmt:message key='edoc.customer.type.lastmonth'/>", "javascript:showDistributeList('toSend','6')");
						setIcon(toSend6);
						toSend.add(toSend6);
						var toSend7 = new WebFXTreeItem("toSendThisYear", "<fmt:message key='edoc.customer.type.thisyear'/>", "javascript:showDistributeList('toSend','7')");
						setIcon(toSend7);
						toSend.add(toSend7);
						var toSend8 = new WebFXTreeItem("toSendLastYear", "<fmt:message key='edoc.customer.type.previous.years'/>", "javascript:showDistributeList('toSend','8')");
						setIcon(toSend8);
						toSend.add(toSend8);
						toSendRoot.add(toSend);
						document.write(toSend);
						toSend.expand();
						//已分发
						var distributeDoneRoot = new WebFXTree("distributeDoneRoot", "<fmt:message key='edoc.receive.attributed' />", "");
						var distributeDone = new WebFXTreeItem("distributeDone", "<fmt:message key='edoc.receive.attributed' />", "javascript:showDistributeList('sent','')");
						var distributeDone1 = new WebFXTreeItem("sentToday", "<fmt:message key='edoc.customer.type.today'/>", "javascript:showDistributeList('sent','1')");
						setIcon(distributeDone1);
						distributeDone.add(distributeDone1);
						var distributeDone2 = new WebFXTreeItem("sentLastDay", "<fmt:message key='edoc.customer.type.yesterday'/>", "javascript:showDistributeList('sent','2')");
						setIcon(distributeDone2);
						distributeDone.add(distributeDone2);
						var distributeDone3 = new WebFXTreeItem("sentThisWeek", "<fmt:message key='edoc.customer.type.thisweek'/>", "javascript:showDistributeList('sent','3')")
						setIcon(distributeDone3);
						distributeDone.add(distributeDone3);
						var distributeDone4 = new WebFXTreeItem("sentLastWeek", "<fmt:message key='edoc.customer.type.lastweek'/>", "javascript:showDistributeList('sent','4')")
						setIcon(distributeDone4);
						distributeDone.add(distributeDone4);
						var distributeDone5 = new WebFXTreeItem("sentThisMonth", "<fmt:message key='edoc.customer.type.thismonth'/>", "javascript:showDistributeList('sent','5')")
						setIcon(distributeDone5);
						distributeDone.add(distributeDone5);
						var distributeDone6 = new WebFXTreeItem("sentLastMonth", "<fmt:message key='edoc.customer.type.lastmonth'/>", "javascript:showDistributeList('sent','6')")
						setIcon(distributeDone6);
						distributeDone.add(distributeDone6);
						var distributeDone7 = new WebFXTreeItem("sentThisYear", "<fmt:message key='edoc.customer.type.thisyear'/>", "javascript:showDistributeList('sent','7')")
						setIcon(distributeDone7);
						distributeDone.add(distributeDone7);
						var distributeDone8 = new WebFXTreeItem("sentLastYear", "<fmt:message key='edoc.customer.type.previous.years'/>", "javascript:showDistributeList('sent','8')")
						setIcon(distributeDone8);
						distributeDone.add(distributeDone8); 
						distributeDoneRoot.add(distributeDone);
						document.write(distributeDone);
						if(from=="listFenfa") {
							if('${param.modelType}'=='sent') {//发文已分发
								webFXTreeHandler.select(distributeDone);
							} else {//发文待分发
 								webFXTreeHandler.select(toSend);
							}
						} else {webFXTreeHandler.select(doneOver);}
					}
				</c:if>			
			</script>
	  	
	  	</div>
			</td>
			<td valign="top" style="position:relative;left:-10px;">
	  	 	<c:choose>
		  	<c:when test="${((param.from) eq 'listPending') || ((param.from) eq 'listDone') || ((param.from) eq 'listReaded')}">
		  		<c:if test="${edocType != 2}"><!-- xiangfan 2012-04-05 去掉 '签报管理' 的'自定义分类'功能按钮 -->
		  			
				<span class="custom_sort"  onclick="javascript:openCustomerType()" title="<fmt:message key='edoc.action.customType.label' />"
					alt="<fmt:message key='edoc.action.customType.label' />" style="cursor:pointer;"> </span>
		  		</c:if>
		  	</c:when>
		  	
	  	</c:choose>
	  	 </td>

		</tr>
	  	</table>
	</body>
</html>