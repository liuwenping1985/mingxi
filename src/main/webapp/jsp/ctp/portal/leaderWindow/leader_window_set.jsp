<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2015-9-13 15:17:19#$:

 Copyright (C) 2015 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
  <head>
    <title>${ctp:i18n('edoc.system.menuname.leaderWindow')}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript">
         function fnShowBtn(_this){
         	if($(_this).val() =="${ctp:i18n('edoc.leader.window.please.input.duty')}" || $(_this).val() =="${ctp:i18n('edoc.leader.window.please.input.name')}"){
				$(_this).val("");
			}
         	 var curTr = $(_this).closest("tr").index();
             $(".dynamicTable tr").each(function(index){
            	$(this).find(".curspan").addClass("display_none");
            });
             $($(".dynamicTable tr td:last-child")[curTr]).find(".curspan").removeClass("display_none");
         }

		function fnShowDef(_this){
			if($(_this).val().trim()==""){
				if(_this.tagName == "TEXTAREA"){
					$(_this).val("${ctp:i18n('edoc.leader.window.please.input.name')}");
				}else{
					$(_this).val("${ctp:i18n('edoc.leader.window.please.input.duty')}");
				}
			}
		}

		$(document).ready(function(){
            $("#del").live("click",function(){
            	var _height = $(".dynamicTable").find("tr").height();
            	if($(".dynamicTable tr").size()>1){
            		if($(".dynamicTable tr").size()>3){
            			$("#mainIframe", parent.document).height($("#mainIframe", parent.document).height()-_height);
            		}

                	$(this).closest("tr").remove();
            	}else{
            		$.alert("${ctp:i18n('form.base.delRow.alert')}");
            	}
            });

            $("#adddown").live("click",function(){
            	var _height = $(".dynamicTable").find("tr").height();
            	  if($(".dynamicTable tr").size()>=10){
 					 alert("${ctp:i18n('edoc.leader.window.set.row.maxsize')}");
            	  }else{
            		  if($(".dynamicTable tr").size()>2){
            			  $("#mainIframe", parent.document).height($("#mainIframe", parent.document).height()+_height);
            		  }

            	  	  var parentTr = $(this).closest("tr");
		       		  var tr = parentTr.clone();
		       		  tr.find(".curspan").addClass("display_none");
		              parentTr.after(tr);
            	  }
            });
        });

        function lwValidate(obj,info){
        	var validate = true;
        	for(var i=0;i<obj.size();i++){
           		var value = obj[i].value;
           		if(value==""||value == info){
	           		$.alert(info);
	           		validate = false;
	           		break;
	           	}
	           	var r = value.match("&|#|@|$|%|=");
		        if(r!=null && r!=""){
		        	$.alert("${ctp:i18n('edoc.leader.window.set.validate')}");
		        	validate = false;
		        	break;
		        }
           	}
           	return validate;
        }

        function OK(resultFun,fragmentId,id){
        	var meg = "${ctp:i18n('modifyBody.save.label')}${ctp:i18n('edoc.system.menuname.leaderWindow')}${ctp:i18n('import.success')}";
        	var fValidate = $("#lwForm").validate();
        	var tableForm = $("#tableForm").validate();
        	var validate = true;
        	if(fValidate && tableForm){
	            validate = lwValidate($(".dynamicTable input"),"${ctp:i18n('edoc.leader.window.please.input.duty')}");
	            if(validate){
	            	validate = lwValidate($(".dynamicTable textarea"),"${ctp:i18n('edoc.leader.window.please.input.name')}");
	            	if(validate){
	            		var contentInp = document.getElementsByName("contentInp");
			        	var contentarea = document.getElementsByName("contentarea");
			        	var content = "";
			        	for(var i=0;i<contentInp.length;i++){
			        		if(contentInp[i].value == "" && contentarea[i].value == ""){
			        			break;
			        		}
							content = content+contentInp[i].value+"==="+contentarea[i].value+"(;)";
			        	}

			        	$("#content").val(content);
			        	$("#lwForm").jsonSubmit(
			              {
			                callback : function(res) {
				                 if (res != null && res != "") {
				                    $.alert(res);
				                 }else{
				                 	resultFun(fragmentId,id);
				                 }
			                }
			            });
	            	}
	            }
        	}

        }

        function cancel(){
			$("#main",window.parent.document).attr("src", _ctxPath + "/portal/portalController.do?method=showSystemNavigation");
        }

        function doOnclick(){
	  		try{
		  		getA8Top().headImgCuttingWin = getA8Top().$.dialog({
				    id : "headImgCutDialog",
		            title : "上传头像",
		            transParams:{'parentWin':window},
		            url: "/seeyon/portal/portalController.do?method=headImgCutting&source=leaderWindow",
		            width: 650,
		            height: 500,
		            isDrag:false
	  	  		 });
	 		 }catch(e){}
		}

		function headImgCuttingCallBack (retValue) {
			getA8Top().headImgCuttingWin.close();
			if(retValue != undefined){
		          $("#image2").attr("src", "${pageContext.request.contextPath}/fileUpload.do?method=showRTE&fileId=" + retValue + "&type=image");
		          $("#imageName").val("fileId=" + retValue);
		          $("#attachmentsFlag").val(true);
		    }
		}
	</script>
  </head>

  <body style="overflow-y:hidden">
 			<div class="form_area">
   			<div class="">
		   		<table  style="margin:15px auto 0">
		    		<tr>
		    			<td valign="top" width="50%" style="border-right:1px dashed rgb(211, 211, 211)">
		    				<div class="form_area align_center">
							    <form id="lwForm" action="leaderwindow.do?method=saveLeaderWindow" method="post">
							        <table border="0" cellspacing="0" cellpadding="0" width="250" align="center">
							            <tbody>
							            	<tr>
							            		<th colspan="2" style="text-align:center;padding: 8px 0; ">主要领导信息</th>
							            	</tr>
								            <tr>
								            	<td>
				        							<c:choose>
				                                        <c:when test="${leaderWindow.imageName ==null || leaderWindow.imageName =='' }">
				                                        	<img id="image2" width="130" hight="180" src="${pageContext.request.contextPath}/apps_res/edoc/images/lwdefault.png" class="radius cursor-hand" onClick="doOnclick();"/>
				                                        </c:when>
				                                        <c:otherwise>
				                                        	<img id="image2" width="130" hight="180" src="${pageContext.request.contextPath}/fileUpload.do?method=showRTE&${leaderWindow.imageName}&type=image" class="radius cursor-hand" onClick="doOnclick();"/>
				                                        </c:otherwise>
					                                    </c:choose>
														<input type="hidden" id="imageName" name="imageName" value="${leaderWindow.imageName }">
														<input type="hidden" id="id" name="id" value="${leaderWindow.id }">
								            	</td>
								            	<td>
								            		<table style="margin: 0 5px;">
									            		<tr>
												                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('edoc.leader.window.name')}:</label></th>
												                <td width="60%"><div class="common_txtbox_wrap">
												                    <input id="name" type="text" class="validate" value="${ctp:toHTMLWithoutSpace(leaderWindow.name)}" validate='type:"string",name:"${ctp:i18n('edoc.leader.window.name')}:",notNull:true,maxLength:50'>
																	<input name="attachmentsFlag" type="hidden" id="attachmentsFlag" type="text" value="${leaderWindow.attachmentsFlag }">
																	<input name="content" id="content" type="hidden" value="${leaderWindow.content }"/>
												                </div></td>
												            </tr>
												            <tr>
												                <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('edoc.leader.window.duty')}:</label></th>
												                <td width="60%">
												                	<div class="common_txtbox_wrap">
												                    	<input type="text" class="validate" name="duty" validate='type:"string",notNull:true,name:"${ctp:i18n('edoc.leader.window.duty')}",maxLength:120' id="duty" value="${leaderWindow.duty }"/>
												                	</div>
												                </td>
												            </tr>
												            <tr>
												                <th nowrap="nowrap"><label class="margin_r_10" for="text">工作分工:</label></th>
												                <td>
												                    <textarea class="validate" name="fenGong" validate='type:"string",notNull:true,name:"工作分工",maxLength:600' id="fenGong"  style="line-height: 20px; height:40px">${leaderWindow.fenGong}</textarea>
												                </td>
												            </tr>
								            		</table>
								            	</td>
								            </tr>
								            <tr><td align="center" >${ctp:i18n('edoc.leader.window.suggest.size')}：130*180px</td><td>&nbsp; </td> </tr>

							            </tbody></table>
							    </form>
							</div>
		    			</td>
		    			<td  width="50%" valign="top" >
			    			<div class="form_area align_center" style="margin-left: 5px;">
							    <form id="tableForm" action="#" >
							    	<h1 style="font-weight: normal; font-size:12px; text-align: center; width:300px; margin:0 auto; text-align:left; line-height:30px;padding: 8px 0;">其他领导信息</h1>
							    	<p style="width:280px; padding:0 10px;  background: red; margin:0 auto; height:30px; background:#f5f5f5; line-height:30px"><span class="left">领导职务</span><span>人员姓名(多人)</span></p>
							        <table class="dynamicTable"  border="0" cellspacing="10" cellpadding="0" align="center" style="width:300px;">
							        	<c:forEach items="${leaderWindow.contentList}" var="content">
							        		<tr>
								                <td nowrap="nowrap" valign="middle" width="25%">
								                	<input value="${content.sunDuty }" onBlur="fnShowDef(this);" onfocus="fnShowBtn(this)" type="text" validate='type:"string",name:"${ctp:i18n('edoc.leader.window.name')}:",notNull:true,maxLength:50' class="validate w100b" name="contentInp" style="height:40px"/>
								                </td>
								                <td nowrap="nowrap" valign="middle" width="75%" style="position:relative">
								                	<textarea onBlur="fnShowDef(this);" onFocus="fnShowBtn(this)" class="validate w100b" name="contentarea" validate='type:"string",name:"${ctp:i18n('edoc.leader.window.duty')}",maxLength:120' style="height:40px">${content.sunContent}</textarea>
								                	<div style="position:absolute; top:0; right:-40px">
									                	<span class="curspan display_none">
									                		<span id='adddown' class='display_none ico16 gone_through_16'></span>
									                		<span id='del' class='ico16 revoked_process_16 display_none'></span>
									                	</span>
								                	</div>
								                </td>
								            </tr>
							        	</c:forEach>
							        </table>
							    </form>
							</div>
		    			</td>
		    		</tr>
		    	</table>
		    </div>
		 </div>
  </body>
</html>
