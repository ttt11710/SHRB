<?php
/*
*/

/*
This example/starter plugin can be used to speed up Visual Composer plugins creation process.
More information can be found here: http://kb.wpbakery.com/index.php?title=Category:Visual_Composer
*/

// don't load directly
if (!defined('ABSPATH')) die('-1');
class Biwifi_Auth_Simple_Shortcode {
    function __construct() {
        // We safely integrate with VC with this hook
        add_action( 'init', array( $this, 'integrate_with_vc' ) );
        // Use this when creating a shortcode addon
        add_shortcode( 'auth-simple', array( $this, 'render_tag' ) );
       
        //ajax获取验证码
        add_action( 'wp_ajax_nopriv_get_verification', array($this,'get_verification'));
        add_action( 'wp_ajax_get_verification', array($this,'get_verification'));
        //按钮验证verification_button
        add_shortcode('verification_button',array($this,'verification_function'));
        //活动按钮验证
        add_shortcode('activity_button',array($this,'activity_function'));
        //测试用
        add_shortcode('bartag',array($this,'test_function'));
        //ajax是否通过
        add_action('wp_ajax_nopriv_is_by',array($this,'is_by'));
        add_action('wp_ajax_is_by', array($this,'is_by'));
    }
    function integrate_with_vc() {
      
        // Check if Visual Composer is installed
        // if ( ! defined( 'WPB_VC_VERSION' ) ) {
        //     // Display notice that Visual Compser is required
        //     add_action('admin_notices', array( $this, 'show_vc_version_notice' ));
        //     return;
        // }
 
        /*
        Add your Visual Composer logic here.
        Lets call vc_map function to "register" our custom shortcode within Visual Composer interface.
        
        More info: http://kb.wpbakery.com/index.php?title=Vc_map
        */
        //短信验证
        vc_map( array(
           "name" => __("短信验证模块"),
           "base" => "bartag",
           "class" => "",
           "category" => __('Content'),
           // 'admin_enqueue_js' => array(get_template_directory_uri().'/vc_extend/bartag.js'),
           // 'admin_enqueue_css' => array(get_template_directory_uri().'/vc_extend/bartag.css'),
           "params" => array(
              array(
                 "type" => "textfield",
                 "holder" => "div",
                 "class" => "",
                 "heading" => __("Text"),
                 "param_name" => "foo",
                 "value" => __("6位验证码"),
                 "description" => __("Description for foo param.")
              ),
              array(
                  "type" => "textfield",
                  "holder" => "div",
                  "class" => "",
                  "heading" => "重定向url",
                  "param_name" => "buttonurl",
                  "value" => "",
                  "description" => "输入验证成功后的重定向url，缺省为空，使用用户在浏览器中输入的原始url"
              ),
              array(
                  "type" => "colorpicker",
                  "holder" => "div",
                  "class" => "",
                  "heading" => "按钮颜色",
                  "param_name" => "buttoncolor",
                  "value" => '#53a1b8', //Defaultcolor
                  "description" => "选择按钮背景颜色"
              ),
           )
        ) );
        
        //按钮验证
        vc_map( array(
            "name" => __("按钮验证", 'biwifi-portal'),
            "description" => __("Biwifi simple auth", 'biwifi-portal'),
            "base" => "verification_button",
            "class" => "",
            "controls" => "full",
            // "icon" => plugins_url('assets/asterisk_yellow.png', __FILE__), // or css class name which you can reffer in your css file later. Example: "vc_extend_my_class"
            "category" => __('Content', 'js_composer'),
            //'admin_enqueue_js' => array(plugins_url('assets/vc_extend.js', __FILE__)), // This will load js file in the VC backend editor
            //'admin_enqueue_css' => array(plugins_url('assets/vc_extend_admin.css', __FILE__)), // This will load css file in the VC backend editor
            "params" => array(
                array(
                  "type" => "textfield",
                  "holder" => "div",
                  "class" => "",
                  "heading" => "按钮文本",
                  "param_name" => "buttontext",
                  "value" => "开始使用",
                  "description" => "输入按钮文本"
                ),
                array(
                  "type" => "colorpicker",
                  "holder" => "div",
                  "class" => "",
                  "heading" => "按钮颜色",
                  "param_name" => "buttoncolor",
                  "value" => '#53a1b8', //Defaultcolor
                  "description" => "选择按钮背景颜色"
                ),
                array(
                  "type" => "textfield",
                  "holder" => "div",
                  "class" => "",
                  "heading" => "重定向url",
                  "param_name" => "buttonurl",
                  "value" => "",
                  "description" => "输入验证成功后的重定向url，缺省为空，使用用户在浏览器中输入的原始url"
                ),
            )
            // "params" => array(
            // )
        ) );
        //团购秒杀按钮
        vc_map( array(
            "name" => "活动验证按钮",
            "base" => "activity_button",
            "class" => "",
            "controls" => "full",
            // "icon" => plugins_url('assets/asterisk_yellow.png', __FILE__), // or css class name which you can reffer in your css file later. Example: "vc_extend_my_class"
            "category" => __('Content', 'js_composer'),
            //'admin_enqueue_js' => array(plugins_url('assets/vc_extend.js', __FILE__)), // This will load js file in the VC backend editor
            //'admin_enqueue_css' => array(plugins_url('assets/vc_extend_admin.css', __FILE__)), // This will load css file in the VC backend editor
            "params" => array(
                array(
                  "type" => "textfield",
                  "holder" => "div",
                  "class" => "",
                  "heading" => "按钮文本",
                  "param_name" => "buttontext",
                  "value" => "开始使用",
                  "description" => "输入按钮文本"
                ),
                array(
                  "type" => "colorpicker",
                  "holder" => "div",
                  "class" => "",
                  "heading" => "按钮颜色",
                  "param_name" => "buttoncolor",
                  "value" => '#53a1b8', //Defaultcolor
                  "description" => "选择按钮背景颜色"
                ),
            )
            // "params" => array(
            // )
        ) );
    }
    //按钮验证
    function verification_function($atts, $content = null)
    {
      // print_r(plugins_url('assets/asterisk_yellow.png', __FILE__));
      extract( shortcode_atts( array(
        'buttontext' => '开始使用',
        'buttoncolor' => '#53a1b8',
        'buttonurl' => ''
      ), $atts ) );
     
      if ( $buttonurl == '') {
        $buttonurl = $_GET['userurl'];
      }
      $url="http://bankcomm.biwifi.cn:8080/wlan/auth";
      $url=$url."?uamip=".$_GET['uamip']."&uamport=".$_GET['uamport']."&userurl=".$buttonurl."&challenge=".$_GET['challenge']."";
      // print_r($url);
      $output = $content
                .'<div class="biwifi_auth" style="text-align:center">'
                . '<a id="button_verification" style="background:'.$atts['buttoncolor'].';" class="uchannel_button button" href='.$url.'>'
                . $atts['buttontext']
                . '</a>'
                . '</div>';
      return $output;
    }

