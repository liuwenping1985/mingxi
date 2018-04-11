<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
    <head></head>
    <body>
         <div style="margin-left:auto;margin-right:auto;width:500px;">
               <span style="color:red">Notes<br/>Date format:yyyy-MM-dd,eg:2015-04-03</span><br/><br/>
               Log Date:<input type="text" id="logDate" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"></input>
               <a  id="confirmBtn" class="common_button common_button_emphasize" href="javascript:void(0)">Confirm Upload</a
         </div>
    </body>
</html>
<script type="text/javascript">
     $("#confirmBtn").click(function(){
    	 var logDateStr=$("#logDate").val();
         var url="${path}/sensor.do?method=checkLog&logDateStr=" + logDateStr;
         $.ajax({
        	 url:url,
        	 dataType:"html",
        	 success:function(data)
        	 {
        		 if(data=="")
        			 {
        			    var uploadUrl="${path}/sensor.do?method=uploadLog&logDateStr=" + logDateStr;
        			    $.messageBox({
        			    	'type':1,
        			    	'imgType':'3',
        			    	'msg':"Do you want to upload the files?",
        			    	ok_fn:function()
        			    	{
        			    		 $.ajax({
		        			    	 url:uploadUrl,
		        			    	 dataType:"html",
		        			    	 success:function(data)
		        			    	 {
		        			    		 $.messageBox({
		        	        				    'type' : 0,
		        	        				    'imgType':0,
		        	        				    'msg' :data,
		        	        				    ok_fn : function() {
		        	        				    }
		        	        				  });
		        			    	 },
		        			    	 error:function()
		        			    	 {
		        			    		 $.messageBox({
		        			 				    'type' : 0,
		        			 				    'imgType':1,
		        			 				    'msg' :"Error!",
		        			 				    ok_fn : function() {
		        			 				    }
		        			 				  });
		        			    	 }
		        			     });
        			    	}
        			    });
        			 }
        		 else
        			 {
        			  $.messageBox({
        				    'type' : 0,
        				    'imgType':2,
        				    'msg' :data,
        				    ok_fn : function() {
        				    }
        				  });
        			 }
        	 },
        	 error:function()
        	 {
        		 $.messageBox({
 				    'type' : 0,
 				    'imgType':1,
 				    'msg' :"Error!",
 				    ok_fn : function() {
 				    }
 				  });
        	 }
         });
     });
</script>