var param = {
};

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


var paramCode = {
		lcd : "",
};

jui.ready([ "grid.table", "ui.paging"], function(table, paging) {

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
			}
		
		});
	});
	
	/*
	 * 공지사항 댓글 리스트
	 * notice_comment_mgr.jsp
	 * Button Name : 조회
	 */	
	tab_noticeReply = table("#tab_noticeReply", {
		 scroll : true,
		 scrollHeight: 200,
		 resize : true,
		 event: {
            select: function(row) {
            	var row = row.index;
            	fn_comment(row);
            }
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
				result_data = result;
				data_size = result.length;				
				var jsonData = JSON.stringify(result);
				data = JSON.parse(jsonData);

				tab_noticeReply.reset();
				paging_reply.reload(data_size);
				
				var start = (page-1)*10;
				var end = page*10;
				for (var i = start; i < end; i++){
					tab_noticeReply.append(result[i]);
				}
			}
		});

	});
	
	paging_reply = paging("#paging_reply", {
        count: 10,
        event: {
            page: function(pNo) {
                page = pNo;
                
                tab_noticeReply.reset();
				var start = (page-1)*10;
				var end = page*10;
				for (var i = start; i < end; i++){
					tab_noticeReply.append(result_data[i]);
				}
            }
        }
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
	    
	    var today = year + month + day;
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
					alert("저장이 완료되었습니다");
					$("#txt_noticeReply").val("");
					$("#bt_noticeReply").click();
				}else if(result == 0){
					alert("저장이 되지 않았습니다");
				}	
			}
		
		});
	});
	
	
	
});


/*
 * JUI를 이용한 SELECT BOX
 * 
 */

jui.ready([ "ui.combo" ], function(combo) {
	combo_councellerExtension = combo("#combo_councellerExtension", {
		index: 0,
        event: {
            change: function(data) {
               /*alert("text(" + data.text + "), value(" + data.value + ")");*/
                document.getElementById("txt_councellerExtension").value = data.text;
            }
        }
    });
	
	combo_authCd = combo("#combo_authCd", {
        index: 0,
        event: {
            change: function(data) {
                /*alert("text(" + data.text + "), value(" + data.value + ")");*/
                document.getElementById("txt_authCd").value = data.value;
            }
        }
    });

	combo_record_callTyp = combo("#combo_record_callTyp", {
        index: 0,
        event: {
            change: function(data) {
                /*alert("text(" + data.text + "), value(" + data.value + ")");*/
                document.getElementById("txt_callType").value = data.value; 
            }
        }
    });
	
	combo_recordExtention = combo("#combo_recordExtention", {
		index: 0,
        event: {
            change: function(data) {
                /*alert("text(" + data.text + "), value(" + data.value + ")");*/
                document.getElementById("txt_recordExtension").value = data.value;
            }
        }
	});
	
	combo_councellerPresent = combo("#combo_councellerPresent", {
		index: 0,
        event: {
            change: function(data) {
               /* alert("text(" + data.text + "), value(" + data.value + ")");*/
                document.getElementById("txt_empNm").value = data.text;
               
            }
        }
	});
	
	combo_noticeAsk = combo("#combo_noticeAsk", {
		index: 0,
        event: {
            change: function(data) {
               /* alert("text(" + data.text + "), value(" + data.value + ")");*/
                document.getElementById("selectSearchText").value = data.value;
            }
        }
	});
});
