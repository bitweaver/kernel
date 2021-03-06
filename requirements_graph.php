<?php
/**
 * @version $Header$
 * @package kernel
 * @subpackage functions
 */

/**
 * Setup
 */
require_once( '../kernel/includes/setup_inc.php' );
$gBitSystem->verifyPermission( 'p_admin' );
global $gBitInstaller;
$gBitInstaller = &$gBitSystem;
$gBitInstaller->verifyInstalledPackages();
$gBitInstaller->drawRequirementsGraph( !empty( $_REQUEST['install_version'] ), ( !empty( $_REQUEST['format'] ) ? $_REQUEST['format'] : 'png' ), ( !empty( $_REQUEST['command'] ) ? $_REQUEST['command'] : 'dot' ));
?>
