<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" errorPage="" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.apps.index.resource.i18n.IndexResources"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.webmail.resources.i18n.WebMailResources" var="v3xMailI18N"/>
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource"  var="v3xDocI18N"/>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search Result Page</title>

<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="<c:url value="/skin/${CurrentUser.skin}/skin.css" />">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="<c:url value="/skin/default/skin.css" />">
</c:if>
<link href="<c:url value="/apps_res/index/css/searchresult.css${v3x:resSuffix()}" />" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/index/js/searchresult.js${v3x:resSuffix()}" />"></script>
<html:link renderURL='/index/indexController.do' var='indexURL'/>

<script Language="JavaScript">
<!--
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/index/js/i18n/");


//getA8Top().hiddenNavigationFrameset();
//getA8Top().showLocation(null, "<fmt:message key='menu.index' bundle="${v3xMainI18N}" />");

 var keyword="${v3x:escapeJavascript(keyword)}";
 var accessoryName = "${v3x:escapeJavascript(accessoryName)}";
  var str = "${indexURL}"+"?method=searchAll&keyword="+encodeURIComponent(keyword)+"&accessoryName="+encodeURIComponent(accessoryName)+"&iframeSearch=iframeSearch" + "&_appCategory=" + "${_appCategory}";
  String.prototype.trim=function(){   
        return this.replace(/(^(\s|\*)*)|(\s*$)/g, "");    
    } 
    function IsNull(value){    
        if(value.length==0){    
            return true;   
        }
        return false;
    }

function searchAction(){

    var ids = document.getElementsByName("library");
    var selectCount = 0;
    for(var i = 0; i < ids.length; i++){
        if(ids[i].checked){
            selectCount++;
        }
    }
    if(selectCount <= 0){
        alert(v3x.getMessage("indexLang.indexquery_selectone_type"));
                return false;
    }
    
    var keyword = document.getElementById("simpleSearch").value.trim() || document.getElementById("kword").value.trim();
    var accessoryName=document.getElementById("accessoryName").value.trim();
    var author=document.getElementById("author").value.trim();
    var title=document.getElementById("title").value.trim();
    document.getElementById("kword").value = keyword;
    document.getElementById("accessoryName").value = accessoryName;
    document.getElementById("author").value =author;
    document.getElementById("title").value =title;
    if(IsNull(keyword)&&IsNull(author)&&IsNull(title)&&IsNull(accessoryName)){
        alert(v3x.getMessage("V3XLang.index_input_error"));
        return;
    }
    var myform=document.getElementById("form1");
    var beginDate = myform.SEARCHDATE_BEGIN;
    var endDate = myform.SEARCHDATE_END;
    if(beginDate.value !='' && endDate.value !='' && beginDate.value>endDate.value){
        alert(v3x.getMessage("V3XLang.index_input_endDate_less_beginDate"));
        return;
    }
        myform.submit();
       myform.search.disabled=true;
}


//回车执行查询 
function doKeyPressedEvent()
{
   if(event.keyCode==13){
     searchAction();
   }
}
function returnBack(){
      getA8Top().contentFrame.topFrame.back();
    }   

function enableType()
{
     var indextypedocument=document.getElementById("indextype");
     var library=document.getElementsByName("library");
     var display=indextypedocument.style.display;
       if(display==null||display=='')
       {
           indextypedocument.style.display="none";
           document.getElementById("indexIteam").style.display="none";
           
           for(var i=0;i<library.length;i++)
          {
                var idCheckBox=library[i];
                idCheckBox.disabled=true;
           }
           
       }else{
           indextypedocument.style.display="";
           document.getElementById("indexIteam").style.display="";
           
           for(var i=0;i<library.length;i++)
           {
                var idCheckBox=library[i];
                idCheckBox.disabled=false;
           }
            }
}


