package com.coretree.defaultconfig.statis.model;

import java.util.Date;

import com.coretree.defaultconfig.EitDateUtil;
import com.coretree.defaultconfig.EitFormatUtil;
import com.coretree.defaultconfig.EitStringUtil;

public class CallStat {
	private String callId;
	private String regDate;
	private String regHms;
	private String regHour;
	private String telNo;
	private String callTypCd;
	private String agentTransYn;
	private String empNo;
	private String empNm;
	private int callStatSec;
	private Date sdate;
	private String extension;
	private byte direct;
	private byte status;
	
	private int nTotIb; //총인입건수
	private int nTotIbAgTrans; //상담원 연결건수
	private int nTotCb; //콜백건수
	private int nTotIbAban; //포기건수
	private int nTotOut; //아웃바운드
	private int nTotRes; //상담예약건수
	private int nTotExt; //내선건수
	private String answer; //응답율
	
	private String callStatstartDate;
	private String callStatendDate;
	
	private String callStatstartDate2;
	private String callStatendDate2;
	
	public String getCallId() {
		return callId;
	}
	public void setCallId(String callId) {
		this.callId = callId;
	}
	public String getRegDate() {
		//return EitDateUtil.formatDate(EitStringUtil.remove(regDate, '-'),"-");
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	
	public String getRegHour() {
		return regHour;
	}
	public void setRegHour(String regHour) {
		this.regHour = regHour;
	}
	public int getnTotIb() {
		return nTotIb;
	}
	public void setnTotIb(int nTotIb) {
		this.nTotIb = nTotIb;
	}
	public int getnTotIbAgTrans() {
		return nTotIbAgTrans;
	}
	public void setnTotIbAgTrans(int nTotIbAgTrans) {
		this.nTotIbAgTrans = nTotIbAgTrans;
	}
	public int getnTotCb() {
		return nTotCb;
	}
	public void setnTotCb(int nTotCb) {
		this.nTotCb = nTotCb;
	}
	public int getnTotIbAban() {
		return nTotIbAban;
	}
	public void setnTotIbAban(int nTotIbAban) {
		this.nTotIbAban = nTotIbAban;
	}
	public int getnTotOut() {
		return nTotOut;
	}
	public void setnTotOut(int nTotOut) {
		this.nTotOut = nTotOut;
	}
	public int getnTotExt() {
		return nTotExt;
	}
	public void setnTotExt(int nTotExt) {
		this.nTotExt = nTotExt;
	}
	public int getnTotRes() {
		return nTotRes;
	}
	public void setnTotRes(int nTotRes) {
		this.nTotRes = nTotRes;
	}
	public String getCallStatstartDate() {
		return callStatstartDate;
	}
	public void setCallStatstartDate(String callStatstartDate) {
		this.callStatstartDate = callStatstartDate;
	}
	public String getCallStatendDate() {
		return callStatendDate;
	}
	public void setCallStatendDate(String callStatendDate) {
		this.callStatendDate = callStatendDate;
	}
	public String getCallStatstartDate2() {
		return callStatstartDate2;
	}
	public void setCallStatstartDate2(String callStatstartDate2) {
		this.callStatstartDate2 = callStatstartDate2;
	}
	public String getCallStatendDate2() {
		return callStatendDate2;
	}
	public void setCallStatendDate2(String callStatendDate2) {
		this.callStatendDate2 = callStatendDate2;
	}
	public String getAnswer() {
		return EitStringUtil.isNullToString(answer);
	}
	public void setAnswer(String answer) {
		this.answer = answer;
	}

	
	public String getRegHms() {
		return regHms;
	}
	public void setRegHms(String regHms) {
		this.regHms = regHms;
	}
	public String getTelNo() {
		return EitFormatUtil.toTel(EitStringUtil.isNullToString(EitStringUtil.remove(telNo, '-')));
	}
	public void setTelNo(String telNo) {
		this.telNo = telNo;
	}
	public String getCallTypCd() {
		return callTypCd;
	}
	public void setCallTypCd(String callTypCd) {
		this.callTypCd = callTypCd;
	}
	public String getAgentTransYn() {
		return agentTransYn;
	}
	public void setAgentTransYn(String agentTransYn) {
		this.agentTransYn = agentTransYn;
	}
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
	
	public int getCallStatSec() { return callStatSec; }
	public void setCallStatSec(int callStatSec) { this.callStatSec = callStatSec; }
	
	public Date getSdate() { return sdate; }
	public void setSdate(Date sdate) { this.sdate = sdate; }
	
	public String getExtension() { return this.extension; }
	public void setExtension(String extension) { this.extension = extension; }
	
	public byte getDirect() { return this.direct; }
	public void setDirect(byte direct) { this.direct = direct; }
	
	public byte getStatus() { return this.status; }
	public void setStatus(byte status) { this.status = status; }
	
	@Override
	public String toString() {
		return "CallStat [callId=" + callId + ", regDate=" + regDate + ", callStatstartDate= " + callStatstartDate + ", callStatendDate= " + callStatendDate
				+ ", TelNo=" + this.telNo + ", Extension=" + this.extension + "]";
	}
	
}