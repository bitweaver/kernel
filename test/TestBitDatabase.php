<?php
require_once('bit_setup_inc.php');

class TestBitDatabase extends UnitTestCase {

    var $test;
    var $now;
    var $name = "`TestTikiDatabase`";

    var $tables = array("TestTikiDatabase" => 
                        "`uniqueId` I4 AUTO PRIMARY,
		         `someText` C(15),
		         `someDate` I8,
		         `someBlob` B");
    
    var $data = "GIF89a  ¢     ÿÿÿÿ   ÿ  ÿÿÿ      !ù   ,       -D£ÑkÈI¡4¼©;éZE-dUèÍ&¹ËåRlvFï¼ÞÓpþ ;";

    function TestBitDatabase ()
    {
        global $gBitDb;
        $this->test = $gBitDb;
	$this->now = date("U");
    }


    function setUp ()
    {
	// Drop the test table, if tear down have failed
	$tables = array($this->name);
	$this->test->dropTables($tables);
    }

    function tearDown ()
    {
	// Drop the test table
	$tables = array($this->name);
	$this->test->dropTables($tables);
    }

    // Helpers
    function createTable()
    {
	$this->test->createTables($this->tables);

        #if($this->test->tableExists($this->name)) {
	#    // simepletest should have a assertFail
	#    $this->assertTrue(false, 'Skipped - test table already exists');
	#    return;
        #}
    }


    function insertData()
    {
	$this->createTable ();

	$query = "INSERT INTO " . $this->name . " (`someText`, `someDate`) VALUES (?,?)";
	$bindvars = array("abc", (int)$this->now);
        $result = $this->test->query($query, $bindvars);
	$bindvars = array("xyz", 1234);
	$this->test->query($query, $bindvars);
	$bindvars = array("ABC", 6789);
	$this->test->query($query, $bindvars);
    }


    // tests

    function testTableExists()
    {
	$table = array($this->name);
        $this->assertFalse($this->test->tableExists($table),
			   'Error test table already exists');
    }


    function testCreateTable()
    {
	$this->createTable ();
        $this->assertFalse($this->test->tableExists($this->tables));
    }


    function testQStr()
    {
        $x = " ' \" 123 \" ' ";
        $this->assertEqual($this->test->qstr($x), "' \' \\\" 123 \\\" \' '");
    }



    function testInsertData()
    {
	$this->createTable ();
	
	$query = "INSERT INTO " . $this->name . " (`someText`, `someDate`) VALUES (?,?)";
	$bindvars = array("abc", (int)$this->now);
        $result = $this->test->query($query, $bindvars);
        $this->assertTrue(is_object($result));
    }



    function testSelectData()
    {
	$this->insertData ();
	$query = "SELECT * FROM " . $this->name;
        $result = $this->test->query($query);
        $this->assertEqual($result->numRows(), 3);
    }


    function testGetOneField()
    {
	$this->insertData ();
	$query = "SELECT `someText` FROM " . $this->name . " WHERE `someDate` = ?";
	$bindvars = array(6789);
        $result = $this->test->getOne($query, $bindvars);
        $this->assertEqual($result, "ABC");
    }


    function testDeleteData()
    {
	$this->insertData ();
	$query = "DELETE FROM " . $this->name;
        $result = $this->test->query($query);
        $this->assertEqual($result, true);
    }


    function testEncodeBlob()
    {
	$this->insertData ();
	$data = $this->data;
	$now = '1234';
	$query = "INSERT INTO " . $this->name . " (`someBlob`, `someDate`) VALUES (?,?)";
	$bindvars = array($this->test->dbByteEncode($data), (int)$now);
        $result = $this->test->query($query, $bindvars);
        $this->assertTrue(is_object($result));
    }


    function testDecodeBlob()
    {
	// $this->insertData (); //should perhaps have a test for this too

	$this->createTable ();
	$data = $this->data;
        $now = '1234';

	// Insert the Blob we want to decode
	$query = "INSERT INTO " . $this->name . " (`someBlob`, `someDate`) VALUES (?,?)";
	$encodedData =$this->test->dbByteEncode($data);
	$this->assertNotNull($encodedData); #???
	$bindvars = array($encodedData, (int)$now);
        $result = $this->test->query($query, $bindvars);
        $this->assertTrue(is_object($result)); # makes error reporting sensible

	// Get and decode the Blob
	$query2 = "SELECT `someBlob` FROM " . $this->name . " WHERE `someDate` = ?";

        $bindvars2 = array($now);
        $result2 = $this->test->getOne($query2, $bindvars2);
        $this->assertTrue(is_object($result2)); #makes error reporting sensible
	$data = $this->data;
        $this->assertEqual($this->test->dbByteDecode($result2), $data);
    }


    function testDropTable()
    {
	$tables = array($this->name);
        $this->assertTrue($this->test->dropTables($tables));
    }
}
?>