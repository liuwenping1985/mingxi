<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=findChildNum"></script>
<!DOCTYPE html>
<html class="over_hidden">
<head>
<style>
.stadic_body_top_bottom{
    bottom: 30px;
    top: 0px;
}
.stadic_footer_height{
    height:30px;
}
</style>

<script type="text/javascript" src="${path}/ajax.do?managerName=orgManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=xcSynManager"></script>
<script type="text/javascript" language="javascript">
var memberIds = window.dialogArguments;
var xcManager = new xcSynManager();
$().ready(function() {
	var childnum=xcManager.findChildNum();
	var selectid=document.getElementById("typeName");
	if(selectid!=null){
		selectid.options.length=1;
    for(var i=0;i<childnum.length;i++){
	    var op = document.createElement("option");
		op.setAttribute("value",childnum[i].childnum);
		op.setAttribute("id","o"+i);
		//op.innerHTML = childnum[i].childnum;
		selectid.appendChild(op);
		$("#o"+i).text(childnum[i].childnum).html();
	}
	}
	
    $("#ids").val(memberIds);
	$("#certigier").click(function() {
        $.selectPeople({
            type: 'selectPeople',
            panels: 'Department,Team,Post,RelatePeople',
            selectType: 'Member',
            minSize: 1,
            maxSize: 1,
            onlyLoginAccount: true,
            returnValueNeedType: false,
            callback: function(ret) {
                $("#certigier").val(ret.text);
                $("#certigierId").val(ret.value);
            }
        });
    });

    $("#btnok").click(function() {
		var ids=$("#ids").val();
		var id=$("#certigierId").val();
		if(ids.indexOf(id)>-1&&id!=""){
			$.alert("${ctp:i18n('xc.syn.return.5.js')}");//被授权人不能与授权人是同一个人！
			return false;
		}
		if("childnum"=="${select}"){
			if($("#typeName").val()==null){
				$.alert("${ctp:i18n('xc.syn.return.4.js')}");//必填项不能为空
				return ;
			}
		}
		if("certigier"=="${select}"){
			if($("#certigier").val()==''){
				$.alert("${ctp:i18n('xc.syn.return.4.js')}");//必填项不能为空
				return ;
			}
			var email= xcManager.getEmail(id);
			if(email==''||email==null){
			$.alert("${ctp:i18n('xc.syn.return.6.js')}");//邮箱不能为空
			return false;
		 }
	  }
        getCtpTop().startProc($.i18n('xc.syn.start.js'));//同步进度条
        $("#memberBatForm").submit();
    });
   
});
function getchildnimdesc(){
	var selectid=document.getElementById("typeName");
	var childnum=$("#typeName").children('option:selected').val();
	var childnumdesc=xcManager.checkChildNum(childnum,"C");
	document.getElementById("desc").innerText=childnumdesc;
		//alert($("#typeName").children('option:selected').val());
	}
	
function OK() {
	var ids =$("#ids").val();
	var roleIds =$("#roleIds").val();
	var orgDepartmentId =$("#orgDepartmentId").val();
	var orgPostId =$("#orgPostId").val();
	var orgLevelId =$("#orgLevelId").val();
	var certigierId =$("#certigierId").val();
	var certigier =$("#certigier").val();
	var typeName =$("#typeName").val();
	var sel ="${select}";
	return {"ids":ids,"sel":sel,"roleIds":roleIds,"orgDepartmentId":orgDepartmentId,"orgPostId":orgPostId,"orgLevelId":orgLevelId,"certigierId":certigierId,"certigier":certigier,"typeName":typeName};
}

</script>
</head>
<body>
<div class="form_area" id='form_area'>
    <form id="memberBatForm" name="memberBatForm" method="post" action="member.do?method=syn_batchUpdate">
        <div class="align_center clearfix">
            <table width="90%" border="0" cellspacing="0" cellpadding="0" class="margin_l_15">
                <input type="hidden" id="ids" name="ids" value="-1">
                <input type="hidden" id="roleIds" name="roleIds">
                <input type="hidden" id="orgDepartmentId" name="orgDepartmentId">
                <input type="hidden" id="orgPostId" name="orgPostId">
                <input type="hidden" id="orgLevelId" name="orgLevelId">
				<!-- 批量人员修改 start -->
				 <input type="hidden" id="certigierId" name="certigierId">
				 <!-- 批量人员修改 end -->
                <!-- 批量修改角色 -->

				<!-- 批量人员修改 start -->
				<c:if test="${select=='certigier'}">
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color='red'>*</font>${ctp:i18n('xc.syn.confirmPersonSet')}:</label><!--授权人员-->
                    </th>
                    <td width="80%"><div class="common_txtbox_wrap">
                            <input type="text" id="certigier" name="certigier" class="w100b"/>
                        </div>
                    </td>
                <tr>
				</c:if>
				<c:if test="${select=='childnum'}">
				 <tr>
                    <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color='red'>*</font>${ctp:i18n('xc.syn.SubAccountNameSet')}:</label><!--账号-->
                    </th>
                    <td width="80%">
                            <select id="typeName" name="typeName" style="WIDTH: 100% " onchange="getchildnimdesc();">  
								<option disabled="disabled" value="">-请选择-</option>  
							</select> 
                        
                    </td>
                <tr>
                <tr>
                    <th nowrap="nowrap">
                        <label class="margin_r_10" for="text">${ctp:i18n('xc.SubAccountName.desc')}</label></th>
                    <td>
                        <div class="common_txtbox  clearfix">
                            <textarea cols="30" rows="7" class="w100b " id="desc" name="desc" disabled="disabled"></textarea>
                        </div>
                    </td>
                </tr>
				</c:if>
				<!-- 批量人员修改 end -->
            </table>
        </div>
    </form>
</div>
</body>
</html>