<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>인턴프로젝트</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootswatch/3.3.7/paper/bootstrap.min.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
<link rel="stylesheet"
	href="https://cdn.rawgit.com/mladenplavsic/bootstrap-navbar-sidebar/3bd282bd/docs/navbar-fixed-right.min.css">
<link rel="stylesheet"
	href="https://cdn.rawgit.com/mladenplavsic/bootstrap-navbar-sidebar/3bd282bd/docs/navbar-fixed-left.min.css">
<link rel="stylesheet"
	href="https://cdn.rawgit.com/mladenplavsic/bootstrap-navbar-sidebar/3bd282bd/docs/docs.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script
	src="https://cdn.rawgit.com/mladenplavsic/bootstrap-navbar-sidebar/3bd282bd/docs/docs.js"></script>
<script async defer src="https://buttons.github.io/buttons.js"></script>
<style>
.fakeimg {
	height: 200px;
	background: #aaa;
}

.subReply {
	padding-left: 50px;
}

.nav-link {
	color: white !important;
}

.dropdown .dropdown-menu a:hover {
	color: #000 !important;
	background-color: #FF0000;
	border-color: #000;
}
</style>
<script>
	var IDX = getQueryStringObject().idx;
	function getQueryStringObject() {
		var a = window.location.search.substr(1).split('&');
		if (a == "")
			return {};
		var b = {};
		for (var i = 0; i < a.length; ++i) {
			var p = a[i].split('=', 2);
			if (p.length == 1)
				b[p[0]] = "";
			else
				b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
		}
		return b;
	} // 연구해보기
	
	/* 댓글관련 */
	function drawReply(replys) {
		$("#cnt").text("등록된 댓글 - " + replys.length)
		var html = '';
		html += '<form class="form-inline" action="writeReply" method="post"><input type="hidden" name="idx" value = "' + IDX + '"><input type="hidden" name="replyIdx" value = "0"><input type="text" class="form-control mb-2 mr-sm-2" id="contents" placeholder="답글" name="contents"><button type="submit" class="btn btn-primary mb-2">등록</button></form>';

		replys
				.forEach(function(reply) {
					if (reply.replyIdx == 0) {
						var rc = 0;
						replys.forEach(function(i) {
							if (reply.idx == i.replyIdx)
								rc++;
						})
						html += '<div class="row"><div class="col-sm-12">';
						html += '<form class="form-inline" action="writeReply" method="post"><label for="pwd" class="mr-sm-2">'
								+ reply.contents + '(' + rc + ')' + '</label>'
						html += '<input type="hidden" name="idx" value = "' + IDX + '"><input type="hidden" name="replyIdx" value = "' + reply.idx + '"><input type="text" class="form-control mb-2 mr-sm-2" id="contents" placeholder="답글" name="contents"><button type="submit" class="btn btn-primary mb-2">등록</button></form>';
						html += '<div class="row"><div class="col-sm-12 sub' + reply.idx + '"></div></div></div></div>';
					}
				})
		$("#replyArea").append(html);
		replys
				.forEach(function(reply) {
					if (reply.replyIdx != 0) {
						var rc = 0;
						replys.forEach(function(i) {
							if (reply.idx == i.replyIdx)
								rc++;
						})
						var subHtml = '';
						subHtml = '<div class="row"><div class="col-sm-12 subReply">';
						subHtml += '<form class="form-inline" action="writeReply" method="post"><label for="pwd" class="mr-sm-2">'
								+ reply.contents + '(' + rc + ')' + '</label>'
						subHtml += '<input type="hidden" name="idx" value = "' + IDX + '"><input type="hidden" name="replyIdx" value = "' + reply.idx + '"><input type="text" class="form-control mb-2 mr-sm-2" id="contents" placeholder="답글" name="contents"><button type="submit" class="btn btn-primary mb-2">등록</button></form>';
						subHtml += '<div class="row"><div class="col-sm-12 sub' + reply.idx + '"></div></div></div></div>';
						$(".sub" + reply.replyIdx).append(subHtml);
					}
				})
	}
	
	
	$.ajax({
		url : "boardView?idx=" + IDX,
		success : function(result) {
			 $("#image").append('<img src="resources/images/'+ result.image + '" style="width: 100%;">');
			$("#title").text(result.title);
			$("#contents").text(result.contents);
			console.log(result.contents);
			console.log(result.image);
		}
	});

	$.ajax({
		url : "replyList?idx=" + IDX,
		success : function(replys) {
			drawReply(replys)
		}
	});
</script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$("#writeBtn").click(function() {
							location.href = "write";
						})
						$
								.ajax({
									url : "boardList",
									success : function(result) {
										var html = "";
										result
												.forEach(function(item) {
													html += "<tr> <td><a href = 'view?idx="
															+ item.idx
															+ "'>"
															+ item.title
															+ "</a>"
															+ "<button type='button' class='btn btn-danger' style='float: right;' id = 'deleteBtn' onclick = 'location.href = 'view?idx='"
															+ item.idx
															+ "'>글삭제</button></td> </tr>"
												})
										$("#listArea").append(html)
										$('#example').DataTable();
									}
								});
						$("#deleteBtn").click(function() {
							location.href = "write";
						})
					});
	/*
	 html+= "<tr> <td><a href = 'view?idx=" + item.idx + "'>" + item.title + "</a></td> </tr>"
	 + "<button type='button' class='btn btn-primary' align='right' id = 'deleteBtn'>글삭제</button></td> </tr>"
	 <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
	 */
</script>
</head>
<body>


	<div class="jumbotron text-center" style="margin-bottom: 0">
		<h1>
			<a href="index.html">인턴 프로젝트 게시판</a>
		</h1>
	</div>
	<nav class="navbar navbar-inverse navbar-fixed-left navbar-light">
		<div class="container">

			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed"
					data-toggle="collapse" data-target="#navbar" aria-expanded="false"
					aria-controls="navbar">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">CONTENTS</a>
			</div>


			<!-- collapse 클릭하면 펼쳐지고 보여지는 기능 -->
			<div class="collapse navbar-collapse" id="collapsibleNavbar">
				<ul class="navbar-nav flex-column">

					<li class="nav-item"><a class="nav-link" href="index">홈</a></li>

					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false" style="color: white">게시판 <span
							class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="mainBoard" style="color: bk">메인 게시판</a></li>
							<li><a href="tempBoard" style="color: bk">임시저장 게시판</a></li>
							<li><a href="saveBoard" style="color: bk">완료 게시판</a></li>
							<li><a href="deleteBoard" style="color: bk">삭제 게시판</a></li>
						</ul></li>



				</ul>
			</div>


		</div>
	</nav>

	<div class="container" style="margin-top: 30px">
		<div class="row">
			<div class="col-sm-12">
				<h2>본문</h2>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-6">
				<div id="image"></div>
			</div>
			<div class="col-sm-6">
				<div class="row">
					<div class="col-sm-12">
						<h2 id="title"></h2>
					</div>
					<div class="col-sm-12">
						<pre id="contents"></pre>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<h2 id="cnt"></h2>
				<div id="replyArea"></div>
			</div>
		</div>
	</div>
</body>
</html>
