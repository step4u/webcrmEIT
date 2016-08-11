<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="shortcut icon" type="image/x-icon" href="../resources/jui-master/img/icon/favicon.ico" />
<title>Coretree - IP Contact Centre</title>
<!-- <script src="../resources/js/jquery-2.2.4.min.js"></script> -->

<%@ include file="./common/jui_common.jsp"%>
<script src="../resources/js/popup.js"></script>

<!-- 좌측 메뉴 slide 기능을 위한 파일 -->

<!-- 우측 사이드 바 기능 활용을 위한 파일 -->
<link rel="stylesheet" href="../resources/css/jquery-ui.css">
<script src="../resources/js/jquery-ui.js"></script>

<!-- Popup script components -->
<script src="../resources/js/popupEvent.js"></script>
<script src="../resources/js/tel.js"></script>

<style type="text/css">
body {
	overflow-y: hidden;
}

.navigation {
	display: block;
	position: absolute;
	float: left;
	top: 0;
	left: 0;
	width: 205px;
	height: 100%;
	background-color: #eaeaea;
	background-image:
		url(../resources/jui-master/img/theme/jennifer/left_back.jpg);
	margin-top: 8px;
}

.content-wrapper {
	display: block;
	position: absolute;
	float: left;
	left: 205px;
	top: 0;
	height: 100%;
	width: 1140px;
	/* width:885px; */
}

.top {
	margin-top: 8px;
	background-image:
		url(../resources/jui-master/img/theme/jennifer/top_back.jpg);
}

.right {
	display: block;
	position: absolute;
	float: right;
	top: 0;
	right: 0;
	left: 1345px;
	width: 20px;
	height: 100%;
}

.nav-right {
	display: none;
	position: absolute;
	float: right;
	top: 0;
	right: 0;
	width: 250px;
	height: 100%;
	background-color: lightgray;
}
</style>

<script>
	$(document).ready(function() {

		$(".submenu").slideUp();
		$(".submenu:first").slideDown();

		/* 좌측 메뉴 slide 기능 */
		$(".vmenu>a").click(function() {
			$(".vmenu>a").removeClass("active");
			$(this).addClass("active");
			$(".vmenu a i").removeClass("icon-arrow1");
			$(this).find("i").addClass("icon-arrow1");

			var submenu = $(this).next("ul");
			$(".submenu").slideUp();
			submenu.slideToggle();
		});

		$(".submenu>li").click(function() {
			$(".submenu>li").removeClass("active");
			$(this).addClass("active");

		});

		/* 우측 사이드바 기능 */
		$("#imgSidr").click(function() {
			$("#sidr").toggle("right");
			monitoringSearch();
		});

		/* 상단 탭 컨트롤 */
		/* $(".tab_up").ready(function() {
			$(".tab_content").hide();
			$(".tab_content:first").show();
			$("ul.tab_up li:first").addClass("checked");
			$("ul.tab_up li:first i").addClass("icon-arrow1");

			$("ul.tab_up li").click(function() {
				$("ul.tab_up li").removeClass("checked");
				$(this).addClass("checked");
				$("ul.tab_up li i").removeClass("icon-arrow1");
				$(this).find("i").addClass("icon-arrow1");

				$(".tab_content").hide();
				var activeTab = $(this).attr("rel");
				$("#" + activeTab).fadeIn("fast");
			});
		}); */

		/* 하단 탭 컨트롤 */
		/* $(".tab_down").ready(function() {
			$(".tab_content2").hide();
			$(".tab_content2:first").show();
			$("ul.tab_down li:first").addClass("checked");
			$("ul.tab_down li:first i").addClass("icon-arrow1");

			$("ul.tab_down li").click(function() {
				$("ul.tab_down li").removeClass("checked");
				$(this).addClass("checked");
				$("ul.tab_down li i").removeClass("icon-arrow1");
				$(this).find("i").addClass("icon-arrow1");

				$(".tab_content2").hide();
				var activeTab = $(this).attr("rel");
				$("#" + activeTab).fadeIn("fast");
			});
		}); */
		

	jui.ready([ "ui.tab" ], function(tab) {
		tab_1 = tab("#tab_1", {
			event : {
				change : function(data) {
					$("ul.tab_up li").removeClass("checked");
					$("ul.tab_up li i").removeClass("icon-arrow1");

					var a = data.index + 1;

					$("ul.tab_up li:nth-child(" + a + ")").addClass("checked");
					$("ul.tab_up li:nth-child(" + a + ") i").addClass("icon-arrow1");
				}
			},
			target : "#tab_contents_1",
			index : 0
		});

		tab_2 = tab("#tab_2", {
			event : {
				change : function(data) {
					$("ul.tab_down li").removeClass("checked");
					$("ul.tab_down li i").removeClass("icon-arrow1");

					var a = data.index + 1;

					$("ul.tab_down li:nth-child(" + a + ")")
							.addClass("checked");
					$("ul.tab_down li:nth-child(" + a + ") i").addClass(
							"icon-arrow1");
				}
			},
			target : "#tab_contents_2",
			index : 0
		});
	});
});
</script>

