<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var paramNoticeFileName = {
		bbsSeq : ""
};
var paramNoticeUpdate = {
		bbsSeq : ""
};
var	paramNoticeNew = {
		bbsSeq : "",
		readEmpNo : ""
};
var paramReply = {
		bbsSeq : ""
};
var paramReplyInsert = {
		bbsSeq : "",
		regDate : "",
		regHms : "",
		regEmpNo : "",
		regEmpNm : "",
		commentNote : ""	
};

jui.ready([ "grid.xtable","ui.paging"], function(xtable, paging) {

	var data;
	var data_size;
	var page = 1;
	var result_data;

	/* 공지사항 새글 컬럼 업데이트*/
	$("#noticeNew").click(function() {
		paramNoticeNew.bbsSeq = $("#noticeNew").val();
		paramNoticeNew.readEmpNo = $("input[name=custNo]").val();
		
		$.ajax({
			url : "/popup/noticeNewUpdate",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramNoticeNew),
			success : function(result) {
/*				if(result == 1){
					alert("새글을 읽었습니다.");
				}else if(result == 0){
					alert("새글 업데이트를 실패하였습니다");
				}	*/	
				$("#bt_noticeSelect").click();
				
				setTimeout(function (){
					var id = $("#noticeNewYN").val();
					$(id).addClass("selected");
					$(id).find('input:checkbox[name="notice_chk"]').prop('checked', true);
				},500);
				
			}
		
		});
	});
	
	/*
	 * 공지사항 댓글 리스트
	 * notice_comment_mgr.jsp
	 * Button Name : 조회
	 */	
	tab_noticeReply = xtable("#tab_noticeReply", {
		resize : true,
		scrollHeight: 103,
		width : 1150,
        scrollWidth: 1105,
        buffer: "s-page",
        bufferCount: 50,
		event: {
            select: function(row) {
            	var row = row.index;
            	fn_comment(row);
            }
		 },
		tpl: {
	            row: $("#tpl_row_bbsComment").html(),
	            none: $("#tpl_none_bbsComment").html()
	        }
	});
	
	paging_reply = paging("#paging_reply", {
	      pageCount: 50,
	      event: {
	          page: function(pNo) {
	        	  tab_noticeReply.page(pNo);
	          }
	       },
	       tpl: {
	           pages: $("#tpl_pages_bbsComment").html()
	       }
	});
	
	$("#bt_noticeReply").click(function() {
		paramReply.bbsSeq = $("#bt_noticeReply").val();
		
		$.ajax({
			url : "/popup/selectCommentReplyList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramReply),
			success : function(result) {
				page=1;
				tab_noticeReply.update(result);
				tab_noticeReply.resize(); 
				
				paging_reply.reload(tab_noticeReply.count());
			}
		});

	});
	
	/*파일 이름 조회*/
	$("#bt_roadFileName").click(function() {
		paramNoticeFileName.bbsSeq = $("#bt_roadFileName").val();
		
		$.ajax({
			url : "/popup/fileName",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramNoticeFileName),
			success : function(result) {
				if(result.length < 1){
					$("#selectNoticeFile").val("");
				}else if(result.length >= 1){
					$("#selectNoticeFile").val(result[0].fileName);
				}
			}
		});

	});

	/* 공지사항 댓글 저장 버튼*/
	$("#bt_replyInsert").click(function() { 
		var txt_noticeReply = document.getElementById('txt_noticeReply');
		var blank_pattern = /^\s+|\s+$/g;
		
		if (txt_noticeReply.value == '' || txt_noticeReply.value == null || txt_noticeReply.value.replace( blank_pattern, '' ) == ""){
			msgboxActive('공지사항 의견달기', '위 게시글에 대한 \"댓글\"을 입력해주세요.');
		}else {
			var date = new Date();
			   
		    var year  = date.getFullYear();
		    var month = date.getMonth() + 1; 
		    var day   = date.getDate();
	
		    var hours = date.getHours();
		    var minute = date.getMinutes();
		    var second = date.getSeconds();
		        
		    if (("" + month).length == 1) { month = "0" + month; }
		    if (("" + day).length   == 1) { day   = "0" + day;   }
		    
		    if (("" + hours).length == 1) { hours = "0" + hours; }
		    if (("" + minute).length   == 1) { minute   = "0" + minute;   }
		    if (("" + second).length   == 1) { second   = "0" + second;   }
		    
		    var today = year + '' + month + '' + day;
		    var time = hours +""+ minute +""+ second;
		    
		    var replayCommentNote = $("#txt_noticeReply").val().replace(/\n/g, "<br>");
		    replayCommentNote = replaceAll(replaceAll(replayCommentNote, "\"", "&quot;"), "\'", "\`");
		    
		    paramReplyInsert.bbsSeq = $("#bt_noticeReply").val();
		    paramReplyInsert.regDate = today; 
		    paramReplyInsert.regHms	= time;
		    paramReplyInsert.regEmpNo = $("#txt_noticeNo").val();
		    paramReplyInsert.regEmpNm = $("#txt_noticeNm").val();
		    paramReplyInsert.commentNote = replayCommentNote;
		    
			$.ajax({
				url : "/popup/noticeReplyInsert",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramReplyInsert),
				success : function(result) {
					if(result == 1){
						msgboxActive('공지사항 의견달기', '게시글에 대한 댓글 \"저장\"이 완료되었습니다.');
						$("#txt_noticeReply").val("");
						$("#bt_noticeReply").click();
					}else if(result == 0){
						msgboxActive('공지사항 의견달기', '게시글에 대한 댓글 \"저장\"이 완료되지 않았습니다. 다시 시도해주세요.');
					}	
				}
			
			});
		}
	});
});
</script>
<script id="tpl_row_bbsComment" type="text/template">
	<tr class="trNoticeComment">
		<td align="center"><!= regDate !></td>
		<td align="center"><!= regEmpNm !></td>
		<td align="center" name="comment"><!= commentNote !></td>
	</tr>
