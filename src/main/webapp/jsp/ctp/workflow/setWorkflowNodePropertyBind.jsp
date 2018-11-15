<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>${ctp:i18n('subflow.setting.selectFlow')}</title>
    <%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body class="">
    <div style="height: 40px;">&nbsp;</div>
    <table class="margin_t_5 margin_l_5 font_size12" align="center" width="380" height="70%" style="table-layout:fixed;">
        <tr height="310">
            <td valign="top" width="260" height="100%">
                <p align="left" class="margin_b_5">${ctp:i18n('workflow.designer.node.unselected') }</p>
                <select class="w100b" style="width:260px;height: 300px;" size="20" multiple id="unselect" ondblClick="addOptions()">
                    <c:forEach items="${items}" var="item" varStatus="status">
                        <option value="${item.id}" type="unselect" title="${item.name}">${item.name}</option>
                    </c:forEach>
                </select>
            </td>
            <td width="30" valign="middle" align="center">
                <span class="select_selected hand" id="select_ico"> </span><br><br>
                <span class="select_unselect hand" id="unselect_ico"> </span>
            </td>
            <td valign="top" width="260" height="70%">
                <p align="left" class="margin_b_5 w100b">${ctp:i18n('workflow.designer.node.selected') }</p>
                <select class="w100b selected_area" style="height: 300px;width:260px;;" size="20" id="selected" ondblClick="delOptions()"> 
                    <c:forEach items="${selectedItems}" var="sitem" varStatus="status">
                        <option value="${sitem.id}" type="unselect" title="${sitem.name}">${sitem.name}</option>
                    </c:forEach>
                </select>
            </td>
            <td width="30" valign="middle" align="center">
                <span class="sort_up hand" id="up_ico"> </span><br><br>
                <span class="sort_down hand" id="down_ico"> </span>
            </td>
        </tr>
    </table>
<script type="text/javascript" src="${path}/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var items = ${itemsJSON};
//添加
function addOptions(){
    var allSize = 3, addedSize = 0, selected = [], hasNew = false, selectedSize = $("#selected option").size();
    var selectedObj = $("#selected");
    $("#unselect option:selected").each(function(){
    	var tempThis = $(this);
    	if(selectedObj.find("option[value="+tempThis.val()+"]").size()<=0){
    	    hasNew = true;
    	    if(addedSize + selectedSize < allSize){
	    	    var tempOp = "<option value='"+tempThis.val()+"' title=\""+tempThis.attr("title")+"\" >"+tempThis.text()+"</option>"
	    	    selected.push(tempOp);
                addedSize++;
	    	}
    	}
    	tempThis = null;
    });
    if(!hasNew){
        return;
    }
    if(selectedSize>=allSize){
        var temp = "${ctp:i18n('workflow.designer.node.max')}";
        temp = temp.replace(/\{0\}/g,allSize);
        $.alert(temp);
        return;
    }
    if(selected.length>0){
        selectedObj.append(selected.join(""));
    }
    selectedObj = null;
}
//删除
function delOptions(){
    $("#selected option:selected").each(function(){
        $(this).remove();
    });
}
function OK(){
	var result = {success:true};
	var checkedObjs = $("#selected option");
	if(checkedObjs.size()>0){
		var ids = [], names = [];
		checkedObjs.each(function(){
			ids.push($(this).val());
			names.push($(this).text());
		});
		result.ids = ids.join(",");
        result.names = names.join("、");
	}else{
        result.ids = "";
        result.names = "";
	}
    return $.toJSON(result);
}
$(function(){
	$("#select_ico").click(function (){
        addOptions();
    });
    $("#unselect_ico").click(function (){
        delOptions();
    });
    $("#up_ico").click(function (){
        var selected = $("#selected option:selected");
        if(selected.size()>0){
        	var prev = selected.prev("option");
        	if(prev.size()>0){
        		prev.insertAfter(selected);
        	}
        }
    });
    $("#down_ico").click(function (){
    	var selected = $("#selected option:selected");
        if(selected.size()>0){
            var next = selected.next("option");
            if(next.size()>0){
            	next.insertBefore(selected);
            }
        }
    });
	$("#selectAll").click(function(){
		if($(this).prop("checked")){
			$("tbody :checkbox").each(function(){
				$(this).prop("checked",true);
			});
		}else{
			$("tbody :checkbox").each(function(){
                $(this).prop("checked",false);
            });
		}
	});
	$("td.checkedFirstTdRadio").click(function(){
		var checkObj = $(this).prev("td").find(":checkbox");
		if(checkObj.size()>0){
			if(!checkObj.prop("checked")){
				checkObj.prop("checked",true);
			}else{
				checkObj.prop("checked",false);
			}
		}
		checkObj = null;
	});
	var searchobj = $.searchCondition({
        top:10,
        right:10,
        searchHandler: function(){
            var choose = $('#'+searchobj.p.id).find("option:selected").val();
            var value = "";
            if(choose === 'subject'){
                value =  $('#names').val();
            }
            var valueisNull = false;
            if(value==null || $.trim(value)==""){
            	valueisNull = true;
            }
            if(items!=null && items.length>0){
            	var unSelectObj = $("#unselect");
            	unSelectObj.empty();
                var itemArray = [];
                for(var i=0,len=items.length; i<len; i++){
                	var item = items[i];
                	if(valueisNull || item.name.indexOf(value)>-1){
	                    var tempOp = "<option value='"+item.id+"' title=\""+item.name+"\" >"+item.name+"</option>"
	                    itemArray.push(tempOp);
                	}
                }
                if(itemArray.length>0){
	                unSelectObj.append(itemArray.join(""));
	            }
                unSelectObj = null;
            }
        },
        conditions: [{
            id: 'names',
            name: 'names',
            type: 'input',
            text: '${ctp:i18n("workflow.designer.node.unselected") }',//标题
            value: 'subject'
        }]
    });
});
</script>
</body>
</html>