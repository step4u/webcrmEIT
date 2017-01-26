package com.coretree.defaultconfig.setting.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.coretree.defaultconfig.setting.model.Torganization;

@Mapper
public interface TorganizationMapper {

	public List<Torganization> selectCouncellerList(Torganization Torganization);
	public long deleteCounceller(Torganization Torganization);
	public long updateCounceller(Torganization Torganization);
	public long insertCounceller(Torganization Torganization);
	public long updateDataCounceller(Torganization Torganization);  
	public long councellerExtensionChk(Torganization Torganization);
	public long councellerNameChk(Torganization Torganization);
	
	
}
