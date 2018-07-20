<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>表单查询</title>
<style>
    .stadic_head_height{
        height:21px;
    }
    .stadic_body_top_bottom{
        bottom: 0px;
        top:21px;
    }
</style>
<script>
    $(document).ready(function(){
        new MxtLayout({
             'id': 'layout',
            'westArea': {
                'id': 'west',
                'width':220,
                'sprit': true,
                'minWidth':0,
                'maxWidth':500,
                'border': false
            },
            'centerArea': {
                'id': 'center',
                'border': true,
                'minHeight':20,
                'border': false
            }
        });
        $("#formColumnTree").tree({
            idKey : "queryId",
            pIdKey : "categoryId",
            nameKey : "queryName",
            onClick : function(e, treeId, node){
                if(node.categoryId != 0 && node.categoryId != 1){
                    $("iframe").prop("src","${path }/form/queryResult.do?method=queryExc&hidelocation=false&type=query&fromPortal=section&queryId="+node.data.queryId);
                }
            },
            nodeHandler : function(n) {
            	if(n.data.categoryId==0){
            	  n.isParent = true;
	                n.open = true;
            	}
            }
        });
    });
</script> 
</head>
<body class="h100b overflow_hidden page_color" id='layout'>
    <c:if test="${param.srcFrom eq 'formsection' }">
    <div class="comp" comp="type:'breadcrumb',comptype:'location'"></div>
    </c:if>
    <div >
        <div class="layout_west line_col" id="west">
            <div id="formColumnTree"></div>
        </div>
        <!--查询设置&结果-->
        <div class="layout_center" id="center" style="overflow:hidden;">
            <iframe frameborder="0" width="100%" height="100%" src="${path }/form/formSection.do?method=queryMain&sectionId=${param.sectionId}"> </iframe>
        </div>  
    </div>
</body>
</html>
