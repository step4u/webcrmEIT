package com.coretree.defaultconfig.statis.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.coretree.defaultconfig.statis.model.RecordMgt;

@Mapper
public interface RecordMgtMapper {

	public List<RecordMgt> selectRecordList(RecordMgt recordMgt);
	public RecordMgt getRecFn(int seq);
}
