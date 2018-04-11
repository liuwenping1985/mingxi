<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>${ctp:i18n('cip.org.sync.log.label')}</title>
        <script type="text/javascript" src="${path}/ajax.do?managerName=cipSynLogManager"></script>
        <style>
            .stadic_head_height{
                height:40px;
            }
            .stadic_body_top_bottom{
                bottom: 0px;
                top: 40px;
            }
            #logs_div{
            	margin-left: 10px;
            	margin-top: 10px;
            }
        </style>
        <script type="text/javascript">
        
       	$().ready(function(){
       		var manager = new cipSynLogManager();
       		$("#toolbar").toolbar({
       	        toolbar: [{id: "add",name: "${ctp:i18n('cip.org.sync.log.prevpage')}",className: "ico16 tobackflow_16",click: prevPage},//ico16 beback_16    ico16 toback_16
       	        		  {id: "next",name: "${ctp:i18n('cip.org.sync.log.nextpage')}",className: "ico16 sent_to_16",click: nextPage}
       	        		  ]
       	    });
       		
           	if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
       		manager.readCipLog({"logName":$("#logName").val(),"date":$("#date").val()}, {
				success: function(rel) {
					try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
					$("#logs_div").html(rel.logName+" : <br>"+rel.log);
	           		$("#logName").val(rel.logName);
				}
			});
           	
           	function prevPage(){
           		if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
           		var logMap = manager.readCipLog({"logName":$("#logName").val(),"date":$("#date").val(),"action":"prev"}, {
    				success: function(rel) {
    					try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
    					$("#logs_div").html(rel.logName+" : <br>"+rel.log);
    	           		$("#logName").val(rel.logName);
    				}
    			});
           	}
    		function nextPage(){
    			manager.readCipLog({"logName":$("#logName").val(),"date":$("#date").val(),"action":"next"}, {
    				success: function(rel) {
    					try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
    					$("#logs_div").html(rel.logName+" : <br>"+rel.log);
    	           		$("#logName").val(rel.logName);
    				}
    			});
           	}
       	});
       	
       	
        </script>
    </head>
    <body class="h100b over_hidden">
        <div class="stadic_layout">
            <div class="stadic_layout_head stadic_head_height">
                <div id="toolbar"></div>
                <input type="hidden" id="logName" value=""/>
            	<input type="hidden" id="date" value="${date}"/>
            </div>
            <div class="stadic_layout_body stadic_body_top_bottom">
                <div id="logs_div" style="width: 100%;height: 100%;border: 0;"></div>
            </div>
        </div>
    </body>
</html>