<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
			<label style="font-size:16px">
			<c:if test="${statisticsDimension==1}">
				${v3x:toHTML(organizationName)}
			</c:if>
			<c:if test="${statisticsDimension==2}">
				<c:if test="${timeType==1}">
					<c:choose>
					<c:when test ="${yeartype_startyear == yeartype_endyear}">
						${yeartype_startyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />
					</c:when>
					<c:otherwise>
						${yeartype_startyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />-- 
						${yeartype_endyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />
					</c:otherwise>
					</c:choose>
				</c:if>
				<c:if test="${timeType==2}">
					<c:choose>
					<c:when test ="${seasontype_startyear == seasontype_endyear && seasontype_startseason == seasontype_endseason}">
						${seasontype_startyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />${seasontype_startseason}<fmt:message key='common.quarter.label' bundle='${v3xCommonI18N}' />
					</c:when>
					<c:otherwise>
						${seasontype_startyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />${seasontype_startseason}<fmt:message key='common.quarter.label' bundle='${v3xCommonI18N}' />--
						${seasontype_endyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />${seasontype_endseason}<fmt:message key='common.quarter.label' bundle='${v3xCommonI18N}' />
					</c:otherwise>
					</c:choose>

				</c:if>
				<c:if test="${timeType==3}">
					
					<c:choose>
					<c:when test ="${monthtype_startyear == monthtype_endyear && monthtype_startmonth == monthtype_endmonth}">
						${monthtype_startyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />${monthtype_startmonth}<fmt:message key='menu.tools.calendar.yue' bundle='${v3xMainI18N}' />
					</c:when>
					<c:otherwise>
						${monthtype_startyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />${monthtype_startmonth}<fmt:message key='menu.tools.calendar.yue' bundle='${v3xMainI18N}' />--
						${monthtype_endyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />${monthtype_endmonth}<fmt:message key='menu.tools.calendar.yue' bundle='${v3xMainI18N}' />
					</c:otherwise>
					</c:choose>

				</c:if>
				<c:if test="${timeType==4}">
					<c:choose>
					<c:when test ="${daytype_startyear == daytype_endyear && daytype_startmonth == daytype_endmonth && daytype_startday == daytype_endday}">
						${daytype_startyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />${daytype_startmonth}<fmt:message key='menu.tools.calendar.yue' bundle='${v3xMainI18N}' />${daytype_startday}<fmt:message key='menu.tools.calendar.ri' bundle='${v3xMainI18N}' />
					</c:when>
					<c:otherwise>
						${daytype_startyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />${daytype_startmonth}<fmt:message key='menu.tools.calendar.yue' bundle='${v3xMainI18N}' />${daytype_startday}<fmt:message key='menu.tools.calendar.ri' bundle='${v3xMainI18N}' />--
						${daytype_endyear}<fmt:message key='menu.tools.calendar.nian' bundle='${v3xMainI18N}' />${daytype_endmonth}<fmt:message key='menu.tools.calendar.yue' bundle='${v3xMainI18N}' />${daytype_endday}<fmt:message key='menu.tools.calendar.ri' bundle='${v3xMainI18N}' />
					</c:otherwise>
					</c:choose>
				</c:if>
			</c:if><fmt:message key="edoc.stat.tables.label"/></label>