<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<title>秀栏目</title>
	<style type="text/css">
	    body{background: none;}
		.list_show{list-style: none;display: block;width: 200px;height: 190px;margin-top: 10px;float: left; }
		.list_show a img {width:200px;height: 140px;}
		.list_show .title{line-height:20px;height:20px;font-size: 12px; text-overflow: ellipsis; overflow: hidden;white-space: nowrap;color: rgb(166, 166, 166);display: inline-block;}
		.list_show .title img{height: 18PX;width: 16PX;vertical-align: middle;}
		.list_show .short_title{width: 120px;}
		.list_show .long_title{width: 200px;}
		.list_show .date_span{height:20px;width: 70px;font-size: 12px; text-overflow: ellipsis; overflow: hidden;white-space: nowrap;color: rgb(166, 166, 166);float: right;}
		 .hits_gray,.estimate_gray,.liked_gray{color: #a6a6a6;line-height: 20px; height: 20px;display: inline-block; vertical-align: top;font-size: 12px; }   
		 .hits_gray{margin-left: 0px;}
		 
		 .nodata_div{margin: 5px auto 0px;width: 178px;text-align: center;display: none;}
		 .nodata_div img{height: 175px;}
		 
		 .noimg{width: 200px;height: 140px;text-align: center;}
		 .noimg span {text-align: center;font-size: 12px;color:rgb(166, 166, 166);}
		 .ico16{cursor: default;}
		 
		 .ShowsSection:hover,.list_show:hover{box-shadow: 1px 1px 1px rgba(0,0,0,.15);}
		 /*秀照片栏目特殊处理*/
		.ShowsSection{height: 190px;width:280px;}
		.ShowsSection a img {width:280px;height: 190px;}
	</style>
</head>
<body>
	<script type="text/javascript">
		$(function(){
			var window_width  = 0;
			if (window.innerWidth)
				window_width = window.innerWidth;
			else if ((document.documentElement) && (document.documentElement.clientWidth))
				window_width = document.documentElement.clientWidth;
			var sectionType = "${sectionType}"
			var width = "${width}"
			var columnsCount = "${columnsCount}"//显示的行数
			var dataFrom = "${dataFrom}"//數據來源
			var displayCol = "${displayCol}"//數據來源
			var _showManager = new showManager();
			var data_size  = 1;
			var marginLeft  = 0;
			if(sectionType != "ShowsSection"){
				if(window_width > 200 + 0){
					data_size = parseInt(window_width/(200 + 3)) * columnsCount;//可以显示的数据
					marginLeft = (window_width - 200 * parseInt(window_width/(200 + 3)))/(data_size / columnsCount)
				}else{
					data_size = columnsCount;
					$("ul").css("width","200px");
				}
			}else{
				if(window_width > 280 + 0){
					data_size = parseInt(window_width/(280 + 8)) * columnsCount;//可以显示的数据
					marginLeft = (window_width - 280 * parseInt(window_width/(280 + 8)))/(data_size / columnsCount)
				}else{
					data_size = columnsCount;
					$("ul").css("width","280px");
				}
			}
			
			var escape = {
				    "&": "&amp;",
				    "<": "&lt;",
				    ">": "&gt;",
				    '"': "&quot;",
				    "'": "&#x27;",
				    "`": "&#x60;"
			};
			var possible = /[&<>"'`]/;
			var badChars = /[&<>"'`]/g;
			 var escapeChar = function(chr) {
				    return escape[chr] || "&amp;";
			 };
			 
			
			//计数每一行显示的数据条数
			var datas = _showManager.findShowsectionDatasByType(sectionType,data_size,dataFrom);
			var html = ''
			if(datas.length > 0 ){
				for(var i = 0 ; i < datas.length ; i++ ){
					var showbar = datas[i];
					var per_size = data_size / columnsCount;
					
					//===================计算显示图片左右margin值
					if(i % per_size == 0){
						//第一个
						html += '<li class="list_show ${sectionType}" style="margin-left:' + Math.floor(marginLeft/2) + 'px;margin-right:' + Math.floor(marginLeft) + 'px">';
					}else if( (i + 1) % per_size == 0){
						//最后一个
						html += '<li class="list_show ${sectionType}" style="margin-right:0px">';
					}else{
						//其他
						html += '<li class="list_show ${sectionType}" style="margin-right:' + Math.floor(marginLeft) + 'px">';
					}
					
					
					//=====================图片区域开始
					//&showpostId=5813874894894088966&from=imageViewer
					if(sectionType == "ShowsSection"){
						html += ' <a href="' + _ctxPath + "/show/show.do?method=showbar&showbarId=" +showbar.showbarId + '&showpostId=' + showbar.id + '&from=imageViewer" target="_blank">';
					}else{
						html += ' <a href="' + _ctxPath + "/show/show.do?method=showbar&showbarId=" +showbar.showbarId + '" target="_blank">';
					}
					
					//显示图片
					if(typeof showbar.imageId  != "undefined"){
						if(sectionType == "ShowsSection"){
							html += '<img src="' + _ctxPath + '/image.do?method=showImage&id=' + showbar.imageId + '&size=custom&w=400&h=288&handler=show" width="280" height="190" />';
						}else{
							html += '<img src="' + _ctxPath + '/image.do?method=showImage&id=' + showbar.imageId + '&size=custom&w=400&h=288&handler=show" width="200" height="140" />';
						}
					}else{
						html += '<div class="noimg"><img id="404_img" src="${path }/apps_res/show/images/common/404.png" style="width:120px;height: 120px;" /><br/>';
						html += '<span>' + $.i18n("show.label.noPicture") + '</span></div>';
					}
					html += '</a>';
					
					
					//========================下边内容区域开始
					if(sectionType != "ShowsSection"){
						//不是秀秀栏目， 需要显示点赞、评论、秀照片数、显示时间、主题的标题
						html += ' <div>';
						html += ' 	<div class="content">';
						if(displayCol.indexOf("1") ==  -1){//是否显示时间
							html += ' 		<span class="title long_title"  title="' + showbar.showbarName.replace(badChars, escapeChar) + '">' + escapeStringToHTML(showbar.showbarName,true) + '</span>';
						}else{
							html += ' 		<span class="title short_title"  title="' + showbar.showbarName.replace(badChars, escapeChar) + '">' + escapeStringToHTML(showbar.showbarName,true) + '</span>';
							html += ' 		<span class="date_span" title="' + $.i18n("show.section.displayCol.createTime")+ '">' + showbar.createTime + '</span>';
						}
						html += ' 	</div>';
						html += '	<span title="'+ $.i18n("show.section.displayCol.viewtimes") +'" class="hits_gray"><span class="ico16 show_clickNumberGray"></span> ' + showbar.viewNum + '</span>&ensp;';
						html += '	<span title="'+ $.i18n("show.section.displayCol.commenttimes") +'" class="estimate_gray"><span class="ico16 show_replyNumberGray"></span> ' + showbar.commentNum + '</span>&ensp;';
						html += '	<span title="'+ $.i18n("show.section.displayCol.liketimes") +'" class="liked_gray"><span class="ico16 show_likeGray"></span> ' + showbar.likeNum + '</span>';
						html += ' </div>';
					}
					html += '</li>';
				}
				$("#show_list_ul").html(html).show();
			}else{
				$(".nodata_div").show();
			}
		});
	</script>
	<ul id="show_list_ul" style="display: none;"></ul>
	<div class="nodata_div hide">
		<img alt="" src="${path }/apps_res/show/images/common/404.png"><br>
		<span>${ctp:i18n("show.section.nodata") }</span>
	</div>
</body>
</html>