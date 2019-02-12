package com.seeyon.apps.kdXdtzXc.base.util;

import java.util.HashMap;
import java.util.Map;

public class MapWapper<T, V> {
	private Map<T, V> map = new HashMap<T, V>();

	public MapWapper<T, V> add(T key, V value) {
		map.put(key, value);
		return this;
	}

	public MapWapper<T, V> add(Map<T, V> map) {
		this.map.putAll(map);
		return this;
	}

	public Map<T, V> addToMap(T key, V value) {
		map.put(key, value);
		return map;
	}

	public Map<T, V> toMap() {
		return this.map;
	}

	public void clean() {
		map.clear();
	}

	public void remove(T key) {
		map.remove(key);
	}
}
