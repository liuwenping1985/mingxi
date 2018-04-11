<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/doc/js/docFavorite.js${ctp:resSuffix()}"></script>
<title>期刊发布页面</title>
<script type="text/javascript">
	var officecanSaveLocal = 'false'//不能保存文档
	var officecanPrint = 'false';
	var _publishRange = "";
	var _publishUserName = "";
	var _publishAccount = "";
	var _publishDept = "";
	var _publishTime = "";
	var  magazineId="${id}";
    var _needToTaohong = "${needToTaohong}";

	function mainbody_callBack_failed() {

	}

	/** 初始化office期刊内部事件 */
	function initOfficeCallBackEvent() {
		if(typeof(officeEditorFrame)!='undefined' && officeEditorFrame != null && officeEditorFrame.openFileCallBack && officeEditorFrame.doLoadFile){
			doAddPublishRange();
		}else {
			setTimeout(initOfficeCallBackEvent, "500");
		}
	}

	/**
	 * 如果是期刊审核，设定审核页面加载完成后，意见框聚焦
	 */
	function doAddPublishRange() {
		if (window.officeEditorFrame != undefined && officeEditorFrame != null && officeEditorFrame.setLable) {
			if (officeEditorFrame.page_OcxState == "complete") {//Office文件加载完成
				officeEditorFrame.setLable("publish_range", _publishRange);//发布范围套红
				officeEditorFrame.setLable("publish_user", _publishUserName);//期刊发布人套红

				officeEditorFrame.setLable("publish_account", _publishAccount);//发布单位套红
                officeEditorFrame.setLable("publish_dept", _publishDept);//发布部门套红
                officeEditorFrame.setLable("publish_time", _publishTime);//发布时间套红
				$.content.getContentDomains(function() {
					var jsonSubmitCallBack = function() {
						setTimeout(function() {
							window.setTimeout(function(){window.parent.saveNextMagazineRange();},0)//发布下一个期刊
						}, 300);
					}
					jsonSubmitCallBack();
				}, 'saveAs', null, mainbody_callBack_failed);//修改成 saveAs 避免弹出无流程id相关提示dialog
			} else {
				setTimeout(doAddPublishRange, "500");
			}
		} else {

		}
	}

	$(function() {

		if("true" == _needToTaohong){
			_publishRange = window.parent.tempMagazinePublishRanges;
	        _publishUserName = window.parent.tempMagazinePublishUserName;
	        _publishAccount = window.parent.tempMagazinePublishAccount;
	        _publishDept = window.parent.tempMagazinePublishDept;
	        _publishTime = window.parent.tempMagazinePublishTime;
	        initOfficeCallBackEvent();
		}else{
			window.setTimeout(function(){window.parent.saveNextMagazineRange();},0)//直接发布下一个期刊
		}
	});
</script>
</head>
<body>
  <c:if test="${needToTaohong=='true'}">
        <jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
  </c:if>
</body>
</html>