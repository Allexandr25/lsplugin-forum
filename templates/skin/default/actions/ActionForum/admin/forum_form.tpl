{assign var="noSidebar" value=true}
{include file='header.tpl'}

<h2 class="page-header">
	<a href="{router page='forum'}admin">{$aLang.forum_acp}</a> <span>&raquo;</span>
	<a href="{router page='forum'}admin/forums">{$aLang.forums}</a> <span>&raquo;</span>
	{if $sType == 'edit'}
		{$aLang["forum_edit_"|cat:$sNewType]}
	{else}
		{$aLang["forum_create_"|cat:$sNewType]}
	{/if}
</h2>

<div class="forums">
	<header class="forums-header">
		<h3>{$aLang.forum_create}</h3>
	</header>

{if $sNewType != 'category' && !$aForums}
	<div class="">{$aLang.forum_create_warning}</div>
{else}
	<form action="" method="POST" enctype="multipart/form-data">
		<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" /> 
		<input type="hidden" name="forum_type" value="{$sNewType}" />

		<table class="table">
			<tr>
				<th colspan="2" align="center">
					<h3>{$aLang.forum_create_block_main}</h3>
				</th>
			</tr>

			<tr>
				<td width="400">
					<label for="forum_title">{$aLang.forum_create_title}:</label>
					<span class="note"> </span>
				</td>
				<td>
					<input type="text" id="forum_title" name="forum_title" value="{$_aRequest.forum_title}" class="input-text input-width-full" />
				</td>
			</tr>
			<tr>
				<td width="400">
					<label for="forum_url">{$aLang.forum_create_url}:</label>
					<span class="note">{$aLang.forum_create_url_note}</span>
				</td>
				<td>
					<input type="text" id="forum_url" name="forum_url" value="{$_aRequest.forum_url}" class="input-text input-width-full" />
				</td>
			</tr>
			<tr>
			<td width="400">
				<label for="forum_sort">{$aLang.forum_create_sort}:</label>
				<span class="note">{$aLang.forum_create_sort_notice}</span>
			</td>
			<td class="row1">
				<input type="text" id="forum_sort" name="forum_sort" value="{$_aRequest.forum_sort}" class="input-text input-width-full" />
			</td>
		</tr>

		{if $sNewType != 'category'}
		<tr>
			<td width="400">
				<label for="forum_description">{$aLang.forum_create_description}:</label>
				<span class="note"></span>
			</td>
			<td>
				<textarea id="forum_description" name="forum_description" rows="5" class="input-text input-width-full">{$_aRequest.forum_description}</textarea>
			</td>
		</tr>
		<tr>
			<td width="400">
				<label for="forum_parent">{$aLang.forum_create_parent}:</label>
				<span class="note"></span>
			</td>
			<td>
				<select id="forum_parent" name="forum_parent">
				{foreach from=$aForumsList item=aItem}
					<option value="{$aItem.id}"{if $_aRequest.forum_parent==$aItem.id} selected{/if}>{$aItem.title}</option>
				{/foreach}
				</select>
			</td>
		</tr>
		<tr>
			<td width="400">
				<label for="forum_type">{$aLang.forum_create_type}:</label>
				<span class="note">{$aLang.forum_create_type_notice}</span>
			</td>
			<td>
				<select id="forum_type" name="forum_type">
					<option value="1"{if $_aRequest.forum_type=='1'} selected{/if}>{$aLang.forum_create_type_active}</option>
					<option value="0"{if $_aRequest.forum_type=='0'} selected{/if}>{$aLang.forum_create_type_archive}</option>
				</select>
			</td>
		</tr>
		<tr>
			<td width="400">
				<label for="forum_sub_can_post">{$aLang.forum_create_sub_can_post}:</label>
				<span class="note">{$aLang.forum_create_sub_can_post_notice}</span>
			</td>
			<td>
				<label><input type="radio" class="radio" name="forum_sub_can_post" id="forum_sub_can_post_yes" value="1"{if $_aRequest.forum_sub_can_post=='1'} checked{/if}> Yes</label>
				<label><input type="radio" class="radio" name="forum_sub_can_post" id="forum_sub_can_post_no" value="0"{if !$_aRequest.forum_sub_can_post || $_aRequest.forum_sub_can_post=='0'} checked{/if}> No</label>
			</td>
		</tr>
		<tr>
			<td width="400">
				<label for="forum_quick_reply">{$aLang.forum_create_quick_reply}:</label>
				<span class="note">{$aLang.forum_create_quick_reply_notice}</span>
			</td>
			<td>
				<label><input type="radio" class="radio" name="forum_quick_reply" id="forum_quick_reply_yes" value="1"{if $_aRequest.forum_quick_reply=='1'} checked{/if}> Yes</label>
				<label><input type="radio" class="radio" name="forum_quick_reply" id="forum_quick_reply_no" value="0"{if !$_aRequest.forum_quick_reply || $_aRequest.forum_quick_reply=='0'} checked{/if}> No</label>
			</td>
		</tr>

		<tr>
			<th colspan="2" align="center">
				<h3>{$aLang.forum_create_block_redirect}</h3>
			</th>
		</tr>

		<tr>
			<td width="400">
				<label for="forum_redirect_url">{$aLang.forum_create_forum_redirect_url}:</label>
				<span class="note">{$aLang.forum_create_forum_redirect_url_notice}</span>
			</td>
			<td>
				<input type="text" id="forum_redirect_url" name="forum_redirect_url" value="{$_aRequest.forum_redirect_url}" class="input-wide" />
			</td>
		</tr>
		<tr>
			<td width="400">
				<label for="forum_redirect_on">{$aLang.forum_create_forum_redirect_on}:</label>
				<span class="note">{$aLang.forum_create_forum_redirect_on_notice}</span>
			</td>
			<td>
				<label><input type="radio" class="radio" name="forum_redirect_on" id="forum_redirect_on_yes" value="1"{if $_aRequest.forum_redirect_on=='1'} checked{/if}> Yes</label>
				<label><input type="radio" class="radio" name="forum_redirect_on" id="forum_redirect_on_no" value="0"{if !$_aRequest.forum_redirect_on || $_aRequest.forum_redirect_on=='0'} checked{/if}> No</label>
			</td>
		</tr>
		{/if}

		<tr>
			<td colspan="2">
				<div class="ta-c">
					{if $sType == 'edit'}
					<button type="submit" name="submit_forum_save" class="button">{$aLang.forum_edit_submit}</button>
					{else}
					<button type="submit" name="submit_forum_add" class="button button-primary">{$aLang.forum_create_submit}</button>
					{/if}
				</div>
			</td>
		</tr>
	</table>
</form>
{/if}

{include file='footer.tpl'}