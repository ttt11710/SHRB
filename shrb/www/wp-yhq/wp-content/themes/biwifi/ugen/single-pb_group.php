<?php include_once('header.php');?>
<?php include_once('goodsSync.js.php');?>
<?php
    // $api=new WC_API;
    // $api->register_resources('WC_API_Orders');
    //$order1 = new WC_API_Orders( );
    // WC()->api->WC_API_Orders->get_orders();
    // WC_API_Orders::get_orders($fields = null, $filter = array(), $status = null, $page = 1);
    // echo date('Y-m-d H:i:s',time());
// $current_url = home_url();
// print_r($current_url);
    include_once('config.php');
    include_once('public_function.php');
    $pb_cb=$_GET['cb'];
    //判断是否登入
    $callback_url=get_permalink();
    $callback_url=urlencode($callback_url."?cb=".$pb_cb);
    pb_login_determine($callback_url);
    $pb_group_id=get_the_id();

    $post_type=PB_MENU_CONFIG::$MENU['group']['post_type'];
    //团购信息区块的数据
    $pb_post_data=ff_get_all_fields_from_section('pb_group_buy', 'meta', 'post', $pb_group_id);
    $product = get_product($pb_post_data['pb_select_product']);//new WC_Product($mateArray['pb_select_product']);
    $product_id=$pb_post_data['pb_select_product'];
    $imageIDs = $product->get_gallery_attachment_ids();
    $img_url=array();
    foreach ($imageIDs as $key => $value) {
        $img_url[]=wp_get_attachment_image_src($imageIDs[$key],array(PRODUCT_IMAGE_WIDTH,PRODUCT_IMAGE_HEIGHT));
    }
    // print_r($img_url);
    // $phoneImageArray = Array();
    // foreach($imageIDs as $imageID){
    //     $imageInfo = wp_get_attachment_image_src($imageID,array(PB_PLAN_CONFIG::$PRODUCT_IMAGE_WIDTH,PB_PLAN_CONFIG::$PRODUCT_IMAGE_HEIGHT));
    //     $downloadImageArray[count($downloadImageArray)] = $imageInfo[0];
    //     $tempArray = explode("/",$imageInfo[0]);
    //     $imageName = $tempArray[count($tempArray)-1];
    //     $phoneImageArray[count($phoneImageArray)] = $imageName;
    // }
    // print_r($phoneImageArray);
    // print_r($img_url);
    // print_r(strtotime($pb_post_data['pb_latest_payment_time']));
    // print_r(date(time()));
    // print_r($pb_post_data);
    //获取最小团购人数
    $pb_people=array();
    foreach ($pb_post_data['pb_group_ladder_grouping'] as $value) {
       $pb_people[]=$value['pb_group_ladder_people'];
    }
    //获取最小人数的值
    $pb_people_mim=min($pb_people);
	$pb_group_product=get_product($pb_post_data['pb_select_product'],$fields = null);
    //库存
    $pb_stock=$pb_group_product->get_variation_attributes();
    //页面加载后获得团购总人数
    $user_count = pb_select_activity_people($pb_group_id,$post_type,array(PB_ORDER_STATUS::$PB_ORDER_STATUS['CANCELLED']['title']));
//    if(count($pb_post_data['pb_group_ladder_grouping'])==1)
//    {
//        $pb_group_price=pb_selsct_groupPrice($pb_post_data['pb_group_ladder_grouping'],$user_count);
//    }
//    else{
        $pb_group_price=pb_show_group_price($pb_post_data['pb_group_ladder_grouping'],$user_count);
//    }
    // print_r($pb_post_data['pb_group_ladder_grouping']);
    // add_filter( 'woocommerce_get_price_html', 'woocommerce_hide_price' );
    // function woocommerce_hide_price( $price ){
    //     return $price;
    // }
    // print_r($pb_group_product);0
?>

