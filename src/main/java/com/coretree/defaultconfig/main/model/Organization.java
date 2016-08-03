package com.coretree.defaultconfig.main.model;

import com.coretree.defaultconfig.EitStringUtil;

public class Organization {
	private String empNo;
	private String empNm;
	private String password;
	private String authCd;
	private int existCount;
	private String extensionNo;
	private String newPwd;
	private String state;
	
	public String getEmpNo() {
		return EitStringUtil.isNullToString(empNo);
	}
	public void setEmpNo(String empNo) {
		this.empNo = empNo;
	}
	public String getEmpNm() {
		return EitStringUtil.isNullToString(empNm);
	}
	public void setEmpNm(String empNm) {
		this.empNm = empNm;
	}
	public String getPassword() {
		return EitStringUtil.isNullToString(password);
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getAuthCd() {
		return EitStringUtil.isNullToString(authCd);
	}
	public void setAuthCd(String authCd) {
		this.authCd = authCd;
	}
	public int getExistCount() {
		return existCount;
	}
	public void setExistCount(int existCount) {
		this.existCount = existCount;
	}
	public String getExtensionNo() {
		return EitStringUtil.isNullToString(extensionNo);
	}
	public void setExtensionNo(String extensionNo) {
		this.extensionNo = extensionNo;
	}
	public String getNewPwd() {
		return EitStringUtil.isNullToString(newPwd);
	}
	public void setNewPwd(String newPwd) {
		this.newPwd = newPwd;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	@Override
	public String toString() {
		return "Organization [empNo=" + empNo + ", empNm=" + empNm
				+ ", password=" + password + ", authCd=" + authCd
				+ ", existCount=" + existCount + ", extensionNo=" + extensionNo
				+ ", newPwd=" + newPwd + ", state=" + state + "]";
	}
}