</head>

<body class="jui">
	<div class="navigation">
		<%@ include file="./pages/menu.jsp"%>
	</div>

	<!-- CONTENTS -->
	<div class="content-wrapper">
		<!-- 버튼 부분 -->
		<div class="top" style="height: 65px">
			<%@ include file="./pages/softphone.jsp"%>
		</div>
		<div>
			<div style="height: 40%">
				<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<ul id="tab_1" class="tab top tab_up">
								<li class="checked" id="click_tab1"><a href="#tab01" style="padding-bottom: 9px;">고객상세<i class="icon-arrow1"></i></a></li>
								<li id="click_tab2"><a href="#tab02" style="padding-bottom: 9px;">고객리스트<i></i></a></li>
								<li><a href="#tab03" style="padding-bottom: 9px;">콜백<i></i></a></li>
								<li><a href="#tab04" style="padding-bottom: 9px;">상담예약<i></i></a></li>
							</ul>

							<div id="tab_contents_1">
								<div id="tab01"><%@ include file="./pages/tab01.jsp"%></div>
								<div id="tab02"><%@ include file="./pages/tab02.jsp"%></div>
								<div id="tab03"><%@ include file="./pages/tab03.jsp"%></div>
								<div id="tab04"><%@ include file="./pages/tab04.jsp"%></div>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>

	<div class="right">
		<span class='icon icon-chevron-left' id="imgSidr"
			style="line-height: 550px; font-size: 20px;"></span>
	</div>

	<!-- 우측 사이드바 -->
	<div class="nav-right" id="sidr">
		<%@ include file="./pages/right.jsp"%>
	</div>


	<!-- 좌측 메뉴 팝업 -->
	<div id="win_1" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/excel_store.jsp"%>
	</div>

	<div id="win_2" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/record_present.jsp"%>
	</div>

	<div id="win_3" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/ivr_present.jsp"%>
	</div>

	<div id="win_4" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/callcenter_all_present.jsp"%>
	</div>

	<div id="win_5" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/counceller_present.jsp"%>
	</div>

	<div id="win_6" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/notice_ask.jsp"%>
	</div>

	<%-- <div id="win_7" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/notice_reg_modify.jsp"%>
	</div>

	<div id="win_8" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/notice_comment_mgr.jsp"%>
	</div> --%>

	<div id="win_9" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/counceller_manager.jsp"%>
	</div>

	<div id="win_10" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/sms_transport.jsp"%>
	</div>

	<div id="win_11" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/extension_manage.jsp"%>
	</div>

	<div id="win_13" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/callback_reserve.jsp"%>
	</div>

	<div id="win_14" class="msgboxpop danger" style="display:none">
		<%@ include file="./popup/sms_transport_reg.jsp"%>
	</div>
</body>
</html>