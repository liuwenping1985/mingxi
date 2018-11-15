<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
 <head> 
  <title>测试</title> 
  <script type="text/javascript"> 
     
  /* 
  "NodeUser""上节点"
  "NodeUserSuperDept" "上节点上级部门"
  "NodeUserManageDep" "上节点主管各部门"
  "NodeUserLeaderDep" "上节点分管各部门" 
  "NodeUserSuperAccount" "上节点上级单位" */
  
  	  function _toSelectpeople(){
  	    /* var _excludeElements = new ArrayList();
  	  		_excludeElements.add("NodeNodeUser");
  			_excludeElements.add("NodeNodeUserSuperDept");
  			_excludeElements.add("NodeNodeUserManageDep");
  			_excludeElements.add("NodeNodeUserLeaderDep");
  			_excludeElements.add("NodeNodeUserSuperAccount");
  			excludeElements_rolesp = _excludeElements; */
  		
  		var paramsValue = $("#sp_Vluae").val();
  		$.selectPeople({
	         type:'selectPeople'
	        ,id:"rolesp"
	        ,panels:'Node'
	        ,selectType:'Node'
	        ,maxSize : 1
	        ,excludeElements: "Node|NodeUser,Node|NodeUserSuperDept,Node|NodeUserManageDep,Node|NodeUserLeaderDep,Node|NodeUserSuperAccount"
	        ,minSize:0
	        ,text:$.i18n('common.default.selectPeople.value')
	        ,returnValueNeedType: false
	        ,showFlowTypeRadio: false
	        ,onlyLoginAccount:false
	        ,params:{
		        value: paramsValue
		     }
	        ,targetWindow:getCtpTop()
	        ,callback : function(res){
	         	$("#spText").val(res.text);
	         	$("#sp_Vluae").val(res.value);
	        }
	    }); 
  	  }
      function OK(){
          // 通过window.dialogArguments可以调用父窗口的方法，变量等，例如window.dialogArguments.$('#field0013')
          // 使用dataValue回填
          var ret = {};
          ret.dataValue = $("#sp_Vluae").val();
          ret.type = "Node";
          ret.showValue = $("#spText").val();
         
          return ret;
      }
  </script> 
 </head>
 <body class="page_color">
  <div class="margin_t_30">
  <table width="100%">
    <tr>
      <td width="130" align="right">${ctp:i18n('wfdynamicform.label.chooserole')}&nbsp;&nbsp;</td>
      <td><input id="spText" style="width:200px; padding:0 4px;" class="hand" name="spText" type="text" onclick="_toSelectpeople()" readonly="readonly"/><input id="sp_Vluae" name="sp_Vluae" type="hidden" onlick=""></td>
    </tr>
  </table>
  </div> 
   
 </body>
</html>