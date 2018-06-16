<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javascript">
	//리뷰 쓰기
	$(function() {
		$('#addreviewbutton').on(
				"click",
				function() {
					
					console.log("click");
					if ($('#reviewcontent').val().trim() == "") {
						alert("리뷰 내용을 입력해주세요.");
					} else {	

						$.ajax({
							url : "insertreview.ps",
							type : "post",
							data : {
								brdNo : ${boardInfo.brdNo},
								cmtContent : $("#reviewcontent").val()
							},
							success : function(data) {
								var html="";
								
								$.each(data.comment,function(index,obj){
									
									html+=data.commuserid[index]+" : "+obj.cmtContent+"<br>";
									html+="<hr style='margin-top: 5px; margin-bottom: 5px;'>";
								}); 
								
								console.log(html);
								$(".review").empty();
								$(".review").append(html); 
								
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
						url : "apply.ps",
						type : "post",
						data : {
							
							operApplyAppeal : $("#operApplyAppeal").val(),
							operApplyPrice : $("#operApplyPrice").val(),
							operApplyReg : $("#operApplyReg").val(),
							requestUserNo : ${boardInfo.userNo},
							brdNo : ${boardInfo.brdNo}
						},
						success : function(data) {
							
							
						}
					});	
				});
		
		
		
		
		/* $('#applylist').on("click",function() {
			
			console.log("applylist클릭");
			
						$.ajax({
							url : "applylist.ps",
							type : "post",
							data : {						
								requestUserNo : ${boardInfo.userNo},
								brdNo : ${boardInfo.brdNo}
							},
							success : function(data) {
								console.log(data);
								$.each(data.applylist,function(index,obj){
									
								}); 
								
							}
						});	
						
						
						
					}); */
		
		
		
		
		
		
	});
</script>



<div class="page-header header-filter" data-parallax="true"
	style="background-image: url('<%=request.getContextPath()%>/assets/img/city-profile.jpg');"></div>
<div class="main main-raised">
	<div class="profile-content">
		<div class="container">
			<div class="row" style="border-width: 1px">
				<div class="col-md-12 ml-auto mr-auto">
					<h3>${boardInfo.brdTitle}</h3>
					<p>
						<font>${boardInfo.brdContent}</font>
					</p>





				</div>
			</div>

		</div>

	</div>


	<div id="reviews" style="text-align: center;">
		<h4 style="margin-bottom: 20px;">
			<b>리뷰</b>
		</h4>
		<hr style="margin-top: 5px; margin-bottom: 5px;">
		<div class="review">
			<c:forEach var="review" items="${comment}" varStatus="status">
				

					${commuserid[status.index]} : ${review.cmtContent} 
					
					<hr style="margin-top: 5px; margin-bottom: 5px;">

			</c:forEach>
		</div>
		<textarea rows="2" maxlength="45" placeholder="리뷰를 입력해주세요(최대 45자)"
			id="reviewcontent"></textarea>
		<button id="addreviewbutton" class="btn">
			<font><b>리뷰 쓰기</b></font>
		</button>
	</div>


<table class="table">
    <thead>
     <tr>
            <th class="text-center">#</th>
            <th class="text-center">작업신청자</th>
            <th class="text-center">작업기간</th>
            <th class="text-center">금액</th>
        </tr>
    </thead>
    <tbody>


<c:choose>
	<c:when test="${boardInfo.userNo eq user.userNo}">			
			<div class="apply">
			<c:forEach var="apply" items="${applylist}" varStatus="status">
				

					${applyid[status.index]} : ${apply.operApplyAppeal} 
					${apply.operApplyPrice}
					${apply.operApplyReg}
					${apply.operUserNo}
					<input type="button" value="수락" operUserNo="${apply.operUserNo}" >
					
					<hr style="margin-top: 5px; margin-bottom: 5px;">

			</c:forEach>
		</div>
	</c:when>
	<c:otherwise>
		<button type="button" class="btn btn-default btn-sm"
			data-toggle="modal" data-target="#exampleModal">신청하기</button>		
	</c:otherwise>
</c:choose>
	
</tbody>
</table>



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



