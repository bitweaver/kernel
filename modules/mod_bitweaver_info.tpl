{bitmodule title="$moduleTitle" name="bit_info"}
	{assign var=version_info value=$gBitSystem->checkBitVersion()}
	<ul>
		<li>{tr}Powered By{/tr} <a href="http://bitweaver.org">bitweaver</a></li>
		<li>{tr}Version{/tr}: <strong>{$version_info.local}</strong></li>
		{if $gBitUser->isAdmin()}
			<li>
				{if $version_info.compare lt 0}
					{tr}Upgrade to{/tr} <strong>{$version_info.upgrade}</strong>
				{elseif $version_info.compare gt 0}
					{tr}Latest Version{/tr} <strong>{$version_info.upgrade}</strong>
				{/if}

				{if $version_info.release}
					{tr}Latest Release{/tr} <strong>{$version_info.release}</strong>
				{/if}
				<br />
				{if $version_info.compare eq 0 and !$version_info.release}
					{tr}Your version is up to date.{/tr}
				{elseif $version_info.compare lt 0 or $version_info.release}
					{tr}Your version is not up to date.{/tr}
				{elseif $version_info.compare gt 0 or $version_info.release}
					{tr}Seems you are using a test version.{/tr}
				{/if}
			</li>
		{/if}
	</ul>
{/bitmodule}
