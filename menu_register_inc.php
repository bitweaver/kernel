<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_kernel/menu_register_inc.php,v 1.10 2006/09/13 16:13:43 spiderr Exp $
 * @package kernel
 * @subpackage functions
 */

global $gBitUser, $gBitSystem, $gBitSmarty;

// Global menu
//	$gBitSystem->registerAppMenu( 'global', NULL, NULL, 'bitpackage:kernel/menu_global.tpl' );


// Application menu
uasort( $gBitSystem->mAppMenu, "mAppMenu_sort" );

// Admin menu
if( $gBitUser->isAdmin() ) {
	$adminMenu = array();
	foreach( array_keys( $gBitSystem->mPackages ) as $package ) {
		$package = strtolower( $package );
		$tpl = "bitpackage:$package/menu_".$package."_admin.tpl";
		if( ($gBitSystem->isPackageActive( $package ) || $package == 'kernel') && @$gBitSmarty->template_exists( $tpl ) ) {
			$adminMenu[$package]['tpl'] = $tpl;
			$adminMenu[$package]['display'] = 'display:'.( empty( $package ) || ( isset( $_COOKIE[$package.'admenu'] ) && ( $_COOKIE[$package.'admenu'] == 'o' ) ) ? 'block;' : 'none;' );
		}
	}
	ksort( $adminMenu );
	$gBitSmarty->assign_by_ref( 'adminMenu', $adminMenu );
}

function mAppMenu_sort( $a, $b ) {
	if( is_numeric( $a['menu_position'] ) ) {
		return( strcmp( $a['menu_position'], $b['menu_position'] ) );
	} else {
		return( strcmp( $a['menu_title'], $b['menu_title'] ) );
	}
}
?>
