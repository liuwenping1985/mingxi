<div id="v5pagelayout" class="v5pagelayout v5pagelayout_body warp" >
	<style>
	.hidehide{

		display:none !important;
	}
	.no-margin-left{

		margin-left: 0px !important;
	}
	.no-top{
		top:0px !important;
	}
	
	</style>
    <div class="layout_header layout_header_area hidehide" style="display:none">
    	<div class="v5container area " id="v5headerarea">${pageRenderResult.bodyHtmlData.v5headerarea }</div>
    </div>
    <div class="layout_content no-top clearfix">
	<div id="v5nav" style="display:none" class=" hidehide v5container layout_left">${pageRenderResult.bodyHtmlData.v5nav }</div>
	<div class="layout_right">
	    <div class="layout_content_main">
		   <div id="content_layout_body_left_content" class="layout_content_main_warp">
			<div id="nowLocation" class="v5container layout_location">
			${pageRenderResult.bodyHtmlData.nowLocation }
			</div>
			<div id="v5body" class="v5container layout_content_main_content clearfix">
				<iframe src="" allowtransparency="true" id="main" name="main" frameborder="0"  onload="setonbeforeunload()" class="w100b h100b" style="position:absolute;"></iframe>
				<div class="noneDiv w100b h100b"></div>
			</div>
		   </div>
	    </div>
	</div>
    </div>
    <script>
    	function GetRequest() {  
   var url = location.search||(window.lcaotion+"");
   var theRequest = new Object();  
   if (url.indexOf("?") != -1) {  
      var str = url.substr(1);  
      strs = str.split("&");  
      for(var i = 0; i < strs.length; i ++) {  
         theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);  
      }  
   }  
   return theRequest;  
} 
function iframSrcLocator(url){

	$("#main").attr("src",url);
	//console.log($(".layout_content_main"));
	$(".layout_content_main").addClass("no-margin-left");
	
	


}
$(document).ready(function(){

	var param = GetRequest();
		if(param.openType=="menhu"){
			var l_type = param.type;
			if(l_type=="shouwenduban"){		//收文

				iframSrcLocator("/seeyon/supervise/supervise.do?method=listSupervise&app=4&_resourceCode=F07_edocSupervise");

			}else if(l_type=="xietongdaifa"){ //协同
				
				iframSrcLocator("/seeyon/collaboration/collaboration.do?method=listWaitSend&_resourceCode=F01_listWaitSend");

			}else if(l_type=="xietongdaiban"){
				
				iframSrcLocator("/seeyon/collaboration/collaboration.do?method=listPending&_resourceCode=F01_listPending");

			}else if(l_type=="xietongyifa"){
				
				iframSrcLocator("/seeyon/collaboration/collaboration.do?method=listSent&_resourceCode=F01_listSent");

			}else if(l_type=="xietongyiban"){
				
				iframSrcLocator("/seeyon/collaboration/collaboration.do?method=listDone&_resourceCode=F01_listDone");

			}else if(l_type=="xietongduban"){
				
				iframSrcLocator("/seeyon/supervise/supervise.do?method=listSupervise&app=1&_resourceCode=F01_supervise");

			}else if(l_type=="fawen"){//公文
				
				iframSrcLocator("/seeyon/edocController.do?method=entryManager&entry=sendManager&_resourceCode=F07_sendManager");

			}else if(l_type=="shouwen"){
				
				iframSrcLocator("/seeyon/edocController.do?method=entryManager&entry=recManager&_resourceCode=F07_recManager");

			}else if(l_type=="qianbao"){
				
				iframSrcLocator("/seeyon/edocController.do?method=entryManager&entry=signReport&_resourceCode=F07_signReport");

			}else if(l_type=="gongwenchaxun"){
				
				iframSrcLocator("/seeyon/edocController.do?method=edocSearchMain&_resourceCode=F07_edocSearch");

			}else if(l_type=="gongwentongji"){
				
				iframSrcLocator("/seeyon/edocStat.do?method=mainEntry&_resourceCode=F07_edocStat");

			}else if(l_type=="gongwenduban"){
				
				iframSrcLocator("/seeyon/supervise/supervise.do?method=listSupervise&app=4&_resourceCode=F07_edocSupervise");

			}else if(l_type=="gongwenjiaohuan"){
				
				iframSrcLocator("/seeyon/exchangeEdoc.do?method=listMainEntry&_resourceCode=F07_edocExchange");

			}else if(l_type=="huiyianpai"){//会议
				
				iframSrcLocator("/seeyon/meetingNavigation.do?method=entryManager&entry=meetingArrange&_resourceCode=F09_meetingArrange");

			}else if(l_type=="daikaihuiyi"){
				
				iframSrcLocator("/seeyon/meetingNavigation.do?method=entryManager&entry=meetingPending&_resourceCode=F09_meetingPending");

			}else if(l_type=="yikaihuiyi"){
				
				iframSrcLocator("/seeyon/meetingNavigation.do?method=entryManager&entry=meetingDone&_resourceCode=F09_meetingDone");

			}else if(l_type=="huiyiziyuan"){
				
				iframSrcLocator("/seeyon/meetingroom.do?method=index&_resourceCode=F09_meetingRoom");

			}else if(l_type=="gerenzhongxin"){//个人中心
				
				iframSrcLocator("/seeyon/personal/670869647114347_D.psml?uu=15455117540377&isOpenDesigner=0");

			} else if(l_type=="wodemoban"){
				iframSrcLocator("/seeyon/template/template.do?method=moreTreeTemplate&fragmentId=8815840473741608701&ordinal=0&columnsName=我的模板&recent=20");
				///seeyon/template/template.do?method=moreTreeTemplate&fragmentId=8815840473741608701&ordinal=0&columnsName=我的模板&recent=20
			} else if(l_type=="wodeshoucang"){
				
				iframSrcLocator("/seeyon/doc.do?method=myCollection");
				///seeyon/template/template.do?method=moreTreeTemplate&fragmentId=8815840473741608701&ordinal=0&columnsName=我的模板&recent=20
			}else if(l_type=="bgs"){

				iframSrcLocator("/seeyon/custom/3757630520085269961.psml?uu=15456355063762&isOpenDesigner=0");
			}else if(l_type=="dwbgs"){
				iframSrcLocator("/seeyon/custom/-5816809937017813020.psml?uu=15456358308062&isOpenDesigner=0");
					///seeyon/custom/-5816809937017813020.psml?uu=15456358308062&isOpenDesigner=0
			}else if(l_type=="rsc"){
				iframSrcLocator("/seeyon/custom/-5816809937017813020.psml?uu=15456358308062&isOpenDesigner=0");
					///seeyon/custom/-5816809937017813020.psml?uu=15456358308062&isOpenDesigner=0
			} else if(l_type=="dwbgs"){
				iframSrcLocator("/seeyon/custom/-5816809937017813020.psml?uu=15456358308062&isOpenDesigner=0");
					
			} else if(l_type=="xqgs"){
				//7899743386227327998
				//7719514294657173978
				iframSrcLocator("/seeyon/doc.do?method=docIndex&openLibType=1&_resourceCode=F04_docIndex&docResId=3563212477215886478");
				
			} else if(l_type=="tongbao"){
				iframSrcLocator("/seeyon/doc.do?method=docHomepageIndex&docResId=2101297384881669972");

			} else if(l_type=="zhuanbao"){
			
				iframSrcLocator("/seeyon/doc.do?method=docHomepageIndex&docResId=4787332904735427042");
				
			} else if(l_type=="jianbao"){
				iframSrcLocator("/seeyon/doc.do?method=docHomepageIndex&docResId=4550956951978068889");
				
			}  else if(l_type=="yianweijian"){
				iframSrcLocator("/seeyon/doc.do?method=docHomepageIndex&docResId=8806195959775645147");
				
			} else if(l_type=="sanhuiyike"){
				iframSrcLocator("/seeyon/doc.do?method=docHomepageIndex&docResId=3156008936522925665");
				
			} else if(l_type=="shijiuda"){
				iframSrcLocator("/seeyon/doc.do?method=docHomepageIndex&docResId=7971248901287657867");
				
			} else if(l_type=="shibada"){
				iframSrcLocator("/seeyon/doc.do?method=docHomepageIndex&docResId=2862958949873369273");
				
			} else if(l_type=="liangxueyizuo"){
				iframSrcLocator("/seeyon/doc.do?method=docHomepageIndex&docResId=6106334362364887336");
				
			} else if(l_type=="sanyansanshi"){
				iframSrcLocator("/seeyon/doc.do?method=docHomepageIndex&docResId=2578138809961434052");
				
			} else if(l_type=="guangrongbang"){
				iframSrcLocator("/seeyon/doc.do?method=moreDocPictures&fragmentId=-8421287753516824743&ordinal=0&folderId=820644300868634954");
	//待办			
			} else if(l_type=="xietongdaiban"){
				iframSrcLocator("/seeyon/collaboration/pending.do?method=morePending&fragmentId=-6236628819606156523&ordinal=0&currentPanel=sources&rowStr=subject,receiveTime,sendUser,category&columnsName=%E5%BE%85%E5%8A%9E%E5%8D%8F%E5%90%8C");
				
			}else if(l_type=="gongwendaiban"){
				iframSrcLocator("/seeyon/collaboration/pending.do?method=morePending&fragmentId=-5933524193568079336&ordinal=0&currentPanel=sources&rowStr=subject,receiveTime,edocMark,sendUser,category&columnsName=%E5%BE%85%E5%8A%9E%E5%85%AC%E6%96%87");
				
			}else if(l_type=="huiyidaiban"){
				iframSrcLocator("/seeyon/collaboration/pending.do?method=morePending&fragmentId=7743074186106916011&ordinal=0&currentPanel=sources&rowStr=subject,receiveTime,sendUser,placeOfMeeting,theConferenceHost,processingProgress,category&columnsName=%E5%BE%85%E5%8A%9E%E4%BC%9A%E8%AE%AE");
				
			}else if(l_type=="renwudaiban"){
				iframSrcLocator("");
	//已发			
			}else if(l_type=="xietongyifa"){
				iframSrcLocator("/seeyon/portalAffair/portalAffairController.do?method=moreSent&fragmentId=-6236628819606156523&ordinal=2&rowStr=subject,publishDate,currentNodesInfo,category&columnsName=%E5%B7%B2%E5%8F%91%E4%BA%8B%E9%A1%B9");
				
			}else if(l_type=="gongwenyifa"){
				iframSrcLocator("/seeyon/portalAffair/portalAffairController.do?method=moreSent&fragmentId=-5933524193568079336&ordinal=2&rowStr=subject,publishDate,edocMark,currentNodesInfo,category&columnsName=%E5%B7%B2%E5%8F%91%E5%85%AC%E6%96%87");
				
			}else if(l_type=="huiyiyifa"){
				iframSrcLocator("/seeyon/meetingNavigation.do?method=entryManager&entry=meetingArrange&_resourceCode=F09_meetingArrange");
				
			}else if(l_type=="renwuyifa"){
				iframSrcLocator("");
	//已办			
			}else if(l_type=="xietongyiban"){
				iframSrcLocator("/seeyon/portalAffair/portalAffairController.do?method=moreDone&fragmentId=-6236628819606156523&ordinal=1&rowStr=subject,createDate,receiveTime,currentNodesInfo,sendUser,deadline,category&columnsName=%E5%B7%B2%E5%8A%9E%E4%BA%8B%E9%A1%B9&isGroupBy=true");
				
			}else if(l_type=="gongwenyiban"){
				iframSrcLocator("/seeyon/portalAffair/portalAffairController.do?method=moreDone&fragmentId=-5933524193568079336&ordinal=1&rowStr=subject,createDate,receiveTime,edocMark,sendUser,deadline,category&columnsName=%E5%B7%B2%E5%8A%9E%E5%85%AC%E6%96%87&isGroupBy=true");
				
			}else if(l_type=="huiyiyiban"){
				iframSrcLocator("/seeyon/meeting.do?method=moreMeeting&fragmentId=7743074186106916011&ordinal=1&rowStr=subject,receiveTime,sendUser,placeOfMeeting,theConferenceHost,category&meeting_category=meeting");
				
			}else if(l_type=="renwuyiban"){
				iframSrcLocator("");
//超期				
			}else if(l_type=="xietongchaoqi"){
				iframSrcLocator("");
				
			}else if(l_type=="gongwenchaoqi"){
				iframSrcLocator("");
				
			}else if(l_type=="huiyichaoqi"){
				iframSrcLocator("");
				
			}else if(l_type=="renwuchaoqi"){
				iframSrcLocator("");
				
			}else if(l_type=="daifaxietong"){
				iframSrcLocator("/seeyon/collaboration/collaboration.do?method=listWaitSend&_resourceCode=F01_listWaitSend");
				
			}else if(l_type=="yifaxietong"){
				iframSrcLocator("/seeyon/collaboration/collaboration.do?method=listSent&_resourceCode=F01_listSent");
				
			}else if(l_type=="daibanxietong"){
				iframSrcLocator("/seeyon/collaboration/collaboration.do?method=listPending&_resourceCode=F01_listPending");
				
			}else if(l_type=="yibanxietong"){
				iframSrcLocator("/seeyon/collaboration/collaboration.do?method=listDone&_resourceCode=F01_listDone");
				
			}else if(l_type=="dubanxietong"){
				iframSrcLocator("/seeyon/supervise/supervise.do?method=listSupervise&app=1&_resourceCode=F01_supervise");
				
			}else if(l_type=="gongwenduban"){
				iframSrcLocator("/seeyon/supervise/supervise.do?method=listSupervise&app=4&_resourceCode=F07_edocSupervise");
				
			}else if(l_type==""){
				iframSrcLocator("");
				
			}else if(l_type==""){
				iframSrcLocator("");
				
			}else if(l_type==""){
				iframSrcLocator("");
				
			}else if(l_type==""){
				iframSrcLocator("");
				
			}else if(l_type==""){
				iframSrcLocator("");
				
			}else{
				$(".hidehide").removeClass("hidehide");
				$(".no-margin-left").removeClass("no-margin-left");
				$(".no-top").removeClass("no-top");
			}
			

		}else{

				$(".hidehide").removeClass("hidehide");
				$(".no-margin-left").removeClass("no-margin-left");
				$(".no-top").removeClass("no-top");

		}


});
	
	</script>
</div>