<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
$("td.checkedFirstTdRadio").click(function(){
	$(this).prev("td").find(":radio").prop("checked", true);
});
function OK(){
	var radioObj = $("input[name=templeteId]:checked"), result = "";
	if(radioObj.size()>0){
        var subId = radioObj.val(), subName = radioObj.attr("templeteName");
		var manager = new WFAjax();
        var result = manager.hasSubProcess(subId);
        if(result!=null){
        	if(result=="true" || result==true){
        		result = {
                    canBeSub : false
                    ,subId : ""
                    ,subName : ""
                };
                $.alert("${ctp:i18n('subflow.selectedFormflowError')}");
        	}else{
				result = {
					canBeSub : true
					,subId : subId
					,subName : subName
				};
        	}
        }
	}else{
        //$.alert("请选择表单流程！");
        $.alert("${ctp:i18n('subflow.setting.noSelectFlow')}");
        result = {canBeSub : false ,subId : "" ,subName : ""};
    }
    result = $.toJSON(result);
	return result;
}
</script>