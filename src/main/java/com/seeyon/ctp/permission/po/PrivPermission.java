package com.seeyon.ctp.permission.po;

import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.util.UUIDLong;


/**
 * This is an object that contains data related to the PRIV_PERMISSION table.
 *
 *  注册数与并发数按照单位分配和控制 
 *
 * @hibernate.class
 *  table="PRIV_PERMISSION"
 */
public class PrivPermission extends BasePO {

/*[IDTCODE MARKER BEGIN]*/


  // fields
  /**
   *  控制方式，1：注册数，2：并发数 
   */
  private java.lang.Integer _type;
  /**
   *  分配数量 
   */
  private java.lang.Long _distributionnum = 0L;
  /**
   *  所属单位 
   */
  private java.lang.Long _orgAccountId;
  /**
   *  创建时间 
   */
  private java.util.Date _createdate;
  /**
   *  创建人员 
   */
  private java.lang.Long _createuserid;
  /**
   *  更新时间 
   */
  private java.util.Date _updatedate;
  /**
   *  更新人员 
   */
  private java.lang.Long _updateuserid;
  /**
   *  许可类型，1：A8/A6server，2：M1，3：致信
   */
  private java.lang.Integer _lictype;


  // constructors
  public PrivPermission () {
    initialize();
  }

  /**
   * Constructor for primary key
   */
  public PrivPermission (java.lang.Long _id) {
    this.setId(_id);
    initialize();
  }

  protected void initialize () {}

  public void setIdIfNew() {
      if(this.id == null){
          this.id = UUIDLong.longUUID();
      }
  }

  /**
   *  控制方式，1：注册数，2：并发数 
   */
  public java.lang.Integer getType () {
    return _type;
  }

  /**
   *  控制方式，1：注册数，2：并发数 
   * @param _type the TYPE value
   */
  public void setType (java.lang.Integer _type) {
    this._type = _type;
  }


  /**
   *  分配数量 
   */
  public java.lang.Long getDistributionnum () {
	  
    return _distributionnum;
  }

  /**
   *  分配数量 
   * @param _distributionnum the DISTRIBUTIONNUM value
   */
  public void setDistributionnum (java.lang.Long _distributionnum) {
    this._distributionnum = _distributionnum;
  }


  /**
   *  所属单位 
   */
  public java.lang.Long getOrgAccountId () {
    return _orgAccountId;
  }

  /**
   *  所属单位 
   * @param _orgAccountId the ORG_ACCOUNT_ID value
   */
  public void setOrgAccountId (java.lang.Long _orgAccountId) {
    this._orgAccountId = _orgAccountId;
  }


  /**
   *  创建时间 
   */
  public java.util.Date getCreatedate () {
    return _createdate;
  }

  /**
   *  创建时间 
   * @param _createdate the CREATEDATE value
   */
  public void setCreatedate (java.util.Date _createdate) {
    this._createdate = _createdate;
  }


  /**
   *  创建人员 
   */
  public java.lang.Long getCreateuserid () {
    return _createuserid;
  }

  /**
   *  创建人员 
   * @param _createuserid the CREATEUSERID value
   */
  public void setCreateuserid (java.lang.Long _createuserid) {
    this._createuserid = _createuserid;
  }


  /**
   *  更新时间 
   */
  public java.util.Date getUpdatedate () {
    return _updatedate;
  }

  /**
   *  更新时间 
   * @param _updatedate the UPDATEDATE value
   */
  public void setUpdatedate (java.util.Date _updatedate) {
    this._updatedate = _updatedate;
  }


  /**
   *  更新人员 
   */
  public java.lang.Long getUpdateuserid () {
    return _updateuserid;
  }

  /**
   *  更新人员 
   * @param _updateuserid the UPDATEUSERID value
   */
  public void setUpdateuserid (java.lang.Long _updateuserid) {
    this._updateuserid = _updateuserid;
  }


  /**
   *  许可类型，1：A8/A6server，2：M1，3：致信
   */
  public java.lang.Integer getLictype () {
    return _lictype;
  }

  /**
   *  许可类型，1：A8/A6server，2：M1，3：致信
   * @param _lictype the LICTYPE value
   */
  public void setLictype (java.lang.Integer _lictype) {
    this._lictype = _lictype;
  }


/*[IDTCODE MARKER END]*/

}