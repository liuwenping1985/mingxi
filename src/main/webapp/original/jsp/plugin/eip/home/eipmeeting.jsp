<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!-------- 会议通知 ------>
<div class="s-n-r sm-til fr" style="height: 384px">
		<h1>会议专题<a class="more" href="javascript:openUrl('/seeyon/meetingList.do?method=listPendingMeeting&listType=listPendingMeeting')"  >更多 &gt;</a></h1>
		<div class="snr-gg-tab">
			<ul>
				<li class="act">会议通知</li>
				<li >已开会议</li>
			</ul>
		</div>
		<div class="snr-gg-content">
			<ul class="snr-gg snr-zt zt1" id="meetingPortalList">
				<!-- <a href="#" class="more">更多 &gt;</a> -->
			</ul>
			<ul class="snr-gg snr-zt zt2" id="doneMeeting">
				<!-- <a href="#" class="more">更多 &gt;</a> -->
			</ul>
		</div>
		
	</div>
<script type="text/javascript">
		
Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
meetingAjaxData();
		var nummeets = 8;//会议展示个数
		function meetingAjaxData(){
				var url = "zyPortalController.do?method=listPendingMeeting&num=8";
		    	$.ajax({
		    		url:url,
		        	type:"GET",  
		        	dataType :'text', 
		    		success:function(result){
		    			var json = $.parseJSON(result);
		    			var _buls = $("#meetingPortalList");
		    			var html = "";
		    			
		    			for(var em=0; em < json.length && em < nummeets; em++){
		    				var startDate = dateFormat(json[em].beginDate,"MM-dd hh:mm");
			    			var startDate1 = dateFormat(json[em].beginDate,"MM-dd");
			    			var startDate0 = dateFormat(json[em].beginDate,"yyyy-MM-dd");
			    			var endDate = dateFormat(json[em].endDate,"hh:mm");
			    			var endDate1 = dateFormat(json[em].endDate,"MM-dd");
			    			var endDate0 = dateFormat(json[em].endDate,"yyyy-MM-dd");
			    			if(startDate0 != endDate0){
			    				//startDate = startDate1;
			    				endDate = endDate0;
			    			}
		    				html += "<li><a style=\"padding-right:148px;\" href=\"javascript:meetingView('"+json[em].id+"','"+json[em].state+"','"+json[em].bodyType+"')\" > <i>"+json[em].title+"</i><span>"+startDate+" ~ "+endDate+"</span></a></li>";
		    			}
		    			//html += "<a href=\"javascript:openUrl('${path}/meetingList.do?method=listPendingMeeting&listType=listPendingMeeting')\">更多></a>";
		    			_buls.empty();
		    			_buls.append(html);
		    			
		    			//定时任务
		    			setTimeout("meetingAjaxData()", 60*1000 );
					}
		    	});
			}
		//打开详情页面，从首页、版块首页、换一换打开
		function meetingView(bulId, state, bodyType) {//\"javascript:newsView(
			if(window.parent.$.ctx.CurrentUser.isAdmin){
				return;
			}
		    var url = _ctxPath + "/mtMeeting.do?method=mydetail&id=" + bulId + "&proxy=0&proxyId=-1";
		    openCtpWindow({
		        'window': window,
		        'url': url
		    });
		}
		doneMeetingAjaxData();
		//var nummeets = 10;//公告展示个数
		function doneMeetingAjaxData(){
				var url = "zyPortalController.do?method=listDoneMeeting&num=8";
		    	$.ajax({
		    		url:url,
		        	type:"GET",  
		        	dataType :'text', 
		    		success:function(result){
		    			var json = $.parseJSON(result);
		    			var _buls = $("#doneMeeting");
		    			var html = "";
		    			for(var em=0; em < json.length && em < nummeets; em++){
			    			var startDate = dateFormat(json[em].beginDate,"MM-dd hh:mm");
			    			var startDate1 = dateFormat(json[em].beginDate,"MM-dd");
			    			var startDate0 = dateFormat(json[em].beginDate,"yyyy-MM-dd");
			    			var endDate = dateFormat(json[em].endDate,"hh:mm");
			    			var endDate1 = dateFormat(json[em].endDate,"MM-dd");
			    			var endDate0 = dateFormat(json[em].endDate,"yyyy-MM-dd");
			    			if(startDate0 != endDate0){
			    				//startDate = startDate1;
			    				endDate = endDate0;
			    			}
		    				html += "<li><a style=\"padding-right:148px;\" href=\"javascript:meetingView('"+json[em].id+"','"+json[em].state+"','"+json[em].bodyType+"')\" > <i>"+json[em].title+"</i><span>"+startDate+" ~ "+endDate+"</span></a></li>";
		    			}
		    			//http://localhost/seeyon/meeting.do?method=listPendingMeeting&listType=listPendingMeeting&meetingNature=&sendType=&mtAppId=&summaryId=&affairId=&collaborationFrom=&formOper=&moduleTypeFlag=&portalRoomAppId=&projectId=&meetingId=&time=
		    			// html += "<a href=\"javascript:openUrl('${path}/meetingList.do?method=listDoneMeeting&listType=listDoneMeeting')\">更多></a>";
		    			_buls.empty();
		    			_buls.append(html);
		    			
		    			//定时任务
		    			setTimeout("doneMeetingAjaxData()", 60*1000 );
					}
		    	});
			}
		/* MeetingRoomAjaxData();
		//var nummeets = 10;//公告展示个数
		function MeetingRoomAjaxData(){
				var url = "zyPortalController.do?method=listMeetingRoom&num=10";
		    	$.ajax({
		    		url:url,
		        	type:"GET",  
		        	dataType :'text', 
		    		success:function(result){
		    			var json = $.parseJSON(result);
		    			var _buls = $("#doneMeeting");
		    			var html = "";
		    			
		    			for(var em=0; em < json.length && em < nummeets; em++){
		    				html += "<li><a href=\"javascript:openUrl('${path}/meetingroom.do?method=index&_resourceCode=F09_meetingRoom')\" > <i>"+json[em].roomName+"</i><span>"+new Date(json[em].startDatetime).Format("MM-dd hh:mm")+" ~ "+new Date(json[em].endDatetime).Format("hh:mm")+"</span>"+"</a></li>";
		    			}
		    			//http://localhost/seeyon/meeting.do?method=listPendingMeeting&listType=listPendingMeeting&meetingNature=&sendType=&mtAppId=&summaryId=&affairId=&collaborationFrom=&formOper=&moduleTypeFlag=&portalRoomAppId=&projectId=&meetingId=&time=
		    			html += "<a href=\"javascript:openUrl('${path}/meetingroom.do?method=index&_resourceCode=F09_meetingRoom')\">更多></a>";
		    			_buls.empty();
		    			_buls.append(html);
		    			
		    			//定时任务
		    			setTimeout("meetingAjaxData()", 60*1000 );
					}
		    	});
			} */
		//打开详情页面，从首页、版块首页、换一换打开
		function meetingView(bulId, state, bodyType) {//\"javascript:newsView(
		//http://localhost/seeyon/mtMeeting.do?method=mydetail&id=8469461941056587211&proxy=0&proxyId=-1
			if(window.parent.$.ctx.CurrentUser.isAdmin){
				return;
			}
		    var url = _ctxPath + "/mtMeeting.do?method=mydetail&id=" + bulId + "&proxy=0&proxyId=-1";
		    openCtpWindow({
		        'window': window,
		        'url': url
		    });
		}
	function dateFormat(dateString,format) {
            if(!dateString)return "";
            var time = getDateForStringDate(dateString);
            var o = {
                "M+": time.getMonth() + 1, //月份
                "d+": time.getDate(), //日
                "h+": time.getHours(), //小时
                "m+": time.getMinutes(), //分
                "s+": time.getSeconds(), //秒
                "q+": Math.floor((time.getMonth() + 3) / 3), //季度
                "S": time.getMilliseconds() //毫秒
            };
            if (/(y+)/.test(format)) format = format.replace(RegExp.$1, (time.getFullYear() + "").substr(4 - RegExp.$1.length));
            for (var k in o)
                if (new RegExp("(" + k + ")").test(format)) format = format.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            return format;
        }
   /**
 * 解决 ie，火狐浏览器不兼容new Date(s)
 * @param strDate
 * 返回 date对象
 * add by zyf at 2015年11月5日
 */
function getDateForStringDate(strDate){
	//切割年月日与时分秒称为数组
	var s = strDate.split(" "); 
	var s1 = s[0].split("-"); 
	var s2 = s[1].split(":");
	if(s2.length==2){
		s2.push("00");
	}
	return new Date(s1[0],s1[1]-1,s1[2],s2[0],s2[1],s2[2]);
}
	</script>