<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>서울시 행사</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- 글꼴 -->
<link rel="stylesheet" href="./css/font.css">

<!-- 부트스트랩 -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"></script>

<!-- 날씨 -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="./js/weather.js"></script>

<style>
* {
	font-family: 'Title_Medium';
}

.container {
	display: flex;
	flex-wrap: wrap;
	justify-content: left;
	align-items: left;
	height: 100vh;
}

.menu {
	display: flex;
	flex-direction: column;
	align-items: left;
	text-shadow: gray 0.1em 0.1em 0.1em;
	width: 100%;
	max-width: 1400px;
	margin: 0 auto;
}

.card-container {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
	gap: 20px;
	margin-top: 50px;
	row-gap: 20px;
}

.card {
	display: flex;
	flex-direction: column;
	justify-content: flex-end;
	max-width: 350px;
	width: 100%;
	height: 400px;
	border-radius: 10px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
	overflow: hidden;
	background-size: cover;
	position: relative;
}

.card h2, .card p {
	padding: 5px;
	margin: 0;
	color: white;
	background-color: rgba(0, 0, 0, 0.3);
	font-size: 14px;
}

button {
	font-family: 'Title_Medium';
}
</style>

</head>
<body>
	<c:import url="../header.jsp" />
	<br>
	<div align="center">
		<h1 style="font-size: 40px; position: static; margin: 10px;"
			class="text">서울시 행사 리스트</h1>
		<br> <br>

		<!-- 검색창 -->
		<div class="search-container">
			<label style="position: static; margin: 10px;" for="searchInput">행사명
				검색</label> <input id="searchInput" type="text" placeholder="Search...">
		</div>
		<!-- 필터링 버튼 -->
		<button id="whole" type="button" class="btn btn-outline-primary">전체
			행사</button>
		<button id="past" type="button" class="btn btn-outline-secondary">지난
			행사</button>
		<button id="current" type="button" class="btn btn-outline-primary">진행
			행사</button>
		<button id="future" type="button" class="btn btn-outline-secondary">예정
			행사</button>
	</div>

	<div class="container-fluid">
		<div class="menu">

			<div class="card-container"></div>
			<div class="d-flex justify-content-center">
				<nav aria-label="Page navigation example">
					<ul class="pagination"></ul>
					<c:forEach var="pageNumber" begin="1" end="${totalPage}">
						<li class="page-item"><a href="#" class="page-link">${pageNumber}</a>
						</li>
					</c:forEach>
				</nav>
			</div>
		</div>
	</div>

	<script>
		$
				.ajax({
					// API 주소 입력 
					url : "https://apis.data.go.kr/B551011/KorService1/searchFestival1?numOfRows=200&pageNo=1&MobileOS=ETC&MobileApp=GoSeoul&_type=json&listYN=Y&arrange=A&eventStartDate=20230501&areaCode=1&serviceKey=9u1LYAg7hOW1YTn138et7L7Q8Qcks2RZvreM6YC011a5iHJrju%2BbgL%2FSP8uU1FE0d3k0K3fqzUuvSEWUu8xndg%3D%3D",
					dataType : "json",
					success : function(result) {
						let events = result.response.body.items.item;
						events.sort(function(a, b) {
							return b.eventstartdate.localeCompare(a.eventstartdate);
						});
						let cardContainer = $(".card-container");
						let today = new Date();
						let pastEvents = [];
						let currentEvents = [];
						let futureEvents = [];

						// 반복문으로 받아온 값 꺼내오기
						for (let i = 0; i < events.length; i++) {
							let event = events[i];
							let card = $("<div>").addClass("card");
							let title = $("<h2>").text(event.title);
							let place = $("<p>").text(event.addr1);
							let startDate = new Date(event.eventstartdate.slice(0, 4), event.eventstartdate.slice(4, 6) - 1, event.eventstartdate.slice(6, 8));
							let endDate = new Date(event.eventenddate.slice(0, 4), event.eventenddate.slice(4, 6) - 1, event.eventenddate.slice(6, 8));
							let date = $("<p>").text(startDate.toLocaleDateString("ko-KR") + " ~ " + endDate.toLocaleDateString("ko-KR"));

							// 필터링 조건 설정
							if (endDate < today) {
								card.addClass("past");
								pastEvents.push(event);
							} else if (startDate <= today && today <= endDate) {
								card.addClass("current");
								currentEvents.push(event);
							} else {
								card.addClass("future");
								futureEvents.push(event);
							}
							// 이미지가 없을 경우 기본로고 표시
							card.append(title).append(place).append(date);
							if (event.firstimage !== "") {
								card.css("background-image", "url("+ event.firstimage + ")");
							} else {
								card.css("background-image", "url(./images/GoSeoul_Logo.jpg)");
							}
							//          cardRow = $("<div>").addClass("card-row");
							//          cardContainer.append(cardRow);
							//          cardRow.append(card);
							cardContainer.append(card);

							card.click(function() {
								window.location.href = "eventDetail.do?contentId=" + event.contentid;
							});
						}
						let totalCards = events.length;
						let totalPage = Math.ceil(totalCards / 12);
						console.log("카드의 총 개수: " + totalCards);
						console.log("페이지 수: " + totalPage);

					}
				});

		// 검색 기능
		$("#searchInput").on(
				"keyup",
				function() {
					let value = $(this).val().toLowerCase();
					$(".card").filter(
							function() {
								$(this).toggle(
										$(this).text().toLowerCase().indexOf(
												value) > -1);
							});
				});

		// 필터링 기능
		$(document).ready(function() {
			$("#whole").click(function() {
				$(".card").show();
			});

			$("#past").click(function() {
				$(".card:not(.past)").hide();
				$(".past").show();
			});

			$("#current").click(function() {
				$(".card:not(.current)").hide();
				$(".current").show();
			});

			$("#future").click(function() {
				$(".card:not(.future)").hide();
				$(".future").show();
			});
		});
	</script>

	<c:set var="cardsPerPage" value="8" />
	<c:set var="totalCards" value="${events.size()}" />
	<c:set var="totalPages"
		value="${(totalCards + cardsPerPage - 1) / cardsPerPage}" />

	<div class="pagination">
		<c:forEach var="page" begin="1" end="${totalPages}">
			<c:choose>
				<c:when test="${page == currentPage}">
					<span class="page active">${page}</span>
				</c:when>
				<c:otherwise>
					<a href="#" class="page">${page}</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</div>

	<c:import url="../footer.jsp" />
</body>
</html>
