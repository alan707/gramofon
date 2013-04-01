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

// $route['default_controller'] = '';
// $route['404_override'] = '';

switch ( strtoupper($_SERVER['REQUEST_METHOD']) )
{
    case 'GET':
        $route['users/username_(:any)']         = 'users/show/$1/username';
        $route['users/facebook_(:num)']         = 'users/show/$1/facebook';
        $route['users/(:num)/clips']            = 'clips/show_user_clips/$1';
        $route['users/(:num)/favorites/(:num)'] = 'favorites/show/$1/$2';
        $route['users/(:num)/favorites']        = 'favorites/show_user_favorites/$1';
        $route['users/(:num)/following/(:num)'] = 'follows/show/$2/$1';
        $route['users/(:num)/following']        = 'follows/show_user_following/$1';
        $route['users/(:num)']                  = 'users/show/$1';
        $route['users']                         = 'users/index';
        $route['clips/(:num)']                  = 'clips/show/$1';
        $route['clips']                         = 'clips/index';
        break;

    case 'POST':
        $route['favorites'] = 'favorites/create';
        $route['following'] = 'follows/create';
        $route['users']     = 'users/create';
        $route['clips']     = 'clips/create';
        break;
    
    case 'PUT':
        $route['users/(:num)'] = 'users/update/$1';
        $route['clips/(:num)'] = 'clips/update/$1';
        break;

    case 'DELETE':
        $route['users/(:num)/favorites/(:num)'] = 'favorites/destroy/$1/$2';
        $route['users/(:num)/following/(:num)'] = 'follows/destroy/$2/$1';
        $route['users/(:num)']                  = 'users/destroy/$1';
        $route['clips/(:num)']                  = 'clips/destroy/$1';
        break;
}
