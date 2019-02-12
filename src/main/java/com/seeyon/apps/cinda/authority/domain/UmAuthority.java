package com.seeyon.apps.cinda.authority.domain;

import java.util.Date;
import java.util.List;

import com.seeyon.ctp.util.Strings;

/**
 * UmAuthority entity. @author MyEclipse Persistence Tools
 */

public class UmAuthority implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 2470589233259664671L;
	private String authorityid;
	private String authorityname;
	private String authorityattribute;
	private String attributevalue;
	private Integer appsystem;
	private String operatingkind;
	private Integer sublicencescope;
	private Date createdate;
	private String operatemode;
	private Integer authoritytype;
	private String authoritycode;
	private String url;
	private String sequence;
	private String simplename;
	private String urltype;
	private String functioncode;
	private String authoritygroup;
	private List<UmAuthority> childs;
	private String parentcode;
	private int level = 0;
	// Constructors

	/** default constructor */
	public UmAuthority() {
	}

	/** minimal constructor */
	public UmAuthority(String authorityid) {
		this.authorityid = authorityid;
	}

	/** full constructor */
	public UmAuthority(String authorityid, String authorityname,
			String authorityattribute, String attributevalue,
			Integer appsystem, String operatingkind,
			Integer sublicencescope, Date createdate, String operatemode,
			Integer authoritytype, String authoritycode, String url,
			String sequence, String simplename, String urltype,
			String functioncode, String authoritygroup) {
		this.authorityid = authorityid;
		this.authorityname = authorityname;
		this.authorityattribute = authorityattribute;
		this.attributevalue = attributevalue;
		this.appsystem = appsystem;
		this.operatingkind = operatingkind;
		this.sublicencescope = sublicencescope;
		this.createdate = createdate;
		this.operatemode = operatemode;
		this.authoritytype = authoritytype;
		this.authoritycode = authoritycode;
		this.url = url;
		this.sequence = sequence;
		this.simplename = simplename;
		this.urltype = urltype;
		this.functioncode = functioncode;
		this.authoritygroup = authoritygroup;
	}
	// Property accessors
	public String getAuthorityid() {
		return authorityid;
	}

	public void setAuthorityid(String authorityid) {
		this.authorityid = authorityid;
	}

	public String getAuthorityname() {
		return authorityname;
	}

	public void setAuthorityname(String authorityname) {
		this.authorityname = authorityname;
	}

	public String getAuthorityattribute() {
		return authorityattribute;
	}

	public void setAuthorityattribute(String authorityattribute) {
		this.authorityattribute = authorityattribute;
	}

	public String getAttributevalue() {
		return attributevalue;
	}

	public void setAttributevalue(String attributevalue) {
		this.attributevalue = attributevalue;
	}

	public Integer getAppsystem() {
		return appsystem;
	}

	public void setAppsystem(Integer appsystem) {
		this.appsystem = appsystem;
	}

	public String getOperatingkind() {
		return operatingkind;
	}

	public void setOperatingkind(String operatingkind) {
		this.operatingkind = operatingkind;
	}

	public Integer getSublicencescope() {
		return sublicencescope;
	}

	public void setSublicencescope(Integer sublicencescope) {
		this.sublicencescope = sublicencescope;
	}

	public Date getCreatedate() {
		return createdate;
	}

	public void setCreatedate(Date createdate) {
		this.createdate = createdate;
	}

	public String getOperatemode() {
		return operatemode;
	}

	public void setOperatemode(String operatemode) {
		this.operatemode = operatemode;
	}

	public Integer getAuthoritytype() {
		return authoritytype;
	}

	public void setAuthoritytype(Integer authoritytype) {
		this.authoritytype = authoritytype;
	}

	public String getAuthoritycode() {
		return authoritycode;
	}

	public void setAuthoritycode(String authoritycode) {
		this.authoritycode = authoritycode;
		this.parentcode = this.authoritycode.substring(0, this.authoritycode.length()-2);
		this.level = (this.authoritycode.length())/2-1;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getSequence() {
		return sequence;
	}

	public void setSequence(String sequence) {
		this.sequence = sequence;
	}

	public String getSimplename() {
		return simplename;
	}

	public void setSimplename(String simplename) {
		this.simplename = simplename;
	}

	public String getUrltype() {
		return urltype;
	}

	public void setUrltype(String urltype) {
		this.urltype = urltype;
	}

	public String getFunctioncode() {
		return functioncode;
	}

	public void setFunctioncode(String functioncode) {
		this.functioncode = functioncode;
	}

	public String getAuthoritygroup() {
		return authoritygroup;
	}

	public void setAuthoritygroup(String authoritygroup) {
		this.authoritygroup = authoritygroup;
	}

	public List<UmAuthority> getChilds() {
		return childs;
	}

	public void setChilds(List<UmAuthority> childs) {
		this.childs = childs;
	}

	public String getParentcode() {
		if(Strings.isBlank(parentcode)){
			this.parentcode = this.authoritycode.substring(0,this.authoritycode.length()-2);
		}
		return parentcode;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

public static void main(String[] args) {
	UmAuthority um = new UmAuthority();
	um.setAuthoritycode("01");
	System.out.println("parentcode="+um.getParentcode());
}
}