package com.coretree.defaultconfig.setting.model;

public class Torganization {
	String empNo;  //사번
	String empNm; //이름
	int grpCd; //상담그룹코드
	String enterDate; //입사일
	String authCd; //권한코드
	String mobilePhoneNo; //핸드폰번호
	String emailId; //이메일
	String extensionNo; //내선번호
	String password; //비밀번호
	String note; //비고
	
	public String getEmpNo() {
		return empNo;
	}


	public void setEmpNo(String empNo) {
		this.empNo = empNo;
	}


	public String getEmpNm() {
		return empNm;
	}


	public void setEmpNm(String empNm) {
		this.empNm = empNm;
	}


	public int getGrpCd() {
		return grpCd;
	}


	public void setGrpCd(int grpCd) {
		this.grpCd = grpCd;
	}


	public String getEnterDate() {
		return enterDate;
	}


	public void setEnterDate(String enterDate) {
		this.enterDate = enterDate;
	}


	public String getAuthCd() {
		return authCd;
	}


	public void setAuthCd(String authCd) {
		this.authCd = authCd;
	}


	public String getMobilePhoneNo() {
		return mobilePhoneNo;
	}


	public void setMobilePhoneNo(String mobilePhoneNo) {
		this.mobilePhoneNo = mobilePhoneNo;
	}


	public String getEmailId() {
		return emailId;
	}


	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}


	public String getExtensionNo() {
		return extensionNo;
	}


	public void setExtensionNo(String extensionNo) {
		this.extensionNo = extensionNo;
	}


	public String getPassword() {
		return password;
	}


	public void setPassword(String password) {
		this.password = password;
	}


	public String getNote() {
		return note;
	}


	public void setNote(String note) {
		this.note = note;
	}


	@Override
	public String toString() {
		return "Torganization [empNo=" + empNo + ", empNm=" + empNm
				+ ", grpCd=" + grpCd + ", enterDate=" + enterDate + ", authCd=" + authCd
				+ ", mobilePhoneNo=" + mobilePhoneNo 
				+ ", emailId=" + emailId + ", extensionNo=" + extensionNo 
				+ ", password=" + password + ", note=" + note + "]";
	}
	
}
