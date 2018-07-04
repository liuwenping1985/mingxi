<script type="text/javascript">
<!--
function memberLeave(){
    var memberId = $("#spc2").val();
    alert(memberId);
    
    var dialog = $.dialog({
        url : "<c:url value='/organization/memberLeave.do' />?method=showLeavePage&memberId=" + memberId,
        title : $.i18n("member.leave.label"),
        width : 700,
        height : 560,
        buttons: [
            {
                text : $.i18n('common.button.ok.label'),
                handler : function() {
                        //TODO
                        var result = dialog.getReturnValue();
                        
                        alert($.i18n("member.leave.success"));
                        dialog.close();
                }
            },
            {
                text : $.i18n('common.button.cancel.label'),
                handler : function() {
                    dialog.close();
                }
            }
        ]
    });
}
//-->
</script>