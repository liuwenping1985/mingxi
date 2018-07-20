<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<title>MemberManagerment</title>
<%@ include file="/WEB-INF/jsp/apps/organization/member/secretSetMember_js.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=memberManager"></script>
<script type="text/javascript">
window.onload = function(){
	 var toolbarArray = new Array();
	 <c:if test="${app == '1'}">
    	 toolbarArray.push({id: "setSecret",name:$.i18n('secret.user.set.secretSetting'),className: "ico16 redistribution_16",click:secretSet});
     </c:if>
     <c:if test="${app == '2'}">
     	toolbarArray.push({id: "addRole",name: $.i18n('secret.user.set.roleSetting'),className: "ico16 redistribution_16",click:fenPeiRole});
     </c:if>
    $("#toobar_miji").toolbar({
        toolbar: toolbarArray
    });
    $("#west").height($("#west").height() - 30);
}

function secretSet(){//定密设置
	var v = $("#memberTable").formobj({
	       gridFilter : function(data, row) {
	         return $("input:checkbox", row)[0].checked;
	       }
	});
	if(v.length==0){
		alert($.i18n('secret.choose.personnel'));
		return;
	}
	var fileIds="";//传递的是人员id
	 for(var i=0;i<v.length;i++){
		 if(i===v.length-1){
			 fileIds+=v[i].id;
         }else{
        	 fileIds+=(v[i].id+",");
         }
	 }
	 var url ="/seeyon/secret/secretSetController.do?method=secretSetdata&fileIds="+fileIds;
	 if(v.length == 1){
		 url += "&secretLevel="+v[0].secretlevel;
	 }
	setDialog(url);
}
function setDialog(url){
       var dialog = $.dialog({
            id: 'html',
            htmlId: 'htmlId',
            url:url,
            height:120,
            title: $.i18n('secret.user.set.secretSetting'),

            overflow:'hidden',
            buttons: [{
                text: $.i18n("common.button.ok.label"),
                isEmphasize: true, //蓝色按钮
                handler: function () {
                    var selectValues = dialog.getReturnValue();
                    dialog.close();
                    var fileIds = selectValues.split("&")[0];
                    var selectValue = selectValues.split("&")[1];
                    setSecret(fileIds,selectValue);

                }
            }, {
                text: $.i18n('common.button.cancel.label'),
                handler: function () {
                    dialog.close();
                }
            }]
        });
}
function setSecret(fileIds,selectValue){
	var url= "/seeyon/secret/secretSetController.do?method=saveSecretData&fileIds="+fileIds+"&selectValue="+selectValue;
	$.ajax({url : url,success : function(data){
		 if(orgAccountId　!= ""){
           	 var obj = new Object();
                obj.orgAccountId = orgAccountId;
                $("#memberTable").ajaxgridLoad(obj);
           }else{
           	 var obj = new Object();
                $("#memberTable").ajaxgridLoad(obj);
           }
		}});
}

</script>
<script type="text/javascript">
function fenPeiRole(){//分配角色
	var v = $("#memberTable").formobj({
	       gridFilter : function(data, row) {
	         return $("input:checkbox", row)[0].checked;
	       }
	});
	if(v.length==0){
		alert($.i18n('secret.choose.personnel'));
		return;
	}
	if(v.length>1){
		alert($.i18n('secret.choose.personnel.one'));
		return;
	}
	var fileIds="";//传递的是人员id
	 for(var i=0;i<v.length;i++){
		 if(i===v.length-1){
			 fileIds+=v[i].id;
      }else{
     	 fileIds+=(v[i].id+",");
      }
	 }
	 var url = "/seeyon/secret/secretSetController.do?method=secretRole&fileIds="+fileIds;
	 setRoleDialog(url);
}
function setRoleDialog(url){
    var dialog = $.dialog({
         id: 'html',
         htmlId: 'htmlId',
         url:url,
         height:500,
         width:300,
         title: $.i18n("secret.user.set.roleSetting"),
         overflow:'hidden',
         buttons: [{
             text: $.i18n("common.button.ok.label"),
             isEmphasize: true, //蓝色按钮
             handler: function () {
                 var selectValues = dialog.getReturnValue();
                 if(!selectValues){
                 	 dialog.close();
                 }else{
                 	 var memberIds = selectValues.split("&")[0];
	                 var fileIds = selectValues.split("&")[1];
	             	 var memberManagerAjax = new memberManager();
	             	 memberManagerAjax.dealSecretRole(memberIds,fileIds);
	                 dialog.close();//关闭弹出窗口
	                 if(orgAccountId　!= ""){
                    	 var obj = new Object();
                         obj.orgAccountId = orgAccountId;
                         $("#memberTable").ajaxgridLoad(obj);
                    }else{
                    	 var obj = new Object();
                         $("#memberTable").ajaxgridLoad(obj);
                    }
                 }
             }
         }, {
             text: $.i18n('common.button.cancel.label'),
             handler: function () {
                 dialog.close();
             }
         }]
     });
}
</script>
</head>
<body>

<div id="toobar_miji">
</div>
    <div id='layout' class="comp" comp="type:'layout'">
     <c:if test="${app == '2'}">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'renYuanJueSe'"></div>
    </c:if>
      <c:if test="${app == '1'}">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'RenYuanMiJi'"></div>
    </c:if>
     <div class="layout_west" id="west" layout="width:200">
            <div id="unitTree"></div>
        </div>
        <div class="layout_center over_hidden" layout="border:false" id="center">
            <table id="memberTable" class="flexme3" style="display: none"></table>
            <div id="grid_detail">
                <div>
                    <div id="sssssssss" class="clearfix" style="position: relative;">
                        <div id="welcome">
                            <div class="color_gray margin_l_20">
                                <div class="clearfix">
                                    <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n("org.external.member.info")}</h2>
                                    <div class="font_size12 left margin_t_20 margin_l_10">
                                        <div class="margin_t_10 font_size14">
                                            <span id="count"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="line_height160 font_size14">
                                    ${ctp:i18n('organization.detail_info_external_secret')}</div>
                            </div>
                        </div>
                    </div>
                    <div id="btnArea" class="">
                        <div id="button_area" align="center" class="page_color button_container border_t padding_t_5" style="height:35px;">
                            <table width="80%" border="0">
                                <tbody>
                                    <tr>
                                        <td width="20%" align="center">
                                            <label class="margin_r_10 hand" for="conti" id="lconti" style="font-size:12px;">
                                                <input id="conti" class="radio_com" value="0" type="checkbox" checked="checked">${ctp:i18n('continuous.add')}&nbsp;
                                            </label>
                                        </td>
                                        <td width="60%" align="center">
                                            <a href="javascript:void(0)" id="btnok"
                                                class="common_button common_button_gray">${ctp:i18n('common.button.ok.label')}</a>&nbsp;&nbsp;
                                            <a href="javascript:void(0)" id="btncancel"
                                                class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                                        </td>
                                        <td width="20%">&nbsp;</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>