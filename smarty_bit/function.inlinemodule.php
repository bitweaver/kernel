<?php

// Usage: add to the body of any .tpl file
// Example: {inlinemodule file="bitpackage:wiki/mod_last_modif_pages.tpl" rows="50"}

function smarty_function_inlinemodule($params, &$smarty)
{
	global $module_rows, $module_params;

	$module_rows = (!empty( $params['rows'] ) && is_numeric( trim( $params['rows'] ) ) ? $params['rows'] : NULL);
	$module_params = (!empty( $params['params'] ) ? $params['params'] : NULL);
	print $smarty->fetch( $params['file'] );
}

/* vim: set expandtab: */

?>
