{* $Header: /cvsroot/bitweaver/_bit_kernel/templates/Attic/admin_general.tpl,v 1.9 2006/03/29 10:10:23 squareing Exp $ *}
{strip}
{form}
	<input type="hidden" name="page" value="{$page}" />

	{jstabs}
		{jstab title="Homepage Settings"}
			{legend legend="Homepage Settings"}
				<div class="row">
					{formlabel label="Home page" for="bit_index"}
					{forminput}
						<select name="bit_index" id="bit_index">
							<option value="my_page"{if $gBitSystem->getConfig('bit_index') eq 'my_page'} selected="selected"{/if}>{tr}My {$gBitSystem->getConfig('site_title')} Page{/tr}</option>
							<option value="user_home"{if $gBitSystem->getConfig('bit_index') eq 'user_home'} selected="selected"{/if}>{tr}User's homepage{/tr}</option>
							<option value="group_home"{if $gBitSystem->getConfig('bit_index') eq 'group_home'} selected="selected"{/if}>{tr}Group home{/tr}</option>
							<option value="custom_home"{if $gBitSystem->getConfig('bit_index') eq $gBitSystem->getConfig('url_index')} selected="selected"{/if}>{tr}Custom home{/tr}</option>
							{foreach key=name item=package from=$gBitSystem->mPackages }
								{if $package.homeable && $package.installed}
									<option {if $gBitSystem->getConfig('bit_index') eq $package.name}selected="selected"{/if} value="{$package.name}">{$package.name|capitalize}</option>
								{/if}
							{/foreach}
						</select>
						{formhelp note="Pick your site's homepage. This is where they will be redirected, when they access a link to your homepage.
							<dl><dt>My bitweaver Page</dt><dd>This page contains all links the user can access with his/her current permissions.</dd>
								<dt>User's Homepage</dt><dd>This is the user's public homepage</dd>
								<dt>Group Home</dt><dd>You can define an individual home page for a group of users using this option. To define home pages, please access the <em>Groups and Permissions</em>.</dd>
								<dt>Custom Home</dt><dd>You can define any url as your bitweaver homepage. This could be an introductory page with links or a flash introduction...</dd>
								<dt>Package Homes</dt><dd>Here you can set a particular package that will serve as your home page. If you want to select an individual homepage from the exisiting ones, please access the <br /><em>Administration --> 'Package' --> 'Package' Settings</em> page.</dd>
							</dl>"}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="URI for custom home" for="url_index"}
					{forminput}
						<input type="text" id="url_index" name="url_index" value="{$gBitSystem->getConfig('url_index')|escape}" size="50" />
						{formhelp note="Use a specific URI to direct users to a particular page when accessing your site. Can be used to have an introductory page.<br />To activate this, please select <em>Custom home</em> above."}
					{/forminput}
				</div>

				<div class="row submit">
					<input type="submit" name="prefsTabSubmit" value="{tr}Change preferences{/tr}" />
				</div>
			{/legend}
		{/jstab}

		{jstab title="Date and Time"}
			{legend legend="Date and Time Formats"}
				<div class="row">
					{formlabel label="Long date format" for="long_date_format"}
					{forminput}
						<input type="text" name="long_date_format" id="long_date_format" value="{$long_date_format|escape}" size="50"/>
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Short date format" for="short_date_format"}
					{forminput}
						<input type="text" name="short_date_format" id="short_date_format" value="{$short_date_format|escape}" size="50"/>
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Long time format" for="long_time_format"}
					{forminput}
						<input type="text" name="long_time_format" id="long_time_format" value="{$long_time_format|escape}" size="50"/>
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Short time format" for="short_time_format"}
					{forminput}
						<input type="text" name="short_time_format" id="short_time_format" value="{$short_time_format|escape}" size="50"/>
						{formhelp note="<strong>Online Help</strong>: <a class=\"external\" href=\"http://www.php.net/manual/en/function.strftime.php\">Date and Time Format Help</a>"}
					{/forminput}
				</div>

				<div class="row submit">
					<input type="submit" name="timeTabSubmit" value="{tr}Change preferences{/tr}" />
				</div>
			{/legend}
		{/jstab}

		{jstab title="Miscellaneous"}
			{legend legend="Miscellaneous Settings"}
				<div class="row">
					{formlabel label="Maximum number of records in listings" for="max_records"}
					{forminput}
						<input size="5" type="text" name="max_records" id="max_records" value="{$gBitSystem->getConfig('max_records')|escape}" />
					{/forminput}
				</div>

				{foreach from=$formGeneralMisc key=feature item=output}
					<div class="row">
						{formlabel label=`$output.label` for=$feature}
						{forminput}
							{html_checkboxes name="$feature" values="y" checked=$gBitSystem->getConfig($feature) labels=false id=$feature}
							{formhelp note=`$output.note` page=`$output.page`}
						{/forminput}
					</div>
				{/foreach}

				<div class="row submit">
					<input type="submit" name="miscTabSubmit" value="{tr}Change preferences{/tr}" />
				</div>
			{/legend}
		{/jstab}
	{/jstabs}
{/form}

{/strip}
