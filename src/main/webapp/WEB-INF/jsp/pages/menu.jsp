<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<!-- <link rel="stylesheet" href="../resources/jui-master/dist/ui.css">
	<link rel="stylesheet" href="../resources/jui-master/dist/ui.min.css">
	<link rel="stylesheet" href="../resources/jui-master/dist/ui-jennifer.css">
	<link rel="stylesheet" href="../resources/jui-master/dist/ui-jennifer.min.css"> -->

<%-- <%@ include file="../common/jui_common.jsp"%> --%>

<!-- <style type="text/css">
#targetElement {
	height: 200px;
	margin: 50px;
	background: #9cf;
}

.positionDiv {
	position: absolute;
	width: 75px;
	height: 75px;
	background: #080;
}
</style> -->

<!-- <script type="text/javascript">
jui.ready([ "ui.window" ], function(win) {
	win_1 = win("#win_1", {
		width : 1117,
		height : 558,
		left : "5%",
		top : 200,
		resize : false,
		move : true
	});
});
</script> -->

</head>

<body class="jui">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="70" align="center"><img
				src="../resources/jui-master/img/theme/jennifer/logo.png"
				width="136" height="26"></td>
		</tr>
	</table>
	<table>
		<tr>
			<td>
				<div class="vmenu">
					<a class="active">고객정보<i class="icon-arrow1"></i></a>
					<ul class="submenu"  style="display:none">
						<li id="bt_excelPopup"><a onclick="win_1.show()">엑셀로 고객정보 저장</a></li>
						<!-- <li id="bt_customerPopup"><a onclick="win_13.show()">고객정보선택</a></li> -->
					</ul>
					<a>통 계<i></i></a>
					<ul class="submenu"  style="display:none">
						<li id="bt_recordPopup"><a onclick="win_2.show()">녹취 현황</a></li>
						<li id="bt_ivrPopup"><a onclick="win_3.show()">IVR 현황</a></li>
						<li id="bt_callcenterPopup"><a onclick="win_4.show()">전체 통계현황</a></li>
						<li id="bt_councellerPresentPopup"><a onclick="win_5.show()">상담원 통계 현황</a></li>
					</ul>
					<a>공지사항<i></i></a>
					<ul class="submenu"  style="display:none">
						<li id="bt_noticePopup"><a onclick="win_6.show()">공지사항 조회</a></li>
						<!-- <li><a onclick="win_7.show()">공지사항 등록/수정</a></li> -->
						<!-- <li><a onclick="win_8.show()">공지사항 댓글관리</a></li> -->
					</ul>
					<a>환경설정<i></i></a>
					<ul class="submenu"  style="display:none">
						<li id="bt_councellerPopup"><a onclick="win_9.show()">상담원관리</a></li>
						<li id="bt_smsPopup"><a onclick="win_10.show()">SMS 전송유형</a></li>
						<li id="bt_extenstionPopup"><a onclick="win_11.show()">내선관리</a></li>
					</ul>
				</div>
			</td>
		</tr>
	</table>
</body>
</html>