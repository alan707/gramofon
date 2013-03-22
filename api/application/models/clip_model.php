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

        $query = $this->db->get( 'clips', $limit, $offset );

        foreach ( $query->result() as $clip ) {
            $clips[] = $clip;
        }

        return $clips;
    }

    public function get_all_user_clips( $user_id, $offset = 0, $limit = 10 )
    {
        $clips = array();

        $this->db->where( 'user_id', $user_id );

        $query = $this->db->get( 'clips', $limit, $offset );

        foreach ( $query->result() as $clip ) {
            $clips[] = $clip;
        }

        return $clips;
    }

    public function get_clip( $id )
    {
        $clip = new stdClass;

        $this->db->join( 'users', 'clips.user_id = users.id' );

        $query = $this->db->get_where( 'clips', array('clips.id' => $id) );

        if ( $query->num_rows() > 0 ) {
            $data = $query->row();

            $clip->id        = $data->id;
            $clip->file_url  = $data->file_url;
            $clip->title     = $data->title;
            $clip->latitude  = $data->latitude;
            $clip->longitude = $data->longitude;
            $clip->venue     = $data->venue;
            // $clip->created   = $data->created;

            $clip->user = new stdClass;
            $clip->user->id          = $data->user_id;
            $clip->user->username    = $data->username;
            $clip->user->first_name  = $data->first_name;
            $clip->user->last_name   = $data->last_name;
            $clip->user->email       = $data->email;
            $clip->user->facebook_id = $data->facebook_id;
            // $clip->user->created     = $data->user_id;
        }

        return $clip;
    }

    public function create_clip( $data )
    {
        $new_clip = new stdClass;

        // @todo: upload file data to S3
        // @todo: add errors

        $clip = new stdClass;
        $clip->title     = $data['title'];
        $clip->user_id   = $data['user_id'];
        $clip->latitude  = $data['latitude'];
        $clip->longitude = $data['longitude'];
        $clip->venue     = $data['venue'];
        $clip->user_id   = $data['user_id'];

        $this->db->insert( 'clips', $clip );

        $new_clip_id = $this->db->insert_id();

        if ( $new_clip_id ) {
            $new_clip = $this->get_clip( $new_clip_id );
        }

        return $new_clip;
    }

    // @todo
    public function update_clip( $id, $data )
    {
        $clip = new stdClass;

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
        $this->db->delete( 'clips', array('id' => $id) );

        $query = $this->db->get_where( 'clips', array('id' => $id) );

        return ( $query->num_rows() == 0 );
    }

}