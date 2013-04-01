<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

/**
 * Controller for all follow requests
 */
class Follows extends CI_Controller
{

    /**
     * Upon instantiation, pre-load the user model. 
     */
    public function __construct()
    {
        parent::__construct();

        header( 'Content-type: application/json' );

        // auto-load model for controller
        $this->load->model( 'follow_model' );
    }

    /**
     * Show all users that a given user is following.
     * @param int $user_id 
     */
    public function show_user_following( $user_id )
    {
        $offset = $this->input->get( 'offset' );
        $limit  = $this->input->get( 'limit' );

        $offset = ( $offset ) ? $offset : 0;
        $limit  = ( $limit ) ? $limit : 10;

        $follows = $this->follow_model->get_user_following( $user_id, $offset, $limit );

        $json = json_encode( $follows );

        if ( $json ) {
            header( 'Content-type: application/json' );
            echo( $json );
        }
    }

    /**
     * Show follow relationship status for a followed user ID & follower user ID.
     * @param int $followed_id 
     * @param int $follower_id 
     */
    public function show( $followed_id, $follower_id )
    {
        $follow = $this->follow_model->get_follow( $followed_id, $follower_id );

        $json = json_encode( $follow );

        if ( $json ) {
            header( 'Content-type: application/json' );
            echo( $json );
        }
    }

    /**
     * Create a new follow relationship from POST data.
     */
    public function create()
    {
        $followed_id = $this->input->post( 'followed_id' );
        $follower_id = $this->input->post( 'follower_id' );

        if ( $followed_id && $follower_id ) {
            $follow = $this->follow_model->create_follow( $followed_id, $follower_id );

            $json = json_encode( $follow );

            if ( $json ) {
                header( 'Content-type: application/json' );
                echo( $json );
            }
        }
    }

    /**
     * Destroy follow relationship.
     * @param int $followed_id 
     * @param int $follower_id 
     */
    public function destroy( $followed_id, $follower_id )
    {
        $result = $this->follow_model->remove_follow( $followed_id, $follower_id );

        $json = json_encode( $result );

        if ( $json ) {
            header( 'Content-type: application/json' );
            echo( $json );
        }
    }

}