<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>选择节点权限</title>
<script type="text/javascript">
var type = "${type}";
function ok(){
	var domList = listFrame.document.getElementById('permissionList').getElementsByTagName('input');
    var checkBoxlist = [];  // 定义一个存储checkbox的空数组 
    var len = domList.length;　　//缓存到局部变量  // 第一步获取的数组的长度 
    while (len--) {　　//使用while的效率会比for循环更高   // 开始循环判断 
	    　　if (domList[len].type == 'checkbox') {   // 如果类型为checkbox即为题目所需的复选框 
	    	checkBoxlist.push(domList[len]);
	    　　}   
     } 
    if (!checkBoxlist) {
        return true;
    }
    var ids="";
    var names="";
    for (var i = 0; i < checkBoxlist.length; i++) {
            var checkbox = checkBoxlist[i];
            if (!checkbox.checked)
                continue;
           ids+=$(checkbox).val()+",";
           names+=$(checkbox).parent().parent().parent().children("td").eq(1).children("div").attr("title")+",";    
    }
	ids=ids.substring(0,ids.length-1);
	if(ids.indexOf(",")>-1){
	   alert("只能选择一个节点权限");
	   return;
	}
    if(ids==""&& type == 1){
	   alert("未选择权限");
	   return;
	}
	
	names=names.substring(0,names.length-1);
	var valueArr = new Array();
	valueArr.push(ids);	
	valueArr.push(names);
	window.returnValue = valueArr;
	window.close();	
}

</script>
</head>	
<body  style="overflow: hidden" onkeydown="listenerKeyESC()" width="100%" height="100%">
<form name="preIssusForm" action=""  method="post" >
	<table  width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr >
			<td colspan="2" width="100%" height="100%">
				<iframe width="100%" height="470" frameborder="1" 
				src="${url}"
				name="listFrame" id="listFrame" >
				</iframe>
			</td>
		</tr>
		<tr height="42">
			<td height="42" align="right" class="bg-advance-bottom" colspan="2">
				<input type="button" onclick="ok()" value="${ctp:i18n('common.button.ok.label')}" class="common_button common_button_gray">&nbsp;
				<input type="button" onclick="window.close()" value="${ctp:i18n('common.button.cancel.label')}" class="common_button common_button_gray">
			</td>
		</tr>
	</table>
</form>
</body>
</html>