function selectAll(obj){
    var checkBox = document.getElementsByName("library");
    if(checkBox && checkBox.length>0){
        //alert(checkBox.length +'---------'+ obj.getAttribute('checked'));
        var flag = obj.checked;
        for(var i = 0; i<checkBox.length; i++){
            var temp = checkBox[i];
            if(temp){
                temp.checked = flag;
                //temp.setAttribute('checked',flag);
            }
        }
    }
}
function isChecked(){
    var checkBox = document.getElementsByName("library");
    var flag = true;
    if(checkBox && checkBox.length>0){
        for(var i = 0; i<checkBox.length; i++){
            var temp = checkBox[i];
            if(temp){
                var checkedStr = temp.checked
                if(checkedStr == false){
                    flag = false;
                    break;
                }
            }
        }
    }   
    document.getElementById('allSelect').checked = flag;
}

function showSearchArea(showIndex){
  //本地存储showIndex值，在searchResultTable.jsp页面获取，用于区分用户点击的是高级搜索还是便捷搜索，并给table设置不同的高度
  localStorage.showIndex = showIndex;
  //判断dataIFrame下面id为list的table是否存在，存在就触发searchResultTable.jsp下面的initGrid()方法
  if(document.getElementById("dataIFrame").contentWindow.document.getElementById("list")){
      document.getElementById("dataIFrame").contentWindow.initGrid();
  }

	var simple =document.getElementById('simpleSearchArea');
	var more =document.getElementById('moreSearchArea');
	if(showIndex==1){ //简易搜索
		simple.style.display = "";
		more.style.display = "none";
		document.getElementById("simpleSearch").value = document.getElementById("kword").value.trim();
		document.getElementById("kword").value = "";
	    document.getElementById("accessoryName").value = "";
	    document.getElementById("author").value ="";
	    document.getElementById("title").value ="";
	    document.getElementById("SEARCHDATE_BEGIN").value ="";
	    document.getElementById("SEARCHDATE_END").value ="";
	    
	    if(document.getElementById("dataIFrame").contentWindow.document.getElementById("scrollBody")){
			document.getElementById("dataIFrame").contentWindow.document.getElementById("scrollBody").style.height 
			= (document.getElementById("dataIFrame").contentWindow.document.body.clientHeight ) + "px";
			
			if(navigator.userAgent.indexOf("MSIE 9") > 0 && navigator.userAgent.indexOf("Trident/5.0") > 0){
                document.getElementById("dataIFrame").contentWindow.document.getElementById("scrollBody").style.height
                = (document.getElementById("dataIFrame").contentWindow.document.body.clientHeight - 50) + "px";
            }
	    }
	}
	else{ //显示高级
		document.getElementById("kword").value = document.getElementById("simpleSearch").value.trim();
		document.getElementById("simpleSearch").value = "";

		if(document.getElementById("dataIFrame").contentWindow.document.getElementById("scrollBody")){
			document.getElementById("dataIFrame").contentWindow.document.getElementById("scrollBody").style.height
			= (document.getElementById("dataIFrame").contentWindow.document.body.clientHeight - 70 ) + "px";

			if(navigator.userAgent.indexOf("MSIE 9") > 0 && navigator.userAgent.indexOf("Trident/5.0") > 0){
                document.getElementById("dataIFrame").contentWindow.document.getElementById("scrollBody").style.height
                = (document.getElementById("dataIFrame").contentWindow.document.body.clientHeight - 150) + "px";
            }
	    }
		simple.style.display = "none";
		more.style.display = "";
	}
}

//-->
var tohtml = "<SPAN class=nowLocation_content><fmt:message key='doc.now.location.PersonalTools' bundle='${v3xDocI18N}'/>" +
    " > <A href=javascript:showMenu('"+
    v3x.baseURL+"/index/indexController.do?method=search')><fmt:message key='index.com.seeyon.v3x.index.jsp.title'/></A></SPAN>"
showCtpLocation("",{html:tohtml});
</script>
${v3x:skin()}

<style type="text/css">
	.search_li tr td{
		height:35px;
		line-height: 35px;
	}
	.search_li tr td.td_span{
		padding-right:15px;
		color:#333;
	}
  #moreSearchArea input.textStyle{
    height: 24px;
    line-height: 24px;
    border: 1px solid #ccc;
    _height: 26px\9;
    height:/*\**/ 26px\9;
    _line-height: 26px\9;
    line-height:/*\**/ 26px\9;
  }
