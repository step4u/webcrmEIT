package com.coretree.defaultconfig.statis.model;

import com.coretree.defaultconfig.EitDateUtil;
import com.coretree.defaultconfig.EitStringUtil;

public class AgentStat {
	private String regDate;
	private String regHour;
	private String empNo;
	private String empNm;
	private int nInbound; //인바운드_건수
	private int tInbound; //인바운드 통화시간(초)
	private String tInboundFmt;
	private int nOutbound; //아웃바운드_건수
	private int tOutbound; //아웃바운드 통화시간(초)
	private String tOutboundFmt;
	private int nExtension; //내선통화_건수
	private int tExtension; //내선통화_시간(초)
	private String tExtensionFmt;
	private int tAgentStat1011; //상담원상태_대기
	private String tAgentStat1011Fmt;
	private int tAgentStat1012; //상담원상태_후처리
	private String tAgentStat1012Fmt;
	private int tAgentStat1013; //상담원상태_이석
	private String tAgentStat1013Fmt;
	private int tAgentStat1014; //상담원상태_휴식
	private String tAgentStat1014Fmt;
	private int tAgentStat1015; //상담원상태_교육
	private String tAgentStat1015Fmt;
	private int tAgentStat1016; //상담원상태_통화중
	private int tAgentStat1017; //상담원상태_로그아웃
	private int tAgentStat1018; //상담원상태_로그인
	private int nCallback; //콜백처리_건수
	private int nReservation; //상담예약처리_건수
	private int nSms; //SMS전송_건수
	
