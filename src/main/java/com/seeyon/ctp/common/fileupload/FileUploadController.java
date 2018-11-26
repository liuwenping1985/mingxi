//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.common.fileupload;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserHelper;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.NoSuchPartitionException;
import com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE;
import com.seeyon.ctp.common.filemanager.event.FileDownloadEvent;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.FileSecurityManager;
import com.seeyon.ctp.common.filemanager.manager.PartitionManager;
import com.seeyon.ctp.common.fileupload.bean.FileProperties;
import com.seeyon.ctp.common.fileupload.bean.FileServicePartition;
import com.seeyon.ctp.common.fileupload.bean.FileServiceRequestBean;
import com.seeyon.ctp.common.fileupload.bean.FileServiceResponseBean;
import com.seeyon.ctp.common.fileupload.bean.StatusCode;
import com.seeyon.ctp.common.fileupload.bean.Thresholds;
import com.seeyon.ctp.common.fileupload.util.FileServiceUtil;
import com.seeyon.ctp.common.fileupload.util.FileUploadUtil;
import com.seeyon.ctp.common.fileupload.util.FileServiceUtil.ModeEnum;
import com.seeyon.ctp.common.fileupload.util.FileServiceUtil.RequestTypeEnum;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.Partition;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.web.util.WebUtil;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.EnumUtil;
import com.seeyon.ctp.util.FileUtil;
import com.seeyon.ctp.util.HttpClientUtil;
import com.seeyon.ctp.util.OperationControllable;
import com.seeyon.ctp.util.OperationCounter;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.SetContentType;
import com.seeyon.ctp.util.json.JSONUtil;

import java.io.*;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.seeyon.v3x.dee.common.base.util.MD5;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.commons.logging.Log;

import org.springframework.web.servlet.ModelAndView;
import www.seeyon.com.utils.MD5Util;

public class FileUploadController extends BaseController {
    private static final Log log = CtpLogFactory.getLog(FileUploadController.class);
    private static Integer maxDownloadConnections = SystemProperties.getInstance().getIntegerProperty("fileDowload.maxConnections", '\uffff');
    private static OperationControllable downloadCounter;
    private static Map<String, String> RTE_type;
    private static final String HEADER_IFMODSINCE = "If-Modified-Since";
    private static final String HEADER_LASTMOD = "Last-Modified";
    private static final long Etag_CacheDate = 302400000L;
    private FileManager fileManager;
    private AttachmentManager attachmentManager;
    private FileSecurityManager fileSecurityManager;
    private PartitionManager partitionManager;
    private String clientAbortExceptionName = "ClientAbortException";
    private String contentTypeCharset = "UTF-8";
    private String htmlSuffix;

    public FileUploadController() {
    }

    public void setFileSecurityManager(FileSecurityManager fileSecurityManager) {
        this.fileSecurityManager = fileSecurityManager;
    }

    public FileUploadBreakPointService getFubps() {
        return fubps;
    }

    private FileUploadBreakPointService fubps = new FileUploadBreakPointService();

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setPartitionManager(PartitionManager partitionManager) {
        this.partitionManager = partitionManager;
    }

    public void setHtmlSuffix(String htmlSuffix) {
        this.htmlSuffix = htmlSuffix;
    }

    public void setClientAbortExceptionName(String clientAbortExceptionName) {
        this.clientAbortExceptionName = clientAbortExceptionName;
    }

    public ModelAndView processUpload(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = null;
        String userAgent = request.getHeader("User-Agent");
        if(userAgent == null || !userAgent.toUpperCase().contains("IE") && !userAgent.toUpperCase().contains("RV:11")) {
            modelAndView = new ModelAndView("ctp/common/fileUpload/upload");
        } else {
            modelAndView = new ModelAndView("ctp/common/fileUpload/uploadForGeniues");
        }

        String extensions = request.getParameter("extensions");
        String applicationCategory = request.getParameter("applicationCategory");
        String typeStr = request.getParameter("type");
        String firstSave = request.getParameter("firstSave") == null?"":request.getParameter("firstSave");
        String maxSizeStr = request.getParameter("maxSize");
        String from = request.getParameter("from");
        ATTACHMENT_TYPE type = null;
        if(StringUtils.isNotBlank(typeStr)) {
            type = (ATTACHMENT_TYPE)EnumUtil.getEnumByOrdinal(ATTACHMENT_TYPE.class, Integer.valueOf(typeStr).intValue());
        } else {
            type = ATTACHMENT_TYPE.FILE;
        }

        if(StringUtils.isBlank(firstSave)) {
            firstSave = "false";
        }

        ApplicationCategoryEnum category = null;
        if(StringUtils.isNotBlank(applicationCategory)) {
            category = ApplicationCategoryEnum.valueOf(Integer.valueOf(applicationCategory).intValue());
        } else {
            category = ApplicationCategoryEnum.global;
            log.warn("上传文件：v3x:fileUpload没有设定applicationCategory属性，将设置为‘全局’。");
        }

        Long maxSize = Long.valueOf(Long.parseLong(SystemProperties.getInstance().getProperty("fileUpload.maxSize")));
        if(StringUtils.isNotBlank(maxSizeStr)) {
            maxSize = Long.valueOf(maxSizeStr);
        }

        Map v3xFiles = null;

        try {
            v3xFiles = this.fileManager.uploadFiles(request, extensions, maxSize);
            if(v3xFiles != null) {
                List<String> keys = new ArrayList(v3xFiles.keySet());
                Collections.sort(keys, new FileUploadController.FileFieldComparator());
                List<Attachment> atts = new ArrayList();
                Iterator var17 = keys.iterator();

                while(var17.hasNext()) {
                    String key = (String)var17.next();
                    Attachment att = new Attachment((V3XFile)v3xFiles.get(key), category, type);
                    atts.add(att);
                }

                if("true".equalsIgnoreCase(firstSave)) {
                    this.attachmentManager.create(atts);
                }

                modelAndView.addObject("atts", atts);
                HttpSession session = request.getSession();
                session.setAttribute("repeat", request.getParameter("repeat"));
                if(from != null && "a8genius".equals(from)) {
                    response.setContentType("text/html;charset=UTF-8");
                    PrintWriter out = response.getWriter();
                    String jsonStr = JSONUtil.toJSONString(atts);
                    out.println(jsonStr);
                    out.flush();
                    return null;
                }
            }
        } catch (NoSuchPartitionException var20) {
            log.error("", var20);
            modelAndView.addObject("e", var20);
        } catch (BusinessException var21) {
            log.error(var21.getLocalizedMessage(), var21);
            modelAndView.addObject("e", var21);
        } catch (Exception var22) {
            log.error("", var22);
            modelAndView.addObject("e", new BusinessException("fileupload.exception.unknown", new Object[]{var22.getMessage()}));
        }

        return modelAndView;
    }

