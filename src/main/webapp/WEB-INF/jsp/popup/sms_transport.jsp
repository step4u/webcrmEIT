<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<script data-jui="#tab_smsTransport" data-tpl="row" type="text/template">
	<tr class="tr03">
		<td align ="center"><!= cateCd !></td>
		<td><!= cateNm !></td>
		<td align = "left"><!= cateComment !></td>
	</tr>
</script>
<script data-jui="#tab_smsTransport" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="3" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
<script>
function initialization(){
	document.getElementById("cate_Cd").value= "";
	document.getElementById("cate_Nm").value = "";
	document.getElementById("cate_Comment").value = "";
}
</script>
<div class="head">
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				SMS 전송유형
			</td>
		</tr>
	</table>
</div>
<div class="body">
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" style="margin-bottom: 2px;">
		<tr>
			<td width="60" class="td01">유형코드</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="cate_Cd" value="10" style="width: 80px" />
			</td>
			<td width="50" class="td01">유형명</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="cate_Nm" value="요금제조회" style="width: 100px" />
			</td>
			<td width="50" class="td01">내용</td>
			<td colspan="2" align="left" class="td02" width="230">
				<input type="text" class="input mini" id="cate_Comment" style="width: 500px" />
			</td>
			<td width="190" align="right" class="td01">
				<a class="btn small focus" onclick="initialization()">초기화</a> 
				<a class="btn small focus" id="bt_smsInsert">저 장</a> 
				<input type="hidden" value= />
				<a class="btn small focus" id="bt_smsSelect">조 회</a>
			</td>
		</tr>
	</table>
	<table class="table classic hover" id="tab_smsTransport" width="100%">
		<thead>
			<tr>
				<th width="10%">코드</th>
				<th width="10%">유형</th>
				<th width="80%">내용</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>