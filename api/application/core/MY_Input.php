<?php  if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

/**
 * Extending core CI Input class to add support for PUT vars.
 */
class MY_Input extends CI_Input
{

    /**
    * Fetch an item from the POST array
    *
    * @access   public
    * @param    string
    * @param    bool
    * @return   string
    */
    public function put( $index = NULL, $xss_clean = FALSE )
    {
        $data = array();

        // Parse PUT vars
        parse_str( file_get_contents( 'php://input' ), $data );

        // Check if a field has been provided
        if ( $index === NULL && ! empty( $data ) ) {
            $put = array();

            // Loop through the full PUT array and return it
            foreach ( array_keys( $data ) as $key ) {
                $put[$key] = $this->_fetch_from_array( $data, $key, $xss_clean );
            }

            return $put;
        }

        return $this->_fetch_from_array( $data, $index, $xss_clean );
    }
        
}