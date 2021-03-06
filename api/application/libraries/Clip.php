<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Clip 
{

    public function __construct( $data = null )
    {
    	if ( $data ) {
	    	$this->id        = $data->id;
	    	$this->url       = 'https://gramofon.s3.amazonaws.com/clips/' .  $data->filename;
	    	$this->title     = $data->title;
	    	$this->latitude  = $data->latitude;
	    	$this->longitude = $data->longitude;
	    	$this->venue     = $data->venue;
	    	$this->created   = $data->created;
	    	$this->user      = new User( $data );
	    }
    }

}