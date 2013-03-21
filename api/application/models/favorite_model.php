<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Favorite_model extends CI_Model
{

    public function get_all_favorites( $offset = 0, $limit = 10 )
    {
        $this->load->library('Clip');

        $clips = array();

        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;

        return $clips;
    }

    public function get_user_favorites( $user_id, $offset = 0, $limit = 10 )
    {
        $this->load->library('Clip');

        $clips = array();

        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;
        $clips[] = new Clip;

        return $clips;
    }

    public function get_favorite( $user_id, $clip_id )
    {
        $status = false;

        return $status;
    }

    public function create_favorite( $user_id, $clip_id )
    {
        $status = true;

        return $status;
    }

    public function remove_favorite( $user_id, $clip_id )
    {
        return true;
    }

}