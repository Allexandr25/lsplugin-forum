<?php
/*---------------------------------------------------------------------------
* @Module Name: Forum
* @Description: Forum for LiveStreet
* @Version: 1.0
* @Author: Chiffa
* @LiveStreet Version: 1.0
* @File Name: Forum.class.php
* @License: CC BY-NC, http://creativecommons.org/licenses/by-nc/3.0/
*----------------------------------------------------------------------------
*/

class PluginForum_ModuleForum extends ModuleORM {
	const TOPIC_STATE_OPEN		= 0;
	const TOPIC_STATE_CLOSE		= 1;
	const TOPIC_STATE_MOVED		= 2;
	/**
	 * Префикс подфорумов для дерева
	 */
	const DEPTH_GUIDE			= '--';
	/**
	 * Объект маппера форума
	 */
	protected $oMapperForum=null;

	/**
	 * Инициализация модуля
	 */
	public function Init() {
		parent::Init();
		/**
		 * Получаем объект маппера
		 */
		$this->oMapperForum=Engine::GetMapper(__CLASS__);
	}

	/**
	 * Перемещает топики в другой форум
	 *
	 * @param	integer	$sForumId
	 * @param	integer	$sForumIdNew
	 * @return bool
	 */
	public function MoveTopics($sForumId,$sForumIdNew) {
		if ($res=$this->oMapperForum->MoveTopics($sForumId,$sForumIdNew)) {
			//чистим кеш
			$this->Cache_Clean();
			return $res;
		}
		return false;
	}

	/**
	 * Перемещает подфорумы в другой форум
	 *
	 * @param	integer	$sForumId
	 * @param	integer	$sForumIdNew
	 * @return bool
	 */
	public function MoveForums($sForumId,$sForumIdNew) {
		if ($res=$this->oMapperForum->MoveForums($sForumId,$sForumIdNew)) {
			//чистим кеш
			$this->Cache_Clean();
			return $res;
		}
		return false;
	}

	/**
	 * Получает слудующий по сортировке форум
	 *
	 * @param	integer	$iSort
	 * @param	integer	$sPid
	 * @param	string	$sWay
	 * @return	object
	 */
	public function GetNextForumBySort($iSort,$sPid,$sWay='up') {
		$sForumId=$this->oMapperForum->GetNextForumBySort($iSort,$sPid,$sWay);
		return $this->GetForumById($sForumId);
	}

	/**
	 * Получает значение максимальной сортировки
	 *
	 * @param	integer	$sPid
	 * @return	integer
	 */
	public function GetMaxSortByPid($sPid) {
		return $this->oMapperForum->GetMaxSortByPid($sPid);
	}

	/**
	 * Получает статистику форума
	 *
	* @return	array
	 */
	public function GetForumStats() {
		$aStats=array();
		/**
		 * Посетители
		 */
		if (class_exists('PluginAceBlockManager_ModuleVisitors') && Config::Get('plugin.forum.stats.online')) {
			$aStats['online']=array();
			$nCountVisitors=$this->PluginAceBlockManager_Visitors_GetVisitorsCount(300);
			$nCountGuest=$nCountVisitors;
			$nCountUsers=0;
			if ($aUsersLast=$this->User_GetUsersByDateLast(Config::Get('plugin.forum.stats.users_count'))) {
				$aStats['online']['users']=array();
				foreach ($aUsersLast as $oUser) {
					if ($oUser->isOnline()) {
						$aStats['online']['users'][]=$oUser;
						$nCountUsers++;
						$nCountGuest--;
					}
				}
				shuffle($aStats['online']['users']);
			}
			if ($nCountUsers > $nCountVisitors) $nCountVisitors=$nCountUsers;
			$aStats['online']['count_visitors']=$nCountVisitors;
			$aStats['online']['count_users']=$nCountUsers;
			$aStats['online']['count_quest']=$nCountGuest;
		}
		/**
		 * Дни рождения
		 * TODO:
		 * Написать запрос, возвращающих пользователей, дата рождения которых
		 * совпадает с текущей...
		 */
		if (Config::Get('plugin.forum.stats.bdays')) {
			if ($aUsers=$this->User_GetUsersByFilter(array('activate'=>1),array(),1,999)) {
				$aStats['bdays']=array();

				foreach ($aUsers['collection'] as $oUser) {
					if ($sProfileBirthday=$oUser->getProfileBirthday()) {
						if (date("m-d")==date("m-d",strtotime($sProfileBirthday))) {
							$aStats['bdays'][]=$oUser;
						}
					}
				}
			}
		}
		/**
		 * Получаем количество всех постов
		 */
		$aStats['count_all_posts']=$this->oMapperForum->GetCountPosts();
		/**
		 * Получаем количество всех топиков
		 */
		$aStats['count_all_topics']=$this->oMapperForum->GetCountTopics();
		/**
		 * Получаем количество всех юзеров
		 */
		$aStats['count_all_users']=$this->oMapperForum->GetCountUsers();
		/**
		 * Получаем последнего зарегистрировавшегося
		 */
		if (Config::Get('plugin.forum.stats.last_user')) {
			$aLastUsers=$this->User_GetUsersByDateRegister(1);
			$aStats['last_user']=end($aLastUsers);
		}

		return $aStats;
	}

