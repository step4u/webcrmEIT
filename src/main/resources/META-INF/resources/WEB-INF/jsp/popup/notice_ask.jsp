<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var paramNotice = {
		startDate : "",
		endDate : "",
		search : "",
		regEmpNo : ""
};
var paramNoticeDelete = {
		bbsSeq : ""	
};
var paramNoticeModify = {
		bbsSeq : ""
};
var paramDetail = {
		bbsSeq : ""
};
jui.ready([ "grid.xtable"], function(xtable) {
	tab_noticeList = xtable("#tab_noticeList", {
		resize : true,
		scrollHeight: 400,
		width : 1105,
        scrollWidth: 1100,
        buffer: "s-page",
        bufferCount: 50,
		csv:["bbsSeq","bbsSbj","regEmpNo","regDate","regHms","regHms","bbsNote","bbsNote"],
		csvNames:["유형","고객번호","고객명","연락처1","연락처2","연락처3","eMail","FAX"],
	});
	
	$("#bt_noticePopup").click(function(){
		var date = new Date();
		var month = date.getMonth() + 1;
		month = month < 10 ? '0' + month : month;
		var day = date.getDate();
		day = day < 10 ? '0' + day : day;

		$("#txt_noticeStartDate").val(setYesterday(date.getFullYear() +'-'+ month +'-'+ day));
		$("#txt_noticeEndDate").val(date.getFullYear() +'-'+ month +'-'+ day);
		
		tab_noticeList.update();
	});
	
	$("#bt_noticeSelect").click(function() {
		paramNotice.startDate = $("#txt_noticeStartDate").val().replace(/-/gi, ""); 
		paramNotice.endDate = $("#txt_noticeEndDate").val().replace(/-/gi, ""); 
		paramNotice.search = $("#select_noticeSearch option:selected").val();
		paramNotice.searchText = $("#txt_noticeSearch").val();
		paramNotice.regEmpNo = $("input[name=custNo]").val();
		
		//alert(paramNotice.startDate + " ~ " + paramNotice.endDate);
		$.ajax({
			url : "/popup/notice",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramNotice),
			success : function(result) {
				page=1;
				tab_noticeList.update(result);
				tab_noticeList.resize(); 
			}
		});
	});
	
	/*삭제 버튼*/
	$("#bt_noticeDelete").click(function() {
		var cnt = $('input:checkbox[name="notice_chk"]:checked').length;
	    if(cnt == 0){
	         alert('삭제할 게시글을 선택해주세요.');
	    }else{
			var chkLength = 0;
			var temp = "";
			chkLength = tab_noticeList.size();
			for(var i = 0; i< chkLength; i++){
				 if($("#"+i+"_notice input[name=notice_chk]:checked").is(":checked")){
					if(temp == ""){
						temp = $("#"+i+"_notice input[name=notice_chk]").val();
					}else{
						temp += ","+$("#"+i+"_notice input[name=notice_chk]").val();
					}
				}  
			}
			paramNoticeDelete.bbsSeq = temp;
			
			$.ajax({
				url : "/popup/noticeDelete",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramNoticeDelete),
				success : function(result) {
					if(result>=1){
						alert("삭제가 완료되었습니다");
						$("#bt_noticeSelect").click();
					}else {
						alert("삭제가 완료되지 않았습니다. 다시 시도해주세요.");
					}
				}
			});
			
			$.ajax({
				url : "/popup/noticeCommentDelete",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramNoticeDelete),
				success : function(result) {
					
				}
			});
	    }
	
	});
	
	/*수정 버튼*/
	$("#bt_noticeModifyPopup").click(function() {
		var cnt = $('input:checkbox[name="notice_chk"]:checked').length;
	    if(cnt == 0){
	         alert('수정할 게시글을 선택해주세요.');
	    }else if(cnt > 1){
	    	alert("수정할 게시글을 하나만 선택해주세요.");
	    }else{
	    	var sbj = ""; 
	    	var note = "";
	    	
	    	var chkLength = 0;
	    	var temp = "";
	    	chkLength = tab_noticeList.size();
	    	for(var i = 0; i< chkLength; i++){
	    		 if($("#"+i+"_notice input[name=notice_chk]:checked").is(":checked")){
	    			if(temp == ""){
	    				temp = $("#"+i+"_notice input[name=notice_chk]").val();
	    			}else{
	    				temp += ","+$("#"+i+"_notice input[name=notice_chk]").val();
	    			}
	    		}  
	    	}
	    	
	    	paramDetail.bbsSeq = temp;
	    	
	    	//수정페이지에서 파일 삭제할 때 사용할 seq
	    	$("#bbsmodifySEQ").val(temp);
	    	
	    	$.ajax({
	    		url : "/popup/noticeCommentDetails",
	    		type : "post",
	    		contentType : 'application/json; charset=utf-8',
	    		data : JSON.stringify(paramDetail),
	    		success : function(result) {
	    			for ( var i = 0; i < result.length; i++) {
	    				sbj = result[i].bbsSbj;
	    				note = result[i].bbsNote;
	    			}
	    			
	    			sbj = replaceAll(sbj, "<br>", "\r\n");
	    			sbj = replaceAll(replaceAll(sbj, "&quot;", "\""),"\`","\'");
	    			
	    			note = replaceAll(note, "<br>", "\r\n");
	    			note = replaceAll(replaceAll(note, "&quot;", "\""),"\`","\'");
	    			
	    			document.getElementById("txt_noticeModifySbj").value = sbj;
	    			document.getElementById("txt_noticeModifyNote").value = note;
	    			
	    			$("#noticeModifyfileName").val("");
	    			
	    		}
	    	});
	    	
	    	/* 파일 이름 조회 */
	    	$.ajax({
	    		url : "/popup/fileName",
	    		type : "post",
	    		contentType : 'application/json; charset=utf-8',
	    		data : JSON.stringify(paramDetail),
	    		success : function(result) {
	    			if(result.length < 1){
	    				$("input[name=bbsModifyFileDownload]").val("");
					}else if(result.length >= 1){
						$("input[name=bbsModifyFileDownload]").val(result[0].fileName);
					}
	    		}
	    	});
	    	
			win_16.show();
	    }
	
	});
	
	paging_notice = function(no) {
        page += no;
        page = (page < 1) ? 1 : page;
        tab_noticeList.page(page);
	}
});

