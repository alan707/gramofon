<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Migration_Add_likes extends CI_Migration
{

    public function up()
    {
        $this->dbforge->add_field(array(
            'clip_id' => array(
                'type'       => 'INT',
                'constraint' => 20,
                'unsigned'   => true
            ),
            'user_id' => array(
                'type'       => 'INT',
                'constraint' => 20,
                'unsigned'   => true
            ),
            'created' => array(
                'type'       => 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP'
            )
        ));

        $this->dbforge->add_key( array('clip_id', 'user_id'), true );
        $this->dbforge->create_table( 'clips' );
    }

    public function down()
    {
        $this->dbforge->drop_table('clips');
    }

}