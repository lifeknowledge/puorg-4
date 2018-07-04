<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


  	<script type="text/javascript">
		  //top으로ws
		  	
			$(function() {

				if($('#loginUserNo').val()!= ""){
					connect() 
				}
				
				//신고하기/////////////////////////////////////////////////////////////////
				$('#blaSend').click(function(){
					var info = $('#info').val().split(',')
					var blaContent = $('#blaContent').val()
					var data = 	{
									blaContent : blaContent,
									tableNo : info[0],
									userNo : info[1],
									brdNo : info[2],
									picNo : info[3]
								}
					blameController(data)
				})
				
				$(document).on('click','a[data-original-title=보내버리기]',function(){
					var info = (this.id).split(',')
					var content = this.parentNode.children[1].innerHTML
					var data = {
									tableNo : info[0],
									userNo : info[1],
									brdNo : info[2],
									picNo : info[3],
									cmtNo : info[4],
									blaContent : content
								}
					blameController(data)
				})
			});
			
		  	function blameController(data) {
			  $.ajax({
					url : "/picsion/blame/complainInsert.ps",
					data : data,
					success : function(data){
						alert('신고 되었습니다')
					}
				})
			}
			//신고하기/////////////////////////////////////////////////////////////////
		  
		  	//////WEB SOCKET/////
		  	var wsocket
		  
			function connect(){
			 	/* wsocket = new WebSocket("ws://13.124.171.244:8080/picsion/message.ps") //ec2등록 용도 */
			 	
			 	wsocket = new WebSocket("ws://192.168.0.36:8090/picsion/message.ps") //테스트 용도 
			 	wsocket.onopen = onOpen
			 	wsocket.onmessage = onMessage
			}
		  	function onOpen(evt) {
				console.log("여기는 오픈 이벤트")
			}
		  	function onMessage(evt){
		  		console.log("onMessage 실행")
		  		
				var table = evt.data.split(':')[2]
				var sendUserNo = evt.data.split(':')[0]
				var removeDiv = $('#commentstart').find('p[data-no='+sendUserNo+']').closest('.media');
				var url = "";
				
				if(table==4 && evt.data.split(':')[3] != null){
				
					 $.ajax({
                    	url:"/picsion/comment/readreview.ps",
                    	data: {	
                    			cmtNo: evt.data.split(':')[3]
                    	},
                        success: function(data) {
							  var media="";
						      
									media += "<div class='media'>"+
								    "<a class='float-left' href='#pablo'>"+
									"<div class='avatar'>";
									if(data.userinfo.prPicture == null){
										 media += "<img class='media-object' alt='64x64' src='<%=request.getContextPath()%>/assets/img/user.png'>";
									}else{
										media += "<img class='media-object' alt='64x64' src='<%=request.getContextPath()%>"+data.userinfo.prPicture+"'>";
									}
									media += "</div></a><div class='media-body'><h4 class='media-heading'>"+
									data.userinfo.userName+"<small>· "+moment(data.receivecomment.cmtReg).format('YYYY-MM-DD, H:mm:ss')+"</small>"+
									    "</h4><p>"+data.receivecomment.cmtContent+"</p>"+
									    "<a href='#pablo' class='btn btn-primary btn-link float-right'"+
										"rel='tooltip' title='' data-original-title='보내버리기' id='" + data.receivecomment.tableNo + ","+data.userinfo.userNo+","+data.receivecomment.brdNo+",0,"+data.receivecomment.cmtNo+"' > <i "+
										"class='material-icons'>reply</i>신고</a></div></div>";
								
								$("#reviewcontents").append(media); 									
						        $('#collapseThree').scrollTop($('#collapseThree')[0].scrollHeight);
						      	$("#reviewcontent").val("");                        	
                        
                        }
                        }); 
				}
				else if(table==5 && evt.data.split(':')[3] != null){
		  			
                    $.ajax({
                    	url:"/picsion/message/readmsg.ps",
                    	data: {	sendUserNo: sendUserNo,
                    			msgNo: evt.data.split(':')[3]
                    	},
                        success: function(data) {
                        	/* 현재 연 메시지창이 보낸사람이 맞는지 확인해서 메시지 뿌려주기  */
                        	if($('.messageSend').data("no")==sendUserNo && $('#msgContent-show').hasClass('msg-show')){
	                        	var msg = "<div class='popover bs-popover-right bs-popover-right-docs message-receive'>"+
						                      "<div class='arrow'></div>"+
						                      "<div class='popover-body'>"+
							                      "<p class='msg-content-p'>"+data.msginfo.msgContent+"</p>"+
							                      "<p class='msg-reg-p' align='right'><small>"+moment(data.msginfo.msgReg).format('MM-DD, HH:mm')+"</small></p>"+
						                      "</div></div>";
								$('#msg-body').append(msg);
								$('#msg-body').scrollTop($('#msg-body')[0].scrollHeight);
                        	}
							removeDiv.remove();
							
							var userList = "<div class='media'>"+
										   "<a class='float-left'>"+
										   		"<div class='avatar'>"+
										   			"<a href='<%=request.getContextPath()%>/picture/mystudio.ps?userNo="+data.userinfo.userNo+"'><img class='media-object' src='<%=request.getContextPath()%>"+data.userinfo.prPicture+"'></a>"+
										   		"</div></a>"+
										   	"<div class='media-body media-body-custom'>"+
										   		"<h4 class='media-heading msgUserName'>"+data.userinfo.userName+"<small> · "+moment(data.msginfo.msgReg).format('YYYY-MM-DD, HH:mm:ss')+"</small></h4>"+
										   		"<p class='msgList' style='cursor: pointer;' data-no='"+data.userinfo.userNo+"'>"+data.msginfo.msgContent+"</p>"+
										   		"<a class='btn btn-rose btn-link float-right message-margin-del'><i class='material-icons receiveMsgDel'>clear</i>삭제</a>"+
										   		"<a class='btn btn-primary btn-link float-right message-margin-del' rel='tooltip' title='' data-original-title='보내버리기'><i class='material-icons'>reply</i> 신고</a>"+
										   	"</div></div>";
										   	
							$('#commentstart').prepend(userList);
								
                        	
                        }
                    })
                } else{
                	newNoticeCount()
                }
		 	}
		  	
		  	
		  	function onClose(evt) {
			  console.log("여기는 클로즈 이벤트")
			}
		  
		  	function send(receiveUser,tableNo) {
			  	var loginUser = $('#loginUserNo').val()
			  
		        wsocket.send(loginUser+":"+receiveUser+":"+tableNo);
		    }
			//////WEB SOCKET/////
		  	//top으로
		  	function topFunction() {
			    document.body.scrollTop = 0;
			    document.documentElement.scrollTop = 0;
			}
			
		  	
		  	
		</script>

<!-- 메시지 Modal -->
<div class="modal fade" id="reportModal" tabindex="1" role="dialog" aria-labelledby="reportModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="reportModalLabel">신고하기</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      
      <div class="modal-body">
	    <div class="form-group">
	    	<label for="exampleFormControlTextarea1">내용</label>
	    	<textarea class="form-control" id="blaContent" name="blaContent" rows="3" placeholder="최대 25자까지 가능"></textarea>
	    </div>
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-primary" id="blaSend" data-dismiss="modal">보내기</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>
