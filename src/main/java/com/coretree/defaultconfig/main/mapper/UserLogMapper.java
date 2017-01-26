package com.coretree.defaultconfig.main.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.coretree.defaultconfig.main.model.UserLog;
import com.coretree.models.Organization;

@Mapper
public interface UserLogMapper {
	public List<UserLog> selectAllUserLogs();
	public void addUserLog(UserLog userlog);
	public void addLog(Organization organization);
}
