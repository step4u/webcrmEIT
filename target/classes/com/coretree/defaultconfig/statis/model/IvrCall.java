package com.coretree.defaultconfig.statis.model;

import com.coretree.defaultconfig.EitDateUtil;
import com.coretree.defaultconfig.EitFormatUtil;
import com.coretree.defaultconfig.EitStringUtil;

public class IvrCall {
	
	private String inboundDate; 
	private String inboudHms;
	private String genDirNo;
	private String telNo;
	private String tmptelNo;
	private String agentContactYN;
	private String callbackSuccessYN;
	private String abandonYN;
	private String empNo;
	private String empNm;
	
	private String ivrstartDate;
	private String ivrendDate;

	public String getInboundDate() {
		//return EitDateUtil.formatDate(EitStringUtil.remove(inboundDate, '-'),"-");
		return inboundDate;
	}
	public void setInboundDate(String inboundDate) {
		this.inboundDate = inboundDate;
	}
	public String getInboudHms() {
		return inboudHms;
	}
	public void setInboudHms(String inboudHms) {
		this.inboudHms = inboudHms;
	}
	
	public String getAgentContactYN() {
		return EitStringUtil.isNullToString(agentContactYN);
	}
	public void setAgentContactYN(String agentContactYN) {
		this.agentContactYN = agentContactYN;
	}
	public String getCallbackSuccessYN() {
		return EitStringUtil.isNullToString(callbackSuccessYN);
	}
	public void setCallbackSuccessYN(String callbackSuccessYN) {
		this.callbackSuccessYN = callbackSuccessYN;
	}
	public String getAbandonYN() {
		return EitStringUtil.isNullToString(abandonYN);
	}
	public void setAbandonYN(String abandonYN) {
		this.abandonYN = abandonYN;
	}
	public String getEmpNo() {
		return  EitStringUtil.isNullToString(empNo);
	}
	public void setEmpNo(String empNo) {
		this.empNo = empNo;
	}
	public String getEmpNm() {
		return  EitStringUtil.isNullToString(empNm);
	}
	public void setEmpNm(String empNm) {
		this.empNm = empNm;
	}
	public String getGenDirNo() {
		return EitStringUtil.isNullToString(genDirNo);
	}
	public void setGenDirNo(String genDirNo) {
		this.genDirNo = genDirNo;
	}
	public String getTelNo() {
		return EitFormatUtil.toTel(EitStringUtil.isNullToString(EitStringUtil.remove(telNo, '-')));
	}
	public void setTelNo(String telNo) {
		this.telNo = telNo;
	}
	public String getTmptelNo() {
		return EitStringUtil.isNullToString(tmptelNo);
	}
	public void setTmptelNo(String tmptelNo) {
		this.tmptelNo = tmptelNo;
	}
	public String getIvrstartDate() {
		return ivrstartDate;
	}
	public void setIvrstartDate(String ivrstartDate) {
		this.ivrstartDate = ivrstartDate;
	}
	public String getIvrendDate() {
		return ivrendDate;
	}
	public void setIvrendDate(String ivrendDate) {
		this.ivrendDate = ivrendDate;
	}
	@Override
	public String toString() {
		return "IvrCall ["
				+ "inboundDate : " + inboundDate + " ,inboudHms : " + inboudHms + " ,genDirNo=" + genDirNo + ", telNo=" + telNo 
				+  ", ivrstartDate :" + ivrstartDate + ", ivrendDate : " + ivrendDate + "]";
	}
	
}
