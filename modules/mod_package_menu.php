<?php
/**
 * @package kernel
 * @subpackage modules
 */
global $gBitSystem;
if( ACTIVE_PACKAGE == 'messu' ) {
	$active = 'users';
} else {
	$active = ACTIVE_PACKAGE;
}

if( !empty( $gBitSystem->mAppMenu[$active]['template'] ) ) {
	$gBitSmarty->assign( 'packageMenu', $gBitSystem->mAppMenu[$active] );
}
?>
