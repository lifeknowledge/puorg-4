<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/javascript">
	//리뷰 쓰기
	$(function() {
		if(${boardInfo.operStateNo}==2){
		$('#collapseThree').scrollTop($('#collapseThree')[0].scrollHeight);
		}
		var myNo = $('#loginUserNo').val();
		if(${operation.operNo} != 0)
		{
		var receiveUserNo=${operation.requesterNo}; 
			if(myNo==receiveUserNo){
					receiveUserNo=${operation.operatorNo};
				}
		}
		/* $('#collapseThree').scrollTop($('#collapseThree')[0].scrollHeight); */
		$('#addreviewbutton').on("click",function() {
					console.log("click");
					var cmtcon=$("#reviewcontent").val();
					if ($('#reviewcontent').val().trim() == "") {
						alert("리뷰 내용을 입력해주세요.");
					} else {	
						$.ajax({
							url : "/picsion/comment/insertreview.ps",
							type : "post",
							data : {
								brdNo : ${boardInfo.brdNo},
								cmtContent : cmtcon
							},
							success : function(data) {
								console.log(data.addcomment);
								$("#reviewcontents").empty();
								  var media="";
							      $.each(data.commuserlist,function(index,element){
										media += "<div class='media'>"+
									    "<a class='float-left' href='#pablo'>"+
										"<div class='avatar'>";
										if(element.prPicture == null){
											 media += "<img class='media-object' alt='64x64' src='<%=request.getContextPath()%>/assets/img/user.png'>";
										}else{
											media += "<img class='media-object' alt='64x64' src='<%=request.getContextPath()%>"+element.prPicture+"'>";
										}
										media += "</div></a><div class='media-body'><h4 class='media-heading'>"+
											element.userName+"<small>· "+moment(data.comment[index].cmtReg).format('YYYY-MM-DD, H:mm:ss')+"</small>"+
										    "</h4><p>"+data.comment[index].cmtContent+"</p>"+
										    "<a href='#pablo' class='btn btn-primary btn-link float-right'"+
											"rel='tooltip' title='' data-original-title='보내버리기' id='" + data.comment[index].tableNo + ","+element.userNo+","+data.comment[index].brdNo+",0,"+data.comment[index].cmtNo+"' > <i "+
											"class='material-icons'>reply</i>신고</a></div></div>";
									})
									$("#reviewcontents").append(media); 									
							        $('#collapseThree').scrollTop($('#collapseThree')[0].scrollHeight);
							      	$("#reviewcontent").val("");
							      	if(${boardInfo.operStateNo}==2){
							      	var tableNo=4+":"+data.addcomment.cmtNo;
									send(receiveUserNo,tableNo);
							      	}
							     
							  }, 
							  error: function(){
							   	  alert("메시지 보내는 도중 오류가 발생했습니다.");
							  }
						});	
					}
				});
		
		
		$('.datetimepicker').datetimepicker({
		    icons: {
		        time: "fa fa-clock-o",
		        date: "fa fa-calendar",
		        up: "fa fa-chevron-up",
		        down: "fa fa-chevron-down",
		        previous: 'fa fa-chevron-left',
		        next: 'fa fa-chevron-right',
		        today: 'fa fa-screenshot',
		        clear: 'fa fa-trash',
		        close: 'fa fa-remove'
		    }
		});
		
		
		
		$('#apply').on("click",function() {
					
		console.log("apply클릭");
		
					$.ajax({
						url : "/picsion/operationApply/apply.ps",
						type : "post",
						data : {
							operApplyAppeal : $("#operApplyAppeal").val(),
							operApplyPrice : $("#operApplyPrice").val(),
							operApplyReg : $("#operApplyReg").val(),
							requestUserNo : ${boardInfo.userNo},
							brdNo : ${boardInfo.brdNo}
						},
						success : function(data) {}
					});	
				});
		

		$('#applysummit').on("click",function() {
			var brdNo=${boardInfo.brdNo};
			var requesterNo=${boardInfo.userNo};
					$.ajax({
						url : "/picsion/operation/operok.ps",
						type : "post",
						data : {	
							requesterNo : requesterNo,
							operPrice : $("#oApplyPrice").val(),
							operEndReg : Date($("#oApplyReg").val()),
							brdNo : brdNo,
							operatorNo : $("#oUserNo").val(),
							operApplyNo : $("#operApplyNo").val()
						}, 
						success : function(data) {
							console.log("test");
							console.log(data.check);
							location.href="/picsion/board/boardInfo.ps?brdNo="+brdNo;
						}
					});	
				});
		
		
		
		$('.applyModal').on("click",function() {
			var operApplyNo=$(this).attr("operApplyNo");
			var applyid=$(this).children()[0].innerText;
			console.log("applyid : "+applyid);
			var operApplyPrice=$(this).children()[1].innerText;
			console.log("operApplyPrice : "+operApplyPrice);
			var operApplyReg=$(this).children()[2].innerText;
			console.log("operApplyReg : "+operApplyReg);
			var operUserNo=$(this).attr("operUserNo");
			console.log("operUserNo : "+operUserNo);
			var operApplyAppeal=$(this).attr("operApplyAppeal");
			console.log("operApplyAppeal : "+operApplyAppeal);
			
			$('#oUserNo').val(operUserNo);
			$('#applyid').val(applyid);
			$('#oApplyPrice').val(operApplyPrice);
			$('#oApplyReg').val(operApplyReg);
			$('#oApplyAppeal').val(operApplyAppeal);
			$('#operApplyNo').val(operApplyNo);
		});
	});
