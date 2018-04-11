<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    boolean isDevelop = AppContext.isRunningModeDevelop();
    String ctxPath =request.getContextPath(),  ctxServer = "http://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html class="body_html">
    <head>
        <meta charset="utf-8">
        <title>index_body</title>
        <%@ include file="platview_header.jsp" %>
        <script type="text/javascript">
        var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
        var _locale = '<%=locale%>';
        var _isDevelop = <%=isDevelop%>;
	    </script>
        <script type="text/javascript" src="${path}/common/js/jquery-debug.js"></script>
        <script type="text/javascript" src="${path}/common/platview/platview_body_pc.js"></script>
    </head>
    <body class="body_auto">
        <div class="index_body">
            <ul class="body_ul">
                <li class="li_single">
                      <div class="li_header">
                        <div class="transform_info">
                            <div class="circle">
                            </div>
                            <img src="${path}/common/platview/img/monitor.png" class="li_header_img">
                        </div>
                    </div>
                    <span class="sort_name">业务引擎说明</span>
                    <ul class="second_ul">
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/busengine.do?method=org')"><img src="${path}/common/platview/img/down.png" class="down_up">组织模型</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/busengine.do?method=workflow')"><img src="${path}/common/platview/img/down.png" class="down_up">工作流引擎</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/busengine.do?method=form')"><img src="${path}/common/platview/img/down.png" class="down_up">表单引擎</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/busengine.do?method=portal')"><img src="${path}/common/platview/img/down.png" class="down_up">门户引擎</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/busengine.do?method=report')"><img src="${path}/common/platview/img/down.png" class="down_up">报表引擎</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/busengine.do?method=exchange')"><img src="${path}/common/platview/img/down.png" class="down_up">数据交换引擎</span></li>
                    </ul>
                </li>
                <li class="li_single">
                    <div class="li_header">
                        <div class="transform_info">
                            <div class="circle">
                            </div>
                            <img src="${path}/common/platview/img/engine.png" class="li_header_img">
                        </div>
                        
                    </div>
                    <span class="sort_name">运维监控中心</span>
                    <ul class="second_ul">
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/ctp/sysmgr/monitor/gauge.do')"><img src="${path}/common/platview/img/down.png" class="down_up">资源监控</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/ctp/sysmgr/perflogcfg.do')"><img src="${path}/common/platview/img/down.png" class="down_up">线程监控</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/ctp/sysmgr/monitor/earlyWarning.do')"><img src="${path}/common/platview/img/down.png" class="down_up">系统预警</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/systemlogsmanage.do')"><img src="${path}/common/platview/img/down.png" class="down_up">服务日志</span></li>
                        <c:if test="${i18nFlag }">
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/i18NResource.do')"><img src="${path}/common/platview/img/down.png" class="down_up">国际化资源管理</span></li>
                        </c:if>
                        <!-- 
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/constDef.do')"><img src="${path}/common/platview/img/down.png" class="down_up">系统常量</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/appLog.do?method=mainFrame&from=audit')"><img src="${path}/common/platview/img/down.png" class="down_up">应用日志</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/logonLog.do?method=detailSearch&from=audit&rescode=f13_loginlog')"><img src="${path}/common/platview/img/down.png" class="down_up">登录日志</span></li>
                         -->
                    </ul>
                </li>
                 <li class="li_single">
                    <div class="li_header">
                        <div class="transform_info">
                            <div class="circle">
                            </div>
                            <img src="${path}/common/platview/img/integrate.png" class="li_header_img">
                        </div>
                    </div>
                     <span class="sort_name">集成配置中心</span>
                     <ul class="second_ul">
                    <c:if test="${ctp:hasPlugin('nc')}">
                        <li class="sort_type">
                            <span class="second_ul_span haschild"><img src="${path}/common/platview/img/down.png" class="down_up">NC组织数据同步</span>
                            <ul class="third_ul" style="display:none">
                                <li onclick="mainClick('/ncOrgController.do?method=handSynch')"><em class="small_circle"></em>NC同步设置</li>
                                <li onclick="mainClick('/ncAutoSynch.do?method=autoSynch')"><em class="small_circle"></em>NC同步操作</li>
                                <li onclick="mainClick('/ncSynchLog.do?method=synchLog')"><em class="small_circle"></em>NC同步历史</li>
                                <li onclick="mainClick('/ncUserMapper.do?method=userMapper')"><em class="small_circle"></em>NC账号匹配</li>
                            </ul>
                        </li>
                        <li class="sort_type">
                            <span class="second_ul_span haschild"><img src="${path}/common/platview/img/down.png" class="down_up">NC集成配置</span>
                            <ul class="third_ul" style="display:none">
                                <li onclick="mainClick('/ncMultiJCController.do?method=showNCConfframe')"><em class="small_circle"></em>NC集成参数设置</li>
                                <li onclick="mainClick('/ncBusiBindController.do?method=showNCBusiBindframe')"><em class="small_circle"></em>集成业务绑定</li>
                            </ul>
                        </li>
                    </c:if>
                    
                    <c:if test="${ctp:hasPlugin('u8business')}">
                        <li class="sort_type">
                            <span class="second_ul_span haschild" ><img src="${path}/common/platview/img/down.png" class="down_up">U8集成配置</span>
                            <ul class="third_ul" style="display:none">
                                <li onclick="mainClick('/u8ServerController.do?method=initU8Server')"><em class="small_circle"></em>U8服务器设置</li>
                                <li onclick="mainClick('/u8OrgController.do?method=handSynch')"><em class="small_circle"></em>U8同步设置</li>
                                <li onclick="mainClick('/u8AutoSynch.do?method=autoSynch')"><em class="small_circle"></em>U8同步操作</li>
                                <li onclick="mainClick('/u8SynchLogController.do?method=synchLog')"><em class="small_circle"></em>U8同步历史</li>
                                <li onclick="mainClick('/u8UserMapper.do?method=userMapper')"><em class="small_circle"></em>U8帐号绑定</li>
                            </ul>
                        </li>
                        <li class="sort_type">
                            <span class="second_ul_span" onclick="mainClick('/u8business/u8BusinessDataSource.do?method=showDataSourceList')">
                            <img src="${path}/common/platview/img/down.png" class="down_up">U8数据源配置</span>
                        </li>
                    </c:if>
                    
                    <c:if test="${ctp:hasPlugin('dee')}">
                        <li class="sort_type">
                            <span class="second_ul_span haschild"><img src="${path}/common/platview/img/down.png" class="down_up">DEE配置</span>
                            <ul class="third_ul" style="display:none">
                                <li onclick="mainClick('/deeDeployDRPController.do?method=show')"><em class="small_circle"></em>资源包部署</li>
                                <li onclick="mainClick('/deeDeleteController.do?method=getFlowFrame')"><em class="small_circle"></em>任务删除</li>
                                <li onclick="mainClick('/deeSynchronLogController.do?method=synchronLogFrame')"><em class="small_circle"></em>异常处理</li>
                                <li onclick="mainClick('/deeDataSourceController.do?method=dataSourceFrame')"><em class="small_circle"></em>数据源设置</li>
                                <li onclick="mainClick('/deeScheduleController.do?method=scheduleFrame')"><em class="small_circle"></em>定时器设置</li>
                            </ul>
                        </li>
                    </c:if>
                        
                    <c:if test="${ctp:hasPlugin('ncvoucher')}">
                        <li class="sort_type">
                            <span class="second_ul_span pointer haschild"><img src="${path}/common/platview/img/down.png" class="down_up">凭证配置设置</span>
                            <ul class="third_ul" style="display:none">
                                <li onclick="mainClick('/voucher/accountCfgController.do?method=showAccountCgrList')"><em class="small_circle"></em>账号配置</li>
                                <li onclick="mainClick('/voucher/deptMapperController.do?method=showDeptMapperList')"><em class="small_circle"></em>部门映射</li>
                                <li onclick="mainClick('/voucher/memberMapperController.do?method=showMemberMapperList')"><em class="small_circle"></em>人员映射</li>
                                <li onclick="mainClick('/voucher/subjectMapperController.do?method=showSubjectMapperList')"><em class="small_circle"></em>科目映射</li>
                                <li onclick="mainClick('/voucher/archivesMapperController.do?method=showArchivesMapperList')"><em class="small_circle"></em>映射档案</li>
                                <li onclick="mainClick('/voucher/documnentationMapperController.do?method=showDocumnentationMapperList')"><em class="small_circle"></em>单据映射</li>
                            </ul>
                        </li>
                    </c:if>
                    
                        <li class="sort_type">
                            <span class="second_ul_span pointer" onclick="mainClick('/portal/linkSystemController.do?method=linkSystemMain&isAdmin=true')">
                            <img src="${path}/common/platview/img/down.png" class="down_up">关联系统</span>
                        </li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/ldap/ldap.do?method=index')"><img src="${path}/common/platview/img/down.png" class="down_up">目录服务配置</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/cmp/appMgr.do')"><img src="${path}/common/platview/img/down.png" class="down_up">移动接入设置</span></li>
						<c:if test="${ctp:getSystemProperty('portal.favicon')!='U8'}">
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('http://weixin.seeyon.com/index_qy.jsp')"><img src="${path}/common/platview/img/down.png" class="down_up">微信企业号集成</span></li>
						</c:if>
