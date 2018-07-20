//<%@ page language="java" contentType="text/html; charset=UTF-8" %>
//<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
$(function(){
	$("#searchButton").click(function(){
		var value = $("#select").val();
		var data = wfAjax.getUnenabledEntity(value||"");
		showResult(data);
	});
	$("#select").click(limitChar).keyup(limitChar);
	//显示列头
	showTitle();
});
var allData = {};
function selectPeopleFunction(obj){
}
function limitChar(){
	var v = $(this).val();
	if(v!=null && v.length>20){
		$(this).val(v.substr(0,20));
	}
}
function render(text, row, rowIndex, colIndex,col){
	return text;
}
function showResult(data){
	if(data==null || data.length==0){
		data = [];
	}
	allData = {};
	for(var i=0,len=data.length; i<len; i++){
		allData[data[i].id] = data[i];
	}
	$("#resultListArea").html('<table id="resultList" class="flexme3" style="display: none;"></table>');
	var ss = $("#resultList").ajaxgrid({
		usepager:false,
        click: selectPeopleFunction,
        render: render,
        datas: {
        	rows:data
        },
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            sortable: false,
            align: 'left',
            type: 'checkbox',
			isToggleHideShow:true
        }, {
            display: '${ctp:i18n("workflow.replaceNode.13")}',
            name: 'name',
            width: '55%',
            sortable: true,
            align: 'left',
			isToggleHideShow:false 
        }, {
            display: '所属单位',
            name: 'accountShortName',
            width: '20%',
            sortable: true,
            align: 'left'
        }, {
            display: '${ctp:i18n("workflow.replaceNode.14")}',
            name: 'typeName',
            width: '15%',
            sortable: true,
            align: 'left'
        }],
        sortname: "id",
        sortorder: "asc",
        showTableToggleBtn: false,
        parentId: "resultListArea",
        hChange: false,
        vChange: true,
		vChangeParam: {
            overflow: "hidden",
			autoResize:true
        },
        slideToggleBtn: false
    });
}
function showTitle(){
	$("#resultListArea").html('<table id="resultList" class="flexme3" style="display: none;"></table>');
	var ss = $("#resultList").ajaxgrid({
		usepager:false,
        click: selectPeopleFunction,
        render: render,
        datas: {
        	rows:[]
        },
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            sortable: false,
            align: 'left',
            type: 'checkbox',
			isToggleHideShow:true
        }, {
            display: '${ctp:i18n("workflow.replaceNode.13")}',
            name: 'name',
            width: '55%',
            sortable: true,
            align: 'left',
			isToggleHideShow:false 
        }, {
            display: '所属单位',
            name: 'accountShortName',
            width: '20%',
            sortable: true,
            align: 'left'
        }, {
            display: '${ctp:i18n("workflow.replaceNode.14")}',
            name: 'typeName',
            width: '15%',
            sortable: true,
            align: 'left'
        }],
        sortname: "id",
        sortorder: "asc",
        showTableToggleBtn: false,
        parentId: "resultListArea",
        hChange: false,
        vChange: true,
		vChangeParam: {
            overflow: "hidden",
			autoResize:true
        },
        slideToggleBtn: false
    });
}
function OK(){
	var canSize = window.dialogArguments.allSize;
	if(canSize==null){
		canSize = 10;
	}
	if(canSize<=0){
		canSize = 0;
	}
	if(canSize==0){
		$.alert("${ctp:i18n('workflow.replaceNode.15')}！");
		return;
	}else if(canSize>10){
		canSize = 10;
	}
	var checkObj = $("#resultList").find(":checkbox:checked");
	if(checkObj.size()==0){
		$.alert("${ctp:i18n('workflow.replaceNode.16')}！");
		return;
	}
	if(checkObj.size()>canSize){
		if(canSize==10){
			$.alert("${ctp:i18n('workflow.replaceNode.17')}！");
		}else{
//			$.alert("已经选择"+(10-canSize)+"个节点，本次最多只能选择"+canSize+"个节点！");
			$.alert($.i18n('workflow.replaceNode.18', (10-canSize), canSize)+"！");
		}
		return;
	}
	var result = [];
	checkObj.each(function(){
		var temp = allData[$(this).val()];
		if(temp!=null){
			temp.accountId = "";
			temp.accountShortname = "";
			result.push(temp);
		}
	});
	checkObj = null;
	return $.toJSON(result);
}