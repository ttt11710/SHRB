<?php
//创建目录
function pb_file_mkdir($dir, $mode = 0777)
{
	if (is_dir($dir) || @mkdir($dir, $mode)) return TRUE;
	if (!mkdirs(dirname($dir), $mode)) return FALSE;
	return @mkdir($dir, $mode);
}

//写入文件
function pb_file_writefile($filename,$content){
	$file = fopen($filename,"w");
	fwrite($file,$content);
	fclose($file);
}

?>