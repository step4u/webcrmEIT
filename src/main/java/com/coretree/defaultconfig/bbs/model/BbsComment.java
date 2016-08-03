package com.coretree.defaultconfig.bbs.model;

import com.coretree.defaultconfig.EitStringUtil;

public class BbsComment {
   String bbsSeq;
   String commentSeq;
   String regDate;
   String regHms;
   String regEmpNo;
   String regEmpNm;
   String commentNote;
   
   

public String getBbsSeq() {
	return bbsSeq;
}


public void setBbsSeq(String bbsSeq) {
	this.bbsSeq = bbsSeq;
}


public String getCommentSeq() {
	return commentSeq;
}


public void setCommentSeq(String commentSeq) {
	this.commentSeq = commentSeq;
}


public String getRegDate() {
	return regDate;
}


public void setRegDate(String regDate) {
	this.regDate = regDate;
}


public String getRegHms() {
	return regHms;
}


public void setRegHms(String regHms) {
	this.regHms = regHms;
}


public String getRegEmpNo() {
	return regEmpNo;
}


public void setRegEmpNo(String regEmpNo) {
	this.regEmpNo = regEmpNo;
}


public String getRegEmpNm() {
	return EitStringUtil.isNullToString(regEmpNm);
}


public void setRegEmpNm(String regEmpNm) {
	this.regEmpNm = regEmpNm;
}


public String getCommentNote() {
	return commentNote;
}


public void setCommentNote(String commentNote) {
	this.commentNote = commentNote;
}


	@Override
	public String toString() {
		return "BbsComment [bbsSeq=" + bbsSeq + ", commentSeq=" + commentSeq
				+ ", regDate=" + regDate + ", regHms=" + regHms + ", regEmpNo=" + regEmpNo + ", commentNote=" + regEmpNm + ", regEmpNm="
				+ commentNote + "]";
	}

}
