<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Clip 
{
    public $id;
    public $url;
    public $title;
    public $latitude;
    public $longitude;
    public $venue;
    public $created;
    public $user;

    public function __construct( $data = null )
    {
    	if ( $data ) {
	    	$this->id        = $data->id;
	    	$this->url       = 'https://gramofon.s3.amazonaws.com/uploads/' . $data->user_username . '/sound_file/' . $data->filename;
	    	$this->title     = $data->title;
	    	$this->latitude  = $data->latitude;
	    	$this->longitude = $data->longitude;
	    	$this->venue     = $data->venue;
	    	$this->created   = $data->created;
	    	$this->user      = new User( $data );
	    }
    }

}