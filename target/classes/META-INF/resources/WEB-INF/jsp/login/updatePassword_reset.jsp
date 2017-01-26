<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script type="text/javascript">
var users = {
		username : "",
		empNo : "",
		password : "",
		newPwd : "",
	};

function updatePwd_reset() {
			var empNo = $("input[name=pwdEmpNo_reset]").val();
			var nowPwd = $("input[name=nowPwd_reset]").val();
			var newPwd = $("input[name=newPwd_reset]").val();
			var confirmPwd = $("input[name=confirmPwd_reset]").val();
			if(empNo == ""){
				msgboxActive('비밀번호 변경', "아이디를 입력해주세요.");
		 	}else if(empNo != <%= session.getAttribute("empNo")%>){
		 		msgboxActive('비밀번호 변경', "본인만 변경 할 수 있습니다.");
			}else if(empNo == "superadmin"){
				msgboxActive('비밀번호 변경', "비밀번호를 변경할 수 없습니다.");
			}else if(nowPwd == ""){
				msgboxActive('비밀번호 변경', "현재 비밀번호를 입력해주세요.");
			}else if(newPwd == ""){
				msgboxActive('비밀번호 변경', "새 비밀번호를 입력해주세요.");
			}else if(confirmPwd == ""){
				msgboxActive('비밀번호 변경', "새 비밀번호 확인을 입력해주세요.");
			}else if(newPwd != confirmPwd){
				msgboxActive('비밀번호 변경', "새 비밀번호와 새 비밀번호 확인이 맞지 않습니다.");
			}else{
					if(newPwd == confirmPwd){
						users.empNo = empNo;
						users.password = nowPwd;
						users.newPwd = newPwd;
						var jsondata = JSON.stringify(users);
						$.ajax({
							url : "/login/updatePwd",
							type : "post",
							contentType : 'application/json; charset=utf-8',
							data : JSON.stringify(users),
							success : function(result) {
								if(result == 0){
									msgboxActive('비밀번호 변경', '\"현재 비밀번호\"를 확인하세요.');
								}else if(result == 2){
									msgboxActive('비밀번호 변경', '공백을 제외하고 영문자, 숫자, 특수문자를 포함한 8자리~20자리의 비밀번호를 입력하세요.');
								}else if(result == 1){
									msgboxActive('비밀번호 변경', '비밀번호 변경이 완료되었습니다.');
									win_12_2.hide();
								}
							}
						});
					}
			}
		}
</script>
<style>
#win_12_2 > div.body > form > table > tbody > tr{
	height: 35px;
}
#win_12_2 > div.body > form > table > tbody > tr > td > input[type=password]{
	width: 150px; height: 22px; font-size:20px;
}
</style>
</head>
<body class="jui">
	<div class="head">
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td class="poptitle"style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">비밀번호 변경</td>
			</tr>
		</table>
	</div>
	<div class="body" style="height:239px; width:360px">
			<p><b>공백을 제외하고 영문자, 숫자, 특수문자를 포함한<br>8자리~20자리의 비밀번호를 입력하세요.</b></p>
		<form name="frm" method="post">
			<table width="330" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<hr>
							<td align="left">현재 비밀번호  </td>
							<td>
								<input type="hidden" name= "pwdEmpNo_reset" class="input mini" placeholder="아이디" value="<%= session.getAttribute("empNo") %>" style="width: 130px" /> 
								<input type="password" name="nowPwd_reset" class="input" maxlength="20" onkeyup="noSpaceForm(this);" onkeydown="noSpaceForm(this);" onchange="noSpaceForm(this);" />
							</td>
						</tr>
						<tr>
							<td align="left">새로운 비밀번호  </td>
							<td>
								<input type="password" name="newPwd_reset" class="input" maxlength="20" onkeyup="noSpaceForm(this);" onkeydown="noSpaceForm(this);" onchange="noSpaceForm(this);" />
							</td>
						</tr>
						<tr>
							<td align="left">새로운 비밀번호 확인 </td>
							<td>
								<input type="password" name="confirmPwd_reset" class="input" maxlength="20" onkeyup="noSpaceForm(this);" onkeydown="noSpaceForm(this);" onchange="noSpaceForm(this);"/>
							</td>
						</tr>
						<tr>
							<td align="center" colspan="2" style="padding-top: 15px;">
								<a class="logbtn small focus" href="javascript:updatePwd_reset();" style="height:30px;">확인</a>&nbsp;
							</td>
						</tr>
					</table>
			</form>
</div>
</body>
</html>