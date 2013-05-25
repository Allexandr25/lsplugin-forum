{assign var="oUser" value=$oPost->getUser()}

<article class="forum-post{if $bFirst} forum-post-first{/if}{if $oMarker && $oMarker->getLastMarkPost($oTopic) < $oPost->getId()} new{/if} js-post" id="post-{$oPost->getId()}">
	<div class="forum-post-wrap">
		<div class="forum-post-content">
			<header class="forum-post-header">
				{hook run='forum_post_header_begin' post=$oPost}
				<div class="clearfix">
					<section class="forum-post-extra-right">
						<ul class="forum-post-extra-info">
							{if $oUserCurrent && ($oUserCurrent->isAdministrator() || ($oForum && $oForum->getModViewIP())) && $oPost->getUserIp()}
								<li>IP: {$oPost->getUserIp()}</li>
							{/if}
							<li>{$aLang.plugin.forum.post} <a href="{$oPost->getUrlFull()}" name="post-{$oPost->getId()}" onclick="return ls.forum.linkToPost({$oPost->getId()})">#{$oPost->getNumber()}</a></li>
							{hook run='forum_post_header_info_item' post=$oPost}
						</ul>
						<a class="forum-post-extra-trigger" onclick="ls.tools.slide($('#post-extra-target-{$oPost->getId()}'), $(this));">
							<i class="icon-topic-menu"></i>
						</a>
					</section>
					<section class="forum-post-extra-left">
						<div class="forum-post-info-author">
							{hook run='forum_post_userinfo_begin' post=$oPost user=$oUser}

							{if $oUser}
								<a href="{$oUser->getUserWebPath()}"><img alt="{$oUser->getLogin()}" src="{$oUser->getProfileAvatarPath(48)}" /></a>
								<p><a rel="author" href="{$oUser->getUserWebPath()}">{$oUser->getLogin()}</a></p>
							{else}
								<img alt="{$oPost->getGuestName()}" src="{cfg name='path.static.skin'}/images/avatar_male_48x48.png" />
								<p>{$aLang.plugin.forum.guest_prefix}{$oPost->getGuestName()}</p>
							{/if}
							<time datetime="{date_format date=$oPost->getDateAdd() format='c'}" title="{date_format date=$oPost->getDateAdd() format='j F Y, H:i'}">
								{date_format date=$oPost->getDateAdd() format="j F Y, H:i"}
							</time>

							{hook run='forum_post_userinfo_end' post=$oPost user=$oUser}
						</div>
					</section>
				</div>
				{hook run='forum_post_header_end' post=$oPost}
			</header>
			<div class="forum-post-body">
				{hook run='forum_post_content_begin' post=$oPost}
				{if $oPost->getTitle()}
					<h2>{$oPost->getTitle()}</h2>
				{/if}
				<div class="text">
					{$oPost->getText()}
				</div>
				{if $oPost->getEditorId()}
					{assign var="oEditor" value=$oPost->getEditor()}
					<div class="edit">
						{$aLang.plugin.forum.post_editing}
						<a href="{$oEditor->getUserWebPath()}">{$oEditor->getLogin()}</a>
						{if $oPost->getDateEdit()}
							<span class="divide">-</span>
							{date_format date=$oPost->getDateEdit()}
						{/if}
						{if $oPost->getEditReason()}
							<span class="reason">{$oPost->getEditReason()}</span>
						{/if}
					</div>
				{/if}
				{hook run='forum_post_content_end' post=$oPost}
			</div>
		</div>
	</div>
	{if $oUserCurrent && !$noFooter}
	<footer class="forum-post-footer clearfix">
		<ul class="slide slide-post-info-extra" id="post-extra-target-{$oPost->getId()}">
			{if $oUserCurrent && $oUser}
			<li>
				<a href="{router page='talk'}add/?talk_users={$oUser->getLogin()}">{$aLang.send_message_to_author}</a>
			</li>
			{/if}
			<li>
				<a href="#" class="js-post-quote" data-name="{if $oUser}{$oUser->getLogin()}{/if}" data-post-id="{$oPost->getId()}">{$aLang.plugin.forum.button_quote}</a>
			</li>
			<li>
				<a href="{$oTopic->getUrlFull()}reply" class="js-post-reply" data-name="{if $oUser}{$oUser->getLogin()}{/if}" data-post-id="{$oPost->getId()}">{$aLang.plugin.forum.button_reply}</a>
			</li>
			{if $LS->ACL_IsAllowEditForumPost($oPost,$oUserCurrent)}
			<li>
				<a href="{router page='forum'}topic/edit/{$oPost->getId()}" class="js-post-edit" data-post-id="{$oPost->getId()}">{$aLang.plugin.forum.button_edit}</a>
			</li>
			{/if}
			{if $LS->ACL_IsAllowDeleteForumPost($oPost,$oUserCurrent)}
			<li>
				<a href="{router page='forum'}topic/delete/{$oPost->getId()}" class="js-post-delete" data-post-id="{$oPost->getId()}">{$aLang.plugin.forum.button_delete}</a>
			</li>
			{/if}
		</ul>
	</footer>
	{/if}
</article>