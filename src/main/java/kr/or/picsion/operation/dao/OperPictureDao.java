package kr.or.picsion.operation.dao;

import kr.or.picsion.operation.dto.OperPicture;

/**
 * @project Final_Picsion
 * @package kr.or.picsion.operation.dao 
 * @className OperPictureDao
 * @date 2018. 7. 2.
 */

public interface OperPictureDao {

	public int insertOperPicture(OperPicture operpicture);
	public int updateOperation(OperPicture operpicture);
	public OperPicture selectOperpicture(int operNo);
}
