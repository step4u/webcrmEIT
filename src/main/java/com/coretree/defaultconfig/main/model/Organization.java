package com.coretree.defaultconfig.main.model;

import com.coretree.defaultconfig.EitStringUtil;

public class Organization {
	private String empNo;
	private String empNm;
	private String password;
	private String grpCd;
	private String enterDate;
	private String mobilePhoneNo;
	private String emailId;
	private String extensionNo;
	private String note;
	private String agentStatCd;
	private String newPwd;
	private String role;
	private String modifyDate;
	private int loginFailCnt;
	private String isLock;
	private String lastLoginDate;
	private int existCount;

	private int tempval;
	private String tempstr;

	public String getEmpNo() { return EitStringUtil.isNullToString(empNo); }
	public void setEmpNo(String empNo) { this.empNo = empNo; }

	public String getEmpNm() { return EitStringUtil.isNullToString(empNm); }
	public void setEmpNm(String empNm) { this.empNm = empNm; }
	
	public String getPassword() { return EitStringUtil.isNullToString(password); }
	public void setPassword(String password) { this.password = password; }
	
	public String getGrpCd() { return EitStringUtil.isNullToString(grpCd); }
	public void setGrpCd(String grpCd) { this.grpCd = grpCd; }
	
	public String getEnterDate() { return EitStringUtil.isNullToString(enterDate); }
	public void setEnterDate(String enterDate) { this.enterDate = enterDate; }
	
	public String getMobilePhoneNo() { return EitStringUtil.isNullToString(mobilePhoneNo); }
	public void setMobilePhoneNo(String mobilePhoneNo) { this.mobilePhoneNo = mobilePhoneNo; }
	
	public String getEmailId() { return EitStringUtil.isNullToString(emailId); }
	public void setEmailId(String emailId) { this.emailId = emailId; }
	
	public String getExtensionNo() { return EitStringUtil.isNullToString(extensionNo); }
	public void setExtensionNo(String extensionNo) { this.extensionNo = extensionNo; }
	
	public String getNote() { return EitStringUtil.isNullToString(note); }
	public void setNote(String note) { this.note = note; }
	
	public String getAgentStatCd() { return this.agentStatCd; }
	public void setAgentStatCd(String agentStatCd) { this.agentStatCd = agentStatCd; }
	
	public String getNewPwd() { return EitStringUtil.isNullToString(newPwd); }
	public void setNewPwd(String newPwd) { this.newPwd = newPwd; }
	
	public int getExistCount() { return existCount; }
	public void setExistCount(int existCount) { this.existCount = existCount; }
	
	public int getTempval() { return tempval; }
	public void setTempval(int tempval) { this.tempval = tempval; }
	
	public String getTempstr() { return tempstr; }
	public void setTempstr(String tempstr) { this.tempstr = tempstr; }
	
	public String getRole() {
		return EitStringUtil.isNullToString(role);
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getModifyDate() {
		return EitStringUtil.isNullToString(modifyDate);
	}
	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}
	public int getLoginFailCnt() {
		return loginFailCnt;
	}
	public void setLoginFailCnt(int loginFailCnt) {
		this.loginFailCnt = loginFailCnt;
	}
	public String getIsLock() {
		return EitStringUtil.isNullToString(isLock);
	}
	public void setIsLock(String isLock) {
		this.isLock = isLock;
	}
	public String getLastLoginDate() {
		return EitStringUtil.isNullToString(lastLoginDate);
	}
	public void setLastLoginDate(String lastLoginDate) {
		this.lastLoginDate = lastLoginDate;
	}
	@Override
	public String toString() {
		return "Organization [empNo=" + empNo + ", empNm=" + empNm
				+ ", password=" + password + ", grpCd=" + grpCd
				+ ", enterDate=" + enterDate + ", mobilePhoneNo="
				+ mobilePhoneNo + ", emailId=" + emailId + ", extensionNo="
				+ extensionNo + ", note=" + note + ", agentStatCd="
				+ agentStatCd + ", newPwd=" + newPwd + ", role=" + role
				+ ", modifyDate=" + modifyDate + ", loginFailCnt="
				+ loginFailCnt + ", isLock=" + isLock + ", lastLoginDate="
				+ lastLoginDate + ", existCount=" + existCount + ", tempval="
				+ tempval + ", tempstr=" + tempstr + "]";
	}
}
