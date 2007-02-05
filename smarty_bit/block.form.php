<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */

/**
 * Smarty {form} block plugin
 *
 * Type:     block
 * Name:     form
 * Input:
 *           - ipackage    (optional) - package where we should direct the form after submission
 *           - ifile       (optional) - file that is targetted
 *           - ianchor     (optional) - move to anchor after submitting
 *                         if neither are set, $PHP_SELF is used as url
 *           - legend      if set, it will generate a fieldset using the input as legend
 * @uses smarty_function_escape_special_chars()
 * @todo somehow make the variable that is contained within $iselect global --> this will allow importing of outside variables not set in $_REQUEST
 */
function smarty_block_form($params, $content, &$gBitSmarty) {
	global $gBitSystem;

	if( $content ) {
		if( !isset( $params['method'] ) ) {
			$params['method'] = 'post';
		}
		$atts = '';
		if( isset( $params['secure'] ) && $params['secure'] ) {
			// This is NEEDED to enforce HTTPS secure logins!
			$url = 'https://' . $_SERVER['HTTP_HOST'];
		} else {
			$url = '';
		}

		foreach( $params as $key => $val ) {
			switch( $key ) {
				case 'ifile':
				case 'ipackage':
					if( $key == 'ipackage' ) {
						if( $val == 'root' ) {
							$url .= BIT_ROOT_URL.$params['ifile'];
						} else {
							$url .= constant( strtoupper( $val ).'_PKG_URL' ).$params['ifile'];
						}
					}
					break;
				case 'legend':
					if( !empty( $val ) ) {
						$legend = '<legend>'.tra( $val ).'</legend>';
					}
					break;
				// this is needed for backwards compatibility since we sometimes pass in a url
				case 'action':
					if( substr( $val, 0, 4 ) == 'http' ) {
						if( isset( $params['secure'] ) && $params['secure'] && (substr( $val, 0, 5 ) != 'https')) {
							$val = preg_replace('/^http/', 'https', $val);
						}
						$url = $val;
					} else {
						$url .= $val;
					}
					break;
				case 'ianchor':
				case 'secure':
					break;
				default:
					if( !empty( $val ) ) {
						$atts .= $key.'="'.$val.'" ';
					}
					break;
			}
		}
		if( !isset( $url ) || empty( $url ) ) {
			$url = $_SERVER['PHP_SELF'];
		} else if( $url == 'https://' . $_SERVER['HTTP_HOST'] ) {
			$url .= $_SERVER['PHP_SELF'];
		}
		$ret = '<form action="'.$url.( !empty( $params['ianchor'] ) ? '#'.$params['ianchor'] : '' ).'" '.$atts.'>';
		$ret .= isset( $legend ) ? '<fieldset>'.$legend : '<div>';		// adding the div makes it easier to be xhtml compliant
		$ret .= $content;
		$ret .= '<div class="clear"></div>';							// needed to avoid rendering issues
		$ret .= isset( $legend ) ? '</fieldset>' : '</div>';			// close the open tags
		$ret .= '</form>';
		return $ret;
	}
}
?>
