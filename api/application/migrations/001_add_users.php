<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Migration_Add_users extends CI_Migration
{

	public function up()
	{
		$this->dbforge->add_field(array(
			'id' => array(
				'type'           => 'INT',
				'constraint'     => 20,
				'unsigned'       => true,
				'auto_increment' => true
			),
			'username' => array(
				'type'           => 'VARCHAR',
				'constraint'     => 255,
			),
			'firstname' => array(
				'type'           => 'VARCHAR',
				'constraint'     => 255,
			),
			'lastname' => array(
				'type'           => 'VARCHAR',
				'constraint'     => 255,
			),
			'email' => array(
				'type'           => 'VARCHAR',
				'constraint'     => 255,
			),
			'facebook_id' => array(
				'type'           => 'INT',
				'constraint'     => 40,
				'unsigned'       => true
			),
            'created' => array(
                'type'           => 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP'
            )
		));

        $this->dbforge->add_key( 'id', true );
        $this->dbforge->add_key( 'username' );
        $this->dbforge->add_key( 'facebook_id' );

        $this->dbforge->create_table('users');
	}

	public function down()
	{
		$this->dbforge->drop_table('users');
	}

}