//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.common.filemanager.manager;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE;
import com.seeyon.ctp.common.filemanager.dao.V3XFileDAO;
import com.seeyon.ctp.common.filemanager.event.FileItem;
import com.seeyon.ctp.common.filemanager.event.FileUploadEvent;
import com.seeyon.ctp.common.fileupload.FileUploadBreakPointService;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.util.*;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.URLDecoder;
import java.util.*;
import java.util.regex.Pattern;

public class FileManagerImpl implements FileManager {
    private static Log log = CtpLogFactory.getLog(FileManagerImpl.class);
    public static final String FORM_FIELD_DEFAULT_FILE1 = "file1";
    private PartitionManager partitionManager;
    private V3XFileDAO v3xFileDAO;
    private int maxWidth;
    private int maxHeight;
    private String fileSuffix;

    private FileUploadBreakPointService fubps = new FileUploadBreakPointService();

    public FileManagerImpl() {
    }

    public FileUploadBreakPointService getFubps() {
        return fubps;
    }

    public void setFubps(FileUploadBreakPointService fubps) {
        this.fubps = fubps;
    }

    public void setFileSuffix(String fileSuffix) {
        this.fileSuffix = fileSuffix;
    }

    public void setMaxWidth(int maxWidth) {
        this.maxWidth = maxWidth;
    }

    public void setMaxHeight(int maxHeight) {
        this.maxHeight = maxHeight;
    }

    public void setPartitionManager(PartitionManager partitionManager) {
        this.partitionManager = partitionManager;
    }

    public void setV3xFileDAO(V3XFileDAO v3xFileDAO) {
        this.v3xFileDAO = v3xFileDAO;
    }

    public String getNowFolder(boolean createWhenNoExist) throws BusinessException {
        return this.getFolder(new Date(), createWhenNoExist);
    }

    public String getFolder(Date createDate, boolean createWhenNoExist) throws BusinessException {
        return this.partitionManager.getFolder(createDate, createWhenNoExist);
    }

    protected String getDefaultFolder() throws BusinessException {
        return this.getFolder(new Date(), true);
    }

    public V3XFile getV3XFile(Long fileId) throws BusinessException {
        return this.v3xFileDAO.get(fileId);
    }

    public List<V3XFile> getV3XFile(Long[] fileIds) throws BusinessException {
        return this.v3xFileDAO.get(fileIds);
    }

    public File getFile(Long fileId) throws BusinessException {
        return this.getSpicFile(fileId, true);
    }

    public File getSpicFile(Long fileId, boolean decryption) throws BusinessException {
        V3XFile v3xFile = this.getV3XFile(fileId);
        if(v3xFile == null) {
            throw new IllegalArgumentException("文件Id=" + fileId + "不存在");
        } else {
            File file = this.getNewFile(v3xFile.getCreateDate(), fileId);
            return !file.exists()?null:(decryption?this.decryptionFile(file):file);
        }
    }

    public File getFile(Long fileId, Date createDate) throws BusinessException {
        File file = this.getNewFile(createDate, fileId);
        if(!file.exists()) {
            V3XFile v3xFile = this.getV3XFile(fileId);
            if(v3xFile == null) {
                return null;
            }

            Date realCreateDate = v3xFile.getCreateDate();
            file = this.getNewFile(realCreateDate, fileId);
            if(!file.exists()) {
                return null;
            }
        }

        return this.decryptionFile(file);
    }

    public File getFileForUC(Long fileId, Date createDate) throws BusinessException {
        String ucFilePath = this.partitionManager.getFolderForUC(createDate, true) + File.separator + fileId;
        File file = new File(ucFilePath);
        if(!file.exists()) {
            V3XFile v3xFile = this.getV3XFile(fileId);
            if(v3xFile == null) {
                return null;
            }

            Date realCreateDate = v3xFile.getCreateDate();
            ucFilePath = this.partitionManager.getFolderForUC(realCreateDate, true) + File.separator + fileId;
            file = new File(ucFilePath);
            if(!file.exists()) {
                return null;
            }
        }

        return this.decryptionFile(file);
    }

    public File getFileDecryption(Long fileId) throws BusinessException {
        return this.decryptionFile(this.getFile(fileId));
    }

    public File getFileDecryption(Long fileId, Date createDate) throws BusinessException {
        return this.decryptionFile(this.getFile(fileId, createDate));
    }

    public File getThumFile(Long fileId, Date createDate) throws BusinessException {
        return this.getThumFile(fileId, createDate, this.maxWidth);
    }

    private File getThumFileCommon(String resFile, int px) {
        String smallFile = resFile + "_" + px + this.fileSuffix;
        File file = new File(smallFile);
        if(!file.exists()) {
            try {
                String entryTempFile = CoderFactory.getInstance().decryptFileToTemp(resFile);
                String entryThumFile = entryTempFile + "_" + px + this.fileSuffix;
                ImageUtil.resize(entryTempFile, entryThumFile, px, px);
                if(!entryTempFile.equals(resFile)) {
                    CoderFactory.getInstance().encryptFile(entryThumFile, smallFile);
                }

                return new File(smallFile);
            } catch (Exception var7) {
                log.error("生成缩略图:" + var7.fillInStackTrace());
            }
        }

        return file;
    }