</script>

<input type="hidden"
	value="${boardInfo.tableNo},${boardInfo.userNo},${boardInfo.brdNo},0"
	id="info">

<div class="page-header header-filter" data-parallax="true"
	style="background-image: url('<%=request.getContextPath()%>/assets/img/city-profile.jpg');"></div>
<div class="main main-raised">
	<div class="profile-content">	
		<div class="container">
			<div class="row" style="border-width: 1px; text-align: center;">
				<div class="col-md-12 ml-auto mr-auto">
					<h2 class="title">${boardInfo.brdTitle}</h2>
					<p>
						<font>${boardInfo.brdContent}</font>
					</p>
					<c:choose>
						<c:when	test="${boardInfo.userNo ne user.userNo && boardInfo.operStateNo ne 2}">
						<button type="button" class="btn btn-default btn-sm" style="float:right"
							data-toggle="modal" data-target="#exampleModal">신청하기</button>
						</c:when>
					</c:choose>
					<c:if test="${boardInfo.operStateNo eq 1}">
							<div class="col-md-12 col-sm-12">
										<h3 class="title">댓 	글</h3>
										<!-- <h3 class="main-price">$335</h3> -->
										<div id="accordion" role="tablist">

											<div class="card card-collapse">

												<div id="collapseThree" class="collapse show"
													role="tabpanel" aria-labelledby="headingThree"
													data-parent="#accordion"
													style="height: 250px; overflow-x: hidden; overflow-y: inherit;">
													<div class="card-body" id="reviewcontents">

														<c:forEach var="review1" items="${comment}"
															varStatus="status">

															<div class="media">
																<a class="float-left"
																	href="<%=request.getContextPath()%>/picture/mystudio.ps?userNo=${review1.userNo}">
																	<div class="avatar">
																		<img class="media-object" alt="Tim Picture"
																			src="<%=request.getContextPath()%>/${commentuser[status.index].prPicture}">
																	</div>
																</a>
																<div class="media-body">
																	<h4 class="media-heading">

																		${commentuser[status.index].userName} <small>·
																			<fmt:formatDate pattern="yyyy-MM-dd, HH:mm:ss"
																				value="${review1.cmtReg}" />
																		</small>

																	</h4>
																	<p>${review1.cmtContent}</p>
																	<a href="#pablo"
																		class="btn btn-primary btn-link float-right"
																		rel="tooltip" title="" data-original-title="보내버리기"
																		id="${review1.tableNo},${review1.userNo},${review1.brdNo},0,${review1.cmtNo}">
																		<i class="material-icons">reply</i> 신고
																	</a>
																</div>
															</div>

														</c:forEach>

													</div>
												</div>
											</div>
											<div class="card card-collapse">
												<div class="card-header" role="tab" id="headingTwo">
													<h5 class="mb-0">
														<a>Input Comment</a>
													</h5>
												</div>
												<div id="collapseTwo" class="collapse show" role="tabpanel"
													aria-labelledby="headingTwo" data-parent="#accordion"
													style="">
													<div class="media media-post">
														<a class="author float-left" href="#pablo">
															<div class="avatar">
																<img class="media-object" alt="64x64"
																	src="<%=request.getContextPath()%>/${sessionScope.user.prPicture}">
															</div>
														</a>
														<div class="media-body">
															<div class="form-group label-floating bmd-form-group">
																<label class="form-control-label bmd-label-floating"
																	for="exampleBlogPost"> 댓글을 달아보세요...</label>
																<textarea class="form-control" rows="5"
																	id="reviewcontent"></textarea>
															</div>
															<div class="media-footer">
																<a href="#pablo"
																	class="btn btn-primary btn-round btn-wd float-right"
																	id="addreviewbutton">Post Comment</a>
																<button class="btn btn-primary btn-sm"
																	data-toggle="modal" data-target="#reportModal">신고</button>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>

									</div>
							
						</c:if>
				</div>
			</div>
			<c:choose>
				<c:when test="${boardInfo.operStateNo eq 2}">
					<div class="section section-comments">
						<div class="row">
							<div class="col-md-12 ml-auto mr-auto">

								<div class="row">
									<div class="col-md-6 col-sm-6">
										<h3 class="title" style="text-align: center">작업 정보</h3>
										<div class="card card-collapse">
											<div class="card-header" role="tab" id="headingTwo">
												<h5 class="mb-0">
													<a>요청자</a>
												</h5>
											</div>
											<div id="collapseTwo" class="collapse show" role="tabpanel"
												aria-labelledby="headingTwo" data-parent="#accordion"
												style="">
												<div class="card-body">${requestUser.userName}</div>
											</div>
										</div>
										<div class="card card-collapse">
											<div class="card-header" role="tab" id="headingTwo">
												<h5 class="mb-0">
													<a>작업자</a>
												</h5>
											</div>
											<div id="collapseTwo" class="collapse show" role="tabpanel"
												aria-labelledby="headingTwo" data-parent="#accordion"
												style="">
												<div class="card-body">${operatorUser.userName}</div>
											</div>
										</div>
										<div class="card card-collapse">
											<div class="card-header" role="tab" id="headingTwo">
												<h5 class="mb-0">
													<a>거래금액</a>
												</h5>
											</div>
											<div id="collapseTwo" class="collapse show" role="tabpanel"
												aria-labelledby="headingTwo" data-parent="#accordion"
												style="">
												<div class="card-body">${boardInfo.brdExpectPrice}</div>
											</div>
										</div>
										<div class="card card-collapse">
											<div class="card-header" role="tab" id="headingTwo">
												<h5 class="mb-0">
													<a>작업완료날짜</a>
												</h5>
											</div>
											<div id="collapseTwo" class="collapse show" role="tabpanel"
												aria-labelledby="headingTwo" data-parent="#accordion"
												style="">
												<div class="card-body">${boardInfo.brdExpectEndDate}</div>
											</div>
										</div>
										<div class="card card-collapse">
											<div class="card-header" role="tab" id="headingTwo">
												<h5 class="mb-0">
													<a>저작권 양도여부</a>
												</h5>
											</div>
											<div id="collapseTwo" class="collapse show" role="tabpanel"
												aria-labelledby="headingTwo" data-parent="#accordion"
												style="">
												<div class="card-body">${boardInfo.copyright}</div>
											</div>
										</div>
									</div>

									<div class="col-md-6 col-sm-6">
										<h3 class="title">작업 메시지함</h3>
										<!-- <h3 class="main-price">$335</h3> -->
										<div id="accordion" role="tablist">

											<div class="card card-collapse">

												<div id="collapseThree" class="collapse show"
													role="tabpanel" aria-labelledby="headingThree"
													data-parent="#accordion"
													style="height: 250px; overflow-x: hidden; overflow-y: inherit;">
													<div class="card-body" id="reviewcontents">

														<c:forEach var="review1" items="${comment}"
															varStatus="status">

															<div class="media">
																<a class="float-left"
																	href="<%=request.getContextPath()%>/picture/mystudio.ps?userNo=${review1.userNo}">
																	<div class="avatar">
																		<img class="media-object" alt="Tim Picture"
																			src="<%=request.getContextPath()%>/${commentuser[status.index].prPicture}">
																	</div>
																</a>
																<div class="media-body">
																	<h4 class="media-heading">

																		${commentuser[status.index].userName} <small>·
																			<fmt:formatDate pattern="yyyy-MM-dd, HH:mm:ss"
																				value="${review1.cmtReg}" />
																		</small>

																	</h4>
																	<p>${review1.cmtContent}</p>
																	<a href="#pablo"
																		class="btn btn-primary btn-link float-right"
																		rel="tooltip" title="" data-original-title="보내버리기"
																		id="${review1.tableNo},${review1.userNo},${review1.brdNo},0,${review1.cmtNo}">
																		<i class="material-icons">reply</i> 신고
																	</a>
																</div>
															</div>

														</c:forEach>

													</div>
												</div>
											</div>
											<div class="card card-collapse">
												<div class="card-header" role="tab" id="headingTwo">
													<h5 class="mb-0">
														<a>Input Comment</a>
													</h5>
												</div>
												<div id="collapseTwo" class="collapse show" role="tabpanel"
													aria-labelledby="headingTwo" data-parent="#accordion"
													style="">
													<div class="media media-post">
														<a class="author float-left" href="#pablo">
															<div class="avatar">
																<img class="media-object" alt="64x64"
																	src="<%=request.getContextPath()%>/${sessionScope.user.prPicture}">
															</div>
														</a>
														<div class="media-body">
															<div class="form-group label-floating bmd-form-group">
																<label class="form-control-label bmd-label-floating"
																	for="exampleBlogPost"> 댓글을 달아보세요...</label>
																<textarea class="form-control" rows="5"
																	id="reviewcontent"></textarea>
															</div>
															<div class="media-footer">
																<a href="#pablo"
																	class="btn btn-primary btn-round btn-wd float-right"
																	id="addreviewbutton">Post Comment</a>
																<button class="btn btn-primary btn-sm"
																	data-toggle="modal" data-target="#reportModal">신고</button>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>

									</div>
								</div>
							</div>
						</div>
					</div>
				</c:when>
			</c:choose>

			<c:choose>
				<c:when
					test="${boardInfo.userNo eq user.userNo && boardInfo.operStateNo ne 2}">
					<table class="table">
						<thead>
							<tr>
								<th class="text-center">작업신청자</th>
								<th class="text-center">금액</th>
								<th class="text-center">마감 날짜</th>
							</tr>
						</thead>
						<tbody>

							<c:choose>
								<c:when test="${empty applylist}">
									<tr>
										<td colspan="3" style="text-align: center;">신청자가 없습니다.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<div class="apply">
										<c:forEach var="apply" items="${applylist}" varStatus="status">
											<tr class="applyModal" style="cursor: pointer;"
												data-toggle="modal" data-target="#operModal"
												operApplyNo="${apply.operApplyNo}"
												operUserNo="${apply.operUserNo}"
												operApplyAppeal="${apply.operApplyAppeal}">
												<td class="text-center">${applyid[status.index]}</td>
												<td class="text-center">${apply.operApplyPrice}</td>
												<td class="text-center">${apply.operApplyReg}</td>
											</tr>
										</c:forEach>
									</div>
								</c:otherwise>
							</c:choose>

						</tbody>

					</table>
				</c:when>				
			</c:choose>
		</div>
	</div>
	<c:if test="${boardInfo.operStateNo eq 2 && user.userNo eq operation.operatorNo}">
	<div id="upload">
		<div class="card card-collapse">
			<div class="card-header" role="tab" id="picupload1">
				<h5 class="mb-0 title">
					<a class="collapsed" data-toggle="collapse" href="#picupload" style="text-align: center;"
						aria-expanded="false" aria-controls="picupload">사진 업로드</a>
				</h5>
			</div>
			<div id="picupload" class="collapse" role="tabpanel"
				aria-labelledby="picupload1" data-parent="#upload">
				<div class="card-body">
					<div class="row">
						<div class="col-md-6">
							<form id="fileForm" action="amazontest.ps"
								enctype="multipart/form-data" method="post">

								<div class="fileinput fileinput-new text-center"
									data-provides="fileinput">
									<div class="fileinput-new thumbnail img-raised">
										<img
											src="https://epicattorneymarketing.com/wp-content/uploads/2016/07/Headshot-Placeholder-1.png"
											alt="...">
									</div>
									<div
										class="fileinput-preview fileinput-exists thumbnail img-raised"></div>
									<div>
										<span class="btn btn-raised btn-round btn-default btn-file">
											<span class="fileinput-new">Select image</span> <span
											class="fileinput-exists">Change</span> <input type="file"
											name="filePath" accept=".jpg, .png, .bmp" />
										</span> <a href="#pablo"
											class="btn btn-danger btn-round fileinput-exists"
											data-dismiss="fileinput"> <i class="fa fa-times"></i>
											Remove
										</a>
									</div>
								</div>
								<!-- <input type="submit" class="btn btn-primary btn-round" value="보내기"> -->
							</form>
						</div>

						<div class="col-md-6">
							<form
								action="<%=request.getContextPath()%>/picture/uploadAfter.ps">

								<div class="form-group">
									<label for="title">제목</label> <input type="text"
										class="form-control" id="pictureTitle" name="picTitle">
								</div>

								<div class="form-group">
									<label for="description">설명</label> <input type="text"
										class="form-control" id="pictureDesc" name="picContent">
								</div>

								<!-- <form action=""> -->
								<div id="picTags" class="form-group">
									<label for="comment">Tags</label> <br>
									<div id="loaderIcon"></div>
								</div>
								<!-- </form> -->
								<%--	<div class="form-group">
							<input type="text" name="picPath" value="${picPath}"> 
						</div> --%>
								<div id="tagA"></div>
								<button type="submit" class="btn btn-primary">저장하기</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</c:if>
