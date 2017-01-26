package com.coretree.defaultconfig.azure;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
//import org.springframework.stereotype.Service;

@Component
public class CustomUserDetailsService implements UserDetailsService{
	
//	private static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsService.class);

	@Autowired
	private CustomUserDAO userDAO;

	@Override
	public UserDetails loadUserByUsername(String username)
			throws UsernameNotFoundException {
		
		username = username.trim();
		
		CustomUserInfo userInfo;
		try {
			userInfo = userDAO.getUserInfo(username);
		} 
		catch (Exception e) {
			throw new UsernameNotFoundException(e.getMessage());
		}
		UserDetails userDetails = (UserDetails)new User(userInfo.getUsername(), 
				userInfo.getPassword(), userInfo.getRoles());
		userInfo.release();
		
		return userDetails;
	}
} 
