<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script type="text/javascript">
var param_t= {
};

jui.ready([ "grid.xtable"], function(xtable) {

	var data;
	var data_size;
	var page = 1;
	var result_data;
	
	/*
	 * 고객정보선택
	 * callback_reserve.jsp
	 */	
	tab_customerListPopup = xtable("#tab_customerListPopup", {
		resize : true,
		scrollHeight: 400,
        buffer: "s-page",
        bufferCount: 20,
	});
	
	$("#bt_customerPopup").click(function() {
		
		$.ajax({
			url : "/popup/customerList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(param_t),
			success : function(result) {
				if(result != ""){
					page=1;
					tab_customerListPopup.update(result);
					 tab_customerListPopup.resize(); 
				}else{
				 tab_customerListPopup.resize(); 
				}
			}
		
		});
	});
	
	paging_customer1 = function(no) {
        page += no;
        page = (page < 1) ? 1 : page;
        tab_customerListPopup.page(page);
	}
});
</script>
<script data-jui="#tab_customerListPopup" data-tpl="row" type="text/template">
	<tr class="tr03">
		<td align ="center" width="6%"><!= custNo !></td>
		<td width="5%"><!= custNm !></td>
		<td width="10%"><!= tel1No !></td>
		<td width="10%"><!= tel2No !></td>
		<td width="10%"><!= tel3No !></td>
		<td width="13%"><!= emailId !></td>
		<td width="25%"><!= addr !></td>
		<td width="10%"><!= custNote !></td>
	</tr>
</script>

<!-- <script data-jui="#paging_customer1" data-tpl="pages" type="text/template">
    <! for(var i = 0; i < pages.length; i++) { !>
    <a href="#" class="page"><!= pages[i] !></a>
    <! } !>
</script>
-->
<div class="head">
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				고객정보선택
			</td>
		</tr>
	</table>
</div>
<div class="body">
	<table class="table classic hover" id="tab_customerListPopup" width="100%">
		<thead>
			<tr>
				<th width="6%">고객번호</th>
				<th width="5%">고객명</th>
				<th width="10%">연락처1</th>
				<th width="10%">연락처2</th>
				<th width="10%">연락처3</th>
				<th width="13%">eMail</th>
				<th width="25%">주소</th>
				<th width="10%">비고</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<div class="row" align="right" style="text-align: right; margin-top: 3px;">
	    <div class="group">
	        <button onclick="paging_customer1(-1);" class="btn mini">Prev</button>
	        <button onclick="paging_customer1(1);" class="btn mini">Next</button>
	    </div>
	</div>
</div>