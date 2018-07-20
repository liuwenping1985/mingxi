<%--
 $Author:  翟锋$
 $Rev: 1697 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!DOCTYPE html>
<html class="h100b over_hidden" id='permisEdit' style='display:block;'>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>F1-节点权限-添加&修改</title>
    <style>
        .stadic_body_top_bottom { bottom: 36px; top: 0; }
        .stadic_footer_height { height: 36px; }
    </style>
    <script type="text/javascript" src="${path}/ajax.do?managerName=permissionManager"></script>
    <script type="text/javascript">
        $(function(){
            parent.$("#grid_detail").css("overflow","hidden");
            fnInitOption();
            $("#category").change(function(){
            	$("#commonOperation").empty();
	        	$("#commonOperationShow").empty();
	        	$("#advancedOperationShow").empty();
	        	$("#basicOperationShow").empty();
	        	$("#permissionRange").val("");
	        	$("#permissionRange_name").val("");
	        	//客开 作者:mly 项目名称:自流程 修改功能：交换节点无自流程 start edoc_new_change_permission_policy
	        	var categoryValue = $("#category option:selected").val();
	        	if("edoc_new_change_permission_policy" == categoryValue){
	        		$("#customDealWithTr").hide();
	        		$("#shuangwendanTr").hide();
	        		$("#memberRangeTr").hide();
	        	}else{
	        		$("#customDealWithTr").show();
	        		$("#memberRangeTr").show();
	        		$("#shuangwendanTr").show();
	        	}
	        	//客开 作者:mly 项目名称:自流程 修改功能：交换节点无自流程 end
	        });
            //当是修改的时候
            if('${operType}'==='change'){
                var labelName = $('#name').val();
                //如果是发文中的拟文(3000)和签报中的拟文(3109)时，无权限操作
                if(labelName === 'niwen' || 'dengji' === labelName){
                	var category = $('#category').val();
                	if(category != "edoc_new_qianbao_permission_policy" && category != "edoc_new_send_permission_policy" && category != "edoc_new_rec_permission_policy" && category != "edoc_new_change_permission_policy"){
	                    $('#accessProperties').hide();
	                    $('#mapping').hide();
                	}
                }else if(labelName === 'shangbao'){//信息报送-上报节点无权限操作
                    $('#accessProperties').hide();
                    $('#mapping').hide();
                }
                //当点击单条记录
                if('${flag}'!=='edit'){
                    // 隐藏底部的按钮
                    var cs = {display:'none'};
                    $('#bottomButton').css(cs);
                    $('.stadic_body_top_bottom').css('bottom',"0px");
                    //全部置为不可用
                    $('input').disable();
                    $('textarea').disable();
                    $('select#location').disable();
                    $(".common_button.common_button_gray.right").disable();
                }else{
                    //如果是系统节点，则名称不能修改
                    if('${ffpermission_edit_form.type}' === '0'){
                        var category = $('#category').val();
                        //$('#label').attr("readonly","readonly");
                        $("#label").disable();
                        //如果是 新闻审批(2306)、公告审批(2307) 时  ‘允许批量处理’ 不可修改
                        if(labelName === 'newsaudit'||labelName === 'bulletionaudit'){
                            $('#batch').disable();
                        }
                        //如果是表单审核(2305)、核定(2308)、知会(2303)、公文（收文、发文、签报）的知会 编辑操作 不可用
                        if(labelName === 'formaudit' || labelName === 'vouch' || labelName === 'inform' || labelName === 'zhihui'){
                            var str = "&nbsp;&nbsp;<span class='color_red'>*&nbsp;&nbsp;"+$('#curName').val()+"权限不允许编辑操作 </span>";
                            $('#edit_no').append(str);
                            $(".common_button.common_button_gray.right").disable();
                        }
                        if(labelName === 'zhihui'){
                        	$("input[name='isEnabled']").disable();
                        }
                        //发文、收文、签报：知会，不能意见必填
                        if(category === 'edoc_send_permission_policy' || category === 'edoc_rec_permission_policy'
                                || category === 'edoc_qianbao_permission_policy'){
                            //知会 意见必填 不能修改
                            if('zhihui' === labelName){
                                $("#opinionPolicy").disable();
                                $("#cancelOpinionPolicy").disable();
                                $("#disAgreeOpinionPolicy").disable();
                            }
                            //如果是拟文和登记 则意见、态度和批处理不能修改
                            if(labelName === 'niwen'  || 'dengji' === labelName){
                                //意见
                                $("#opinionPolicy").disable();
                                $("#cancelOpinionPolicy").disable();
                                $("#disAgreeOpinionPolicy").disable();
                                //批处理
                                $('#batch').disable();
                                //态度
                                $('#attitudeSetting').disable();
                            }
                            //如果是 发文中的封发，则不能批处理
                            if(category === 'edoc_send_permission_policy' && 'fengfa' === labelName) {
                                $('#batch').disable();
                            }
                        }
                    }
                }
                //权限类别不能修改
                $('select#category').disable();
            }
            
            // 确定 按钮 绑定点击事件
            $('#edit_confirm_button').click(function(){
            	_submit();
            });
            //取消 绑定点击事件
            $('#edit_cancel_button').click(function(){
            	refreshW();
            });
            
            //常用操作绑定点击事件
            $('#commonEdit').click(function(){
                checkPolicy('common');
            });
            //高级操作 绑定点击事件
            $('#advancedEdit').click(function(){
                checkPolicy('advanced');
            });
            //基本操作 绑定点击事件
            $('#basicEdit').click(function(){
                checkPolicy('basic');
            });
            
            //节点权限说明绑定点击事件 
            $('#showNodeDescription').click(function(){
                var category = $('#category').val();
                var dialog = $.dialog({
                    url: _ctxPath + "/permission/permission.do?method=desc&category="+category,
                    width:400,
                    height:400,
                    title:"${ctp:i18n('permission.node.description.lable')}", //节点权限操作说明
                    targetWindow:getCtpTop(),
                    buttons : [ {
                        text : "${ctp:i18n('permission.close')}",//关闭
                        handler : function() {
                          dialog.close();
                        }
                      } ]
               });
            });
            
        });
        //刷新父页面
        function refreshW(){
        	var category = $('#category').val();
        	if(category === 'edoc_send_permission_policy' || category === 'edoc_rec_permission_policy'
                || category === 'edoc_qianbao_permission_policy'){
        		category='edoc';
        	//V51 F18 信息报送  start
        	} else if(category === 'info_send_permission_policy') {
        		category='info';
        	}
        	//V51 F18 信息报送  end
        	var listObj=parent.$("#permissionList");
            if(listObj[0]){//如果从列表中打开，则刷新列表
                listObj.ajaxgridLoad();
            }else{
                parent.location.href = _ctxPath + "/permission/permission.do?method=list&category="+category;
            }
        }
        
        function submitPermission(){
        	//分办中有 处理后归档  不允许提交
        	if($('#name').val() == 'fenban'){
        		if($('#basicOperation').find("option[value='Archive']").text() != ""){
        			$.alert("${ctp:i18n('permission.operation.fenbanNoArchive')}");
        			subCount = 0;
        			return ;
        		}
        	}
        	
            //changyi当勾选了允许批处理复选框时，需要判断在基本操作中是否有交换类型，有就不能提交 
              if($("#batch").attr("checked") == "checked"){
                 var basic = $("#basicOperationShow").find("option");
                 var tip = "";
                 basic.each(function(){
                   if($(this).val() == "EdocExchangeType"){
                     tip = "0";
                     subCount = 0;
                     //终止循环
                     return false;
                   }
                 });
                 if(tip == "0"){
                     //基本操作中有交换类型，不允许勾选批量处理!
                     $.alert("${ctp:i18n('permission.prompt.setting.EdocExchangeType')}");
                     $('#edit_confirm_button')[0].disabled=false;
                     subCount = 0;
                     return;
                 }
              }
            //处理时必须填写意见  选中状态时 校验基本操作里是否有 ’意见‘
            var isOpinionClked = $('#opinionPolicy').is(":checked");
            var isRevokeClked = $('#cancelOpinionPolicy').is(":checked");
          	var isdisAgreeClked = $('#disAgreeOpinionPolicy').is(":checked");
            if(isOpinionClked ||isRevokeClked||isdisAgreeClked){
                var option = $('#basicOperation').find('option');
                var tip = "";
                option.each(function(){
                    if($(this).val() === 'Opinion'){
                        tip = "0";
                        //终止循环
                        subCount = 0;
                        return false;
                    }
                });
                if(option.length === 0 || tip !== '0'){
                    //基本操作中设置'意见'，才允许勾选'处理时必须填写意见'选项
                    if(isOpinionClked){
                    	$.alert("${ctp:i18n('permission.prompt.setting.opinion')}");
                    }else if(isRevokeClked){
                    	$.alert("${ctp:i18n('permission.prompt.setting.opinion1')}");
                    }else if(isdisAgreeClked){
                    	$.alert("${ctp:i18n('permission.prompt.setting.opinion2')}");
                    }
                    $('#edit_confirm_button')[0].disabled=false;
                    subCount = 0;
                    return;
                }
            }

          //当节点权限类型为 发文或签报时，不能选择转收文的功能
			var category = document.getElementById("category");
			if(category.value != "edoc_rec_permission_policy" && category.value != "edoc_new_rec_permission_policy"){
				var type;
				var flag = 1;
				var commonOperationShow = document.getElementById("commonOperationShow");
				var options = commonOperationShow.options;
				for(var i=0;i<options.length;i++){
					if(options[i].value == "TurnRecEdoc"){
						type = "common";
						flag = 2;
						break;
					}
				}

				if(flag == 1){
					var advancedOperationShow = document.getElementById("advancedOperationShow");
					var options = advancedOperationShow.options;
					
					for(var i=0;i<options.length;i++){
						if(options[i].value == "TurnRecEdoc"){
							type = "advanced";
							flag = 2;
							break;
						}
					}
				}
				
				if(flag == 2){
					var newEdoc = "${newEdoc}";
					if(newEdoc){
						alert("当前权限类别是新发文或交换时，不能有转收文操作，请重新设置!");
					}else{
						alert("当前权限类别是发文或签报时，不能有转收文操作，请重新设置!");
					}
					checkPolicy(type);
					$('#edit_confirm_button')[0].disabled=false;
					subCount = 0;
					return;
				}
			}
            
			
			if($("#location").val()!="0" ) {
				//判断基本操作中是否有'提交'选项
				//新闻审批(2306)、公告审批(2307)、表单审核(2305)、核定(2308) 发文中的拟文(3000)、签报中的拟文(3109)不用校验 ‘提交’
				var labelName = $('#name').val();
				if(labelName != 'newsaudit'&& labelName != 'bulletionaudit'&& labelName != 'formaudit'
						&& labelName != 'vouch'&& labelName != 'niwen' && labelName != 'dengji'){
					if($('#basicOperation').find("option[value='ContinueSubmit']").text() === ""){
						$.alert("${ctp:i18n('permission.prompt.setting.basicOperation')}");//基本操作中必须有'提交'选项
						$('#edit_confirm_button')[0].disabled=false;
						subCount = 0;
						return;
					}
				}
				if(labelName == 'faxing'){
					if($('#basicOperation').find("option[value='FaDistribute']").text() === ""){
						$.alert("${ctp:i18n('permission.prompt.setting.basicOperation.faxing')}");//基本操作中必须有'提交'选项
						$('#edit_confirm_button')[0].disabled=false;
						subCount = 0;
						return;
					}
				}
				if($("#basicOperation").find("option[value='CommonPhrase']").text()!=""){//如果有常用语，需要有意见
					if($("#basicOperation").find("option[value='Opinion']").text()==""){//没有意见，不允许提交
						$.alert("选择常用语需要选择意见，请重新选择");
						$('#edit_confirm_button')[0].disabled=false;
						subCount = 0;
						return;
					}
				}
			}
			
            //表单提交
            var form = $("#permission_edit_form");
            var path = "";
            if('${flag}' === 'edit'){
                path = _ctxPath + "/permission/permission.do?method=update";
            }else{
                path = _ctxPath + "/permission/permission.do?method=save";
            }
            form.attr('action',path);
            $('#edit_confirm_button')[0].disabled = false;
            form.jsonSubmit({
                validate : true,
                errorIcon : true,
                collbackError:function(){
            	   subCount = 0;
                },
                callback:function(args){
                	refreshW();
                }
            });
        }

        
        function addOneSub(n){
            return parseInt(n)+1;
        }
        //提交回调函数
        var subCount = 0;
        function _submit(){
        	//人员范围与自定义续办方式判断
        	var str = "";
        	if($("#memberRange_check").attr("checked")=="checked"&&$("#customDealWith_check").attr("checked")==null){
        		str = "需要对自定义续办方式进行设置";
        		$.alert(str);
        		return;
        	}
       	    if($("#memberRange_check").attr("checked")=="checked"){
          	   var memberRangeName = $("#memberRange_name").val();
          	   if(memberRangeName == ""||memberRangeName == null||memberRangeName =="undefined"){
          		   str="请设置人员范围";
          	   }
       	    }
        	if($("#customDealWith_check").attr("checked")=="checked"){
          	   var permissionRange = $("#permissionRange").val();
          	   if(permissionRange==""){
          		   if(str==""){
          			   str="请自定义续办方式（权限范围需要设置）";
          		   }else{  
          			   str+="与自定义续办方式（权限范围需要设置）";
          		   }
          	   }
         	}
       	   if(str!=""){
      		   $.alert(str);
      		   return;
      	   }
        	
       	 	subCount = addOneSub(subCount);
       	    if(parseInt(subCount)>=2){
       	        //不能重复提交，用最原生的alert，$.ALERT不能阻塞，太慢了才弹出
       	        alert($.i18n("collaboration.summary.notDuplicateSub"));
       	        subCount = 0;
       	        return;
       	    }
        	
        	this.disabled = true;
        	//客开  作者:mly  项目名称:自流程  start
			if($("#customDealWith_check").attr('checked') !='checked'){
				$("#permissionRange").val('');
				$("#returnTo").val('');
			}
			if($("#memberRange_check").attr('checked') !='checked'){
				$("#memberRange").val('');
			}
			//客开  作者:mly  项目名称:自流程  end
            
            //如果是系统节点时，修改时不需要校验，此时名称是不能修改的
            if('${flag}' === 'edit' && $('#type').val() === '0'){
                submitPermission();
            }else{
                // 校验节点权限名称是否重复
                var pm = new permissionManager();
                var params = new Object();
                params["category"] = $('#category').val();
              	//当输入特殊字符时，比较有问题，转换比较
                params["name"] = $('#label').val();
                //修改节点权限
                if('${flag}'==='edit'){
                    //判断是否被引用
                    if($('#isRef').val() === "1" && ($('#curName').val() !== $('#label').val())){
                        $.alert("${ctp:i18n('permission.prompt.not_edit')}");
                        this.disabled=false;
                        subCount = 0;
                        return;
                    }
                    params["curName"] = $('#curName').val();
                    params["flag"] = 'edit';
                }
                params["name"] = $("#label").val();
                pm.existsPermission(params,{
                    success : function(msg){
                        if(msg !== ""){
                            var win = new MxtMsgBox({
                                'type': 0,
                                'title':'${ctp:i18n("permission.prompt")}',//提示
                                'imgType':2,
                                'msg': msg,//已有同名权限，请重命名
                                 ok_fn:function(){
                                    $('#label').focus();
                                    $('#edit_confirm_button')[0].disabled=false;
                                    subCount = 0;
                                 }
                            });
                        }else{
                            $('#name').val($('#label').val());
                            submitPermission();
                        }
                    }, 
                    error : function(request, settings, e){
                        $.alert(e);
                        subCount = 0;
                    }
               });
            }
        }
        //判断选择的操作
        function checkPolicy(param) {
            var opt =null;    
            var optShow = null;
            var notInclude = "";
            var exists = "";
            if(param == 'basic'){
                opt = $('#basicOperation');
                optShow = $('#basicOperationShow');
                //查出常用操作中已选用的
                opt.find('option').each(function(){
                    if($(this).next().text() != ""){
                        exists = exists + $(this).val()+",";
                    }else{
                        exists = exists + $(this).val();
                    }
                });
                if(notInclude != ""){
                    notInclude = notInclude + "," + exists;
                }else{
                    notInclude = exists;
                }
                
            }else if(param == 'common'){
                opt = $('#commonOperation');
                optShow = $('#commonOperationShow');
                //点击常用编辑操作时 查询出高级操作中已存在的选项，将其在常用操作中排出
                $('#advancedOperation').find('option').each(function(){
                    if($(this).next().text() != ""){
                        notInclude = notInclude + $(this).val()+",";
                    }else{
                        notInclude = notInclude + $(this).val();
                    }
                });
                //查出常用操作中已选用的
                opt.find('option').each(function(){
                    if($(this).next().text() != ""){
                        exists = exists + $(this).val() + ",";
                    }else{
                        exists = exists + $(this).val();
                    }
                });
                if(notInclude != ""){
                    notInclude = notInclude + "," + exists;
                }else{
                    notInclude = exists;
                }
                
            }else if(param == 'advanced'){
                opt = $('#advancedOperation');
                optShow = $('#advancedOperationShow');
               //点击高级编辑操作时 查询出常用编辑中已存在的选项，将其在高级编辑操作中排出
                $('#commonOperation').find('option').each(function(){
                    if($(this).next().text() != ""){
                        notInclude = notInclude + $(this).val() + ",";
                    }else{
                        notInclude = notInclude + $(this).val();
                    }
                });
               //查出高级操作中已选用的
                opt.find('option').each(function(){
                    if($(this).next().text() != ""){
                        exists = exists + $(this).val() + ",";
                    }else{
                        exists = exists + $(this).val();
                    }
                });
                if(notInclude != ""){
                    notInclude = notInclude + "," + exists;
                }else{
                    notInclude = exists;
                }
            }
            var url = _ctxPath + "/permission/permission.do?method=operationChoose&param="+param+"&notInclude="+notInclude+"&exists="+exists+"&isEdoc="+$('#category').val()+"&submitStyle="+$("#submitStyle").val()+"&permissionName="+encodeURIComponent($('#name').val());
            
            var dialog = $.dialog({
               url: url,
               width:370,
               height:280,
               title:"${ctp:i18n('permission.flow.operation')}",//流程节点操作
               targetWindow:getCtpTop(),
               buttons : [ {
                   text : "${ctp:i18n('permission.confirm')}",//确定
                   handler : function() {
                     var returnValue = dialog.getReturnValue();
                     returnValue = $.parseJSON(returnValue);
                     var json = eval(returnValue.options);
                     //先将数据清空
                     opt.find('option').remove();
                     optShow.find('option').remove();
                     $.each(json,function (i,o) {
                         opt.append("<option selected='selected' value='"+o.value+"'>"+o.text+"</option>");
                         optShow.append("<option value='"+o.value+"'>"+o.text+"</option>");
                     });
                     // 指定回退再处理的流转方式
                     var submitStyle = eval(returnValue.submitStyle);
                     $("#submitStyle").val(submitStyle[0].value);
                     $("#submitStyleFrom").val(param);
                     dialog.close();
                   }
                 }, {
                   text : "${ctp:i18n('permission.cancel')}",//取消
                   handler : function() {
                     dialog.close();
                   }
                 } ]
             });
        }
        
        //初始化选项
        function fnInitOption(){
        	var opinionPolicyVal = "${opinionPolicy}";
        	if("1"==opinionPolicyVal){
        		$("#cancelOpinionPolicy").attr("disabled","disabled").attr("checked","checked");
        		$("#disAgreeOpinionPolicy").attr("disabled","disabled").attr("checked","checked");
        	}
        }
        
        function fnOptionClk(isOption){
        	setTimeout(function(){
        		var opinionPolicy = $("#opinionPolicy");
          		var cancelOpinionPolicy = $("#cancelOpinionPolicy");
          		var disAgreeOpinionPolicy = $("#disAgreeOpinionPolicy");
          		var isOpinionClked =opinionPolicy.is(":checked") ;
          		var isRevokeClked = cancelOpinionPolicy.is(":checked");
          		var isdisAgreeClked = disAgreeOpinionPolicy.is(":checked");
          		if(isOption){
          			if(isOpinionClked){
          				cancelOpinionPolicy.attr("disabled","disabled").attr("checked","checked");
          				disAgreeOpinionPolicy.attr("disabled","disabled").attr("checked","checked");
          			}else{
          				cancelOpinionPolicy.removeAttr("disabled");
          				disAgreeOpinionPolicy.removeAttr("disabled");
          			}
          		}
	          }, 100);
          }
      //客开 作者：mly 项目名称:自流程  修改功能:续办定义 start
        function customDealWithClk(flag){
        	var btn = $("#customDealWithBtn");
        	var check = $("#customDealWith_check");
        	if(check.attr("checked")){
        		btn.unbind( "click").bind("click",customDealWith);
        		 btn.removeClass("common_button_disable");
        	}else{
        		btn.unbind( "click" );
        		  btn.addClass("common_button_disable");
        	}
        }
        function customDealWith(){
        	var category = $('#category').val();
            var dialog = $.dialog({
                url: _ctxPath + "/permission/permission.do?method=customDealWith&id=${param.id}&category="+$("#category option:selected").val(),
                width:400,
                height:200,
                title:"自定义续办方式", 
                transParams:{
                	customDealWith : $("#permissionRange").val()+"|"+$("#permissionRange_name").val()+"|"+$("#returnTo").val(),
                	newEdoc:"${param.newEdoc}"
                },
                targetWindow:getCtpTop(),
                buttons : [{
                	text:"确定",
                	handler:function(){
                		var rv = dialog.getReturnValue();
                		if(rv != null){
                			var arr = rv.split("|");
                			$("#permissionRange").val(arr[0]);
                			$("#permissionRange_name").val(arr[1]);
                			$("#returnTo").val(arr[2]);
                			dialog.close();
                		}
                	}
                },{
                    text : "${ctp:i18n('permission.close')}",//关闭
                    handler : function() {
                      dialog.close();
                    }
             	}]
           });
        }
        function memberRangeClk(){
        	var input = $("#memberRange");
        	var inputName=$("#memberRange_name");
        	var check = $("#memberRange_check");
        	//input.val('');
        	//inputName.val('');
        	if(check.attr("checked") == "checked"){
        		inputName.unbind( "click").bind("click",memberRangeSetting);
        		inputName.attr('disabled',false);
        	}else{
        		inputName.unbind( "click" );
        		inputName.attr('disabled',true);
        	}
        }
        function memberRangeSetting(){
        	$.selectPeople({
				params : {
					//text : $("#memberRange_name").val(),
					value : $("#memberRange").val()
				},
				panels:"Department,Team,Post,Level",
				selectType:"Member",
				//returnValueNeedType:false,
				callback : function(ret) {
					$("#memberRange_name").val(ret.text);
					$("#memberRange").val(ret.value);
				}
			});
        }
        $(document).ready(function(){
        	if("${flag}" == 'edit'){
        		customDealWithClk();
            	memberRangeClk();
        	}
        });
        //客开 作者：mly 项目名称:自流程  修改功能:续办定义 end
				</script>
