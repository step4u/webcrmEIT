<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var url;
window.player;

var paramCode = {
		lcd : "",
};
var paramRecord = {
		startDate : "",
		endDate: "",
		telNo : "",
		tmptelNo : "",
		callTypCd : "",
		extensionNo : ""
};

jui.ready(["grid.xtable","ui.paging"], function(xtable, paging) {
	tab_record = xtable("#tab_record", {
		resize : true,
		scrollHeight: 400,
        buffer: "s-page",
        bufferCount: 1000,
		width : 1100,
        scrollWidth: 1095,
        tpl: {
            row: $("#tpl_row_record").html(),
            none: $("#tpl_none_record").html()
        }
	});
	
	paging_record = paging("#paging_record", {
	      pageCount: 1000,
	      event: {
	          page: function(pNo) {
	        	  tab_record.page(pNo);
	          }
	       },
	       tpl: {
	           pages: $("#tpl_pages_record").html()
	       }
	});
	
	$("#bt_recordSelect").click(function() {
		paramRecord.startDate = $("#txt_recordStartDate").val().replace(/-/gi, ""); 
		paramRecord.endDate = $("#txt_recordEndDate").val().replace(/-/gi, ""); 
		paramRecord.tmptelNo = $("#txt_recordTel").val().replace(/-/gi, ""); 
		paramRecord.callTypCd = $("#select_recordCallTyp option:selected").val();
		paramRecord.extensionNo = $("#select_recordExtension option:selected").val();
		
		$.ajax({
			url : "/popup/recordList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramRecord),
			success : function(result) {
				page=1;
				tab_record.update(result);
				tab_record.resize(); 
				paging_record.reload(tab_record.count());
			}
		
		});
	});
	
	/*
	 * 녹취현황  
	 * 내선 코드 / 콜구분
	 */	
	$("#bt_recordPopup").click(function() {
		paramCode.lcd = "1007";
		$.ajax({
			url : "/code/selecCodeList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCode),
			success : function(result) {
				$('#select_recordExtension').empty();
				$('#select_recordExtension').append('<option value=' + '' + '></li>');
			    for ( var i = 0; i < result.length; i++) {
						$('#select_recordExtension').append('<option value='+result[i].scd+'>' + result[i].scd + '</option>');
			    } 			
			}
		});
		
		
		paramCode.lcd = "1006";
		$.ajax({
			url : "/code/selecCodeList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCode),
			success : function(result) {
				$('#select_recordCallTyp').empty();
				$('#select_recordCallTyp').append('<option value=' + '' + '></option>');
			    for ( var i = 0; i < result.length; i++) {
						$('#select_recordCallTyp').append('<option value='+result[i].scd+'>' + result[i].scdNm + '</option>');
			    } 			
			}
		});
		
		var date = new Date();
		var month = date.getMonth() + 1;
		month = month < 10 ? '0' + month : month;
		var day = date.getDate();
		day = day < 10 ? '0' + day : day;

		$("#txt_recordStartDate").val(setYesterday(date.getFullYear() +'-'+ month +'-'+ day));
		$("#txt_recordEndDate").val(date.getFullYear() +'-'+ month +'-'+ day);
		
		tab_record.update(0);	
	});
	
	/* 엑셀저장 */
	$("#bt_recordExcel").click(function() {
		var empNm = $("input[name=empNm]").val();
		paramRecord.startDate = $("#txt_recordStartDate").val().replace(/-/gi, ""); 
		paramRecord.endDate = $("#txt_recordEndDate").val().replace(/-/gi, ""); 
		paramRecord.callTypCd = $("#select_recordCallTyp option:selected").val();
		paramRecord.extensionNo = $("#select_recordExtension option:selected").val();
		paramRecord.telNo = $("#txt_recordTel").val();

		$("#ifraRecord").attr("src", "/popup/redcordListExcel?startDate="+paramRecord.startDate+"&endDate="+paramRecord.endDate+"&callTypCd="+paramRecord.callTypCd + "&extensionNo=" + paramRecord.extensionNo  + "&telNo=" + paramRecord.telNo +"&empNm="+empNm);
	});
	
});
function recordtest(recSeq){
	url = "/main/" + recSeq ;
/* 	console.log('window.player.playing : ' + window.player.playing);
	if (window.player.playing) {
		window.player.close();
	} */
	try {
		window.player.close();
	} catch (err) {
		console.log(err);
	}
	window.player = new Player(url, document.querySelector('#player'));
}
</script>
<script id="tpl_row_record" type="text/template">
	<tr class="tr03">
		<td align ="center"><!= extensionNo !></td>
		<td align ="center"><!= telNo !></td>
		<td><!= callTypCd !></td>
		<td><!= recStartDate !> <!= recStartHms !></td>
		<td><!= fileSize !></td>
		<td><!= fileName !></td>
		<td><a id="doplay" href="javascript:recordtest('<!= recSeq !>');"><span class="icon icon-left"></span></a></td>
	</tr>
