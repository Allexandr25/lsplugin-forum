{assign var="noSidebar" value=true}
{include file='header.tpl'}

{assign var="oForum" value=$oTopic->getForum()}

<h2 class="page-header">{include file="$sTemplatePathPlugin/breadcrumbs.tpl"}</h2>

{if $oConfig->GetValue('plugin.forum.topic_line_mod') && $oHeadPost}
<div class="forum-topic">
	<header class="forums-header">
		<span class="fl-r">{$aLang.plugin.forum.topic_post_count}: {$iPostsCount}</span>
		<h3>{$oTopic->getTitle()}</h3>
	</header>
	{include file="$sTemplatePathPlugin/post.tpl" oPost=$oHeadPost}
</div>
{/if}

{if count($aPosts) > 0}
<div id="topic-controls-top" class="controllers clearfix">
	{include file="$sTemplatePathPlugin/paging.tpl" aPaging=$aPaging}
	{include file="$sTemplatePathPlugin/buttons_action.tpl"}
</div>

<div class="forum-topic">
	<header class="forums-header">
		{if $oConfig->GetValue('plugin.forum.topic_line_mod')}
		<h3>{$aLang.plugin.forum.topic_answers}</h3>
		{else}
		<span class="fl-r">{$aLang.plugin.forum.topic_post_count}: {$iPostsCount}</span>
		<h3>{$oTopic->getTitle()}</h3>
		{/if}
	</header>
	{foreach from=$aPosts item=oPost}
		{include file="$sTemplatePathPlugin/post.tpl" oPost=$oPost}
	{/foreach}
</div>
{/if}

<footer class="forum-topic-footer">
	{if $oUserCurrent && $oUserCurrent->isAdministrator()}
	<form name="modform" action="" method="POST" enctype="multipart/form-data">
		<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />
		<input type="hidden" name="t" value="{$oTopic->getId()}" />
		<input type="hidden" name="f" value="{$oForum->getId()}" />
		<select name="code">
			<option value="-1">{$aLang.plugin.forum.topic_mod_option}</option>
			<option value="1">-{$aLang.plugin.forum.topic_move}</option>
			<option value="2">-{$aLang.plugin.forum.topic_delete}</option>
			{if $oTopic->getStatus() == '0'}
			<option value="3">-{$aLang.plugin.forum.topic_close}</option>
			{else}
			<option value="3">-{$aLang.plugin.forum.topic_open}</option>
			{/if}
			{if $oTopic->getPosition() == '0'}
			<option value="4">-{$aLang.plugin.forum.topic_pin}</option>
			{else}
			<option value="4">-{$aLang.plugin.forum.topic_unpin}</option>
			{/if}
		</select>
		<button type="submit" name="submit_topic_mod" class="button">OK</button>
		{/if}
	</form>
</footer>

<div id="topic-controls-bottom" class="controllers clearfix">
	{include file="$sTemplatePathPlugin/paging.tpl" aPaging=$aPaging}
	{include file="$sTemplatePathPlugin/buttons_action.tpl" bFastAnswer=true}
</div>

{if $oUserCurrent && (!$oTopic->getState() || $oUserCurrent->isAdministrator()) && $oForum->getQuickReply()}
	{include file="$sTemplatePathPlugin/fast_answer_form.tpl"}
{/if}

{include file='footer.tpl'}