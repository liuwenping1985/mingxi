<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>新建反馈</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/supervisionEditPage.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
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
	#field0072_txt{
		width:390px;
	    box-sizing: border-box;
	    border:1px solid #D7D7D7;
	    border-radius:5px;
	    height:28px;
	}
	
</style>
</head>
<body style="overflow: auto;overflow-x:hidden;">

	<form id="subTableForm" class="">
		<div class="xl-container xl-feeback-container">
			<!--取消按钮样式--><!-- xl 6-30此处去掉了头部 -->
			
			<table class="xl-content-table" id="${tableName}" style="padding-right:3px;">
				<input type="hidden" value="" name="field0092" id="field0092">
				<input type="hidden" value="" name="field0130" id="field0130">
				<input type="hidden" value="" name="field0097" id="field0097">
				<input id="field0135" name="field0135" type="hidden" value="1"/>
				<colspan>
					<col width="90px"/>
	                <col width="80px"/>
	                <col width="100px"/>
	                <col width="120px"/>
	                 <col width="90px"/>
				</colspan>
				<tbody>
					<tr style="text-align:left;display:none;" id="errorTr">
		        		<td></td>
		        		<td colspan="4" id="errorMsg">
		        			<ul></ul>
		        		</td>
		        	</tr>
					<tr>
		                <td align="right">
		                    <div style="width:85px">
		                        <label style="">目标路线：</label>
		                    </div>
		                </td>
		                <td colspan="4">
		                     <div>
		                          <select name="" class="xl-feedback-period" id="timeSelect">
		                              <option value=""></option>
		                              <c:forEach items="${dataList}" var="data">
		                              	<c:if test="${fn:length(data.field0139)>0}">
			                              	<option title="${data.field0139}" value="${data.id}" <c:if test="${data.id==id}">selected</c:if>>
				                              	<c:if test="${fn:length(data.field0139)>28 }">${fn:substring(data.field0139,0,28)}...</c:if>
												<c:if test="${fn:length(data.field0139)<=28 }">${data.field0139}</c:if>
											</option>
										</c:if>
		                              </c:forEach>
		                          </select>
		                      </div>
		                </td>
		            </tr>
		            <tr style="display:none">
		            	<td>
			            	<c:forEach items="${dataList}" var="data">
				            	<input type="hidden" value="${data.field0138 }" id="${data.id}field0092"/>
								<input type="hidden" value="${data.field0142 }" id="${data.id}field0130"/>
								<input type="hidden" value="${data.field0139 }" id="${data.id}field0097"/>
							</c:forEach>
							<input type="text" value="${id}" id="id">
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
								<textarea validate="name:'反馈单位',type:'string',china3char:true,notNull:true" type="text" unselectable="on" id="field0072_txt" name="field0072_txt" class="xl-help-units validate">${organize}</textarea>
                        		<input type="hidden" id="field0072" name="field0072" value="${field0072}">
							</div>
						</td>
					</tr>
					
					<tr>
						<td align="right">
							<div>
	                            <label>事项完成率：</label>
	                        </div>
						</td>
						<td colspan="4">
						<input type="hidden" name="field0074" id="field0074">
							<div>
								<div class="scroll" id="scroll">
	                                <div id="bar" class="bar">
	                                    <p class="bar_num" id="bar_num"></p>
	                                </div>
	                                <div class="xl_mask" id="mask"></div>
	                            </div>
                        	</div>
						</td>
					</tr>
					<tr>
                    <td align="right">
                        <div>
                            <label>完成情况：</label>
                        </div>
                    </td>
                    <td colspan="4">
                        <div>
                            <textarea id="field0073" validate="name:'完成情况',china3char:true,maxLength:4000,notNull:true" name="field0073" type="text" class="xl-performance validate"></textarea>
                        </div>
                    </td>
                </tr>
                <tr class="xl-link">
						<td></td>
						<td>
							<div class="xl-attachment" onclick="insertAttachmentPoi('${field0076}')">
								<b></b>
								<span>附件</span>
							</div>
						</td>
						<td>
							<div class="xl-association" onclick="quoteDocument('${field0077}')">
								<b></b>
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
							<ul id="field0076_span" class="edit_class"
									fieldVal='{name:"field0076",isMasterFiled:"false",displayName:"DR4附件",fieldType:"VARCHAR",inputType:"attachment",formatType:"",value:""}'><div
										class="comp"
										comp="type:'fileupload',callMethod:'fileValueChangeCallBack',delCallMethod:'fileDelCallBack',takeOver:false,isBR:true,canDeleteOriginalAtts:true,notNull:'false',displayMode:'visible',autoHeight:true,applicationCategory:'2',embedInput:'field0076',attachmentTrId:'${field0076}'"
										attsdata='{}'></div><input
										type='hidden' id='field0076_${id}_editAtt'
										value="true">
							</ul>
							<ul id="field0077_span" class="edit_class"
									fieldVal='{name:"field0077",isMasterFiled:"false",displayName:"DR4关联文档",fieldType:"VARCHAR",inputType:"document",formatType:"",value:""}'><div
										class="comp"
										comp="type:'assdoc',callMethod:'assdocValueChangeCallBack',delCallMethod:'assdocDelCallBack',notNull:'false',displayMode:'visible',canDeleteOriginalAtts:true,attachmentTrId:'${field0077}', modids:'1,3',embedInput:'field0077'"
										attsdata='{}'></div><input
										type='hidden' id='field0077_${id}_editAtt'
										value="true">
							</ul>
							</div>
						</td>
					</tr>
					<div
						requrl="${path }/fileUpload.do?type=0&amp;applicationCategory=undefined&amp;extensions=&amp;maxSize=&amp;isEncrypt=&amp;popupTitleKey="
						style="overflow: auto;; *font-size: 0; max-height: 64px; overflow-x: hidden;"
						id="attachmentArea"></div>
					<tr>
						<td colspan="3"></td>
						<td align="center">
							<div>
								<input type="button" value="取消" class="xl_btn_cancel"
									onclick="_closeWin()" />
							</div>
						</td>
						<td align="right">
							<div>
								<input type="button" value="提交" class="xl_btn"
									onclick="sendReq4AddOrDel()" />
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</body>
<script type="text/javascript">
	//复制自form.js
	function sendReq4AddOrDel() {
		//表单提交
		var formobj = $("#subTableForm");
		if(!formobj.validate({errorBg:true,errorIcon:true})){
			validatamsg(formobj);
			return;
		}
		var contentData = [];// 正文数据
		contentData.push("${tableName}");
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
					sendsuccess("反馈成功");
					_closeWin('feedback');
				}
				//TODO 跳转页面到列表页面
			}
		});
	}

	/**
	 * 插入附件回调函数
	 */
	function fileValueChangeCallBack(fileHiddenInput) {
		//插入附件后修改背景颜色
		$(".xl-feedback-block").css("background-color","#F3F3F3");
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
	function assdocValueChangeCallBack() {
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
	
	$(function() {
		$("#timeSelect").change(function(){
			 //$(this).css("background-color","#FFFFCC");
			 var id=$(this).val();
			 $("#field0092").val($("#"+id+"field0092").val());
			 $("#field0130").val($("#"+id+"field0130").val());
			 $("#field0097").val($("#"+id+"field0097").val());
			 //window.location.href="${path}/supervision/supervisionController.do?method=enterFeedbackPage&tableName=feedback&masterDataId=${masterDataId}&planId="+id;
			 //$("#field0077").val(planIds[1]);
			 //$("#field0076").val(planIds[2]);
			 
		});
		
		//关联文档请求的url增加回调函数
		var rquesturl=$("#attachment2Area${field0077}").attr("requesturl");
		$("#attachment2Area${field0077}").attr("requesturl",rquesturl+"&callMethod=assdocValueChangeCallBack");
	});
	
	var scroll = document.getElementById('scroll');
    var bar = document.getElementById('bar');
    var mask = document.getElementById('mask');
    var ptxt = document.getElementById('bar_num');
    var barleft = 0;
    bar.onmousedown = function(event){
        var event = event || window.event;
        var leftVal = event.clientX - this.offsetLeft;
        var that = this;
        // 拖动一定写到 down 里面才可以
        document.onmousemove = function(event){
            var event = event || window.event;
            barleft = event.clientX - leftVal;
            if(barleft < 0)
                barleft = 0;
            else if(barleft > scroll.offsetWidth - bar.offsetWidth)
                barleft = scroll.offsetWidth - bar.offsetWidth;
            mask.style.width = barleft +'px' ;
            that.style.left = barleft + "px";
            var value=parseInt(barleft/(scroll.offsetWidth-bar.offsetWidth) * 100);
            ptxt.innerHTML = value + "%";
            document.getElementById("field0074").value=value/100;
            //防止选择内容--当拖动鼠标过快时候，弹起鼠标，bar也会移动，修复bug
            window.getSelection ? window.getSelection().removeAllRanges() : document.selection.empty();
        }

    }
    document.onmouseup = function(){
        document.onmousemove = null; //弹起鼠标不做任何操作
    }
    
    $("#field0072_txt").bind('click',function(){
		var values = $("#field0072").val();
		var txt = $("#field0072_txt").val();
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
    	                $("#field0072").val(res.value);
    	                $("#field0072_txt").val(res.text);
    	            }else{
    	            	$("#field0072").val('');
    	                $("#field0072_txt").val('');
    	            }
	   	        }
	   	    });
	   });
</script>
</html>