<script type="text/javascript">
    var product_id=<?php echo $product_id;?>;
    var ajax_url="<?php echo admin_url('admin-ajax.php');?>";
    $(document).ready(function(){
        //商品图片滚动区域

        initImgIscroll();
        btn=$("#in");
        selectone();
        selsectmodel();
        clickColorAndSize(ajax_url);
        btn.click(function(){
            var span=$('#choose_color,#choose_size,#choose_mode').find(".choose2");
            if(span.length==3 && stockFlag){
                var g_color=span.eq(0).text();
                var g_size=span.eq(1).text();
                var g_mode=span.eq(2).text();
                $.openLoading();
                var group_id=<?php echo $pb_group_id;?>;
                $.get("<?php echo admin_url('admin-ajax.php');?>?action=get_group_create_order&group_id="+group_id+"&choose_color="+g_color+"&choose_size="+g_size+"&choose_mode="+g_mode+"&post_type=<?php echo get_post_type();?>",function(data){
                    $.closeLoading();
                    var group_msg=data;
                    var group_people=data.people;
                    var group_status=data.status;
                    var group_price=data.price;
                    console.log(group_msg);
                    // console.log(group_msg[0].msg);
                    if(group_msg.code==1001 || group_msg.code==1006)
                    {
                        $.ajax({
                                type:'post',
                                url:'<?php echo $pb_cb;?>/group/confirmInGroup?sign=1&id='+group_id+'&person='+group_people+'&groupPrice='+group_price,
                                dataType:'json',
                                success:function(data){
                                    if (data.code==200) {
                                        //需要判断人数是否到最小开团人数,到了跳转支付,未到跳转固定页面等待短信通知
                                        //固定页面http://192.168.2.74:3004/group/ingroup.html
                                    }
                                }
                        });
                        popupMsg(group_msg.msg,function(){
                            if(group_status)
                            {
                                window.location.href=group_msg.pay_url;
                            }
                            else
                            {
                                //参团成功
                                window.location.href="<?php echo $pb_cb;?>/group/ingroup.html";
                            }
                        });
                    }
                    else
                    {
                        popupMsg(group_msg.msg);
                    }
                });
            }
        });
    });






</script>


<div class="container" id="container" style="height:auto;padding-bottom: 220px;">
    <div id="detail" class="">
        <div class="head bg1 fc1">
            <p></p>
            <p class="ft21">商品详情</p>
            <p></p>
        </div>
        <div class="content">
                <div id="wrapper">
                    <div id="scroller">
                        <ul>
                            <?php
                            foreach ($img_url as $key => $value) 
                            {
                            ?>
                                <li><img src='<?php echo $value[0];?>'/></li>
                            <?php  
                            }
                            ?>
                        </ul>
                    </div>
                </div>
                <div class="line pure-g">
                     <?php
                            foreach ($img_url as $key => $value) 
                            {
                            ?>
                                <div class="indicator"></div>
                            <?php  
                            }
                            ?>
                </div>

            <p class="name ft20 fw" id="name"><?php echo $pb_group_product->post->post_title; ?></p>
            <div class="price pure-g ft17">
                <div class="pure-u-2-5 fc5">商品原价<br/><span class="ft21"><del id="cost">￥<?php echo $pb_group_product->get_variation_regular_price('max');?></del></span></div>
                <div class="pure-u-1-5 fc2">
                    团&nbsp;&nbsp;购<br/>
                    <span>惊喜价</span>
                </div>
                <div class="pure-u-2-5 ft43 fc2 lh40" id="price">￥<?php echo $pb_group_price;?></div>
            </div>
            <p class="ft11 pl10"></p>
            <div class="ft14 color">
                <span>颜色</span>
                <div id="choose_color" class="pl38">
                    <?php 
                    foreach ($pb_stock['color'] as $value) {
                    ?>
                    <span class="choose"><?php echo $value;?></span>
                    <?php
                    }
                    ?>
                </div>
            </div>
            <div class="ft14 color">
                <span>尺码</span>
                <div id="choose_size" class="pl38">
                    <?php 
                    foreach ($pb_stock['size'] as $value) {
                    ?>
                        <span class="choose"><?php echo $value;?></span>
                    <?php
                    }
                    ?>
                </div>
            </div>
             <div class="ft14 color">
                <span>提货</span>
                <div id="choose_mode">
                    <?php 
                    foreach ($pb_stock['delivery'] as $value) {
                    ?>
                        <span class="choose"><?php echo $value;?></span>
                    <?php
                    }
                    ?>
                </div>
            </div>
<!--             <div class="ft14 color mb20 pb40">
                <span id="choose_stock">
                </span>
            </div> -->
            <div class="fixed-bottom">
               <div class="btn_b bg6 fc1 ft21" id="in">确认</div>
            </div>
        </div>
    </div>
</div>
<?php
    // global $woocommerce;
    // $woocommerce->checkout->add_to_checkout($product_id);
    // print_r($woocommerce);
?>
<?php include_once('footer.php');?>