package com.seeyon.apps.cinda.authority.domain;

import java.math.BigDecimal;
import java.util.Date;

/**
 * UmOrganization entity. @author MyEclipse Persistence Tools
 */

public class UmOrganization implements java.io.Serializable {

	// Fields

	private String id;
	private String code;
	private String organizationname;
	private String organizationcode;
	private BigDecimal type;
	private BigDecimal departmentkind;
	private String parentid;
	private String simplename;
	private Double registercapital;
	private Date establishdate;
	private String scope;
	private BigDecimal businesskind;
	private String legalperson;
	private String linkman;
	private String telephone;
	private String address;
	private String postcode;
	private String website;
	private String email;
	private String district;
	private String principal;
	private String fax;
	private String departmentkindcode;
	private String addn;
	private BigDecimal sequence;
	private String fullname;
	private String orgtype;
	private String createperson;
	private String createdate;
	private String cancelperson;
	private String canceldate;

	// Constructors

	/** default constructor */
	public UmOrganization() {
	}

	/** minimal constructor */
	public UmOrganization(String id) {
		this.id = id;
	}

	/** full constructor */
	public UmOrganization(String id, String code, String organizationname,
			String organizationcode, BigDecimal type,
			BigDecimal departmentkind, String parentid, String simplename,
			Double registercapital, Date establishdate, String scope,
			BigDecimal businesskind, String legalperson, String linkman,
			String telephone, String address, String postcode, String website,
			String email, String district, String principal, String fax,
			String departmentkindcode, String addn, BigDecimal sequence,
			String fullname, String orgtype, String createperson,
			String createdate, String cancelperson, String canceldate) {
		this.id = id;
		this.code = code;
		this.organizationname = organizationname;
		this.organizationcode = organizationcode;
		this.type = type;
		this.departmentkind = departmentkind;
		this.parentid = parentid;
		this.simplename = simplename;
		this.registercapital = registercapital;
		this.establishdate = establishdate;
		this.scope = scope;
		this.businesskind = businesskind;
		this.legalperson = legalperson;
		this.linkman = linkman;
		this.telephone = telephone;
		this.address = address;
		this.postcode = postcode;
		this.website = website;
		this.email = email;
		this.district = district;
		this.principal = principal;
		this.fax = fax;
		this.departmentkindcode = departmentkindcode;
		this.addn = addn;
		this.sequence = sequence;
		this.fullname = fullname;
		this.orgtype = orgtype;
		this.createperson = createperson;
		this.createdate = createdate;
		this.cancelperson = cancelperson;
		this.canceldate = canceldate;
	}

	// Property accessors

	public String getId() {
		return this.id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getOrganizationname() {
		return this.organizationname;
	}

	public void setOrganizationname(String organizationname) {
		this.organizationname = organizationname;
	}

	public String getOrganizationcode() {
		return this.organizationcode;
	}

	public void setOrganizationcode(String organizationcode) {
		this.organizationcode = organizationcode;
	}

	public BigDecimal getType() {
		return this.type;
	}

	public void setType(BigDecimal type) {
		this.type = type;
	}

	public BigDecimal getDepartmentkind() {
		return this.departmentkind;
	}

	public void setDepartmentkind(BigDecimal departmentkind) {
		this.departmentkind = departmentkind;
	}

	public String getParentid() {
		return this.parentid;
	}

	public void setParentid(String parentid) {
		this.parentid = parentid;
	}

	public String getSimplename() {
		return this.simplename;
	}

	public void setSimplename(String simplename) {
		this.simplename = simplename;
	}

	public Double getRegistercapital() {
		return this.registercapital;
	}

	public void setRegistercapital(Double registercapital) {
		this.registercapital = registercapital;
	}

	public Date getEstablishdate() {
		return this.establishdate;
	}

	public void setEstablishdate(Date establishdate) {
		this.establishdate = establishdate;
	}

	public String getScope() {
		return this.scope;
	}

	public void setScope(String scope) {
		this.scope = scope;
	}

	public BigDecimal getBusinesskind() {
		return this.businesskind;
	}

	public void setBusinesskind(BigDecimal businesskind) {
		this.businesskind = businesskind;
	}

	public String getLegalperson() {
		return this.legalperson;
	}

	public void setLegalperson(String legalperson) {
		this.legalperson = legalperson;
	}

	public String getLinkman() {
		return this.linkman;
	}

	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}

	public String getTelephone() {
		return this.telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPostcode() {
		return this.postcode;
	}

	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public String getWebsite() {
		return this.website;
	}

	public void setWebsite(String website) {
		this.website = website;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getDistrict() {
		return this.district;
	}

	public void setDistrict(String district) {
		this.district = district;
	}

	public String getPrincipal() {
		return this.principal;
	}

	public void setPrincipal(String principal) {
		this.principal = principal;
	}

	public String getFax() {
		return this.fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public String getDepartmentkindcode() {
		return this.departmentkindcode;
	}

	public void setDepartmentkindcode(String departmentkindcode) {
		this.departmentkindcode = departmentkindcode;
	}

	public String getAddn() {
		return this.addn;
	}

	public void setAddn(String addn) {
		this.addn = addn;
	}

	public BigDecimal getSequence() {
		return this.sequence;
	}

	public void setSequence(BigDecimal sequence) {
		this.sequence = sequence;
	}

	public String getFullname() {
		return this.fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getOrgtype() {
		return this.orgtype;
	}

	public void setOrgtype(String orgtype) {
		this.orgtype = orgtype;
	}

	public String getCreateperson() {
		return this.createperson;
	}

	public void setCreateperson(String createperson) {
		this.createperson = createperson;
	}

	public String getCreatedate() {
		return this.createdate;
	}

	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}

	public String getCancelperson() {
		return this.cancelperson;
	}

	public void setCancelperson(String cancelperson) {
		this.cancelperson = cancelperson;
	}

	public String getCanceldate() {
		return this.canceldate;
	}

	public void setCanceldate(String canceldate) {
		this.canceldate = canceldate;
	}

}