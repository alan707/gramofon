<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Migration_Add_follows extends CI_Migration
{

    public function up()
    {
        $this->dbforge->add_field(array(
            'followed_id' => array(
                'type'       => 'INT',
                'constraint' => 20,
                'unsigned'   => true
            ),
            'follower_id' => array(
                'type'       => 'INT',
                'constraint' => 20,
                'unsigned'   => true
            ),
            'created' => array(
                'type'       => 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP'
            )
        ));

        $this->dbforge->add_key( array('followed_id', 'follower_id'), true );
        $this->dbforge->add_key( array('followed_id') );
        $this->dbforge->add_key( array('follower_id') );
        $this->dbforge->create_table( 'follows' );
    }

    public function down()
    {
        $this->dbforge->drop_table( 'follows' );
    }

}