    @SetContentType
    public ModelAndView showRTE(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long fileId = Long.valueOf(request.getParameter("fileId"));
        User user = AppContext.getCurrentUser();
        String ucFlag = request.getParameter("ucFlag");
        if(user == null) {
            boolean accessDenied = true;
            if(UserHelper.isFromMicroCollaboration(request)) {
                accessDenied = false;
            } else if("yes".equals(ucFlag)) {
                V3XFile f = this.fileManager.getV3XFile(fileId);
                if(f != null && ApplicationCategoryEnum.uc.getKey() == f.getCategory().intValue()) {
                    accessDenied = false;
                }
            } else if(this.fileSecurityManager != null) {
                accessDenied = !this.fileSecurityManager.isNeedlessLogin(fileId);
            }

            if(accessDenied) {
                response.setStatus(404);
                return null;
            }
        }

        String small = (String)Strings.escapeNULL(request.getParameter("showType"), "");
        String smallPX = (String)Strings.escapeNULL(request.getParameter("smallPX"), "");
        String etag = fileId + small + smallPX;
        if(WebUtil.checkEtag(request, response, etag)) {
            return null;
        } else {
            Date createDate = null;
            if(Strings.isNotBlank(request.getParameter("createDate"))) {
                createDate = Datetimes.parseDate(request.getParameter("createDate"));
            } else {
                V3XFile f = this.fileManager.getV3XFile(fileId);
                if(f == null) {
                    response.setStatus(404);
                    return null;
                }

                createDate = f.getCreateDate();
            }

            String type = request.getParameter("type");
            if(type != null && type.startsWith("flash")) {
                type = "flash";
            }

            String mimeType = (String)RTE_type.get(type);
            if(mimeType == null) {
                response.setStatus(404);
                return null;
            } else {
                WebUtil.writeETag(request, response, etag, 302400000L);
                response.setContentType(mimeType);
                File f = null;
                if(!"small".equals(small)) {
                    if("yes".equals(ucFlag)) {
                        f = this.fileManager.getFileForUC(fileId, createDate);
                    } else {
                        f = this.fileManager.getFile(fileId, createDate);
                    }
                } else if(Strings.isNotBlank(smallPX)) {
                    if("yes".equals(ucFlag)) {
                        f = this.fileManager.getThumFileForUC(fileId, createDate, smallPX);
                    } else {
                        f = this.fileManager.getThumFile(fileId, createDate, Integer.parseInt(smallPX));
                    }
                } else if("yes".equals(ucFlag)) {
                    f = this.fileManager.getThumFileForUC(fileId, createDate, smallPX);
                } else {
                    f = this.fileManager.getThumFile(fileId, createDate);
                }

                if(f == null) {
                    return null;
                } else {
                    InputStream in = null;
                    ServletOutputStream out = response.getOutputStream();

                    try {
                        in = new FileInputStream(f);
                        if(in != null) {
                            CoderFactory.getInstance().download(in, out);
                        }
                    } catch (FileNotFoundException var20) {
                        log.warn(var20);
                    } catch (Exception var21) {
                        if(var21.getClass().getSimpleName().equals(this.clientAbortExceptionName)) {
                            log.debug("用户关闭下载窗口: " + var21.getMessage());
                        } else {
                            log.error("", var21);
                        }
                    } finally {
                        IOUtils.closeQuietly(in);
                        IOUtils.closeQuietly(out);
                    }

                    return null;
                }
            }
        }
    }