</script>
<script id="tpl_none_record" type="text/template">
    <tr height ="390">
        <td colspan="7" class="none" align="center">데이터가 존재하지 않습니다.</td>
    </tr>
</script>
<script id="tpl_pages_record" type="text/template">
    <! for(var i = 0; i < pages.length; i++) { !>
    <a href="#" class="page" onclick="fn_page();"><!= pages[i] !></a>
    <! } !>
</script>
<script>
$(document).ready(function() {
	$("#txt_recordStartDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd",
		dayNamesMin : ["일","월","화","수","목","금","토"],
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		nextText:'다음 달',
        prevText:'이전 달'
	}); 

	$("#txt_recordEndDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd",
		dayNamesMin : ["일","월","화","수","목","금","토"],
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		nextText:'다음 달',
        prevText:'이전 달'
	});
});
</script>
<style>
#record_top_tr td {
	padding-bottom: 5px;
}
</style>
<div class="head">
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				녹취현황
			</td>
		</tr>
	</table>
</div>
<div class="body">
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" style="margin-bottom: 2px;">
		<tr id="record_top_tr">
			<td class="td01" style="text-align: center; padding-left:0px !important">통화일자</td>
			<td class="td02" style="text-align: left;">
				<input type="text" class="input mini" id="txt_recordStartDate" style="width: 82px" /> 
				<input type="text" class="input mini" id="txt_recordEndDate"  style="width: 82px" />
			</td>
			<td class="td01">콜구분</td>
			<td class="td02">
				<select id="select_recordCallTyp"></select>
			</td>
			<td class="td01">내선번호</td>
			<td class="td02">
				<select id="select_recordExtension"></select>
			</td>
			<td class="td01">전화번호</td>
			<td class="td02">
				<input type="text" class="input mini" id="txt_recordTel" maxLength="14" style="width: 120px; float:left" onfocus="OnCheckPhone(this)" onfocus="OnCheckPhone(this)" onKeyup="removeChar(event); OnCheckPhone(this);" onkeydown="return onlyNumber(event);"/>
			</td>
			<td width="150" align="right" class="td01" style="padding-right:9px;">
				<a class="btn small focus" id="bt_recordSelect">조 회</a>
				<a class="btn small focus" id="bt_recordExcel">엑셀 다운로드</a>
			</td>
		</tr>
	</table>
	<table class="table classic hover" id="tab_record" width="100%" style="padding-left: 5px;">
		<thead>
			<tr>
				<th style="width:100px">내선번호</th>
				<th style="width:120px">전화번호</th>
				<th style="width:100px">콜유형</th>
				<th style="width:146px">녹취일시</th>
				<th style="width:100px">파일크기</th>
				<th style="width:300px">파일명</th>
				<th style="width:auto">청취</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<iframe id="ifraRecord" name="ifraRecord" style="display:none;"></iframe>
	<div id="paging_record" class="paging" style="margin-top: 4px; margin-right: 4px; width:1092px;">
	    <a href="#" class="prev" style="left:0" onclick="fn_page();">이전</a>
	    <div class="list"></div>
	    <a href="#" class="next" onclick="fn_page();">다음</a>
	</div>
<div class="sm2-bar-ui" id="player">
<!--div class="sm2-bar-ui compact full-width"-->

 <div class="bd sm2-main-controls">

  <div class="sm2-inline-texture"></div>
  <div class="sm2-inline-gradient"></div>

  <div class="sm2-inline-element sm2-button-element">
   <div class="sm2-button-bd">
    <a href="#play" class="sm2-inline-button play-pause">Play / pause</a>
   </div>
  </div>

  <div class="sm2-inline-element sm2-inline-status">

   <div class="sm2-playlist">
    <div class="sm2-playlist-target">
     <!-- playlist <ul> + <li> markup will be injected here -->
     <!-- if you want default / non-JS content, you can put that here. -->
     <noscript><p>JavaScript is required.</p></noscript>
    </div>
   </div>

   <div class="sm2-progress">
    <div class="sm2-row">
    <div class="sm2-inline-time">00:00:00</div>
     <div class="sm2-progress-bd">
      <div class="sm2-progress-track">
       <div class="sm2-progress-bar"></div>
       <div class="sm2-progress-ball"><div class="icon-overlay"></div></div>
      </div>
     </div>
     <div class="sm2-inline-duration">00:00:00</div>
    </div>
   </div>

  </div>

  <div class="sm2-inline-element sm2-button-element sm2-volume">
   <div class="sm2-button-bd" id='volumeContainter'>
    <span id='volume' class="sm2-inline-button sm2-volume-control volume-shade"></span>
    <a href="#volume" class="sm2-inline-button sm2-volume-control">volume</a>
   </div>
  </div>

 </div>

 <div class="bd sm2-playlist-drawer sm2-element">

  <div class="sm2-inline-texture">
   <div class="sm2-box-shadow"></div>
  </div>

  <!-- playlist content is mirrored here -->

  <div class="sm2-playlist-wrapper">
    <ul class="sm2-playlist-bd">
     <li id="playertitle">sample - sample</li>
    </ul>
  </div>

 </div>

</div>
	
</div>
