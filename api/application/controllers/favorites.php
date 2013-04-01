<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

/**
 * Controller for all favorite requests
 */
class Favorites extends CI_Controller
{

    /**
     * Upon instantiation, pre-load the user model. 
     */
    public function __construct()
    {
        parent::__construct();

        header( 'Content-type: application/json' );

        // auto-load model for controller
        $this->load->model( 'favorite_model' );
    }

    /**
     * Show all favorites.
     */
    public function index()
    {
        $offset = $this->input->get( 'offset' );
        $limit  = $this->input->get( 'limit' );

        $offset = ( $offset ) ? $offset : 0;
        $limit  = ( $limit ) ? $limit : 10;

        $favorites = $this->favorite_model->get_all_favorites( $offset, $limit );

        $json = json_encode( $favorites );

        if ( $json ) {
            echo( $json );
        }
    }

    /**
     * Show all favorites for a given user ID.
     * @param int $user_id 
     */
    public function show_user_favorites( $user_id )
    {
        $offset = $this->input->get( 'offset' );
        $limit  = $this->input->get( 'limit' );

        $offset = ( $offset ) ? $offset : 0;
        $limit  = ( $limit ) ? $limit : 10;

        $favorites = $this->favorite_model->get_user_favorites( $user_id, $offset, $limit );

        $json = json_encode( $favorites );

        if ( $json ) {
            header( 'Content-type: application/json' );
            echo( $json );
        }
    }

    /**
     * Show favorite status for a given user ID & clip ID.
     * @param int $user_id 
     * @param int $clip_id 
     */
    public function show( $user_id, $clip_id )
    {
        $favorite = $this->favorite_model->get_favorite( $user_id, $clip_id );

        $json = json_encode( $favorite );

        if ( $json ) {
            header( 'Content-type: application/json' );
            echo( $json );
        }
    }

    /**
     * Create a new favorite from POST data.
     */
    public function create()
    {
        $user_id = $this->input->post( 'user_id' );
        $clip_id = $this->input->post( 'clip_id' );

        if ( $user_id && $clip_id ) {
            $favorite = $this->favorite_model->create_favorite( $user_id, $clip_id );

            $json = json_encode( $favorite );

            if ( $json ) {
                header( 'Content-type: application/json' );
                echo( $json );
            }
        }
    }

    /**
     * Destroy favorite.
     * @param int $user_id 
     * @param int $clip_id 
     */
    public function destroy( $user_id, $clip_id )
    {
        $result = $this->favorite_model->remove_favorite( $user_id, $clip_id );

        $json = json_encode( $result );

        if ( $json ) {
            header( 'Content-type: application/json' );
            echo( $json );
        }
    }

}