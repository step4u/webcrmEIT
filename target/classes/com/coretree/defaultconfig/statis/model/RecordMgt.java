package com.coretree.defaultconfig.statis.model;

import com.coretree.defaultconfig.EitFormatUtil;
import com.coretree.defaultconfig.EitStringUtil;

public class RecordMgt {
	private int recSeq; //녹취번호
	private String extensionNo; //내선번호
	private String empNo; //상담원번호
	private String telNo; //전화번호
	private String tmptelNo; //전화번호
	private String callTypCd; //콜유형코드
	private String recStartDate; //녹취시작일
	private String recStartHms; //녹취시작시간
	private String recEndDate; //녹취종료일
	private String recEndHms; //녹취종료시간
	private int fileSize; //파일크기
	private String fileName; //파일명
	private String callId; //CALL ID - 교환기에서 발생하며 데이터 저장
	
	private String startDate; //통화일자 날짜비교
	private String endDate; //통화일자 날짜비교

	public int getRecSeq() {
		return recSeq;
	}
	public void setRecSeq(int recSeq) {
		this.recSeq = recSeq;
	}
	public String getExtensionNo() {
		return extensionNo;
	}
	public void setExtensionNo(String extensionNo) {
		this.extensionNo = extensionNo;
	}
	public String getEmpNo() {
		return empNo;
	}
	public void setEmpNo(String empNo) {
		this.empNo = empNo;
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
	public String getCallTypCd() {
		return EitStringUtil.isNullToString(callTypCd);
	}
	public void setCallTypCd(String callTypCd) {
		this.callTypCd = callTypCd;
	}
	public String getRecStartDate() {
		return recStartDate;
	}
	public void setRecStartDate(String recStartDate) {
		this.recStartDate = recStartDate;
	}
	public String getRecStartHms() {
		return recStartHms;
	}
	public void setRecStartHms(String recStartHms) {
		this.recStartHms = recStartHms;
	}
	public String getRecEndDate() {
		return recEndDate;
	}
	public void setRecEndDate(String recEndDate) {
		this.recEndDate = recEndDate;
	}
	public String getRecEndHms() {
		return recEndHms;
	}
	public void setRecEndHms(String recEndHms) {
		this.recEndHms = recEndHms;
	}
	public int getFileSize() {
		return fileSize;
	}
	public void setFileSize(int fileSize) {
		this.fileSize = fileSize;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getCallId() {
		return callId;
	}
	public void setCallId(String callId) {
		this.callId = callId;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	@Override
	public String toString() {
		return "RecordMgt [recSeq=" + recSeq + ", extensionNo=" + extensionNo
				+ ", empNo=" + empNo + ", telNo=" + telNo + ", callTypCd=" + callTypCd 
				+ ", recStartDate=" + recStartDate + ", recStartHms=" + recStartHms + ", recEndDate=" + recEndDate 
				+ ", recEndHms=" + recEndHms + ", fileSize=" + fileSize + ", fileName=" + fileName + ", callId=" + callId + "]";
	}
	
}
