<ul class="nav nav-pills">
	<li{if $sMenuItemSelect=='forum'} class="active"{/if}><a href="{router page='forum'}">{$aLang.forums}</a></li>

	{if $oUserCurrent && $oUserCurrent->isAdministrator()}
		<li{if $sMenuItemSelect=='admin'} class="active"{/if}>
			<a href="{router page='forum'}admin">{$aLang.forum_acp}</a>
		</li>
	{/if}

	{hook run='menu_forum_item'}
	{hook run='menu_forum'}
</ul>