<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<script type="text/javascript">
$(function() {
	/* baguetteBox.run('.tz-gallery'); */
	var loginUserNo = $('#loginUserNo').val();

	
	$(document).on('click','#like',function(){
		if(loginUserNo == 0){
		}else{
			var data = {userNo : loginUserNo,
				    picNo : $(this).attr("value")};
			var respect =  $(this);
			var rpa = $(this).parent();
			 $.ajax({
				url : "<%=request.getContextPath()%>/picture/increaserespect.ps",
				data : data,
				success : function(data){
					if(data.result==1){
						  $(respect)[0].innerHTML = 'favorite_border';
						  $(rpa)[0].childNodes[1].nodeValue--;
					  }else{
						  $(respect)[0].innerHTML = 'favorite';
						  $(rpa)[0].childNodes[1].nodeValue++;
					  }
				}
			 }) 
		}
	})
	
	$(document).on('click','#down',function(){
		if(loginUserNo == 0){
		}else{
			var data = {userNo : loginUserNo,
				    picNo : $(this).attr("value")};
			var bookmark = $(this);
			var bpa = $(this).parent();
			 $.ajax({
				url : "<%=request.getContextPath()%>/picture/increasebookmark.ps",
				data : data,
				success : function(data){
					if(data.result==1){
						  $(bookmark)[0].innerHTML = 'bookmark_border';
						  $(bpa)[0].childNodes[1].nodeValue--;
					  }else{
						  $(bookmark)[0].innerHTML = 'bookmark';
						  $(bpa)[0].childNodes[1].nodeValue++;
					  }
				}
			 }) 
		}
	})
	
})
</script>

<style type="text/css">
.img-size {
	height: 300px;
	width: 100%;
} 
</style>

<div class="page-header header-filter" data-parallax="true"
	style="background-image: url('<%=request.getContextPath()%>/assets/img/city-profile.jpg');">
</div>
<div class="main main-raised">
	<div class="profile-content">

		<div class="container-fluid">
			<div class="flex_grid credits">
			<div class="tz-gallery">
				<div class="row">
				<c:forEach items="${imagelistall}" var="followinglistall" varStatus="status">					
						  <div class="item col-sm-6 col-md-4"> 
			                    <a href="<%=request.getContextPath()%>/picture/picinfo.ps?picNo=${followinglistall.picNo}">
			                        <img class="rounded img-size" src="<%=request.getContextPath()%>/${followinglistall.picPath}"alt="No Image">
			                    </a>
			                    <div>
			                    <div class="counts hide-xs hide-sm ">
			                    <c:choose>
									<c:when test="${followinglistall.respectCheck eq 'T'}">
										<em><i id="like" value="${followinglistall.picNo}" class="material-icons">favorite</i>${followinglistall.respectCount}</em>
									</c:when>
									<c:otherwise>
										<em><i id="like" value="${followinglistall.picNo}" class="material-icons">favorite_border</i>${followinglistall.respectCount}</em>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${followinglistall.bookmarkCheck eq 'T'}">
										<em><i id="down" value="${followinglistall.picNo}" class="material-icons">bookmark</i>${followinglistall.bookmarkCount}</em>
									</c:when>
									<c:otherwise>
										<em><i id="down" value="${followinglistall.picNo}" class="material-icons">bookmark_border</i>${followinglistall.bookmarkCount}</em>
									</c:otherwise>
								</c:choose>
			                    </div>
			                    <a href="<%=request.getContextPath()%>/picture/mystudio.ps?userNo=${ownlist[status.index].userNo}">${ownlist[status.index].userName}</a>
               				</div>
			            </div>
						
					</c:forEach>
				</div>
			</div>
		</div>
		</div>
	</div>
</div>
