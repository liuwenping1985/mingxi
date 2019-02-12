package com.seeyon.apps.doc.po;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ToStringBuilder;

import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.doc.util.KnowledgeUtils;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.thoughtworks.xstream.XStream;

/**
 * 文档主表，记录文档、文档夹
 * @see DocCommonInfo
 */
public class DocResourcePO extends BasePO implements Comparable<DocResourcePO> {
    public static final String PROP_ID             = "id";
    public static final String PROP_MIMETYPEID     = "mimeTypeId";
    public static final String PROP_FRNAME         = "frName";
    public static final String PROP_SIZE           = "frSize";
    public static final String PROP_LAST_USER      = "lastUserId";
    public static final String PROP_LAST_UPDATE    = "lastUpdate";

    private static final long  serialVersionUID    = -3128658640817910854L;

    /** 是否允许创建子文档夹  */
    private boolean            subfolderEnabled;
    /** 是否文档夹人 */
    private boolean            isFolder;
    /** 文档是否被锁定人 */
    private boolean            isCheckOut;
    /** 锁定文档的人人 */
    private Long               checkOutUserId;
    /** 锁定文档的时间人 */
    private Timestamp          checkOutTime;
    /** 文档创建人 */
    private Long               createUserId;
    /** 文档创建日期 */
    private Timestamp               createTime;
    private Timestamp               openSquareTime;
    /** 所属文档库ID */
    private long               docLibId;
    /** 文档的直接父文档夹ID */
    private long               parentFrId;
    /** 文档逻辑路径：从文档库的根Id起，到自身的所有节点ID，以"."串接起来的值 */
    private String             logicalPath;
    /** 是否允许评论  */
    private boolean            commentEnabled;
    /** 评论次数 */
    private int                commentCount        = 0;
    /** 文档状态 */
    private byte               status;
    /** 修改文档状态的时间 */
    private Timestamp               statusDate;
    /** 访问次数 */
    private int                accessCount         = 0;
    /** 是否为学习文档 */
    private boolean            isLearningDoc;
    /** 文档排序号 */
    private int                frOrder;
    //项目  信达资产   公司  kimde  修改人  msg  修改时间   2018-01-24   修改功能：只是在页面显示人员姓名  start 
    private String username;
    
    public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	//项目  信达资产  公司 kimde 修改人 msg 修改时间  2018-01-24    修改功能：在页面显示人员姓名    end
	/** 
     * 文档源ID，分为如下三种情况：
     * 1.如该文档是上传文档，对应v3x_file主键ID；
     * 2.如该文档是归档，对应归档应用实体ID；
     * 3.如为链接，对应源文档（夹）ID。
     * 如果为文档历史版本信息，只可能为第一种情况
      */
    private Long               sourceId;
    /** 文档内容类型 */
    private long               frType;
    /** 文档描述 */
    private String             frDesc;
    /** 文档关键词 */
    private String             keyWords;
    /** 是否启用版本管理和版本注释 */
    private boolean            versionEnabled;
    /**　文档格式排序号 */
    private int                mimeOrder;
    private boolean            third_hasPingHole;

    /** 文档类型 (0:公文归档的公文，1：部门归档的公文)*/
    private Integer            pigeonholeType;

    /** 文档名称 */
    private String             frName;
    /** 文档大小，单位为字节  */
    private long               frSize;
    /** 文档最近修改人 */
    private Long               lastUserId;
    /** 文档最近修改日期 */
    private Timestamp               lastUpdate;
    /** 文档类型ID */
    private Long               mimeTypeId;
    /** 文档是否有对应附件 */
    private boolean            hasAttachments;
    /** 版本注释 */
    private String             versionComment;
    /** 如果是协同，是否有表单授权 */
    private boolean            isRelationAuthority = false;
    /**来源类别：0:上传 1：新建 2：归档 3：主体收藏 4:附件收藏    */
    private Integer            sourceType;
    /**是否允许推荐   */
    private Boolean            recommendEnable     = false;
    /**推荐次数    */
    private Integer            recommendCount      = 0;
    /**收藏次数    */
    private Integer            collectCount        = 0;
    /**下载次数    */
    private Integer            downloadCount       = 0;
    /**评分次数    */
    private Integer            scoreCount          = 0;
    /**文档总分    */
    private Double             totalScore          = 0.0;