    public File getThumFile(Long fileId, Date createDate, int px) throws BusinessException {
        String resFile = this.getNewFilepath(createDate, fileId);
        if(!(new File(resFile)).exists()) {
            V3XFile v3xFile = this.getV3XFile(fileId);
            if(v3xFile == null) {
                return null;
            }

            Date realCreateDate = v3xFile.getCreateDate();
            resFile = this.getNewFilepath(realCreateDate, fileId);
        }

        return this.getThumFileCommon(resFile, px);
    }

    public File getThumFileForUC(Long fileId, Date createDate, String pxStr) throws BusinessException {
        String resFile = this.partitionManager.getFolderForUC(createDate, true) + File.separator + fileId;
        if(!(new File(resFile)).exists()) {
            V3XFile v3xFile = this.getV3XFile(fileId);
            Date realCreateDate = v3xFile.getCreateDate();
            resFile = this.partitionManager.getFolderForUC(realCreateDate, true) + File.separator + fileId;
        }

        int px = this.maxWidth;
        if(StringUtils.isNoneBlank(new CharSequence[]{pxStr})) {
            try {
                px = Integer.valueOf(pxStr).intValue();
            } catch (Exception var7) {
                log.error("传入的缩略图参数不符合规范", var7);
            }
        }

        return this.getThumFileCommon(resFile, px);
    }

    public File decryptionFile(File file) {
        try {
            return CoderFactory.getInstance().decryptFileToTemp(file);
        } catch (Exception var3) {
            log.error("文件=" + file.getName() + " 解密错误！", var3);
            throw new IllegalArgumentException("文件=" + file.getName() + "  解密错误！");
        }
    }

    public Map<String, V3XFile> uploadFiles(HttpServletRequest request, String allowExtensions, Long maxSize) throws BusinessException {
        return this.uploadFiles(request, (String)allowExtensions, (Map)null, (String)null, maxSize);
    }

    public Map<String, V3XFile> uploadFiles(HttpServletRequest request, Long memberId, Long accountId, String allowExtensions, Long maxSize) throws BusinessException {
        return this.uploadFiles(request, memberId, accountId, allowExtensions, (Map)null, (String)null, maxSize);
    }

    public Map<String, V3XFile> uploadFiles(HttpServletRequest request, String allowExtensions, String destDirectory, Long maxSize) throws BusinessException {
        return this.uploadFiles(request, (String)allowExtensions, (Map)null, destDirectory, maxSize);
    }

    public Map<String, V3XFile> uploadFiles(HttpServletRequest request, String allowExtensions, File destFile, Long maxSize) throws BusinessException {
        Map<String, File> destFiles = new HashMap();
        destFiles.put("file1", destFile);
        return this.uploadFiles(request, allowExtensions, (Map)destFiles, maxSize);
    }

    public Map<String, V3XFile> uploadFiles(HttpServletRequest request, String allowExtensions, Map<String, File> destFiles, Long maxSize) throws BusinessException {
        return this.uploadFiles(request, (String)allowExtensions, (Map)destFiles, (String)null, maxSize);
    }

