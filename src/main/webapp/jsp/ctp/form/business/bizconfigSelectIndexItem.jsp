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
    <script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
</head>
<script>
    function changePhoneView(obj){
        $("div","#container").each(function(){
            $(this).css("background","");
            $(this).css("color","");
        });
        $(obj).css("background","highlight");
        $(obj).css("color","highlighttext");
        var formId = $(obj).attr("formId");
        var queryBeanId = $(obj).attr("queryId");
        var bizManager = new businessManager();
        var result = bizManager.getIndicatorByQueryId(formId,queryBeanId);
        if(result.phoneViewInfo){
            var phoneViewInfo = $.parseJSON(result.phoneViewInfo);
            var queryPhoneId = phoneViewInfo.queryId;
            var indicators = phoneViewInfo.indicateList;
            var _html = "";
            for(var i = 0,len = indicators.length;i<len;i++){
                _html += '<option value="'+indicators[i].id+'" queryBeanId="'+queryBeanId+'" simpleStr="'+indicators[i].simpleStr+'">'+indicators[i].showTitle+'</option>'
            }
            $("#indicator").html(_html);
        }
    }
    //获取选择的指标
    function getSelectObject(){
        var objs = [];
        var selectObj =$("#indicator");
        if(selectObj[0].selectedIndex > -1){
            $("option",selectObj).each(function(){
                if($(this)[0].selected){
                    var obj = {};
                    obj.id = $(this).val();
                    obj.showTitle = $(this).text();
                    obj.queryBeanId = $(this).attr("queryBeanId");
                    obj.simpleStr = $(this).attr("simpleStr");
                    objs.push(obj);
                }
            });
        }
        return objs;
    }
    //双击选择到右侧
    function dblSelect(){
        parent.addToRight();
    }
</script>
<body class="font_size12">
<div>
    <div style="height: 175px;">
        <div id="container" class="border_all" style="overflow-y: auto;height: 100%">
        <c:forEach items="${formQueryBeanList}" var="queryBean" varStatus="status">
            <div id="query${status.index}" onclick="changePhoneView(this)" style="cursor:pointer" queryId="${queryBean.id}" formId="${queryBean.formId}">${queryBean.name}</div>
        </c:forEach>
        </div>
    </div>
    <!-- 查询移动指标 -->
    <div style="text-align: left;line-height: 20px;height: 20px;">${ctp:i18n('bizconfig.business.mobile.index.item.label')}</div>
    <div class="w100b" style="height: 100px;overflow-y: auto;">
        <select class="border_all" name="indicator" id="indicator" ondblclick="dblSelect()" style="width: 100%;height: 100%;" multiple="multiple">
        </select>
    </div>
</div>
</body>
</html>
