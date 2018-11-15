<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

var isNewForm = "${formBean.newForm }";

//将所属应用置灰且只有计划格式的值
var locationUrl = window.location.href;

if(locationUrl.indexOf("form/fieldDesign.do")>-1){
	//将所属应用固定为计划格式
	var planFormatSelect = $("#categoryId");
	planFormatSelect.attr("disabled", "true");
	var option = document.createElement("OPTION");
	option.text = $.i18n('common.detail.label.dynamicForm');
	option.value = "6";
	option.selected = true;
	planFormatSelect[0].add(option);
	//屏蔽掉唯一标识
	$("#setUniqueMarkBtn").hide();
	//屏蔽掉移动设计编辑器
	$("#setFormStyleBtn").hide();
}



