package com.coretree.defaultconfig.main.model;

public class OrgStatatistics {
	private int total = 0;
	private int logined = 0;
	private int logouted = 0;
	private int ready = 0;
	private int after = 0;
	private int busy = 0;
	private int left = 0;
	private int rest = 0;
	private int edu = 0;
	
	public int getTotal() { return total; }
	public void setTotal(int total) { this.total = total; }
	
	public int getLogined() { return logined; }
	public void setLogined(int logined) { this.logined = logined; }
	
	public int getLogouted() { return logouted; }
	public void setLogouted(int logouted) { this.logouted = logouted; }
	
	public int getReady() { return ready; }
	public void setReady(int ready) { this.ready = ready; }
	
	public int getAfter() { return after; }
	public void setAfter(int after) { this.after = after; }
	
	public int getBusy() { return busy; }
	public void setBusy(int busy) { this.busy = busy; }
	
	public int getLeft() { return left; }
	public void setLeft(int left) { this.left = left; }
	
	public int getRest() { return rest; }
	public void setRest(int rest) { this.rest = rest; }
	
	public int getEdu() { return edu; }
	public void setEdu(int edu) { this.edu = edu; }
	
	@Override
	public String toString() {
		return "OrgStatatistics [total=" + total + ", logined=" + logined + ", logouted=" + logouted
				+ ", ready=" + ready + ", after=" + after + ", busy=" + busy
				+ ", left=" + left + ", rest=" + rest + ", edu=" + edu + "]";
	}
}
