{strip}
{* checks if installer path is available *}
{assign var=installfile value="`$smarty.const.INSTALL_PKG_PATH`install.php"|is_file}
{assign var=installread value="`$smarty.const.INSTALL_PKG_PATH`install.php"|is_readable}
{if $installfile neq 1 and $installread neq 1}
	{capture assign=install_unavailable}
		<p>{tr}You might have to rename your <strong>install/install.done</strong> file back to <strong>install/install.php</strong>.{/tr}</p>
	{/capture}
{/if}

{form class="kernel_`$page`|replace:'packages':'pkg'"}
	<input type="hidden" name="page" value="{$page}" />
	{jstabs}
		{jstab title="Installed"}
			{legend legend="bitweaver packages installed on your system"}
				<p>
					{tr}Packages with checkmarks are currently enabled, packages without are disabled.  To enable or disable a package, check or uncheck it, and click the 'Modify Activation' button.{/tr} <a href='{$smarty.const.INSTALL_PKG_URL}install.php?step=3'>{tr}To uninstall or reinstall a package, visit the installer.{/tr}</a>
				</p>

				{$install_unavailable}

				{foreach key=name item=package from=$gBitSystem->mPackages}
					{if $package.installed && !$package.service && !$package.required}
						<div class="row">
							<div class="formlabel">
								<label for="package_{$name}">{biticon ipackage=$name iname="pkg_`$name`" iexplain="$name" iforce=icon}</label>
							</div>
							{forminput}
								<label>
									<input type="checkbox" value="y" name="fPackage[{$name}]" id="package_{$name}" {if $package.active_switch eq 'y' }checked="checked"{/if} />
									&nbsp;
									<strong>{$name|capitalize}</strong>
								</label>
								{formhelp note=`$package.info` package=$name}
							{/forminput}
						</div>
					{/if}
				{/foreach}

			{/legend}



			{legend legend="bitweaver services installed on your system"}
				<p>
					{tr}A service package is a package that allows you to extend the way you display bitweaver content - such as <em>categorising your content</em>. Activating more than one of any service type might lead to conflicts.<br />
					We therefore recommend that you <em>	enable only one of each</em> <strong>service type</strong>.{/tr}
				</p>
				{foreach key=name item=package from=$gBitSystem->mPackages}
					{if $package.installed && $package.service && !$package.required}
						<div class="row">
							<div class="formlabel">
								{if !$package.required}<label for="package_{$name}">{/if}{biticon ipackage=$name iname="pkg_`$name`" iexplain="$name" iforce=icon}{if !$package.required}</label>{/if}
							</div>
							{forminput}
								<label>
									<input type="checkbox" value="y" name="fPackage[{$name}]" id="package_{$name}" {if $package.active_switch eq 'y' }checked="checked"{/if} />
									&nbsp;
									<strong>{$name|capitalize}</strong>
									<br />
									{tr}Service Type{/tr}: <strong>{$package.service|capitalize|replace:"_":" "}</strong>
								</label>
								{formhelp note=`$package.info` package=$name}
							{/forminput}
						</div>
					{/if}
				{/foreach}
			{/legend}

			<div class="row submit">
				<input type="submit" name="features" value="{tr}Modify Activation{/tr}"/>
			</div>
		{/jstab}


		{jstab title="Required"}
			{legend legend="Required bitweaver packages installed on your system"}
				{foreach key=name item=package from=$gBitSystem->mPackages}
					{if $package.installed && !$package.service && $package.required}
						<div class="row">
							<div class="formlabel">
								{biticon ipackage=$name iname="pkg_`$name`" iexplain="$name" iforce=icon}
							</div>
							{forminput}
									<strong>{$name|capitalize}</strong>
									{formhelp note=`$package.info` package=$name}
							{/forminput}
						</div>
					{/if}
				{/foreach}
			{/legend}
			{legend legend="Required bitweaver services installed on your system"}
				{foreach key=name item=package from=$gBitSystem->mPackages}
					{if $package.installed && $package.service && $package.required}
						<div class="row">
							<div class="formlabel">
								{biticon ipackage=$name iname="pkg_`$name`" iexplain="$name" iforce=icon}
							</div>
							{forminput}
								<label>
									<strong>{$name|capitalize}</strong>
								</label>
								{formhelp note=`$package.info` package=$name}
							{/forminput}
						</div>
					{/if}
				{/foreach}
			{/legend}
		{/jstab}


		{if $dependencymap || $dependencies}
			{jstab title="Dependencies"}
				{if $dependencymap}
					<h2>{tr}Dependencies{/tr}</h2>
					<p class="help">{tr}Below you will find an illustration of how the packages depend on each other.{/tr}</p>
					<div style="text-align:center; overflow:auto;">
						<img alt="A graphical representation of package dependencies" title="Dependency graph" src="{$smarty.const.KERNEL_PKG_URL}dependency_graph.php?install_version=1&amp;format={$smarty.request.format}&amp;command={$smarty.request.command}" usemap="#Dependencies" />
						{$dependencymap}
					</div>
				{/if}

				{if $dependencies}
					<h2>{tr}Dependency Table{/tr}</h2>
					<p class="help">{tr}Below you will find a detailed table with package dependencies. If not all package dependencies are met, consider trying to meet all package dependencies. If you don't meet them, you may continue at your own peril.{/tr}</p>
					<table id="dependencies">
						<caption>Package Dependencies</caption>
						<tr>
							<th style="width:16%;">Requirement</th>
							<th style="width:16%;">Min Version</th>
							<th style="width:16%;">Max Version</th>
							<th style="width:16%;">Available</th>
							<th style="width:36%;">Result</th>
						</tr>
						{foreach from=$dependencies item=dep}
							{if $pkg != $dep.package}
								<tr><th colspan="5">{$dep.package|ucfirst} requirements</th></tr>
								{assign var=pkg value=$dep.package}
							{/if}

							{if $dep.result == 'ok'}
								{assign var=class value=success}
							{elseif $dep.result == 'missing'}
								{assign var=class value=error}
							{elseif $dep.result == 'min_dep'}
								{assign var=class value=error}
							{elseif $dep.result == 'max_dep'}
								{assign var=class value=warning}
							{/if}

							<tr class="{$class}">
								<td>{$dep.requires|ucfirst}</td>
								<td>{$dep.required_version.min}</td>
								<td>{$dep.required_version.max}</td>
								<td>{$dep.required_version.available}</td>
								<td>
									{if $dep.result == 'ok'}
										OK
									{elseif $dep.result == 'missing'}
										Package missing
										{assign var=missing value=true}
									{elseif $dep.result == 'min_dep'}
										Minimum version not met
										{assign var=min_dep value=true}
									{elseif $dep.result == 'max_dep'}
										Maximum version exceeded
										{assign var=max_dep value=true}
									{/if}
								</td>
							</tr>
						{/foreach}
					</table>

					{if $missing}
						{formfeedback warning="At least one required package is missing. Please activate or install the missing package." link="install/install.php?step=3/Install Package"}
					{/if}

					{if $min_dep}
						{formfeedback warning="At least one package did not meet the minimum version requirement. If possible, please upgrade to a newer version."}
					{/if}

					{if $max_dep}
						{formfeedback warning="At least one package recommend a version lower to the one you have installed. This might cause problems."}
					{/if}

					{if !$min_dep && !$max_dep && !$missing}
						{formfeedback success="All package dependencies have been met."}
					{/if}
				{/if}

				<ul>
					<li>{smartlink ititle="Install Packages" ipackage=install ifile=install.php step=3}</li>
					<li>{smartlink ititle="Upgrade Packages" ipackage=install ifile=install.php step=4}</li>
				</ul>
			{/jstab}
		{/if}


		{jstab title="Not Installed"}
			{legend legend="bitweaver packages available for installation"}

				<div class="row">
					<div class="formlabel">
						{biticon ipackage=install iname="pkg_install" iexplain="install" iforce=icon}
					</div>
					{forminput}
						<p><strong><a class="warning" href='{$smarty.const.INSTALL_PKG_URL}install.php?step=3'>{tr}Click here to install more Packages{/tr}&nbsp;&hellip;</a></strong></p>

						{$install_unavailable}
					{/forminput}
				</div>

				<hr style="clear:both" />

				{foreach key=name item=package from=$gBitSystem->mPackages}
					{if ((1 or $package.tables) && !$package.required && !$package.installed) }
						<div class="row">
							<div class="formlabel">
								{biticon ipackage=$name iname="pkg_`$name`" iexplain="$name" iforce=icon}
							</div>
							{forminput}
								{$name|capitalize}
								{formhelp note=`$package.info` package=$name}
							{/forminput}
						</div>
					{/if}
				{/foreach}
			{/legend}
		{/jstab}
	{/jstabs}
{/form}

{/strip}
