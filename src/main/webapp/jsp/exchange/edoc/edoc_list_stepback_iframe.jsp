<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!–[if IE 10]>
<!DOCTYPE>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9">
<![endif]–>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="../exchangeHeader.jsp" %>
	<%@ include file="../../common/INC/noCache.jsp"%>
	<%
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    %>
<title></title>

<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet"
	href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"/>
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>';
  function deleteItem() {
    var checkedIds = document.getElementsByName('id');
    var len = checkedIds.length;
    var str = "";
    for ( var i = 0; i < len; i++) {
      var checkedId = checkedIds[i];
      if (checkedId && checkedId.checked
          && checkedId.parentNode.parentNode.tagName == "TR") {
        str += checkedId.value;
        str += ","
      }
    }
    //-- justify is any id has been chose.

    if (str == null || str == "") {
      alert("至少选择一个删除对象");
      return false;
    }

    //-- justification end.

    str = str.substring(0, str.length - 1);

    if (window.confirm("确实要进行删除操作?'是' 请按'确定',否则'取消'")) {

      document.location.href = '${exchangeEdoc}?method=edocDelete&type=sign&id='
          + str;
    }

  }

  //已回退c
  function editItem(id) {
    /*if(v3x.getBrowserFlag('pageBreak')){
    	parent.detailFrame.window.location='${exchangeEdoc}?method=receiveDetail&id='+id+'&modelType=toReceive&userId=${current_user_id}&fromlist=true';
    }else{
    	v3x.openWindow({
         	url: '${exchangeEdoc}?method=receiveDetail&id='+id+'&modelType=toReceive&userId=${current_user_id}',
         	dialogType:'open',
         	workSpace: 'yes'
    	});
    }*/
    var url = '${exchangeEdoc}?method=receiveDetail&id=' + id
        + '&modelType=toReceive&userId=${current_user_id}';
    openExchangeDetail(url);
  }
  function openExchangeDetailDp(_url) {
  	// xiangfan 2012-1-10 'subject'判断是否是交换公文
  	var rv = v3x.openWindow({
  		url : _url,
  		resizable : "yes",
  		FullScrean : 'yes',
  		dialogType : '1'
  	});

  	if ((typeof rv == "string" && rv == "true")
  			|| (typeof rv == "boolean" && rv == true)) {
  		parent.location.reload(true);
  	}
  }
  function showByStatus() {
    window.document.searchForm.submit();
  }
  function showData(summaryId,affairId) {
    var url =_ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=stepBackRecord&affairId="+affairId+"&summaryId="+summaryId;
    openExchangeDetailDp(url);

  }
</script>
<style>
.abtn{
width:24px;
height:24px;
margin-left:10px;
padding-left:1px;
color:#111;
border:1px solid  #99948c;
border-bottom-width:1px;
border-radius:0px 5px 5px 0px;
display:inline-block;
background-color:rgb(234, 234, 234);
}
.abtn:hover{
background-color:rgb(247, 247, 247);
}
.ebtn{
    width:18px;
    height:18px;
    line-height:16px;
    margin-top:5px;
    display:inline-block;
    background-image:url("<%=ctxPath%>/skin/default/images/icon16.png?v=5_6_6_04");
    background-position-x:-31px;
}
</style>
</head>
<body  onload="setMenuState('menu_pending');">
<iframe name="saveAsExcelFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="webfx-menu-bar" style="width:90%;">
			<form action="" name="searchForm" id="searchForm" method="get"
				onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<input type="hidden" value="<c:out value='${modelType}' />" name="modelType">
				<input type="hidden" value="" name="selectedValue" />
				<div class="div-float-right" style="margin-right:5px;">
				<div class="div-float" id="selectDiv" name="selectDiv" style="margin-right:-8px">
					<select name="condition" id="condition" style="height:25px;margin-right:10px" onChange="showNextSpecialCondition(this);" class="condition">
							<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							<option value="sendUnit"  <c:if test="${condition == 'sendUnit'}">selected</c:if>><fmt:message key="exchange.edoc.sendaccount" /></option>
							<option value="subject" <c:if test="${condition == 'subject'}">selected</c:if>><fmt:message key="exchange.edoc.title" /></option>
							<option value="docMark" <c:if test="${condition == 'docMark'}">selected</c:if>><fmt:message key="exchange.edoc.wordNo" /></option>
					</select>
					</div>
			  	<div id="sendUnitDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield" style="height:24px;" <c:if test="${condition == 'sendUnit'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
			  	</div>
			  	<div id="subjectDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield" style="height:24px;" <c:if test="${condition == 'subject'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
			  	</div>
			  	<div id="docMarkDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield" style="height:24px;" <c:if test="${condition == 'docMark'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
			  	</div>
					<a class="abtn" href="javascript:doSearch();"><em class="ebtn"></em></a>
					&nbsp;		
			</form>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div class="scrollList" id="scrollListDiv">
			<form id="listForm">
			<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true" className="sort ellipsis">
				<v3x:column width="15%" type="String" onClick="showData('${bean.id}','${bean.edocId}');"
					label="公文文号" className="cursor-hand sort"  value="${bean.docMark}" alt="${bean.docMark}">
				</v3x:column>
				<v3x:column width="12%" type="String" onClick="showData('${bean.id}','${bean.edocId}');"
					label="退文时间" className="cursor-hand sort" alt="${bean.recTime}">
					<span title="<fmt:formatDate value="${bean.recTime}" pattern="yyyy-MM-dd HH:mm:ss"/>">
						<fmt:formatDate value="${bean.recTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm:ss" />&nbsp;
					</span>
				</v3x:column>
				<v3x:column width="35%" type="String" onClick="showData('${bean.id}','${bean.edocId}');"
					label="exchange.edoc.title" className="cursor-hand sort"  value="${bean.subject}" alt="${bean.subject}">
				</v3x:column>

				<v3x:column width="14%" type="String" onClick="showData('${bean.id}','${bean.edocId}');"
					label="发文单位" className="cursor-hand sort" value="${bean.sendUnit}" alt="${bean.sendUnit}">
				</v3x:column>

				<v3x:column width="12%" type="String"  onClick="showData('${bean.id}','${bean.edocId}');"
					label="接收单位/部门" className="cursor-hand sort" value="${bean.recAccountName}" alt="${bean.recAccountName}">
				</v3x:column>
				
				<v3x:column width="18%" type="String"  onClick="showData('${bean.id}','${bean.edocId}');"
					label="退文原因" className="cursor-hand sort" value="${bean.stepBackInfo}" alt="${bean.stepBackInfo}">
				</v3x:column>
				
				
			</v3x:table>
			</form></div>
		</td>
	</tr>
</table>
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='${exchangelabel}' />", [1,2], pageQueryMap.get('count'), _("ExchangeLang.detail_info_6012"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
function exportExcel(){
	  saveAsExcelFrame.location.href ="<c:url value='/exchangeEdoc.do'/>?method=exportExcel&flag=stepBack";
}
//xl 7-15显示滚动条
$(function(){
	var width=$("body").css("width");
	$("#scrollListDiv").css("width",width);
	$(".fDIV").css("width",width);
})

//处理没有数据时页面宽度撑大。
$(function(){
	var width=document.body.clientWidth;
	$("#bDivlistTable").css("width",width);
})

</script>
</body>
</html>