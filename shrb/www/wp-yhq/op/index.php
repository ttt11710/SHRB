<?php 
	$public_key= '-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7wyvZfgBXs6bBVUTvqyaPglVN
VQDKbiw1/iSbMVlERfFm2jUVy1jG++DChTlMBfOn3Tt7zNtX4t5rk0J2ElchjJnE
7cTwN5+f3JsBArM8YnSYIi4GxazuvzhGgDQIiXHLsQlbsw6WUoOMB8K9phES6Eus
31Bqr5adtMXcJFW43wIDAQAB
-----END PUBLIC KEY-----';
	$private_key= '-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQC7wyvZfgBXs6bBVUTvqyaPglVNVQDKbiw1/iSbMVlERfFm2jUV
y1jG++DChTlMBfOn3Tt7zNtX4t5rk0J2ElchjJnE7cTwN5+f3JsBArM8YnSYIi4G
xazuvzhGgDQIiXHLsQlbsw6WUoOMB8K9phES6Eus31Bqr5adtMXcJFW43wIDAQAB
AoGBALrom4MDKiYjwTEdx+TpNBaRwIadwo7Aw6Pv3NLceic7lQY027lZVoOmguRA
qHvkRNvqn+cqU4MWZSEjU3qj4TTfwVa61RVR25txHiKW7E6WB386MfHv9DSb6Ntz
gPe6qETLjFwL8NbfoGeceSHN9SIywnAFPBwcxtWITZzNDPSJAkEA7ECbAeFsVfNR
39SRa8NzaKafMCvLDSsQSNPQiYyrWM+Hgp+K/ljEgu8kiEHGWvg+qHgaaybxr4tT
IzIecpQW2wJBAMt09rBHi8fleQL3CkVVNyRHKkqQzP0kWmgSYWBooy82ntfHJmTS
P/rtaockFUHFEet7FQL1AcjZT0Xly8lxW00CQHGmlqrt7XbfiYh6ssY7jP5QAY5j
0tdv2vKd6tjwsdEUbKT66Rt4SniOYG2n7qr+du4GcPcREf0XshPhXWJTOTcCQQDK
4e+9CRtSUnnBgycyzC8Ydf6uLIa9R6r/bJS91pojUoxDD8wxbZdvWaCI8mpgE2wz
LaFeOYN2DX0HbocwcWFhAkBmCMYlwIi4On2F/JRgG5QpX1ZqCKHIi0FiUV4bY8Lb
PfV0JbEGYnH4kZb4ScEfwNtpyBJEOBtqC/e6T0V/jYom
-----END RSA PRIVATE KEY-----
';
	// print_r($public_key);
	// die;
	//echo $private_key;  
	$pi_key =  openssl_pkey_get_private($private_key);//这个函数可用来判断私钥是否是可用的，可用返回资源id Resource id  
	$pu_key = openssl_pkey_get_public($public_key);//这个函数可用来判断公钥是否是可用的  
	// print_r($pi_key);echo "|";  
	// print_r($pu_key);echo "|";  
	  
	  
	// $data = "865245625452";//原始数据  
	// $encrypted = "";   
	// $decrypted = "";   
	  
	// echo "source data:",$data,"\n";  
	  
	// echo "private key encrypt:\n";  
	  
	// openssl_private_encrypt($data,$encrypted,$pi_key);//私钥加密  
	// $encrypted = base64_encode($encrypted);//加密后的内容通常含有特殊字符，需要编码转换下，在网络间通过url传输时要注意base64编码是否是url安全的  
	// echo $encrypted,"\n";  
	  
	// // echo "public key decrypt:\n";  
	  
	// openssl_public_decrypt(base64_decode($encrypted),$decrypted,$pu_key);//私钥加密的内容通过公钥可用解密出来  
	// echo $decrypted,"\n";  
	  
	// echo "---------------------------------------\n";  
	// echo "public key encrypt:\n";  
	  
	// openssl_public_encrypt($data,$encrypted,$pu_key);//公钥加密  
	// $encrypted = base64_encode($encrypted);  
	// echo $encrypted,"\n";  
	  
	echo "private key decrypt:\n";  
	openssl_private_decrypt(base64_decode('QyoDI93STgCVO9HUSclrQF9r2U/vTQGFO5R6EkTx0+rLdSbt5Liw4zSUt/GvjIAFKKPtQGHxzjr3rXK5KPiVXt7YJFY3Fb8WzHWjmuK+yV5j/2QezT5ehfS/WHAui9bkY5u5limkLKQ9CAli3rEbaImq+WM+9qJ1+ySTLcSa/gA='),$decrypted,$private_key);//私钥解密  
	echo $decrypted,"\n";  
?>