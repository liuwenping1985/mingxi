<%--
	OA集成帆软报表默认数据集参数
	-------------------------------------------------
	序号	|参数名							|说明	
	1	|org_currentUserId				|当前登录人员ID
	2	|org_currentUserDepartmentId	|当前登录人员所在部门
	
 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.ctp.form.modules.engin.formula.function.FormulaOrgFunction"%>

<%--1. 登录人员ID --%>
<input id="org_currentUserId" name="org_currentUserId" value="<%= FormulaOrgFunction.org_currentUserId()%>" />
<%--2. 登录人员所在部门ID--%>
<input id="org_currentUserDepartmentId" name="org_currentUserDepartmentId" value="<%=FormulaOrgFunction.org_currentUserDepartmentId() %>" />