    //活动验证
    function activity_function($atts, $content = null)
    {
      $buttonurl=$this->get_url($_GET['nasid']);
      $buttonurl='http://'.$buttonurl.':3200/home.html';
      extract( shortcode_atts( array(
        'buttontext' => '开始使用',
        'buttoncolor' => '#53a1b8',
      ), $atts ) );
      $url="http://bankcomm.biwifi.cn:8080/wlan/auth";
      $url=$url."?uamip=".$_GET['uamip']."&uamport=".$_GET['uamport']."&userurl=".$buttonurl."&challenge=".$_GET['challenge']."&nasid=".$_GET['nasid']."";
      $output = $content
                .'<div class="biwifi_auth" style="text-align:center">'
                . '<a id="button_verification" style="background:'.$atts['buttoncolor'].';" class="uchannel_button button" href='.$url.'>'
                . $atts['buttontext']
                . '</a>'
                . '</div>';
      return $output;
    }
    //获取活动的ul
    function get_url($nasid){
      global $wpdb;
      $ids=$wpdb->get_results("select id from wp_posts where post_type='ubox'",ARRAY_A);
      // print_r($ids);
      $ubox_id;
      foreach ($ids as $value) {
        $mac_address=get_post_meta($value['id'],'mac_address');
        $box_id=get_post_meta($value['id'],'box_id');
        if($mac_address[0]==$nasid)
        {
          print_r($box_id);
          $ubox_id=$box_id[0];
          break;
        }
      }
      $get_ip_url = "http://192.168.1.44:8080/biwifiDNS/getip";
      $post_data = array ("UboxId" => $ubox_id);
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_URL, $get_ip_url);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      // post数据
      curl_setopt($ch, CURLOPT_POST, 1);
      // post的变量
      curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
      $output = curl_exec($ch);
      curl_close($ch);
      //打印获得的数据
      // print_r($output);
      return $output;
    }

    //短信验证
    function test_function($atts, $content = null)
    {
      extract( shortcode_atts( array(
        'foo'=>'获取验证码',
        'buttontext' => '开始使用',
        'buttoncolor' => '#53a1b8',
        'buttonurl' => ''
      ), $atts ) );
      if ( $buttonurl == '') {
        $buttonurl = $_GET['userurl'];
      }
      $url="http://bankcomm.biwifi.cn:8080/wlan/auth";
      $url=$url."?uamip=".$_GET['uamip']."&uamport=".$_GET['uamport']."&userurl=".$buttonurl."&challenge=".$_GET['challenge']."";
      // print_r($atts);  
      echo '<style>
              #table1 tr td{border:0px;margin:3px;height:40px}
            </style>';
      echo '<table id="table1" style="border:0px solid #000;width:90%">';
      echo '<tr><td colspan="2"><input type="tel" id="portal_phone" placeholder="请输入手机号" style="width:100%" /></td></tr>';
      echo '<tr><td><input type="text" id="portal_code" placeholder="请输验证码" style="width:100%;height:20px" /></td>';
      echo '<td><a id="get_code" class="uchannel_button button" style="display:block;text-align: center;height:20px;padding:0;width:100%;background:'.$buttoncolor.'" >'.$foo.'</a></td></tr>';
      echo '<tr><td colspan="2"><a id="verification" class="uchannel_button button" style="10px 0 11px;display:block;text-align: center;background:'.$buttoncolor.';width:100%;">验证</a></td></tr>';
      echo '</table>';
      wp_enqueue_script( 'verification',plugins_url().'/BiWiFi-Portal/public/js/verification.js', array(),'1.0.0', true );
      // print_r($foo);
    }
    //ajax验证码
    function get_verification()
    {
      if(!isset($_GET['phone']))
      {
        exit;
      }
      $phone=$_GET['phone'];
      global $wpdb;
      $new_key = rand(0,9).rand(0,9).rand(0,9).rand(0,9).rand(0,9).rand(0,9);
      $content = "您的验证码是：".$new_key."。请不要把验证码泄露给其他人。";
      $shot_message=$wpdb->get_var($wpdb->prepare("SELECT COUNT(*) from wp_gcommerce_temp_user where user_name={$phone}"));
      $user_isset=$wpdb->get_var($wpdb->prepare("SELECT COUNT(*) from wp_users where user_login={$phone}"));
      if($user_isset>0)
      {
        echo json_encode(array('status'=>500,'msg'=>'用户名已注册，请登入'));
        exit;
      }
      else
      {
        if($shot_message>0)
        {
          $wpdb->update('wp_gcommerce_temp_user',array('confirm_code'=>$new_key),array('user_name'=>$phone));
        }
        else
        {
          $wpdb->query("INSERT INTO wp_gcommerce_temp_user (user_name, user_pass, user_email,confirm_code,type) VALUES ('{$phone}','111111','111111','{$new_key}','verification user')");
        }
      }
      $res = $this->pb_send_sms_gcommerce($phone,$content);
      echo json_encode(array('status'=>200,'msg'=>'验证码已通过短信发送到您的手机，输入验证码进行验证'));
      exit;
    }
    //ajax验证后的操作
    function is_by()
    {
      global $wpdb;
      if(!isset($_GET['phone']) || !isset($_GET['code']))
      {
        exit;
      }
      $phone=$_GET['phone'];
      $code=$_GET['code'];
      // print_r($phone);
      // print_r($code);
      $cout=$wpdb->get_var($wpdb->prepare("SELECT COUNT(*) from wp_gcommerce_temp_user where user_name={$phone} and confirm_code={$code}"));
      if($cout>0)
      {
        echo json_encode(array('status'=>200,'msg'=>'验证通过'));
      }
      else
      {
        echo json_encode(array('status'=>500,'msg'=>'验证失败'));
      }
      exit;
    }
    //短信网关
    function pb_send_sms_gcommerce($to, $content) {
      $sms_user = "cf_ganchu";
      $sms_password = "cf_ganchu";
      $sms_url = "http://115.29.206.186:8080/sms/mtbs?account=" . $sms_user . "&password=" . $sms_password . "&phone=" . trim($to) . "&content=" . urlencode(trim($content));
      //echo $content;
      //echo $sms_url;
      $result = file_get_contents($sms_url);
      // echo $result;
      return $result;
    }


    /*
    Show notice if your plugin is activated but Visual Composer is not
    */
    public function show_vc_version_notice() {
        $plugin_data = get_plugin_data(__FILE__);
        echo '
        <div class="updated">
          <p>'.sprintf(__('<strong>%s</strong> requires <strong><a href="http://bit.ly/vcomposer" target="_blank">Visual Composer</a></strong> plugin to be installed and activated on your site.', 'vc_extend'), $plugin_data['Name']).'</p>
        </div>';
    }
}
// Finally initialize code
new Biwifi_Auth_Simple_Shortcode();