</div>
<!-- 신청Modal -->
<div class="modal fade" id="exampleModal" tabindex="1" role="dialog"
	aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">참여신청 페이지</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>

			<div class="modal-body">
				<div class="form-group">
					<label for="exampleInput1" class="bmd-label-floating">판매금액</label>
					<input type="text" class="form-control" id="operApplyPrice"
						name="operApplyPrice">
				</div>
				<div class="form-group">
					<label class="label-control">희망 완료 날짜</label> <input type="text"
						class="form-control datetimepicker" id="operApplyReg"
						name="operApplyReg" />
				</div>
				<div class="form-group">
					<label for="exampleFormControlTextarea1">간단한 소개글</label>
					<textarea class="form-control" id="operApplyAppeal"
						name="operApplyAppeal" rows="3"></textarea>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="apply"
					data-dismiss="modal">신청</button>
				<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
			</div>

		</div>
	</div>
</div>

<!-- 신청자 상세  Modal Core -->
<div class="modal fade" id="operModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="myModalLabel">신청자 상제보기</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
			</div>
			<div class="modal-body">

				<form>
					<fieldset disabled>
						<input type="text" style="display: none;" id="oUserNo"
							name="operUserNo" class="form-control"> <input
							type="text" style="display: none;" id="operApplyNo"
							name="operApplyNo" class="form-control">
						<div class="form-group">
							<label for="disabledTextInput">신청자</label> <input type="text"
								id="applyid" class="form-control">
						</div>
						<div class="form-group">
							<label for="disabledTextInput">판매가격</label> <input type="text"
								id="oApplyPrice" name="operApplyPrice" class="form-control">
						</div>
						<div class="form-group">
							<label for="disabledTextInput">완료 예정일</label> <input type="text"
								id="oApplyReg" name="operApplyReg" class="form-control">
						</div>
						<div class="form-group">
							<label for="disabledTextInput">참고사항</label> <input type="text"
								id="oApplyAppeal" name="operApplyAppeal" class="form-control">
						</div>

					</fieldset>
					<button type="button" class="btn btn-primary" id="applysummit"
						data-dismiss="modal">수락</button>
				</form>

			</div>

		</div>
	</div>
