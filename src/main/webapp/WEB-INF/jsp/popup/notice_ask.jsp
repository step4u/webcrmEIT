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

jui.ready([ "grid.xtable"], function(xtable) {
	tab_noticeList = xtable("#tab_noticeList", {
		resize : true,
		scrollHeight: 400,
        buffer: "s-page",
        bufferCount: 50,
		csv:["bbsSeq","bbsSbj","regEmpNo","regDate","regHms","regHms","bbsNote","bbsNote"],
		csvNames:["유형","고객번호","고객명","연락처1","연락처2","연락처3","eMail","FAX"],
	});
	
	$("#bt_noticeSelect").click(function() {
		paramNotice.startDate = $("#txt_noticeStartDate").val().replace(/-/gi, ""); 
		paramNotice.endDate = $("#txt_noticeEndDate").val().replace(/-/gi, ""); 
		paramNotice.search = $("#select_noticeSearch option:selected").val();
		paramNotice.searchText = $("#txt_noticeSearch").val();
		paramNotice.regEmpNo = $("input[name=custNo]").val();
		
		$.ajax({
			url : "/popup/notice",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramNotice),
			success : function(result) {
				if(result != ""){
					page=1;
					tab_noticeList.update(result);
					tab_noticeList.resize(); 
				}else{
					tab_noticeList.resize(); 
				}
			}
		});
	});
	
	/*삭제 버튼*/
	$("#bt_noticeDelete").click(function() {
		var chkLength = 0;
		var temp = "";
		chkLength = tab_noticeList.size();
		for(var i = 0; i< chkLength; i++){
			 if($("input[name=notice_chk]:checked").is(":checked")){
				if(temp == ""){
					temp = $("#"+i+" input[name=notice_chk]").val();
				}else{
					temp += ","+$("#"+i+" input[name=notice_chk]").val();
				}
			}  
		}
		
		paramNoticeDelete.bbsSeq = $("#deleteNum").val();
		
		$.ajax({
			url : "/popup/noticeDelete",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramNoticeDelete),
			success : function(result) {
				if(result == 1){
					alert("삭제가 완료되었습니다");
				}else if(result == 0){
					alert("삭제가 되지 않았습니다.");
				}
				$("#bt_noticeSelect").click();
			}
		});
	
	});
	
	paging_notice = function(no) {
        page += no;
        page = (page < 1) ? 1 : page;
        tab_noticeList.page(page);
	}
});
</script>
<script data-jui="#tab_noticeList" data-tpl="row" type="text/template">
	<tr id="<!= row.index !>" onclick = "javascript:deleteNotice('<!= bbsSeq !>','<!= bbsSbj !>','<!= bbsNote !>');" ondblClick="noticeComment('<!= bbsSeq !>','<!= bbsSbj !>','<!= bbsNote !>');">
		<td><input type="checkbox" name="notice_chk" value="<!= bbsSeq !>"/></td>
		<td align ="center"><!= row.index !></td>
		<td align ="center"><!= bbsSbj !></td>
		<td><!= regEmpNm !></td>
		<td><!= regDate !></td>
		<td><!= regHms !></td>
		<td><!= fileYN !></td>
		<td><!= commentYN !></td>
		<td><!= newYN !></td>
	</tr>
</script>
<script data-jui="#tab_noticeList" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="9" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
<script>
function deleteNotice(bbsSeq, bbsSbj, bbsNote){
	 document.getElementById("deleteNum").value = bbsSeq;
	 document.getElementById("txt_noticeModifySbj").value = bbsSbj;
	 document.getElementById("txt_noticeModifyNote").value = bbsNote; 
}
function noticeComment(bbsSeq, bbsSbj, bbsNote){
	win_17.show();
	document.getElementById("txt_noticeCommentSbj").value = bbsSbj;
	document.getElementById("txt_noticeCommentNote").value = bbsNote;
	
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
$(document).ready(function() {
	var date = new Date();
	var month = date.getMonth() + 1;
	month = month < 10 ? '0' + month : month;
	var day = date.getDate();
	day = day < 10 ? '0' + day : day;
	
	var month2 = date.getMonth() + 1;
	month2 = month2 < 10 ? '0' + month2 : month2;
	var day2 = date.getDate() -2 ;
	day2 = day2 < 10 ? '0' + day2 : day2;
	
	$("#txt_noticeStartDate").val(date.getFullYear() +'-'+ month2 +'-'+ day2);
	$("#txt_noticeEndDate").val(date.getFullYear() +'-'+ month +'-'+ day);
	
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
	
});
</script>
<div class="head">
<input type="hidden" id="noticeNew" /> 
<input type="hidden" id="bt_noticeReply" />
<input type="hidden" id="bt_roadFileName" />
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
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
					<option value="1">제목</optin>
					<option value="2">내용</optin>
					<option value="3">작성자</optin>
				</select>
				<input type="text" class="input mini" id="txt_noticeSearch" style="width: 150px" />
					<!-- <div id="combo_noticeAsk" class="combo">
						<a class="btn small" style="width: 60px;">전체</a> 
						<a class="btn small toggle"><i class="icon-arrow2"></i></a>
						<ul>
							<li value="1">제목</li>
							<li value="2">내용</li>
							<li value="3">작성자</li>
						</ul>
					</div>  -->
					<input type="hidden" id="selectSearchText"/>
			</span></td>
			<td width="25%"></td>
			<td width="230" align="right" class="td01">
				<a class="btn small focus" id="bt_noticeSelect">조 회</a> 
				<a class="btn small focus" onclick="win_15.show()">등 록</a> 
				<a class="btn small focus" onclick="win_16.show()">수 정</a> 
				<a class="btn small focus" id="bt_noticeDelete">삭 제</a>
				<input type="hidden" id="deleteNum" />
			</td>
		</tr>
	</table>
	<table class="table classic hover" id="tab_noticeList" width="100%">
		<thead>
			<tr>
				<th></th>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>작성시간</th>
				<th>첨부파일</th>
				<th>댓글</th>
				<th>새글</th>
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