//<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
var desArr = new Array();
//暂时将所有节点权限的描述设成一个值
//var description = "";
//$("#content").val(description);
//document.getElementById("checkPolicyDiv").innerHTML = document.getElementById("checkPolicyHTML").innerHTML;
var paramObjs= window.parentDialogObj['workflow_dialog_showNodeProperty_Id'].getTransParams();
var dealDesc= paramObjs.desc;
function policyExplain(){
    try{
        var dialog = $.dialog({
        url : '<c:url value="${nodePolicyExplainUrl}"/>',
        transParams : window,
        width : 295,
        height : 275,
        title : '${ctp:i18n("node.policy.explain")}',
        buttons : [
            {
                text : '${ctp:i18n("common.button.close.label") }',
                handler : function(){
                    dialog.transParams = null;
                    dialog.close();
            }}
        ],
        targetWindow: getCtpTop()
    	});
    }catch(e){//兼容公文老代码
        var dialog = $.dialog({
        url : '<c:url value="${nodePolicyExplainUrl }"/>',
        transParams : window,
        width : 295,
        height : 275,
        title : '${ctp:i18n("node.policy.explain")}',
        buttons : [
            {
                text : '${ctp:i18n("common.button.close.label") }',
                handler : function(){
                    dialog.transParams = null;
                    dialog.close();
            }}
        ],
        targetWindow: window.parent
    	});
    }
}
function dealExplain(desc){
	var dialog = $.dialog({
        url : '<c:url value="/workflow/designer.do?method=showDealExplain"/>&desc='+escapeSpecialChar(encodeURIComponent(unescape(dealDesc))),
        width : 295,
        height : 220,
        title : '${ctp:i18n("workflow.designer.node.deal.explain")}',
        buttons : [
            {
                text : '${ctp:i18n("common.button.close.label") }',
                handler : function(){
                    dialog.close();
            }}
        ],
        targetWindow: getCtpTop()
    });
}

function escapeSpecialChar(str){
      if(!str){
          return str;
      }
      str= str.replace(/\&/g, "&amp;").replace(/\</g, "&lt;").replace(/\>/g, "&gt;").replace(/\"/g, "&quot;");
      str= str.replace(/\'/g,"&#039;").replace(/"/g,"&#034;");
      return str;
    }