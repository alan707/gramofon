<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Super simple REST client library.
 * @author Dan Trenz <dan.trenz@rovicorp.com>
 */
class RESTClient {
    
    public static function get( $uri )
    {
        return self::_call($uri, NULL, 'GET');
    }
    
    public static function post( $uri, $data = array() )
    {
        return self::_call($uri, $data, 'POST');
    }
    
    public static function put( $uri, $data = array() )
    {
        return self::_call($uri, $data, 'PUT');
    }
    
    public static function delete( $uri, $data = array() )
    {
        return self::_call($uri, $data, 'DELETE');
    }
    
    private static function _call( $uri, $data = array(), $http_method = 'GET' )
    {               
        $ch = curl_init($uri);
        
        curl_setopt_array($ch, array(
            CURLOPT_RETURNTRANSFER => TRUE,
            CURLOPT_CONNECTTIMEOUT => 10,
            CURLOPT_TIMEOUT        => 10,
            CURLOPT_CUSTOMREQUEST  => $http_method
        ));
        
        if ( !empty($data) ) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        }
        
        if ( ENVIRONMENT == 'development' && function_exists('get_instance') ) {
            $CI =& get_instance();
            
            $label = parse_url($uri, PHP_URL_PATH) . ' (' . mt_rand() . ')';
            
            $CI->benchmark->mark($label . '_start');
        }
        
        $response = curl_exec($ch);
        
        if ( isset($CI) ) {
            $CI->benchmark->mark($label . '_end');
        }

        curl_close($ch);
        
        return $response;
    }
    
}