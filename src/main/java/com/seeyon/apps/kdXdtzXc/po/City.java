package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;
import java.util.List;

public class City  implements Serializable{
	private String id;
	//携程的城市id
	private String 	City;
	//城市英文名称
	private String CityEName;
	//城市中文名称
	private String CityName;	
	//城市简拼
	private String JianPin	;	
	//国家id
	private String Country;
	//国家英文名称
	private String CountryEName;	
	//国家中文名称
	private String CountryName;	
	//省份id
	private String Province;
	//省份英文名称
	private String ProvinceEName;
	//省份中文名称
	private String ProvinceName;
	
	private List<City> data ;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCity() {
		return City;
	}

	public void setCity(String city) {
		City = city;
	}

	public String getCityEName() {
		return CityEName;
	}

	public void setCityEName(String cityEName) {
		CityEName = cityEName;
	}

	public String getCityName() {
		return CityName;
	}

	public void setCityName(String cityName) {
		CityName = cityName;
	}

	public String getJianPin() {
		return JianPin;
	}

	public void setJianPin(String jianPin) {
		JianPin = jianPin;
	}

	public String getCountry() {
		return Country;
	}

	public void setCountry(String country) {
		Country = country;
	}

	public String getCountryEName() {
		return CountryEName;
	}

	public void setCountryEName(String countryEName) {
		CountryEName = countryEName;
	}

	public String getCountryName() {
		return CountryName;
	}

	public void setCountryName(String countryName) {
		CountryName = countryName;
	}

	public String getProvince() {
		return Province;
	}

	public void setProvince(String province) {
		Province = province;
	}

	public String getProvinceEName() {
		return ProvinceEName;
	}

	public void setProvinceEName(String provinceEName) {
		ProvinceEName = provinceEName;
	}

	public String getProvinceName() {
		return ProvinceName;
	}

	public void setProvinceName(String provinceName) {
		ProvinceName = provinceName;
	}

	public List<City> getData() {
		return data;
	}

	public void setData(List<City> data) {
		this.data = data;
	}

	@Override
	public String toString() {
		return "City [id=" + id + ", City=" + City + ", CityEName=" + CityEName + ", CityName=" + CityName + ", JianPin=" + JianPin + ", Country=" + Country + ", CountryEName=" + CountryEName + ", CountryName=" + CountryName + ", Province=" + Province + ", ProvinceEName=" + ProvinceEName + ", ProvinceName=" + ProvinceName + ", data=" + data + "]";
	}

	public City(String id, String city, String cityEName, String cityName, String jianPin, String country, String countryEName, String countryName, String province, String provinceEName, String provinceName, List<City> data) {
		super();
		this.id = id;
		City = city;
		CityEName = cityEName;
		CityName = cityName;
		JianPin = jianPin;
		Country = country;
		CountryEName = countryEName;
		CountryName = countryName;
		Province = province;
		ProvinceEName = provinceEName;
		ProvinceName = provinceName;
		this.data = data;
	}

	public City() {
	}
	
}
