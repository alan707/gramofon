<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

/**
 * Controller for all user requests
 */
class Users extends CI_Controller
{

    /**
     * Upon instantiation, pre-load the user model. 
     */
    public function __construct()
    {
        parent::__construct();

        // auto-load model for controller
        $this->load->model('user_model');
    }

    /**
     * Show all users.
     */
    public function index()
    {
        $users = $this->user_model->get_all_users( 0, 10 );

        $json = json_encode( $users );

        if ( $json ) {
            header('Content-type: application/json');
            echo( $json );
        }
    }

    /**
     * Show a user for a given user ID.
     * @param int $id 
     */
    public function show( $id, $id_type = null )
    {
        $user = $this->user_model->get_user( $id, $id_type );

        $json = json_encode( $user );

        if ( $json ) {
            header('Content-type: application/json');
            echo( $json );
        }
    }

    /**
     * Create a new user from POST data.
     */
    public function create()
    {
        $data = $this->input->post( 'user' );

        if ( $data ) {
            $user = $this->user_model->create_user( $data );

            $json = json_encode( $user );

            if ( $json ) {
                header('Content-type: application/json');
                echo( $json );
            }
        }
    }

    /**
     * Update user from PUT data.
     * @param int $id 
     */
    public function update( $id )
    {
        $data = array();

        $data = $this->input->put( 'user' );

        if ( isset($data) ) {
            $user = $this->user_model->update_user( $id, $data );

            $json = json_encode( $user );

            if ( $json ) {
                header('Content-type: application/json');
                echo( $json );
            }
        }
    }

    /**
     * Destroy user.
     * @param int $id 
     */
    public function destroy( $id )
    {
        $result = $this->user_model->remove_user( $id );

        $json = json_encode( $result );

        if ( $json ) {
            header('Content-type: application/json');
            echo( $json );
        }
    }

    /**
     * Show all likes for a given user ID.
     * @param int $user_id 
     */
    public function show_likes( $user_id )
    {
        $clips = $this->user_model->get_all_likes( $user_id, 0, 10 );

        $json = json_encode( $clips );

        if ( $json ) {
            header('Content-type: application/json');
            echo( $json );
        }
    }

}