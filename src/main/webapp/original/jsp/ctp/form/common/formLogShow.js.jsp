<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var grid;
 $(document).ready(
      function() {
        grid = $("table.flexme3").ajaxgrid({
            	searchHTML : 'condition_box',
              colModel : [ {
                display : "${ctp:i18n('processLog.list.actionuser.label')}",
                name : 'operator',
                width : '50',
                sortable : true,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.formlogshow.opratetype')}",
                name : 'operatetype',
                width : '100',
                sortable : true,
                align : 'left'
              }, {
                display : "${ctp:i18n('processLog.list.description.label')}",
                name : 'description',
                width : '252',
                sortable : true,
                align : 'center'
              }, {
                display : "${ctp:i18n('processLog.list.date.label')}",
                name : 'operatedate',
                width : '150',
                sortable : true,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.log.creator')}",
                name : 'creator',
                width : '100',
                sortable : true,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.log.createtime')}",
                name : 'createtime',
                width : '150',
                sortable : true,
                align : 'left'
              } ],
              managerName : "formLogManager",
              managerMethod : "getFormlogList",
              click :clk,
              dblclick : dblclk,
              usepager : true,
              useRp : true,
              parentId:"logcenter",
              showTableToggleBtn : true,
              resizable : false,
              height : 255,
              vChange : {
                'parentId' : 'center',
                'changeTar' : 'form_area',
                'subHeight' : 90
              }
            });
            var o = new Object();
            o.formId="${formId}";
            if("${ctp:escapeJavascript(single)}"==='true')
            	{
            o.recordId="${recordId}";
            	}
            $("#mytable").ajaxgridLoad(o);
            function rend(txt, data, r, c) {
            }
            function clk(data, r, c) {

            }
            function dblclk(data, r, c){
            }
        if("${ctp:escapeJavascript(single)}"=='false'){
        	 var layout = $("#layout").layout();
        	    layout.setNorth(155);
        }
        
        $("#creatorsName").click(function(){
   		 	$.selectPeople({
   		    	callback : function(ret) {
   		      		$.alert(ret.value + ":" + ret.text);
   		    	}
   			});
   	 	});

	   	 //查询
	   	 $("#search").click(function(){
	   		 searchFun("${formId}");
   	 	 });
    });
 	$("#toolbar").toolbar({
 		isPager:false,
      	toolbar : [{
      		name : $.i18n('form.formlogshow.exportexcel'),//导出Excel
		  	click : exportExcel,
		  	className : "ico16 export_excel_16"
	  	},{
      		name : $.i18n('common.toolbar.print.label'),
	      	className : "ico16 print_16",
	      	click : function() {
	    		//待统一打印标准后再做
        		myprint();
	      	}
       	}]
    });
 
 //导出日志
 function exportExcel(){
 	 var url = _ctxPath + "/form/formData.do?method=exportLogs&formId=${formId}&size="+grid.p.rp + "&page="+grid.p.page;
	 //单行日志
	 if("${ctp:escapeJavascript(single)}"==='true'){
		 url+='&recordId=${recordId}';
 	 }else {
 		 var beginoperatime=$("#beginoperatime").val();
	 	 var endoperatime=$("#endoperatime").val();
	 	 var operationType=$("#operationType option:selected").val();
	 	 var begincreatetime=$("#begincreatetime").val();
	 	 var endcreatetime=$("#endcreatetime").val();
	     var creator=$("#creator").val();
	 	 var operator=$("#operator").val();
     	 if(beginoperatime!==""&&beginoperatime!==undefined){
    	 	url+='&beginoperatime='+beginoperatime+' 00:00:00';
    	 }
     	 if(endoperatime!==""&&endoperatime!==undefined){
    	 	 url+='&endoperatime='+endoperatime+' 24:00:00';
	 	 }
     	 if(operationType!==""&&operationType!==undefined){
	 		 url+='&operateType='+operationType;
	 	 }
     	 if(begincreatetime!==""&&begincreatetime!==undefined){
	 		 url+='&begincreatetime='+begincreatetime+' 00:00:00';;
	 	 }
     	 if(endcreatetime!==""&&endcreatetime!==undefined){
	 	 	url+='&endcreatetime='+endcreatetime+' 24:00:00';;
	 	 }
     	 if(creator!==""&&creator!==undefined){
	 		 url+='&creator='+creator.substr(creator.indexOf('|')+1,creator.length);
	 	 }
      	 if(operator!==""&&operator!==undefined){
	 		 url+='&operator='+operator.substr(operator.indexOf('|')+1,operator.length);
	 	 }
 	 }
	 $("#exportExcel").attr("src",url);
 }
	 
     </script>
     <script type="text/javascript" src="${path}/common/form/common/formLogShow.js${ctp:resSuffix()}"></script>