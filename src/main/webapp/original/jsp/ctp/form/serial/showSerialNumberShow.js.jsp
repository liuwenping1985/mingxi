<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
	var paramType = "${ctp:escapeJavascript(param.type)}";
	$(document).ready(
		function(){
			//初始化显示设置
			initView();
        	//保存事件
        	$("#enter").click(function(){enterSubmit();});
          	$("#cancel").click(function(){parent.window.location.reload();});
          	if(paramType != "view"){
          		 bindEvent();
          	}
          	if(paramType != "create"){
          		preview();
          	}
	});
	//初始化显示设置
	function initView(){
		if(paramType == "view"){
			$("#myfrm").disable();
	        fillData();
		}else if(paramType == "edit"){
			fillData();
		}else if(paramType == "create"){
			 $("#radio1").attr("checked",true);
	          $("#radio5").attr("checked",true);
	          $("#ruleResetDiv").disable();
	          $("#prefix").disable();
	          $("#suffix").disable();
	          $("#textTimeBehind").disable();
		}
	}
	//initView内部调用该方法
	function fillData(){
    	// OA-107956 前后缀带有特殊双引号的时候直接用后台的值存在解析问题，因此用前台控件的值来做判断
		if($("#prefix").val()){
			$("#checkprefix").attr("checked",true);
		}else{
			$("#prefix").disable();
		}
		if($("#suffix").val()){
			$("#checksuffix").attr("checked",true);
		}else{
			$("#suffix").disable();
		}
        if("${ffmyfrm.fixLenShow}" == "0"){
        	$("#fixLenShow").attr("checked",false);
        }else{
        	$("#fixLenShow").attr("checked",true);
        }
        $("input[name='timeDate'][value='${ffmyfrm.timeDate}']").attr("checked",true);
        $("input[name='ruleReset'][value='${ffmyfrm.ruleReset}']").attr("checked",true);
        if(paramType == "edit"){
        	  enableResetRule();
         }
	}
	//enter提交事件
	var isSubMit = false;
	function enterSubmit(){
		if (isSubMit) {
			return;
		}
		isSubMit = true;
		if($("#minValue").val().length > $("#digit").val()) {
        	$.alert("${ctp:i18n('form.serialnumberlist.mixlargerthanmax')}") ;
			isSubMit = false;
            return ;
        }
    	if($("#myfrm").validate({errorAlert:true,errorIcon:false})){
            if(isMark($("#variableName").val())){
            	$.alert("${ctp:i18n('form.forminputchoose.inputerror')}"+" \:,|<>\/|\'\"?#$%&\^\*");
				isSubMit = false;
                return;
          	}
        	var form = new serialNumberManager();
        	form.checkSave($("#id").val(),$("#variableName").val(),paramType,{success: function(check){  
            	if(check == "-1"){
                	$.alert("${ctp:i18n('form.serialnumberlist.serialnumbewasalreadyexisted')}");
					isSubMit = false;
              	}else if(check == "-2"){
              		$.alert({
    					'msg':"${ctp:i18n('form.relation.formdata.deleted')}",
    					ok_fn:function(){
    						parent.window.location.reload();
							isSubMit = false;
    					}
    				});
              	}else{
                	//提交
                 	$("#myfrm").jsonSubmit({validate:false,callback:function(){parent.window.location.reload();isSubMit = false;}});
               }
        	}});
    	}else{
    	    isSubMit = false;
    	}
	}
	//这个方法有待修改，一点注释都没有。靠。
    function preview(){
    	var reg = RegExp("^\[0-9\]*\[1-9\]\[0-9\]*$");
        var textPrefixBack = $("#suffix") ;
        var checkboxSelectBack = $("#checksuffix") ;
        var textPrefix = $("#prefix");
        var textPreview3 = $("#dispvalue");
        var textLength = $("#digit");
        var text2 = $("#textTimeBehind") ;
		var minText = $("#minValue") ;
		var length = "";
        var lengthValue3 = "";
		/*if(textPrefix.val() != "" && textPrefix.val().length > 85){
            $.alert("${ctp:i18n('form.serialnumberlist.prefixoutoflength')}");
            return;
        }
        if(!$("#myfrm").validate({errorAlert:true,errorIcon:false})){
            return;
        }*/
        if(minText.val() == ""){
            minText.val(1);
        }
        if(!reg.test(minText.val())){
            //$.alert("${ctp:i18n('form.serialnumberlist.mixvalueerror')}");
            //return;
        }
        if($.trim(textLength.val()) != ""){
        	if(!reg.test(textLength.val())){
            	//$.alert("${ctp:i18n('form.serialnumberlist.lengtherror')}");
             	//return;
            }
            length = textLength.val();
            if(length > 10){
            	//$.alert("${ctp:i18n('form.serialnumberlist.lengthtoolarg')}");
            	//return;
            }else{
            	if(length == 1 || length == minText.val().length){
	                lengthValue1 = "1";
	                lengthValue2 = "2";
	                lengthValue3 = minText.val();
              	}else{
              		if($("#fixLenShow").attr("checked")){
		                for(var i = 0 ; i < length-minText.val().length; i++){
		                  lengthValue3 += "0";
		                }
              		}
	                lengthValue3 = lengthValue3 + minText.val();
              }
              var time = getTime();
              if($.trim(text2.val()) != ""){
                  time += text2.val();
              }
              lengthValue3 = time +  lengthValue3;
              if(checkboxSelectBack.attr("checked") && $.trim(textPrefixBack.val()) != ""){
                  lengthValue3 = lengthValue3 + textPrefixBack.val();
              }
              if($.trim(textPrefix.val()) != ""){
                  lengthValue3 = textPrefix.val() + lengthValue3;
              }
              textPreview3.val(lengthValue3);
            }
        }else{
            textPreview3.val("");
        }        
	}
	//获取时间方法
    function getTime(){
	    var today = new Date();
	    var returnVal = "";
	    var obj = parseInt($("input[name='timeDate']:checked").val());
	    switch(obj){
	        case 1:
	        	returnVal = today.getFullYear();
	            break;
	        case 2:
	            returnVal = today.getFullYear();
	            if((today.getMonth()+1)<10){
	                returnVal=returnVal+"0"+(today.getMonth()+1);
	            }else{
	                returnVal=returnVal+""+(today.getMonth()+1);
	            }
	            break;
	       case 3:
	            returnVal = today.getFullYear();
	            if((today.getMonth()+1)<10){
	                returnVal=returnVal+"0"+(today.getMonth()+1);
	            }else{
	                returnVal=returnVal+""+(today.getMonth()+1);
	            }
	            if(today.getDate()<10){
	                returnVal=returnVal+"0"+today.getDate();
	            }else{
	                returnVal=returnVal+""+today.getDate();
	            }
	            break;
	        default:
	        	break;
	        }
	    	return returnVal;
	}
	//该方法应该判断是否有这些特殊字符
    function  isMark(str){
    	var myReg = new RegExp("[\\:,|<>\/|\'\"?#$%&\^\*]");
    	return myReg.test(str);
    }
	//绑定事件
    function bindEvent(){
    	$("#checkprefix").click(function(){
            if($(this).attr("checked")){
            	$("#prefix").enable();
            }else{
	        	$("#prefix").val("");
	            $("#prefix").disable();
            }
		});
        $("#checksuffix").click(function(){
        	if($(this).attr("checked")){
            	$("#suffix").enable();
            }else{
            	$("#suffix").val("");
            	$("#suffix").disable();
            }
		});
        $("input[name='timeDate']").click(function(){
        	enableResetRule();
            preview();
        });
        $("#fixLenShow").click(function (){
        	preview();
        });
    	$("input").blur(preview);
	}
	//禁用启用重置规则
    function enableResetRule(){
    	var obj = $("input[name='timeDate']:checked");
        var obj1 = $("input[name='ruleReset']:checked");
        var valueInt = parseInt(obj.val());
        var valueInt1 = parseInt(obj1.val());
        if(valueInt < valueInt1){
            $("input[name='ruleReset'][value='0']").attr("checked",true);
        }
        if(valueInt == 0){
            $("#textTimeBehind").disable();
        }else{
            $("#textTimeBehind").enable();
        }
        for(var i=valueInt; i >= 0; i--){
            $("input[name='ruleReset'][value='"+i+"']").enable();
        }
        for(var i=valueInt+1; i <=3; i++){
            $("input[name='ruleReset'][value='"+i+"']").disable();
        }
	}
</script>