function replaceAll(str, target, replacement) {
    return str.split(target).join(replacement);
};

function noticeComment(bbsSeq, bbsSbj, bbsNote){
	
	var sbj = ""; 
	var note = "";
	
	paramDetail.bbsSeq = bbsSeq;
	
	$.ajax({
		url : "/popup/noticeCommentDetails",
		type : "post",
		contentType : 'application/json; charset=utf-8',
		data : JSON.stringify(paramDetail),
		success : function(result) {
			for ( var i = 0; i < result.length; i++) {
				sbj = result[i].bbsSbj;
				note = result[i].bbsNote;
			}
			
			sbj = replaceAll(sbj, "<br>", "\r\n");
			sbj = replaceAll(replaceAll(sbj, "&quot;", "\""),"\`","\'");
			
			note = replaceAll(note, "<br>", "\r\n");
			note = replaceAll(replaceAll(note, "&quot;", "\""),"\`","\'");
			
			win_17.show();
			document.getElementById("txt_noticeCommentSbj").value = sbj;
			document.getElementById("txt_noticeCommentNote").value = note;
			
			/* fileName 불러오기 */
			document.getElementById("bt_roadFileName").value = bbsSeq; 
			document.getElementById("bt_roadFileName").click();
			
			/* 새글 컬럼 업데이트 */
			document.getElementById("noticeNew").value = bbsSeq;
			document.getElementById("noticeNew").click(); 
			
			/* 댓글리스트 */
			document.getElementById("bt_noticeReply").value = bbsSeq;
			document.getElementById("bt_noticeReply").click();  
			document.getElementById("txt_noticeReply").value = "";
		}
	});
	
};

