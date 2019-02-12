package com.seeyon.apps.kdXdtzXc.rest.util;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

/**
 * Created by taoan on 2017-1-15.
 */
public class ZzdlJsonObject {
    private JSONObject jsonObject;

    public ZzdlJsonObject(Object o) {
          this.jsonObject = new JSONObject(o);


    }
  public ZzdlJsonObject(Map map) {
          this.jsonObject = new JSONObject(map);


    }

    public ZzdlJsonObject put(String name, boolean value) {
        try {
            jsonObject.put(name, value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return this;
    }


    public ZzdlJsonObject put(String name, double value) {
        try {
            jsonObject.put(name, value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return this;
    }

    public ZzdlJsonObject put(String name, int value) {
        try {
            jsonObject.put(name, value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return this;
    }

    public ZzdlJsonObject put(String name, long value) {
        try {
            jsonObject.put(name, value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return this;
    }

    public ZzdlJsonObject put(String name, Map value) {
        try {
            jsonObject.put(name, value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return this;
    }

    public ZzdlJsonObject put(String name, Object value) {
        try {
            jsonObject.put(name, value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return this;
    }

    /**
     * @param name 不需要的字段信息
     * @return
     */
    public ZzdlJsonObject remove(String name) {

        jsonObject.remove(name);
        return this;
    }

    public String toJson() {
        return jsonObject.toString();
    }


}
