<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setBundle basename="com.seeyon.apps.dee.resources.i18n.DeeResources"/>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>高级查询</title>
</head>
<body class="h100b over_hidden">
<div id="searchDiv" class="form_area align_center" style="height:100%;overflow-y: auto;" >
	
		
			 
	
	 
</div>
 
</body>
<style>
.common_txtbox_wrap input {width: 95%; height: 24px;line-height: 24px;border: 0;border-radius: 0;}
</style>
<script type="text/javascript">
var fieldsJsons = "";
var fieldsObjs = [];
fieldsJsons = '${fieldsJson}';
fieldsObjs = eval('(' + fieldsJsons+ ')');
//初始化表单
initForm();	
 
 
 	 
 	function initForm(){
 		
	 	var str = "<table id=\"searchForm\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"90%\" align=\"center\"><tbody>";
	 	 
 		for(var i=0;i<fieldsObjs.length;i++){
 			var field = fieldsObjs[i];
 		
 			if(i%2 == 0 ){
 				str += "<tr>"
 			}
 			var name = field.display;
			if(name.length > 15){
				name = name.substring(0,15);
			}
			
 			str+= "<th nowrap=\"nowrap\"><label class=\"margin_r_5\" for=\"text\" title=\""+field.display+"\" >"+name+":</label></th>";
 			str+= "<td width=\"50%\">";
 			if(field.fieldtype == 'TIMESTAMP' ){
				str += "<div class=\"common_txtbox_wrap\"  >"
 				str += "<input style=\"width:48%; height: 24px;line-height: 24px;border: 0;border-radius: 0;\" id=\""+field.name+"-start\" type=\"text\" fieldType=\""+field.fieldtype+"\" class=\"comp\" readOnly=\"readonly\" comp=\"type:'calendar',ifFormat:'%Y-%m-%d',showsTime:true\"  >";
				str += "-";
				str += "<input style=\"width:48%; height: 24px;line-height: 24px;border: 0;border-radius: 0;\" id=\""+field.name+"-end\" type=\"text\" fieldType=\""+field.fieldtype+"\" class=\"comp validate\" readOnly=\"readonly\"  comp=\"type:'calendar',ifFormat:'%Y-%m-%d',showsTime:true\"  >";
			}if( field.fieldtype == 'DATETIME' ){
				str += "<div class=\"common_txtbox_wrap\"  >"
	 				str += "<input style=\"width:48%; height: 24px;line-height: 24px;border: 0;border-radius: 0;\" id=\""+field.name+"-start\" type=\"text\" fieldType=\""+field.fieldtype+"\" class=\"comp\" readOnly=\"readonly\" comp=\"type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true\"  >";
					str += "-";
					str += "<input style=\"width:48%; height: 24px;line-height: 24px;border: 0;border-radius: 0;\" id=\""+field.name+"-end\" type=\"text\" fieldType=\""+field.fieldtype+"\" class=\"comp validate\" readOnly=\"readonly\"  comp=\"type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true\"  >";
			}else if( field.fieldtype == 'DECIMAL' ){
				str += "<div style=\"_float: left;text-align:left;overflow: hidden; padding: 0 0px; background: #fff; margin: auto;\" >";
 				str += "<select style=\"width:20%; padding-bottom:3px; \"  id=\""+field.name+"-operater\" ><option value=\"=\">=</option><option value=\"lt\">&lt;</option><option value=\"gt\">&gt;</option>";
 				str += "<input style=\"margin-left:10px;width:70%; height: 24px;line-height: 24px; border: 1px solid #ccc; padding-left:10px; \"  id=\""+field.name+"\" fieldType=\""+field.fieldtype+"\" type=\"text\" >";
 			}else if( field.fieldtype == 'VARCHAR' || field.fieldtype == 'LONGTEXT' ){
				str += "<div class=\"common_txtbox_wrap\">";
 				str += "<input id=\""+field.name+"\" fieldType=\""+field.fieldtype+"\" type=\"text\" >";
 			}
 			str+= "</div></td>";
 			
 			if( i%2 != 0  ){
 				str += "</tr>";
 			}
 		}
 		if( fieldsObjs.length%2 != 0 ){
 			str += "<th nowrap=\"nowrap\"><label class=\"margin_r_5\" for=\"text\"></label></th><td></td></tr>";
 		}
 		str += "</tbody></table>";
 		document.getElementById("searchDiv").innerHTML=str;
 	}
 	

 	 
	function OK(){
		var list = [];
		for(var i=0;i<fieldsObjs.length;i++){
			var field = fieldsObjs[i];
			var o = new Object(); 
			if(field.fieldtype == 'TIMESTAMP' || field.fieldtype == 'DATETIME' ){
				var d1 = document.getElementById(field.name+"-start").value;
				var d2 = document.getElementById(field.name+"-end").value;
			//	if(d1 && d2){
					if(d1 == "" && d2 == ""){
						continue
					}else{
						if(d1 != "" && d2 != ""){
							var s_date = new Date(d1.replace(/-/,"/"));
							var e_date = new Date(d2.replace(/-/,"/"));
							if(　s_date >　e_date ){
								$.alert(field.display+"<fmt:message key='dee.advanceSearch.time.constrain'/>"+"！");
								return "error";
							}
						}
						o.fieldType = field.fieldtype;
						o.value = d1 + "@" + d2 ;
						o.name = field.name;
					}	
			//	}else{
			//		continue
			//	}
			}else if( field.fieldtype == 'DECIMAL' ){
				var d1 = document.getElementById(field.name+"-operater").value;
				var d2 = document.getElementById(field.name).value;
				if(  d2 &&  d2!= ""){
					if(isNaN(d2)){
						$.alert(field.display+"<fmt:message key='dee.advanceSearch.isNan.constrain'/>"+"！");
						return "error";
					}
					var d2_length = d2 + "";
					var length = field.fieldlength;
					if(d2_length.length > length){
						$.alert(field.display+"<fmt:message key='dee.advanceSearch.length.constrain'/>"+ length +"！");
						return "error";
					}
					o.fieldType = field.fieldtype;
					o.value = d2 ;
					o.name = field.name;
					o.operater = d1;
				}else{
					continue;
				}
				
				
				
			}else if( field.fieldtype == 'VARCHAR' || field.fieldtype == 'LONGTEXT' ){
				
				var d2 = document.getElementById(field.name).value;
				if(  d2 &&  d2!= ""){
					var length = field.fieldlength;
					if(d2.length > length){
						$.alert(field.display+"<fmt:message key='dee.advanceSearch.length.constrain'/>"+ length +"！");
						return "error";
					}
					o.fieldType = field.fieldtype;
					o.value = d2 ;
					o.name = field.name;
				}else{
					continue
				}
				
			}
			list.push(o);
		}
	 
		return list;
	}
 </script>
</html>