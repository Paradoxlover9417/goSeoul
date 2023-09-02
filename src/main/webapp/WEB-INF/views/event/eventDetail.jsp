<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

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

<title>행사 상세내용</title>

<style>
/* 
#title, #thumb #overview, #website, #contact, #address{
	position:static;
	pading:100px; 
}
 */
* {
	font-family: 'Title_Medium';
	text-align: justify;
}

.wrap1 {
	margin: 0 auto;
	max-width: 800px;
}

img {
	margin: 0 auto;
	max-width: 350px;
	height: auto;
}

#title {
	font-size: 34px;
	font-weight: bold;
	position: static;
	text-align: center;
	margin: 0 auto;
	bottom: 20px;
}

#overview {
	white-space: pre-line;
}

#thumb {
	text-align: center;
	margin: 0 auto;
	width: 100%;
}

#map {
	position: static;
	top: 10px;
	margin: 0 auto;
	width: 100%;
}
</style>
<script type="text/javascript"
	src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=8968d8e89aaef36c89ab8e913a241a26"></script>
</head>
<body>
	<div class="wrap">
		<c:import url="../header.jsp" />
		<br>
		<div class="wrap1">
			<div class="inner container-fluid">
				<div id="title"></div>
				<br>
				<div id="thumb"></div>
				<br>
				<div id="overview"></div>
				<br>
				<div id="eventdate"></div>
				<br>
				<div id="website"></div>
				<br>
				<div id="contact"></div>
				<br>
				<div id="playtime"></div>
				<br>
				<div id="usetimefestival"></div>
				<br>
				<div id="map" style="max-width: 1140px; width: 100%; height: 400px;"></div>
				<div style="max-width: 600px; justify-items: center;">
					<br>
					<div id="address"></div>
					<div id="eventplace"></div>
					<br>
				</div>
			</div>
		</div>
		<script>
			function getParam(sname) {
				//파라미터 부분 자르기
				var params = location.search.substr(location.search.indexOf("?") + 1);
				//초기화
				var sval = "";
				params = params.split("&");
				for (var i = 0; i < params.length; i++) {
					temp = params[i].split("=");
					if ([ temp[0] ] == sname) {
						sval = temp[1];
					}
				}
				return sval;
			}
			// 파라미터 값 확인을 위한 실행
			getParam("contentId");

			// contentId에 파라미터에서 던진 컨텐츠 아이디 저장, 예) 2828431
			var contentId = temp[1];

			// 테스트 파라미터 포함 값은 > test.html?contentId=2828431

			$(document).ready(function() {
				$.ajax({
					/* URL에 API에서 가져온 주소값 입력 */
					url : "https://apis.data.go.kr/B551011/KorService1/detailCommon1?MobileOS=ETC&MobileApp=GoSeoul&_type=json&contentId="
						+ contentId
						+ "&contentTypeId=15&defaultYN=Y&firstImageYN=Y&areacodeYN=Y&catcodeYN=Y&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y
						&numOfRows=20&pageNo=1&serviceKey=9u1LYAg7hOW1YTn138et7L7Q8Qcks2RZvreM6YC011a5iHJrju%2BbgL%2FSP8uU1FE0d3k0K3fqzUuvSEWUu8xndg%3D%3D",
					method : 'GET',
					async : false,
					dataType : "json",
					success : function(data) {
						console.log(data);
						console.log(contentId);
						let detail = data.response.body.items.item;
						var mapx = 0;
						var mapy = 0;
						for (let i = 0; i < detail.length; i++) {
							let dt = detail[i];
							$("#title").text(dt.title);
							$("<img>").attr("src",
									dt.firstimage)
									.appendTo("#thumb");
							$("#overview").html(
									dt.overview);
							//  받아온 dt.homepage값에서 순수 url만 추출하는 코드
							const text = dt.homepage;
							const urlPattern = /https?:\/\/[^\s"'<>]+/g;
							const urls = text
									.match(urlPattern)[0];
							console.log(urls);

							$("#website")
									.html(
											"<b>웹사이트:  </b><br><a href='" + urls + "'>바로가기</a>");
							$("#contact")
									.html(
											"<b>문의처:  </b><br>"
													+ dt.telname
													+ " "
													+ dt.tel);
							$("#address")
									.html(
											"<b>주소:  </b>"
													+ $(
															"<span>")
															.text(
																	dt.addr1)
															.html());
							mapx = dt.mapx;
							mapy = dt.mapy;

						}
						console.log(mapx);
						console.log(mapy);
						var container = document
								.getElementById('map');
						var options = {
							center : new kakao.maps.LatLng(
									mapy, mapx),
							level : 3
						};

						var map = new kakao.maps.Map(
								container, options);
						map
								.addOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC);
						var markerPosition = new kakao.maps.LatLng(
								mapy, mapx);

						var marker = new kakao.maps.Marker(
								{
									position : markerPosition
								});

						// 마커가 지도 위에 표시되도록 설정합니다
						marker.setMap(map);
					}
				});

				$
										.ajax({
											/* URL에 API에서 가져온 주소값 입력 */
											url : "https://apis.data.go.kr/B551011/KorService1/detailIntro1?MobileOS=etc&MobileApp=goSeoul&_type=json&contentId="
													+ contentId
													+ "&contentTypeId=15&numOfRows=200&pageNo=1&serviceKey=9u1LYAg7hOW1YTn138et7L7Q8Qcks2RZvreM6YC011a5iHJrju%2BbgL%2FSP8uU1FE0d3k0K3fqzUuvSEWUu8xndg%3D%3D",
											method : 'GET',
											async : false,
											dataType : "json",
											success : function(data2) {
												console.log(data2);
												let detail2 = data2.response.body.items.item;
												for (let i = 0; i < detail2.length; i++) {
													let dt2 = detail2[i];
													startDate = dt2.eventstartdate
															.replace(
																	/(\d{4})(\d{2})(\d{2})/g,
																	'$1. $2. $3');
													endDate = dt2.eventenddate
															.replace(
																	/(\d{4})(\d{2})(\d{2})/g,
																	'$1. $2. $3');
													$("#eventdate").html(
															"<b>행사 기간:  </b><br>"
																	+ startDate
																	+ " ~ "
																	+ endDate);
													$("#eventplace")
															.html(
																	"<b>행사장 정보:  </b>"
																			+ $(
																					"<span>")
																					.text(
																							dt2.eventplace)
																					.html());
													$("#playtime")
															.html(
																	"<b>이용 시간: </b><br>"
																			+ dt2.playtime);
													$("#usetimefestival")
															.html(
																	"<b>입장료: </b><br>"
																			+ dt2.usetimefestival);

													/* 
													agelimit              ""
													bookingplace              ""
													contentid              "2381938"
													contenttypeid              "15"
													discountinfofestival              ""
													eventenddate              "20231203"
													eventhomepage              ""
													eventplace              "코엑스 B홀, COEX HALL B"
													eventstartdate              "20231130"
													festivalgrade              ""
													placeinfo              ""
													playtime              "11:00 - 18:00"
													program              ""
													spendtimefestival              ""
													sponsor1              "㈜한국국제전시"
													sponsor1tel              "02-761-2512"
													sponsor2              ""
													sponsor2tel              ""
													subevent              ""
													usetimefestival	"현장구매 시 10,000원<br>1차 사전등록(~10/16) 시 7,000원<br>2차 사전등록(10/17~11/29) 시 8,000원<br>*사전등록 : 홈페이지 - 관람안내에서 가능"
													 */
												}

											}

										});
							});
		</script>
		<div class="footerBox">
			<c:import url="../footer.jsp" />
		</div>
	</div>
</body>
</html>
