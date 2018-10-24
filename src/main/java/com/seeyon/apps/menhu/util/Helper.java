package com.seeyon.apps.menhu.util;

import com.seeyon.apps.menhu.vo.CommonTypeParameter;
import com.seeyon.ctp.util.json.JSONUtil;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

public class Helper {

    public static void responseJSON(Object data, HttpServletResponse response) {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control",
                "no-store, max-age=0, no-cache, must-revalidate");
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");
        response.setHeader("Pragma", "no-cache");
        PrintWriter out = null;
        try {
            out = response.getWriter();
            out.write(JSONUtil.toJSONString(data));
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
            } finally {

            }

        }
    }

    public static CommonTypeParameter parseCommonTypeParameter(HttpServletRequest request) {
        CommonTypeParameter p = new CommonTypeParameter();

        String offset = request.getParameter("offset");
        if (StringUtils.isEmpty(offset)) {
            p.setOffset(0);
        } else {
            try {
                Integer offsetInt = Integer.parseInt(offset);
                p.setOffset(offsetInt);
            } catch (Exception e) {
                p.setOffset(0);
            }

        }

        String limit = request.getParameter("limit");
        if (StringUtils.isEmpty(limit)) {
            p.setLimit(100);
        } else {
            try {
                Integer limitInt = Integer.parseInt(limit);
                p.setLimit(limitInt);
            } catch (Exception e) {
                p.setLimit(100);
            }
        }
        String typeId = request.getParameter("typeId");
        if (StringUtils.isEmpty(typeId)) {
            p.setTypeId(null);
        } else {
            try {
                Long typeLong = Long.parseLong(typeId);
                p.setTypeId(typeLong);
            } catch (Exception e) {
                p.setTypeId(null);
            }
        }
        return p;

    }

    public static <T> List<T> paggingList(List<T> list, CommonTypeParameter typeParameter) {

        Integer offset = typeParameter.getOffset();
        Integer limit = typeParameter.getLimit();
        if (list == null) {
            return new ArrayList<T>();
        }
        int size = list.size();
        int start = 0;
        int end = size;
        if (offset + limit > size) {
            end = size;
        }
        if (start > end) {
            start = end - 20;
        }
        if (start < 0) {
            start = 0;
        }
        return list.subList(start, end);
    }

    public static void main(String[] args) {

        List list = new ArrayList();
        list.add(1);
        list.add(2);
        list.add(3);
        list.add(4);
        list.add(5);
        System.out.println(list.subList(3, 5));
    }


}
