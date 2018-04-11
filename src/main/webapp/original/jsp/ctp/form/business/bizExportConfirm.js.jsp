<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
function OK(){
	 var issucess = true;
	 /*
	 var url = _ctxPath + "/form/business.do?method=writeBizDataFile&bizId=${bizId}&fileName=${bizName}";
	 $("body").jsonSubmit({
         action : url,
         debug : false,
         validate : false,
         beforeSubmit:function(){
             processBar =  new MxtProgressBar({text: "正在导出中，请稍候...."});
         },
         callback : function(objs) {
             //兼容google浏览器需要下面这一句替换掉google浏览器添加的pre
             objs = objs.replace("<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">","").replace("</pre>", "").replace("<pre>", "");
             var _objs = $.parseJSON(objs);
             if(_objs.success=="true" || _objs.success==true){
             }else{
                 $.alert("导出失败！原因：" + _objs.errorMsg);
                 issucess = false;
             }
             if(processBar!=undefined){
                 processBar.close();
             }
         }
     });*/
	 return issucess;
}
</script>