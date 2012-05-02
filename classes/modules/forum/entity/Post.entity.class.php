<?php
/*---------------------------------------------------------------------------
* @Module Name: Forum
* @Description: Forum for LiveStreet
* @Version: 1.0
* @Author: Chiffa
* @LiveStreet Version: 1.0
* @File Name: Post.entity.class.php
* @License: CC BY-NC, http://creativecommons.org/licenses/by-nc/3.0/
*----------------------------------------------------------------------------
*/

class PluginForum_ModuleForum_EntityPost extends EntityORM {
	protected $aRelations = array(
		'topic'=>array('belongs_to','PluginForum_ModuleForum_EntityTopic','topic_id'),
		'user'=>array('belongs_to','ModuleUser_EntityUser','user_id'),
		'editor'=>array('belongs_to','ModuleUser_EntityUser','post_editor_id'),
	);

	/**
	 * ���������� ������� ���������
	 */
	public function Init() {
		parent::Init();
		$this->aValidateRules[]=array('post_title','string','min'=>2,'max'=>100,'allowEmpty'=>true,'label'=>$this->Lang_Get('plugin.forum.post_create_title'),'on'=>array('post'));
		$this->aValidateRules[]=array('post_text_source','string','min'=>5,'max'=>Config::Get('plugin.forum.post_max_length'),'allowEmpty'=>false,'label'=>$this->Lang_Get('plugin.forum.post_create_text'),'on'=>array('topic','post'));
		$this->aValidateRules[]=array('post_text_source','post_unique','on'=>array('topic','post'));
	}

	/**
	 * �������� ������ �� ������������
	 *
	 * @param $sValue
	 * @param $aParams
	 * @return bool | string
	 */
	public function ValidatePostUnique($sValue,$aParams) {
		$this->setTextHash(md5($sValue.$this->getTitle()));
		if ($oPostEquivalent=$this->PluginForum_Forum_GetPostByUserIdAndTextHash($this->getUserId(),$this->getTextHash())) {
			if ($iId=$this->getId() and $oPostEquivalent->getId()==$iId) {
				return true;
			}
			return $this->Lang_Get('plugin.forum.post_create_text_error_unique',array('url'=>$oPostEquivalent->getUrlFull()));
		}
		return true;
	}

	public function getUrlFull() {
		return Router::GetPath('forum')."findpost/{$this->getId()}/";
	}

	public function getNumber() {
		return $this->_getDataOne('number') ? $this->_getDataOne('number') : $this->getId();
	}
}
?>