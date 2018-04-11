<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head> 
<title>信息评分标准设置</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoScoreManager"></script>
</head>
<script type="text/javascript">
$(document).ready(function () {
	var scoreType="${score.type}";
	changeSelect(scoreType);
	$("#edit_confirm_button").click(function() {
		if("${ctp:escapeJavascript(param.openForm)}" === 'add'||  "${ctp:escapeJavascript(param.openForm)}" === 'edit'){
			submitScore();
        }
	});
	$("#edit_cancel_button").click(function() {
		parent.location.reload();
	});
	if("${ctp:escapeJavascript(openForm)}" == "add" || "${ctp:escapeJavascript(openForm)}" == "edit"){
		$("#publishRange").bind("click", function() {
			openMagazinePublishDialog($(this));
		});//发布范围绑定
	}
});

function submitScore() {
    //判断信息评分标准名称是否重复
    var name = $("#name").val();
    var id = '${score.id}';
    var scoreManager = new infoScoreManager();
    var isRepeatName = scoreManager.getScoreName(id, name);
    if (isRepeatName) {
        $.alert("${ctp:i18n('infosend.editScore.isReName')}");
        return;
    }
    var _type = $("#type").val();
    if(_type == "0"){
    	$("#publishToViewRangeIds").val("");
		$("#publishToViewRangeNames").val("");
		$("#publishToPublicRangeIds").val("");
		$("#publishToPublicRangeNames").val("");
		$("#publishRange").val("");
    }
    //表单提交
    var form = $("#addForm");
    var path = _ctxPath + "/info/score.do?method=editScore";
    form.attr('action', path);
    form.jsonSubmit({
        validate : true,
        errorIcon : true,
        callback : function(args) {
        	if(args != "true" && args != "<PRE>true</PRE>") {//<PRE>true</PRE> 兼容ie7情况
        		$.alert(args);
        	}else{
        		parent.window.location.reload();        		
        	}
        }
    });
}

function changeSelect(val){
	if(val == "0"){//上报评分标准
		document.getElementById('levelId').style.display="none";
		document.getElementById('fanweiId').style.display="none";
	}else{//发布评分标准
		document.getElementById('levelId').style.display="";
		document.getElementById('fanweiId').style.display="";
		
		if("${ctp:escapeJavascript(openForm)}" != "add") {
			if("${ctp:escapeJavascript(openForm)}" != "edit" || '${score.enumId}' != "" ){//枚举字段可能被删除
				$("#levelId").find("#level").val('${score.enumId}');
			}
		}
	}
}
var openForm = "${openForm}";
function _init(){
	if(openForm != "add" && openForm != "edit"){
		$("#type").disable();
		$("#nameDiv").disable(); 
		$("#levelDiv").disable();
		$("#scroeDiv").disable();
		$("#publishRangeDiv").disable();
		$("#stateDiv").disable();
		$("#descDiv").disable();
	}
	$("#createUserNameDiv").disable();
}
</script>

