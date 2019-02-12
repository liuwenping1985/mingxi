package com.seeyon.apps.cinda.authority.domain;


/**
 * UmUserGroupRoleId entity. @author MyEclipse Persistence Tools
 */

public class UmUserGroupRole implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 8843695175465931702L;
	private String entitycode;
	private String userid;
	private Integer entitykind;
	private String startdate;
	private String enddate;

	// Constructors

	/** default constructor */
	public UmUserGroupRole() {
	}

	/** minimal constructor */
	public UmUserGroupRole(String entitycode, String userid,
			Integer entitykind) {
		this.entitycode = entitycode;
		this.userid = userid;
		this.entitykind = entitykind;
	}

	/** full constructor */
	public UmUserGroupRole(String entitycode, String userid,
			Integer entitykind, String startdate, String enddate) {
		this.entitycode = entitycode;
		this.userid = userid;
		this.entitykind = entitykind;
		this.startdate = startdate;
		this.enddate = enddate;
	}

	// Property accessors

	public String getEntitycode() {
		return this.entitycode;
	}

	public void setEntitycode(String entitycode) {
		this.entitycode = entitycode;
	}

	public String getUserid() {
		return this.userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public Integer getEntitykind() {
		return this.entitykind;
	}

	public void setEntitykind(Integer entitykind) {
		this.entitykind = entitykind;
	}

	public String getStartdate() {
		return this.startdate;
	}

	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}

	public String getEnddate() {
		return this.enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof UmUserGroupRole))
			return false;
		UmUserGroupRole castOther = (UmUserGroupRole) other;

		return ((this.getEntitycode() == castOther.getEntitycode()) || (this
				.getEntitycode() != null && castOther.getEntitycode() != null && this
				.getEntitycode().equals(castOther.getEntitycode())))
				&& ((this.getUserid() == castOther.getUserid()) || (this
						.getUserid() != null && castOther.getUserid() != null && this
						.getUserid().equals(castOther.getUserid())))
				&& ((this.getEntitykind() == castOther.getEntitykind()) || (this
						.getEntitykind() != null
						&& castOther.getEntitykind() != null && this
						.getEntitykind().equals(castOther.getEntitykind())))
				&& ((this.getStartdate() == castOther.getStartdate()) || (this
						.getStartdate() != null
						&& castOther.getStartdate() != null && this
						.getStartdate().equals(castOther.getStartdate())))
				&& ((this.getEnddate() == castOther.getEnddate()) || (this
						.getEnddate() != null && castOther.getEnddate() != null && this
						.getEnddate().equals(castOther.getEnddate())));
	}

	public int hashCode() {
		int result = 17;

		result = 37
				* result
				+ (getEntitycode() == null ? 0 : this.getEntitycode()
						.hashCode());
		result = 37 * result
				+ (getUserid() == null ? 0 : this.getUserid().hashCode());
		result = 37
				* result
				+ (getEntitykind() == null ? 0 : this.getEntitykind()
						.hashCode());
		result = 37 * result
				+ (getStartdate() == null ? 0 : this.getStartdate().hashCode());
		result = 37 * result
				+ (getEnddate() == null ? 0 : this.getEnddate().hashCode());
		return result;
	}

}