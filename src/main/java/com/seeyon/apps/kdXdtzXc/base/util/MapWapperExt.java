package com.seeyon.apps.kdXdtzXc.base.util;

import java.util.Map;

public class MapWapperExt extends MapWapper<String, Object> {
	public MapWapperExt add(String key, Object value) {
		super.add(key, value);
		return this;
	}

	public Map<String, Object> toMap() {
		return super.toMap();
	}

	public void clean() {
		super.clean();
	}

	public void remove(String key) {
		super.remove(key);
	}
}
