package com.seeyon.apps.addressbook.po;

import java.util.Date;
import java.util.Set;

import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.util.Strings;

public class AddressBookSet extends BasePO {

    private static final long serialVersionUID = -1096765859251674854L;

    private Integer           viewScope;                               //查看范围
    private Integer           keyInfo;                                 //关键信息
    private Integer           keyInfoType;                             //关键信息类型
    private Integer           exportPrint;                             //导出打印
    private String            displayColumn;                           //显示列头
    private boolean           memberName       = true;                 //姓名
    private boolean           memberDept       = true;                 //部门
    private boolean           memberPost       = true;                 //岗位
    private boolean           memberLevel      = false;                //职务级别
    private boolean           workLocal        = true;                 //工作地
    private boolean           memberPhone      = true;                 //办公电话
    private boolean           memberMobile     = true;                 //手机号码
    private boolean           memberEmail      = false;                //电子邮件
    private boolean           memberWX         = false;                //微信
    private boolean           memberWB         = false;                //微博
    private boolean           memberHome       = false;                //家庭住址
    private boolean           memberCode       = false;                //邮政编码
    private boolean           memberAddress    = false;                //通讯地址
    /**
     * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-10   修改功能  通讯录列表增加办公室门牌号  start 
     */    
    private boolean           houseNumber      = true;                //办公室门牌号
    /**
     * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-10   修改功能  通讯录列表增加办公室门牌号  end 
     */    
    
    /**
     * 项目  信达资产   公司  kimde  修改人  解哲   修改时间    2018-3-3   修改功能  通讯录列表增加是否董高监  start 
     */    
    private boolean            dgj             = true;   			   //办公室门牌号
    /**
     * 项目  信达资产   公司  kimde  修改人  解哲   修改时间    2018-3-3   修改功能  通讯录列表增加是否董高监  end 
     */  
    private Date              createDate;                              //创建时间
    private Date              updateDate;                              //更新时间
    private Long              accountId;                               //单位ID
    private String            viewScopeIds;
    private String            viewScopeNames;
    private Set<Long>         viewScopeMemberSet;
    private String            keyInfoIds;
    private String            keyInfoNames;
    private Set<Long>         keyInfoMemberSet;
    private String            exportPrintIds;
    private String            exportPrintNames;
    private Set<Long>         exportPrintMemberSet;


	public boolean isWorkLocal() {
		return workLocal;
	}

	public void setWorkLocal(boolean workLocal) {
		this.workLocal = workLocal;
	}

	public Integer getViewScope() {
        return viewScope;
    }

    public void setViewScope(Integer viewScope) {
        this.viewScope = viewScope;
    }

    public Integer getKeyInfo() {
        return keyInfo;
    }

    public void setKeyInfo(Integer keyInfo) {
        this.keyInfo = keyInfo;
    }

    public Integer getKeyInfoType() {
        return keyInfoType;
    }

    public void setKeyInfoType(Integer keyInfoType) {
        this.keyInfoType = keyInfoType;
    }

    public Integer getExportPrint() {
        return exportPrint;
    }

    public void setExportPrint(Integer exportPrint) {
        this.exportPrint = exportPrint;
    }

    public String getDisplayColumn() {
        return displayColumn;
    }

    public void setDisplayColumn(String displayColumn) {
        this.displayColumn = displayColumn;
    }

