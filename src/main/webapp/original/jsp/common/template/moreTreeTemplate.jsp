<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>${ctp:i18n("common.my.template")}</title>
	<script type="text/javascript">
		var page = [];
		var category = "${category}";
		var recent = "${recent}";
		page.showTemplates = ${showTemplates};
		var loginAccountId = "${CurrentUser.loginAccount}";
	</script>
	<style type="text/css">
		a {
		    font-size: 12px;
		    cursor: pointer;
		    color: #000;
		    text-decoration: none;
		}
		.companyCheck{
			width:194px;
			height:23px;
			border:1px solid #dae3ea;
			border-radius:3px;
			line-height: 23px;
			color: #999;
			padding-left:10px;
			font-size: 12px;
			position: relative;
		}
		.changeBtn{
		border:1px solid #dae3ea;
		height: 23px;
		line-height: 23px;
		list-style: none;
		width:69px;
		border-radius: 5px;
		display: inline-block;
		margin-left: 26px;
		z-index: 4;
		position: relative;
		background: #fff;
	}
	.treeBtn{
		width:34px;
		line-height: 23px;
		height:23px;
		position: relative;
		cursor: pointer;
		border-right: 1px solid #dae3ea;
		border-radius: 4px 0 0 5px;
	}
	.leftBtn {
		width:34px;
		line-height: 23px;
		height:23px;
		position: relative;
		cursor: pointer;
		border-radius: 0 4px   4px 0;
	}
	.selectBtn {
		background: #8d929b;
	}
	.emBtn {
		position:relative;
		bottom:2px;
		left:8px;
	}
	</style>
	
</head>
<body style="margin-top:0px">
	 <div id='layout' class="comp f0f0f0" comp="type:'layout'">
        <div class="layout_north f0f0f0" layout="height:38,sprit:false,border:false">
		    <form id="searchForm" method="post" action="${path}/template/template.do?method=moreTemplateList">
			    <div style="width: 100%;height: 100%" class="overflow "  >
					<div class="left padding_5">
						<select class="companyCheck" id="selectAccountId" onchange="onSelectAccount()">
							<option value="1">${ctp:i18n("template.moreTemplate.allAccount")}</option>
							<c:forEach items="${accounts }" var="accounts" >
								<option value="${accounts.key}"
										<c:if test='${orgAccountId == accounts.key && isShowTemplates eq "false"}'>selected="selected"</c:if> >
										${accounts.value}
									 </option>
							</c:forEach>
						</select>
					</div>
					<div class="right padding_5">
						<ul class="changeBtn right margin_r_5">
							<li class="left treeBtn selectBtn">
								<em title="${ctp:i18n('template.moreTemplate.tree')}" class="ico16 emBtn viewStyle_tree_checked"></em>
							</li>
							<li class="left leftBtn">
								<em onclick="moreTemplate()" title="${ctp:i18n('template.moreTemplate.flat')}" class="ico16 emBtn viewStyle_list"></em>
							</li>
						</ul>  	
						<span class="search">
							<input id="searchValue" name="searchValue" value="${searchValue}"/>
							<span onclick="search()" class="ico16 search_16"></span>
						</span>
						<span>
							<a class="button" href="${path }/collTemplate/collTemplate.do?method=showTemplateConfig">${ctp:i18n('template.templatePub.configurationTemplates')}</a><!-- 配置模板 -->
						</span>
					</div>
				</div>
			</form>
        </div>
        <div class="layout_west" id="west" layout="border:false">
            <table width="99%" height="100%" style="background: #fff;" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="padding_10" valign="top">
                        <div id="tree" class="ztree"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="layout_center " id="center" style="overflow:auto;background: #fff;" layout="border:false">
            <div width="100%" height="100%">
            	<table id="templateDatasTab" border="0" cellpadding="0" cellspacing="0"  align="center" class="font_size12 w100b padding_10" style="table-layout:fixed">	
			     </table>
            </div>
        </div>
      </div>
</body>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/template/js/moreTreeTemplate.js${ctp:resSuffix()}"></script>
</html>