</script>
<script id="tpl_pages_bbsComment" type="text/template">
    <! for(var i = 0; i < pages.length; i++) { !>
    <a href="#" class="page" onclick="fn_page();"><!= pages[i] !></a>
    <! } !>
</script>
<script id="tpl_none_bbsComment" type="text/template">
    <tr height ="50">
        <td colspan="3" class="none" align="center">데이터가 존재하지 않습니다.</td>
    </tr>
</script>
<script>
$(document).ready(function(){
	 $("#bt_noticeFiledownload").click(function() {
		
		//파일명
		var fName = $("#selectNoticeFile").val();
		var fileName = fName.substring(0, fName.lastIndexOf("."));
		//확장자 구하기
		var fileExtension = fName.slice(fName.lastIndexOf(".")+1).toLowerCase();
		$.ajax({
			url : "/popup/noticeFileDownload/" + fileName + "/" + fileExtension,
			type : "post",
			contentType: "application/octet-stream; charset=utf-8",
			data : fileName,
			success : function() {
				window.location.href = "/popup/noticeFileDownload/" + fileName + "/" + fileExtension;
			}
		});
	}); 
});

/* 초기화 버튼 EVENT */
function replyInitialization(){
	document.getElementById("txt_noticeReply").value = ""; 
};

/* 댓글 선택시 의견내용 textarea에 댓글내용 보여지는 메소드 */
function fn_comment(row){
	var comment = $(".trNoticeComment").find("[name = comment]").eq(row).html();
	var str = replaceAll(comment, "<br>", "\r\n");
	str = replaceAll(replaceAll(str, "&quot;", "\""),"\`","\'");
	
	document.getElementById("txt_noticeReply").value = str;
};

</script>
<div class="head">
	<a href="#" class="close" id="noticeCommentClose"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				공지사항 의견달기
			</td>
			<td></td>
		</tr>
	</table>
</div>
<div class="body" >
	<table border="0" cellpadding="0" cellspacing="0" class="table01" id="noticeContents" >
                <tr>
                  <td width="65" border="0" cellpadding="0" cellspacing="0">
  <tr>
                      <td width="65" class="td01">제목&nbsp;&nbsp;</td>
          <td height="25" colspan="2" align="left"><input type="text" class="input mini" style="width:895px" id="txt_noticeCommentSbj"/></td>
              </tr>
                    <tr>
                      <td width="65" class="td01">내용&nbsp;&nbsp;</td>
                      <td height="100" colspan="2" align="left">
	                      <textarea name="textarea" class="input" style="height: 160px;width:895px" id="txt_noticeCommentNote"></textarea>
	                  </td>
              </tr>
                    <tr>
                      <td width="65" class="td01">다운로드&nbsp;&nbsp;</td>
                      <td height="0" align="left" ><input type="text" class="input mini" style="width:895px" id="selectNoticeFile" value="" /></td>
                      <td width="65" align="right" class="td01"><a class="btn small focus" id="bt_noticeFiledownload">다 운</a></td>
              </tr>
            </table>
        <table class="table01" border="0" cellpadding="0" cellspacing="0" style="margin-top:1px; padding-bottom:0px !important">
                <tr>
                  <td width="65" class="td01">의견내용&nbsp;&nbsp;</td>
                  <td height="100" align="left">
                  	<textarea name="textarea2" class="input" id="txt_noticeReply" style="height: 100px;width:895px" ></textarea>
                  </td>
                  <td align="right" valign="middle">
	                  <table width="68" border="0" cellpadding="0" cellspacing="0">
	                    <tr>
	                      <td height="28" align="right">
	                      	<a class="btn small focus" onclick="viewRoleChk('View_noticeComment_User.do','noticeComment','공지사항 댓글저장');">저&nbsp;&nbsp;장</a>
	                      	<input type="hidden" id="bt_replyInsert" /> <!-- 권한으로 인해 댓글저장버튼 이벤트 hidden -->
	                      </td>
	                    </tr>
	                    <tr>
	                      <td height="28" align="right"><a class="btn small focus" onclick="javascript:replyInitialization();">초기화</a></td>
	                    </tr>
	                  </table>
                  </td>
              </tr>
          </table>
           <table class="table classic hover table01" id="tab_noticeReply" width="100%" style="margin-top:2px; padding:0px !important">
              <thead>
                <tr>
                  <th class="th01" style="width:150px">작성일시</th>
                  <th style="width:150px">작성자</th>
                  <th style="width:auto">내용</th>
                </tr>
              </thead>
              <tbody>
              </tbody>
            </table>
          
		<div id="paging_reply" class="paging" style="margin-top: 4px; margin-right: 4px; width:1092px;">
		    <a href="#" class="prev" style="left:0" onclick="fn_page();">이전</a>
		    <div class="list"></div>
		    <a href="#" class="next" onclick="fn_page();">다음</a>
		</div>
</div>