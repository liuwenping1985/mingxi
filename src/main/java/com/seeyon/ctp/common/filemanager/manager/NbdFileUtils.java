package com.seeyon.ctp.common.filemanager.manager;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.Constants;
import com.seeyon.ctp.common.filemanager.event.FileItem;
import com.seeyon.ctp.common.filemanager.event.FileUploadEvent;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.util.UUIDLong;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.net.URLDecoder;
import java.util.*;

/**
 * Created by liuwenping on 2018/8/23.
 */
public class NbdFileUtils {


    private static PartitionManager PM;

    private static FileManager FM;

    public static PartitionManager getPM() {
        if (PM == null) {
            PM = (PartitionManager) AppContext.getBean("partitionManager");
        }
        return PM;
    }


    public static FileManager getFM() {
        if (FM == null) {
            FM = (FileManager) AppContext.getBean("fileManager");
        }
        return FM;
    }


    private static String getFolder(Date createDate, boolean createWhenNoExist) throws BusinessException {
        return getPM().getFolder(createDate, createWhenNoExist);
    }

    public static Map<String, V3XFile> uploadFiles(HttpServletRequest request, V3xOrgMember member) throws BusinessException {
        System.out.println("---------Test zero------");
        String dir = "";
        // User user = AppContext.getCurrentUser();
        if (!(request instanceof MultipartHttpServletRequest)) {
            throw new IllegalArgumentException("Argument request must be an instantce of MultipartHttpServletRequest. [" + request.getClass() + "]");
        } else {
            Date createDate = new Date();
            System.out.println("---------Test one------");

            dir = getFolder(createDate, true);
            User user = new User();
            user.setId(member.getId());
            user.setDepartmentId(member.getOrgDepartmentId());
            user.setLoginAccount(member.getOrgAccountId());
            user.setLoginName(member.getLoginName());
            user.setName(member.getName());
            AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);

            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
            //System.out.println("---------Test two------"+multipartRequest.toString());
            Map<String, V3XFile> v3xFiles = new HashMap();
            //org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest r;
            Iterator<String> fileNames = multipartRequest.getFileNames();

            if (fileNames == null) {
                return null;
            } else {
                // String isEncrypt = request.getParameter("isEncrypt");
                while (fileNames.hasNext()) {
                    String name = fileNames.next();
                    System.out.println("---------Files:" + name);
                    if ("".equals(name)) {
                        continue;
                    }
                    String fieldName = String.valueOf(name);

                    List<MultipartFile> fileItemList = multipartRequest.getFiles(String.valueOf(name));

                    for (int fileIndex = 0; fileIndex < fileItemList.size(); ++fileIndex) {
                        MultipartFile fileItem = (MultipartFile) fileItemList.get(fileIndex);
                        if (fileItem != null) {
                            String originalFileName= fileItem.getOriginalFilename();
                            try{
                                System.out.println("---------originalFileName:" + originalFileName);
                                originalFileName = URLDecoder.decode(originalFileName,"UTF-8");
                            }catch(Exception e){
                                e.printStackTrace();
                            }

                            String filename = originalFileName.replace(' ', ' ').replace('?', ' ');
                            //String suffix = FilenameUtils.getExtension(filename).toLowerCase();

                            FileItem fi = new FileItemImpl(fileItem);
                            FileUploadEvent event = new FileUploadEvent(getFM(), fi);

                            try {
                                EventDispatcher.fireEventWithException(event);
                            } catch (Throwable var30) {
                                if (var30 instanceof BusinessException) {
                                    throw (BusinessException) var30;
                                }

                                throw new BusinessException(var30.getLocalizedMessage(), var30);
                            }

                            if (fi.getMessages().size() > 0) {
                                request.setAttribute("upload.event.message", fi.getMessages());
                            }

                            long fileId = UUIDLong.longUUID();
                            File destFile = null;
                            try {
                                destFile = new File(dir + File.separator + fileId);
                                fi.saveAs(destFile);
                            } catch (Exception var31) {
                                throw new BusinessException("附件存盘时发生错误", var31);
                            }

                            V3XFile file = new V3XFile(Long.valueOf(fileId));
                            file.setCreateDate(createDate);
                            file.setFilename(filename);
                            file.setSize(Long.valueOf(fi.getSize()));
                            file.setMimeType(fi.getContentType());
                            file.setType(Integer.valueOf(Constants.ATTACHMENT_TYPE.FILE.ordinal()));
                            if (user != null) {
                                file.setCreateMember(member.getId());
                                file.setAccountId(member.getOrgAccountId());
                            }
                            String newKeyName = fieldName + "_" + (fileIndex + 1);
                            v3xFiles.put(newKeyName, file);
                        }
                    }
                }
            }
            return v3xFiles;
        }
    }




}