	private String leadStartDate;
	private String leadEndDate;
	
/*	
	private int sum_nInbound = 0;
	private int sum_tInbound = 0;
	private String sum_tInboundFmt;
	private int sum_nOutbound = 0; //아웃바운드_건수
	private int sum_tOutbound = 0; //아웃바운드 통화시간(초)
	private String sum_tOutboundFmt;
	private int sum_nExtension = 0; //내선통화_건수
	private int sum_tExtension = 0; //내선통화_시간(초)
	private String sum_tExtensionFmt;
	private int sum_tAgentStat1011 = 0; //상담원상태_대기
	private String sum_tAgentStat1011Fmt;
	private int sum_tAgentStat1012 = 0; //상담원상태_후처리
	private String sum_tAgentStat1012Fmt;
	private int sum_tAgentStat1013 = 0; //상담원상태_이석
	private String sum_tAgentStat1013Fmt;
	private int sum_tAgentStat1014 = 0; //상담원상태_휴식
	private String sum_tAgentStat1014Fmt;
	private int sum_tAgentStat1015 = 0; //상담원상태_교육
	private String sum_tAgentStat1015Fmt;
	private int sum_nCallback = 0; //콜백처리_건수
	private int sum_nReservation = 0; //상담예약처리_건수
	private int sum_nSms = 0; //SMS전송_건수
	
	private int avg_nInbound = 0;
	private int avg_tInbound = 0;
	private String avg_tInboundFmt;
	private int avg_nOutbound = 0; //아웃바운드_건수
	private int avg_tOutbound = 0; //아웃바운드 통화시간(초)
	private String avg_tOutboundFmt;
	private int avg_nExtension = 0; //내선통화_건수
	private int avg_tExtension = 0; //내선통화_시간(초)
	private String avg_tExtensionFmt;
	private int avg_tAgentStat1011 = 0; //상담원상태_대기
	private String avg_tAgentStat1011Fmt;
	private int avg_tAgentStat1012 = 0; //상담원상태_후처리
	private String avg_tAgentStat1012Fmt;
	private int avg_tAgentStat1013 = 0; //상담원상태_이석
	private String avg_tAgentStat1013Fmt;
	private int avg_tAgentStat1014 = 0; //상담원상태_휴식
	private String avg_tAgentStat1014Fmt;
	private int avg_tAgentStat1015 = 0; //상담원상태_교육
	private String avg_tAgentStat1015Fmt;
	private int avg_nCallback = 0; //콜백처리_건수
	private int avg_nReservation = 0; //상담예약처리_건수
	private int avg_nSms = 0; //SMS전송_건수
*/	
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
	public int getnInbound() {
		return nInbound;
	}
	public void setnInbound(int nInbound) {
		this.nInbound = nInbound;
	}
	public int gettInbound() {
		return tInbound;
	}
	public void settInbound(int tInbound) {
		this.tInbound = tInbound;
	}
	public String gettInboundFmt() {
		return tInboundFmt;
	}
	public void settInboundFmt(String tInboundFmt) {
		this.tInboundFmt = tInboundFmt;
	}
	public int getnOutbound() {
		return nOutbound;
	}
	public void setnOutbound(int nOutbound) {
		this.nOutbound = nOutbound;
	}
	public int gettOutbound() {
		return tOutbound;
	}
	public void settOutbound(int tOutbound) {
		this.tOutbound = tOutbound;
	}
	public String gettOutboundFmt() {
		return tOutboundFmt;
	}
	public void settOutboundFmt(String tOutboundFmt) {
		this.tOutboundFmt = tOutboundFmt;
	}
	public int getnExtension() {
		return nExtension;
	}
	public void setnExtension(int nExtension) {
		this.nExtension = nExtension;
	}
	public int gettExtension() {
		return tExtension;
	}
	public void settExtension(int tExtension) {
		this.tExtension = tExtension;
	}
	public String gettExtensionFmt() {
		return tExtensionFmt;
	}
	public void settExtensionFmt(String tExtensionFmt) {
		this.tExtensionFmt = tExtensionFmt;
	}
	public int gettAgentStat1011() {
		return tAgentStat1011;
	}
	public void settAgentStat1011(int tAgentStat1011) {
		this.tAgentStat1011 = tAgentStat1011;
	}
	public String gettAgentStat1011Fmt() {
		return tAgentStat1011Fmt;
	}
	public void settAgentStat1011Fmt(String tAgentStat1011Fmt) {
		this.tAgentStat1011Fmt = tAgentStat1011Fmt;
	}
	public int gettAgentStat1012() {
		return tAgentStat1012;
	}
	public void settAgentStat1012(int tAgentStat1012) {
		this.tAgentStat1012 = tAgentStat1012;
	}
	public String gettAgentStat1012Fmt() {
		return tAgentStat1012Fmt;
	}
	public void settAgentStat1012Fmt(String tAgentStat1012Fmt) {
		this.tAgentStat1012Fmt = tAgentStat1012Fmt;
	}
	public int gettAgentStat1013() {
		return tAgentStat1013;
	}
	public void settAgentStat1013(int tAgentStat1013) {
		this.tAgentStat1013 = tAgentStat1013;
	}
	public String gettAgentStat1013Fmt() {
		return tAgentStat1013Fmt;
	}
	public void settAgentStat1013Fmt(String tAgentStat1013Fmt) {
		this.tAgentStat1013Fmt = tAgentStat1013Fmt;
	}
	public int gettAgentStat1014() {
		return tAgentStat1014;
	}
	public void settAgentStat1014(int tAgentStat1014) {
		this.tAgentStat1014 = tAgentStat1014;
	}
	public String gettAgentStat1014Fmt() {
		return tAgentStat1014Fmt;
	}
	public void settAgentStat1014Fmt(String tAgentStat1014Fmt) {
		this.tAgentStat1014Fmt = tAgentStat1014Fmt;
	}
	public int gettAgentStat1015() {
		return tAgentStat1015;
	}
	public void settAgentStat1015(int tAgentStat1015) {
		this.tAgentStat1015 = tAgentStat1015;
	}
	public String gettAgentStat1015Fmt() {
		return tAgentStat1015Fmt;
	}
	public void settAgentStat1015Fmt(String tAgentStat1015Fmt) {
		this.tAgentStat1015Fmt = tAgentStat1015Fmt;
	}
	public int gettAgentStat1016() {
		return tAgentStat1016;
	}
	public void settAgentStat1016(int tAgentStat1016) {
		this.tAgentStat1016 = tAgentStat1016;
	}
	public int gettAgentStat1017() {
		return tAgentStat1017;
	}
	public void settAgentStat1017(int tAgentStat1017) {
		this.tAgentStat1017 = tAgentStat1017;
	}
	public int gettAgentStat1018() {
		return tAgentStat1018;
	}
	public void settAgentStat1018(int tAgentStat1018) {
		this.tAgentStat1018 = tAgentStat1018;
	}
	public int getnCallback() {
		return nCallback;
	}
	public void setnCallback(int nCallback) {
		this.nCallback = nCallback;
	}
	public int getnReservation() {
		return nReservation;
	}
	public void setnReservation(int nReservation) {
		this.nReservation = nReservation;
	}
	public int getnSms() {
		return nSms;
	}
	public void setnSms(int nSms) {
		this.nSms = nSms;
	}
	public String getLeadStartDate() {
		return leadStartDate;
	}
	public void setLeadStartDate(String leadStartDate) {
		this.leadStartDate = leadStartDate;
	}
	public String getLeadEndDate() {
		return leadEndDate;
	}
	public void setLeadEndDate(String leadEndDate) {
		this.leadEndDate = leadEndDate;
	}
/*	
	//합계
	public int getSum_nInbound() {
		return sum_nInbound;
	}
	public void setSum_nInbound(int sum_nInbound) {
		this.sum_nInbound = sum_nInbound;
	}
	public int getSum_tInbound() {
		return sum_tInbound;
	}
	public void setSum_tInbound(int sum_tInbound) {
		this.sum_tInbound = sum_tInbound;
	}
	public String getSum_tInboundFmt() {
		return sum_tInboundFmt;
	}
	public void setSum_tInboundFmt(String sum_tInboundFmt) {
		this.sum_tInboundFmt = sum_tInboundFmt;
	}
	public int getSum_nOutbound() {
		return sum_nOutbound;
	}
	public void setSum_nOutbound(int sum_nOutbound) {
		this.sum_nOutbound = sum_nOutbound;
	}
	public int getSum_tOutbound() {
		return sum_tOutbound;
	}
	public void setSum_tOutbound(int sum_tOutbound) {
		this.sum_tOutbound = sum_tOutbound;
	}
	public String getSum_tOutboundFmt() {
		return sum_tOutboundFmt;
	}
	public void setSum_tOutboundFmt(String sum_tOutboundFmt) {
		this.sum_tOutboundFmt = sum_tOutboundFmt;
	}
	public int getSum_nExtension() {
		return sum_nExtension;
	}
	public void setSum_nExtension(int sum_nExtension) {
		this.sum_nExtension = sum_nExtension;
	}
	public int getSum_tExtension() {
		return sum_tExtension;
	}
	public void setSum_tExtension(int sum_tExtension) {
		this.sum_tExtension = sum_tExtension;
	}
	public String getSum_tExtensionFmt() {
		return sum_tExtensionFmt;
	}
	public void setSum_tExtensionFmt(String sum_tExtensionFmt) {
		this.sum_tExtensionFmt = sum_tExtensionFmt;
	}
	public int getSum_tAgentStat1011() {
		return sum_tAgentStat1011;
	}
	public void setSum_tAgentStat1011(int sum_tAgentStat1011) {
		this.sum_tAgentStat1011 = sum_tAgentStat1011;
	}
	public String getSum_tAgentStat1011Fmt() {
		return sum_tAgentStat1011Fmt;
	}
	public void setSum_tAgentStat1011Fmt(String sum_tAgentStat1011Fmt) {
		this.sum_tAgentStat1011Fmt = sum_tAgentStat1011Fmt;
	}
	public int getSum_tAgentStat1012() {
		return sum_tAgentStat1012;
	}
	public void setSum_tAgentStat1012(int sum_tAgentStat1012) {
		this.sum_tAgentStat1012 = sum_tAgentStat1012;
	}
	public String getSum_tAgentStat1012Fmt() {
		return sum_tAgentStat1012Fmt;
	}
	public void setSum_tAgentStat1012Fmt(String sum_tAgentStat1012Fmt) {
		this.sum_tAgentStat1012Fmt = sum_tAgentStat1012Fmt;
	}
	public int getSum_tAgentStat1013() {
		return sum_tAgentStat1013;
	}
	public void setSum_tAgentStat1013(int sum_tAgentStat1013) {
		this.sum_tAgentStat1013 = sum_tAgentStat1013;
	}
	public String getSum_tAgentStat1013Fmt() {
		return sum_tAgentStat1013Fmt;
	}
	public void setSum_tAgentStat1013Fmt(String sum_tAgentStat1013Fmt) {
		this.sum_tAgentStat1013Fmt = sum_tAgentStat1013Fmt;
	}
	public int getSum_tAgentStat1014() {
		return sum_tAgentStat1014;
	}
	public void setSum_tAgentStat1014(int sum_tAgentStat1014) {
		this.sum_tAgentStat1014 = sum_tAgentStat1014;
	}
	public String getSum_tAgentStat1014Fmt() {
		return sum_tAgentStat1014Fmt;
	}
	public void setSum_tAgentStat1014Fmt(String sum_tAgentStat1014Fmt) {
		this.sum_tAgentStat1014Fmt = sum_tAgentStat1014Fmt;
	}
	public int getSum_tAgentStat1015() {
		return sum_tAgentStat1015;
	}
	public void setSum_tAgentStat1015(int sum_tAgentStat1015) {
		this.sum_tAgentStat1015 = sum_tAgentStat1015;
	}
	public String getSum_tAgentStat1015Fmt() {
		return sum_tAgentStat1015Fmt;
	}
	public void setSum_tAgentStat1015Fmt(String sum_tAgentStat1015Fmt) {
		this.sum_tAgentStat1015Fmt = sum_tAgentStat1015Fmt;
	}
	public int getSum_nCallback() {
		return sum_nCallback;
	}
	public void setSum_nCallback(int sum_nCallback) {
		this.sum_nCallback = sum_nCallback;
	}
	public int getSum_nReservation() {
		return sum_nReservation;
	}
	public void setSum_nReservation(int sum_nReservation) {
		this.sum_nReservation = sum_nReservation;
	}
	public int getSum_nSms() {
		return sum_nSms;
	}
	public void setSum_nSms(int sum_nSms) {
		this.sum_nSms = sum_nSms;
	}
	
	//평균
	public int getAvg_nInbound() {
		return avg_nInbound;
	}
	public void setAvg_nInbound(int avg_nInbound) {
		this.avg_nInbound = avg_nInbound;
	}
	public int getAvg_tInbound() {
		return avg_tInbound;
	}
	public void setAvg_tInbound(int avg_tInbound) {
		this.avg_tInbound = avg_tInbound;
	}
	public String getAvg_tInboundFmt() {
		return avg_tInboundFmt;
	}
	public void setAvg_tInboundFmt(String avg_tInboundFmt) {
		this.avg_tInboundFmt = avg_tInboundFmt;
	}
	public int getAvg_nOutbound() {
		return avg_nOutbound;
	}
	public void setAvg_nOutbound(int avg_nOutbound) {
		this.avg_nOutbound = avg_nOutbound;
	}
	public int getAvg_tOutbound() {
		return avg_tOutbound;
	}
	public void setAvg_tOutbound(int avg_tOutbound) {
		this.avg_tOutbound = avg_tOutbound;
	}
	public String getAvg_tOutboundFmt() {
		return avg_tOutboundFmt;
	}
	public void setAvg_tOutboundFmt(String avg_tOutboundFmt) {
		this.avg_tOutboundFmt = avg_tOutboundFmt;
	}
	public int getAvg_nExtension() {
		return avg_nExtension;
	}
	public void setAvg_nExtension(int avg_nExtension) {
		this.avg_nExtension = avg_nExtension;
	}
	public int getAvg_tExtension() {
		return avg_tExtension;
	}
	public void setAvg_tExtension(int avg_tExtension) {
		this.avg_tExtension = avg_tExtension;
	}
	public String getAvg_tExtensionFmt() {
		return avg_tExtensionFmt;
	}
	public void setAvg_tExtensionFmt(String avg_tExtensionFmt) {
		this.avg_tExtensionFmt = avg_tExtensionFmt;
	}
	public int getAvg_tAgentStat1011() {
		return avg_tAgentStat1011;
	}
	public void setAvg_tAgentStat1011(int avg_tAgentStat1011) {
		this.avg_tAgentStat1011 = avg_tAgentStat1011;
	}
	public String getAvg_tAgentStat1011Fmt() {
		return avg_tAgentStat1011Fmt;
	}
	public void setAvg_tAgentStat1011Fmt(String avg_tAgentStat1011Fmt) {
		this.avg_tAgentStat1011Fmt = avg_tAgentStat1011Fmt;
	}
	public int getAvg_tAgentStat1012() {
		return avg_tAgentStat1012;
	}
	public void setAvg_tAgentStat1012(int avg_tAgentStat1012) {
		this.avg_tAgentStat1012 = avg_tAgentStat1012;
	}
	public String getAvg_tAgentStat1012Fmt() {
		return avg_tAgentStat1012Fmt;
	}
	public void setAvg_tAgentStat1012Fmt(String avg_tAgentStat1012Fmt) {
		this.avg_tAgentStat1012Fmt = avg_tAgentStat1012Fmt;
	}
	public int getAvg_tAgentStat1013() {
		return avg_tAgentStat1013;
	}
	public void setAvg_tAgentStat1013(int avg_tAgentStat1013) {
		this.avg_tAgentStat1013 = avg_tAgentStat1013;
	}
	public String getAvg_tAgentStat1013Fmt() {
		return avg_tAgentStat1013Fmt;
	}
	public void setAvg_tAgentStat1013Fmt(String avg_tAgentStat1013Fmt) {
		this.avg_tAgentStat1013Fmt = avg_tAgentStat1013Fmt;
	}
	public int getAvg_tAgentStat1014() {
		return avg_tAgentStat1014;
	}
	public void setAvg_tAgentStat1014(int avg_tAgentStat1014) {
		this.avg_tAgentStat1014 = avg_tAgentStat1014;
	}
	public String getAvg_tAgentStat1014Fmt() {
		return avg_tAgentStat1014Fmt;
	}
	public void setAvg_tAgentStat1014Fmt(String avg_tAgentStat1014Fmt) {
		this.avg_tAgentStat1014Fmt = avg_tAgentStat1014Fmt;
	}
	public int getAvg_tAgentStat1015() {
		return avg_tAgentStat1015;
	}
	public void setAvg_tAgentStat1015(int avg_tAgentStat1015) {
		this.avg_tAgentStat1015 = avg_tAgentStat1015;
	}
	public String getAvg_tAgentStat1015Fmt() {
		return avg_tAgentStat1015Fmt;
	}
	public void setAvg_tAgentStat1015Fmt(String avg_tAgentStat1015Fmt) {
		this.avg_tAgentStat1015Fmt = avg_tAgentStat1015Fmt;
	}
	public int getAvg_nCallback() {
		return avg_nCallback;
	}
	public void setAvg_nCallback(int avg_nCallback) {
		this.avg_nCallback = avg_nCallback;
	}
	public int getAvg_nReservation() {
		return avg_nReservation;
	}
	public void setAvg_nReservation(int avg_nReservation) {
		this.avg_nReservation = avg_nReservation;
	}
	public int getAvg_nSms() {
		return avg_nSms;
	}
	public void setAvg_nSms(int avg_nSms) {
		this.avg_nSms = avg_nSms;
	}*/
	
}
