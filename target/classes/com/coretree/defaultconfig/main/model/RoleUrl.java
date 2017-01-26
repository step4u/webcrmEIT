package com.coretree.defaultconfig.main.model;

import com.coretree.defaultconfig.EitStringUtil;

public class RoleUrl {
	private String urlId;
	private String url;
	private String role;
	private String description;
	public String getUrlId() {
		return EitStringUtil.isNullToString(urlId);
	}
	public void setUrlId(String urlId) {
		this.urlId = urlId;
	}
	public String getUrl() {
		return EitStringUtil.isNullToString(url);
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getRole() {
		return EitStringUtil.isNullToString(role);
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getDescription() {
		return EitStringUtil.isNullToString(description);
	}
	public void setDescription(String description) {
		this.description = description;
	}
	@Override
	public String toString() {
		return "RoleUrl [urlId=" + urlId + ", url=" + url + ", role=" + role
				+ ", description=" + description + "]";
	}
}
