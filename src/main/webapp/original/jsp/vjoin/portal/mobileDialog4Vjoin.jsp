<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2016/3/10
  Time: 14:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>选择查询指标项</title>
</head>
<script>
	$().ready(function(){
		var queryId = "${queryId}";
        var indicatorId = parent.paramValue;
        console.log(indicatorId);
        console.log(queryId);
        if (indicatorId != null && indicatorId != "") {
    		var ajaxJoinFormManager = new joinFormManager();
    		ajaxJoinFormManager.getIndicatorName(queryId, indicatorId, {
    			success : function(rv) {
    				if (rv != "" && rv != null) {
    					var op = "<option value='"+indicatorId+"' >" + rv
    							+ "</option>"
    					$("#selected").append(op);
    				}
    			}
    		});
    	}
	});
    
    function selectOne() {
        var selectObj =$("#indicator");
        if ($("#selected").find("option").length > 0 || selectObj.find(":selected").length > 1) {
            alert("只能选择一个");
            return;
        }
        if(selectObj[0].selectedIndex > -1){
            $("option",selectObj).each(function(){
                if($(this)[0].selected){
                	var op = "<option value='"+$(this).val()+"' >" + $(this).text()+ "</option>";
					$("#selected").append(op);
                }
            });
        }
	}

	function removeOne() {
		$("#selected").empty();
	}
	
	function OK() {
		var ids = [];
		var names = [];
		var id = $("#selected").find("option").val();
		var name = $("#selected").find("option").text();
		console.log(id);
		console.log(name);
		ids[0] = id;
		names[0] = name;
		return [ ids, names ];
	}
	
	/**
     * 从右边移除
     */
    function toDelete(){
        var selected = $("#selected");
        if(selected && selected[0].selectedIndex > -1){
            $("option",selected).each(function(){
                if($(this)[0].selected){
                    $(this).remove();
                }
            });
        }
    }
	
  	//双击选中
    function toChoose() {
        if ($("#selected").find("option").length > 0) {
            alert("只能选择一个");
            return;
        }
        var seletOption = $('#indicator option:selected');
        var op = "<option value='" + seletOption.val() + "' >" + seletOption.text() + "</option>";
        $("#selected").append(op);
    }
</script>
<body scroll="no" style="overflow: hidden">
<table class="margin_t_5 margin_l_5 font_size12" align="center" height="70%" style="table-layout:fixed;float:left;margin-left: 15px;">
		<tr height="310">
			<td valign="top" width="260" height="100%">
				<p align="left" class="margin_b_5 w100b">${ctp:i18n('bizconfig.business.mobile.index.item.label')}</p>
				<select class="w100b selected_area" ondblclick="toChoose();" style="height: 330px;width:260px;;" multiple size="20" id="indicator">
					<c:forEach items="${indicators}" var="indicator" varStatus="status">
						<option value="${indicator.id}">${indicator.showTitle}</option>
			        </c:forEach>
				</select>
			</td>
			<td width="30" valign="middle" align="center">
				<span class="select_selected hand" onClick="selectOne()"> </span><br><br>
				<span class="select_unselect hand" onClick="removeOne()"> </span>
			</td>
			<td valign="top" width="260" height="100%">
				<p align="left" class="margin_b_5 w100b">${ctp:i18n("form.business.owner.set.selected.label")}</p>
				<select class="w100b selected_area" ondblclick="toDelete()" style="height: 330px;width:260px;;" multiple size="20" id="selected">
				</select>
			</td>
		</tr>
	</table>
</body>
</html>
