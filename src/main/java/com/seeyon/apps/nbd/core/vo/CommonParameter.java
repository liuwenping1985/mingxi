package com.seeyon.apps.nbd.core.vo;

import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.ctp.common.po.filemanager.Attachment;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/20.
 */
public class CommonParameter extends HashMap{

    private List<Attachment> attachmentList;

    public List<Attachment> getAttachmentList() {
        return attachmentList;
    }

    public void setAttachmentList(List<Attachment> attachmentList) {
        this.attachmentList = attachmentList;
    }

    public<T> T $(String key){
        return (T)this.get(key);
    }

    public CommonParameter $(String key,Object val){
        this.put(key,val);
        return this;
    }

//PropertyDescriptor

    public static CommonParameter parseParameter(HttpServletRequest request){
        CommonParameter parameter = new CommonParameter();
        Enumeration<String> ps = request.getParameterNames();
        while(ps.hasMoreElements()){
            String psCode = ps.nextElement();
            parameter.put(psCode,request.getParameter(psCode));
        }
        if(parameter.isEmpty()){
           Map<String,String[]> pMap =  request.getParameterMap();
           for(Entry<String,String[]>entry:pMap.entrySet()){

                String key = entry.getKey();
                String[] values = entry.getValue();
                if(values!=null){
                    if(values.length==1){
                        parameter.put(key,values[0]);
                    }else{
                        parameter.put(key,values);
                    }

                }else{
                    parameter.put(key,null);
                }
           }

        }
        try {
            ServletInputStream inputStream = request.getInputStream();
            int i = 1;
            byte[] bs = new byte[1024];
            StringBuilder stb = new StringBuilder();
            while((i = inputStream.read(bs)) != -1){
              //  System.out.println();
                stb.append(new String(new String(bs, 0, i).getBytes(),"UTF-8"));
            }
            if(!CommonUtils.isEmpty(stb.toString())){
                String[] vals = stb.toString().split("&");
                for(String val:vals){
                    String[] subVals = val.split("=");
                    if(subVals.length!=2){
                        parameter.put(subVals[0],"");
                    }else{
                        parameter.put(subVals[0],subVals[1]);
                    }
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        return parameter;

    }


}
