<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

/**
 * Controller for all clip requests
 */
class Clips extends CI_Controller
{

	/**
	 * Upon instantiation, pre-load the C\clip model. 
	 */
	public function __construct()
	{
		parent::__construct();

		// auto-load model for controller
		$this->load->model('clip_model');
	}

	/**
	 * Show all clips.
	 */
	public function index()
	{
		$offset = $this->input->get( 'offset' );
		$limit  = $this->input->get( 'limit' );

		$offset = ( $offset ) ? $offset : 0;
		$limit  = ( $limit ) ? $limit : 10;

		$clips = $this->clip_model->get_all_clips( $offset, $limit );

		$json = json_encode( $clips );

		if ( $json ) {
        	header('Content-type: application/json');
			echo( $json );
		}
	}

	/**
	 * Show all clips for a given user ID.
	 * @param int $user_id 
	 */
	public function show_user_clips( $user_id )
	{
		$offset = $this->input->get( 'offset' );
		$limit  = $this->input->get( 'limit' );

		$offset = ( $offset ) ? $offset : 0;
		$limit  = ( $limit ) ? $limit : 10;

		$clips = $this->clip_model->get_all_user_clips( $user_id, $offset, $limit );

		$json = json_encode( $clips );

		if ( $json ) {
        	header('Content-type: application/json');
			echo( $json );
		}
	}

	/**
	 * Show a clip for a given clip ID.
	 * @param int $id 
	 */
	public function show( $id )
	{
		$clip = $this->clip_model->get_clip( $id );

		$json = json_encode( $clip );

		if ( $json ) {
        	header('Content-type: application/json');
			echo( $json );
		}
	}

	/**
	 * Create a new clip from POST data.
	 */
	public function create()
	{
		$data = $this->input->post( 'clip' );

		if ( $data ) {
			$clip = $this->clip_model->create_clip( $data );

			$json = json_encode( $clip );

			if ( $json ) {
        		header('Content-type: application/json');
				echo( $json );
			}
		}
	}

	/**
	 * Update clip from PUT data.
	 * @param int $id 
	 */
	public function update( $id )
	{
		$data = $this->input->put( 'clip' );

		if ( isset($data) ) {
			$clip = $this->clip_model->update_clip( $id, $data );

			$json = json_encode( $clip );

			if ( $json ) {
	        	header('Content-type: application/json');
				echo( $json );
			}
		}
	}

	/**
	 * Destroy clip.
	 * @param int $id 
	 */
	public function destroy( $id )
	{
		$result = $this->clip_model->remove_clip( $id );

		$json = json_encode( $result );

		if ( $json ) {
        	header('Content-type: application/json');
			echo( $json );
		}
	}


    /**
     * Show all clips by users followed by the given user ID
     * @param int $user_id 
     */
    public function show_user_following( $user_id )
    {
        $offset = $this->input->get( 'offset' );
        $limit  = $this->input->get( 'limit' );

        $offset = ( $offset ) ? $offset : 0;
        $limit  = ( $limit ) ? $limit : 10;

        $follows = $this->clip_model->get_user_following( $user_id, $offset, $limit );

        $json = json_encode( $follows );

        if ( $json ) {
            header( 'Content-type: application/json' );
            echo( $json );
        }
    }

}