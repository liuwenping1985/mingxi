<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>表单查询</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="../common/common.js.jsp" %>
<script>
    var maps=${maps};
    var id="${id}";
    var formMasterId="${formMasterId}";
    var showFieldList=maps.showFields;
    var showList=maps.showFieldNames;
	var formType = ${queryBean.formBean.formType };
	var queryFormId = '${queryBean.formBean.id }';
    var urlFieldList = $.parseJSON('${urlFieldList}');
    var imageDisList  = $.parseJSON('${imageDisList}');
    $(document).ready(function(){
	    if(showFieldList!=""){
	        var fields = showFieldList.split(",");
	        var names = showList.split(",");
	        var col;
	        var colData = new Array();
	        for(var i=0;i<fields.length;i++){
	            col = new Object();
	            col.name=fields[i].substring(fields[i].indexOf(".")+1);
	            col.width=getTHWidthTable(fields.length);
	            col.display=getShowColName(names[i]);
	            col.sortable=true;
	            colData[colData.length] = col;
	        }
	        
	        $("#mytable").ajaxgrid({
	            click : clk,
	            colModel: colData,
                render : rend,
	            managerName : "formQueryResultManager",
	            managerMethod : "getFormQueryResultInColl",
	            usepager: true,
	            showTableToggleBtn: false,
	            resizable:false,
	            dataTable:true,
	            customize:false
	        });
	        var param=new Object();
	        param.id=id;
	        param.formMasterId=formMasterId;
	        $("#mytable").ajaxgridLoad(param);
	        $("#mytable").ajaxgrid().grid.resizeGrid($("body").height()-65);//表格高度
	    }
	    function getTHWidthTable(thCount){
	        if(thCount>=10){
	          return "10%";
	        }
	        return 100/thCount+"%";
	    }
	    function getShowColName(n){
	        var charIndex = n.lastIndexOf("(");
	        if(n.length==(n.lastIndexOf(")")+1)&&charIndex>0){
	          n = n.substring(charIndex+1,n.length-1);
	        }
	        return n;
	    }
	    function clk(data, r, c) {
			<c:if test="${rightStr != ''}">
			showFormData4Statistical(formType,data.id,"${rightStr}","${queryBean.name }",null,queryFormId);
			</c:if>
		}
        function rend(txt,rowData, rowIndex, colIndex,colObj) {
            var isUrl = false;
            var isDisImage = false;
            if(urlFieldList){
                for(i in urlFieldList){
                    if(urlFieldList[i] == colObj.name){
                        isUrl = true;
                        break;
                    }
                }
            }
            if(imageDisList){
                for(j in imageDisList){
                    if(imageDisList[j] == colObj.name){
                        isDisImage = true;
                        break;
                    }
                }
            }
            if(isUrl){
                return '<a class="noClick" href='+txt+' target="_blank">'+txt+'</a>';
            }else if(isDisImage && txt != ""){
                var imgSrc = _ctxPath+"/fileUpload.do?method=showRTE&fileId="+txt+"&expand=0&type=image";
                return "<img class='showImg' src='"+imgSrc+"' height=25 />";
            }else{
                return txt;
            }
        }
        //修复列表错位问题
        $(".togCol").click(function(){
        	$("#mytable").width("auto")
        })
    });
</script>
</head>
<body class="body-pading h100b" leftmargin="0" topmargin="" marginwidth="0" marginheight="0">

        <div class="list">
            <div class="button_box clearfix">
                <table id="mytable"></table>
            </div>
        </div>

</body>
</html>