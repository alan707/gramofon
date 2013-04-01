<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Follow_model extends CI_Model
{

    public function get_user_following( $user_id, $offset = 0, $limit = 10 )
    {        
        $this->load->library('User');

        $following = array();

        $this->db->select(
            'users.id as user_id,'
          . 'users.username as user_username,'
          . 'users.firstname as user_firstname,'
          . 'users.lastname as user_lastname,'
          . 'users.email as user_email,'
          . 'users.facebook_id as user_facebook_id,'
          . 'users.created as user_created'
        );

        $this->db->join( 'users', 'follows.followed_id = users.id' );
        $this->db->where( 'follows.follower_id', $user_id );
        $this->db->order_by( 'users.firstname', 'desc');

        $query = $this->db->get( 'follows', $limit, $offset );

        foreach ( $query->result() as $row ) {
            $following[] = new User( $row );
        }

        return $following;
    }

    public function get_follow( $followed_id, $follower_id )
    {        
        $status = false;

        $this->db->where( 'followed_id', $followed_id );
        $this->db->where( 'follower_id', $follower_id );

        $query = $this->db->get( 'follows' );

        if ( $query->num_rows() > 0 ) {
            $status = true;
        }

        return $status;
    }

    public function create_follow( $followed_id, $follower_id )
    {
        $status = false;

        if ( is_numeric($followed_id) && is_numeric($follower_id)
          && $followed_id != $follower_id ) {
            $sql = "INSERT IGNORE INTO follows ( followed_id, follower_id ) \n"
                .  "VALUES ( $followed_id, $follower_id )";

            if ( $this->db->query($sql) ) {  
                $status = true;
            } else {
                $this->output->set_status_header('500');
            }
        }

        return $status;
    }

    public function remove_follow( $followed_id, $follower_id )
    {
        $success = false;

        $this->db->delete( 'follows', array(
            'followed_id' => $followed_id,
            'follower_id' => $follower_id
        ));

        $follow = $this->get_follow( $followed_id, $follower_id );

        if ( ! $follow ) {
            $success = true;
        }

        return $success;
    }

}