package com.seeyon.apps.cinda.authority.domain;

import java.util.Date;

/**
 * UmRole entity. @author MyEclipse Persistence Tools
 */

public class UmRole implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 524534578250056609L;
	private String rolecode;
	private String rolename;
	private Integer rolekind;
	private String description;
	private Integer appsystem;
	private String expression;
	private String checkone;
	private String checktwo;
	private String checkthree;
	private Date createdate;
	private String creator;
	private String roletype;
	private String resourcescope;

	// Constructors

	/** default constructor */
	public UmRole() {
	}

	/** minimal constructor */
	public UmRole(String rolecode) {
		this.rolecode = rolecode;
	}

	/** full constructor */
	public UmRole(String rolecode, String rolename, Integer rolekind,
			String description, Integer appsystem, String expression,
			String checkone, String checktwo, String checkthree,
			Date createdate, String creator, String roletype,
			String resourcescope) {
		this.rolecode = rolecode;
		this.rolename = rolename;
		this.rolekind = rolekind;
		this.description = description;
		this.appsystem = appsystem;
		this.expression = expression;
		this.checkone = checkone;
		this.checktwo = checktwo;
		this.checkthree = checkthree;
		this.createdate = createdate;
		this.creator = creator;
		this.roletype = roletype;
		this.resourcescope = resourcescope;
	}

	// Property accessors

	public String getRolecode() {
		return this.rolecode;
	}

	public void setRolecode(String rolecode) {
		this.rolecode = rolecode;
	}

	public String getRolename() {
		return this.rolename;
	}

	public void setRolename(String rolename) {
		this.rolename = rolename;
	}



	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}



	public Integer getRolekind() {
		return rolekind;
	}

	public void setRolekind(Integer rolekind) {
		this.rolekind = rolekind;
	}

	public Integer getAppsystem() {
		return appsystem;
	}

	public void setAppsystem(Integer appsystem) {
		this.appsystem = appsystem;
	}

	public String getExpression() {
		return this.expression;
	}

	public void setExpression(String expression) {
		this.expression = expression;
	}

	public String getCheckone() {
		return this.checkone;
	}

	public void setCheckone(String checkone) {
		this.checkone = checkone;
	}

	public String getChecktwo() {
		return this.checktwo;
	}

	public void setChecktwo(String checktwo) {
		this.checktwo = checktwo;
	}

	public String getCheckthree() {
		return this.checkthree;
	}

	public void setCheckthree(String checkthree) {
		this.checkthree = checkthree;
	}

	public Date getCreatedate() {
		return this.createdate;
	}

	public void setCreatedate(Date createdate) {
		this.createdate = createdate;
	}

	public String getCreator() {
		return this.creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getRoletype() {
		return this.roletype;
	}

	public void setRoletype(String roletype) {
		this.roletype = roletype;
	}

	public String getResourcescope() {
		return this.resourcescope;
	}

	public void setResourcescope(String resourcescope) {
		this.resourcescope = resourcescope;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("UmRole [rolecode=");
		builder.append(rolecode);
		builder.append(", rolename=");
		builder.append(rolename);
		builder.append(", rolekind=");
		builder.append(rolekind);
		builder.append(", description=");
		builder.append(description);
		builder.append(", appsystem=");
		builder.append(appsystem);
		builder.append(", expression=");
		builder.append(expression);
		builder.append(", checkone=");
		builder.append(checkone);
		builder.append(", checktwo=");
		builder.append(checktwo);
		builder.append(", checkthree=");
		builder.append(checkthree);
		builder.append(", createdate=");
		builder.append(createdate);
		builder.append(", creator=");
		builder.append(creator);
		builder.append(", roletype=");
		builder.append(roletype);
		builder.append(", resourcescope=");
		builder.append(resourcescope);
		builder.append("]");
		return builder.toString();
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((appsystem == null) ? 0 : appsystem.hashCode());
		result = prime * result
				+ ((checkone == null) ? 0 : checkone.hashCode());
		result = prime * result
				+ ((checkthree == null) ? 0 : checkthree.hashCode());
		result = prime * result
				+ ((checktwo == null) ? 0 : checktwo.hashCode());
		result = prime * result
				+ ((createdate == null) ? 0 : createdate.hashCode());
		result = prime * result + ((creator == null) ? 0 : creator.hashCode());
		result = prime * result
				+ ((description == null) ? 0 : description.hashCode());
		result = prime * result
				+ ((expression == null) ? 0 : expression.hashCode());
		result = prime * result
				+ ((resourcescope == null) ? 0 : resourcescope.hashCode());
		result = prime * result
				+ ((rolecode == null) ? 0 : rolecode.hashCode());
		result = prime * result
				+ ((rolekind == null) ? 0 : rolekind.hashCode());
		result = prime * result
				+ ((rolename == null) ? 0 : rolename.hashCode());
		result = prime * result
				+ ((roletype == null) ? 0 : roletype.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		UmRole other = (UmRole) obj;
		if (appsystem == null) {
			if (other.appsystem != null)
				return false;
		} else if (!appsystem.equals(other.appsystem))
			return false;
		if (checkone == null) {
			if (other.checkone != null)
				return false;
		} else if (!checkone.equals(other.checkone))
			return false;
		if (checkthree == null) {
			if (other.checkthree != null)
				return false;
		} else if (!checkthree.equals(other.checkthree))
			return false;
		if (checktwo == null) {
			if (other.checktwo != null)
				return false;
		} else if (!checktwo.equals(other.checktwo))
			return false;
		if (createdate == null) {
			if (other.createdate != null)
				return false;
		} else if (!createdate.equals(other.createdate))
			return false;
		if (creator == null) {
			if (other.creator != null)
				return false;
		} else if (!creator.equals(other.creator))
			return false;
		if (description == null) {
			if (other.description != null)
				return false;
		} else if (!description.equals(other.description))
			return false;
		if (expression == null) {
			if (other.expression != null)
				return false;
		} else if (!expression.equals(other.expression))
			return false;
		if (resourcescope == null) {
			if (other.resourcescope != null)
				return false;
		} else if (!resourcescope.equals(other.resourcescope))
			return false;
		if (rolecode == null) {
			if (other.rolecode != null)
				return false;
		} else if (!rolecode.equals(other.rolecode))
			return false;
		if (rolekind == null) {
			if (other.rolekind != null)
				return false;
		} else if (!rolekind.equals(other.rolekind))
			return false;
		if (rolename == null) {
			if (other.rolename != null)
				return false;
		} else if (!rolename.equals(other.rolename))
			return false;
		if (roletype == null) {
			if (other.roletype != null)
				return false;
		} else if (!roletype.equals(other.roletype))
			return false;
		return true;
	}
	

}