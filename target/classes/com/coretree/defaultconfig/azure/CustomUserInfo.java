package com.coretree.defaultconfig.azure;

import java.util.ArrayList;

import org.springframework.security.core.GrantedAuthority;

//EIT ���ο� �׽�Ʈ �����Դϴ�.
//������ �ϼ���.

public class CustomUserInfo {
	private String	username;
	private String	password;
	private int		enabled;

	private ArrayList<GrantedAuthority> roles;

	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}

	public int getEnabled() {
		return enabled;
	}
	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}
	
	public ArrayList<GrantedAuthority> getRoles() {
		return roles;
	}
	public void setRoles(ArrayList<GrantedAuthority> roles) {
		this.roles = roles;
	}
	public void removeRoles() {
		this.roles.clear();
	}

	public void release() {
		this.username = null;
		this.password = null;
		this.enabled = 0;
		removeRoles();
	}
	@Override
	public String toString() {
		return "CustomUserInfo [username=" + username + ", password="
				+ password + ", enabled=" + enabled + ", roles=" + roles + "]";
	}
	
} 