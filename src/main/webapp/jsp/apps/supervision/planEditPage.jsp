<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>新建计划</title>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/supervisionEditPage.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/dialog.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/dialog.js"></script>
<style type="text/css">
	.attachmentShowDelete{
		background:none;
		background-color：#3E3E3E;
		border:0px;
	}
	.affix_del_16,.affix_del_16:hover{
		background:url("${path}/apps_res/supervision/img/cancel.png?v=5_6_6_04") no-repeat scroll 0 0 rgba(0, 0, 0, 0);
		display: inline-block;
	    height: 16px;
	    line-height: 16px;
	    vertical-align: middle;
	    width: 16px;
	}
	#field0140_txt{
		width:400px;
	    box-sizing: border-box;
	    border:1px solid #D7D7D7;
	    border-radius:5px;
	    height:28px;
	}
</style>
</head>
<body style="overflow: auto;overflow-x:hidden;">

	<form id="subTableForm" class="">
		<div class="xl-container xl-plan-container">

			<table class="xl-content-table" id="${tableName}">
				<colgroup>
					<col width="110px" />
					<col width="80px" />
					<col width="100px" />
					<col width="120px" />
					<col width="90px" />
				</colgroup>
				<tbody>
				<tr style="text-align:left;display:none;" id="errorTr">
	        		<td></td>
	        		<td colspan="4" id="errorMsg">
	        			<ul></ul>
	        		</td>
	        	</tr>
				<tr>
                <td align="right">
                    <div>
                        <label style="">计划周期：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div class="xl_plan_period">
                        <input type="text" name="field0138" id="field0138" class="comp" readonly="readonly" style="min-height:28px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"/>
                        至
                        <input type="text" name="field0142" id="field0142" class="comp" readonly="readonly" style="min-height:28px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false"/>
                    </div>
                </td>
            </tr>
					<tr>
						<td align="right">
							<div>
								<label style="">目标路线：</label>
							</div>
						</td>
						<td colspan="4">
							<div style="width:360px">
								<textarea type="text" class="xl-goal validate" name="field0139"
									id="field0139" validate="name:'目标路线',type:'string',maxLength:4000,china3char:true,notNull:true"></textarea>
									<input type="hidden" value="${id}" name="id" id="id"> 
							</div>
						</td>
					</tr>
					<tr>
						<td align="right">
							<div>
								<label style="">反馈单位：</label>
							</div>
						</td>
						<td colspan="4">
							<div>
								<textarea validate="name:'反馈单位',type:'string',china3char:true,notNull:true" type="text" unselectable="on" id="field0140_txt" name="field0140_txt" class="xl-help-units validate">${organize}</textarea>
                        		<input type="hidden" id="field0140" name="field0140" value="${field0140}">
							</div>
						</td>
					</tr>
					<tr class="xl-link">
						<td></td>
						<td>
							<div class="xl-attachment" onclick="insertAttachmentPoi('${field0144}')">
								<b onclick=""></b>
								<span>附件</span>
							</div>
						</td>
						<td>
							<div class="xl-association" onclick="quoteDocument('${field0145}')">
								<b onclick=""></b>
								<span>关联文档</span>
							</div>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr class="xl-content">
						<td></td>
						<td colspan="4">
						<div class="xl-feedback-block">
							<p class="xl_remind_word">请点击附件或关联文档添加内容</p>
							<ul id="field0144_span" class="edit_class"
									fieldVal='{name:"field0144",isMasterFiled:"false",displayName:"DR4附件",fieldType:"VARCHAR",inputType:"attachment",formatType:"",value:""}'><div
										class="comp"
										comp="type:'fileupload',callMethod:'fileValueChangeCallBack',delCallMethod:'fileDelCallBack',takeOver:false,isBR:true,canDeleteOriginalAtts:true,notNull:'false',displayMode:'visible',autoHeight:true,applicationCategory:'2',embedInput:'field0144',attachmentTrId:'${field0144}'"
										attsdata='{}'></div><input
										type='hidden' id='field0144_${id}_editAtt'
										value="true">
							</ul>
							<ul id="field0145_span" class="edit_class"
									fieldVal='{name:"field0145",isMasterFiled:"false",displayName:"DR4关联文档",fieldType:"VARCHAR",inputType:"document",formatType:"",value:""}'><div
										class="comp"
										comp="type:'assdoc',callMethod:'assdocValueChangeCallBack',delCallMethod:'assdocDelCallBack',notNull:'false',displayMode:'visible',attachmentTrId:'${field0145}', modids:'1,3',embedInput:'field0145'"
										attsdata='{}'></div><input
										type='hidden' id='field0145_${id}_editAtt'
										value="true">
							</ul>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="3"></td>
						<td align="center">
							<div>
								<input type="button" value="取消" class="xl_btn_cancel"
									onclick="_closeWin()" />
							</div>
						</td>
						<td align="left">
							<div>
								<input type="button" value="提交" class="xl_btn"
									onclick="sendReq4AddOrDel()" />
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div
						requrl="${path }/fileUpload.do?type=0&amp;applicationCategory=undefined&amp;extensions=&amp;maxSize=&amp;isEncrypt=&amp;popupTitleKey="
						style="overflow: auto;; *font-size: 0; max-height: 64px; overflow-x: hidden;"
						id="attachmentArea"></div>
		</div>
	</form>
