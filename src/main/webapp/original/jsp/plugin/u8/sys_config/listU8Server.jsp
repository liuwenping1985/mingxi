<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="head.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js" />"></script>
<script type="text/javascript">
function check_add_server(){
    parent.detailFrame.location.href="/seeyon/u8ServerController.do?method=findU8ServerById&primarykey=" + "";
}
function check_modify_server(){
  var b_checkbox = document.getElementsByName("checkbox");
  var total=0;
  for(var i=0;i<b_checkbox.length;i++){
      if(b_checkbox[i].checked==true){
          total +=1;
      }
  }
  if(total==0){
      alert('<fmt:message key="u8.server.alert.choose.modify"/>');
  }else if(total>1){
      alert('<fmt:message key="u8.server.alert.onlychoose.error"/>');
  }else {
      for(i=0;i<=b_checkbox.length;i++){
          if(b_checkbox[i].checked){              
                parent.detailFrame.location.href="/seeyon/u8ServerController.do?method=findU8ServerById&primarykey=" + b_checkbox[i].value ;//修改             
              break;
          }
      }
  } 
}
function check_delete_server(){
    var b_checkbox = document.getElementsByName("checkbox");
    var total=0;
    for(var i=0;i<b_checkbox.length;i++){
        if(b_checkbox[i].checked==true){
            total +=1;
        }
    }
    if(total==0){
        alert('<fmt:message key="u8.server.alert.choose.error"/>');
    }else if(total>1){
        alert('<fmt:message key="u8.server.alert.onlychoose.error"/>');
    }else if(confirm('<fmt:message key="u8.server.alert.confirm.error"/>')){
        for(i=0;i<=b_checkbox.length;i++){
            if(b_checkbox[i].checked){
            	if(!isReferenced(b_checkbox[i].value)){
                	var url = "${pageContext.request.contextPath}/u8ServerAndUserInfoController.do?method=deleteU8serverAndUserInfo&pk=" + b_checkbox[i].value+"&time="+Math.random();
                    $.ajax({
                        async:false,
                        url:url,
                        type:"GET",
                        success:function(data){
                            if(data!=null && data.length>0){
                                alert(data);
                            }
                        },
                        error:function(){
                            alert('<fmt:message key="u8.server.alert.ajax.error"/>');
                        }
                    }); 
                    setTimeout("parent.window.location.reload()",100);
                }
                break;
            }
        }
    }
}

function isReferenced(id){
    var flag = false;
    var url = "${pageContext.request.contextPath}/u8ServerController.do?method=isReferenced&id="+id+"&time="+Math.random();
    $.ajax({
        async:false,
        url:url,
        type:"GET",
        success:function(data){
            if(data.length>0){
                alert(data);
                flag = true;
            }
        },
        error:function(){
            alert('<fmt:message key="u8.server.alert.ajax.error"/>');
            flag = true;
        }
    }); 
    return flag;
}
function check_detail_servers(id,tframe,isRead){
    tframe.location.href="/seeyon/u8ServerController.do?method=findU8ServerById&readStyle="+isRead+"&primarykey=" + id;
}
function init(){
}