<%-- 
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">帆软报表</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">网站集成</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">吉大正元</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">大家Work集成</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">档案集成</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">书生公文交换</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">云学堂组织数据同步</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">网站集成</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">吉大正元</span></li>
                    
                    <c:if test="${ctp:hasPlugin('everybodyWork')}">
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">大家work集成</span></li>
                    </c:if>
                        
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">档案集成</span></li>
                    
                    <c:if test="${ctp:hasPlugin('gke')}">
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">GKE</span></li>
                    </c:if>
                        
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">天威诚信</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">上海格尔</span></li>
                    
                    <c:if test="${ctp:hasPlugin('imo')}">
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">IMO</span></li>
                    </c:if>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">CMPP3</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">金迪短信</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">NC-MERP</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">UFMobile</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">红杉树</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">永中office转换</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">金格office</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">电子签章</span></li>
                    
                    <c:if test="${ctp:hasPlugin('barCode')}">
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">二维码</span></li>
                    </c:if>
                        
                    <c:if test="${ctp:hasPlugin('lbs')}">
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">LBS</span></li>
                    </c:if>
                    
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">华为集成</span></li>
--%>
                    </ul>
                </li>
                 <li class="li_single">
                      <div class="li_header">
                        <div class="transform_info">
                            <div class="circle">
                            </div>
                            <img src="${path}/common/platview/img/resource.png" class="li_header_img">
                        </div>
                    </div>
                    <span class="sort_name">资源管理中心</span>
                    <ul class="second_ul">
