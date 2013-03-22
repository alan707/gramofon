<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Migrate extends CI_Controller 
{

	public function __construct()
	{
		parent::__construct();
		
        $this->load->library('migration');		
	}
        
    public function index()
    {
        if ( $this->migration->latest() ) {
            echo('DB migrated to latest version.');
        } else {
            show_error($this->migration->error_string());
        }
    }
    
    public function version( $version )
    {
        if ( $this->migration->version($version) ) {            
            echo("DB migrated to version $version.");
        } else {
            show_error($this->migration->error_string());
        }
    }
    
}