	/**
	 * Считает инфу по количеству постов и топиков в подфорумах
	 *
	 * @param	object	$oRoot
	 * @return	object
	 */
	public function CalcChildren($oRoot) {
		$aChildren=$oRoot->getChildren();

		if (!empty($aChildren)) {
			foreach ($aChildren as $oForum) {
				$oForum=$this->CalcChildren($oForum);

				if ($oForum->getLastPostId() > $oRoot->getLastPostId()) {
					$oRoot->setLastPostId($oForum->getLastPostId());
				}

				$oRoot->setCountTopic($oRoot->getCountTopic() + $oForum->getCountTopic());
				$oRoot->setCountPost($oRoot->getCountPost() + $oForum->getCountPost());
			}
		}

		return $oRoot;
	}

	/**
	 * Удаляет посты по массиву объектов
	 *
	 * @param	array	$aPosts
	 * @return	boolean
	 */
	public function DeletePosts($aPosts) {
		if (!is_array($aPosts)) {
			$aPosts = array($aPosts);
		}
		$aTopics=array();

		foreach ($aPosts as $oPost) {
			$aTopics[$oPost->getTopicId()] = 1;
			$oPost->Delete();
		}
		foreach (array_keys($aTopics) as $sTopicId) {
			$this->RecountTopic($sTopicId);
		}
		return true;
	}

	/**
	 * Пересчет счетчиков форума
	 *
	 * @param	object	$oForum
	 * @return	object
	 */
	public function RecountForum($oForum) {
		if (!($oForum instanceof Entity)) {
			$oForum = $this->GetForumById($oForum);
		}

		$iCountTopic=$this->oMapperForum->GetCountTopicByForumId($oForum->getId());
		$iCountPost=$this->oMapperForum->GetCountPostByForumId($oForum->getId());
		$iLastPostId=$this->oMapperForum->GetLastPostByForumId($oForum->getId());

		$oForum->setCountTopic((int)$iCountTopic);
		$oForum->setCountPost((int)$iCountPost);
		$oForum->setLastPostId((int)$iLastPostId);
		return $oForum->Save();
	}

	/**
	 * Пересчет счетчиков топика
	 *
	 * @param	object	$oForum
	 * @return	object
	 */
	public function RecountTopic($oTopic) {
		if (!($oTopic instanceof Entity)) {
			$oTopic = $this->GetTopicById($oTopic);
		}

		$iCountPost=$this->oMapperForum->GetCountPostByTopicId($oTopic->getId());
		$iLastPostId=$this->oMapperForum->GetLastPostByTopicId($oTopic->getId());

		$oTopic->setCountPost((int)$iCountPost);
		$oTopic->setLastPostId((int)$iLastPostId);
		return $oTopic->Save();
	}

	/**
	 * Формируем права модерирования
	 *
	 * @param	object	$oForum
	 * @return	object
	 */
	public function BuildModerPerms($oForum) {
		$sId = LS::CurUsr() ? LS::CurUsr()->getId() : 0;
		$oModerator = $this->PluginForum_Forum_GetModeratorByUserIdAndForumId($sId,$oForum->getId());

		$oForum->setIsModerator(LS::Adm() || $oModerator);
		$oForum->setModViewIP(LS::Adm() || ($oModerator && $oModerator->getViewIp()));
		$oForum->setModDeletePost(LS::Adm() || ($oModerator && $oModerator->getAllowDeletePost()));
		$oForum->setModDeleteTopic(LS::Adm() || ($oModerator && $oModerator->getAllowDeleteTopic()));
		$oForum->setModMoveTopic(LS::Adm() || ($oModerator && $oModerator->getAllowMoveTopic()));
		$oForum->setModOpencloseTopic(LS::Adm() || ($oModerator && $oModerator->getAllowOpencloseTopic()));
		$oForum->setModPinTopic(LS::Adm() || ($oModerator && $oModerator->getAllowPinTopic()));

		return $oForum;
	}

	/**
	 * Проверяем, нужно ли юзеру вводить пароль
	 */
	public function isForumAuthorization($oForum) {
		$bAccess=true;
		if ($oForum->getPassword()) {
			$bAccess=false;
			if (LS::CurUsr()) {
				if (forum_compare_password($oForum)) {
					$bAccess=true;
				}
			}
		}
		return $bAccess;
	}

	/**
	 * Парсер текста
	 */
	public function TextParse($sText=null) {
		if (is_null($sText)) return $sText;

		return $this->Text_Parser($sText);
	}
}

?>