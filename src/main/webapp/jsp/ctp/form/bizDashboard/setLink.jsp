<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2017/1/20
  Time: 16:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>链接设置</title>
</head>
<script>
    $(document).ready(function() {
        changedTagType("form/bizDashboard.do?method=sectionTypeIndex&type=formQuery&from=setLink");
    });
    //切换栏目类型
    function changedTagType(url){
        document.getElementById("formapp").src =_ctxPath+"/"+url+"&from=setLink";
    }
    //选择模版，因为用的是制作看板左边的页面，所以方法名也要相同
    function selectSection(){
        var n1=$("#formapp");
        var oSelected = null;
        if(n1.hasClass("show")){
            oSelected = formapp.getSelectedNodes();
        }
        if(oSelected!=null) {
            if(oSelected.data.sourceType == -1 || oSelected.data.sourceType == 0) {
                return;
            }
            $("#selectedValue").empty();
            $("#selectedValue").append('<option value="'+oSelected.data.id+'" sourceType="'+oSelected.data.sourceType+'">'+oSelected.data.name+'</option>');
        }
    }
    //删除已选模版
    function removeSection(){
        var selectedValue = $("#selectedValue");
        if(selectedValue && selectedValue[0].selectedIndex > -1){
            $("option",selectedValue).each(function(){
                if($(this)[0].selected){
                    $(this).remove();
                }
            });
        }
        //$("#selectedValue").empty();
    }
    //点击确认执行的操作
    function OK(){
        var selected = $("option",selectedValue);
        //建议不加这个，不然就没办法清空已选项了
        //if(selected && selected.length == 0){
       //     $.alert("${ctp:i18n('form.formula.chooserole.isNotNull')}");
        //    return;
        //}
        var obj = {};
        if(selected && selected.length == 1){
            obj.linkId = $(selected).val();
            obj.linkType = $(selected).attr("sourceType");
            obj.linkName = $(selected).text();
        }
        return obj;
    }
</script>
<body>
<div class="left" style="width: 360px;height: 95%;position: absolute;left: 0px;">
    <div id = "parentTable" style="height: 100%;position: absolute;left: 0px; right:40px;width: 320px;">
        <div id="tabs" class="comp" comp="type:'tab',parentId:'parentTable',height:370">
            <div id="tabs_head" class="common_tabs clearfix">
                <ul class="left">
                    <c:forEach items="${sectionTypeList}" var="sourceType" varStatus="status">
                        <li id="${sourceType.id}_li" <c:if test="${status.first}"> class="current"</c:if> ><a href="javascript:changedTagType('${sourceType.URL}')" tgt="formapp" style="padding: 0 4px;"><span title="${sourceType.name}">${sourceType.name}</span></a></li>
                    </c:forEach>
                </ul>
            </div>
            <div id='tabs_body' class="common_tabs_body border_all">
                <iframe name="formapp" id="formapp" class="show"  border="0" width="100%" frameBorder="no"  height="100%" scrolling = "no"></iframe>
            </div>
        </div>
    </div>
    <!-- 左右按钮 -->
    <div class="right" style="position:absolute; right:1px; padding-top:200px; width:32px; height:32px;">
        <p id="columnRight">
            <span class="ico16 select_selected" onClick="selectSection()"></span>
        </p>
        <br>
        <p id="columnLeft">
            <span class="ico16 select_unselect" onClick="removeSection()"></span>
        </p>
    </div>
</div>
<div class="right" style="width:235px; height: 95%;position: absolute;right: 5px;">
    <div id="valueDiv" style="margin-top: 26px;padding: 2px;">
        <select name="selectedValue" id="selectedValue" size="24" ondblclick="removeSection()" style="width: 235px;height: 388px;" multiple="multiple" class="margin_t_5">
        </select>
    </div>
</div>
</body>
</html>
