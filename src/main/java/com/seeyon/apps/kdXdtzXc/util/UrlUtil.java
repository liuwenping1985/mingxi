package com.seeyon.apps.kdXdtzXc.util;

import com.seeyon.apps.kdXdtzXc.KimdeConstant;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;

import javax.servlet.http.HttpServletRequest;

/**
 *
 * Created by taoan on 2017-3-17.
 */
public class UrlUtil {

    /**
     * oa 内部的地址
     *
     * @param viewCode
     * @return
     */
    public static String getViewCodeUrl(String viewCode) {

        String url = KimdeConstant.urlBean.getUrlMap().get(viewCode);
        return url;
    }

    public static String getCollDetailUrl(String summaryId, String openFrom, String operationId, String formId, String dialogId) {
        StringBuffer sb = new StringBuffer("/collaboration/collaboration.do?method=summary");
        if (!ToolkitUtil.isNull(summaryId)) {
            sb.append("&summaryId=").append(summaryId);
        }
        if (!ToolkitUtil.isNull(openFrom)) {
            sb.append("&openFrom=").append(openFrom);
        }
        if (!ToolkitUtil.isNull(operationId)) {
            sb.append("&operationId=").append(operationId);
        }
        if (!ToolkitUtil.isNull(formId)) {
            sb.append("&formId=").append(formId);
        }

        if (!ToolkitUtil.isNull(dialogId)) {
            sb.append("&dialogId=").append(dialogId);
        }
        return sb.toString();
    }

    public static String getBaseHttpPath(HttpServletRequest request) {
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;
         return basePath;
    }

}
