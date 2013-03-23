<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class User
{

    public function __construct( $data = null )
    {
    	if ( $data ) {
	    	$this->id          = $data->user_id;
	    	$this->username    = $data->user_username;
	    	$this->firstname   = $data->user_firstname;
	    	$this->lastname    = $data->user_lastname;
	    	$this->email       = $data->user_email;
	    	$this->facebook_id = $data->user_facebook_id;
	    	$this->created     = $data->user_created;
	    }
    }

}