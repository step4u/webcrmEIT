<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var noticeModifyUpdate = {
	bbsSeq : "",
	bbsSbj : "",
	regEmpNm : "",
	regEmpNm : "",
	bbsNote : ""
};
$(document).ready(function() {
//jui.ready([ "ui.window" ], function(win) {
	
	$("#bt_noticeModify").click(function() {
		noticeModifyUpdate.bbsSeq  = $("#deleteNum").val(); 
		noticeModifyUpdate.bbsSbj = $("#txt_noticeModifySbj").val(); 
		noticeModifyUpdate.regEmpNm = $("#bbsModifyEmpNo").val();
		noticeModifyUpdate.regEmpNm = $("#bbsModifyEmpNm").val();
		noticeModifyUpdate.bbsNote = $("#txt_noticeModifyNote").val();
		
		$.ajax({
			url : "/popup/noticeModify",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(noticeModifyUpdate),
			success : function(result) {
				if(result == 1){
					alert("수정이 완료되었습니다."); 
				}else{
					alert("수정 실패하였습니다.");
				}
				 //$("#win_16").css("display","none");
				$("#bt_noticeSelect").click();
			}
		});
	});
});
</script>
<div class="head">
<input type="hidden" id="bbsModifyEmpNo" value ="<%=session.getAttribute("empNo")%>"/> 
<input type="hidden" id="bbsModifyEmpNm" value ="<%=session.getAttribute("empNm")%>" />
										
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				공지사항 등록 / 수정
			</td>
		</tr>
	</table>
</div>
<div class="body">
	<table style="width: 100%" border="0" cellpadding="0" cellspacing="0" class="table01">
		<tr>
		<td>
			<table style="width: 100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="60" class="td01">제목&nbsp;&nbsp;</td>
					<td height="26" align="left">
						<input type="text" class="input mini" id="txt_noticeModifySbj" style="width: 830px"/>
					</td>
					<td width="130" align="right" class="td01">
						<a class="btn small focus" id="bt_noticeModify">저장</a> 
						<a class="btn small focus">취소</a>
					</td>
				</tr>
				<tr>
					<td width="60" class="td01">내용&nbsp;&nbsp;</td>
					<td height="100" colspan="2" align="left">
						<textarea name="textarea" class="input" id="txt_noticeModifyNote" style="height: 100px; width: 960px" ></textarea>
					</td>
				</tr>
				<tr>
					<td width="60" class="td01">첨부파일&nbsp;&nbsp;</td>
					<td height="25" colspan="2" align="left">
						<input type="file" id="fileNotice" style="display : none"/>
						<a class="btn small focus" onclick="fn_noticeFileSelect()">파일선택</a> 
						<input type="text" class="input mini" id="noticeModifyfileRoot"  style="width: 890px"/>
						<input type="hidden" id="txt_noticeNo" value="<%= session.getAttribute("empNo") %>" />
						<input type="hidden" id="txt_noticeNm"" value="<%= session.getAttribute("empNm") %>" />
					</td>
				</tr>
				<tr>
					<td width="60" class="td01">다운로드&nbsp;&nbsp;</td>
					<td height="0" align="left">
						<input type="text" class="input mini" style="width: 830px" value="선택된 파일명" />
					</td>
					<td width="130" align="right" class="td01">
						<a class="btn small focus">다운</a> <a class="btn small focus">삭제</a>
					</td>
				</tr>
			</table>
		</td>
		</tr>
	</table>
</div>
