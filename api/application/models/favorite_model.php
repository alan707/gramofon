<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Favorite_model extends CI_Model
{

    public function get_user_favorites( $user_id, $offset = 0, $limit = 10 )
    {
        $this->load->library('Clip');
        $this->load->library('User');

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

        $this->db->join( 'clips', 'favorites.clip_id = clips.id' );
        $this->db->join( 'users', 'favorites.user_id = users.id' );
        $this->db->where( 'favorites.user_id', $user_id );
        $this->db->order_by( 'favorites.created', 'desc');

        $query = $this->db->get( 'favorites', $limit, $offset );

        foreach ( $query->result() as $row ) {
            $clips[] = new Clip( $row );
        }

        return $clips;
    }

    public function get_favorite( $user_id, $clip_id )
    {
        $this->db->select( 'created' );

        $this->db->where( 'user_id', $user_id );
        $this->db->where( 'clip_id', $clip_id );

        $query = $this->db->get( 'favorites' );

        return ( $query->num_rows() > 0 );
    }

    public function create_favorite()
    {
        $favorite = new stdClass;

        $user_id = $this->input->post( 'user_id' );
        $clip_id = $this->input->post( 'clip_id' );

        if ( $user_id && $clip_id ) {
            $favorite = new stdClass;
            $favorite->clip_id = $user_id;
            $favorite->user_id = $clip_id;

            $this->db->insert( 'favorites', $favorite );

            $favorite = $this->get_favorite( $user_id, $clip_id );
        }

        return $favorite;
    }

    public function remove_favorite( $user_id, $clip_id )
    {
        $this->db->delete( 'favorites', array(
            'user_id' => $user_id,
            'clip_id' => $clip_id
        ));

        $favorite = $this->get_favorite( $user_id, $clip_id );

        return ( ! $favorite );
    }

}