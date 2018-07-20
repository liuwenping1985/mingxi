<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
    <%------------------------------------------------------  HTML签章相关start ----------------------------------------------------%>
    <%--引用签章JS文件  --%>
    <script type="text/javascript">
        //表单签章相关,hw.js中需要用到
        var hwVer = '<%=DBstep.iMsgServer2000.Version("iWebSignature")%>';
        var webRoot = _ctxServer;
        var htmOcxUserName = escape($.ctx.CurrentUser.name);
    </script>
    
    
     <%-- 存为签章OBJECT对象的 --%>
    <div id="iSignatureHtmlDiv" style="height:0;overflow:hidden;"></div>
    <SCRIPT type="text/javascript">
     <%-- 页面大小改变的时候移动ISignatureHTML签章对象，让其到达正确的位置--%>
      window.onresize = function (){
    	  if(typeof(moveISignatureOnResize)!= 'undefined'){
              moveISignatureOnResize();
          }
      } 
      <%-- 页面离开的时候卸载签章、释放文单签批锁--%>
      window.onbeforeunload=cbfun;
      function cbfun(){
          try{
        	  releaseISignatureHtmlObj();
        	  unLoadHtmlHandWrite();//释放文单签批锁
          }catch(e){}
          if(typeof(beforeCloseCheck) =='function'){
             return beforeCloseCheck();
          }
      }
      window.onunload = function (){
    	  try{unLoadHtmlHandWrite();}catch(e){}
      }
      <%--装载签章--%>
     $(function(){
    	  setTimeout(function(){
    		  if((typeof(loadSignatures) == "function") && ($("#contentType").val()==10 || $("#contentType").val() == 20)){//只有在表单和html的时候才加载,menuMove,menuDocLock
    			  loadSignatures('${ctp:escapeJavascript(param.moduleId)}','${ctp:escapeJavascript(param.canDeleteISigntureHtml)}','${ctp:escapeJavascript(param.isShowMoveMenu)}','${ctp:escapeJavascript(param.isShowDocLockMenu)}');
    	         }
    	  },1000)
      })
      </SCRIPT>
    <%------------------------------------------------------  HTML签章相关end  ----------------------------------------------------%>
