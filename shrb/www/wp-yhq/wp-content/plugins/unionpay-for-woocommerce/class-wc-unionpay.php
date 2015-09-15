<?php
    if (!defined('ABSPATH'))
    exit; // Exit if accessed directly
    
    class WC_Unionpay extends WC_Payment_Gateway{
        // var $current_currency;
        // var $multi_currency_enabled;

        public function __construct() {
            global $woocommerce;
            // $this->current_currency = $this->current_currency();
            // $this->multi_currency_enabled = in_array('woocommerce-multilingual/wpml-woocommerce.php', apply_filters('active_plugins', get_option('active_plugins')))
            //         && get_option('icl_enable_multi_currency') == 'yes';
            $this->id = 'unionpay';
            $this->icon = apply_filters('woocommerce_unionpay_icon', plugins_url('images/unionpay.png', __FILE__));
            $this->has_fields = false;

            // Load the form fields.
            $this->init_form_fields();

            // Load the settings.
            $this->init_settings();
            // Define user set variables
            $this->title = $this->settings['title'];
            // $this->description = $this->settings['description'];
            $this->payment_method = $this->settings['payment_method'];
            $this->debug = $this->settings['debug'];
            $this->form_submission_method = $this->settings['form_submission_method'] == 'yes' ? true : false;
            $this->exchange_rate = $this->settings['exchange_rate'];

            // $this->secure_key = $this->settings['secure_key'];

            $this->notify_url = str_replace('https:', 'http:', add_query_arg('wc-api', 'WC_Unionpay', home_url('/'))); //trailingslashit(home_url()); 
            //Log
            if ($this->debug == 'yes')
                $this->log = $woocommerce->logger();

            // Actions
            add_action('admin_notices', array($this, 'requirement_checks'));
            add_action('woocommerce_api_wc_unionpay', array($this, 'check_unionpay_response'));
            add_action('woocommerce_update_options_payment_gateways', array($this, 'process_admin_options')); // WC <= 1.6.6
            add_action('woocommerce_update_options_payment_gateways_' . $this->id, array($this, 'process_admin_options')); // WC >= 2.0
            add_action('woocommerce_thankyou_unionpay', array($this, 'thankyou_page'));
            add_action('woocommerce_receipt_unionpay', array($this, 'receipt_page'));
        }



        /**
     * Initialise Gateway Settings Form Fields
     *  用于给定前台显示的选项
     * @access public
     * @return void
     */
        function init_form_fields() 
        {
            $this->form_fields = array(
                'enabled' => array(
                    'title' => __('Enable/Disable', 'alipay'),
                    'type' => 'checkbox',
                    'label' => '启用银联',
                    'default' => 'no'
                ),
                'title' => array(
                    'title' => __('Title', 'alipay'),
                    'type' => 'text',
                    'description' => __('This controls the title which the user sees during checkout.', 'alipay'),
                    'default' => '银联'
                ),
                'description' => array(
                    'title' => __('Description', 'alipay'),
                    'type' => 'textarea',
                    'default' => '使用银联卡支付'
                ),
                // 'partnerID' => array(
                //     'title' => __('Partner ID', 'alipay'),
                //     'type' => 'text',
                //     'description' => '请输入合作者身份ID，如果你没有合作者身份ID，请与银联工作人员联系',
                //     'css' => 'width:400px'
                // ),
                // 'secure_key' => array(
                //     'title' => __('Security Key', 'alipay'),
                //     'type' => 'text',
                //     'description' => '输入您与银联合作的密钥',
                //     'css' => 'width:400px'
                // )
                'debug' => array(
                    'title' => __('Debug Log', 'alipay'),
                    'type' => 'checkbox',
                    'label' => __('Enable logging', 'alipay'),
                    'default' => 'no',
                    'description' => __('Log Alipay events, such as trade status, inside <code>woocommerce/logs/alipay.txt</code>', 'alipay'),
                )
                
            );
        }

    /**
     * Check the main currency
     * 
     * @access public
     * @return string
     */
    // function current_currency() {
    //     $currency = get_option('woocommerce_currency');
    //     return $currency;
    // }


    /**
     * Admin Panel Options
     * - Options for bits like 'title' and account etc.
     *
     * @since 1.0
     */
        public function admin_options() 
        {
            ?>
            <h3>银联支付</h3>
            <p>银联支付是一种简单、安全、快速的网络支付方式,客户可以通过借记卡、信用卡支付</p>
            <table class="form-table">
                <?php
                // Generate the HTML For the settings form.
                $this->generate_settings_html();
                ?>
            </table><!--/.form-table-->
            <?php
        }
    /**
     * Process the payment and return the result
     *
     * @access public
     * @param int $order_id
     * @return array
     */
        function process_payment($order_id) 
        {
            global $woocommerce;
            $order = new WC_Order($order_id);
            if (!$this->form_submission_method) {
                 $order->update_status('pending', '未付款');
                 //$this->get_unionpay_args($order);
                 $woocommerce->cart->empty_cart();
                 unset($_SESSION['order_awaiting_payment']);
                 $redirect = $this->get_unionpay_url($order);
                if ($this->debug == 'yes')
                    $this->log->add('yl', 'Query string: ' . $redirect);
                return array(
                    'result' => 'success',
                    'redirect'=> $redirect
                );
            } else {
                return array(
                    'result' => 'success',
                    'redirect' => add_query_arg('order', $order->id, add_query_arg('key', $order->order_key, get_permalink(woocommerce_get_page_id('pay'))))
                );
            }
        }
    //拼接url
        function get_unionpay_url($order)
        {

            $redurl = plugins_url('ylapi.php',__FILE__);
            // orderid订单号
            $orderid = $order->id;
            $items=$order->get_items();
            $order_name=null;
            foreach ($items as $it) {
                $order_name=$it['name'];
            }
            // subject商品名称
            $subject=urlencode(mb_convert_encoding($order_name, 'UTF-8'));

            // orderfrom订单来源 订单来源的商家
            $orderfrom=urlencode('交通银行');
            // total_fee 订单金额
            $total_fee=$order->get_total();
            // frontcallurl前置地址
            $frontcallurl=home_url().'/myaccount/';
            // backcallurl后置地址 商户传递过来的异步通知地址
            $backcallurl =  WC()->api_request_url( 'WC_Unionpay' );
            $pay_id=get_post_meta($orderid,'pay_order_id',true);
            // $backcallurl='http://sanfudev.paybay.cn/t.php';
            // print_r($backcallurl);
            // die;
            // $backcallurl='http://gateway.paybay.cn/paygateway/api/manage';
            //      是否需要登录字段
            // $paybid=0;
            // print_r($backcallurl);
            // die;
            $ucode=$this->decrypt();
            $redir = $redurl.'?orderid='.$pay_id.'&subject='.$subject.'&total_fee='.$total_fee.'&orderfrom='.$orderfrom.'&frontcallurl='.$frontcallurl.'&backcallurl='.$backcallurl.'&ucode='.$ucode;
            // print_r($redir);
            // die;
            return $redir;
        }



    /****
        检查是否支付

    ***/
       function check_unionpay_response() 
       { 
            global $woocommerce;
            global $wpdb;
            @ob_clean();
            // include_once 'func/common.php';
            // include_once 'func/secureUtil.php';
            $post=$_POST;
            if($this->debug=='yes')
                $this->log->add('yl', 'post'.json_encode($post));
            $pay_id=$_POST['orderId'];
            $order_id=$wpdb->get_results("SELECT order_id FROM wp_gcommerce_yhq where pay_order_id='{$pay_id}';");
            $order_id=$order_id[0]->order_id;
            $order = new WC_Order($order_id);
             if($this->debug=='yes'){
                $this->log->add('yl', 'order_id:'.json_encode($order_id));
                $this->log->add('yl', 'pay_id'.json_encode($pay_id));
                $this->log->add('yl', 'status'.json_encode($_POST['respCode']));
                $this->log->add('yl', 'time:'.current_time('timestamp'));
             }
                

            if($_POST['respCode']=='00'){
                update_post_meta($order_id,'pay_complete',current_time('timestamp'));
                $order->update_status('paid', '已支付');
            }
            else{
                $order->update_status('pending', '已支付');
            }
            // if(isset($_POST['orderid'])){
            //     if($this->debug=='yes'){
            //         $this->log->add('yl', '修改订单状态' );
            //     }
            // }
            // $ordid = $_POST['orderid'];   
            // $paystate = $_POST['paystate'];
            // if($this->debug=='yes'){
            //     $this->log->add('yl','POSt：'.$ordid);
            // }
            // $order = new WC_Order($ordid);
            // if($this->debug=='yes'){
            //     $this->log->add('yl', '支付结果：'.$paystate );
            // }
            // else{
            //     $order->update_status('pending', '失败');
            //     $this->successful_request( $_POST );
            // }
        }
        /**
         * Output for the order received page.
         *
         * @access public
         * @return void
         */
        function receipt_page($order) {
           
            echo '<p>' . __('Thank you for your order, please click the button below to pay with Alipay.', 'alipay') . '</p>';
        }
            /**
         * Successful Payment!
         *
         * @access public
         * @param array $posted
         * @return void
         */
        function successful_request($posted) {
            // print_r('bbb');
            // die;
            if ($this->debug == 'yes')
                $this->log->add('yl', 'Trade Status Received: [' . $posted['trade_status'] . '] For Order: [' . $_POST['out_trade_no'] . ']');
            header('HTTP/1.1 200 OK');
            echo "success";
            exit;
        }

        function decrypt(){
            global $woocommerce;
            global $wpdb; 
            global $current_user;
            $phone=$current_user->user_login;
            $user_card=$wpdb->get_var("SELECT user_card FROM wp_gcommerce_user_card where user_phone='{$phone}'");
            // print_r('expression');
            $decrypted=pb_code_decrypt($user_card);
            return $decrypted; 
        }











        




}?>
