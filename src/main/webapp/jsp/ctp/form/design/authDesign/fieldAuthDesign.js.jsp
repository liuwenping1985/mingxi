<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
  $.fn.fillform = function(fillData) {
    if (this[0] == null){
      return;
    }
     var frm = $(this);
     for ( var fi in fillData) {
       var trId = fi.substring(0,fi.indexOf("_"))+"_tr";
       var s = $("input[value='"+fillData[fi]+"']","#"+trId);
       if(s.attr("fieldtype") == 'checkbox' && fillData[fi] == '1'){
           continue;
       }
       s.attr("checked",true);
     }
     frm = null;
  };
    var parWin = window.dialogArguments[0];
    var parParWin = window.dialogArguments[1];
    var authObj = $.parseJSON(window.dialogArguments[2]);
    $(document).ready(function() {
        new MxtLayout({
            'id' : 'layout',
            'centerArea' : {
                'id' : 'center',
                'border' : true
            }
        });
        showAuthDetail();
        if ("${viewType}" != 'view') {
            if ("readonly" == $("#authTypeValue",parParWin.document).val()) {
                $("input[value='${edit }']", "#authset").prop("disabled", true);
                $("input[value='${add }']", "#authset").prop("disabled", true);
                $("#choedit", "#authset").prop("disabled", true);
            }
            resetChecked();
            $("#saveAuth").removeClass("common_button_disable").toggleClass("common_button");
            if ($("input", "#groupEdit").length > 0) {
                $("#groupAuth").removeClass("common_button_disable");
            }
            $("input[attrType='def']", "#authFieldTable").removeProp("disabled");

            $("A", "#selectAllAccess").click(function() {
	            if (!$("#saveAuth").hasClass("common_button_disable")) {
	                if ($(this).attr("id") == "notNull") {
	                    var isNotNullBox = $("input:checkbox[value='${isNotNull }']:not(:disabled)","#authFieldTable");
	                    if (isNotNullBox.eq(0).prop("checked")) {
	                        isNotNullBox.prop("checked",false);
	                    } else {
	                        isNotNullBox.prop("checked",true);
	                    }
	                } else if ($(this).attr("id") == "initValue") {
	                } else if ($(this).attr("id") == "${edit }"|| $(this).attr("id") == "${add }") {
	                    if ($("#authTypeValue",parParWin.document).val() != "readonly") {
                            $("input:radio[value='"+ $(this).attr("id")+ "']","#authFieldTable").each(function(){
                                if(isCheckAll($(this).attr("tablename"))){
                                    $(this).prop("checked",true);
                                }
                            });
                            resetChecked();
                        }
	                } else {
	                    $("input:radio[value='"+ $(this).attr("id")+ "']","#authFieldTable").prop("checked",true);
	                    resetChecked();
	                }
                    disabledFlowdealoption();
	            }
	        });
        } else {
            $("#authset").disable();
        }
        disabledFlowdealoption();
        $("input:checkbox[fieldType='lable']","#authFieldTable").prop("disabled",true);
        $("input:radio", "#authFieldTable").click(function() {
            setNullAbledDisable($(this));
        });
        fillRepeatFromAuth();
        $("#groupAuth").click(
				function(){
					if(!$(this).hasClass("common_button_disable")){
						 var dialog = $.dialog({
							id:"formDesignHighAuthSlave",
							url:"${path }/form/authDesign.do?method=formDesignHighAuthSlave",
						    title : "${ctp:i18n('formoper.dupform.label')}",
						    targetWindow:getCtpTop(),
						    transParams:authObj,
						    buttons : [ {
						      text : "${ctp:i18n('form.forminputchoose.enter')}",
						      id:"sure",
                              isEmphasize: true,
						      handler : function() {
						    	var ret = dialog.getReturnValue();
						    	authObj = ret;
						    	fillRepeatFromAuth();
						    	dialog.close();
						      }
						    }, {
						      text : "${ctp:i18n('form.forminputchoose.cancel')}",
						      id:"exit",
						      handler : function() {
						        dialog.close();
						      }
						    } ]
						  });
					}
				}
            );
        initChecked();
    });
    //设置重复表高级权限
	function fillRepeatFromAuth(){
	    if(authObj!=undefined){
			$("input","#groupEdit").each(function(){
					var id = $(this).attr("id");
					$(this).val(authObj[id]);
			});
		}
	}
	    
    function resetChecked() {
        $("input:radio[value=${browse }][fieldType='${externalwrite }']","#authFieldTable").prop("checked", true);
        $("input:radio[value!=${browse }][fieldType='${externalwrite }']","#authFieldTable").prop("disabled", true);
        $("input:radio[value=${browse }][fieldType='${outwrite}']","#authFieldTable").prop("checked", true);
        $("input:radio[value!=${browse }][fieldType='${outwrite}']","#authFieldTable").prop("disabled", true);
        $("input:radio[value='${browse}'][fieldType='${linenumber}']","#authFieldTable").prop("checked",true);
        $("input:radio[value!='${browse}'][fieldType='${linenumber}']","#authFieldTable").prop("disabled",true);
        setNullAbledDisable();
    }

  function disabledFlowdealoption() {
      $("input:radio[fieldType='${flowdealoption}']","#authFieldTable").prop("disabled", true);
      $("input:radio[fieldType='${flowdealoption}']","#authFieldTable").prop("checked", false);
  }

    function setNullAbledDisable(fName) {
        if (fName) {
            var checkedObj = fName;//$("#"+fName+"_access:checked");
            var nullAbleObj = $("#" + checkedObj.attr("fieldName") + "_notNull");
            if (checkedObj.val() == "${browse }"|| "${hide }" == checkedObj.val()) {
                nullAbleObj.prop("checked", false);
                nullAbleObj.prop("disabled", true);
            } else {
                nullAbleObj.prop("disabled", false);
            }
            if(checkedObj.attr("fieldType") == "flowdealoption" || checkedObj.attr("fieldType") == "checkbox" 
                    || checkedObj.attr("fieldType") == "lable"){
              nullAbleObj.prop("disabled",true);
           }
            if(checkedObj.attr("fieldType")=="relationform" && checkedObj.attr("viewSelectType") == "2"){
            	nullAbleObj.prop("disabled",true);
             }
        } else {
            $("input:radio:checked", "#authFieldTable").each(function() {
                var checkedObj = $(this);
                var nullAbleObj = $("#" + checkedObj.attr("fieldName")+ "_notNull");
                if (checkedObj.val() == "${browse }"|| "${hide }" == checkedObj.val()) {
                    nullAbleObj.prop("checked", false);
                    nullAbleObj.prop("disabled", true);
                } else {
                    nullAbleObj.prop("disabled", false);
                }
                if(checkedObj.attr("fieldType") == "flowdealoption" || checkedObj.attr("fieldType") == "checkbox" 
                        || checkedObj.attr("fieldType") == "lable"){
                  nullAbleObj.prop("disabled",true);
                  nullAbleObj.prop("checked", false);
               }
                if(checkedObj.attr("fieldType")=="${relationForm}" && checkedObj.attr("viewSelectType") == "2"){
                	nullAbleObj.prop("disabled",true);
                 }
            });
        }
    }
    //在权限设置区域显示ID为viewId的权限信息 syn有值时同步，null为异步
    function showAuthDetail(viewId, syn) {
        //取得父页面中权限的具体设置,如果没有则为""
        var obj = window.dialogArguments[2];
        //为""时设置为和最上层的页面中的权限设置一样
        if(obj!=undefined && obj != "") {
            $("#authset").fillform($.parseJSON(obj));
        }
    }
    //返回权限设置的json字符串
    function OK() {
        var obj = $("#authset").formobj();
        if(!checkForm()){
			return false;
        }else{
        	return $.toJSON(obj);
        }
    }

    function checkForm(){
        var retValue = true;
    	var errMsg = isAllowAddorDelete("browse","hide");
        if(errMsg == "") {
            errMsg = isAllowAddorDelete("hide","browse");
        }
        if(errMsg!=""){
        	errMsg = errMsg+"${ctp:i18n('form.authDesign.cannotadddelupdate')}";
            retValue = false;
            $.alert(errMsg);
			//ca!!不能使用confirm组件，只能使用MxtMsgBox，不然确定之后会连父窗口也关闭了
            //var win = new MxtMsgBox({
            //    'type': 0,
            //    'title':"${ctp:i18n('message.header.system.label')}",
            //    'msg':errMsg,
           // 	ok_fn:function(){retValue = false;win.close();}
            //});
        }
        return retValue;
	}

