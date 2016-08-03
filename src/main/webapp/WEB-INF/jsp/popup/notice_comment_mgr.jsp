<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<!-- <div class="head">
	<div class="left">공지사항 의견달기</div>
	<div class="right" style="left:1080px;">
		<a href="#" class="close"><i class="icon-exit"></i></a>
	</div>
</div> -->

<script data-jui="#tab_noticeReply" data-tpl="row" type="text/template">
	<tr class="tr03">
		<td><!= regDate !></td>
		<td><!= regEmpNm !></td>
		<td><!= commentNote !></td>
	</tr>
</script>
<script data-jui="#paging_reply" data-tpl="pages" type="text/template">
    <! for(var i = 0; i < pages.length; i++) { !>
    <a href="#" class="page"><!= pages[i] !></a>
    <! } !>
</script>
<script>
function replyInitialization(){
	document.getElementById("txt_noticeReply").value = ""; 
}
</script>
<div class="head">
	<a href="#" class="close"><i class="icon-exit"></i></a>
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
<div class="body">
	<table border="0" cellpadding="0" cellspacing="0" class="table01">
                <tr>
                  <td width="65" border="0" cellpadding="0" cellspacing="0">
  <tr>
                      <td width="65" class="td01">제목&nbsp;&nbsp;</td>
          <td height="25" colspan="2" align="left"><input type="text" class="input mini" style="width:895px" id="txt_noticeCommentSbj" /></td>
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
        <table class="table01" border="0" cellpadding="0" cellspacing="0" style="margin-top:2px;">
                <tr>
                  <td width="65" class="td01">의견내용&nbsp;&nbsp;</td>
                  <td height="100" align="left"><textarea name="textarea2" class="input" id="txt_noticeReply" style="height: 100px;width:895px" ></textarea></td>
                  <td align="right" valign="middle"><table width="68" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                      <td height="28" align="right">
                      	<a class="btn small focus" id="bt_replyInsert">저&nbsp;&nbsp;장</a>
                      </td>
                    </tr>
                    <tr>
                      <td height="28" align="right"><a class="btn small focus" onclick="javascript:replyInitialization()">초기화</a></td>
                    </tr>
                  </table></td>
              </tr>
                <tr>
                  <td colspan="3" align="left" >
                  <table class="table classic hover" id="tab_noticeReply" width="100%" style="margin-top:2px;">
                    <thead>
                      <tr>
                        <th class="th01">작성일시</th>
                        <th>작성자</th>
                        <th width="60%">내용</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr class="tr03">
                		<td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                    </tbody>
                  </table>
            
                  </td>
                  
                </tr>
                
          </table>
<div id="paging_reply" class="paging" style="width: 100%; margin-top: 3px;">
			<a href="#" class="prev" style="left:0;">Previous</a>
			<div class="list"></div>
			<a href="#" class="next">Next</a>
			</div>
</div>