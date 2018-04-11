<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>EnumIframe</title>
<script type="text/javascript">
    function OK() {
        var target = $($(".current")[0]).find("a").attr("tgt");
        var formtype = $($(".current")[0]).find("a").attr("formtype");
        var doc= document.getElementById(target).contentWindow.document;
        var table = doc.getElementById("templateTable");
        if(formtype!=1){
        	table = doc.getElementById("formTable");
        }
        var boxs = $(table).find("input:checked");
        if(boxs){
        if(boxs.length==0){
             return false;
        }
        return {"templateId":boxs[0].value,"formType":formtype};
        }
        return false;
    }
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div id="tabs" style="height: 100%"  class="comp"
        comp="type:'tab',parentId:'tabs'">
        <div id="tabs_head" class="common_tabs clearfix">
            <ul class="left">
                <li class="current"><a hidefocus="true" href="javascript:void(0)" 
                  tgt="tab1_iframe" formtype="1"><span>${ctp:i18n("formtalk.tab.type")}</span></a></li>
                <li><a hidefocus="true" href="javascript:void(0)"
                    tgt="tab2_iframe" formtype="2"><span>${ctp:i18n("formtalk.tab.type2")}</span></a></li>
                <li><a hidefocus="true" href="javascript:void(0)"
                    tgt="tab3_iframe" formtype="3"><span>${ctp:i18n("formtalk.tab.type3")}</span></a></li>
            </ul>
        </div>
        <div id="tabs_body" class="common_tabs_body" style="height: 100%;">
            <iframe id="tab1_iframe" width="100%" height="100%" src="${path}/genericController.do?ViewPage=plugin/formtalk/templateList" frameborder="no"
                border="0"></iframe>
            <iframe id="tab2_iframe" width="100%" height="100%" src="${path}/genericController.do?ViewPage=plugin/formtalk/unFlowTemplateList&formType=2" frameborder="no"
                border="0"></iframe>
            <iframe id="tab3_iframe" width="100%" height="100%" src="${path}/genericController.do?ViewPage=plugin/formtalk/unFlowTemplateList&formType=3" frameborder="no"
                border="0"></iframe>
        </div>
    </div>
    </div>
</body>
</html>