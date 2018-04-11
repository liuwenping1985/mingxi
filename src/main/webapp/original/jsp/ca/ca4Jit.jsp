<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String original=null,certAuthen =null;
original = request.getAttribute("original")==null?null:request.getAttribute("original").toString();
%>
<object id="JITDSignOcx" codeBase="<%=request.getContextPath()%>/apps_res/ca/JITComVCTK_S.cab#version=2,1,0,3" classid="clsid:B0EF56AD-D711-412D-BE74-A751595F3633"></object>
<script type="text/javascript">
<!--
var isCa = true;
//根据原文和证书产生认证数据包
function caSign(){
	var Auth_Content = '<%=original%>';
	var DSign_Subject = document.getElementById("RootCADN").value;
	if(Auth_Content==""){
		alert("认证原文不能为空!");
	}else{

		var InitParam = "<?xml version=\"1.0\" encoding=\"gb2312\"?><authinfo><liblist><lib type=\"CSP\" version=\"1.0\" dllname=\"\" ><algid val=\"SHA1\" sm2_hashalg=\"sm3\"/></lib><lib type=\"SKF\" version=\"1.1\" dllname=\"SERfR01DQUlTLmRsbA==\" ><algid val=\"SHA1\" sm2_hashalg=\"sm3\"/></lib><lib type=\"SKF\" version=\"1.1\" dllname=\"U2h1dHRsZUNzcDExXzMwMDBHTS5kbGw=\" ><algid val=\"SHA1\" sm2_hashalg=\"sm3\"/></lib><lib type=\"SKF\" version=\"1.1\" dllname=\"U0tGQVBJLmRsbA==\" ><algid val=\"SHA1\" sm2_hashalg=\"sm3\"/></lib></liblist></authinfo>";

  JITDSignOcx.Initialize(InitParam);
  if (JITDSignOcx.GetErrorCode() != 0) {
  		alert("初始化失败，错误码："+JITDSignOcx.GetErrorCode()+" 错误信息："+JITDSignOcx.GetErrorMessage(JITDSignOcx.GetErrorCode()));
      JITDSignOcx.Finalize();
      return false;
  }
		//控制证书为一个时，不弹出证书选择框
		JITDSignOcx.SetCertChooseType(1);
		JITDSignOcx.SetCert("SC","","","",DSign_Subject,"");
		if(JITDSignOcx.GetErrorCode()!=0){
			//alert("错误码："+JITDSignOcx.GetErrorCode()+"　错误信息："+JITDSignOcx.GetErrorMessage(JITDSignOcx.GetErrorCode()));
			JITDSignOcx.Finalize();
			return false;
		}else {
			 var temp_DSign_Result = JITDSignOcx.DetachSignStr("",Auth_Content);
			 if(JITDSignOcx.GetErrorCode()!=0){
					//alert("错误码："+JITDSignOcx.GetErrorCode()+"　错误信息："+JITDSignOcx.GetErrorMessage(JITDSignOcx.GetErrorCode()));
					JITDSignOcx.Finalize();

					return false;
			 }

			 JITDSignOcx.Finalize();
		//如果Get请求，需要放开下面注释部分
		//	 while(temp_DSign_Result.indexOf('+')!=-1) {
		//		 temp_DSign_Result=temp_DSign_Result.replace("+","%2B");
		//	 }
			document.getElementById("signed_data").value = temp_DSign_Result;
		}
	}
	document.getElementById("original_jsp").value = Auth_Content;
}
//-->
</script>

