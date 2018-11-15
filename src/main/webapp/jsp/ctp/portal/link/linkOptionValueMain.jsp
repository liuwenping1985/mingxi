<%--
 $Author: zhout $
 $Rev: 33394 $
 $Date:: 2014-02-27 12:00:23#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>layout</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=linkSystemManager,linkOptionManager"></script>
<script>
$(document).ready(function() {
  var optionValueTable = $("#optionValueTable").ajaxgrid({
    colModel : [ {
      display : 'id',
      name : 'userId',
      width : '40',
      sortable : false,
      align : 'center',
      type : 'checkbox'
    },{
      display : '${ctp:i18n("link.jsp.user.name")}',
      name : 'userName',
      sortable : false,
      width : '${columnWidthPecent}%'
    },{
      display : '${ctp:i18n("link.jsp.user.loginName")}',
      name : 'loginName',
      sortable : false,
      width : '${columnWidthPecent}%'
    }
    <c:forEach var="linkOption" items="${linkOptionList}" varStatus="status">
		,{
	        display : '<c:out value="${linkOption.paramName}" default="null" escapeXml="true"/>',
	        name : 'paramName',
	        sortable : false,
	        width : '${columnWidthPecent}%'
	    }
	</c:forEach>
    ],
    click : optionValueTableClk,
    managerName : "linkOptionManager",
    managerMethod : "selectLinkOptionValues",
    params : {
    	linkSystemId : "${linkSystemId}"
    },
    render : optionValueTableRend,
    resizable : true,
    slideToggleBtn : false,
    height : 100,
    parentId : 'center',
    customize : false,
    vChange : {
      'changeTar' : 'center',
      'subHeight' : 90
    }
  });
  
  function optionValueTableRend(txt, data, r, c) {
    if(c > 2){
      return "<input type=\"password\" value=\"******\" disabled=\"disabled\"/>";
  	}
  	return txt;
  }

  //单击列表中一行，下面form显示详细信息
  function optionValueTableClk(data, r, c) {
    
  }
  
  optionValueTable.grid.resizeGrid(optionValueTable.grid.bDiv.offsetHeight - 32);
});
var linkSystemId = "${linkSystemId}";
function uploadCallBack(fileid, repeat){
  AjaxDataLoader.load(_ctxPath+"/portal/linkSystemController.do?method=importOptionValue&fileid=" + fileid + "&linkSystemId=" + linkSystemId + "&repeat=" + repeat, null, function(str){
    $.messageBox({
      'title': "${ctp:i18n('common.prompt')}",
      'msg': str,
      'type': 0,
      ok_fn: function () {
        parent.$("#linkOptionValueFrame").attr("src", "${path}/portal/linkSystemController.do?method=linkOptionValueMain&linkSystemId=" + linkSystemId);
      }
    });
  });
}

function downloadTemplate(){
  $("#downLoadIFrame").attr("src", "${path}/portal/linkSystemController.do?method=downloadTemplate&linkSystemId=${linkSystemId}");
}

function deleteOptionValue(){
  var checkedIds = $("input:checked", $("#optionValueTable"));
  if (checkedIds.size() == 0) {
    alert("${ctp:i18n('link.jsp.select.modify.category')}");
  } else {
    var userIds = new Array();
    for(var i = 0; i < checkedIds.size(); i++){
      userIds.push($(checkedIds[i]).val());
    }
	$.messageBox({
	  'type' : 1,
	  'msg' : "${ctp:i18n('link.jsp.del.yesorno')}",
	  ok_fn : function() {
	    var linkOptionIds = new Array();
	    <c:forEach var="linkOption" items="${linkOptionList}" varStatus="status">
	       linkOptionIds.push("${linkOption.id}");
	    </c:forEach>
	    new linkOptionManager().deleteParamValues(linkOptionIds, userIds, {
	      success : function(data) {
	        document.location.reload();
	      }   
	    });
	  }
	});
  }
}
</script>
<style>
.form_area table.only_table th{line-height:16px; text-align:left;}
</style>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'" >
        <div class="layout_center" id="center" layout="border:false" style="overflow:hidden">
            <div class="clearfix">
            <table id="optionValueButtonDiv" class="right" border="0" cellSpacing="0" cellPadding="0">
				<tr>
					<td align="right" class="padding_10" nowrap="nowrap">
						<input id="uploadPic" type="hidden"  class="comp common_button common_button_gray" comp="type:'fileupload',quantity:1,applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:false,extensions:'xls',firstSave:false,showReplaceOrAppend:true" />
						<input id="doImportOptionValue" style="padding-left:5px;padding-right:5px;" class="common_button common_button_gray" type="button" onclick="insertAttachment('uploadCallBack');" value="${ctp:i18n('application.95.label')}" />&nbsp;&nbsp;&nbsp;
						<input id="doDownload" type="button" style="padding-left:5px;padding-right:5px;" class="common_button common_button_gray" onclick="downloadTemplate();" value="${ctp:i18n('link.export.excel')}" title="${ctp:i18n('link.export.excel')}" />&nbsp;&nbsp;&nbsp;
						<input id="doDelete" type="button" style="padding-left:5px;padding-right:5px;" class="common_button common_button_gray" onclick="deleteOptionValue();" value="${ctp:i18n('link.jsp.del')}" />
					</td>
				</tr>
			</table>
			</div>
			<div class="clearfix">
			<table id="optionValueTable" class="flexme3" style="display: none"></table>
			</div>
        </div>
    </div>
    <iframe id="downLoadIFrame" name="downLoadIFrame" src="" style="display: none;"/>
</body>
</html>