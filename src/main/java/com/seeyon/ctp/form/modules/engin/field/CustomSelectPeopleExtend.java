package com.seeyon.ctp.form.modules.engin.field;

import java.io.Serializable;

public class CustomSelectPeopleExtend extends FormFieldCustomExtendDesignManager implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9061383794124022094L;

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return "customSelectPeople";
	}

	@Override
	public String getImage() {
		// TODO Auto-generated method stub
		return "/seeyon/apps_res/v3xmain/images/rtx.gif";
	}

	@Override
	public String getJsFileURL() {
		// TODO Auto-generated method stub
		return "/seeyon/plugin/customSelectPeople.do?method=showLeader";
	}

	@Override
	public String getName() {
		// TODO Auto-generated method stub
		return "签报主送领导";
	}

	@Override
	public String getOnClickEvent() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getSort() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getValueType() {
		// TODO Auto-generated method stub
		return "text";
	}

	@Override
	public int getWindowHeight() {
		// TODO Auto-generated method stub
		return 500;
	}

	@Override
	public int getWindowWidth() {
		// TODO Auto-generated method stub
		return 800;
	}

}
