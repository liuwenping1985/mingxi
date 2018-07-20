<%--
 $Author: dengxj $
 $Rev: 603 $
 $Date:: 2014-06-10

 Copyright (C) 2014 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据关联HR重定向</title>
</head>
<body class="font_size12 margin_5">
<div id="content">

    <div>
        <span>预归档到：</span>
        <select id="archiveId" style="width: 100px">
            <option selected="selected" value="">${ctp:i18n('form.timeData.none.lable')}</option>
            <option value="1">${ctp:i18n('form.bind.selectTo')}</option>
        </select>
    </div>
    <div class="hidden clearfix margin_t_5" id="authDetail">
        <div class="left"><label class="margin_r_10" for="text"><font
                color="red"></font>${ctp:i18n('form.query.showdetails.label')}：</label></div>
        <div class="left">
            <div>
                <c:forEach items="${formBean.formViewList}" var="view">
                    <div class="clearfix">
                        <div class="left margin_r_5">
                            <input type="checkbox" id="view_${view.id }" value="${view.id }"/><label for="view_${view.id }">${view.formViewName }</label>
                        </div>
                        <div class="left">
                            <div class=" common_selectbox_wrap" >
                                <select id="auth_${view.id }" style="width: 100px">
                                    <c:forEach items="${view.operations}" var="auth">
                                        <option value="${auth.id }">${auth.name }</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function(){
    $("#archiveId").change(function(){
        var options = $("option",$(this));
        var ids = options.length==3?(options.eq(2).val()+"."+options.eq(2).text()):null;
        if($(this).val()=="1"){
            var pige = pigeonhole(2,null,false,false,"fromTempleteManage");
            if("cancel"!=pige&&""!=pige){
                var p = pige.split(",");
                if(ids!=null){
                    options.eq(2).remove();
                }
                $("<option selected value='"+p[0]+"'>"+p[1]+"</option>").appendTo($(this));
                $("#authDetail").removeClass("hidden");
                $(":checked","#authDetail").prop("checked",false);
            }else{
                if(ids!=null){
                    options.eq(2).prop("selected",true);
                }else{
                    options.eq(0).prop("selected",true);
                }
            }
        }else if("" == $(this).val()){
            if(ids!=null){
                $("option:eq(2)",$(this)).remove();
            }
            $("#authDetail").removeClass("hidden").addClass("hidden");
        }else{
            $("#authDetail").removeClass("hidden");
        }
        if($.browser.msie){//clone出来的选择框 在IE9的情况下 重新赋值后会有问题
            for(var i=0; i<this.options.length; i++){
                this.options[i].innerText = this.options[i].text+(i==0?" ":"");
                this.options[i].text = this.options[i].text+(i==0?" ":"");
            }
        }
    });
});
function OK(){
    var object = new Object();
    object.success = true;
    if($("#archiveId").val()!=""){
        if($(":checkbox:checked","#authDetail").length<=0){
            $.alert("${ctp:i18n('form.bind.chooseDetail')}");
            object.success = false;
        }
    }
    object.value = $.toJSON($("#content").formobj());
    var options = $("option",$("#archiveId"));
	object.text = options.eq(2).text();
	return object;
}
</script>
</body>
</html>