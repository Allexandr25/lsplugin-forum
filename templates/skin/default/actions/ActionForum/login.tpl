{include file='header.tpl' noSidebar=true}

<h2 class="page-header">{include file="$sTemplatePathPlugin/breadcrumbs.tpl"}</h2>

<h4 class="page-subheader">{$aLang.plugin.forum.password_write}</h4>

<p>
	{$aLang.plugin.forum.password_security}<br/>
	{$aLang.plugin.forum.password_security_notice}
</p>

<form action="" method="POST" enctype="multipart/form-data">
	<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" /> 

	<p>
		<label for="f_password">{$aLang.forum_password}:</label>
		<input type="text" id="f_password" name="f_password" value="{$_aRequest.f_password}" class="input-text input-width-full" />
	</p>

	<button name="submit_password" id="submit_password" class="button button-primary">{$aLang.user_login_submit}</button>
</form>

{include file='footer.tpl'}