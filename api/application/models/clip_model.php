<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Clip_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();

        $this->load->library('Clip');
    }

    public function get_all_clips( $offset = 0, $limit = 10 )
    {
        $clips = array();

        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;

        return $clips;
    }

    public function get_all_user_clips( $user_id, $offset = 0, $limit = 10 )
    {
        $clips = array();

        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;

        return $clips;
    }

    public function get_clip( $id )
    {
        $clip = new Clip;

        return $clip;
    }

    public function create_clip( $data )
    {
        $clip = new Clip;

        $clip->id        = 1;
        $clip->title     = $data['title'];
        $clip->user_id   = $data['user_id'];
        $clip->latitude  = $data['latitude'];
        $clip->longitude = $data['longitude'];

        return $clip;
    }

    public function update_clip( $id, $data )
    {
        $clip = new Clip;

        $clip->id = $id;

        foreach ( $data as $key => $value ) {
            if ( property_exists('Clip', $key) ) {
                $clip->$key = $value;
            }
        }

        return $clip;
    }

    public function remove_clip( $id )
    {
        return true;
    }

}