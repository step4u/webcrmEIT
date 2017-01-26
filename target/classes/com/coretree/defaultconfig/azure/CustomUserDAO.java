package com.coretree.defaultconfig.azure;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Repository;

//EIT ���ο� �׽�Ʈ �����Դϴ�.
//������ �ϼ���.

@Repository
public class CustomUserDAO {
	private static final Logger logger = LoggerFactory.getLogger(CustomUserDAO.class);
	
    private JdbcTemplate jdbcTemplate;
    
    @Autowired
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public CustomUserInfo getUserInfo(String username) throws Exception{

    	try {
	    	String sql = ""; 
	    	List<String> roles = null;
	    	ArrayList<GrantedAuthority>userRoles = null;

	    	sql = "select EMP_NO as USERNAME, PASSWORD, ENABLE, null from TORGANIZATION where EMP_NO=?";
	    	final CustomUserInfo userInfo = (CustomUserInfo)jdbcTemplate.queryForObject(sql, new Object[] { username },
	    			new BeanPropertyRowMapper<CustomUserInfo>(CustomUserInfo.class));
	    	
	    	if (userInfo == null) throw new UsernameNotFoundException("UsernameNotFoundException: "+ username);
	    	
	    	sql = "select  ROLE from TORGANIZATION where EMP_NO=?";
			roles = jdbcTemplate.queryForList(sql, new Object[] { username }, String.class);
	    	if (roles == null) throw new UsernameNotFoundException("UserRolesNotFoundException: "+ username);
			userRoles = new ArrayList<GrantedAuthority>();

			for (String role : roles) {
				userRoles.add(new SimpleGrantedAuthority(role));
			}
			userInfo.setRoles(userRoles);
	    	return userInfo;
    	}
    	catch (Exception e) {
    		logger.error("getUserInfo: "+ e.getMessage());
    		throw e;
    	}
    }
    
} 