    public boolean isMemberName() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberName");
        }
        return memberName;
    }

    public void setMemberName(boolean memberName) {
        this.memberName = memberName;
    }

    public boolean isMemberDept() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberDept");
        }
        return memberDept;
    }

    public void setMemberDept(boolean memberDept) {
        this.memberDept = memberDept;
    }

    public boolean isMemberPost() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberPost");
        }
        return memberPost;
    }

    public void setMemberPost(boolean memberPost) {
        this.memberPost = memberPost;
    }

    public boolean isMemberLevel() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberLevel");
        }
        return memberLevel;
    }

    public void setMemberLevel(boolean memberLevel) {
        this.memberLevel = memberLevel;
    }

    public boolean isMemberPhone() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberPhone");
        }
        return memberPhone;
    }

    public void setMemberPhone(boolean memberPhone) {
        this.memberPhone = memberPhone;
    }

    public boolean isMemberMobile() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberMobile");
        }
        return memberMobile;
    }

    public void setMemberMobile(boolean memberMobile) {
        this.memberMobile = memberMobile;
    }

    public boolean isMemberEmail() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberEmail");
        }
        return memberEmail;
    }

    public void setMemberEmail(boolean memberEmail) {
        this.memberEmail = memberEmail;
    }

    public boolean isMemberWX() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberWX");
        }
        return memberWX;
    }

    public void setMemberWX(boolean memberWX) {
        this.memberWX = memberWX;
    }

    public boolean isMemberWB() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberWB");
        }
        return memberWB;
    }

    public void setMemberWB(boolean memberWB) {
        this.memberWB = memberWB;
    }

    public boolean isMemberHome() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberHome");
        }
        return memberHome;
    }

    public void setMemberHome(boolean memberHome) {
        this.memberHome = memberHome;
    }

    public boolean isMemberCode() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberCode");
        }
        return memberCode;
    }

    public void setMemberCode(boolean memberCode) {
        this.memberCode = memberCode;
    }

    public boolean isMemberAddress() {
        String displayColumn = this.getDisplayColumn();
        if (Strings.isNotBlank(displayColumn)) {
            return displayColumn.contains("memberAddress");
        }
        return memberAddress;
    }

    public void setMemberAddress(boolean memberAddress) {
        this.memberAddress = memberAddress;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }

    public String getViewScopeIds() {
        return viewScopeIds;
    }

    public void setViewScopeIds(String viewScopeIds) {
        this.viewScopeIds = viewScopeIds;
    }

    public String getViewScopeNames() {
        return viewScopeNames;
    }

    public void setViewScopeNames(String viewScopeNames) {
        this.viewScopeNames = viewScopeNames;
    }

    public Set<Long> getViewScopeMemberSet() {
        return viewScopeMemberSet;
    }

    public void setViewScopeMemberSet(Set<Long> viewScopeMemberSet) {
        this.viewScopeMemberSet = viewScopeMemberSet;
    }

    public String getKeyInfoIds() {
        return keyInfoIds;
    }

    public void setKeyInfoIds(String keyInfoIds) {
        this.keyInfoIds = keyInfoIds;
    }

    public String getKeyInfoNames() {
        return keyInfoNames;
    }

    public void setKeyInfoNames(String keyInfoNames) {
        this.keyInfoNames = keyInfoNames;
    }

    public Set<Long> getKeyInfoMemberSet() {
        return keyInfoMemberSet;
    }

    public void setKeyInfoMemberSet(Set<Long> keyInfoMemberSet) {
        this.keyInfoMemberSet = keyInfoMemberSet;
    }

    public String getExportPrintIds() {
        return exportPrintIds;
    }

    public void setExportPrintIds(String exportPrintIds) {
        this.exportPrintIds = exportPrintIds;
    }

    public String getExportPrintNames() {
        return exportPrintNames;
    }

    public void setExportPrintNames(String exportPrintNames) {
        this.exportPrintNames = exportPrintNames;
    }

    public Set<Long> getExportPrintMemberSet() {
        return exportPrintMemberSet;
    }

    public void setExportPrintMemberSet(Set<Long> exportPrintMemberSet) {
        this.exportPrintMemberSet = exportPrintMemberSet;
    }
    /**
     * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-10 修改功能  通讯录列表增加办公室门牌号  start 
     */	
    public boolean isHouseNumber() {
		return houseNumber;
	}

	public void setHouseNumber(boolean houseNumber) {
		this.houseNumber = houseNumber;
	}
	/**
     * 项目  信达资产   公司  kimde  修改人  陈岩   修改时间    2017-11-10 修改功能  通讯录列表增加办公室门牌号  end 
     */

    /**
     * 项目  信达资产   公司  kimde  修改人  解哲   修改时间    2018-3-3 修改功能  通讯录列表增加是否董高监  start 
     */	
	public boolean isDgj() {
		return dgj;
	}

	public void setDgj(boolean dgj) {
		this.dgj = dgj;
	}
	/**
     * 项目  信达资产   公司  kimde  修改人  解哲   修改时间    2018-3-3 修改功能  通讯录列表增加是否董高监  end 
     */
    

}
