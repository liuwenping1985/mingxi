package com.seeyon.apps.dev.doc.utils;

import java.util.HashMap;
import java.util.Map;

import com.seeyon.apps.doc.po.DocResourcePO;

@SuppressWarnings("serial")
public class ExportMap<K,V> extends HashMap<K,V> {
	private Map <K,V> stateMap = new HashMap<K, V>();
	private Map <K,V> resourceMap = new HashMap<K, V>();
	
	public Map<K,V> getResourceMap() {
		return resourceMap;
	}
	public V getResource(K key){
		return this.resourceMap.get(key);
	}
	public V[] put(K key, V... value){
		for (V v : value) {
			if(v instanceof Boolean){
				this.stateMap.put(key, v);
			}else if(v instanceof DocResourcePO){
				this.resourceMap.put(key, v);
			}else{
				super.put(key, v);
			}

		}
		return value;
	}

	public boolean containsState(Boolean state){
		return stateMap.containsValue(state);
	}
	public boolean isThird_hasPingHole(Long id){
		boolean b = (Boolean) this.stateMap.get(id);
		return b;
	}
	public void putAll(ExportMap<? extends K, ? extends V> m){
		super.putAll(m);
		this.stateMap.putAll(m.stateMap);
		this.resourceMap.putAll(m.getResourceMap());
	}
	public String toIdString(){
		String ids = this.keySet().toString();
		
		if(ids.startsWith("[") && ids.endsWith("]")){
			ids = ids.substring(1, ids.length()-1);
			return ids;
		}
		return "";
	}
	@Override
    public V remove(Object key) {
		this.resourceMap.remove(key);
		this.stateMap.remove(key);
    	return super.remove(key);
    }
}