</body>
<script type="text/javascript">
	//复制自form.js
	function sendReq4AddOrDel() {
		//表单提交
		var formobj = $("#subTableForm");
		if(!formValidate()){
			return;
		}
		if(!formobj.validate({errorBg:true,errorIcon:true})){
			validatamsg(formobj);
			return;
		}
		var contentData = [];// 正文数据
		contentData.push("${tableName}");
		//模拟提醒记录
		var url = "${path}/supervision/supervisionController.do?method=saveSubTables&masterDataId=${masterDataId}&tableName=${tableName}&tag="
				+ (new Date()).getTime();
		formobj.jsonSubmit({
			action : url,
			domains : contentData,
			debug : false,
			validate : false,
			ajax : true,
			callback : function(objs) {
				var success = eval('(' + objs + ')').success;
				if (success == 'true') {
					//alert("计划提交成功");
					sendsuccess('计划提交成功');
					_closeWin('feedback');
				}else{
					dbAlert("计划提交失败，请联系管理员！",parent);
				}
			}
		});
	}

	/**
	 * 插入附件回调函数
	 */
	function fileValueChangeCallBack(fileHiddenInput) {
		$(".xl-content-block").css("background-color","#F3F3F3");
		$(".xl_remind_word").hide();
	}
	function fileDelCallBack(){
		var attachmentObj=$("div[id^='attachmentDiv_']");
		if(attachmentObj.length==0){
			$(".xl_remind_word").show();
		}
	}
	/**
	 * 插入关联文档回调函数
	 */
	function quoteDoc_Doc1Callback() {
		$(".xl_remind_word").hide();
		$(".attachmentShowDelete").each(function(){
			$(this).css("float","none");
		})
	}
	
	function addScrollForDocument(){
		var attachmentObj=$("div[id^='attachmentDiv_']");
		if(attachmentObj.length==0){
			$(".xl_remind_word").show();
		}
	}
	
	function formValidate(){
		var date1 = $("#field0138").val();
		var date2 = $("#field0142").val();
		var complateDate = parent.complateTime;
		if(date1!='' && date2!='' && date2<date1){
			 dbAlert("计划的开始时限不能大于结束时限！",parent);
			 return false;
		}
		if(complateDate!='' && date2>complateDate){
			 dbAlert("计划时间不能大于事项的完成时限！",parent);
			 return false;
		}
		return true;
	}
	
	$("#field0140_txt").bind('click',function(){
		var values = $("#field0140").val();
		var txt = $("#field0140_txt").val();
	   	$.selectPeople({
	   	        type:'selectPeople'
	   	        ,panels:'Account,Department,OrgTeam,ExchangeAccount'
	   	        ,selectType:'Account,Department,OrgTeam,ExchangeAccount'
	   	        ,text:$.i18n('common.default.selectPeople.value')
	   	        ,hiddenPostOfDepartment:true
	   	        ,hiddenRoleOfDepartment:true
	   	        ,showFlowTypeRadio:false
	   	        ,targetWindow:getCtpTop()
	   	        ,returnValueNeedType:true
	   	     	,params : {
			    	text : txt,
			        value : values
			    }
	   			,minSize:0
	   	        ,callback : function(res){
	   	        	if(res && res.obj && res.obj.length>0){
	   	        		$(this).css("background-color","#fff");
    	                $("#field0140").val(res.value);
    	                $("#field0140_txt").val(res.text);
    	            }else{
    	            	$("#field0140").val('');
    	                $("#field0140_txt").val('');
    	            }
	   	        }
	   	    });
	   });
	$(function(){
		//关联文档请求的url增加回调函数
		var rquesturl=$("#attachment2Area${field0145}").attr("requesturl");
		$("#attachment2Area${field0145}").attr("requesturl",rquesturl+"&callMethod=quoteDoc_Doc1Callback");
	})
</script>
</html>