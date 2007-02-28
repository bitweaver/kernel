<?php
/**
 * @package kernel
 * @subpackage functions
 */

/**
 * required setup
 */
$config_file = empty( $_SERVER['CONFIG_INC'] ) ? BIT_ROOT_PATH.'kernel/config_inc.php' : $_SERVER['CONFIG_INC'];

if( file_exists( $config_file ) ) {
	include_once( $config_file );
}
// If these weren't defined in config_inc, let's define the now
if( !defined( 'BIT_DB_PREFIX' ) ) {
	define( 'BIT_DB_PREFIX', '' );
}
if( (!isset($gBitDbHost)) || empty($gBitDbHost) ) {
	$gBitDbHost   = 'localhost';
}
if( !defined( 'DEFAULT_THEME' ) ) {
	define( 'DEFAULT_THEME', 'basic' );
}
if( !defined( 'DEFAULT_ICON_STYLE' ) ) {
	define( 'DEFAULT_ICON_STYLE', 'tango' );
}
if( !defined( 'BIT_QUERY_CACHE_TIME' ) ) {
	define( 'BIT_QUERY_CACHE_TIME', 86400 );
}
if( !defined( 'DISPLAY_ERRORS' ) ) {
	define( 'DISPLAY_ERRORS', 0 );
}

// Empty PHP_SELF and incorrect SCRIPT_NAME due to php-cgiwrap - wolff_borg
if( empty( $_SERVER['PHP_SELF'] ) ) {
	$_SERVER['PHP_SELF'] = $_SERVER['SCRIPT_NAME'] = $_SERVER['SCRIPT_URL'];
}

// this is broken if the virtual directory under the webserver is
// not the same name as the physical directory on the drive - wolff_borg

// Responding to Wolff, won't the following do what we want?
//   dirname(dirname($_SERVER['PHP_SELF'])) . '/'
// Am I missing something?  --drc
//
// The recent changes have caused problems during installation. i'll try 
// combining both methods by applying the less successful one after the more 
// successful one - xing
if( !defined( 'BIT_ROOT_URL' ) ) {
	// version one which seems to only cause problems seldomly
	preg_match( '/.*'.basename( dirname( dirname( __FILE__ ) ) ).'\//', $_SERVER['PHP_SELF'], $match );
	$subpath = ( isset($match[0] ) ) ? $match[0] : '/';
	// version two which doesn't work well on it's own
	if( $subpath == "/" ) {
		$subpath = dirname( dirname( $_SERVER['PHP_SELF'] ) );
		$subpath .= ( substr( $subpath,-1,1 )!='/' ) ? '/' : '';
	}
	$subpath = str_replace( '//', '/', str_replace( "\\", '/', $subpath ) ); // do some de-windows-ification
	define( 'BIT_ROOT_URL', $subpath );
}

if( !defined( 'BIT_SESSION_NAME' ) ) {
	define( 'BIT_SESSION_NAME', 'BWSESSION' );
}
if( !defined( 'BIT_PHP_ERROR_REPORTING' ) ) {
	define( 'BIT_PHP_ERROR_REPORTING', E_ALL );
}
// This should *only* be changed if you are certain you know what you are doing.
if( !defined( 'ROOT_USER_ID' ) ) {
	define( 'ROOT_USER_ID', 1 );
}
// This should *only* be changed if you are certain you know what you are doing.
if( !defined( 'ANONYMOUS_USER_ID' ) ) {
	define( 'ANONYMOUS_USER_ID', -1 );
}
// This should *only* be changed if you are certain you know what you are doing.
if( !defined( 'ANONYMOUS_GROUP_ID' ) ) {
	define( 'ANONYMOUS_GROUP_ID', -1 );
}
// $gPreScan can be used to specify the order in which packages are scanned by the kernel.
// In the example provided below, the kernel package is processed first, followed by the users and liberty packages.
// Any packages not specified in $gPreScan are processed in the traditional order
global $gPreScan;
if( empty( $gPreScan ) ) {
	$gPreScan = array( 'kernel', 'users', 'liberty', 'themes' );
}

// when running scripts
global $gShellScript;
if( !empty( $gShellScript ) ) {
	// keep notices quiet
	$_SERVER['SCRIPT_URL'] = '';
	$_SERVER['HTTP_HOST'] = 'localhost';
	$_SERVER['HTTP_USER_AGENT'] = 'cron';
	$_SERVER['SERVER_NAME'] = '';
	$_SERVER['HTTP_SERVER_VARS'] = '';
}

// here we set the default thumbsizes we use in bitweaver.
// you can override these by populating this hash in your kernel/config_inc.php
global $gThumbSizes;
if( empty( $gThumbSizes )) {
	$gThumbSizes = array(
		'icon'   => array( 'width' => 48,  'height' => 48 ),
		'avatar' => array( 'width' => 100, 'height' => 100 ),
		'small'  => array( 'width' => 160, 'height' => 120 ),
		'medium' => array( 'width' => 400, 'height' => 300 ),
		'large'  => array( 'width' => 800, 'height' => 600 ),
	);
}
?>