</script>
</head>
<body class="overflow-hidden" onload="init();">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
        <table class="border-left border-right border-top" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td height="22" class="webfx-menu-bar">
    
                <script>
                var _mode = parent.parent.WebFXMenuBar_mode || 'blue'; //取得HR外围frame中的菜单样式
                var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />",_mode);
                myBar.add(new WebFXMenuButton("add","<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>","check_add_server()","<c:url value='/common/images/toolbar/new.gif'/>", "",null));
                myBar.add(new WebFXMenuButton("upd","<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}'/>","check_modify_server()","<c:url value='/common/images/toolbar/update.gif'/>","", null));
                myBar.add(new WebFXMenuButton("del","<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>","check_delete_server()","<c:url value='/common/images/toolbar/delete.gif'/>","", null));
                document.write(myBar);
                document.close();
                </script>
                </td>
            </tr>
        </table>
    </div>
    <div class="center_div_row2 overflow-hidden" id="scrollListDiv" ">
    <form id="userMapperForm" method="post" target="exportIFrame" >
        <v3x:table htmlId="userMapperlist" data="U8ServerAndUserInfoBeans" var="listItem" showHeader="true" className="sort ellipsis">
        <c:set var="click" value="check_detail_servers('${listItem.id}',parent.detailFrame,'read')"/>
        <c:set var="dbclick" value="check_detail_servers('${listItem.id}',parent.detailFrame,'edit')"/>
        <v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"checkbox\")'/>">
            <input type="checkbox" name="checkbox" value="${listItem.id}" isInternal="">
        </v3x:column>
        <v3x:column width="19%" align="left" label="u8.server.name.label" type="String"
                    value="${listItem.u8_server_name}" className="cursor-hand sort" 
                     alt="${listItem.u8_server_name}" onClick="${click}" onDblClick="${dbclick}">
        </v3x:column>
        <v3x:column width="19%" align="left" label="u8.server.address.label" type="String"
            value="${listItem.u8_server_address}" className="cursor-hand sort" 
         alt="${listItem.u8_server_address}" onClick="${click}" onDblClick="${dbclick}">
        </v3x:column>       
        <c:choose>
            <c:when test="${listItem.u8_server_enable==1}">
                <v3x:column width="19%" align="left" label="u8.server.isenabled.label" type="int"
                     className="cursor-hand sort" 
                    alt="${listItem.u8_server_enable}" onClick="${click}" onDblClick="${dbclick}">
                <fmt:message key='u8.server.yes'/></v3x:column>   
            </c:when>
            <c:otherwise>
                <v3x:column width="19%" align="left" label="u8.server.isenabled.label" type="int"
                     className="cursor-hand sort" 
                    alt="${listItem.u8_server_enable}" onClick="${click}" onDblClick="${dbclick}">
                <fmt:message key='u8.server.no'/></v3x:column>
            </c:otherwise>
         </c:choose>
         <c:choose>
            <c:when test="${listItem.u8_key==1}">
                <v3x:column width="19%" align="left" label="u8.server.iskey.label" type="int"
                     className="cursor-hand sort" 
                    alt="${listItem.u8_key}" onClick="${click}" onDblClick="${dbclick}">
                <fmt:message key='u8.server.yes'/></v3x:column>   
            </c:when>
            <c:otherwise>
                <v3x:column width="19%" align="left" label="u8.server.iskey.label" type="int"
                     className="cursor-hand sort" 
                    alt="${listItem.u8_key}" onClick="${click}" onDblClick="${dbclick}">
                <fmt:message key='u8.server.no'/></v3x:column>
            </c:otherwise>
         </c:choose>
        <c:choose>
            <c:when test='${listItem.u8_version=="110"}'>
                <v3x:column width="19%" align="left" label="u8.server.type.label" type="String"
                    value="U8V11.0" className="cursor-hand sort" 
                    alt="${listItem.u8_version}" onClick="${click}" onDblClick="${dbclick}">
                </v3x:column>
            </c:when>
            <c:when test='${listItem.u8_version=="111"}'>
                <v3x:column width="19%" align="left" label="u8.server.type.label" type="String"
                    value="U8V11.1" className="cursor-hand sort" 
                    alt="${listItem.u8_version}" onClick="${click}" onDblClick="${dbclick}">
                </v3x:column>
            </c:when>
            <c:when test='${listItem.u8_version=="120"}'>
                <v3x:column width="19%" align="left" label="u8.server.type.label" type="String"
                    value="U8V12.0" className="cursor-hand sort" 
                    alt="${listItem.u8_version}" onClick="${click}" onDblClick="${dbclick}">
                </v3x:column>
            </c:when>
            <c:when test='${listItem.u8_version=="121"}'>
                <v3x:column width="19%" align="left" label="u8.server.type.label" type="String"
                    value="U8V12.1" className="cursor-hand sort" 
                    alt="${listItem.u8_version}" onClick="${click}" onDblClick="${dbclick}">
                </v3x:column>
            </c:when>
            <c:when test='${listItem.u8_version=="125"}'>
                <v3x:column width="19%" align="left" label="u8.server.type.label" type="String"
                    value="U8V12.5" className="cursor-hand sort" 
                    alt="${listItem.u8_version}" onClick="${click}" onDblClick="${dbclick}">
                </v3x:column>
            </c:when>
            <c:otherwise>
                <v3x:column width="19%" align="left" label="u8.server.type.label" type="String"
                    value="U8V13.0" className="cursor-hand sort" 
                    alt="${listItem.u8_version}" onClick="${click}" onDblClick="${dbclick}">
                </v3x:column>
            </c:otherwise>
        </c:choose>
    
        
        </v3x:table>
   </form>
   </div>
</div>
</div>
<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>