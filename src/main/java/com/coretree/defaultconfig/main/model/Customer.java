package com.coretree.defaultconfig.main.model;

import java.util.Arrays;

import com.coretree.defaultconfig.EitStringUtil;

public class Customer {
	private String custCd;
	private String custCdNm;
	private String custNo;
	private String[] custNos;
	private String custNm;
	private String telNo;
	private String tel1No;
	private String tel2No;
	private String tel3No;
	private String faxNo;
	private String addr;
	private String emailId;
	private String custNote;
	private long existCnt;
	private String existCode;
	private String regDate;
	
	private String outValue;
	
	public String getOutValue() {
		return outValue;
	}
	public void setOutValue(String outValue) {
		this.outValue = outValue;
	}
	public String getCustCd() {
		return EitStringUtil.isNullToString(custCd);
	}
	public void setCustCd(String custCd) {
		this.custCd = custCd;
	}
	public String getCustCdNm() {
		return EitStringUtil.isNullToString(custCdNm);
	}
	public void setCustCdNm(String custCdNm) {
		this.custCdNm = custCdNm;
	}
	public String getCustNo() {
		return EitStringUtil.isNullToString(custNo);
	}
	public void setCustNo(String custNo) {
		this.custNo = custNo;
	}
	public String getCustNm() {
		return EitStringUtil.isNullToString(custNm);
	}
	public void setCustNm(String custNm) {
		this.custNm = custNm;
	}
	public String getTelNo() {
		return EitStringUtil.isNullToString(telNo);
	}
	public void setTelNo(String telNo) {
		this.telNo = telNo;
	}
	public String getTel1No() {
		return EitStringUtil.isNullToString(tel1No);
	}
	public void setTel1No(String tel1No) {
		this.tel1No = tel1No;
	}
	public String getTel2No() {
		return EitStringUtil.isNullToString(tel2No);
	}
	public void setTel2No(String tel2No) {
		this.tel2No = tel2No;
	}
	public String getTel3No() {
		return EitStringUtil.isNullToString(tel3No);
	}
	public void setTel3No(String tel3No) {
		this.tel3No = tel3No;
	}
	public String getFaxNo() {
		return EitStringUtil.isNullToString(faxNo);
	}
	public void setFaxNo(String faxNo) {
		this.faxNo = faxNo;
	}
	public String getAddr() {
		return EitStringUtil.isNullToString(addr);
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getEmailId() {
		return EitStringUtil.isNullToString(emailId);
	}
	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}
	public String getCustNote() {
		return EitStringUtil.isNullToString(custNote);
	}
	public void setCustNote(String custNote) {
		this.custNote = custNote;
	}
	public long getExistCnt() {
		return existCnt;
	}
	public void setExistCnt(long existCnt) {
		this.existCnt = existCnt;
	}
	public String getExistCode() {
		return existCode;
	}
	public void setExistCode(String existCode) {
		this.existCode = existCode;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	@Override
	public String toString() {
		return "Customer [custCd=" + custCd + ", custCdNm=" + custCdNm
				+ ", custNo=" + custNo + ", custNos="
				+ Arrays.toString(custNos) + ", custNm=" + custNm + ", telNo="
				+ telNo + ", tel1No=" + tel1No + ", tel2No=" + tel2No
				+ ", tel3No=" + tel3No + ", faxNo=" + faxNo + ", addr=" + addr
				+ ", emailId=" + emailId + ", custNote=" + custNote
				+ ", existCnt=" + existCnt +  "]";
	}
	public String[] getCustNos() {
		return custNos;
	}
	public void setCustNos(String[] custNos) {
		this.custNos = custNos;
	}
}