    private Long               favoriteSource;
    // 	TODO(duanyl) 此参数只有我要分享中使用，以后可以把此参数移出，让其返回VO
    /** 我要分享--借阅安全访问值*/
    private String			   vForBorrowS;
    
    private String			   vForDocDownload;
    
    private boolean            isOnlyList;
    
    /**
     * 项目类别，不做持久化
     */
    private Long               projectTypeId;
    
    private Boolean           isPigeonholeArchive;
    
    private Byte projectStatus;
    
    public String getvForBorrowS() {
		return vForBorrowS;
	}

	public void setvForBorrowS(String vForBorrowS) {
		this.vForBorrowS = vForBorrowS;
	}

	public boolean getIsRelationAuthority() {
        return isRelationAuthority;
    }

    public void setIsRelationAuthority(boolean isRelationAuthority) {
        this.isRelationAuthority = isRelationAuthority;
    }

    public String getFrName() {
        return frName;
    }
    
    public String getFrNameEscapeJS() {
        return Functions.escapeJavascript(frName);
    }
    
    private static final String[] officeFromats ={".xlsx",".xls",".docx",".doc",".pptx",".ppt",".wps",".et"};
    //office组件保存时，不需要文档的后缀
    public String getFrNameRemoveOffficeFromat() {
        for (String ofromat : officeFromats) {
            if (frName.endsWith(ofromat)) {
                return frName.substring(0, frName.length() - ofromat.length());
            }
        }
        return frName;
    }

    public void setFrName(String frName) {
        this.frName = frName;
    }

    public long getFrSize() {
        return frSize;
    }

    public void setFrSize(long frSize) {
        this.frSize = frSize;
    }

    public Long getLastUserId() {
        return lastUserId;
    }

    public void setLastUserId(Long lastUserId) {
        this.lastUserId = lastUserId;
    }

