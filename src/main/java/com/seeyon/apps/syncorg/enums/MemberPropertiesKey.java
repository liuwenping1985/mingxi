package com.seeyon.apps.syncorg.enums;


/*
 * 在年度预算中， 用于是否是草稿的标志
 */
public enum MemberPropertiesKey  {
    officenumber,
    telnumber,
    emailaddress,
    birthday,
    gender;
    public static MemberPropertiesKey getByName(String name){
    	for (MemberPropertiesKey propertie : MemberPropertiesKey.values()) {
			if(propertie.name().equals(name)){
				return propertie;
			}
		}
		return null;
    }
}


