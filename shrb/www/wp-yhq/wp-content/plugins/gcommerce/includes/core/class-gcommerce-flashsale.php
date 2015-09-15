<?php

/**
 * 优惠券秒杀
 *
 * @link       http://gchu.cn
 * @since      1.0.0
 *
 * @package    GCommerce
 * @subpackage GCommerce/includes/core
 */

class GCommerce_Flashsale {


	/**
	 * Initialize the object.
	 *
	 * @since    1.0.0
	 */
	public function __construct() {

	}

	/**
	 * gCommerce初始化.
	 *
	 * @since    1.0.0
	 * @var      object               $loader           GCommerce_Loader instance.
	 */
	public function init( $loader ) {
		//大屏获取商品信息
		if($_POST['action']=='flashsale_product_info')
			$loader->add_action( 'wp_ajax_nopriv_'.$_POST['action'].'',$this, 'flashsale_product_info',999999);
		if($_POST['action']=='flashsale_product_stock')
			$loader->add_action( 'wp_ajax_nopriv_'.$_POST['action'].'',$this, 'flashsale_product_stock',999999);
		if($_POST['action']=='flashsale_product_order')
			$loader->add_action( 'wp_ajax_nopriv_'.$_POST['action'].'',$this, 'flashsale_product_order',999999);
		if($_POST['action']=='flashsale_info')
			$loader->add_action( 'wp_ajax_nopriv_'.$_POST['action'].'',$this, 'flashsale_info',999999);
	}
	//获取商品信息
	function flashsale_product_info(){
		$product_id=$_POST['id'];
		$product_info=$this->get_product($product_id);
		// print_r($advertising_array);
		// die;
		echo json_encode($product_info);
		exit();
	}
	//实时获取商品库存
	function flashsale_product_stock(){
		$product_id=$_POST['id'];
		$stock=get_post_meta($product_id,'_stock',ture);
		echo json_encode(array('stock'=>$stock));
		exit();
	}
	//参与秒杀订单数量
	function flashsale_product_order(){
		$id=$_POST['flashSalse_id'];
		$order_number=get_flashSalse_nubmer($id);
		echo json_encode(array('order_number'=>$order_number));
		exit();
	}

	function flashsale_info(){
		$product_id=get_post_meta($_POST['id'],'product_id',ture);
		$startTime=get_post_meta($_POST['id'],'start_time',ture);
		$startTime=date('Y-m-d H:i:s',strtotime($startTime));
		$endTime=get_post_meta($_POST['id'],'end_time',ture);
		$endTime=date('Y-m-d H:i:s',strtotime($endTime));
		$all_stock=get_post_meta($_POST['id'],'flash_salse_number',ture);
		$price=get_post_meta($_POST['id'],'flash_salse_price',ture);
		$product_info=$this->get_product($product_id);
		$product_info['activity_start']=$startTime;
		$product_info['activity_end']=$endTime;
		$product_info['stock']=$all_stock;
		$product_info['min_price']=$price;
		echo json_encode($product_info);
		exit();
	}
	//获取商品信息
	function get_product($product_id){
		// $product_id=$_POST['id'];
		$time=current_time('timestamp');
		update_post_meta($product_id,'app',$time);
		// print_r($product_id);
		// die;
		//商品对象
		$pb_flashSale_product=get_product($product_id,$fields = null);
		$imageIDs=$pb_flashSale_product->get_gallery_attachment_ids();
		$img_url=array();
		foreach ($imageIDs as $key => $value) {
			$img_url[]=wp_get_attachment_image_src($imageIDs[$key],array(360,360));
		}
		$imgurl_array=array();
		foreach ($img_url as $key => $value) {
			$imgurl_array[]=$value[0];
		}
		// print_r($imgurl_array);
		// die;
		//title
		// print_r($pb_flashSale_product->post->post_title);
		//库存
		// print_r($pb_flashSale_product->stock);
		//原价
		$max_price=get_post_meta( $product_id, '_regular_price', true );
		// print_r($max_price);
		//秒杀价格
		$min_price=get_post_meta( $product_id, '_sale_price', true );
		// print_r($min_price);
		//活动开始时间
		$activity_start=get_post_meta( $product_id, 'activity_start', true );
		// print_r($activity_start);
		//活动结束时间
		$activity_end=get_post_meta( $product_id, 'activity_end_copy', true );
		// print_r($activity_end);
		//获取大屏文章信息
		$screen_text=get_post_meta( $product_id, 'screen_text', true );
		// print_r(json_encode($screen_text));
		// die;
		//活动标题
		$activity_title=get_post_meta( $product_id, 'activity_title', true );
		//总量
		$all_stock=get_post_meta( $product_id, 'all_stock', true );
		$pb_advertising=get_post_meta($product_id,'pb_advertising');
		$advertising_array=array();
		foreach ($pb_advertising as $key => $value) {
			if($value!=''){
				$advertising_array[]=$value['guid'];
			}
		}

		return array('title'=>$pb_flashSale_product->post->post_title,
					'stock'=>$pb_flashSale_product->stock,
					'max_price'=>$max_price,
					'min_price'=>$min_price,
					'activity_start'=>$activity_start,
					'activity_end'=>$activity_end,
					'imgurl'=>$imgurl_array,
					'screen_text'=>$screen_text,
					'activity_title'=>$activity_title,
					'all_stock'=>$all_stock,
					'advertising_array'=>$advertising_array,
					);
	}
}