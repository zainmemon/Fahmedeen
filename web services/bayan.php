<?php

//header('Access-Control-Allow-Origin: *');
//header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept');

$servername = "localhost";
$username = "fahmedee_zain";
$password = "~-)(0wrP53(c";
$dbname = "fahmedee_fahm";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);
// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
$type = $_GET['type'];

		if($type=='ramdhan'){
					$query = "select * from bayans WHERE (sectionofbayan like '%tafseerequran201%' or sectionofbayan like '%malfuzat201%' or sectionofbayan like '%hadith201%' or sectionofbayan like '%eitikaf201%') and bayanname != '' order by time desc LIMIT 50";
			$result = mysqli_query($conn,$query)
			or die ("Couldn’t execute query.");
			
			}
			
			elseif($type=='others'){
					$query = "select * from bayans where sectionofbayan != 'ramdhan' and sectionofbayan != 'malfoozat' and sectionofbayan != 'quran' and sectionofbayan != 'eitikaf' and sectionofbayan != 'hadith' and sectionofbayan != 'sunday' and sectionofbayan != 'hadith' and sectionofbayan != 'morningquran' and sectionofbayan != 'tusmani' and sectionofbayan != 'nazam' and bayanname != '' order by time desc LIMIT 50";
			$result = mysqli_query($conn,$query)
			or die ("Couldn’t execute query.");
			
			}		
			else{
					$query = "select * from bayans WHERE sectionofbayan like '%$type%' and bayanname != '' order by time desc LIMIT 50";
			$result = mysqli_query($conn,$query)
			or die ("Couldn’t execute query.");
			
			}
	//		else{
	//				$query = "select * from bayans WHERE sectionofbayan like '%$type%' and bayanname != '' order by time desc LIMIT 50";
	//		$result = mysqli_query($conn,$query)
	//		or die ("Couldn’t execute query.");
	//		}
		//$sql = "SELECT bayanname FROM bayans where sectionofbayan = '$type' order by id DESC LIMIT 30";

	//$result = mysqli_query($conn, $sql);

if ($result->num_rows > 0) {
    // output data of each row
	//$jsonArray = array('bayan' => "zain");
	$tempArray = array();
    while($row = mysqli_fetch_assoc($result)) {
		//$tempArray = json_decode($jsonArray, true);
		$bayan = array();
        $bayan["name"] = $row["bayanname"];
        $bayan["link"] = $row['sectionofbayan']."/".str_replace(".ram",".mp3",$row['linkofbayan']);
		
		array_push($tempArray, $bayan);
		//array_push($jsonArray,$row["bayanname"]);
		
    }
	echo json_encode($tempArray);
} else {
    echo "0 results";
}


mysqli_close($conn);
?>