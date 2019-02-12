package com.seeyon.apps.cinda.authority.domain;


/**
 * UmGroupRoleAuthorityId entity. @author MyEclipse Persistence Tools
 */

public class UmGroupRoleAuthority implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 1967516855877174065L;
	private String entitycode;
	private Integer entitykind;
	private Integer issublicence;
	private String authorityid;
	private String tmp;

	// Constructors

	/** default constructor */
	public UmGroupRoleAuthority() {
	}

	/** minimal constructor */
	public UmGroupRoleAuthority(String entitycode, Integer entitykind,
			String authorityid) {
		this.entitycode = entitycode;
		this.entitykind = entitykind;
		this.authorityid = authorityid;
	}

	/** full constructor */
	public UmGroupRoleAuthority(String entitycode, Integer entitykind,
			Integer issublicence, String authorityid, String tmp) {
		this.entitycode = entitycode;
		this.entitykind = entitykind;
		this.issublicence = issublicence;
		this.authorityid = authorityid;
		this.tmp = tmp;
	}

	// Property accessors

	public String getEntitycode() {
		return this.entitycode;
	}

	public void setEntitycode(String entitycode) {
		this.entitycode = entitycode;
	}

	public Integer getEntitykind() {
		return this.entitykind;
	}

	public void setEntitykind(Integer entitykind) {
		this.entitykind = entitykind;
	}

	public Integer getIssublicence() {
		return this.issublicence;
	}

	public void setIssublicence(Integer issublicence) {
		this.issublicence = issublicence;
	}

	public String getAuthorityid() {
		return this.authorityid;
	}

	public void setAuthorityid(String authorityid) {
		this.authorityid = authorityid;
	}

	public String getTmp() {
		return this.tmp;
	}

	public void setTmp(String tmp) {
		this.tmp = tmp;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof UmGroupRoleAuthority))
			return false;
		UmGroupRoleAuthority castOther = (UmGroupRoleAuthority) other;

		return ((this.getEntitycode() == castOther.getEntitycode()) || (this
				.getEntitycode() != null && castOther.getEntitycode() != null && this
				.getEntitycode().equals(castOther.getEntitycode())))
				&& ((this.getEntitykind() == castOther.getEntitykind()) || (this
						.getEntitykind() != null
						&& castOther.getEntitykind() != null && this
						.getEntitykind().equals(castOther.getEntitykind())))
				&& ((this.getIssublicence() == castOther.getIssublicence()) || (this
						.getIssublicence() != null
						&& castOther.getIssublicence() != null && this
						.getIssublicence().equals(castOther.getIssublicence())))
				&& ((this.getAuthorityid() == castOther.getAuthorityid()) || (this
						.getAuthorityid() != null
						&& castOther.getAuthorityid() != null && this
						.getAuthorityid().equals(castOther.getAuthorityid())))
				&& ((this.getTmp() == castOther.getTmp()) || (this.getTmp() != null
						&& castOther.getTmp() != null && this.getTmp().equals(
						castOther.getTmp())));
	}

	public int hashCode() {
		int result = 17;

		result = 37
				* result
				+ (getEntitycode() == null ? 0 : this.getEntitycode()
						.hashCode());
		result = 37
				* result
				+ (getEntitykind() == null ? 0 : this.getEntitykind()
						.hashCode());
		result = 37
				* result
				+ (getIssublicence() == null ? 0 : this.getIssublicence()
						.hashCode());
		result = 37
				* result
				+ (getAuthorityid() == null ? 0 : this.getAuthorityid()
						.hashCode());
		result = 37 * result
				+ (getTmp() == null ? 0 : this.getTmp().hashCode());
		return result;
	}

}