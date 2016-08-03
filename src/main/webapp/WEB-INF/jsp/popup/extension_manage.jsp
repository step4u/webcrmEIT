<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var paramCode = {
		lcd : "",
};
var paramExtensionInsert = {
		scdNm : "",
		scd : ""
};
var paramExtension = {
		scd : ""
};

jui.ready([ "grid.table", "ui.paging"], function(table, paging) {

	tab_extension = table("#tab_extension", {
		/* scroll : true, */
		 resize : true,
		 event: {
	        click: function(row, e) {
	    	this.select(row.index);
	        }
	    }
	});
	
	/*조회 버튼*/
	$("#bt_extensionSelect").click(function() {
		paramCode.lcd = "1007";
		
		$.ajax({
			url : "/code/selecCodeList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCode),
			success : function(result) {
				tab_extension.reset();
				tab_extension.append(result);
			}
		});
	
	});
	
	/*저장 버튼*/
	$("#bt_extensionInsert").click(function() {
		paramExtensionInsert.scd = $("#txt_extensionNo").val();
		paramExtensionInsert.scdNm = $("#txt_extensionContents").val();
		
		
		$.ajax({
			url : "/code/insertExtensionCode",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramExtensionInsert),
			success : function(result) {
				if(result == 1){
					alert("저장이 완료되었습니다");
				}else if(result == 0){
					alert("내선번호가 존재합니다.");
				}	
				$("#txt_extensionNo").val("");
				$("#txt_extensionContents").val("");
				$("#bt_extensionSelect").click();
			}
		});
		
	
	});
	
	/*삭제 버튼*/
	$("#bt_extensionDelete").click(function() {
		paramExtension.scd = $("#extension_scd").val();
		$.ajax({
			url : "/code/deleteExtensionCode",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramExtension),
			success : function(result) {
				if(result == 1){
					alert("삭제가 완료되었습니다");
				}else if(result == 0){
					alert("삭제가 되지 않았습니다.");
				}
				$("#bt_extensionSelect").click();
			}
		});
	
	});
	
});
</script>
<script data-jui="#tab_extension" data-tpl="row" type="text/template">
	<tr class="tr03" onclick = "javascript:deleteExtension(<!= scd !>)";>
		<td><input type="checkbox" /></td>
		<td align ="center"><!= scd !></td>
		<td><!= scdNm !></td>
	</tr>
</script>

<script data-jui="#paging_extension" data-tpl="pages" type="text/template">
    <! for(var i = 0; i < pages.length; i++) { !>
    <a href="#" class="page"><!= pages[i] !></a>
    <! } !>
</script>
<script data-jui="#tab_extension" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="3" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
<script>
function bt_initialization(){
	document.getElementById("txt_extensionNo").value = "";
	document.getElementById("txt_extensionContents").value = "";
}
function deleteExtension(scd){
	document.getElementById("extension_scd").value = scd;	
}
</script>
<div class="head">
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				내선관리
			</td>
		</tr>
	</table>
</div>
<div class="body">
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" style="margin-bottom: 2px;">
		<tr>
			<td width="60" class="td01">내선번호</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="txt_extensionNo" value="1001" style="width: 80px" />
			</td>
			<td width="50" class="td01">내용</td>
			<td colspan="2" align="left" class="td02" width="230">
				<input type="text" class="input mini" id="txt_extensionContents" style="width: 590px" />
			</td>
			<td width="260" align="right" class="td01">
				<a class="btn small focus" onclick="bt_initialization()">초기화</a> 
				<a class="btn small focus" id="bt_extensionInsert">저 장</a> 
				<a class="btn small focus" id="bt_extensionDelete">삭 제</a>
				<input type="hidden" id="extension_scd" />
				<a class="btn small focus" id="bt_extensionSelect">조 회</a>
			</td>
		</tr>
	</table>
	<table class="table classic hover" id="tab_extension" width="100%">
		<thead>
			<tr>
				<th width="5%"></th>
				<th width="10%">내선번호</th>
				<th width="85%">내용</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>