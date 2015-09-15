<?php
	// $ipaddress=apache_request_headers();
	// print_r($ipaddress);
	foreach (getallheaders() as $name => $value) { 
		echo "$name: $value\n"; 
		echo "<br/>";
	} 
?>