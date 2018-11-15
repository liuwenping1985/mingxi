<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建业务配置</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
</head>
<body style="width: 100%;height: 100%;">
<form id="serachForm" name = "serachForm" method="post" action="${path}/form/business.do?method=listbizdata&type=${param.type}" target="formTemplateTreeFrame">
     <input type="hidden" id="type" value="${param.type}">
     <input type="hidden" id="condition" value="creator">
     <input type="hidden" id="textfield" value="creator">
     <input type="hidden" id="queryType" value="creator">
</form>
<table border="0" cellpadding="0" cellspacing="0" width="100%"	height="100%"   >
	<tr >
		<td colspan="4"  width="100%" height="100%">
		<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0" >
			<tr class="border-bottom webfx-menu-bar-gray">
				<td width="" height="30" align="right" >
					<c:if test="${queryType eq '2' }">
					<!-- 我创建的 -->
					<label for="user" class="font_size12">
						<input type="radio" id="user" name="templatesRange" checked value="user" onClick="toShowTempsFromUserOrAdmin('creator')" />
						${ctp:i18n("bizconfig.create.my") }
					</label>
					</c:if>
					
					<!-- 本单位所有 -->
					<label for="admin" class="font_size12">
						<input type="radio" id="admin" name="templatesRange" value="admin" onClick="toShowTempsFromUserOrAdmin('account')" />
						${ctp:i18n("bizconfig.create.all") }
					</label>
				</td>
			</tr>

			<tr>
				<td class="" colspan="3" id="formapptree" valign="top" height="90%">
                    <div id="allColumns" class="scrollList padding5" style="height: 100%;width: 100%">
                        <iframe id = "formTemplateTreeFrame" name = "formTemplateTreeFrame" height="100%" width="100%"  class="border_t" style="border-left-width: 0px;"></iframe>
                    </div>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	$(document).ready(function() {
	  var catg = new Array();
	  <c:forEach items="${category}" var="item">
	  catg.push({text:"${fn:escapeXml(item.name)}",value:"${item.id}"});
	  </c:forEach>
	  if(catg.length == 0){
	    catg.push({text:"",value:""});
	  }
	    var searchobj = $.searchCondition({
	        top:3,
	        left:10,
	        searchHandler: function(){
	            var choose = $('#'+searchobj.p.id).find("option:selected").val();
	            var value = "";
	            if(choose === 'subject'){
	                value =  $('#names').val();
	            }else if(choose === 'categoryId'){
	                value = $('#categorys').val();
	                if(value == "0"){
	                  return;
	                }
	            }else{
	              choose = 'subject';
	            }
                search($("#queryType").val(),choose,value);
	        },
	        conditions: [{
	            id: 'names',
	            name: 'names',
	            type: 'input',
	            text: "${ctp:i18n('formsection.config.template.name')}",
	            value: 'subject'
	        }, {
	            id: 'categorys',
	            name: 'categorys',
	            type: 'select',
	            text: "${ctp:i18n('formsection.config.template.category')}",
	            value: 'categoryId',
	            items: catg
	        }]
	    });

        <%--@elvariable id="queryType" type="ant"--%>
        <c:if test="${param.type eq 'bizmap'}">
            searchobj.g.hideItem("categorys");
        </c:if>
        <c:if test="${queryType eq '1' }">
            $('#admin').click();
        </c:if>
        <c:if test="${queryType eq '2' }">
            $('#user').click();
        </c:if>
	});

    function search(queryType,condition,value){
        $("#queryType").val(queryType);
        $("#condition").val(condition);
        $("#textfield").val(value);
        $("#serachForm").jsonSubmit({
            targetWindow:document.getElementById('formTemplateTreeFrame').contentWindow
        });
    }

	/*
	* 我创建的和所有的切换
	*/
	function toShowTempsFromUserOrAdmin(queryType) {
        search(queryType,"","");
	}

	function getSelectedNodes(){
	  try{
		return document.getElementById('formTemplateTreeFrame').contentWindow.getSelectedNodes();
	  }catch(e){
	    return null;
	  }
	}

    function selectToCreateMenu(){
        parent.selectToCreateMenu();
    }

</script>
</body>
</html>