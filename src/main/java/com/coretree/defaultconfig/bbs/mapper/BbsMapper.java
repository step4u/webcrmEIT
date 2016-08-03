package com.coretree.defaultconfig.bbs.mapper;

import java.util.List;

import org.springframework.boot.mybatis.autoconfigure.Mapper;

import com.coretree.defaultconfig.bbs.model.BbsComment;
import com.coretree.defaultconfig.bbs.model.BbsMgt;

@Mapper
public interface BbsMapper {

	public List<BbsMgt> selectNoticeList(BbsMgt bbsmgt);
	public long deleteNotice(BbsMgt bbsmgt);
	public long insertNotice(BbsMgt bbsmgt); 
	public long updateNotice(BbsMgt bbsmgt); 
	public long insertNoticeFile(BbsMgt bbsmgt);
	public long selectNoticeModify(BbsMgt bbsmgt); 
	public List<BbsMgt> selectFileName(BbsMgt bbsmgt);	
	
	public List<BbsComment> selectCommentList(BbsComment bbsComment);
	public long insertReply(BbsComment bbsComment);
	
}
