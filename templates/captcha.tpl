{if $gBitSystem->isFeatureActive('users_random_number_reg')}
	{literal}
	<script type="text/javascript"> /* <![CDATA[ */
	function reloadImage() {
		element = document.getElementById('captcha_img');
		if (element) {
			thesrc = element.src;
			thesrc = thesrc.substring(0,thesrc.lastIndexOf(".")+4);
			document.getElementById("captcha_img").src = thesrc+"?"+Math.round(Math.random()*100000);
		}
	}
	/* ]]> */ </script>
	{/literal}


	{formfeedback error=$errors.captcha}

	{if $params.variant == "condensed"}
		<span class="captcha" {if $params.id}id="{$params.id}"{/if} {if $params.style}style="{$params.style}"{/if}>
			<img id='captcha_img' onclick="this.blur();reloadImage();return false;" class="alignmiddle" id="captcha_img" src="{$params.source}" alt="{tr}Random Image{/tr}"/>
			<br />
			<input type="text" name="captcha" id="captcha" size="{$params.size+3}"/>
			<br />
			<small><em>{tr}Please copy the code into the box. Reload if unreadable.{/tr}</em></small>
		</span>
		<br />
	{else}
		<div class="control-group" {if $params.id}id="{$params.id}"{/if} {if $params.style}style="{$params.style}"{/if}>
			{formlabel label="Verification Code" for="captcha"}
			{forminput}
				<img id='captcha_img' onclick="this.blur();reloadImage();return false;" src="{$params.source}" alt="{tr}Random Image{/tr}"/>
				<br/>
				<input type="text" name="captcha" id="captcha" size="{$params.size+3}"/>
				{formhelp note="Please copy the code into the box. Reload the page or click the image if it is unreadable. Note that it is not case sensitive."}
				{if empty($smarty.cookies)}<div class="error">You do not currently have any cookies from this site. You must accept cookies in order to pass the captcha. For information on enabling cookies in your browser see this: <a href="http://www.google.com/cookies.html">google page on cookies</a>.</div>{/if}
			{/forminput}
		</div>
	{/if}
{/if}

{if $gBitSystem->isFeatureActive('users_register_recaptcha')}
	<div class="control-group">
		{formfeedback error=$errors.recaptcha}
		{formlabel label="Are you human?" for="recaptcha"}
		{forminput}
			{$gBitSystem->getConfig('users_register_recaptcha_public_key')|recaptcha_get_html:$errors.recaptcha}
			{formhelp note="Sorry, we have to ask."}
		{/forminput}
	</div>
{/if}


{if $gBitSystem->isFeatureActive('users_register_smcaptcha')}
	<div class="control-group">
		{formfeedback error=$errors.smcaptcha}
		{formlabel label="Are you human?" for="smcaptcha"}
		{forminput}
{$gBitSystem->getConfig('users_register_smcaptcha_c_key')|solvemedia_get_html}
			{formhelp note="Sorry, we have to ask."}
		{/forminput}
	</div>
{/if}


