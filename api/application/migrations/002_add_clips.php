<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Migration_Add_clips extends CI_Migration
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
			'filename' => array(
				'type'           => 'VARCHAR',
				'constraint'     => 255,
			),
			'title' => array(
				'type'           => 'VARCHAR',
				'constraint'     => 255,
			),
			'latitude' => array(
				'type'           => 'DOUBLE PRECISION'
			),
			'longitude' => array(
				'type'           => 'DOUBLE PRECISION'
			),
			'venue' => array(
				'type'           => 'VARCHAR',
				'constraint'     => 255
			),
			'user_id' => array(
				'type'           => 'INT',
				'constraint'     => 20,
				'unsigned'       => true
			),
            'created' => array(
                'type'           => 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP'
            )
		));

        $this->dbforge->add_key( 'id', true );
        $this->dbforge->add_key( 'created' );
        $this->dbforge->add_key( 'user_id' );

        $this->dbforge->create_table('clips');
	}

	public function down()
	{
		$this->dbforge->drop_table('clips');
	}

}