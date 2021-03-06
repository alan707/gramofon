<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/*
| -------------------------------------------------------------------------
| URI ROUTING
| -------------------------------------------------------------------------
| This file lets you re-map URI requests to specific controller functions.
|
| Typically there is a one-to-one relationship between a URL string
| and its corresponding controller class/method. The segments in a
| URL normally follow this pattern:
|
|	example.com/class/method/id/
|
| In some instances, however, you may want to remap this relationship
| so that a different class/function is called than the one
| corresponding to the URL.
|
| Please see the user guide for complete details:
|
|	http://codeigniter.com/user_guide/general/routing.html
|
| -------------------------------------------------------------------------
| RESERVED ROUTES
| -------------------------------------------------------------------------
|
| There area two reserved routes:
|
|	$route['default_controller'] = 'welcome';
|
| This route indicates which controller class should be loaded if the
| URI contains no data. In the above example, the "welcome" class
| would be loaded.
|
|	$route['404_override'] = 'errors/page_missing';
|
| This route will tell the Router what URI segments to use if those provided
| in the URL cannot be matched to a valid route.
|
*/

//$route['clip/([0-9]+)/like']   = 'audio_clip/like/$1';
//$route['clip/([0-9]+)/unlike'] = 'audio_clip/unlike/$1';
$route['clip/([0-9]+)/increment-play-count'] = 'audio_clip/increment_play_count/$1';
$route['clip/([0-9]+)'] = 'audio_clip/index/$1';

$route['logout'] = 'user/logout';

$route['utilities/(:any)'] = 'utilities/$1';

$route['ajax_pagination/(:any)'] = 'home/ajax_pagination/$1';

$route['(:any)'] = 'user/index/$1';

$route['default_controller'] = 'home';
$route['404_override'] = '';

/* End of file routes.php */
/* Location: ./application/config/routes.php */