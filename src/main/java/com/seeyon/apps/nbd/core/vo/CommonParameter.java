package com.seeyon.apps.nbd.core.vo;

import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.Constants;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.NbdFileUtils;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.UUIDLong;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.*;

/**
 * Created by liuwenping on 2018/8/20.
 */
public class CommonParameter extends HashMap{

    private List<Attachment> attachmentList;

    private HttpServletRequest request;

    private AttachmentManager attachmentManager;
    private FileManager fileManager;
    private FormManager formManager;


    public AttachmentManager getAttachmentManager() {
        if (this.attachmentManager == null) {
            this.attachmentManager = (AttachmentManager) AppContext.getBean("attachmentManager");
        }

        return this.attachmentManager;
    }


    public FileManager getFileManager() {
        if (this.fileManager == null) {
            this.fileManager = (FileManager) AppContext.getBean("fileManager");
        }

        return this.fileManager;
    }

    public FormManager getFormManager(){
        if(formManager == null){
            formManager = (FormManager) AppContext.getBean("formManager");
        }
        return formManager;
    }

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
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        CommonParameter parameter = new CommonParameter();

        List<Attachment> list = null;
        if (isMultipart) {
            try {
                System.out.println("is isMultipart");
                Map data = new HashMap();
                list = parameter.uploadFiles(request, data);
                Object obj = data.get("req");
                if (obj != null) {
                    parameter.request = (HttpServletRequest) obj;
                }
                parameter.setAttachmentList(list);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

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

    private List<Attachment> uploadFiles(HttpServletRequest request, Map requestHolder) throws BusinessException {
        //  Long maxSize = Long.valueOf(Long.parseLong(SystemProperties.getInstance().getProperty("fileUpload.maxSize")));
        Map v3xFiles = null;
        CommonsMultipartResolver resolver = (CommonsMultipartResolver) AppContext.getBean("multipartResolver");
        HttpServletRequest req = resolver.resolveMultipart(request);
        requestHolder.put("req", req);
        String sender = req.getParameter("sender");
        System.out.println("upload--files-sender:"+sender);
        if (CommonUtils.isEmpty(sender)) {
            return null;
        }
        OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
        V3xOrgMember member = orgManager.getMemberByLoginName(sender);

        v3xFiles = NbdFileUtils.uploadFiles(req, member);
        Constants.ATTACHMENT_TYPE type = Constants.ATTACHMENT_TYPE.FILE;
        ApplicationCategoryEnum category = ApplicationCategoryEnum.form;
        if (v3xFiles != null) {
            List<String> keys = new ArrayList(v3xFiles.keySet());
            List<Attachment> atts = new ArrayList();
            Iterator v3xFilesIterator = keys.iterator();
            while (v3xFilesIterator.hasNext()) {
                String key = (String) v3xFilesIterator.next();
                V3XFile file = (V3XFile) v3xFiles.get(key);
                Attachment att = new Attachment(file, category, type);
                //att.setReference();
                att.setSubReference(UUIDLong.longUUID());
                att.setCategory(2);
                att.setType(0);
                atts.add(att);

                this.getFileManager().save(file);
            }
            if(!CommonUtils.isEmpty(atts)){

                this.getAttachmentManager().create(atts);
            }
            return atts;

        }
        return new ArrayList<Attachment>();
    }

    public HttpServletRequest getRequest() {
        return request;
    }

    public void setRequest(HttpServletRequest request) {
        this.request = request;
    }
}
