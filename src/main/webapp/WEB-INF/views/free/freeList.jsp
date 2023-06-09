<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보 공유 리스트</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- 글꼴 -->
<link rel="stylesheet" href="./css/font.css">

<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>

<!-- 날씨 -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="./js/weather.js"></script>

<!-- 부트스트랩 -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"></script>

<style>
.container {
	text-align: center;
}

* {
	font-family: 'Title_Medium';
}

#searchForm {
	padding: 50px;
}

td>a {
	color: black;
}
</style>
</head>

<body>
	<div class="wrap">
		<c:import url="../header.jsp" />
		<div class="container" align="center" style="margin: 50px auto;">
			<br>
			<h3>여행 정보 공유</h3>

			<div class="d-flex justify-content-end">
				<a href="freeWrite.do" class="btn btn-outline-primary">글쓰기</a>
			</div>

			<!-- <table class="table table-striped"> -->
			<table class="table table-hover" style="margin-top: 5px;">
				<thead>
					<tr>
						<th scope="col">글번호</th>
						<th scope="col">카테고리</th>
						<th scope="col">작성자</th>
						<th scope="col">글제목</th>
						<th scope="col">조회수</th>
						<th scope="col">좋아요</th>
						<th scope="col">싫어요</th>
						<th scope="col">작성시간</th>
					</tr>
				</thead>
				<tboby> <c:if test="${empty list}">
					<tr>
						<td colspan="13">데이터가 없습니다</td>
					</tr>
				</c:if> <c:if test="${not empty list}">
					<c:set var="no" value="${no }"></c:set>
					<c:forEach var="freeBean" items="${list }">
						<tr>
							<th scope="row">${no}</th>
							<td>${freeBean.free_category}</td>
							<td>${freeBean.free_nick}</td>
							<td><a
								href="freeContent.do?num=${freeBean.free_no}&pageNum=${pp.currentPage}">
									${freeBean.free_title} </a></td>
							<td>${freeBean.free_hit}</td>
							<td>${freeBean.free_like}</td>
							<td>${freeBean.free_dislike}</td>
							<td><fmt:formatDate value="${freeBean.free_date}"
									pattern="yy-MM-dd HH:mm:ss" /></td>
						</tr>
						<c:set var="no" value="${no - 1}"></c:set>
					</c:forEach>
				</c:if>
				</tbody>
			</table>

			<form class="form-inline my-2 my-md-0 justify-content-center"
				id="searchForm" action="freeList.do?pageNum=1">
				<select class="custom-select" name="search">
					<option value="free_title"
						<c:if test="${search=='free_title'}">selected="selected" </c:if>>제목</option>
					<option value="free_content"
						<c:if test="${search=='free_content'}">selected="selected" </c:if>>내용</option>
					<option value="free_nick"
						<c:if test="${search=='free_nick'}">selected="selected" </c:if>>작성자</option>
					<option value="subcon"
						<c:if test="${search=='subcon'}">selected="selected" </c:if>>제목+내용</option>
				</select> <input class="form-control" type="text" name="keyword"> <input
					type="submit" class="btn btn-outline-primary" value="확인">
			</form>

			<!-- 검색목록 페이징 -->
			<nav aria-label="Page navigation example">
				<ul class="pagination justify-content-center">
					<li class="page-item"><c:if test="${not empty keyword}">
							<c:if test="${pp.startPage > pp.pagePerBlk }">

								<li class="page-item"><a class="page-link"
									href="freeList.do?pageNum=${pp.startPage - 1}&search=${search}&keyword=${keyword}"
									aria-label="Previous">이전 <span aria-hidden="true">&laquo;</span></a></li>
							</c:if>
							<c:forEach var="i" begin="${pp.startPage}" end="${pp.endPage}">
								<li class="page-item"><a class="page-link"
									href="freeList.do?pageNum=${i}&search=${search}&keyword=${keyword}">${i}</a></li>
							</c:forEach>
							<c:if test="${pp.endPage < pp.totalPage}">
								<li class="page-item"><a class="page-link"
									href="freeList.do?pageNum=${pp.endPage + 1}&search=${search}&keyword=${keyword}"
									aria-label="Next">다음 <span aria-hidden="true">&raquo;</span>
								</a></li>
							</c:if>
						</c:if> <!-- 전체목록 페이징 --> <c:if test="${empty keyword}">
							<c:if test="${pp.startPage > pp.pagePerBlk }">
								<li class="page-item"><a class="page-link"
									href="freeList.do?pageNum=${pp.startPage - 1}"
									aria-label="Previous">이전 <span aria-hidden="true">&laquo;</span></a></li>
							</c:if>
							<c:forEach var="i" begin="${pp.startPage}" end="${pp.endPage}">
								<li class="page-item"
									<c:if test="${pp.currentPage==i}">class="active"</c:if>><a
									class="page-link" href="freeList.do?pageNum=${i}">${i}</a></li>
							</c:forEach>
							<c:if test="${pp.endPage < pp.totalPage}">
								<a class="page-link"
									href="freeList.do?pageNum=${pp.endPage + 1}" aria-label="Next">다음
									<span aria-hidden="true">&raquo;</span>
								</a></li>
					</c:if>
					</c:if>
				</ul>
		</div>
		</ul>
		</nav>
		<div class="footerBox">
			<c:import url="../footer.jsp" />
		</div>
	</div>
</body>
</html>