    private Map<String, V3XFile> uploadFiles(HttpServletRequest request, String allowExtensions, Map<String, File> destFiles, String destDirectory, Long maxSize) throws BusinessException {
        String allowExt = allowExtensions;
        User user = AppContext.getCurrentUser();
        if(user == null) {
            return null;
        } else if(!(request instanceof MultipartHttpServletRequest)) {
            throw new IllegalArgumentException("Argument request must be an instantce of MultipartHttpServletRequest. [" + request.getClass() + "]");
        } else {
            Date createDate = new Date();
            String dir;
            if(StringUtils.isNotBlank(destDirectory)) {
                dir = FilenameUtils.separatorsToSystem(destDirectory);
            } else {
                String ucFlag = request.getParameter("ucFlag");
                if("yes".equals(ucFlag)) {
                    dir = this.partitionManager.getFolderForUC(createDate, true);
                } else {
                    dir = this.getFolder(createDate, true);
                }
            }

            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
            Object maxUploadSizeExceeded = multipartRequest.getAttribute("MaxUploadSizeExceeded");
            maxUploadSizeExceeded=null;
            if(maxUploadSizeExceeded != null) {
                if(maxSize != null && maxSize.longValue() != 0L) {
                    throw new BusinessException("fileupload.exception.MaxSize", new Object[]{Strings.formatFileSize(maxSize.longValue(), false)});
                } else {
                    throw new BusinessException("fileupload.exception.MaxSize", new Object[]{maxUploadSizeExceeded});
                }
            } else {
                Object ex = multipartRequest.getAttribute("unknownException");
                if(ex != null) {
                    throw new BusinessException("fileupload.exception.unknown", new Object[]{ex});
                } else {

                    System.out.println("test2");
                    Map<String, V3XFile> v3xFiles = new HashMap();
                    Iterator<String> fileNames = multipartRequest.getFileNames();
                    String isEncrypt = request.getParameter("isEncrypt");
                    if(fileNames!=null){
                        System.out.println("test3");
                        while(fileNames.hasNext()){
                            String name = fileNames.next();
                            if(StringUtils.isEmpty(name)){
                                continue;
                            }
                            String fieldName = String.valueOf(name);
                            List<MultipartFile> fileItemList = multipartRequest.getFiles(String.valueOf(name));
                            for(int fileIndex = 0; fileIndex < fileItemList.size(); ++fileIndex) {
                                MultipartFile fileItem = (MultipartFile)fileItemList.get(fileIndex);
                                if(fileItem != null) {


                                    String filename = fileItem.getOriginalFilename().replace(' ', ' ').replace('?', ' ');
                                    String suffix = FilenameUtils.getExtension(filename).toLowerCase();
                                    if(!StringUtils.isEmpty(allowExt) && !StringUtils.isEmpty(suffix)) {
                                        allowExt = allowExt.replace(',', '|');
                                        if(!Pattern.matches(allowExt.toLowerCase(), suffix)) {
                                            throw new BusinessException("fileupload.exception.UnallowedExtension", new Object[]{allowExt});
                                        }
                                    }

                                    FileItem fi = new FileItemImpl(fileItem);
                                    FileUploadEvent event = new FileUploadEvent(this, fi);

                                    try {
                                        EventDispatcher.fireEventWithException(event);
                                    } catch (Throwable var31) {
                                        if(var31 instanceof BusinessException) {
                                            throw (BusinessException)var31;
                                        }

                                        throw new BusinessException(var31.getLocalizedMessage(), var31);
                                    }

                                    if(fi.getMessages().size() > 0) {
                                        request.setAttribute("upload.event.message", fi.getMessages());
                                    }

                                    long fileId = UUIDLong.longUUID();
                                    File destFile = null;

                                    try {
                                        if(destFiles != null && destFiles.get(fieldName) != null) {
                                            destFile = (File)destFiles.get(fieldName);
                                            destFile.getParentFile().mkdirs();
                                        } else {
                                            destFile = new File(dir + File.separator + fileId);
                                        }

                                        String encryptVersion = null;
                                        encryptVersion = CoderFactory.getInstance().getEncryptVersion();
                                        if(encryptVersion != null && !"no".equals(encryptVersion) && !"false".equals(isEncrypt)) {
                                            BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(destFile));
                                            CoderFactory.getInstance().upload(fi.getInputStream(), bos, encryptVersion);
                                        } else {
                                            fi.saveAs(destFile);
                                        }
                                    } catch (Exception var32) {
                                        throw new BusinessException("附件存盘时发生错误", var32);
                                    }

                                    V3XFile file = new V3XFile(Long.valueOf(fileId));
                                    file.setCreateDate(createDate);
                                    file.setFilename(filename);
                                    file.setSize(Long.valueOf(fi.getSize()));
                                    file.setMimeType(fi.getContentType());
                                    file.setType(Integer.valueOf(ATTACHMENT_TYPE.FILE.ordinal()));
                                    file.setCreateMember(user.getId());
                                    file.setAccountId(user.getAccountId());
                                    String newKeyName = fieldName + "_" + (fileIndex + 1);
                                    v3xFiles.put(newKeyName, file);
                                }
                            }
                        }
                    }
                    System.out.println("test99999999999");
                    //断点file逻辑从这开始
                    String brNames = request.getParameter("br_upload");
                    String brSizes = request.getParameter("br_upload_size");
                    if(!StringUtils.isEmpty(brNames)){
                        String[] files = brNames.split(",");
                        String[] sizes = brSizes.split(",");
                        Long userId = AppContext.getCurrentUser().getId();
                        int tag =0;
                        for(String fName:files){
                            try {
                                fName=URLDecoder.decode(fName,"utf-8");
                            } catch (UnsupportedEncodingException e) {
                                e.printStackTrace();
                            }
                            String filename = fName.replace(' ', ' ').replace('?', ' ');
                            String suffix = FilenameUtils.getExtension(filename).toLowerCase();
                            if(!StringUtils.isEmpty(allowExt) && !StringUtils.isEmpty(suffix)) {
                                allowExt = allowExt.replace(',', '|');
                                if(!Pattern.matches(allowExt.toLowerCase(), suffix)) {
                                    throw new BusinessException("fileupload.exception.UnallowedExtension", new Object[]{allowExt});
                                }
                            }
                            System.out.println("fName:"+fName+",fSize:"+sizes[tag]+",userId:"+userId);
                            File f = this.fubps.getCommonFile(fName,sizes[tag],userId);
                            FileItem fi = new BrFileItem(filename,Integer.parseInt(sizes[tag]),f);
                            FileUploadEvent event = new FileUploadEvent(this, fi);
                            try {
                                EventDispatcher.fireEventWithException(event);
                            } catch (Throwable var31) {
                                throw new BusinessException(var31.getLocalizedMessage(), var31);
                            }
                            if(fi.getMessages().size() > 0) {
                                request.setAttribute("upload.event.message", fi.getMessages());
                            }
                            long fileId = UUIDLong.longUUID();
                            File destFile = null;
                            try {
                                destFile = new File(dir + File.separator + fileId);
                                String encryptVersion = null;
                                encryptVersion = CoderFactory.getInstance().getEncryptVersion();
                                if(encryptVersion != null && !"no".equals(encryptVersion) && !"false".equals(isEncrypt)) {
                                    BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(destFile));
                                    CoderFactory.getInstance().upload(fi.getInputStream(), bos, encryptVersion);
                                } else {
                                    fi.saveAs(destFile);
                                }
                            } catch (Exception var32) {
                                throw new BusinessException("附件存盘时发生错误", var32);
                            }
                            V3XFile file = new V3XFile(Long.valueOf(fileId));
                            file.setCreateDate(createDate);
                            file.setFilename(filename);
                            file.setSize(Long.valueOf(fi.getSize()));
                            file.setMimeType(fi.getContentType());
                            file.setType(Integer.valueOf(ATTACHMENT_TYPE.FILE.ordinal()));
                            file.setCreateMember(user.getId());
                            file.setAccountId(user.getAccountId());
                            String newKeyName = fName + "_" + (tag + 1);
                            v3xFiles.put(newKeyName, file);
                            try {
                                this.fubps.deleteFile(fName,sizes[tag],userId);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            tag++;


                        }
                    }
                    return v3xFiles;
                }
            }
        }
    }

    private Map<String, V3XFile> uploadFiles(HttpServletRequest request, Long memberId, Long accountId, String allowExtensions, Map<String, File> destFiles, String destDirectory, Long maxSize) throws BusinessException {
        String allowExt = allowExtensions;
        if(!(request instanceof MultipartHttpServletRequest)) {
            throw new IllegalArgumentException("Argument request must be an instantce of MultipartHttpServletRequest. [" + request.getClass() + "]");
        } else {
            Date createDate = new Date();
            String dir;
            if(StringUtils.isNotBlank(destDirectory)) {
                dir = FilenameUtils.separatorsToSystem(destDirectory);
            } else {
                String ucFlag = request.getParameter("ucFlag");
                if("yes".equals(ucFlag)) {
                    dir = this.partitionManager.getFolderForUC(createDate, true);
                } else {
                    dir = this.getFolder(createDate, true);
                }
            }
            System.out.println("test1");
            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
            Object maxUploadSizeExceeded = multipartRequest.getAttribute("MaxUploadSizeExceeded");
            maxUploadSizeExceeded=null;
            if(maxUploadSizeExceeded != null) {
                if(maxSize != null && maxSize.longValue() != 0L) {
                    throw new BusinessException("fileupload.exception.MaxSize", new Object[]{Strings.formatFileSize(maxSize.longValue(), false)});
                } else {
                    throw new BusinessException("fileupload.exception.MaxSize", new Object[]{maxUploadSizeExceeded});
                }
            } else {
               // String brFile=
                Object ex = multipartRequest.getAttribute("unknownException");
                if(ex != null) {
                    throw new BusinessException("fileupload.exception.unknown", new Object[]{ex});
                } else {
                    System.out.println("test2");
                    Map<String, V3XFile> v3xFiles = new HashMap();
                    Iterator<String> fileNames = multipartRequest.getFileNames();
                    String isEncrypt = request.getParameter("isEncrypt");
                    if(fileNames!=null){
                        System.out.println("test3");
                        while(fileNames.hasNext()){
                            String name = fileNames.next();
                            if(StringUtils.isEmpty(name)){
                                continue;
                            }
                            String fieldName = String.valueOf(name);
                            List<MultipartFile> fileItemList = multipartRequest.getFiles(String.valueOf(name));
                            for(int fileIndex = 0; fileIndex < fileItemList.size(); ++fileIndex) {
                                MultipartFile fileItem = (MultipartFile)fileItemList.get(fileIndex);
                                if(fileItem != null) {


                                    String filename = fileItem.getOriginalFilename().replace(' ', ' ').replace('?', ' ');
                                    String suffix = FilenameUtils.getExtension(filename).toLowerCase();
                                    if(!StringUtils.isEmpty(allowExt) && !StringUtils.isEmpty(suffix)) {
                                        allowExt = allowExt.replace(',', '|');
                                        if(!Pattern.matches(allowExt.toLowerCase(), suffix)) {
                                            throw new BusinessException("fileupload.exception.UnallowedExtension", new Object[]{allowExt});
                                        }
                                    }

                                    FileItem fi = new FileItemImpl(fileItem);
                                    FileUploadEvent event = new FileUploadEvent(this, fi);

                                    try {
                                        EventDispatcher.fireEventWithException(event);
                                    } catch (Throwable var31) {
                                        if(var31 instanceof BusinessException) {
                                            throw (BusinessException)var31;
                                        }

                                        throw new BusinessException(var31.getLocalizedMessage(), var31);
                                    }

                                    if(fi.getMessages().size() > 0) {
                                        request.setAttribute("upload.event.message", fi.getMessages());
                                    }

                                    long fileId = UUIDLong.longUUID();
                                    File destFile = null;

                                    try {
                                        if(destFiles != null && destFiles.get(fieldName) != null) {
                                            destFile = (File)destFiles.get(fieldName);
                                            destFile.getParentFile().mkdirs();
                                        } else {
                                            destFile = new File(dir + File.separator + fileId);
                                        }

                                        String encryptVersion = null;
                                        encryptVersion = CoderFactory.getInstance().getEncryptVersion();
                                        if(encryptVersion != null && !"no".equals(encryptVersion) && !"false".equals(isEncrypt)) {
                                            BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(destFile));
                                            CoderFactory.getInstance().upload(fi.getInputStream(), bos, encryptVersion);
                                        } else {
                                            fi.saveAs(destFile);
                                        }
                                    } catch (Exception var32) {
                                        throw new BusinessException("附件存盘时发生错误", var32);
                                    }

                                    V3XFile file = new V3XFile(Long.valueOf(fileId));
                                    file.setCreateDate(createDate);
                                    file.setFilename(filename);
                                    file.setSize(Long.valueOf(fi.getSize()));
                                    file.setMimeType(fi.getContentType());
                                    file.setType(Integer.valueOf(ATTACHMENT_TYPE.FILE.ordinal()));
                                    file.setCreateMember(memberId);
                                    file.setAccountId(accountId);
                                    String newKeyName = fieldName + "_" + (fileIndex + 1);
                                    v3xFiles.put(newKeyName, file);
                                }
                            }
                        }
                    }
                    System.out.println("test99999999999");
                        //断点file逻辑从这开始
                        String brNames = request.getParameter("br_upload");
                        String brSizes = request.getParameter("br_upload_size");
                        if(!StringUtils.isEmpty(brNames)){
                            String[] files = brNames.split(",");
                            String[] sizes = brSizes.split(",");
                            Long userId = AppContext.getCurrentUser().getId();
                            int tag =0;
                            for(String fName:files){
                                String filename = fName.replace(' ', ' ').replace('?', ' ');
                                String suffix = FilenameUtils.getExtension(filename).toLowerCase();
                                if(!StringUtils.isEmpty(allowExt) && !StringUtils.isEmpty(suffix)) {
                                    allowExt = allowExt.replace(',', '|');
                                    if(!Pattern.matches(allowExt.toLowerCase(), suffix)) {
                                        throw new BusinessException("fileupload.exception.UnallowedExtension", new Object[]{allowExt});
                                    }
                                }
                                System.out.println("fName:"+fName+",fSize:"+sizes[tag]+",userId:"+userId);
                                File f = this.fubps.getCommonFile(fName,sizes[tag],userId);
                                FileItem fi = new BrFileItem(filename,Integer.parseInt(sizes[tag]),f);
                                FileUploadEvent event = new FileUploadEvent(this, fi);
                                try {
                                    EventDispatcher.fireEventWithException(event);
                                } catch (Throwable var31) {
                                    throw new BusinessException(var31.getLocalizedMessage(), var31);
                                }
                                if(fi.getMessages().size() > 0) {
                                    request.setAttribute("upload.event.message", fi.getMessages());
                                }
                                long fileId = UUIDLong.longUUID();
                                File destFile = null;
                                try {
                                    destFile = new File(dir + File.separator + fileId);
                                    String encryptVersion = null;
                                    encryptVersion = CoderFactory.getInstance().getEncryptVersion();
                                    if(encryptVersion != null && !"no".equals(encryptVersion) && !"false".equals(isEncrypt)) {
                                        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(destFile));
                                        CoderFactory.getInstance().upload(fi.getInputStream(), bos, encryptVersion);
                                    } else {
                                        fi.saveAs(destFile);
                                    }
                                } catch (Exception var32) {
                                    throw new BusinessException("附件存盘时发生错误", var32);
                                }
                                V3XFile file = new V3XFile(Long.valueOf(fileId));
                                file.setCreateDate(createDate);
                                file.setFilename(filename);
                                file.setSize(Long.valueOf(fi.getSize()));
                                file.setMimeType(fi.getContentType());
                                file.setType(Integer.valueOf(ATTACHMENT_TYPE.FILE.ordinal()));
                                file.setCreateMember(memberId);
                                file.setAccountId(accountId);
                                String newKeyName = fName + "_" + (tag + 1);
                                v3xFiles.put(newKeyName, file);
                                try {
                                    this.fubps.deleteFile(fName,sizes[tag],userId);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                tag++;


                            }
                        }
                        return v3xFiles;
                    }
                }
            }
        }


    public void deleteFile(Long fileId, Boolean deletePhysicsFile) throws BusinessException {
        if(deletePhysicsFile.booleanValue()) {
            File file = this.getSpicFile(fileId, false);
            if(file != null) {
                file.delete();
            }
        }

        this.v3xFileDAO.delete(fileId);
    }

    public void deletePhysicsFile(Long fileId) throws BusinessException {
        File file = this.getSpicFile(fileId, false);
        if(file != null) {
            file.delete();
        }

    }

    public void deleteFile(Long fileId, Date createDate, Boolean deletePhysicsFile) throws BusinessException {
        this.v3xFileDAO.delete(fileId);
        if(deletePhysicsFile.booleanValue()) {
            try {
                File file = this.getFile(fileId, createDate);
                if(file != null) {
                    file.delete();
                }
            } catch (Exception var5) {
                ;
            }
        }

    }

    public InputStream getFileInputStream(Long fileId) throws BusinessException {
        File file = this.getFile(fileId);
        if(file == null) {
            return null;
        } else {
            try {
                return new FileInputStream(file);
            } catch (FileNotFoundException var4) {
                log.warn(file.getAbsolutePath() + "不存在");
                return null;
            }
        }
    }

    public InputStream getFileInputStream(Long fileId, Date createDate) throws BusinessException {
        File file = this.getFile(fileId, createDate);
        if(file == null) {
            return null;
        } else {
            try {
                return new FileInputStream(file);
            } catch (FileNotFoundException var5) {
                log.debug(file.getAbsolutePath() + "不存在");
                return null;
            }
        }
    }

    public InputStream getFileInputStreamForUC(Long fileId, Date createDate) throws BusinessException {
        File file = this.getFileForUC(fileId, createDate);
        if(file == null) {
            return null;
        } else {
            try {
                return new FileInputStream(file);
            } catch (FileNotFoundException var5) {
                log.debug(file.getAbsolutePath() + "不存在");
                return null;
            }
        }
    }

    public void save(V3XFile file) {
        file.setIdIfNew();
        this.v3xFileDAO.save(file);
    }

    public byte[] getFileBytes(Long fileId) throws BusinessException {
        File file = this.getFile(fileId);

        try {
            return file != null?FileUtils.readFileToByteArray(file):null;
        } catch (Exception var4) {
            throw new BusinessException(var4.getMessage());
        }
    }

    public byte[] getFileBytes(Long fileId, Date createDate) throws BusinessException {
        File file = this.getFile(fileId, createDate);

        try {
            return file != null?FileUtils.readFileToByteArray(file):null;
        } catch (Exception var5) {
            throw new BusinessException(var5.getMessage());
        }
    }

    public V3XFile save(String bodyData, ApplicationCategoryEnum category, String filename, Date createDate, Boolean isSaveToDB) throws BusinessException {
        if(bodyData == null) {
            throw new IllegalArgumentException("bodyData is null");
        } else {
            if(createDate == null) {
                createDate = new Date();
            }

            byte[] bs = bodyData.getBytes();
            V3XFile v3xFile = new V3XFile();
            v3xFile.setIdIfNew();
            v3xFile.setCategory(Integer.valueOf(category.key()));
            v3xFile.setCreateDate(createDate);
            v3xFile.setFilename(filename);
            v3xFile.setMimeType(FileUtil.getMimeType(filename));
            v3xFile.setSize(Long.valueOf((long)bs.length));

            try {
                File file = this.getNewFile(v3xFile.getCreateDate(), v3xFile.getId());
                FileUtils.writeByteArrayToFile(file, bs);
                if(isSaveToDB.booleanValue()) {
                    this.save(v3xFile);
                }

                return v3xFile;
            } catch (Exception var9) {
                throw new BusinessException(var9);
            }
        }
    }

    public V3XFile clone(Long originalFileId, boolean saveDB) throws BusinessException, FileNotFoundException {
        V3XFile v3xFile = this.getV3XFile(originalFileId);
        if(v3xFile == null) {
            throw new FileNotFoundException("clone附件 : [" + originalFileId + "]不存在。");
        } else {
            Long newFileId = Long.valueOf(UUIDLong.longUUID());
            Date newCreateDate = new Date();
            this.clone(originalFileId, v3xFile.getCreateDate(), newFileId, newCreateDate);
            V3XFile file = new V3XFile();
            file.setId(newFileId);
            file.setCreateDate(newCreateDate);
            file.setCategory(v3xFile.getCategory());
            file.setDescription(v3xFile.getDescription());
            file.setCreateMember(v3xFile.getCreateMember());
            file.setFilename(v3xFile.getFilename());
            file.setMimeType(v3xFile.getMimeType());
            file.setSize(v3xFile.getSize());
            file.setType(v3xFile.getType());
            file.setAccountId(v3xFile.getAccountId());
            if(saveDB) {
                this.save(file);
            }

            return file;
        }
    }

    public void clone(Long originalFileId, Date createDate, Long newFileId, Date newCreateDate) throws BusinessException, FileNotFoundException {
        File srcFile = this.getFile(originalFileId, createDate);
        if(srcFile == null) {
            throw new FileNotFoundException("Clone附件 : [" + originalFileId + ", " + createDate + "]不存在。");
        } else {
            File destFile = this.getNewFile(newCreateDate, newFileId);

            try {
                FileUtils.copyFile(srcFile, destFile);
            } catch (IOException var8) {
                log.error("Clone文件异常 " + originalFileId, var8);
                throw new BusinessException("Clone文件异常" + var8.getMessage());
            }
        }
    }

    public List<V3XFile> create(ApplicationCategoryEnum category, HttpServletRequest request) throws BusinessException {
        String[] fileUrl = request.getParameterValues("attachment_fileUrl");
        String[] mimeType = request.getParameterValues("attachment_mimeType");
        String[] size = request.getParameterValues("attachment_size");
        String[] createdate = request.getParameterValues("attachment_createDate");
        String[] filename = request.getParameterValues("attachment_filename");
        String[] type = request.getParameterValues("attachment_type");
        String[] needClone = request.getParameterValues("attachment_needClone");
        String[] description = request.getParameterValues("attachment_description");
        if(fileUrl != null && mimeType != null && size != null && createdate != null && filename != null && type != null && needClone != null) {
            Long userId = AppContext.getCurrentUser().getId();
            Long accountId = AppContext.getCurrentUser().getAccountId();
            List<V3XFile> files = new ArrayList();

            for(int i = 0; i < fileUrl.length; ++i) {
                Date originalCreateDate = Datetimes.parseDatetime(createdate[i]);
                V3XFile file = new V3XFile();
                file.setCategory(Integer.valueOf(category.key()));
                file.setType(Integer.valueOf(type[i]));
                file.setFilename(filename[i]);
                file.setMimeType(mimeType[i]);
                file.setSize(Long.valueOf(Long.parseLong(size[i])));
                file.setDescription(description[i]);
                file.setCreateMember(userId);
                file.setAccountId(accountId);
                boolean _needClone = Boolean.parseBoolean(needClone[i]);
                if(_needClone) {
                    Long newFileId = Long.valueOf(UUIDLong.longUUID());
                    Date newCreateDate = new Date();

                    try {
                        this.clone(Long.valueOf(fileUrl[i]), originalCreateDate, newFileId, newCreateDate);
                    } catch (Exception var21) {
                        log.error("Clone 附件", var21);
                        throw new BusinessException("Clone文件异常" + var21.getMessage());
                    }

                    file.setId(newFileId);
                    file.setCreateDate(newCreateDate);
                } else {
                    file.setId(Long.valueOf(Long.parseLong(fileUrl[i])));
                    file.setCreateDate(originalCreateDate);
                }

                this.save(file);
                files.add(file);
            }

            return files;
        } else {
            return null;
        }
    }

    public V3XFile save(File file, ApplicationCategoryEnum category, String filename, Date createDate, Boolean isSaveToDB) throws BusinessException {
        if(file != null && file.exists()) {
            FileInputStream in = null;

            V3XFile var8;
            try {
                in = new FileInputStream(file);
                V3XFile v3xFile = this.save((InputStream)in, category, filename, createDate, isSaveToDB);
                var8 = v3xFile;
            } catch (Exception var12) {
                throw new BusinessException(var12);
            } finally {
                IOUtils.closeQuietly(in);
            }

            return var8;
        } else {
            throw new BusinessException("FileNotFoundException");
        }
    }

    public V3XFile save(InputStream in, ApplicationCategoryEnum category, String filename, Date createDate, Boolean isSaveToDB) throws BusinessException {
        Date cdate = createDate;
        if(in == null) {
            throw new IllegalArgumentException("in is null");
        } else {
            User user = AppContext.getCurrentUser();
            if(createDate == null) {
                cdate = new Date();
            }

            V3XFile v3xFile = new V3XFile();
            v3xFile.setIdIfNew();
            v3xFile.setCategory(Integer.valueOf(category.key()));
            v3xFile.setCreateDate(cdate);
            v3xFile.setFilename(filename);
            v3xFile.setMimeType(FileUtil.getMimeType(filename));
            v3xFile.setType(Integer.valueOf(ATTACHMENT_TYPE.FILE.ordinal()));
            v3xFile.setDescription("");
            if(user != null) {
                v3xFile.setCreateMember(user.getId());
                v3xFile.setAccountId(user.getAccountId());
            } else {
                log.debug("上传文件时当前用户为空。");
            }

            File destFile = this.getNewFile(cdate, v3xFile.getId());
            FileOutputStream out = null;

            try {
                out = new FileOutputStream(destFile);
                int count = IOUtils.copy(in, out);
                v3xFile.setSize(Long.valueOf((long)count));
                if(isSaveToDB.booleanValue()) {
                    this.save(v3xFile);
                }
            } catch (Exception var15) {
                throw new BusinessException(var15);
            } finally {
                IOUtils.closeQuietly(out);
            }

            return v3xFile;
        }
    }

    private String getNewFilepath(Date createDate, Long newFileId) throws BusinessException {
        return this.getFolder(createDate, true) + File.separator + newFileId;
    }

    private File getNewFile(Date createDate, Long newFileId) throws BusinessException {
        return new File(this.getNewFilepath(createDate, newFileId));
    }

    public File getStandardOffice(Long fileId, Date createDate) throws BusinessException {
        File f = this.getFile(fileId, createDate);
        if(f == null) {
            f = this.getFile(fileId);
            if(f == null) {
                return null;
            }
        }

        V3XFile file = this.getV3XFile(fileId);
        String newPathName2 = SystemEnvironment.getSystemTempFolder() + File.separator + f.getName() + "O" + f.lastModified();
        if(file != null) {
            String miniType = file.getMimeType();
            boolean miniTypeFlag = false;
            if(miniType != null && miniType.toLowerCase().contains("word")) {
                miniTypeFlag = true;
            }

            if(file.getFilename() != null && (file.getFilename().toLowerCase().endsWith(".doc") || file.getFilename().toLowerCase().endsWith(".docx") || miniTypeFlag)) {
                newPathName2 = newPathName2 + ".doc";
            }
        }

        File newFile = new File(newPathName2);
        if(newFile.exists()) {
            return newFile;
        } else {
            Util.jinge2StandardOffice(f.getAbsolutePath(), newPathName2);
            return newFile;
        }
    }

    public InputStream getStandardOfficeInputStream(Long fileId, Date createDate) throws BusinessException, FileNotFoundException {
        File f = this.getStandardOffice(fileId, createDate);
        if(f == null) {
            return null;
        } else {
            try {
                return new FileInputStream(f);
            } catch (FileNotFoundException var5) {
                log.warn(f.getAbsolutePath() + "不存在");
                throw var5;
            }
        }
    }

    public V3XFile clone(Long originalFileId) throws BusinessException, FileNotFoundException {
        V3XFile v3xFile = this.getV3XFile(originalFileId);
        if(v3xFile == null) {
            throw new FileNotFoundException("V3XFile : " + originalFileId + "不存在。");
        } else {
            Long newFileId = Long.valueOf(UUIDLong.longUUID());
            Date newCreateDate = new Date();
            this.clone(originalFileId, v3xFile.getCreateDate(), newFileId, newCreateDate);
            V3XFile file = new V3XFile();
            file.setId(newFileId);
            file.setCreateDate(newCreateDate);
            file.setCategory(v3xFile.getCategory());
            file.setDescription(v3xFile.getDescription());
            file.setCreateMember(v3xFile.getCreateMember());
            file.setFilename("copy" + v3xFile.getFilename());
            file.setMimeType(v3xFile.getMimeType());
            file.setSize(v3xFile.getSize());
            file.setType(v3xFile.getType());
            file.setAccountId(v3xFile.getAccountId());
            this.save(file);
            return file;
        }
    }

    public List<V3XFile> findByFileName(String fileName) {
        return this.v3xFileDAO.findByFileName(fileName);
    }

    public void update(V3XFile file) {
        this.v3xFileDAO.update(file);
    }

    public Long copyFileBeforeModify(Long fileId) {
        try {
            return this.clone(fileId, true).getId();
        } catch (FileNotFoundException var3) {
            log.error(var3.getMessage(), var3);
            return Long.valueOf(-1L);
        } catch (BusinessException var4) {
            log.error(var4.getMessage(), var4);
            return Long.valueOf(-1L);
        }
    }

    public Long getFileIdByDocResSourceId(Long fileId) {
        try {
            return this.getV3XFile(fileId).getId();
        } catch (BusinessException var3) {
            log.error(var3.getMessage(), var3);
            return Long.valueOf(-1L);
        }
    }

    public void copyWPS(Long sourceId) {
        try {
            V3XFile file = this.getV3XFile(sourceId);
            String filePath = this.getFolder(file.getCreateDate(), true) + File.separator + sourceId;
            String now = Datetimes.format(new Date(), "yyyyMMddHHmmss", TimeZone.getDefault());
            String contentFileBak = filePath + "_" + now + ".bak";
            File f = new File(filePath);
            if(f.exists()) {
                FileUtils.copyFile(f, new File(contentFileBak));
            }
        } catch (Exception var7) {
            log.error("WPS正文内容备份异常 ：" + sourceId, var7);
        }

    }

    public File getStandardOffice(String fileAbsolutePath) throws BusinessException {
        if(StringUtils.isBlank(fileAbsolutePath)) {
            throw new BusinessException("传入文件路径为空");
        } else {
            String newPathName = SystemEnvironment.getSystemTempFolder() + File.separator + UUIDLong.longUUID();
            Util.jinge2StandardOffice(fileAbsolutePath, newPathName);
            return new File(newPathName);
        }
    }

    public static void main(String[] args) throws Exception {
        String p = "D:\\Working@seeyon\\Runtime\\ApacheJetspeed\\webapps\\seeyon\\main\\login\\default\\images\\banner2";

        for(int i = 1; i < 11; ++i) {
            int s = i * 100;
            ImageUtil.resize(p + ".png", "d:\\aaa_" + s + ".png", s, s);
        }

    }
}