    public Timestamp getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(Timestamp lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    public Long getMimeTypeId() {
        return mimeTypeId;
    }

    public void setMimeTypeId(Long mimeTypeId) {
        this.mimeTypeId = mimeTypeId;
    }

    public boolean getHasAttachments() {
        return hasAttachments;
    }

    public void setHasAttachments(boolean hasAttachments) {
        this.hasAttachments = hasAttachments;
    }

    public String getVersionComment() {
        return versionComment;
    }

    public void setVersionComment(String versionComment) {
        this.versionComment = versionComment;
    }

    public Integer getPigeonholeType() {
        return pigeonholeType;
    }

    public void setPigeonholeType(Integer pigeonholeType) {
        this.pigeonholeType = pigeonholeType;
    }

    public Long getSourceId() {
        return sourceId;
    }

    public void setSourceId(Long sourceId) {
        this.sourceId = sourceId;
    }

    public long getFrType() {
        return frType;
    }

    public void setFrType(long frType) {
        this.frType = frType;
    }

    public String getFrDesc() {
        return frDesc;
    }

    public void setFrDesc(String frDesc) {
        this.frDesc = frDesc;
    }

    public String getKeyWords() {
        return keyWords;
    }

    public void setKeyWords(String keyWords) {
        this.keyWords = keyWords;
    }

    public int getAccessCount() {
        return accessCount;
    }

    public void setAccessCount(int accessCount) {
        this.accessCount = accessCount;
    }

    public long getDocLibId() {
        return docLibId;
    }

    public void setDocLibId(long docLibId) {
        this.docLibId = docLibId;
    }

    public long getParentFrId() {
        return parentFrId;
    }

    public void setParentFrId(long parentFrId) {
        this.parentFrId = parentFrId;
    }

    public String getLogicalPath() {
        return logicalPath;
    }

    public void setLogicalPath(String logicalPath) {
        this.logicalPath = logicalPath;
    }

    public boolean getCommentEnabled() {
        return commentEnabled;
    }

    public void setCommentEnabled(boolean commentEnabled) {
        this.commentEnabled = commentEnabled;
    }

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public byte getStatus() {
        return status;
    }

    public void setStatus(byte status) {
        this.status = status;
    }

    public Timestamp getStatusDate() {
        return statusDate;
    }

    public void setStatusDate(Timestamp statusDate) {
        this.statusDate = statusDate;
    }

    public Long getCreateUserId() {
        return createUserId;
    }

    public void setCreateUserId(Long createUserId) {
        this.createUserId = createUserId;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public Timestamp getOpenSquareTime() {
        if (openSquareTime == null) {
            this.openSquareTime = this.lastUpdate;
        }
        return openSquareTime;
    }

    public void setOpenSquareTime(Timestamp openSquareTime) {
        this.openSquareTime = openSquareTime;
    }

    public boolean getIsLearningDoc() {
        return isLearningDoc;
    }

    public void setIsLearningDoc(boolean isLearningDoc) {
        this.isLearningDoc = isLearningDoc;
    }

    public int getFrOrder() {
        return frOrder;
    }

    public void setFrOrder(int frOrder) {
        this.frOrder = frOrder;
    }

    public boolean getIsFolder() {
        return this.isFolder;
    }

    public void setIsFolder(boolean isFolder) {
        this.isFolder = isFolder;
    }

    public boolean getSubfolderEnabled() {
        return this.subfolderEnabled;
    }

    public void setSubfolderEnabled(boolean subfolderEnabled) {
        this.subfolderEnabled = subfolderEnabled;
    }

    public Timestamp getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(Timestamp checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public Long getCheckOutUserId() {
        return checkOutUserId;
    }

    public void setCheckOutUserId(Long checkOutUserId) {
        this.checkOutUserId = checkOutUserId;
    }

    public boolean getIsCheckOut() {
        return isCheckOut;
    }

    public void setIsCheckOut(boolean isCheckOut) {
        this.isCheckOut = isCheckOut;
    }

    public int getMimeOrder() {
        return mimeOrder;
    }

    public void setMimeOrder(int mimeOrder) {
        this.mimeOrder = mimeOrder;
    }

    public boolean isThird_hasPingHole() {
        return third_hasPingHole;
    }

    public void setThird_hasPingHole(boolean third_hasPingHole) {
        this.third_hasPingHole = third_hasPingHole;
    }

    public boolean isVersionEnabled() {
        return versionEnabled;
    }

    public void setVersionEnabled(boolean versionEnabled) {
        this.versionEnabled = versionEnabled;
    }

    /* ----------------------前端使用-----------------------*/

    /** 保存当前用户对当前 DocResource 的权限 */
    private Set<Integer> aclSet = new HashSet<Integer>();
    /** 是否已经查询过权限 */
    private boolean      hasAcl = false;
    /** 是否个人文档库记录 */
    private boolean      isMyOwn;

    public Set<Integer> getAclSet() {
        return aclSet;
    }

    public void setAclSet(Set<Integer> aclSet) {
        this.aclSet = aclSet;
        this.hasAcl = true;
    }

    public boolean getHasAcl() {
        return hasAcl;
    }

    public void setHasAcl(boolean hasAcl) {
        this.hasAcl = hasAcl;
    }

    public boolean getIsMyOwn() {
        return isMyOwn;
    }

    public void setIsMyOwn(boolean isMyOwn) {
        this.isMyOwn = isMyOwn;
    }

    /** 元数据信息，不持久化  */
    private Map<Long, Object> metadataMap = new HashMap<Long, Object>();

    /**
     * 根据文档元数据定义id，读取文档扩展属性值
     * @param metadataDefId 文档元数据定义id
     * @return 文档扩展属性值对象
     */
    public Object getMetadataByDefId(long defId) {
        return this.getMetadataMap().get(defId);
    }

    public Map<Long, Object> getMetadataMap() {
        return metadataMap;
    }

    public void setMetadataMap(Map<Long, Object> metadataMap) {
        this.metadataMap = metadataMap;
    }

    /** 元数据对象集合信息，不持久化 */
    private List<DocMetadataObjectPO> metadataList = new ArrayList<DocMetadataObjectPO>();

    public List<DocMetadataObjectPO> getMetadataList() {
        return metadataList;
    }

    public void setMetadataList(List<DocMetadataObjectPO> metadataList) {
        this.metadataList = metadataList;
    }

    /**
     * @return the sourceType
     */
    public Integer getSourceType() {
        return sourceType;
    }

    /**
     * @param sourceType the sourceType to set
     */
    public void setSourceType(Integer sourceType) {
        this.sourceType = sourceType;
    }

    /**
     * @return the recommendEnable
     */
    public Boolean getRecommendEnable() {
        return recommendEnable == null ? false : recommendEnable;
    }

    /**
     * @param recommendEnable the recommendEnable to set
     */
    public void setRecommendEnable(Boolean recommendEnable) {
        this.recommendEnable = recommendEnable;
    }

    /**
     * @return the recommendCount
     */
    public Integer getRecommendCount() {
        return (recommendCount == null) ? 0 : recommendCount;
    }

    /**
     * @param recommendCount the recommendCount to set
     */
    public void setRecommendCount(Integer recommendCount) {
        this.recommendCount = recommendCount;
    }

    /**
     * @return the collectCount
     */
    public Integer getCollectCount() {
        return (collectCount == null) ? 0 : collectCount;
    }

    /**
     * @param collectCount the collectCount to set
     */
    public void setCollectCount(Integer collectCount) {
        this.collectCount = collectCount;
    }

    /**
     * @return the downloadCount
     */
    public Integer getDownloadCount() {
        return (downloadCount == null) ? 0 : downloadCount;
    }

    /**
     * @param downloadCount the downloadCount to set
     */
    public void setDownloadCount(Integer downloadCount) {
        this.downloadCount = downloadCount;
    }

    /**
     * @return the scoreCount
     */
    public Integer getScoreCount() {
        return scoreCount == null? 0:scoreCount;
    }

    /**
     * @param scoreCount the scoreCount to set
     */
    public void setScoreCount(Integer scoreCount) {
        this.scoreCount = scoreCount;
    }

    /**
     * @return the totalScore
     */
    public Double getTotalScore() {
        return totalScore == null? 0:totalScore;
    }

    /**
     * @param totalScore the totalScore to set
     */
    public void setTotalScore(Double totalScore) {
        this.totalScore = totalScore;
    }

    public Long getFavoriteSource() {
        return favoriteSource;
    }

    public void setFavoriteSource(Long favoriteSource) {
        this.favoriteSource = favoriteSource;
    }

    public String getAvgScore() {
        return KnowledgeUtils.getAvgScore(totalScore, scoreCount);
    }
    /**
     * 在JSONUtil.toJSONString时要用到，否则获取不到id
     */
    @Override
    public Long getId() {
        return super.getId();
    }

    /*--------------------constructor----------------------- */

    public DocResourcePO() {
    }

    public DocResourcePO(long id) {
        this.id = id;
    }

    public String toString() {
        return new ToStringBuilder(this).append("id", getId()).toString();
    }

    public int compareTo(DocResourcePO o) {
        // order by a.frType desc, a.lastUpdate desc
        if (this.frType > o.frType)
            return 1;
        else if (this.frType < o.frType)
            return -1;
        else
            return -(this.lastUpdate.compareTo(o.lastUpdate));
    }

    /**
     * 判断当前文档所在层级是否过深，已超过上限记数
     */
    public boolean deeperThanLimit(int limit) {
        return this.getLevelDepth() >= limit;
    }
    
    

    public boolean isOnlyList() {
        return isOnlyList;
    }

    public void setOnlyList(boolean isOnlyList) {
        this.isOnlyList = isOnlyList;
    }

    /**
     * 获取当前文档夹的层级深度，从文档库下面的一级文档夹开始算起
     */
    public int getLevelDepth() {
        int len = 0;
        String[] arr = StringUtils.split(this.logicalPath, '.');
        if (arr != null) {
            len = arr.length - 1;
        }
        return len;
    }
    /*
     * 返回个人知识中心--我的文档库下属性操作的安全验证值
     */
    public String getv() {
        return SecurityHelper.digest(this.getId(), 40, 1, false, true, true, true, true, true, true, "", "");
    }
    public String getvForDocPropertyIframe() {
        return SecurityHelper.digest(this.getId(), 40, 1, false, true, true, true, true, true, true, "", "");
    }
    /**
     * 返回个人知识中心--我的文档库下借阅操作的安全验证值
     */
    public String getvForBorrow() {
    	return SecurityHelper.digest(this.getId(),1,false,true,true,true,true,true,true,"","");
    }
    /**
     * 获取当前文档夹相对其某一上层文档夹的层级深度<br>
     * 比如：文档夹A/文档夹B/文档夹C/文档夹D/文档夹E<br>
     * 则文档夹E相对文档夹A的层级深度为4级，D为3级，C为2级，B为1级<br>
     * @param parentId	上层(不一定是上一层)文档夹
     * @return	相对层级深度
     */
    public int getRelativeLevelDepth(Long parentId) {
        String cursor = parentId + ".";
        String relativePath = this.logicalPath.substring(this.logicalPath.indexOf(cursor) + cursor.length());
        return StringUtils.split(relativePath, '.').length;
    }

    /**
     * 根据MimeTypeId类型判定当前文档是否为图片(JPG/PNG/GIF)
     */
    public boolean isImage() {
        return this.getMimeTypeId() == Constants.FORMAT_TYPE_ID_UPLOAD_JPG
                || this.getMimeTypeId() == Constants.FORMAT_TYPE_ID_UPLOAD_PNG
                || this.getMimeTypeId() == Constants.FORMAT_TYPE_ID_UPLOAD_GIF;
    }

    /** 根据MimeTypeId类型判定当前文档是否为上传的PDF文件  */
    public boolean isPDF() {
        return this.getMimeTypeId() == Constants.FORMAT_TYPE_ID_UPLOAD_PDF;
    }

    private static final XStream XSTREAM = new XStream();

    /** 将POJO转换为XStream所能解析格式的XML信息 */
    public String toXMLInfo() {
        return XSTREAM.toXML(this);
    }

    public boolean canPrint4Upload() {
        return this.isImage() || this.isPDF() || this.isUploadOfficeOrWps()
                || this.mimeTypeId == Constants.FORMAT_TYPE_ID_TXT || this.mimeTypeId == Constants.FORMAT_TYPE_ID_HTML
                || this.mimeTypeId == Constants.FORMAT_TYPE_ID_HTM;
    }

    /**
     * 通过mimeTypeId判断上传的文件是否为Office或WPS类型
     */
    public boolean isUploadOfficeOrWps() {
        return this.mimeTypeId == Constants.FORMAT_TYPE_ID_UPLOAD_DOC
                || this.mimeTypeId == Constants.FORMAT_TYPE_ID_UPLOAD_XLS
                || this.mimeTypeId == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_DOC
                || this.mimeTypeId == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_XLS;
    }

	public String getvForDocDownload() {
		return vForDocDownload;
	}

	public void setvForDocDownload(String vForDocDownload) {
		this.vForDocDownload = vForDocDownload;
	}

    public Long getProjectTypeId() {
        return projectTypeId;
    }

    public void setProjectTypeId(Long projectTypeId) {
        this.projectTypeId = projectTypeId;
    }   
    
    public String getProjectStatus() {
        String[] status = { "kaishi", "jinxingzhong", "jieshu", "zhongzhi" , "shanchu"};
        if (projectStatus != null && status.length > projectStatus.intValue()) {
            int index = projectStatus.intValue();
            return ResourceUtil.getString("doc." + status[index]);
        }
        return "";
    }

    public void setProjectStatus(Byte projectStatus) {
        this.projectStatus = projectStatus;
    }
    
    public Boolean getIsPigeonholeArchive() {
        return isPigeonholeArchive == null ? Boolean.FALSE : isPigeonholeArchive;
    }

    public void setIsPigeonholeArchive(Boolean isPigeonholeArchive) {
        this.isPigeonholeArchive = isPigeonholeArchive;
    }
}