</div>

<script>
	$(function() {
		$('input[type=file]').change(function() {
			var formData = new FormData($('#fileForm')[0])
			console.log("클릭가능????")
			console.log(formData)
			$.ajax({
				url : "/picsion/amazontest.ps",
				data : formData,
				processData: false,
				contentType: false,
				type :'POST',
				success : function(data){
					console.log(data)
					$("#loaderIcon").empty();
					if(data.logo != null){
					var logo =''
						logo += '<div class="alert alert-warning">'
						logo += 	'<div class="container-fluid">'
						logo += 		'<div class="alert-icon">'
						logo += 			'<i class="material-icons">warning</i>'
						logo += 		'</div>'
						logo += 		'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
						logo += 			'<span aria-hidden="true"><i class="material-icons">clear</i></span>'
						logo += 		'</button>'
						logo += 		'<b>Warning Alert</b>' + data.logo
						logo += 	'</div>'
						logo += '</div>'
						
						$('h1').after(logo)
					}
 					/*얼굴감지*/
					var ctx = ''
					var ctx = document.getElementByName('filePath').getContext('2d');
						if(data.face != null){
							ctx.strokeStyle="#FF0000";
							
							ctx.strokeRect(data.face["0"].x_0,data.face["0"].y_1,data.face["0"].width,data.face["0"].height);
							
						}
					
					var safe = ''
					if(data.safe != null){
						safe += '<div class="alert alert-danger">'
						safe += 	'<div class="container-fluid">'
						safe += 		'<div class="alert-icon">'
						safe += 			'<i class="material-icons">warning</i>'
						safe += 		'</div>'
						safe += 		'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
						safe += 			'<span aria-hidden="true"><i class="material-icons">clear</i></span>'
						safe += 		'</button>'
						safe += 		'<b>Warning Alert</b>' + data.safe
						safe += 	'</div>'
						safe += '</div>'
						$('h1').after(safe)
					}
					
					var tags = ''
					$.each(data.label, function(i, elt) {
						tags += '<input type="text" value="' + elt + '" data-role="tagsinput" name="tag">'
					})
					
					$('#picTags').append(tags)
					
					tags ='<br><br>태그추가: <input type="text" id="tagAddName">';
					tags +='<button type="button" class="btn btn-primary" id="tagAdd">추가</button><br>';
					tags += '<input type="text" name="picPath" value="' + data.picPath + '">';
					$('#tagA').append(tags)
					/* $('#taginputtest').attr("data-role","tagsinput"); */
					console.log('와요?')
					$("input[data-role=tagsinput]").tagsinput();
				}
			,beforeSend:function(){
				$("#loaderIcon").html("<img src='<%=request.getContextPath()%>/assets/img/LoaderIcon.gif'/>");
			}
				
			})
		})
	})
</script>