function initChecked() {
    $("input","#groupEdit").each(function(){
        if($(this).attr("isCollectTable") == "true" || $(this).attr("isCollectTable") == true) {
            var tableName = $(this).attr("tablename");
            $("input[tableName='"+tableName+"'][value='edit']","#authFieldMap").each(function(){
                $(this).prop("disabled", true);
            });
            $("input[tableName='"+tableName+"'][value='add']","#authFieldMap").each(function(){
                $(this).prop("disabled", true);
            });
            setNullAbledDisable();
        }
    });
}

function isCheckAll(tableName) {
    var isCheckAll = true;
    $("input","#groupEdit").each(function(){
        if($(this).attr("isCollectTable") == "true" || $(this).attr("isCollectTable") == true) {
            if($(this).attr("tablename") == tableName) {
                isCheckAll = false;
                return false;
            }
        }
    });
    return isCheckAll;
}

function isAllowAddorDelete(obj1,obj2) {
    var errMsg = "";
    $("input","#groupEdit").each(function(){
        if($(this).val() == "true" || $(this).val() == true){
            var tableName = $(this).attr("tableName");
            var displayName = $(this).attr("title");
            var operation = $(this).attr("id");
            var canDo = false;
            $("input[tableName='"+tableName+"'][value='"+obj1+"']","#authFieldMap").each(function(){
                var checked = $(this).prop("checked");
                if(!checked){
                    var obj = $("input[id='"+$(this).attr("id")+"'][value='"+obj2+"']","#authFieldMap");
                    if(!obj.prop("checked")){
                        canDo = true;
                        return false;
                    }
                }
            });
            if(!canDo){
                if(errMsg.indexOf(displayName)<0){
                    if(errMsg!=""){
                        errMsg+=",";
                    }
                    errMsg+=displayName;
                }
            }
        }
    });
    return errMsg;
}
</script>