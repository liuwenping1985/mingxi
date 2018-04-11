<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var topWindow = null;

function findParentWindow(thisObj, iterative){
	var parentObj = thisObj;

	if(thisObj.dialogArguments){
		parentObj = thisObj.dialogArguments;
	}
	else if(thisObj.opener){
		parentObj = thisObj.opener;
	}
/*	
	if(parentObj && parentObj.getA8Top().contentFrame){
		topWindow = parentObj.getA8Top();
	}*/
   if(parentObj){
     topWindow = parentObj.getA8Top();
    }	
	else{
		if(iterative > 0){
			findParentWindow(parentObj, iterative - 1);
		}
	}
	
	return null;
}

var parentObj = getA8Top().window.dialogArguments;	
if(parentObj){	
	getA8Top().window.close();
	findParentWindow(getA8Top().window.dialogArguments, 5);
}
else{
	findParentWindow(window, 5);
}

if(topWindow){
	topWindow.reFlesh();
}
</script>