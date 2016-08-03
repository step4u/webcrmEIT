<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<script>
function fn_noticeFileSelect() {
	document.getElementById("fileNotice").click();
	document.getElementById("noticefileRoot").value=document.getElementById("fileNotice").value;
}
</script>
<div class="head">
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
<form  method="post" enctype="multipart/form-data">
	<table style="width: 100%" border="0" cellpadding="0" cellspacing="0" class="table01">
		<tr>
		<td>
			<table style="width: 100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="60" class="td01">제목&nbsp;&nbsp;</td>
					<td height="26" align="left">
						<input type="text" class="input mini" id="txt_noticeSbj" style="width: 830px" />
					</td>
					<td width="130" align="right" class="td01">
						<a class="btn small focus" id="insertNotice">저장</a> 
						<a class="btn small focus">취소</a>
					</td>
				</tr>
				<tr>
					<td width="60" class="td01">내용&nbsp;&nbsp;</td>
					<td height="100" colspan="2" align="left">
						<textarea name="textarea" class="input" id="txt_noticeNote" style="height: 100px; width: 960px"></textarea>
					</td>
				</tr>
				<tr>
					<td width="60" class="td01">첨부파일&nbsp;&nbsp;</td>
					<td height="25" colspan="2" align="left">
						<input type="file" id="fileNotice" name="uplaodFile" style="display : none"/>
						<a class="btn small focus" onclick="fn_noticeFileSelect()">파일선택</a> 
						<input type="text" class="input mini" id="noticefileRoot"  style="width: 890px" />
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
</form>
</div>