</style>





</head>

<body scroll="no" style="padding:0px;margin:0px;" class="bg_color"  onkeydown="doKeyPressedEvent()">
<form action="<html:link renderURL='/index/indexController.do?method=searchAll'/>"  method="post" id="form1" target="dataIFrame">
<input name="iframeSearch" value="iframeSearch" type="hidden"/>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="main-bg" id="mainDivId">
<!--  大标题栏 TR -->
  <tr>
    <td  width="100%" valign="top" height="60">
                <div id="searhBarId">            
                    <table width="100%" height="60" border="0" cellpadding="0" cellspacing="0" >
                      <tr>
                        <td align="center" valign="top">
                            
                                <table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right" style="background:#fff; padding-top:15px;">
                                    <!-- <tr>
                                    	<td width="100" class="sectionTitleLine sectionTitleLineBackground" valign="top" style="padding: 5px;">
                                            <span class="searchSectionTitle"><fmt:message key='common.search.condition.label' bundle="${v3xCommonI18N}"/>:</span>
                                        </td>
                                    </tr> -->
                                    <tr style="">
                                       <!--  <td width="100" class="sectionTitleLine sectionTitleLineBackground" valign="top" style="padding: 5px;">
                                        </td> -->
                                        <td class="" align="center"  style="border-bottom:1px solid #e0e0e0; margin:0 25px;">

                                        <style type="text/css">
                                          .search_li  .search_input{
                                              width: 440px;
                                              height:  38px;
                                              line-height: 38px;
                                              _height: 40px\9;
                                              height:/*\**/ 40px\9;
                                              _line-height: 40px\9;
                                              line-height:/*\**/ 40px\9;
                                              padding:0 15px;
                                              border: 1px solid #b7c3ce;
                                              float: left;
                                              outline: none;
                                          }
                                          .inline_block{
                                            display: inline-block;
                                          }
                                          .search_button,.search_button:hover{
                                            float: left;
                                            width: 150px;
                                            height: 40px;
                                            line-height: 40px;
                                            border-radius: 0 3px 3px 0;
                                            background: #5191d1;
                                            color: #fff;
                                            font-size: 14px;
                                            text-align: center;
                                          }
                                          .checkbox_margin{
                                            margin-left:0px;margin-right:10px;
                                          }
                                        </style>

                                        <!--搜索开始-->
                                             <table width="1080" height="100%" border="0" cellpadding="0" cellspacing="0" class="search_li" >
                                               <tbody id="simpleSearchArea">
                                               <tr class="normal_search">
                                                  <td style="height:40px;line-height:40px; padding:10px 0 30px 0;" align="center" colspan="7">
                                                    <div style="width:750px;">
                                                      <span class="inline_block" style="float:left">
                                                          <input type="text" class="search_input" id="simpleSearch"  value="${v3x:toHTML(keyword)}"><a class="search_button" onclick="searchAction();"><fmt:message key='index.com.seeyon.v3x.index.search'  /></a>
                                                      </span>
                                                      <span class="margin_r_20 inline_block" style="float:right;">
                                                        <a id="senior_search_info"  class="link-blue " onclick="showSearchArea(2);" onmouseOver="javascript:this.className='link-orange'" onmouseOut="javascript:this.className='link-blue'" style="font-size:14px;">[<fmt:message key='index.com.seeyon.v3x.index.advance' />]</a>
                                                      </span>
                                                    </div>
                                                  </td>
                                                </tr>
                                              </tbody>
                                              <!-- style="display:none;" -->
                                              <tbody id="moreSearchArea" style="display:none;">
                                                <tr height="25" class="senior_search">
                                                		<!--搜索词-->
            	                                     	<td  class="td_01 td_span" width="80px" align="right" ><fmt:message key="index.com.seeyon.v3x.index.keword"/></td>
            	                                        
            	                                        <!--输入框 -->
            	                                        <td  class="td_02" width="200px">
            	                                          <input class="textStyle" type="text" id="kword" name="keyword" value="${v3x:toHTML(keyword)}"  maxlength="40" style="width:200px" />
            	                                        </td>
            	                                    	
            	                                    	<!-- 发起人-->
            	                                        <td class="td_03 td_span" width="80px" align="right"><fmt:message key='index.com.seeyon.v3x.index.startUser' />
            	                                        </td>

            	                                        <!-- 输入框-->
            	                                        <td class="td_04" width="200px" nowrap="nowrap">
            	                                         <input class="textStyle" type="text" name="author" id="author"  style="width:200px" maxlength="40"/>
            	                                        </td>

                                                		<!--标题 -->
            	                                        <td class="td_05 td_span" width="80px" align="right"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></td>

            	                                        <!-- 输入框-->
            	                                        <td class="td_06" width="200px"><input class="textStyle" type="text" name="title" id="title"  style="width:200px" maxlength="40" />
            	                                        </td>

            	                                        <!--高级选项 -->
            	                                        <td class="td_07" width="180px"  style="vertical-align:middle;" align="left"> 
            	                                        <!--  <a onClick="enableType();"  class="link-blue" onmouseOver="javascript:this.className='link-orange'" onmouseOut="javascript:this.className='link-blue'">[<fmt:message key='index.com.seeyon.v3x.index.advance' />]</a> -->
                                                      <!--Jerry start-->
                                                      <a href="javascript:;" class="link-blue" onclick="showSearchArea(1);" onmouseOver="javascript:this.className='link-orange'" onmouseOut="javascript:this.className='link-blue'" style="font-size:14px;margin-left:20px;">[<fmt:message key='index.com.seeyon.v3x.index.simpleSearch' />]</a>
                                                      <!--Jerry end-->

            	                                        </td>
            	                                      
                                                </tr>
                                                <tr height="25"  class="senior_search">
                                                		<!--起止时间 -->	
            	                                        <td  class="td_01 td_span"  width="" align="right">
            	                                       		 <fmt:message key='index.com.seeyon.v3x.index.strat_end'  />
            	                                        </td>

            	                                        <!--选择输入框-->
                                                        <td  class="td_02 "  width="" nowrap="nowrap">
                                                     		  <input type="text" class="textStyle" style="width:89px; float:left;" id="SEARCHDATE_BEGIN" name="SEARCHDATE_BEGIN" onClick="whenstart('/seeyon',this,300,340);" value="${SEARCHDATE_BEGIN}" readonly="readonly"/>
            	                                           <!-- 	<fmt:message key='index.com.seeyon.v3x.index.to'  /> -->
                                                         <!--Jerry start-->
                                                          <span style="display:inline-block;width:20px;height:24px; line-height:24px;border-top:1px solid #d1d4db;border-bottom:1px solid #d1d4db;text-align:center;float:left;color:#333;"
                                                          readonly="readonly">-</span>
                                                         <!--Jerry end-->
            	                                            <input type="text" class="textStyle" style="width:89px;float:left;" id="SEARCHDATE_END" name="SEARCHDATE_END" onClick="whenstart('/seeyon',this,300,340);" value="${SEARCHDATE_END}" readonly="readonly"/>
                                                    	</td>

                                            			<!-- 附件名-->
                                            			<td   class="td_03 td_span" width="" align="right"><fmt:message key='index.com.seeyon.v3x.index.accessoryName'  /></td>

                                            			<!-- 输入框-->
                                            	  		<td   class="td_04 " width="200px">
                                            	            <input type="text" class="textStyle" id="accessoryName" name="accessoryName" value="${v3x:toHTML(accessoryName)}"  maxlength="40" style="width:200px" />
                                            	 		</td>

                                                    	<td  class="td_05 " ></td>
                                                    	<td  class="td_06 " ></td>
                                                    	<td  class="td_07 " ></td>
                                                    	<!-- 空-->
                                                     	<!-- <td width="" align="right"></td>
                                                        <td nowrap="nowrap" align="center" width="50" height="40">
                                                    	</td> -->
                                                 </tr>
                                                 
                                                  <!-- 高级选项 -->

                                                  <tr height="25"  style="" id="indextype">

                                              			<!--类型-->
                                                  	<td   class="td_01 td_span"  width="80" align="right"><fmt:message key="common.type.label" bundle="${v3xCommonI18N}"/></td>
                                                  <!--全选-->
                                                  <!-- <td class="td_01"  align="center" style="text-align:left"></td> -->

                                                  <!--选项。。。。。。-->
                                               		<td width="" colspan="10"> 
                                                    <label for="allSelect" style="margin-right:15px;"><input id="allSelect" type="checkbox" onClick="selectAll(this)"  checked="checked" class="checkbox_margin" /><fmt:message key='index.select.all.label'/></label>
        	                                            <c:forEach items="${appLibs}" var="lib" varStatus="status">
        								                <label for="appCheck${lib}" style="margin-right:15px;"><input id="appCheck${lib}" type="checkbox" name="library" onClick="showMemberDisable();isChecked()" value="${lib}" checked="checked" /><fmt:message key='index.application.${lib}.label'/></label>
        	                                            </c:forEach>
        	                                       	</td>
        	                                       <!-- <td   class="td_03 "  ></td>
        	                                       <td  class="td_04 "  ></td>
        	                                       <td  class="td_05 "  ></td>
        	                                       <td  class="td_06 "  ></td>
        	                                       <td  class="td_06 "  ></td> -->
                                                </tr>
                                                <!-- <tr style="" id="indexIteam">
                                               		 <td></td>
                                                	<td nowrap="nowrap" align="center" width="" height="40" colspan="6"  style="text-align:left">
                                                        <c:forEach items="${appLibs}" var="lib" varStatus="status">
            							                <label for="appCheck${lib} " style="margin-right:15px;"><input id="appCheck${lib}" type="checkbox" name="library" onClick="showMemberDisable();isChecked()" value="${lib}" checked="checked"  class="checkbox_margin"/><fmt:message key='index.application.${lib}.label'/></label>
                                                        </c:forEach>
                                                	</td>
                                                </tr> -->
                                                <tr height="25">

                                                		<!--搜索按钮 -->
            	                                    	<td nowrap="nowrap" align="center" width="100%" height="40" colspan="7">
            	                                            <input style="padding: 0 15px; background:#5191d1;border-radius:3px;color:#fff;border:none;margin-bottom:15px;margin-top:10px;" type="button" class="deal_btn" onMouseOver="javascript:this.className='deal_btn_over'" onMouseOut="javascript:this.className='deal_btn'" onClick="searchAction()" id="searchBtn" name="search" value="<fmt:message key='index.com.seeyon.v3x.index.search'  />" />
            	                                        </td>
                                                </tr>
                                                 </tbody>
                                            </table>

                                            <!--搜索结束-->
                                        </td>
                                    </tr>
                                </table>
                        
                        </td>
                      </tr>
                    </table>
                </div>      
    </td>
  </tr>
  <tr>
    <td valign="top">
    <div class="common_content_area" style="height:100%;border:0;" id="contentAreaId">     
    <c:choose>
    <c:when test="${ empty keyword && empty accessoryName}"> 
    <iframe marginheight="0" marginwidth="0" height="100%" src="<html:link renderURL='/index/indexController.do?method=showNullList'/>" name="dataIFrame" scroll="no" id="dataIFrame" width="100%" frameborder="0"></iframe>
    </c:when>
    <c:otherwise>
    <script>
    <!--
    document.write("<iframe marginheight=\"0\" marginwidth=\"0\" height=\"100%\" src=\""+str+"\" name=\"dataIFrame\" scroll=\"no\" id=\"dataIFrame\" width=\"100%\" frameborder=\"0\"></iframe>");
    //-->
    </script>
    </c:otherwise>
    </c:choose>
    
 </div>
    
    </td>
  </tr>
</table>
 </form>
</body>
</html>
