<%--
 $Author: yangwl $
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html style="height:100%;">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>附件列表</title>
        <style>
            .stadic_head_height{
                height:30px;
            }
            .stadic_body_top_bottom{
                top: 30px;
                bottom: 20px;
                height:105px;
            }
            .stadic_footer_height{
            	top:140px;
                height:20px;
            }
            #wholeSelect{
                margin:0 3px 2px 3px;
            }
        </style>
        
        <script type="text/javascript">
            $(function(){
                var attachmentListObj = parent.$("#attachmentList");
                if ($("body").height() > 180 ){
                    //attachmentListObj.height(180);
                } else {
                    //attachmentListObj.height($("body").height());
                }
				//增加全选按钮的事件
				setAllSelect();
				//批量下载按钮点击事件
				batchDownloadFun();
				//设置样式
				_setStyle();
				//初始化图片
				initImgShow();
            });

            var attSize = '${attSize}';

			function _setStyle(){
				if(attSize == 1){
					$(".stadic_body_top_bottom").css("height","50");
					$(".stadic_footer_height").css("top","80px");
					$(parent.document.getElementById("attachmentList")).css("height","120");
				}else if(attSize == 2){
					$(".stadic_body_top_bottom").css("height","70");
					$(".stadic_footer_height").css("top","100px");
					$(parent.document.getElementById("attachmentList")).css("height","140");
				}else if(attSize == 3){
					$(".stadic_body_top_bottom").css("height","90");
					$(".stadic_footer_height").css("top","120px");
					$(parent.document.getElementById("attachmentList")).css("height","160");
				}else if(attSize >= 4){
					$(".stadic_body_top_bottom").css("height","110");
					$(".stadic_footer_height").css("top","140px");
					//$(parent.document.getElementById("attachmentList")).css("height","180");
				}else{
					$(".stadic_body_top_bottom").css("height","25");
					$(".stadic_footer_height").css("top","60px");
					$(parent.document.getElementById("attachmentList")).css("height","100");
				}
			}
            
            function batchDownloadFun(){
            	$("#batchDownload").bind("click",function(){
					if($(".eachSelect:checked").size() == 0){
						//$.alert("至少选择一项数据，当前已选择0项");
						$.alert("${ctp:i18n('collaboration.summary.label.batchdown')}");
						return;
					}else{
						parent.doloadFileFun($.ctx.CurrentUser.id,$(".eachSelect:checked"));
					}
                });
                //其他浏览器屏蔽
                if(!$.browser.msie){
                	$("#batchDownload").hide();   
                }
            }

            function setAllSelect(){
            	$("#wholeSelect").bind("click",function(){
            		if($("#wholeSelect")[0].checked){
            			//alert($(".eachSelect").size());
            			$(".eachSelect").each(function(){
							this.checked = true;
                		});
					}else{
						$(".eachSelect").each(function(){
							this.checked = false;
                		});
					}
            	});
            }
            //查看附件列表
            function showOrCloseAttachmentList(isShow){
                var attachmentListObj = parent.$("#attachmentList");
                attachmentListObj.hide();
                showOfficeObj();
                attachmentListObj.attr("src","");
                
            }

            //查看走office转换格式的附件
            function findAttachment(fileId,createDate,fileName,fileType){
                var url=_ctxPath + "/officeTrans.do?method=view&fileId="+fileId+"&createDate="+createDate+"&filename="+encodeURIat(fileName);
                if($.trim(fileType)!==""){
                    url+="."+fileType;
                }
                $("#"+fileId).attr("href",url);
            }
           //查看附件pdf格式
			function findAttachmentPdf(fileId,createDate,fileName,fileType){
				var url=_ctxPath + "/fileUpload.do?method=doDownload4Office&type=Pdf&isOpenFile=true&fileId="+fileId+"&createDate="+createDate+"&filename="+encodeURIat(fileName);
                if($.trim(fileType)!==""){
                    url+="."+fileType;
                }
                preViewDialog(url);
            } 
            //查看附件图片格式
            function initImgShow(){
              var attaArray = new Array();
              var $show = $(".attaListImg");
              $show.each(function() {
                  var map = {};
                  var t = $(this);
                  var t_id = t.attr("showId");
                  var t_date = t.attr("showDate");
                  var t_name = t.attr("showName");
                  var t_type = t.attr("showType");
  
                  map["dataId"] = t_id;
                  var _src = _ctxPath + "/fileUpload.do?method=showRTE&type=image&fileId=" + t_id + "&createdate=" + t_date + "&filename=" + encodeURIComponent(t_name);
                  if($.trim(t_type)!==""){
                    _src += "." + t_type;
                  }
                  map["src"] = _src
                  attaArray.push(map);
              });
              
              if(attaArray.length>0){
                  var dataTimestamp = new Date().getTime();
                  //加时间戳，避免ID重复  OA-101976
                  var id = "showImg" + dataTimestamp;
                  $show.touch({
                      id: id,//查看器ID，唯一
                      datas: attaArray,  //图片数据
                      targetWindow: getCtpTop(),
                      onClick: {
                          pre:function(){},
                          after:function(){}
                      }
                  });
              }          
            }
    
        </script>
    </head>
    <body  class="h100b over_hidden" style='background-color:#EDEDED;'>
        <div  class="stadic_layout" style="padding:0px 20px; ">
        	 <div class="stadic_layout_head stadic_head_height" style="background:#EDEDED;">
        	 	<table class="popupTitleRight bg_color_white font_size12" width="100%" border="0" bordercolor="#dadada"
                style="border-collapse: collapse;">
        	 		<tr style="height: 25px;color:#666;background:#EDEDED;">
	        	 		<td class="padding_l_5" style="border: 0;" colspan="2">
                    		<span style="font-weight:bold">${ctp:i18n('collaboration.summary.findAllColAttachment.ty')}</span>
	                    </td>
	                    <td colspan="6" style="padding-right: 5px;border: 0;" align="right">
	                        <span class="ico16 close_16 cursor-hand" onclick="showOrCloseAttachmentList(false);"></span>
	                    </td>
                    </tr>
        	 	</table>
        	 </div>
			<div class="stadic_layout_body stadic_body_top_bottom" style="overflow-x:hidden;position:static;">
            <table id="attachTable" class="popupTitleRight bg_color_white font_size12" width="100%" 
                style="border-collapse: collapse;border:1px solid #dddddd;">
                <%--tr style="height: 25px;background-color:#EDEDED">
                    <!-- 查看协同所有附件 -->
                    <td class="padding_l_5" style="border: 0;" colspan="2">
                        <span style="font-weight:bold">${ctp:i18n('collaboration.summary.findAllColAttachment')}</span>
                    </td>
                    <td colspan="6" style="padding-right: 5px;border: 0;" align="right">
                        <span class="ico16 close_16 cursor-hand" onclick="showOrCloseAttachmentList(false);"></span>
                    </td>
                </tr --%>
                <c:choose>
                    <c:when test="${attachmentVOs eq '[]' }">
                        <tr style="height: 22px;" class="align_center">
                            <td colspan="6" class="center">${ctp:i18n("collaboration.sumary.attachmentList.noatt")}</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr style="height: 22px;border: 0;" class="align_center padding_l_5">
                            <!-- 名称  大小  创建人   来源  上传时间  操作-->
                            <td class='w5b' style="background:#f9f8f8;border:1px solid #dddddd;"><input id='wholeSelect' type="checkbox" /></td>
                            <td class="align_left w30b padding_l_5" style="background:#f9f8f8;border:1px solid #dddddd;">${ctp:i18n("collaboration.eventsource.category.name")}</td>
                            <td class="w10b" style="background:#f9f8f8;border:1px solid #dddddd;">${ctp:i18n("collaboration.summary.size")}</td>
                            <td class="w10b" style="background:#f9f8f8;border:1px solid #dddddd;">${ctp:i18n("collaboration.summary.createdBy")}</td>
                            <td style="background:#f9f8f8;border:1px solid #dddddd;">${ctp:i18n("collaboration.summary.source")}</td>
                            <td style="background:#f9f8f8;border:1px solid #dddddd;">${ctp:i18n("collaboration.summary.uploadTime")}</td>
                            <!-- 查看  收藏  如果都没权限，不显示此栏-->
                            <c:if test="${canLook || (!isHistoryFlag && param.canFavorite)}">
	                            <td style="background:#f9f8f8;border:1px solid #dddddd;" class="w20b">${ctp:i18n("collaboration.summary.operating")}</td>
                            </c:if>
                        </tr>
                        <c:forEach var="attachmentVO" items="${attachmentVOs}" varStatus="index">
                            <tr style="height: 22px;" class="align_center">
                                <!-- 点击下载   -->
                                <td style="border:1px solid #dddddd;"><input class='eachSelect' value="${attachmentVO.fileUrl}" 
                                	frName="${ctp:toHTMLWithoutSpace(ctp:escapeJavascript(attachmentVO.fileFullName))}" 
                                	frVStr="${attachmentVO.v}"
                                	frType="${attachmentVO.fileType}" type="checkbox" /></td>
                                <td style="border:1px solid #dddddd;" nowrap class="align_left w30b hand" title="${ctp:toHTMLWithoutSpace(ctp:escapeJavascript(attachmentVO.fileFullName))}"
                                    style="padding-left: 1px;"
                                    onclick="parent.downloadAttrList('${attachmentVO.fileUrl}','${ctp:formatDateByPattern(attachmentVO.uploadTime, 'yyyy-MM-dd')}','${ctp:toHTML(ctp:escapeJavascript(attachmentVO.fileFullName))}','${attachmentVO.fileType}','${attachmentVO.v}')"><span
                                    class="ico16 <c:if test='${(attachmentVO.fileType == "xsn") || (attachmentVO.fileType == "vsd") || (attachmentVO.fileType == "sql") || (attachmentVO.fileType == "bat")}'>file_16</c:if><c:if test='${(attachmentVO.fileType ne "xsn") && (attachmentVO.fileType ne "vsd") && (attachmentVO.fileType ne "bat") && (attachmentVO.fileType ne "sql")}'>${attachmentVO.fileType}_16</c:if>"> </span>${ctp:toHTMLWithoutSpace(attachmentVO.fileName)}.${attachmentVO.fileType}</td>
                                <td style="border:1px solid #dddddd;" class="w10b">${attachmentVO.fileSize}K</td>
                                <td style="border:1px solid #dddddd;" class="w10b">${attachmentVO.userName}</td>
                                <td style="border:1px solid #dddddd;">${attachmentVO.fromType}</td>
                                <td style="border:1px solid #dddddd;">${ctp:formatDateByPattern(attachmentVO.uploadTime, 'yyyy-MM-dd HH:mm')}</td>
                                <!-- 查看  收藏  如果都没权限，不显示此栏-->
                                <c:set value='${attachmentVO.fileType == "pdf"}' var="isPdf"></c:set>
                                <c:set value='${(attachmentVO.fileType == "jpg") || (attachmentVO.fileType == "gif") || (attachmentVO.fileType == "jpeg") || (attachmentVO.fileType == "png") || (attachmentVO.fileType == "bmp")}' var="isPic"></c:set>
                                <c:if test="${attachmentVO.canLook || (!isHistoryFlag && param.canFavorite) || isPdf || isPic}">
	                                <td style="border:1px solid #dddddd;" class="w20b">
	                                <c:choose>
									    <c:when test="${attachmentVO.canLook}">
											<a id="${attachmentVO.fileUrl}" target="downloadFileFrame" onclick='findAttachment("${attachmentVO.fileUrl}","${ctp:formatDateByPattern(attachmentVO.uploadTime, 'yyyy-MM-dd')}","${ctp:toHTML(ctp:escapeJavascript(attachmentVO.fileName))}","${attachmentVO.fileType}")'>${ctp:i18n('collaboration.summary.find')}</a>
										</c:when>
										<c:when test="${isPdf}">
											<a id="${attachmentVO.fileUrl}" target="downloadFileFrame" onclick='findAttachmentPdf("${attachmentVO.fileUrl}","${ctp:formatDateByPattern(attachmentVO.uploadTime, 'yyyy-MM-dd')}","${ctp:toHTML(ctp:escapeJavascript(attachmentVO.fileName))}","${attachmentVO.fileType}")'>${ctp:i18n('collaboration.summary.find')}</a>
										</c:when>
										<c:when test="${isPic}">
											<a id="show${attachmentVO.fileUrl}" class="attaListImg" showId="${attachmentVO.fileUrl}"
											   showDate="${ctp:formatDateByPattern(attachmentVO.uploadTime, 'yyyy-MM-dd')}"
											   showName="${ctp:toHTML(attachmentVO.fileFullName)}"
											   showType="${attachmentVO.fileType}">${ctp:i18n('collaboration.summary.find')}</a>	
										</c:when>
								    </c:choose>
	                                <c:if test="${!isHistoryFlag && param.canFavorite}">
	                                    <span id="favoriteSpan${attachmentVO.fileUrl}" class="${attachmentVO.collect?'display_none':'' }"><a onclick="favorite(1,'${attachmentVO.fileUrl}',false,4)">${ctp:i18n('collaboration.summary.favorite')}</a></span>
	                                    <span id="cancelFavorite${attachmentVO.fileUrl}" class="${!attachmentVO.collect?'display_none':'' }"><a onclick="cancelFavorite(1,'${attachmentVO.fileUrl}',false,4)">${ctp:i18n('collaboration.summary.favorite.cancel')}</a></span>
	                                </c:if>
	                                </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
            </div>
            <c:if test="${CurrentUser.externalType == 0}">
	            <div class="stadic_layout_footer stadic_footer_height" style="position:static;">
	            	<a id="batchDownload"  class="common_button common_button_gray right" style="margin-top:5px;margin-right:1px;background:#6eb0fc;border:1px solid #6eb0fc;">${ctp:i18n('collaboration.summary.attachment.batchDown')}</a>
	            </div>
            </c:if>
            <%-- 阻挡签章字段--%>
            <iframe id="zdiframe" class="hidden bg_color_white" src="about:blank" frameborder="0" scrolling="no"></iframe>
        </div>
    </body>
</html>
