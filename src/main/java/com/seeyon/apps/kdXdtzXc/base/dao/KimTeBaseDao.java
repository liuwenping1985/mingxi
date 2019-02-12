package com.seeyon.apps.kdXdtzXc.base.dao;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;
import java.util.Map;

/**
 * Created by taoan on 2016-7-25.
 */
public  class KimTeBaseDao {
    protected JdbcTemplate jdbcTemplate;

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> queryForList(String sql, Object... values) {
        return jdbcTemplate.queryForList(sql, values);
    }

    public int queryForInt(String sql, Object... args) throws DataAccessException {
        return jdbcTemplate.queryForObject(sql, Integer.class, args);
    }

    public long queryForLong(String sql, Object... args) throws DataAccessException {
        return jdbcTemplate.queryForObject(sql, Long.class, args);
    }
}
