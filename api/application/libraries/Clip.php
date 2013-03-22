<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Clip 
{
    public $id;
    public $filename;
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
	    	$this->filename  = $data->filename;
	    	$this->title     = $data->title;
	    	$this->latitude  = $data->latitude;
	    	$this->longitude = $data->longitude;
	    	$this->venue     = $data->venue;
	    	$this->created   = $data->created;
	    	$this->user      = new User( $data );
	    }
    }

}