<body class="h100b over_hidden" onload="_init();">
<div class="stadic_layout_body stadic_body_top_bottom form_area"  id="content">
  <form name="addForm" id="addForm" method="post" class="align_center">
  	<input type="hidden" id="scoreId" name="scoreId" value="${score.id }" />
    <input type="hidden" id="isSys" name="isSys" value="${score.isSys }" />
  	<table border="0" cellSpacing="0" cellPadding="0" width="500" align="center">
  	<tbody>
  			<tr>
				<th noWrap><label for="name">${ctp:i18n("infosend.score.type.lable")}<!-- 评分标准类型 -->:</label></th>
					<td width="35%" class="w100b">
					<div class="common_selectbox_wrap w100b" >
						<select id="type" name="type" style="width: 100%"  validate="name:'${ctp:i18n('infosend.score.type')}',notNull:true,type:'int'" onchange="changeSelect(this.value)">
							<option ${score.type==1 ? "selected='selected'" : "" } value="1">${ctp:i18n('infosend.score.type.publish.label')}<!-- 发布评分标准 --></option>
                			<option ${score.type==0 ? "selected='selected'" : "" } value="0">${ctp:i18n('infosend.score.type.report.label')}<!-- 上报评分标准 --></option>
						</select>
					</div>
					</td>
				</tr> 
			<tr>
				<th noWrap><font color="red">*</font>${ctp:i18n("infosend.score.database.name")}<!-- 信息评分标准名称 -->:</th>
				<td class="w100b">
				<input id="id" name="id" value="${score.id}" type="hidden" validate="name:'id',notNull:true,type:'long',isNumber:true"/>
				<input id="domainId" name="domainId" type="hidden" value="${score.domainId }"/>
            	<div class="common_txtbox_wrap" id="nameDiv">
            		<input id="name" name="name" class="validate" type="text" value="${ctp:toHTMLWithoutSpace(score.name)}" validate="type:'string',name:'${ctp:i18n("infosend.score.database.name")}',notNull:true,maxLength:85,character:'-!@#$%^&amp;*()_+'" /><!-- 评分标准 -->
            	</div>
          		</td>
			</tr>
			<tr id="levelId">
				<th noWrap><label for="name"><font color="red">*</font>${ctp:i18n('infosend.score.publish.level')}<!-- 刊登级别 -->:</label></th>
				<td class="w100b">
					<div class="common_selectbox_wrap" id="levelDiv">
						${enumString}
					</div>
				</td>
				</tr> 
				 <tr>
					<th noWrap><label for="name"><font color="red">*</font>${ctp:i18n('infosend.score.number')}<!-- 分数 -->:</label></th>
					<td class="w100b">
					<div class="common_txtbox_wrap" id="scroeDiv">
						<input id="score" name="score" type="text" class="validate" class="input-100per" value="${score.score}" escapeXml="true" validate="name:'${ctp:i18n('infosend.score.number')}',notNull:true,isInteger:true,maxLength:3,min:0"/>
						</div>
					</td>
				</tr>
				<tr id="fanweiId">
					<th noWrap><font color="red"></font>${ctp:i18n('infosend.score.publisdestination.label')}<!-- 绑定发布范围 -->:</th>
					<td class="w100b">
		            	<div class="common_txtbox_wrap" id="publishRangeDiv"}>
		            		<input id="publishRange" name="publishRange" class="validate" type="text" value="${publishVO.publishRangeNames}" title="${publishVO.publishRangeNames}" />
		            	</div>
		            	<%@ include file="../../common/magazine_publish_common.jsp" %>
	          		</td>
				</tr>
				<tr>
					<th noWrap><label for="name">${ctp:i18n('infosend.score.state.label')}<!-- 状态 -->:</label></th>
					<td width="35%" nowrap="nowrap" class="new-column">
					<div class="common_selectbox_wrap" id="stateDiv">

						<select id="state" name="state" style="width:100%" validate="name:'${ctp:i18n('infosend.label.status')}',notNull:true,type:'int'"><!-- 当前状态 -->
						<option ${score.state==1 ? "selected='selected'" : "" } value="1">${ctp:i18n('infosend.status.enable')}<!-- 启用 --></option>
                		<option ${score.state==0 ? "selected='selected'" : "" } value="0">${ctp:i18n('infosend.status.disable')}<!-- 停用 --></option>
						</select>
					</div>
					</td>
				</tr> 
				
				<tr>
					<th noWrap><label for="name">${ctp:i18n('infosend.score.create.user')}<!-- 创建人 -->:</label></th>
					<td class="w100b">
					<div  class="common_txtbox_wrap" id="createUserNameDiv">
					    <input type="hidden" id="createUserId" name="createUserId" value="${score.createUserId}" class="input-100per" value="" validate="name:'createUserId',notNull:true,type:'long',isNumber:true"/>
						<input type="text" id="createUserName" name="createUserName" class="input-100per" escapeXml="true" value="${score.createUserName}"/>
					</div>
					</td>
				</tr>
					
				<tr>
					<th noWrap>${ctp:i18n('infosend.score.create.time')}<!-- 创建时间 -->:</label></th>
					<td class="w100b">
					 <div class="common_txtbox_wrap">
					 	<input id="createTime" name="createTime" class="comp input_date validate" disabled="true" type="text" value="${ctp:formatDateByPattern(score.createTime, 'yyyy-MM-dd HH:mm')}" _inited="1" _icoed="true" _autoFill="false" validate="name:'${ctp:i18n('infosend.score.create.time')}',notNull:true,type:'3'"/><!-- 创建时间 -->
		              	<!-- 
		              	<span style="CURSOR: hand" class="calendar_icon_area _autoBtn">
		                	<span style="POSITION: absolute; TOP: -1px; LEFT: -14px" class="calendar_icon"></span>
		              	</span>  -->
		            </div>
					</td>
				</tr> 
				<tr>
					<th noWrap><label for="name">${ctp:i18n('infosend.score.scoredesc.label')}<!-- 备注 -->:</label></th>
					<td class="w100b">
					<div class="common_txtbox" id="descDiv" style="margin-right: 2px;">
						<textarea name="desc"  class="validate w100b" id="desc" cols="60" rows="3" validate="type:'string',name:'${ctp:i18n('category.column.desc')}',notNull:false,maxLength:100">${score.desc}</textarea>
					</div>
					</td>
				</tr>
				<tr><td style=''>&nbsp;</td></tr>  
  		</tbody>
  	</table> 
  </form>
</div>
<c:if test="${param.openForm=='add' || param.openForm=='edit'}">
	<style>
	.stadic_body_top_bottom{
	    top: 0px;
	    bottom: 40px;
	}
	.stadic_footer_height{
	    height:40px;
	}
	</style>
		<div class="stadic_layout_footer stadic_footer_height" id="bottomButton">
			<div id="button" class="common_checkbox_box align_center clearfix padding_t_5 border_t">
		           	<a href="javascript:void(0)" class="common_button common_button_gray" id="edit_confirm_button">${ctp:i18n('permission.confirm')}</a>&nbsp;<%--确定 --%>
		            <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_cancel_button">${ctp:i18n('permission.cancel')}</a><%--取消 --%>
		        </div>
		</div>
</c:if>
</body>
</html>








