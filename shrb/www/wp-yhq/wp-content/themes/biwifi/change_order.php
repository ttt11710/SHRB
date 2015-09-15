<?php
// File Security Check
if ( ! empty( $_SERVER['SCRIPT_FILENAME'] ) && basename( __FILE__ ) == basename( $_SERVER['SCRIPT_FILENAME'] ) ) {
    die ( 'You do not have sufficient permissions to access this page!' );
}
?>

<?php
/**
    Template Name:change_order
  */

	$order_id = $_POST['orderid'];

	function change_order_status($orderid){
		$order =  new WC_Order($orderid);
		$order->update_status("cancelled","已取消");
		echo '取消成功';
	}
	 change_order_Status($order_id);


?>

