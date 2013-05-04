<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Clip_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();

        $this->load->library('Clip');
        $this->load->library('User');
    }

    public function get_all_clips( $offset = 0, $limit = 10 )
    {
        $clips = array();

        $this->db->select(
            'clips.*,'
          . 'users.id as user_id,'
          . 'users.username as user_username,'
          . 'users.firstname as user_firstname,'
          . 'users.lastname as user_lastname,'
          . 'users.email as user_email,'
          . 'users.facebook_id as user_facebook_id,'
          . 'users.created as user_created'
        );

        $this->db->join( 'users', 'clips.user_id = users.id' );
        $this->db->order_by( 'clips.created', 'desc');

        $query = $this->db->get( 'clips', $limit, $offset );

        foreach ( $query->result() as $row ) {
            $clips[] = new Clip( $row );
        }

        return $clips;
    }

    public function get_all_user_clips( $user_id, $offset = 0, $limit = 10 )
    {
        $clips = array();

        $this->db->select(
            'clips.*,'
          . 'users.id as user_id,'
          . 'users.username as user_username,'
          . 'users.firstname as user_firstname,'
          . 'users.lastname as user_lastname,'
          . 'users.email as user_email,'
          . 'users.facebook_id as user_facebook_id,'
          . 'users.created as user_created'
        );

        $this->db->join( 'users', 'clips.user_id = users.id' );
        $this->db->where( 'user_id', $user_id );
        $this->db->order_by( 'clips.created', 'desc');

        $query = $this->db->get( 'clips', $limit, $offset );

        foreach ( $query->result() as $row ) {
            $clips[] = new Clip( $row );
        }

        return $clips;
    }

    public function get_clip( $id )
    {
        $clip = new stdClass;

        $this->db->select(
            'clips.*,'
          . 'users.id as user_id,'
          . 'users.username as user_username,'
          . 'users.firstname as user_firstname,'
          . 'users.lastname as user_lastname,'
          . 'users.email as user_email,'
          . 'users.facebook_id as user_facebook_id,'
          . 'users.created as user_created'
        );

        $this->db->join( 'users', 'clips.user_id = users.id' );

        $query = $this->db->get_where( 'clips', array('clips.id' => $id) );

        if ( $query->num_rows() > 0 ) {
            $clip = new Clip( $query->row() );
        }

        return $clip;
    }

    public function create_clip( $data )
    {
        $new_clip = false;

        $filename = $this->_upload_file();

        if ( $filename ) {
            $clip = new stdClass;

            // required clip properties
            $clip->filename  = $filename;
            $clip->title     = $data['title'];
            $clip->user_id   = $data['user_id'];

            // optional LatLng location properties
            if ( isset($data['latitude']) && isset($data['longitude'])) {
                $clip->latitude  = $data['latitude'];
                $clip->longitude = $data['longitude'];
            }

            // optional venue name property
            if ( isset($data['venue']) ) {
                $clip->venue = $data['venue'];
            }

            $this->db->insert( 'clips', $clip );

            $new_clip_id = $this->db->insert_id();

            if ( $new_clip_id ) {
                $new_clip = $this->get_clip( $new_clip_id );
            }
        }

        return $new_clip;
    }

    // @todo
    // public function update_clip( $id, $data )
    // {
    //     $clip = new stdClass;

    //     $clip->id = $id;

    //     foreach ( $data as $key => $value ) {
    //         if ( property_exists('Clip', $key) ) {
    //             $clip->$key = $value;
    //         }
    //     }

    //     return $clip;
    // }

    public function remove_clip( $id )
    {
        $this->db->delete( 'clips', array('id' => $id) );

        $query = $this->db->get_where( 'clips', array('id' => $id) );

        return ( $query->num_rows() == 0 );
    }

    private function _upload_file()
    {
        $return = false; 

        $filename = $_FILES['audio']['name'];
        $tmp_name = $_FILES['audio']['tmp_name'];

        if ( ! empty($tmp_name) ) {
            $this->load->library('S3');

            S3::setAuth('AKIAIUEHW25WUS5VHGBA', 'InKItKupCGYvsJv3QGrueNnAf96zgLYJL1OdVZBu');

            $return = S3::putObject( S3::inputFile($tmp_name), 'gramofon', 'clips/' . $filename, S3::ACL_PUBLIC_READ );

            if ( $return ) {
                $return = $filename;
            }
        }

        return $return;
    }

}