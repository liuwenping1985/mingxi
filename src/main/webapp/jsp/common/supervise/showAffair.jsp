<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-11-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>layout</title>
    <style type="text/css">
        .stadic_head_height { height: 26px; }
        .stadic_body_top_bottom { overflow-y:hidden; bottom: 0px; top: 0px; }
    </style>
    <script>
		$(function() {
		    $('#mytable').ajaxgrid({
		      colModel : [
		      { display : "${ctp:i18n('supervise.col.dealUser')}", //处理人    
		        name : 'dealUser',
		        width : '10%'
		      },
		      { display : "${ctp:i18n('supervise.node.policy')}",  //节点期限    
		        name : 'policyName',
		        width : '10%'
		      },
		      { display : "${ctp:i18n('supervise.col.receiveTime')}", //收到时间 
		        name : 'reveiveDate',
		        width : '16%'
		      },  
		      { display : "${ctp:i18n('supervise.col.time.sign')}", //处理时间      
		        name : 'completeTime',
		        width : '16%'
		      },  
		      { display : "${ctp:i18n('supervise.col.dealDays')}", //处理时长      
		        name : 'dealDays',
		        width : '14%'
		      },  
		      { display : "${ctp:i18n('supervise.col.metadata_item.process.date')}",  //处理期限     
		        name : 'dealLine',
		        width : '12%'
		      },  
		      { display : "${ctp:i18n('node.isovertoptime.label')}",  //是否超期     
		        name : 'efficiency',
		        width : '10%'
		      },  
		      { display : "${ctp:i18n('supervise.col.hasten.number.label')}",   //催办次数    
		        name : 'hastened',
		        width : '10%'
		      }
		      ],
		      height:$(document).height()-38,
		      render : rend,
		      managerName : "superviseManager",
		      managerMethod : "getAffairModel"
		    });
		    function rend(txt, data, r, c) {
		        if(c == 6){
		            var isRed = data.isefficiency;
		            if(isRed==1){
		                return "<font color='red'>"+txt+"</font>";
		            }else{
		                return txt;
		            }
		        }
		        return txt;
		    }
		    
            var o = new Object();
            o.objectId = "${id}";
            o.affairId = "${param.affairId}";
            $("#mytable").ajaxgridLoad(o);
		  });
</script>
</head>
<body class="page_color h100b over_hidden">
    <div class="stadic_layout">
        <div class="stadic_layout_body stadic_body_top_bottom ">
            <table id="mytable"></table>
        </div>
    </div>
</body>
</html>