<%--  
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">资源管理</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick=""><img src="${path}/common/platview/img/down.png" class="down_up">菜单管理</span></li>
--%>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/permission/licpermission.do?method=showAccountFrame')"><img src="${path}/common/platview/img/down.png" class="down_up">单位许可数分配</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/m1/mobileOfficeAuth.do?method=mobileOfficeOrgAuth')"><img src="${path}/common/platview/img/down.png" class="down_up">移动Office授权数分配</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/identification.do?method=makeIndex')"><img src="${path}/common/platview/img/down.png" class="down_up">身份验证狗管理</span></li>
                    </ul>
                </li>
                 <li class="li_single">
                    <div class="li_header">
                        <div class="transform_info">
                            <div class="circle">
                            </div>
                            <img src="${path}/common/platview/img/pc.png" class="li_header_img">
                        </div>
                    </div>
                    <span class="sort_name">平台开发中心</span>
                    <ul class="second_ul">
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/docs/sdk/content/index.html')"><img src="${path}/common/platview/img/down.png" class="down_up">开发文档</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/usersystem/restUser.do')"><img src="${path}/common/platview/img/down.png" class="down_up">REST用户管理</span></li>
                        <li class="sort_type"><span class="second_ul_span" onclick="mainClick('/signinmanage.do?method=index')"><img src="${path}/common/platview/img/down.png" class="down_up">单点登录</span></li>
                    </ul>
                </li>
            </ul>
        </div>
    </body>
</html>