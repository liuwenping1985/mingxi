<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!-------- 公司新闻 ------>
<div class="s-n-l fl">
		<h1>
			<div id="moreNews" class="act n1 nn " ondblclick="openUrl('${path}/newsData.do?method=newsIndex&spaceType=&spaceId=&boardId=${newsCompanyId}')" >公司新闻</div>
			<div class="more">
				<a href="javascript:openUrl('${path}/newsData.do?method=newsIndex&spaceType=&spaceId=&boardId=${newsCompanyId}')" >更多 &gt;</a><!--企业新闻的更多-->
			</div>
			<div class="clear"></div>
		</h1>
		<div class="nt-content">
			<div class="nt n1t">
				<div class="nt-lb nt-lb-0 fl" id="_newsCompanyImgsList">
					<div class="nt-lb-img"><img src=""><p>暂无数据</p></div>
					<div class="nt-lb-img"><img src=""><p>暂无数据</p></div>
					<div class="nt-lb-img"><img src=""><p>暂无数据</p></div>
					<div class="nt-lb-img"><img src=""><p>暂无数据</p></div>
					<div class="nt-lb-img"><img src=""><p>暂无数据</p></div>
				</div>
				<ul class="nt-ul fr" id="_newsCompanyList">
				</ul>
			</div>
		</div>		
	</div>
<script type="text/javascript">
	//获取新闻栏目
	$(function() {
		newsAjaxData();
	});
	var newsDay = 3;
		function judgeDate(date){
			
			var date1=new Date(date.replace("-", "/").replace("-", "/"));  //开始时间
			var date2=new Date();    //结束时间
			var date3=date2.getTime()-date1.getTime();  //时间差的毫秒数
			//计算出相差天数
			var days=Math.floor(date3/(24*3600*1000));
			
			if(days<=newsDay){
				return true;
			}
			
			return false;
		}
	var typeId = "";
	function newsAjaxData(){
			if(typeId == ""){
					var url = "eipPortalAppController.do?method=getEipPortalAppLists&templateCode=${templateCode}&isEnable=0&columnCode=pl_news&portalCode="+encodeURI(encodeURI("${portalCode}"));
					var postdetil = ajaxController(url,false);
					if(postdetil){
						for(var i=0;i<postdetil.length;i++){
							typeId = postdetil[i].columnDetailId;
							break;
						}
					}
				}
			var url = "zyPortalController.do?method=getNewsPortalListType&typeId="+typeId;
	    	$.ajax({
	    		url:url,
	        	type:"POST",  
	        	dataType :'text', 
	    		success:function(result){
	    			result = $.parseJSON(result);
	    			var datas = result['newsCompanyImgsList'];
	    			var _news = $("#_newsCompanyImgsList");
	    			if(datas != null || datas != undefined){
		    			_news = _news.find("div").find(".owl-item");
		    			for(var em=0; em < _news.length; em++){
		    				var m = _news.eq(em);
		    				var x = em>=datas.length?em%datas.length:em;
		    				m.find("img").first().attr("src",datas[x].imgUrl);
		    				m.find("p").first().text(datas[x].title);
		    				m.find("img").first().attr("ondblclick","newsView('"+datas[x].id+"');");
		    				m.find("p").first().attr("ondblclick","newsView('"+datas[x].id+"');");
		    			}
	    			}
	    			
	    			datas = result['newsCompanyList'];
	    			if(datas != null || datas != undefined){
		    			_news = $("#_newsCompanyList");
		    			var html = "";
		    			for(var em=0; em < datas.length; em++){
		    				var title = datas[em].title.length>21?datas[em].title.substring(0,21)+"...":datas[em].title;
		    				if(datas[em].focusNews == "0"){
		    					var focusNews = "<strong style=\"color:red;\">[焦点]</strong>";
		    					html += "<li><a href=\"javascript:newsView('"+datas[em].id+"')\" title=\""+datas[em].title+"\">"+focusNews+title+"<span>"+datas[em].createDate+"</span></a></li>";
		    				}else{
		    					if(judgeDate(datas[em].createDate)){
		    						title += "<strong><img src=\"${path}/apps_res/v3xmain/images/section/new.gif\"></strong>";
		    					}
			    				html += "<li><a href=\"javascript:newsView('"+datas[em].id+"')\" title=\""+datas[em].title+"\">"+title+"<span>"+datas[em].createDate+"</span></a></li>";
		    				}
		    			}
		    			_news.empty();
		    			_news.append(html);
	    			}
	    			
	    			/*
	    			datas = result['newsSpeadImgsList'];
	    			if(datas != null || datas != undefined){
		    			_news = $("#_newsSpeadImgsList");
		    			_news = _news.find("div");
		    			for(var em=0; em < _news.length; em++){
		    				var m = _news.eq(em);
		    				var x = em>=datas.length?em%datas.length:em;
		    				m.find("img").first().attr("src",datas[x].imgUrl);
		    				m.find("p").first().text(datas[x].title);
		    				m.find("img").first().attr("ondblclick","newsView('"+datas[x].id+"');");
		    				m.find("p").first().attr("ondblclick","newsView('"+datas[x].id+"');");
		    			}
	    			}
	    			datas = result['newsSpeadList'];
	    			if(datas != null || datas != undefined){
		    			_news = $("#_newsSpeadList");
		    			var html = "";
		    			for(var em=0; em < datas.length; em++){
		    				var title = datas[em].title.length>24?datas[em].title.substring(0,24)+"...":datas[em].title;
		    				if(datas[em].focusNews == "0"){
		    					var focusNews = "<strong style=\"color:red;\">[焦点]</strong>";
		    					html += "<li><a href=\"javascript:newsView('"+datas[em].id+"')\" title=\""+datas[em].title+"\">"+focusNews+title+"<span>"+datas[em].createDate+"</span></a></li>";
		    				}else{
			    				html += "<li><a href=\"javascript:newsView('"+datas[em].id+"')\" title=\""+datas[em].title+"\">"+title+"<span>"+datas[em].createDate+"</span></a></li>";
		    				}
		    			}
		    			_news.empty();
		    			_news.append(html);
	    			}
	    			*/
	    			//定时任务
	    			setTimeout("newsAjaxData()", 60*1000 );
				}
	    	});
		}
		//打开详情页面，从首页、版块首页、换一换打开
		function newsView(newId) {//\"javascript:newsView(
			if(window.parent.$.ctx.CurrentUser.isAdmin){
				return;
			}
		    var url = _ctxPath + "/newsData.do?method=newsView&newsId=" + newId + "&from=&spaceId=";
		    openCtpWindow({
		        'window': window,
		        'url': url
		    });
		}
</script>