package com.xad.bullfly.web.common.vo;

import lombok.Data;

import java.util.List;

/**
 * Created by liuwenping on 2020/9/2.
 */
@Data
public class WebJsonResponse {

    private boolean success;
    private String msg;
    private String code;
    private Object data;
    private List items;


    public static WebJsonResponse successWithItems(List items){
        WebJsonResponse result = new WebJsonResponse();
        result.setSuccess(true);
        result.setItems(items);
        return result;
    }
    public static WebJsonResponse successWithData(Object data){
        WebJsonResponse result = new WebJsonResponse();
        result.setSuccess(true);
        result.setData(data);
        return result;
    }
    public static WebJsonResponse fail(String msg){
        WebJsonResponse result = new WebJsonResponse();
        result.setSuccess(false);
        result.setMsg(msg);
        return result;
    }
    public static WebJsonResponse success(String msg){
        WebJsonResponse result = new WebJsonResponse();
        result.setSuccess(true);
        result.setMsg(msg);
        return result;
    }
    public static WebJsonResponse failWithData(String msg, Object data){
        WebJsonResponse result = new WebJsonResponse();
        result.setSuccess(false);
        result.setMsg(msg);
        result.setData(data);
        return result;
    }
    public static WebJsonResponse failWithItems(String msg, List items){
        WebJsonResponse result = new WebJsonResponse();
        result.setSuccess(false);
        result.setMsg(msg);
        result.setItems(items);
        return result;
    }


}
