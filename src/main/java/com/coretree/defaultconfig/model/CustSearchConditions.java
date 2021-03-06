package com.coretree.defaultconfig.model;

public class CustSearchConditions {
	private long idx;
	private String sdate;
	private String edate;
	private String group0;
	private String group1;
	private String txt;
	private int curpage;
	private int rowsperpage;
	private String username;
	
	public long getIdx() { return this.idx; }
	public void setIdx(long idx) { this.idx = idx; }
	
	public String getSdate() { return this.sdate; }
	public void setSdate(String sdate) {
		if (sdate.isEmpty())
			this.sdate = null;
		else
			this.sdate = sdate;
	}
	
	public String getEdate() { return this.edate; }
	public void setEdate(String edate) {
		if (edate.isEmpty())
			this.edate = null;
		else
			this.edate = edate;
	}
	
	public String getGroup0() { return this.group0; }
	public void setGroup0(String group) { this.group0 = group; }
	
	public String getGroup1() { return this.group1; }
	public void setGroup1(String group) { this.group1 = group; }
	
	public String getTxt() { return this.txt; }
	public void setTxt(String txt) {
		if (txt.isEmpty())
			this.txt = null;
		else
			this.txt = "%" + txt + "%";
	}
	
	public int getCurpage() { return this.curpage; }
	public void setCurpage(int curpage) { this.curpage = curpage; }
	
	public int getRowsperpage() { return this.rowsperpage; }
	public void setRowsperpage(int rowsperpage) { this.rowsperpage = rowsperpage; }
	
	public String getUsername() { return this.username; }
	public void setUsername(String username) { this.username = username; }
}
