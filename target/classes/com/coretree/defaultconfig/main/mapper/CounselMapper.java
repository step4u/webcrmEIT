package com.coretree.defaultconfig.main.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.coretree.defaultconfig.main.model.Counsel;

@Mapper
public interface CounselMapper {
	public List<Counsel> counselList(Counsel counsel);
	public long insertCounsel(Counsel counsel);
	public long updateCounsel(Counsel counsel);
	public long updateCustomerCounDate(Counsel counsel);
}
