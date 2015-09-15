<?php
/**
 * Edit address form
 *
 * @author 		WooThemes
 * @package 	WooCommerce/Templates
 * @version     2.1.0
 */

if ( ! defined( 'ABSPATH' ) ) exit; // Exit if accessed directly

global $woocommerce, $current_user;
global $wpdb;
$page_title = ( $load_address === 'billing' ) ? __( 'Billing Address', 'woocommerce' ) : __( 'Shipping Address', 'woocommerce' );

get_currentuserinfo();
?>

<?php wc_print_notices(); ?>

<?php if ( ! $load_address ) : ?>

	<?php wc_get_template( 'myaccount/my-address.php' ); ?>

<?php else : ?>

	<form method="post">

		<!-- <h3><?php echo apply_filters( 'woocommerce_my_account_edit_address_title', $page_title ); ?></h3> -->
		<!-- <h3 style="text-align: center;">个人信息</h3> -->
		<!--<?php 
			foreach ( $address as $key => $field ) : 
				woocommerce_form_field( $key, $field, ! empty( $_POST[ $key ] ) ? wc_clean( $_POST[ $key ] ) : $field['value'] ); 
			 endforeach; 
		?>-->
		<?php
			$name=get_user_meta($current_user->id,'shipping_first_name',ture);
			$address=get_user_meta($current_user->id,'shipping_address_1',ture);
			$phone=get_user_meta($current_user->id,'shipping_phone',ture);
			$phone=$current_user->user_login;
            $user_card=$wpdb->get_var("SELECT user_card FROM wp_gcommerce_user_card where user_phone='{$phone}'");
			$ucode=pb_code_decrypt($user_card);
			if(isset($_POST['save_address1'])){
				update_usermeta($current_user->id,'shipping_first_name',$_POST['uname']);
				update_usermeta($current_user->id,'shipping_address_1',$_POST['address']);
				update_usermeta($current_user->id,'shipping_phone',$_POST['phone']);
				$iscard=pb_verify_card($_POST['ucode']);
				if(!$iscard)
				{
					header("Content-type: text/html; charset=utf-8"); 
					echo "<script>alert('卡号输入错误');</script>";
					$ucode=pb_code_decrypt($user_card);
				}
				else{
					pb_save_card($_POST['ucode']);
					$ucode=$_POST['ucode'];
				}
				// $unamecode=new GCommerce_User();
				// $verify=$unamecode->verify_card($_POST['ucode']);
				// if(!$verify){
				// 	echo "<script>alert('卡号输入错误，请重新输入卡号');</script>";
				// }
				// else{
				// 	$unamecode->save_card($_POST['ucode']);
				// }
				$name=$_POST['uname'];
				$address=$_POST['address'];
				$phone=$_POST['phone'];
				// $ucode=$_POST['ucode'];
				// print_r($ucode);
			}
		?>
 		<p style="background:#ebebeb;color:#3a3a3a;padding:5px 3px">当前账号<?php echo $current_user->user_login;?></p>
<!--		<label for="shipping_postcode" class="">客户姓名 <abbr class="required" title="(必填)">*</abbr></label>
		<input type="text" class="input-text " name="uname" id="uname" placeholder="姓名" value="<?php echo $name; ?>">
		<label for="shipping_postcode" class="">联系电话 <abbr class="required" title="(必填)">*</abbr></label>
		<input type="text" class="input-text " name="phone" id="uname" placeholder="联系电话" value="<?php echo $phone; ?>">
		<label for="shipping_postcode" class="">送货地址 <abbr class="required" title="(必填)">*</abbr></label>
		<input type="text" class="input-text " name="address" id="uname" placeholder="送货地址" value="<?php echo $address; ?>">
		<label for="shipping_postcode" class="">绑定卡号 <abbr class="required" title="(必填)">*</abbr></label>
		<input type="text" class="input-text " name="ucode" id="uname" placeholder="" value=""> -->

		<ul>
			<li style="background:#ebebeb;border-bottom: 1px solid #c8c7cc;padding:5px 3px;">
				收货地址
			</li>
			<li style="border-bottom: 1px solid #c8c7cc;">
				收货人：<input type="text" class="pb_input" name="uname" id="uname" placeholder="姓名" value="<?php echo $name; ?>">
			</li>
			<li style="border-bottom: 1px solid #c8c7cc;">
				手机号码：<input type="text" class="pb_input" name="phone" id="uname" placeholder="联系电话" value="<?php echo $phone; ?>">
			</li>
			<li style="border-bottom: 1px solid #c8c7cc;">
				详细地址：<input type="text" class="pb_input" name="address" id="uname" placeholder="送货地址" value="<?php echo $address; ?>">
			</li>
		</ul>
		<ul>
			<li style="background:#ebebeb;border-bottom: 1px solid #c8c7cc;padding:5px 3px;">
				卡号
			</li>
			<li style="border-bottom: 1px solid #c8c7cc;">
				绑定卡号：<input type="text" class="pb_input" name="ucode" id="uname" placeholder="" value="<?php echo $ucode; ?>">
			</li>
		</ul>
		<p>
			<input type="submit" style="margin-top:10px;width:100%" class="button" name="save_address1" value="<?php _e( '保存当前信息', 'woocommerce' ); ?>" />
			<!-- <?php wp_nonce_field( 'woocommerce-edit_address' ); ?>
			<input type="hidden" name="action" value="edit_address" /> -->
		</p>
	</form>

<?php endif; ?>