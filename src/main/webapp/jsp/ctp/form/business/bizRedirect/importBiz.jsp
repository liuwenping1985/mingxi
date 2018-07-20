<%--
 $Author:$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager,bizDataManager"></script>
<html>
    <head>
        <title>Insert title here</title>
        <script type="text/javascript">
        var treeObj;
        var currentFormObj;
        var bizDataManager = new bizDataManager();
        var dialogArg = window.dialogArguments;//所有参数
        $(document).ready(function(){
          $("#formColumnTree").tree({
              idKey : "value",
              pIdKey : "parent",
              nameKey : "name",
              nodeHandler : function(n) {
                  n.open = true;
                 if(n.data.type != "son"){
                     n.isParent = true;
                 }
              }
          });
          treeObj = $("#formColumnTree").treeObj();
          initView(true);
      });
        
        function initView(firstShow){
          var nodes = treeObj.getNodes();
          currentFormObj = null;
          var needRedirect = true;
          if(nodes.length == 0 || (nodes[0].isParent && typeof(nodes[0].children) == "undefined")){
			$.confirm({'msg':'没有需要重定向的表单，业务配置自动激活！',ok_fn:function(){published(true);},cancel_fn:function(){window.parentDialogObj['redirectBiz'].close(); },close_fn:function(){window.parentDialogObj['redirectBiz'].close(); }});
			return;
		  }
          for(var i=0; i < nodes.length;i++){
            if (initViewFunction(nodes[i])){
              break;
            } else {
              needRedirect = false;
            }
          }
          if (!needRedirect && firstShow){
            $.confirm({'msg':'所有表单已经完成重定向，是否现在发布？',ok_fn:function(){published(true);},cancel_fn:function(){window.parentDialogObj['redirectBiz'].close(); },close_fn:function(){window.parentDialogObj['redirectBiz'].close(); }});
          }
        }
        
        function initViewFunction(node){
          if(node.isParent){
            var nodes = node.children;
            	try{
            		for(var i=0; i < nodes.length;i++){
	                    if (initViewFunction(nodes[i])){
	                        return true;
	                    }
                	}
            	}catch(e){}
                
          } else {
            if (node.data.state == -2){
              currentFormObj = {};
              currentFormObj.id = node.data.value;
              currentFormObj.name = node.data.name;
              $("#viewIframe").prop("src","${path}/content/content.do?isFullPage=true&moduleId="+node.data.value+"&moduleType=35&rightId=-1&isFullPage=true&viewState=4");
              return true;
            } else if (node.data.state == -1){
                var id = node.tId;
                $("#"+id+"_a").css("color","#ccc");
            }
          }
        }
        
        function complateFormRedirect(){
          var node = treeObj.getNodeByParam("value",currentFormObj.id);
          if (node){
            node.data.state = -1;
            treeObj.updateNode(node);
            initView(false);
          }
        }
        
        function published(firstView){
          bizDataManager.doUpdateFormBeanState("${param.bizId}","2");
          bizDataManager.doUpdateBizMapState("${param.bizId}","1");
          if (firstView){
              dialogArg.param.closeWindow();
          }
        }
        
        function OK(param){
          var result = {};
          result.type = param.type;
          result.redirectComplate = false;
          result.bizId = "${param.bizId}";
          //某个表单导入重定向完成后事件
          if (param.type == 'complate'){
            complateFormRedirect();
            //所有表单重定向完成后，这个对象为null
            if (currentFormObj == null){
              result.redirectComplate = true;
            }
            return result;
          }
          //下一个，开始导入按钮事件
          if (param.type == 'redirect'){
            result.formid = currentFormObj.id;
            result.formName = currentFormObj.name;
            return result;
          }
          //发布事件
          if (param.type == 'published'){
            published(false);
            return result;
          }
          //保存退出事件
          if (param.type == 'saveandexit'){
            return result;
          }
          return result;
        }
        </script>
    </head>
    <body>
        <div class="comp" comp="type:'layout'" id="layout">
            <div id="west" class="layout_west" layout="width:200">
                <div id="formColumnTree"></div>
            </div>
            <div id="center" class="layout_center page_color over_hidden" layout="border:false">
                <iframe id="viewIframe" height="100%" width="100%" style="width: 100%;height: 100%;" frameborder="0" ></iframe>
            </div>
        </div>
    </body>
</html>