$(document).ready(function() {
	$("#txt_noticeStartDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd"
	});

	$("#txt_noticeEndDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd"
	});
	
	$("#noticeSingUp").click(function() {
		$("#txt_noticeSbj").val("");
		$("#txt_noticeNote").val("");
		$("#noticefileRoot").val("");
	});
	
    $("#notice_checkall").click(function(){
        if($("#notice_checkall").prop("checked")){
            $("input[name=notice_chk]").prop("checked",true);
        }else{
            $("input[name=notice_chk]").prop("checked",false);
        }
    });
	
});
</script>
<script data-jui="#tab_noticeList" data-tpl="row" type="text/template">
	<tr id="<!= row.index !>_notice" ondblClick="noticeComment('<!= bbsSeq !>','<!= bbsSbj !>','<!= bbsNote !>');">
		<td><input type="checkbox" name="notice_chk" value="<!= bbsSeq !>"/></td>
		<td align ="center"><!= parseInt(row.index)+1 !></td>
		<td align ="left"><!= bbsSbj !></td>
		<td><!= regEmpNm !></td>
		<td><!= regDate !> <!= regHms !></td>
		<td><!= fileYN !></td>
		<td><!= commentYN !></td>
		<td><!= newYN !></td>
	</tr>
</script>
<script data-jui="#tab_noticeList" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="8" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
<div class="head">
<input type="hidden" id="noticeNew" /> 
<input type="hidden" id="bt_noticeReply" />
<input type="hidden" id="bt_roadFileName" />
<input type="hidden" id="txt_noticeNo" value="<%= session.getAttribute("empNo") %>" />
<input type="hidden" id="txt_noticeNm" value="<%= session.getAttribute("empNm") %>" />
	
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				공지사항 조회
			</td>
		</tr>
	</table>
</div>
<div class="body" id="notice">
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" style="margin-bottom: 2px;">
		<tr>
			<td class="td01">작성일자</td>
			<td class="td02">
				<input type="text" class="input mini" id="txt_noticeStartDate" style="width: 82px" />
				<input type="text" class="input mini" id="txt_noticeEndDate" style="width: 82px" />
			</td>
			<td class="td01">검색입력</td>
			<td width="250"><span class="td02">
				<select id="select_noticeSearch">
					<option value="0"></optin>
					<option value="1">제목</optin>
					<option value="2">내용</optin>
					<option value="3">작성자</optin>
				</select>
				<input type="text" class="input mini" id="txt_noticeSearch" style="width: 150px" />
				<input type="hidden" id="selectSearchText"/>
			</span></td>
			<td width="25%"></td>
			<td width="230" align="right" class="td01">
				<a class="btn small focus" id="bt_noticeSelect">조 회</a> 
				<a class="btn small focus" id="noticeSingUp" onclick="win_15.show()">등 록</a> 
				<a class="btn small focus" id="bt_noticeModifyPopup">수 정</a> 
				<a class="btn small focus" id="bt_noticeDelete">삭 제</a>
			</td>
		</tr>
	</table>
	<table class="table classic hover" id="tab_noticeList" width="100%">
		<thead>
			<tr>
				<th style="width:61px;"><input type="checkbox" id="notice_checkall" /></th>
				<th style="width:63px;">번호</th>
				<th style="width:322px;">제목</th>
				<th style="width:120px;">작성자</th>
				<th style="width:180px;">작성일</th>
				<th style="width:78px;">첨부파일</th>
				<th style="width:80px;">댓글</th>
				<th style="width:auto;">새글</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table> 
	<div class="row" align="right" style="text-align: right; margin-top: 3px;">
	    <div class="group">
	        <button onclick="paging_notice(-1);" class="btn mini">Prev</button>
	        <button onclick="paging_notice(1);" class="btn mini">Next</button>
	    </div>
	</div>
</div>
<div id="win_15" class="msgboxpop danger" style="display:none">
		<%@ include file="./notice_reg_regist.jsp"%>
</div>
<div id="win_16" class="msgboxpop danger" style="display:none">
		<%@ include file="./notice_reg_modify.jsp"%>
</div>
<div id="win_17" class="msgboxpop danger" style="display:none">
		<%@ include file="./notice_comment_mgr.jsp"%>
</div>