    public ModelAndView download(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView m = new ModelAndView("ctp/common/fileUpload/download");
        String filename;
        if(this.isRemoteDownload(request)) {
            String ticket = FileServiceUtil.generateDownloadTicket(Long.valueOf(request.getParameter("fileId")).longValue());
            filename = this.generateRemoteDownloadUrl(request, ticket);
            if(filename != null) {
                response.sendRedirect(filename);
                return null;
            }
        }

        if(!downloadCounter.check()) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script>alert('" + ResourceUtil.getStringByParams("fileuoload.downoad.exceedConnection", new Object[]{maxDownloadConnections}) + "');</script>");
            return null;
        } else {
            downloadCounter.start();
            Map<String, String> ps = this.getParameterMap(request);
            m.addObject("ps", ps);
            filename = request.getParameter("filename");
            String suffix = FilenameUtils.getExtension(filename).toLowerCase();
            String from = request.getParameter("from");
            if(from != null && "a8geniues".equals(from)) {
                m.addObject("isHTML", Boolean.valueOf(Pattern.matches(this.htmlSuffix, suffix)));
            } else if(Pattern.matches(this.htmlSuffix, suffix) && !"mobile".equals(from)) {
                m.addObject("isHTML", Boolean.valueOf(true));
            }

            return m;
        }
    }

    private boolean isRemoteDownload(HttpServletRequest request) {
        String isSystemRecieveForm = request.getParameter("isSystemForm");
        String isSystemRedTemplete = request.getParameter("isSystemRedTemplete");
        String isInfoTemplate = request.getParameter("isInfoTemplate");
        String fileId = request.getParameter("fileId");
        if(!FileServiceUtil.isRemoteMode()) {
            return false;
        } else if("true".equals(request.getParameter("forceLocalDownload"))) {
            return false;
        } else {
            int appType = request.getParameter("appType") == null?0:Integer.parseInt(request.getParameter("appType"));
            return "true".equals(isSystemRecieveForm)?false:("true".equals(isSystemRedTemplete)?false:("true".equals(isInfoTemplate)?false:!"607151236662539448".equals(fileId) || appType != ApplicationCategoryEnum.info.key()));
        }
    }

    private Map<String, String> getParameterMap(HttpServletRequest request) {
        Map<String, String> ps = new HashMap();
        Enumeration params = request.getParameterNames();

        while(params.hasMoreElements()) {
            String name = (String)params.nextElement();
            if(!"method".equalsIgnoreCase(name)) {
                String value = request.getParameter(name);
                ps.put(name, value);
            }
        }

        return ps;
    }

    public ModelAndView doDownload4html(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return (new FileUploadController.FileDownloader(request, response) {
            void setOutput() {
                String swf = this.request.getParameter("swf");
                if("true".equals(swf)) {
                    this.setFlashContenttype();
                } else {
                    this.setDownloadContentType(this.response, this.filename, "attachment", "application/octet-stream");
                }

            }

            void getInputstream() throws Exception {
                String comm = this.request.getParameter("comm");
                if("byFileId".equals(comm)) {
                    V3XFile v3xfile = FileUploadController.this.fileManager.getV3XFile(this.fileId);
                    this.createDate = v3xfile.getCreateDate();
                    this.filename = v3xfile.getFilename();
                } else {
                    this.createDate = Datetimes.parseDate(this.request.getParameter("createDate"));
                    this.filename = this.request.getParameter("filename");
                    this.filename = new String(this.filename.getBytes(), "iso8859-1");
                }

                this.in = FileUploadController.this.fileManager.getFileInputStream(this.fileId, this.createDate);
            }
        }).download();
    }

    @SetContentType
    public ModelAndView doDownload4Office(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return (new FileUploadController.FileDownloader(request, response) {
            void setOutput() {
                String type = this.request.getParameter("type");
                String fileName = FileUploadUtil.getOfficeName(this.fileId, type);
                String attachment = "true".equals(this.request.getParameter("isOpenFile"))?"":"attachment";
                this.setDownloadContentType(this.response, fileName, attachment, FileUploadUtil.getOfficeHeader(type));
            }

            void getInputstream() throws Exception {
                String comm = this.request.getParameter("comm");
                if("byFileId".equals(comm)) {
                    V3XFile v3xfile = FileUploadController.this.fileManager.getV3XFile(this.fileId);
                    this.createDate = v3xfile.getCreateDate();
                } else {
                    this.createDate = Datetimes.parseDate(this.request.getParameter("createDate"));
                }

                this.in = FileUploadController.this.fileManager.getStandardOfficeInputStream(this.fileId, this.createDate);
            }
        }).download();
    }

    @SetContentType
    public ModelAndView doDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return (new FileUploadController.FileDownloader(request, response) {
            protected boolean beforeDownload() throws Exception {
                return true;
            }

            void setOutput() {
                String swf = this.request.getParameter("swf");
                if("true".equals(swf)) {
                    this.setFlashContenttype();
                } else {
                    if(!"mobile".equals(this.request.getParameter("from"))) {
                        this.contentType = "application/octet-stream";
                    }

                    this.setDownloadContentType(this.response, this.filename, "attachment", this.contentType);
                }

            }

            void getInputstream() throws BusinessException {
                String comm = this.request.getParameter("comm");
                V3XFile v3xfile;
                if("byFileId".equals(comm)) {
                    v3xfile = this.getFile();
                    this.createDate = v3xfile.getCreateDate();
                    this.filename = v3xfile.getFilename();

                    try {
                        this.filename = URLEncoder.encode(this.filename, "UTF-8");
                    } catch (UnsupportedEncodingException var5) {
                        FileUploadController.log.error(var5);
                    }
                } else if("mobile".equals(this.request.getParameter("from"))) {
                    v3xfile = this.getFile();
                    this.contentType = v3xfile.getMimeType();
                    this.createDate = v3xfile.getCreateDate();
                    this.filename = FileUploadUtil.escapeFileName(v3xfile);
                } else {
                    this.createDate = Datetimes.parseDate(this.request.getParameter("createDate"));
                    this.filename = this.request.getParameter("filename");
                    this.filename = FileUtil.getDownloadFileName(this.request, this.filename);
                }

                this.in = this.appsPreHandle();
                if(this.in == null) {
                    long openfileStart = System.currentTimeMillis();
                    this.in = FileUploadController.this.fileManager.getFileInputStream(this.fileId, this.createDate);
                    if(this.in == null) {
                        V3XFile v3xfilex = this.getFile();
                        this.createDate = v3xfilex.getCreateDate();
                        this.in = FileUploadController.this.fileManager.getFileInputStream(this.fileId, this.createDate);
                    }

                    if(this.in == null) {
                        this.response.addHeader("filestatus", "no");
                    }

                    if(System.currentTimeMillis() - openfileStart > 1000L) {
                        FileUploadController.log.warn("文件系统打开附件过慢！耗时：" + (System.currentTimeMillis() - openfileStart));
                    }
                }

            }

            private InputStream appsPreHandle() throws BusinessException {
                String isSystemRecieveForm = this.request.getParameter("isSystemForm");
                String isSystemRedTemplete = this.request.getParameter("isSystemRedTemplete");
                String isInfoTemplate = this.request.getParameter("isInfoTemplate");
                int appType = this.request.getParameter("appType") == null?0:Integer.parseInt(this.request.getParameter("appType"));
                String folder;
                String systemFormId;
                String tempType;
                if("true".equals(isSystemRecieveForm)) {
                    try {
                        folder = this.request.getParameter("formType");
                        systemFormId = "-2921628185995099164";
                        tempType = "edoc.folder";
                        if(appType == ApplicationCategoryEnum.info.key()) {
                            tempType = "govform.folder";
                            systemFormId = "607151236662539448";
                        } else {
                            tempType = "edoc.folder";
                            if("0".equals(folder)) {
                                systemFormId = "6071519916662539448";
                            } else if("1".equals(folder)) {
                                systemFormId = "-2921628185995099164";
                            } else if("10".equals(folder)) {
                                systemFormId = "-2921628185995099166";
                            } else {
                                systemFormId = "-1766191165740134579";
                            }
                        }

                        return new FileInputStream(new File(SystemProperties.getInstance().getProperty(tempType) + File.separator + "form" + File.separator + systemFormId));
                    } catch (Exception var8) {
                        return FileUploadController.this.fileManager.getFileInputStream(this.fileId, this.createDate);
                    }
                } else if("true".equals(isSystemRedTemplete)) {
                    try {
                        return new FileInputStream(new File(SystemProperties.getInstance().getProperty("edoc.folder") + File.separator + "template" + File.separator + "-6001972826857714844"));
                    } catch (Exception var9) {
                        return FileUploadController.this.fileManager.getFileInputStream(this.fileId, this.createDate);
                    }
                } else if("true".equals(isInfoTemplate)) {
                    try {
                        StringBuffer filePathBuff = new StringBuffer(SystemProperties.getInstance().getProperty("infosend.folder"));
                        systemFormId = "";
                        tempType = this.request.getParameter("tempType");
                        if("0".equals(tempType)) {
                            systemFormId = "template/5282854121826306408";
                        }

                        filePathBuff.append(File.separator);
                        filePathBuff.append(systemFormId);
                        return new FileInputStream(new File(filePathBuff.toString()));
                    } catch (Exception var10) {
                        return FileUploadController.this.fileManager.getFileInputStream(this.fileId, this.createDate);
                    }
                } else if("607151236662539448".equals(this.fileId.toString()) && appType == ApplicationCategoryEnum.info.key()) {
                    folder = "govform.folder";
                    systemFormId = "607151236662539447";

                    try {
                        return new FileInputStream(new File(SystemProperties.getInstance().getProperty(folder) + File.separator + "form" + File.separator + systemFormId));
                    } catch (FileNotFoundException var11) {
                        return FileUploadController.this.fileManager.getFileInputStream(this.fileId, this.createDate);
                    }
                } else {
                    return null;
                }
            }
        }).download();
    }

    private static void showError(String error, BusinessException e, ServletOutputStream out, HttpServletRequest request, HttpServletResponse response) {
        response.setContentType("text/html;charset=UTF-8");
        String message = null;
        if(error != null) {
            message = ResourceUtil.getString("fileupload.document." + error);
        }

        if(e != null) {
            message = ResourceUtil.getString("fileupload.document.Exception");
        }

        response.addHeader("Rang", "-1");
        if(message != null) {
            PrintWriter writer = new PrintWriter(out);
            writer.println("<script type=\"text/javascript\">");
            String str = Strings.escapeJavascript(message);

            String encode;
            try {
                encode = URLEncoder.encode(str, "UTF-8");
            } catch (UnsupportedEncodingException var10) {
                encode = URLEncoder.encode(str);
            }

            writer.println("alert(decodeURI(\"" + encode + "\"));");
            if("blank".equals(request.getParameter("from"))) {
                writer.println("window.open(\"/closeIE7.htm\", \"_self\");");
            }

            writer.println("</script>");
            if("mobile".equals(request.getParameter("from"))) {
                writer.println(message);
                writer.println("<html><head>");
                writer.println("<meta http-equiv=\"Refresh\" content=\"3;url=mob.do?method=showAffairs\">");
                writer.println("</head></html>");
            }

            writer.flush();
            writer.close();
        }

    }

    public ModelAndView deleteFile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("ctp/common/fileUpload/upload");

        try {
            Long fileId = Long.valueOf(Long.parseLong(request.getParameter("fileId")));
            Date createDate = Datetimes.parseDatetime(request.getParameter("createDate"));
            this.fileManager.deleteFile(fileId, createDate, Boolean.valueOf(true));
        } catch (Exception var6) {
            ;
        }

        return modelAndView;
    }

    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = null;
        User user = AppContext.getCurrentUser();
        String userAgent = request.getHeader("User-Agent");
        if(!user.isV5Member() || userAgent == null || !userAgent.toUpperCase().contains("IE") && !userAgent.toUpperCase().contains("RV:11")) {
            modelAndView = new ModelAndView("ctp/common/fileUpload/upload");
        } else {
            //modelAndView = new ModelAndView("ctp/common/fileUpload/uploadForGeniues");
            modelAndView = new ModelAndView("ctp/common/fileUpload/upload");

        }

        String isA8geniusAdded = request.getParameter("isA8geniusAdded");
        modelAndView.addObject("isA8geniusAdded", isA8geniusAdded);
        String str = FileuploadManagerImpl.getMaxSizeStr();
        modelAndView.addObject("maxSize", str);
        return modelAndView;
    }

    public ModelAndView indexforForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("ctp/common/fileUpload/uploadForForm");
        String isA8geniusAdded = request.getParameter("isA8geniusAdded");
        modelAndView.addObject("isA8geniusAdded", isA8geniusAdded);
        String str = FileuploadManagerImpl.getMaxSizeStr();
        modelAndView.addObject("maxSize", str);
        return modelAndView;
    }

    public ModelAndView indexforFormImage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("ctp/common/fileUpload/upLoadImage");
        String isA8geniusAdded = request.getParameter("isA8geniusAdded");
        modelAndView.addObject("isA8geniusAdded", isA8geniusAdded);
        String str = FileuploadManagerImpl.getMaxSizeStr();
        modelAndView.addObject("maxSize", str);
        return modelAndView;
    }

    public ModelAndView getFileServiceCofig(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        if(user != null && !user.isSystemAdmin()) {
            StringBuilder sb = new StringBuilder(ResourceUtil.getStringByParams("loginUserState.wuquanfangwen", new Object[0]));
            BusinessException be = new BusinessException(sb.toString());
            be.setCode("invalid_resource_code");
            be.setFullPage(true);
            throw be;
        } else {
            ModelAndView modelAndView = new ModelAndView("ctp/common/fileUpload/serviceConfig");
            this.loadOriginConfig(modelAndView);
            return modelAndView;
        }
    }
    private DataBaseHandler handler = DataBaseHandler.getInstance();


    public ModelAndView qfup(HttpServletRequest request, HttpServletResponse response){
        Map ret = new HashMap();
        Long userId=AppContext.getCurrentUser().getId();
        String fName = request.getParameter("fName");
        String fSize = request.getParameter("fSize");
        String md5 = userId+"_"+fName+"_"+fSize;
        handler.createNewDataBaseByNameIfNotExist("FILE_UPLOAD");

        try {

            String md5Name = MD5Util.bytetoString(md5.getBytes("utf-8"));
            Object data = handler.getDataByKey("FILE_UPLOAD",md5Name);
            File f = this.getFubps().getCommonFile(fName,fSize,userId);

            if(data==null){
                ret.put("hasProcess",false);
                if(f.exists()){
                    f.delete();
                }

            }else{
                ret.put("hasProcess",true);
                if(!f.exists()){
                    ret.put("hasProcess",false);
                }else{
                    //检查文件大小和当前数是否一致
                    RandomAccessFile raf = this.getFubps().getBrFile(fName,fSize,userId);
                    Long curSize = Long.parseLong(String.valueOf(data));
                    //ok的
                    if(curSize.longValue()==raf.length()){
                        raf.close();
                        ret.put("currentSize",data);
                    }else{
                        raf.close();
                        f.delete();
                        handler.putData("FILE_UPLOAD",md5Name,0);
                        ret.put("currentSize",0L);
                    }
                }

            }
        } catch (Exception e) {

        }

        //handler.getDataByKey()
        ret.put("result",true);
        responseJSON(ret,response);
        return null;
    }

    public ModelAndView tempUpload(HttpServletRequest request, HttpServletResponse response){
        Map ret = new HashMap();
        try {
            String dataSizeStr = request.getParameter("dataSize");
            String start = request.getParameter("start");
            String end = request.getParameter("end");
            String fName = request.getParameter("fName");
            String fSize = request.getParameter("fSize");
            Long userId = AppContext.getCurrentUser().getId();

            if(start==null||end==null){
                throw new BusinessException("断点错误");
            }
            Integer st = Integer.parseInt(start);
            Integer ed = Integer.parseInt(end);
            Integer dataSize = ed-st;

            InputStream ins = request.getInputStream();
            if(ins!=null){
                byte[] buffer = new byte[dataSize];
                int len =-1;
                int size=0;
                RandomAccessFile raf = fubps.getBrFile(fName,fSize,userId);
                raf.seek(st);
                while((len=ins.read(buffer))>0){

                    size+=len;

                    raf.write(buffer,0,len);


                }
                ret.put("raf_size",raf.length());
                raf.close();
                String md5 = userId+"_"+fName+"_"+fSize;
                String md5Name = MD5Util.bytetoString(md5.getBytes("utf-8"));
                handler.putData("FILE_UPLOAD",md5Name,ed);
                ret.put("size",size);
            }
            if(end.equals(fSize)){
                //上传完了
            }
            ret.put("start",start);
            ret.put("end",end);
            ret.put("uerId",userId);
            ret.put("fName",fName);
            ret.put("fSize",fSize);
        } catch (Exception e) {
            e.printStackTrace();
        }
        ret.put("result",true);
        responseJSON(ret,response);
        return null;
    }






    private static void responseJSON(Object data, HttpServletResponse response)
    {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control",
                "no-store, max-age=0, no-cache, must-revalidate");
        response.addHeader("Cache-Control", "post-check=0, pre-check=0");
        response.setHeader("Pragma", "no-cache");
        PrintWriter out = null;

        try
        {
            out = response.getWriter();
            out.write(JSON.toJSONString(data));
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }finally{
            try {
                if (out != null) {
                    out.close();
                }
            }finally {

            }

        }
    }

    public ModelAndView updateFileServiceCofig(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("ctp/common/fileUpload/serviceConfig");
        String flag = request.getParameter("flag");
        String serverIp = request.getParameter("serverIp");
        int serverPort = Integer.parseInt(request.getParameter("serverPort"));
        String maxDownloadNumStr = request.getParameter("maxDownloadNum");
        boolean originRemoteMode = FileServiceUtil.isRemoteMode();
        FileServiceUtil.switchToMode("on".equals(flag)?ModeEnum.REMOTE:ModeEnum.LOCAL);
        FileServiceUtil.ip = serverIp;
        FileServiceUtil.port = serverPort;
        modelAndView.addObject("flag", flag);
        modelAndView.addObject("serverIp", serverIp);
        modelAndView.addObject("serverPort", Integer.valueOf(serverPort));
        int maxDownloadNum;
        if(StringUtils.isNotEmpty(maxDownloadNumStr)) {
            maxDownloadNum = Integer.parseInt(maxDownloadNumStr);
            modelAndView.addObject("maxDownloadNum", Integer.valueOf(maxDownloadNum));
        }

        modelAndView.addObject("showMsg", "menu.system.service.file.setting.ok");
        modelAndView.addObject("localMaxDownloadNum", SystemProperties.getInstance().getIntegerProperty("fileDowload.maxConnections"));
        if(FileServiceUtil.isRemoteMode() && StringUtils.isNotEmpty(serverIp)) {
            if(StringUtils.isNotEmpty(maxDownloadNumStr)) {
                maxDownloadNum = Integer.parseInt(maxDownloadNumStr);
                modelAndView.addObject("maxDownloadNum", Integer.valueOf(maxDownloadNum));
                Thresholds thresholds = new Thresholds();
                thresholds.setDownloadNum(maxDownloadNum);

                try {

                    int status;
                    if(originRemoteMode) {
                        status = this.setFileServiceThresholds(FileServiceUtil.getRequestUrl(RequestTypeEnum.SET_THRESHOLD), thresholds);
                    } else {
                        status = this.updateFileServiceConfig(thresholds);
                    }

                    if(status != 0) {
                        modelAndView.addObject("showMsg", StatusCode.getDesc(status));
                        FileServiceUtil.loadProperties();
                        this.loadOriginConfig(modelAndView);
                        return modelAndView;
                    }
                } catch (IOException var12) {
                    modelAndView.addObject("showMsg", "menu.system.service.file.connect.fail.hint");
                    FileServiceUtil.loadProperties();
                    this.loadOriginConfig(modelAndView);
                    return modelAndView;
                }
            }
        } else {
            FileServiceUtil.switchToMode(ModeEnum.LOCAL);
        }

        if(!FileServiceUtil.saveToProperties()) {
            modelAndView.addObject("showMsg", "menu.system.service.file.connect.fail.hint");
            FileServiceUtil.loadProperties();
            this.loadOriginConfig(modelAndView);
            return modelAndView;
        } else {
            return modelAndView;
        }
    }

    private void loadOriginConfig(ModelAndView modelAndView) {
        modelAndView.addObject("flag", FileServiceUtil.isRemoteMode()?"on":"off");
        modelAndView.addObject("serverIp", FileServiceUtil.ip);
        modelAndView.addObject("serverPort", Integer.valueOf(FileServiceUtil.port));
        modelAndView.addObject("localMaxDownloadNum", SystemProperties.getInstance().getIntegerProperty("fileDowload.maxConnections"));
        if(FileServiceUtil.isRemoteMode()) {
            try {
                Thresholds thretholds = this.getFileServiceThresholds(FileServiceUtil.getRequestUrl(RequestTypeEnum.GET_THRESHOLD));
                if(thretholds != null) {
                    int maxDownloadNum = thretholds.getDownloadNum();
                    modelAndView.addObject("maxDownloadNum", Integer.valueOf(maxDownloadNum));
                } else {
                    modelAndView.addObject("showMsg", "menu.system.service.file.connect.fail.hint");
                    FileServiceUtil.switchToMode(ModeEnum.LOCAL);
                }
            } catch (IOException var4) {
                modelAndView.addObject("showMsg", "menu.system.service.file.connect.fail.hint");
                FileServiceUtil.switchToMode(ModeEnum.LOCAL);
            }
        }

    }

    private Thresholds getFileServiceThresholds(String reqUrl) throws IOException {
        FileServiceResponseBean resBean = null;
        HttpClientUtil httpClient = new HttpClientUtil(5000);

        try {
            httpClient.openGet(reqUrl);
            int status = httpClient.send();
            if(status != 200) {
                Object var5 = null;
                return (Thresholds)var5;
            }

            resBean = (FileServiceResponseBean)httpClient.getResponseJsonAsObject(FileServiceResponseBean.class);
        } catch (IOException var9) {
            throw var9;
        } finally {
            httpClient.close();
        }

        return resBean != null?resBean.getThresholds():null;
    }

    private int setFileServiceThresholds(String reqUrl, Thresholds thresholds) throws IOException {
        FileServiceRequestBean reqBean = new FileServiceRequestBean();
        reqBean.setThresholds(thresholds);
        HttpClientUtil httpClient = new HttpClientUtil(5000);

        int var7;
        try {
            httpClient.openPost(reqUrl);
            httpClient.setRequestBodyJson(reqBean);
            int status = httpClient.send();
            if(status != 200) {
                int var13 = status;
                return var13;
            }

            FileServiceResponseBean resBean = (FileServiceResponseBean)httpClient.getResponseJsonAsObject(FileServiceResponseBean.class);
            if(resBean.getStatus() == 0) {
                return 0;
            }

            var7 = resBean.getStatus();
        } catch (IOException var11) {
            throw var11;
        } finally {
            httpClient.close();
        }

        return var7;
    }

    private void addRemoteDownloadTicket(String reqUrl, String ticket, FileProperties fileProperties) throws IOException {
        FileServiceRequestBean reqBean = new FileServiceRequestBean();
        reqBean.setTicket(ticket);
        reqBean.setFileProperties(fileProperties);
        HttpClientUtil httpClient = new HttpClientUtil(5000);

        try {
            httpClient.openPost(reqUrl);
            httpClient.setRequestBodyJson(reqBean);
            int status = httpClient.send();
            if(status == 200) {
                ;
            }
        } catch (IOException var10) {
            throw var10;
        } finally {
            httpClient.close();
        }

    }

    private String generateRemoteDownloadUrl(HttpServletRequest request, String ticket) throws BusinessException {
        String downUrl = FileServiceUtil.getRequestUrl(RequestTypeEnum.FILE_DOWNLOAD);
        String comm = request.getParameter("comm");
        long fileId = Long.valueOf(request.getParameter("fileId")).longValue();
        Date createDate = null;
        String filename = null;
        V3XFile v3xfile;
        if("byFileId".equals(comm)) {
            v3xfile = this.fileManager.getV3XFile(Long.valueOf(fileId));
            createDate = v3xfile.getCreateDate();
            filename = v3xfile.getFilename();

            try {
                filename = URLEncoder.encode(filename, "UTF-8");
            } catch (UnsupportedEncodingException var12) {
                log.error(var12);
            }
        } else if("mobile".equals(request.getParameter("from"))) {
            v3xfile = this.fileManager.getV3XFile(Long.valueOf(fileId));
            createDate = v3xfile.getCreateDate();
            filename = FileUploadUtil.escapeFileName(v3xfile);
        } else {
            createDate = Datetimes.parseDate(request.getParameter("createDate"));
            filename = FileUtil.getDownloadFileName(request, request.getParameter("filename"));
        }

        downUrl = downUrl + "/" + DateFormatUtils.format(createDate, "yyyy/MM/dd") + "/" + fileId;
        FileProperties fileProperties = new FileProperties();
        fileProperties.setFileId(fileId);
        fileProperties.setFileName(filename);

        try {
            this.addRemoteDownloadTicket(FileServiceUtil.getRequestUrl(RequestTypeEnum.ADD_TICKET), ticket, fileProperties);
        } catch (IOException var11) {
            return null;
        }

        downUrl = downUrl + "?ticket=" + ticket;
        return downUrl;
    }

    private int updateFileServiceConfig(Thresholds thresholds) throws IOException {
        FileServiceRequestBean reqBean = new FileServiceRequestBean();
        reqBean.setThresholds(thresholds);
        List<FileServicePartition> partitions = new ArrayList();
        List<Partition> partitionlist = this.partitionManager.getAllPartitions();
        Iterator var5 = partitionlist.iterator();

        while(var5.hasNext()) {
            Partition originPartition = (Partition)var5.next();
            partitions.add(new FileServicePartition(originPartition));
        }

        reqBean.setPartitionList(partitions);
        HttpClientUtil httpClient = new HttpClientUtil(5000);

        int var7;
        try {
            httpClient.openPost(FileServiceUtil.getRequestUrl(RequestTypeEnum.SET_SERVER_CONFIG));
            httpClient.setRequestBodyJson(reqBean);
            int status = httpClient.send();
            if(status == 200) {
                FileServiceResponseBean resBean = (FileServiceResponseBean)httpClient.getResponseJsonAsObject(FileServiceResponseBean.class);
                if(resBean.getStatus() == 0) {
                    return 0;
                }

                int var8 = resBean.getStatus();
                return var8;
            }

            var7 = status;
        } catch (IOException var12) {
            throw var12;
        } finally {
            httpClient.close();
        }

        return var7;
    }

    static {
        downloadCounter = new OperationCounter((long)maxDownloadConnections.intValue());
        RTE_type = new HashMap();
        RTE_type.put("image", "image/jpeg");
        RTE_type.put("flash", "application/x-shockwave-flash");
    }

    private static class FileFieldComparator implements Comparator<String>, Serializable {
        private static final long serialVersionUID = -1350845417478340152L;

        private FileFieldComparator() {
        }

        public int compare(String o1, String o2) {
            try {
                String keyO1 = o1.substring(4);
                String keyO2 = o2.substring(4);
                String[] indexArrayO1 = keyO1.split("_");
                String[] indexArrayO2 = keyO2.split("_");
                int inputIndexO1 = Integer.valueOf(indexArrayO1[0]).intValue();
                int fileIndexO1 = Integer.valueOf(indexArrayO1[1]).intValue();
                int inputIndexO2 = Integer.valueOf(indexArrayO2[0]).intValue();
                int fileIndexO2 = Integer.valueOf(indexArrayO2[1]).intValue();
                return inputIndexO1 != inputIndexO2?inputIndexO1 - inputIndexO2:fileIndexO1 - fileIndexO2;
            } catch (Exception var11) {
                return o1.compareTo(o2);
            }
        }
    }

    abstract class FileDownloader {
        protected final HttpServletRequest request;
        protected final HttpServletResponse response;
        protected Long fileId = null;
        protected Date createDate = null;
        protected InputStream in = null;
        protected ServletOutputStream out;
        protected String filename = null;
        protected String contentType;
        private V3XFile v3xFile;

        public FileDownloader(HttpServletRequest request, HttpServletResponse response) {
            this.request = request;
            this.response = response;
        }

        protected V3XFile getFile() throws BusinessException {
            if(this.v3xFile == null) {
                this.v3xFile = FileUploadController.this.fileManager.getV3XFile(this.fileId);
            }

            return this.v3xFile;
        }

        public ModelAndView download() throws Exception {
            this.request.setCharacterEncoding(FileUploadController.this.contentTypeCharset);
            this.fileId = Long.valueOf(this.request.getParameter("fileId"));
            if(!this.beforeDownload()) {
                return null;
            } else {
                this.out = this.response.getOutputStream();

                Object var2;
                try {
                    this.contentType = "application/octet-stream";
                    this.getInputstream();
                    FileDownloadEvent event;
                    if(this.in != null) {
                        this.setOutput();
                        event = new FileDownloadEvent(this, this.getFile(), this.fileId.longValue(), this.request, this.response, FileUploadController.this.fileManager);
                        event.setInputStream(this.in);
                        EventDispatcher.fireEventWithException(event);
                        CoderFactory.getInstance().download(event.getInputStream(), this.out);
                        return null;
                    }

                    if("m1".equals(this.request.getParameter("from"))) {
                        throw new Exception("FileNoFound");
                    }

                    event = new FileDownloadEvent(this, (V3XFile)null, this.fileId.longValue(), this.request, this.response, FileUploadController.this.fileManager);
                    event.setInputStream(this.in);
                    EventDispatcher.fireEventWithException(event);
                    if(event.getInputStream() == null) {
                        FileUploadController.showError("FileNoFound", (BusinessException)null, this.out, this.request, this.response);
                    } else {
                        CoderFactory.getInstance().download(event.getInputStream(), this.out);
                    }

                    var2 = null;
                    return (ModelAndView)var2;
                } catch (NoSuchPartitionException var7) {
                    FileUploadController.showError((String)null, var7, this.out, this.request, this.response);
                    var2 = null;
                    return (ModelAndView)var2;
                } catch (Throwable var8) {
                    if(var8.getClass().getSimpleName().equals(FileUploadController.this.clientAbortExceptionName)) {
                        FileUploadController.log.debug("用户关闭下载窗口: " + var8.getMessage());
                        return null;
                    }

                    if("m1".equals(this.request.getParameter("from"))) {
                        throw new Exception("FileNoFound");
                    }

                    FileUploadController.showError("Exception", (BusinessException)null, this.out, this.request, this.response);
                    var2 = null;
                } finally {
                    IOUtils.closeQuietly(this.in);
                    IOUtils.closeQuietly(this.out);
                    if("true".equalsIgnoreCase(this.request.getParameter("deleteFile"))) {
                        FileUploadController.this.fileManager.deleteFile(this.fileId, this.createDate, Boolean.valueOf(true));
                    }

                    FileUploadController.downloadCounter.end();
                }

                return (ModelAndView)var2;
            }
        }

        protected void setDownloadContentType(HttpServletResponse response, String filename, String mode, String contentType1) {
            String name = filename.replace(";", "");
            String userAgent = this.request.getHeader("User-Agent");
            boolean isIe7 = userAgent != null && userAgent.toLowerCase().contains("msie 7");
            if(isIe7) {
                response.setContentType(contentType1);
            } else {
                response.setContentType(contentType1 + "; charset=" + FileUploadController.this.contentTypeCharset);
            }

            String fname;
            if(!name.startsWith("filename=") && !name.startsWith("filename*=")) {
                fname = ";filename=\"" + name + "\"";
            } else {
                fname = ";" + name;
            }

            response.setHeader("Content-disposition", mode + fname);
        }

        protected void setFlashContenttype() {
            this.setDownloadContentType(this.response, this.filename, "inline", "application/x-shockwave-flash");
        }

        protected boolean beforeDownload() throws Exception {
            return true;
        }

        abstract void setOutput();

        abstract void getInputstream() throws Exception;
    }
}
