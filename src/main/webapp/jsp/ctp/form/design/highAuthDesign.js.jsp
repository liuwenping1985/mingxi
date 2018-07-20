<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${path}/common/form/design/highAuthDesign.js${ctp:resSuffix()}"></script>
<script>
    var count = 1;
    var parentObj = "";
    var parWin = window.dialogArguments;
    var curtconditionValue;
    var _viewType = '${viewType}';
    var _authId = '${authId}';
    $(document).ready(function() {
        new MxtLayout({
            'id' : 'layout',
            'centerArea' : {
                'id' : 'center',
                'border' : true
            }
        });
        var obj = $("#highAuths", parWin.document).val();
        if (obj != "") {
            obj = $.parseJSON(obj);
            if (obj.length !== undefined) {
                for ( var i = 0; i < obj.length; i++) {
                    if (i > 0) {
                        var addobj = add();
                        $(addobj).fillform(obj[i]);
                        if ("${viewType}" === 'view') {
                            $("#conditionValue", addobj).prop("disabled", true);
                        }
                    } else {
                        $("#authset").fillform(obj[i]);
                        if ("${viewType}" === 'view') {
                            $("#conditionValue").prop("disabled", true);
                        }
                    }
                }
            } else {
                $("#authset").fillform(obj);
                if ("${viewType}" === 'view') {
                    $("#conditionValue", addobj).prop("disabled", true);
                } else {
                    //$("#conditionValue").val("${ctp:i18n('form.authdesign.hightauth.label')}");
                }
            }
        } else {
            if ("${viewType}" === 'view') {
                $("#conditionValue").prop("disabled", true);
                $("#authValue").val($.toJSON($("#radioHeight", parWin.document).formobj()));
            } else {
                $("#conditionValue").val($.i18n('form.authdesign.hightauth.label'));
                $("#authValue").val($.toJSON($("#radioHeight", parWin.document).formobj()));
            }
        }
        if ("${viewType}" != 'view') {
            $("#authTitle").removeProp("disabled");
            $("#add").removeProp("disabled");
            $("#del").removeProp("disabled");
        }else{
            $("#abandon").prop("disabled",true);
        }
        //重置事件
        $("#abandon").click(function () {
            if("${viewType}" != 'view') {
                resetPage();
            }
        });
    });
    
</script>