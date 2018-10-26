<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-11-15#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<TABLE class="only_table edit_table" border=0 cellSpacing=0 cellPadding=0 width="100%" style="padding:10px 20px 229px 20px;border:none;background:#fafafa;">
		<THEAD>
			<TR>
				<TH style="height:32px;text-align:center;background: rgb(128, 171, 211);color:#fff;border-rigth: 1px solid #d2d2d2;"><input id="checkAll" onclick="sel(this)" name="importlevelcheck" type="checkbox"/></TH>
				<TH style="background: rgb(128, 171, 211);color:#fff;">
					<%--类型 --%>
	                ${ctp:i18n("collaboration.eventsource.category.type")}
                </TH>
			</TR>
		</THEAD>
		<c:if test="${itemCount eq 3}">
			<TBODY>
				<TR>
					<TD style="height:32px;text-align:center;color:#fff;border-left: 1px solid #dedede;"><input id="normal" name="importlevel" type="checkbox" value="1"/></TD>
					<TD style="background:#FFF;">
					    <%--普通 --%>
	                    ${ctp:i18n("collaboration.pendingsection.importlevl.normal")}
	                </TD>
				</TR>
          <c:if test="${hasEdoc}">
	            <TR>
	                <TD style="height:32px;text-align:center;color:#fff;border-left: 1px solid #dedede;"><input id="pingAnxious" name="importlevel"  type="checkbox" value="2"/></TD>
	                <TD>
	                    <%--平急（公文）/重要（协同、表单）--%>
	                    ${ctp:i18n("collaboration.pendingsection.old.importlevl.pingAnxious")}
	                </TD>
	            </TR>
				      <TR>
	                <TD style="height:32px;text-align:center;color:#fff;border-left: 1px solid #dedede;"><input id="important" name="importlevel"  type="checkbox" value="3"/></TD>
	                <TD>
	                    <%--加急 (公文)/非常重要（协同、表单） --%>
	                    ${ctp:i18n("collaboration.pendingsection.old.importlevl.important")}
	                </TD>
	            </TR>
          </c:if>
	            <TR>
	                <TD style="height:32px;text-align:center;color:#fff;border-left: 1px solid #dedede;"><input id="other" name="importlevel"  type="checkbox" value="4"></TD>
	                <TD style="background:#FFF;">
	                    <%--其他--%>
	                    ${ctp:i18n("collaboration.pendingsection.other")}
	                </TD>
	            </TR>
			</TBODY>
		</c:if>
		<c:if test="${itemCount >= 5}">
			<TBODY>
				<TR>
					<TD style="height:32px;text-align:center;background:#fff;border-right:none;border-left:1px solid #d2d2d2;"><input id="normal" name="importlevel" type="checkbox" value="1"/></TD>
					<TD style="background:#FFF;">
					    <%--普通 --%>
	                    ${ctp:i18n("collaboration.pendingsection.importlevl.normal")}
	                </TD>
				</TR>
	        	<TR>
		            <TD style="height:32px;text-align:center;background:#fff;border-right:none;border-left:1px solid #d2d2d2;"><input id="pingAnxious" name="importlevel"  type="checkbox" value="2"/></TD>
		            <TD style="background:#FFF;">
		            	<c:if test ="${hasEdoc}">
		                  <%--平急（公文）/重要（协同、表单）--%>
		               		${ctp:i18n_1("collaboration.pendingsection.importlevl.pingAnxious",i18nValue2)}
		                </c:if>
		                <c:if test ="${!hasEdoc}">
		                	${ctp:i18n('collaboration.pendingsection.old.importlevl.pingAnxious')}
		                </c:if>
		            </TD>
	       	 	</TR>
				<TR>
		            <TD style="height:32px;text-align:center;background:#fff;border-right:none;border-left:1px solid #d2d2d2;"><input id="important" name="importlevel"  type="checkbox" value="3"/></TD>
		            <TD style="background:#FFF;">
		            	<c:if test="${hasEdoc}">
		                 <%--加急 (公文)/非常重要（协同、表单） --%>
		                 ${ctp:i18n("collaboration.pendingsection.importlevl.important")}
		                </c:if>
		                <c:if test="${!hasEdoc}">
		                	${ctp:i18n('collaboration.pendingsection.old.importlevl.important')}
		                </c:if>
		            </TD>
		        </TR>
		        <c:if test="${hasEdoc}">
		           <TR>
		               <TD style="height:32px;text-align:center;background:#fff;border-right:none;border-left:1px solid #d2d2d2;"><input id="urgent" name="importlevel"  type="checkbox" value="4"/></TD>
		               <TD style="background:#FFF;"> 
		                   <%--特急（公文）--%>
		                   ${ctp:i18n("collaboration.pendingsection.importlevl.urgent")}
		               </TD>
		           </TR>
		           <TR>
		               <TD style="height:32px;text-align:center;background:#fff;border-right:none;border-left:1px solid #d2d2d2;"><input id="teTi" name="importlevel"  type="checkbox" value="5"/></TD>
		               <TD style="background:#FFF;">
		                   <%--特提（公文）--%>
		                   ${ctp:i18n("collaboration.pendingsection.importlevl.teTi")}
		               </TD>
		           </TR>
		        </c:if>
		        <TR>
		            <TD style="height:32px;text-align:center;background:#fff;border-right:none;border-left:1px solid #d2d2d2;"><input id="other" name="importlevel"  type="checkbox" value="6"></TD>
		            <TD style="background:#FFF;">
		                <%--其他--%>
		                ${ctp:i18n("collaboration.pendingsection.other")}
		            </TD>
		        </TR>
			</c:if>
		</TBODY>
    </TABLE>
</body>
<script type="text/javascript">
	function OK(){
	    var importlevel = document.getElementsByName("importlevel");
	    var count = 0;
	    for(var i=0 ; i<importlevel.length ;i++){
	        if(!importlevel[i].checked) count ++;
	    }
	    if(count == importlevel.length) {
	        location.reload();
	    }
	    var importlevelstr = [];
	    var allValue = [];
	    var resMap = new Properties();
	    if(importlevel){
	        for(var i=0 ; i<importlevel.length ;i++){
	            var importl = importlevel[i]
	            if(importl && importl.checked){
	                resMap.put(importl.value,importl.value);
	            }
	        }
	    }
	    var keys = resMap.keys();
	    for(var i = 0 ; i < keys.size();i++){
	        allValue[allValue.length] = keys.get(i);
	    }
	
	    if(allValue.length != 0){
	        importlevelstr[0] = allValue;
	    } else {
	        importlevelstr[0] = [];//应对portal-common.js中的统一至少选择一项的提示判断，增加代码
	    }
	    return importlevelstr;
	}
	function sel(v){
	    var obj = document.getElementsByName("importlevel");
	    if(obj){
	        for(var i=0 ; i<obj.length ;i++){
	            obj[i].checked = v.checked;
	        }
	    }
	}
	window.onload = function () {
	    var values = window.parentDialogObj['setPanelValue_id'].getTransParams();
	    var importlevel = document.getElementsByName("importlevel");
	    if(importlevel && values){
	        for(var i=0 ; i<importlevel.length ;i++){
	            var valuestr  = values.split(",");
	            for(var j=0 ; j<valuestr.length ;j++){
	                if(valuestr[j]  == importlevel[i].value){
	                    importlevel[i].checked = true;
	                }
	            }
	        }
	    } else{
	        //默认勾选重要&非常重要
	        //document.getElementById("important").checked = true;
	        //document.getElementById("urgent").checked = true;
	    }
	}
</script>
</html>