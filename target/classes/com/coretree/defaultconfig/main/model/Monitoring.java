package com.coretree.defaultconfig.main.model;

public class Monitoring {
	private long totIbCnt;					//총인입
	private long totAgtConnCnt;			//상담원연결
	private long totAbanCnt;				//상담원포기
	private long totAgtIbCnt;				//상담원전체인바운드건수
	private long totAgtObCnt;			//상담원전체아웃바운드건수
	private long agtIbCnt;					//로그인상담원 인ㅇ바운드
	private long agtObCnt;				//로그인상담원 아웃바운드
	private long agtCbCounCnt;				//당일 콜백 처리건수(상담원) 
	private long totCbCounCnt;				// 당일 콜백 처리건수(전체)
	private long totCbResCnt;				//당일 콜백 등록건수(전체)
	private long agtRevCounCnt;				//당일 상담예약 처리건수(상담원)
	private long totRevCounCnt;				// 당일 상담예약 처리건수(전체)
	private long totRevResCnt;				//당일 상담예약 등록건수(전체)
	private long agtRevResCnt;				//당일 상담예약 등록건수(상담원)
	private long totBbsCnt;				//공지사항
	
	public long getTotIbCnt() {
		return totIbCnt;
	}
	public void setTotIbCnt(long totIbCnt) {
		this.totIbCnt = totIbCnt;
	}
	public long getTotAgtConnCnt() {
		return totAgtConnCnt;
	}
	public void setTotAgtConnCnt(long totAgtConnCnt) {
		this.totAgtConnCnt = totAgtConnCnt;
	}
	public long getTotAbanCnt() {
		return totAbanCnt;
	}
	public void setTotAbanCnt(long totAbanCnt) {
		this.totAbanCnt = totAbanCnt;
	}
	public long getTotAgtIbCnt() {
		return totAgtIbCnt;
	}
	public void setTotAgtIbCnt(long totAgtIbCnt) {
		this.totAgtIbCnt = totAgtIbCnt;
	}
	public long getTotAgtObCnt() {
		return totAgtObCnt;
	}
	public void setTotAgtObCnt(long totAgtObCnt) {
		this.totAgtObCnt = totAgtObCnt;
	}
	public long getAgtIbCnt() {
		return agtIbCnt;
	}
	public void setAgtIbCnt(long agtIbCnt) {
		this.agtIbCnt = agtIbCnt;
	}
	public long getAgtObCnt() {
		return agtObCnt;
	}
	public void setAgtObCnt(long agtObCnt) {
		this.agtObCnt = agtObCnt;
	}
	public long getAgtCbCounCnt() {
		return agtCbCounCnt;
	}
	public void setAgtCbCounCnt(long agtCbCounCnt) {
		this.agtCbCounCnt = agtCbCounCnt;
	}
	public long getTotCbCounCnt() {
		return totCbCounCnt;
	}
	public void setTotCbCounCnt(long totCbCounCnt) {
		this.totCbCounCnt = totCbCounCnt;
	}
	public long getTotCbResCnt() {
		return totCbResCnt;
	}
	public void setTotCbResCnt(long totCbResCnt) {
		this.totCbResCnt = totCbResCnt;
	}
	public long getAgtRevCounCnt() {
		return agtRevCounCnt;
	}
	public void setAgtRevCounCnt(long agtRevCounCnt) {
		this.agtRevCounCnt = agtRevCounCnt;
	}
	public long getTotRevCounCnt() {
		return totRevCounCnt;
	}
	public void setTotRevCounCnt(long totRevCounCnt) {
		this.totRevCounCnt = totRevCounCnt;
	}
	public long getTotRevResCnt() {
		return totRevResCnt;
	}
	public void setTotRevResCnt(long totRevResCnt) {
		this.totRevResCnt = totRevResCnt;
	}
	public long getAgtRevResCnt() {
		return agtRevResCnt;
	}
	public void setAgtRevResCnt(long agtRevResCnt) {
		this.agtRevResCnt = agtRevResCnt;
	}
	public long getTotBbsCnt() {
		return totBbsCnt;
	}
	public void setTotBbsCnt(long totBbsCnt) {
		this.totBbsCnt = totBbsCnt;
	}
	@Override
	public String toString() {
		return "Monitoring [totIbCnt=" + totIbCnt + ", totAgtConnCnt="
				+ totAgtConnCnt + ", totAbanCnt=" + totAbanCnt
				+ ", totAgtIbCnt=" + totAgtIbCnt + ", totAgtObCnt="
				+ totAgtObCnt + ", agtIbCnt=" + agtIbCnt + ", agtObCnt="
				+ agtObCnt + ", agtCbCounCnt=" + agtCbCounCnt
				+ ", totCbCounCnt=" + totCbCounCnt + ", totCbResCnt="
				+ totCbResCnt + ", agtRevCounCnt=" + agtRevCounCnt
				+ ", totRevCounCnt=" + totRevCounCnt + ", totRevResCnt="
				+ totRevResCnt + ", agtRevResCnt=" + agtRevResCnt
				+ ", totBbsCnt=" + totBbsCnt + "]";
	}
}