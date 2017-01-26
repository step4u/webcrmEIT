package com.coretree.defaultconfig.main.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.coretree.defaultconfig.main.model.Organization;

@Mapper
public interface OrganizationMapper {
	public Organization checkLogin(Organization user);
	public List<Organization> selectLoginUser();
	public List<com.coretree.models.Organization> getUsers();
	public void updatePwd(Organization organization);
	public void updateLoginDate(Organization organization);
	public List<Organization> empList();
	public List<Organization> usersState();
	public List<Organization> usersState2();
	//public Collection<GrantedAuthority> getAuthorities(String username);
    public Organization readUser(String username);
    public List<String> readAuthority(String username);
    public long updatePwd_late(Organization organization);
}
