package kr.or.picsion.operation.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.View;

import kr.or.picsion.board.dto.Board;
import kr.or.picsion.board.service.BoardService;
import kr.or.picsion.comment.service.CommentService;
import kr.or.picsion.notice.service.NoticeService;
import kr.or.picsion.operation.dto.Operation;
import kr.or.picsion.operation.service.OperationService;

@Controller
public class OperationController {

	@Autowired
	private View jsonview;

	@Autowired
	private OperationService operationService;

	@Autowired
	private CommentService commentService;

	@Autowired
	private BoardService boardService;
	
	@Autowired
	private NoticeService noticeService;
	
	@RequestMapping(value="operok.ps")
	public View OperationApplyok(Operation operation, Model model) {
		System.out.println("OperationApplyok컨트롤러");
		System.out.println(operation);
		
		Board board = boardService.selectBoard(operation.getBrdNo());
		board.setBrdExpectPrice(operation.getOperPrice());
		board.setBrdExpectEndDate(operation.getOperEndReg());		
		board.setOperStateNo(2);
		commentService.deleteAllComment(board.getBrdNo());
		boardService.updateBoard(board);
		int result = operationService.insertOperation(operation);

		if(result != 0) {
			HashMap<String, Object> noticeMap = new HashMap<String, Object>();
			
			noticeMap.put("no", operation.getOperNo());
			noticeMap.put("receiveUserNo", operation.getOperatorNo());
			noticeMap.put("sendUserNo", operation.getRequesterNo());
			noticeMap.put("table", "operNo");
			noticeMap.put("tableNo", operation.getTableNo());
			
			noticeService.insertNotice(noticeMap);
		}
		
		model.addAttribute("check", result);
		return jsonview	;
	}
		
}
