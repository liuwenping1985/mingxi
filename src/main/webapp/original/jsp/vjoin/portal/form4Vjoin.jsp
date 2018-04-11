<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">
var id = "";
var parentId = "";
var sectionName = "";
var singleBoardId = "";
var sectionBeanId = "";
$().ready(function(){
	$("#formTree").tree({
		idKey : "id",
		pIdKey : "parentId",
		nameKey : "sectionName",
		onClick : clk,
		onDblClick : function(e, treeId, node) {
			if ($("#selected").find("option").length > 0) {
				alert("只能选择一个");
				return;
			}
		    if (node.data.singleBoardId != "" && node.data.singleBoardId != null && $("#selected").find("option").length == 0) {
			    var op = "<option value='"+node.data.singleBoardId+"' >" + node.data.sectionName + "</option>"
				$("#selected").append(op);
			}
      	},
		nodeHandler : function(n) {
			n.open = true;
		}
	});
	
	var values = parent.paramValue;
	var type = "${type}";
	if (values != null && values != "") {
		var ajaxJoinFormManager = new joinFormManager();
		ajaxJoinFormManager.getFormName(type, values, {
			success : function(rv) {
				if (rv != "" && rv != null) {
					var op = "<option value='"+values+"' >" + rv
							+ "</option>"
					$("#selected").append(op);
				}
			}
		});
	}

	$("#searchBtn").on("click", function() {
        var searchVal = encodeURIComponent($("#search").val());
        location.href = _ctxPath + "/vjoin/portal.do?method=form4Vjoin&type=" + type + "&searchVal=" + searchVal;
    })
});

	function clk(e, treeId, node) {
		id = node.data.id;
		singleBoardId = node.data.singleBoardId;
		sectionName = node.data.sectionName;
		parentId = node.data.parentId;
		sectionBeanId = node.data.sectionBeanId;
	}

	function selectOne() {
		if ($("#selected").find("option").length > 0) {
			alert("只能选择一个");
			return;
		}
		if (sectionBeanId != "" && sectionBeanId != null) {
			var op = "<option value='"+singleBoardId+"' >" + sectionName
					+ "</option>"
			$("#selected").append(op);
		} else {
			alert("请选择表单");
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
	
</script>
</head>
<body scroll="no" style="overflow: hidden">
<table class="margin_t_5 margin_l_5 font_size12" align="center" height="70%" style="table-layout:fixed;float:left;margin-left: 15px;">
		<tr height="310">
			<td valign="top" width="260" height="100%">
				<div>
					<div style="float: left;">
						<p align="left" class="margin_b_5">${ctp:i18n("form.business.owner.set.alternative.label")}</p>
					</div>
					<div style="float: right;">
						<input type="text" value="${searchVal}" id="search" style="height: 17px;line-height: 16px">
						<em class="ico16 search_16" id="searchBtn"></em>
					</div>
				</div>
				<div style="float: left;border:1px solid #e4e4e4;height: 330px;width:260px;overflow: auto">
					<ul id="formTree"></ul>
				</div>
			</td>
			<td width="30" valign="middle" align="center">
				<span class="select_selected hand" onClick="selectOne()"> </span><br><br>
				<span class="select_unselect hand" onClick="removeOne()"> </span>
			</td>
			<td valign="top" width="260" height="100%">
				<p align="left" class="margin_b_5 w100b">${ctp:i18n("form.business.owner.set.selected.label")}</p>
				<select class="w100b selected_area" ondblclick="toDelete()" style="height: 330px;width:260px;" multiple size="20" id="selected">
				</select>
			</td>
		</tr>
	</table>
</body>
</html>