</head>
<body class="h100b over_hidden" >
    <%--修改之前的节点权限名称 --%>
    <input id="curName" name="curName" class='hidden' value="${ffpermission_edit_form.label}">
    <form id="permission_edit_form" class="h100b">
    <%--指定回退再处理的流转方式 --%>
    <input id="submitStyleFrom" name="submitStyleFrom" value="${submitStyleFrom }" type="hidden">
    <input id="submitStyle" name="submitStyle" value="${submitStyle }" type="hidden">
        <div class="stadic_layout_body stadic_body_top_bottom"  id="content">
            <table width="80%" class="font_size12 form_area margin_t_5 padding_t_5" style="table-layout: fixed;"  border="0" align="center">
                <tr>
                    <td valign="top">
                        <table width="100%" border="0" style="table-layout: fixed;" >
                            <tr>
                                <td class="font_bold align_right"  id="accessProperties">${ctp:i18n('permission.property')}:</td><%--权限属性 --%>
                                <td><div id="edit_no"></div></td>
                            </tr>
                            <tr>
                                <td class="align_right"><span class="color_red">*</span>${ctp:i18n('permission.name')}:</td><%--权限名称 --%>
                                <td class="padding_5">
                                    <div class="common_txtbox clearfix">
                                        <div class="common_txtbox_wrap">
                                            <input type="text" id="label" name="label"
                                                class="validate" validate="type:'string',name:'${ctp:i18n('permission.name')}',notNull:true,maxLength:30,avoidChar:'\\/|$%&amp;&gt;&lt;&quot;*:?;'" />
                                             <input type="hidden" id="name" name="name"/>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="align_right">${ctp:i18n('permission.type')}:</td><%--权限类型 --%>
                                <td class="padding_5">
                                    <div class="common_txtbox clearfix">
                                        <div class="common_txtbox_wrap">
                                            <c:choose>
                                                <c:when test="${operType=='change'}">
                                                    <input type="text"  id="typeName" disabled="disabled"/> 
                                                    <input type="hidden" name="type" id="type">
                                                </c:when>
                                                <c:otherwise><%--新建节点 --%>
                                                    <input type="hidden" name="type" id="type" value="1">
                                                    <input type="text"  value="${ctp:i18n('permission.type.custome')}" disabled="disabled"><%--用户自定义 --%>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <c:choose>
                            	<c:when test="${category=='info' || category=='info_send_permission_policy'}">
                            	<!-- V51 F18 信息报送  start -->
                            		<input type="hidden" name="category" id="category" value="info_send_permission_policy" />
                            	<!-- V51 F18 信息报送  end -->
                            	</c:when>
					            <c:when test="${category!='col_flow_perm_policy'}">
					                <tr>
	                                    <td class="align_right">${ctp:i18n('flowperm.edoc.type')}:</td><%--权限类别--%>
	                                    <td class="padding_5">
	                                        <div class="common_selectbox_wrap">
	                                        	<c:choose>
	                                        		<c:when test="${newEdoc=='true' }">
	                                        			<select name="category" id="category" >
			                                                 <option value="edoc_new_send_permission_policy" selected>${ctp:i18n('permission.edoc_new_send_permission_policy')}</option>
			                                                 <option value="edoc_new_rec_permission_policy">${ctp:i18n('permission.edoc_new_rec_permission_policy')}</option>
			                                                 <option value="edoc_new_change_permission_policy">${ctp:i18n('permission.edoc_new_change_permission_policy')}</option>
			                                                 <option value="edoc_new_qianbao_permission_policy">${ctp:i18n('permission.edoc_qianbao_permission_policy')}</option>
			                                             </select>
	                                        		</c:when>
	                                        		<c:otherwise>
	                                        			<select name="category" id="category" >
			                                                 <option value="edoc_send_permission_policy" selected>${ctp:i18n('permission.edoc_send_permission_policy')}</option><%--发文 --%>
			                                                 <option value="edoc_rec_permission_policy">${ctp:i18n('permission.edoc_rec_permission_policy')}</option><%--收文 --%>
			                                                 <option value="edoc_qianbao_permission_policy">${ctp:i18n('permission.edoc_qianbao_permission_policy')}</option><%--签报 --%>
			                                             </select>
	                                        		</c:otherwise>
	                                        	</c:choose>
	                                        </div>
	                                    </td>
                                    </tr>
					            </c:when>
					            <c:otherwise>
					                <input type="hidden" name="category" id="category" value="${category}" />
					            </c:otherwise>
					        </c:choose>
                            <tr>
                                <td class="align_right">${ctp:i18n('permission.location')}:</td><%--权限位置 --%>
                                <td class="padding_5">
                                    <div class="common_selectbox_wrap">
                                        <c:choose>
                                                <c:when test="${ffpermission_edit_form.type == '0'}">
                                                    <!-- ${ctp:i18n('permission.location.mid')} -->
                                                    <span>${ffpermission_edit_form.locationName}</span>
                                                    <input type="hidden" name="location" id="location">
                                                </c:when>
                                                <c:otherwise>
                                                    <select name="location" id="location" >
                                                        <option value="1" selected>${ctp:i18n('permission.location.mid')}</option><%--处理节点 --%>
                                                        <%--结束节点
                                                        <c:if test="${category!='col_flow_perm_policy' && category!='info_send_permission_policy' && category!='info'}">
                                                            <option value="2">${ctp:i18n('permission.location.end')}</option>
                                                        --%>

                                                    </select>
                                                </c:otherwise>
                                            </c:choose>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="align_right">${ctp:i18n('permission.isenabled')}:</td><%--是否启用 --%>
                                <td class="padding_5">
                                    <div class="common_radio_box clearfix">
                                        <label for="isEnabled" class="margin_r_10 hand">
                                            <input type="radio" value="1" name="isEnabled" id="isEnabled" class="radio_com" checked="checked" >
                                            ${ctp:i18n('permission.status.yes')}<%-- 是--%>
                                        </label>
                                        <label for="isEnabled" class="margin_r_10 hand">
                                            <input type="radio" value="0" name="isEnabled" id="isEnabled" class="radio_com" >
                                            ${ctp:i18n('permission.status.no')}<%-- 否--%>
                                        </label>
                                    </div>
                                </td>
                            </tr>
                            <c:set var="optionShowOrHide" value="${ffpermission_edit_form.location!='0'?'':'none'}"/>
                            <tr style="display:${optionShowOrHide}" onclick="fnOptionClk(true);">
                                <td class="align_right">
                                    <input type="checkbox" id="opinionPolicy" value="1" name="opinionPolicy" class="radio_com" >
                                </td>
                                <td class="padding_5">
                                     <label for="opinionPolicy" class="margin_r_10 hand">
                                        ${ctp:i18n('permission.opinion.empty.not')}<%--处理时必须填写意见 --%>
                                     </label>
                                </td>
                            </tr>
                            <tr style="display:${optionShowOrHide}" onclick="fnOptionClk(false);">
                                <td class="align_right">
                                  <input type="checkbox" id="cancelOpinionPolicy" value="1" name="cancelOpinionPolicy" class="radio_com" >
                                </td>
                                <td class="padding_5">
                                    <label for="cancelOpinionPolicy" class="margin_r_10 hand">
                                        ${ctp:i18n('permission.opinion.empty.not.1')}<%--撤销/回退/终止时必须填写意见 --%>
                                    </label>
                                </td>
                            </tr>
                            <%-- 客开 作者:mly 项目名称:流程自循环 start --%>
                            <c:if test="${param.newEdoc eq 'true' && category ne 'edoc_new_change_permission_policy' }">
                            <c:if test="${operType eq 'add' or( operType eq 'change' and  permissionName ne 'zhihui' and permissionName ne 'fenfa' and permissionName ne 'niwen' and permissionName ne 'fengfa' and permissionName ne 'qianshou' and permissionName ne 'fenban' and permissionName ne 'yuedu') }">
                           <%-- <c:if test="${newEdoc=='true' }"> --%>
                            <tr id="customDealWithTr" style="display:${optionShowOrHide}">
                                <td class="align_right">
                                  <input type="checkbox" id="customDealWith_check" <c:if test="${ permissionRange ne null &&'' ne permissionRange }"> checked="checked" </c:if> value="1" onclick="customDealWithClk();" name="customDealWith_check" class="radio_com" >
                                </td>
                                <td class="padding_5">
                                     <label for="customDealWith_check" class="margin_r_10 hand" <c:if test="${'edit' eq flag }"> onclick="customDealWithClk(); " </c:if> >
                                      	 自定义续办方式<%--自定义续办方式 --%>
                                     </label>
                                     <input type="hidden" name="permissionRange" id = "permissionRange" value="${permissionRange }">
                                     <input type="hidden" name="permissionRange_name" id = "permissionRange_name" value="${permissionRange_name }">
                                     <input type="hidden" name="returnTo" id="returnTo" value="${returnTo }">
                                     <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="customDealWithBtn">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                                </td>
                            </tr>
                             <tr id="memberRangeTr" style="display:${optionShowOrHide}">
                                <td class="align_right">
                                  <input type="checkbox" <c:if test="${ memberRange ne null &&'' ne memberRange }"> checked="checked" </c:if> id="memberRange_check" value="1" onchange="memberRangeClk()" name="memberRange_check" class="radio_com" >
                                </td>
                                <td class="padding_5">
                                     <label for="memberRange_check" class="margin_r_10 hand" <c:if test="${'edit' eq flag }"> onclick="memberRangeClk(); " </c:if> >
                                      	 人员范围设置<%--人员范围设置 --%>
                                     </label>
                                     <input type="hidden" name="memberRange" id="memberRange" value="${memberRange }">
                                     <input type="text" id="memberRange_name"  name="memberRange_name"  value="${memberRange_name }" style="width:120px"<c:if test="${'edit' ne flag }"> disabled="disabled" </c:if>   readonly="readonly"><%--用户自定义 --%>
                                </td>
                            </tr>
                            <%--  </c:if>--%>
                              </c:if></c:if>
                              <%-- 客开 作者:mly 项目名称:流程自循环 end --%>
                              <%-- 双文单的时候默认显示start --%>
                              <c:if test="${param.newEdoc eq 'true' && category ne 'edoc_new_change_permission_policy' && permissionName ne 'niwen'}">
                              <tr <c:if test="${enableAIP != '1' }">style="display:none"</c:if> id="shuangwendanTr">
                                <td class="align_right">双文单时默认显示:</td>
                                <td class="padding_5">
                                    <div class="common_radio_box clearfix">
                                        <label class="margin_r_10 hand">
                                            <input type="radio" value="2" name="formDefaultShow" id="formDefaultShow" class="radio_com" <c:if test="${formDefaultShow == '2' }">checked="checked"</c:if> >标准文单
                                        </label>
                                        <label class="margin_r_10 hand">
                                            <input type="radio" value="1" name="formDefaultShow" id="formDefaultShow" class="radio_com" <c:if test="${formDefaultShow == '1' }">checked="checked"</c:if> >全文签批单
                                        </label>
                                    </div>
                                </td>
                            </tr>
                            </c:if>
                              <%-- 双文单的时候默认显示end --%>
                            <tr style="display:${optionShowOrHide}" onclick="fnOptionClk(false);">
                                <td class="align_right">
                                  <input type="checkbox" id="disAgreeOpinionPolicy" value="1" name="disAgreeOpinionPolicy" class="radio_com" >
                                </td>
                                <td class="padding_5">
                                     <label for="disAgreeOpinionPolicy" class="margin_r_10 hand">
                                        ${ctp:i18n('permission.opinion.empty.not.2')}<%--不同意时必须填写意见 --%>
                                     </label>
                                </td>
                            </tr>
                            <tr style="display:${(category!='info' && category!='info_send_permission_policy' && !isNewEdoc)?'':'none'}">
                                <td class="align_right">
                                    <input type="checkbox" id="batch" value="1" name="batch" class="radio_com" >                
                                 </td>
                                <td class="padding_5">
                                    <label for="batch" class="margin_r_10 hand">
                                    ${ctp:i18n('permission.batch.subject')} </label><%--允许批量处理 --%>
                                </td>
                            </tr>
                            <!-- V51 F18 信息报送  start -->
                            <tr style="display:${(category!='info' && category!='info_send_permission_policy')?'':'none'}">
                                <td class="align_right">${ctp:i18n('permission.attitude.subject')}:</td><%--节点态度设置 --%>
                                <td class="padding_5">
                                    <div class="common_radio_box clearfix" id="attitudeSetting">
                                        <label for="" class="margin_t_5 hand display_block">
                                            <input type="radio" value="1" name="attitude" id="attitude" class="radio_com" checked="checked"> 
                                                ${ctp:i18n('permission.attitude.1')}<%--显示已阅、同意和不同意 --%>
                                        </label>
                                        <label for="" class="margin_t_5 hand display_block">
                                            <input type="radio" value="2" name="attitude" id="attitude" class="radio_com" > 
                                                ${ctp:i18n('permission.attitude.2')}<%--显示同意和不同意 --%>
                                        </label>
                                        <label for="" class="margin_t_5 hand display_block">
                                            <input type="radio" value="3" name="attitude" id="attitude" class="radio_com"> 
                                                ${ctp:i18n('permission.attitude.3')}<%-- 不显示态度--%>
                                        </label>
                                    </div>
                                </td>
                            </tr>
                            <!-- V51 F18 信息报送  end -->
                            <tr>
                                <td class="align_right">${ctp:i18n('permission.description')}:</td><%--描述 --%>
                                <td class="padding_5">
                                    <div class="common_txtbox  clearfix">
                                        <textarea cols="30" rows="7" class="padding_5 w100b validate" name="description" id="description" validate="type:'string',name:'${ctp:i18n('permission.description')}',maxLength:80,character:'&amp;&lt;&gt;'"> </textarea>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width="10%"></td>
                    <td valign="top" id="mapping" width="45%">
                        <table width="100%" border="0" id="permissionOperation">
                            <tr>
                                <td class="font_bold">${ctp:i18n('permission.permoperation.reflect')}</td><%--权限与操作映射 --%>
                                <td class="padding_5 align_right">
                                    <a href="javascript:void(0)" id="showNodeDescription">
                                        ${ctp:i18n('permission.node.description.lable')} <%--节点权限操作说明 --%>
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_5">${ctp:i18n('permission.operation.common')}</td><%--常用操作 --%>
                                <td class="padding_5">
                                    <a href="javascript:void(0)" class="common_button common_button_gray right" id="commonEdit">
                                        ${ctp:i18n('permission.operation.editoperation')}<%--编辑 --%>
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="padding_5">
                                    <div class="common_txtbox  clearfix">
                                        <select id="commonOperationShow" 
                                            multiple="multiple"  size="4"  class="padding_5 w100b ">
                                            <c:if test="${operType=='change'}">
                                                <c:forEach items="${commonList}" var="commonItem">
                                                    <option value="${commonItem.key}">${ctp:i18n(commonItem.label)}</option>
                                                </c:forEach>
                                            </c:if>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_5">${ctp:i18n('permission.operation.advanced')}</td><%--高级操作 --%>
                                <td class="padding_5">
                                    <a href="javascript:void(0)" class="common_button common_button_gray right" id="advancedEdit">
                                        ${ctp:i18n('permission.operation.editoperation')}<%--编辑 --%>
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="padding_5">
                                    <div class="common_txtbox  clearfix">
                                        <select id="advancedOperationShow" 
                                            multiple="multiple"  size="4"  class="padding_5 w100b ">
                                            <c:if test="${operType=='change'}">
                                                <c:forEach items="${advancedList}" var="advanceItem">
                                                    <option value="${advanceItem.key}">${ctp:i18n(advanceItem.label)}</option>
                                                </c:forEach>
                                            </c:if>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_5"><span class="color_red">*</span>${ctp:i18n('permission.operation.basic')}</td><%--基本操作 --%>
                                <td class="padding_5">
                                    <a href="javascript:void(0)" class="common_button common_button_gray right" id="basicEdit">
                                        ${ctp:i18n('permission.operation.editoperation')} <%--编辑 --%>
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="padding_5">
                                    <div class="common_txtbox  clearfix">
                                        <select id="basicOperationShow"
                                            multiple="multiple"  size="4"  class="padding_5 w100b" >
                                            <c:if test="${operType=='change'}">
                                                <c:forEach items="${basicList}" var="basicItem">
                                                    <option value="${basicItem.key}">${ctp:i18n(basicItem.label)}</option>
                                                </c:forEach>
                                            </c:if>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <%-- 隐藏传值域--%>
			<c:if test="${ffpermission_edit_form.location!='0'}">
            <div class="hidden">
                <select id="commonOperation" multiple="multiple"  size="4"  class="padding_5 w100b ">
                    <c:if test="${operType=='change'}">
                        <c:forEach items="${commonList}" var="common">
                            <option value="${common.key}" selected="selected">${ctp:i18n(common.label)}</option>
                        </c:forEach>
                    </c:if>
                </select>
                <select id="advancedOperation" multiple="multiple"  size="4"  class="padding_5 w100b ">
                    <c:if test="${operType=='change'}">
                        <c:forEach items="${advancedList}" var="advance">
                            <option value="${advance.key}" selected="selected">${ctp:i18n(advance.label)}</option>
                        </c:forEach>
                    </c:if>
                </select>
                <select id="basicOperation" multiple="multiple"  size="4"  class="padding_5 w100b">
                    <c:if test="${operType=='change'}">
                        <c:forEach items="${basicList}" var="basic">
                            <option value="${basic.key}" selected="selected">${ctp:i18n(basic.label)}</option>
                        </c:forEach>
                    </c:if>
                </select>
            </div>
            </c:if>
        </div>
        <div class="stadic_layout_footer stadic_footer_height" id="bottomButton">
            <div id="button" align="center" class="page_color button_container">
                <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
                   <a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10 hand" id="edit_confirm_button">${ctp:i18n('permission.confirm')}</a>&nbsp;<%--确定 --%>
                    <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_cancel_button">${ctp:i18n('permission.cancel')}</a><%--取消 --%>
                </div>
            </div>
        </div>
        <c:choose>
            <c:when test='${operType=="change"}'>
                <!-- 修改节点权限 ，添加隐藏域-->
                <input type="hidden" name="isRef" id="isRef"/>
                <input type="hidden" name="flowPermId" id="flowPermId"/>
            </c:when>
            <c:otherwise>
                <!-- 新建节点权限时，添加隐藏域 -->
                <input type="hidden" name="isRef" id="isRef" value="0"/>
            </c:otherwise>
        </c:choose>
    </form>
</body>
</html>
