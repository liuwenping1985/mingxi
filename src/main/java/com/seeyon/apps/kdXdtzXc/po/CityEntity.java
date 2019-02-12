package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;
import java.util.List;

import com.seeyon.apps.kdXdtzXc.base.ann.POJO;
@POJO(tableName = "City", desc = "机票城市")
public class CityEntity  implements Serializable{
	private String id;
	//"城市三代")
	private String  code ;
	//"国家id ")
	private String  countryID ;
	//"城市id ")
	private String  cityID ;
	//"城市中文名称")
	private String  name ;
	//"城市英文名称")
	private String  name_En;
	// "城市拼音")
	private String  namePinyin ;
	// "省id ")
	private String  provinceID ;
	// " 国家2代 ")
	private String  countryCode ;
	// "国家中文名称")
	private String  countryName ;
	//"国家英文名称")
	private String  countryEname ;
	//"POI类型")
	private String  poiType ;
	// "是否有重复姓名的 标记")
	private String  duplicateCityNameFlag ;
	// "城市简称")
	private String  cnShortSpelling ;
	private List<CityEntity> datas ;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getCountryID() {
		return countryID;
	}
	public void setCountryID(String countryID) {
		this.countryID = countryID;
	}
	public String getCityID() {
		return cityID;
	}
	public void setCityID(String cityID) {
		this.cityID = cityID;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getName_En() {
		return name_En;
	}
	public void setName_En(String name_En) {
		this.name_En = name_En;
	}
	public String getNamePinyin() {
		return namePinyin;
	}
	public void setNamePinyin(String namePinyin) {
		this.namePinyin = namePinyin;
	}
	public String getProvinceID() {
		return provinceID;
	}
	public void setProvinceID(String provinceID) {
		this.provinceID = provinceID;
	}
	public String getCountryCode() {
		return countryCode;
	}
	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}
	public String getCountryName() {
		return countryName;
	}
	public void setCountryName(String countryName) {
		this.countryName = countryName;
	}
	public String getCountryEname() {
		return countryEname;
	}
	public void setCountryEname(String countryEname) {
		this.countryEname = countryEname;
	}
	public String getPoiType() {
		return poiType;
	}
	public void setPoiType(String poiType) {
		this.poiType = poiType;
	}
	public String getDuplicateCityNameFlag() {
		return duplicateCityNameFlag;
	}
	public void setDuplicateCityNameFlag(String duplicateCityNameFlag) {
		this.duplicateCityNameFlag = duplicateCityNameFlag;
	}
	public String getCnShortSpelling() {
		return cnShortSpelling;
	}
	public void setCnShortSpelling(String cnShortSpelling) {
		this.cnShortSpelling = cnShortSpelling;
	}
	public List<CityEntity> getDatas() {
		return datas;
	}
	public void setDatas(List<CityEntity> datas) {
		this.datas = datas;
	}
	@Override
	public String toString() {
		return "CityEntity [" + (id != null ? "id=" + id + ", " : "") + (code != null ? "code=" + code + ", " : "") + (countryID != null ? "countryID=" + countryID + ", " : "") + (cityID != null ? "cityID=" + cityID + ", " : "") + (name != null ? "name=" + name + ", " : "") + (name_En != null ? "name_En=" + name_En + ", " : "") + (namePinyin != null ? "namePinyin=" + namePinyin + ", " : "") + (provinceID != null ? "provinceID=" + provinceID + ", " : "") + (countryCode != null ? "countryCode=" + countryCode + ", " : "") + (countryName != null ? "countryName=" + countryName + ", " : "") + (countryEname != null ? "countryEname=" + countryEname + ", " : "") + (poiType != null ? "poiType=" + poiType + ", " : "") + (duplicateCityNameFlag != null ? "duplicateCityNameFlag=" + duplicateCityNameFlag + ", " : "") + (cnShortSpelling != null ? "cnShortSpelling=" + cnShortSpelling + ", " : "") + (datas != null ? "datas=" + datas : "") + "]";
	}
	public CityEntity(String id, String code, String countryID, String cityID, String name, String name_En, String namePinyin, String provinceID, String countryCode, String countryName, String countryEname, String poiType, String duplicateCityNameFlag, String cnShortSpelling, List<CityEntity> datas) {
		super();
		this.id = id;
		this.code = code;
		this.countryID = countryID;
		this.cityID = cityID;
		this.name = name;
		this.name_En = name_En;
		this.namePinyin = namePinyin;
		this.provinceID = provinceID;
		this.countryCode = countryCode;
		this.countryName = countryName;
		this.countryEname = countryEname;
		this.poiType = poiType;
		this.duplicateCityNameFlag = duplicateCityNameFlag;
		this.cnShortSpelling = cnShortSpelling;
		this.datas = datas;
	}
	public CityEntity() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	

}
