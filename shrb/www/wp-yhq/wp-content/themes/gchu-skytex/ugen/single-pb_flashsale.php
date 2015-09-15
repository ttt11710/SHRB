<?php include_once('header.php');?>
<?php include_once('goodsSync.js.php');?>
<?php
    include_once('config.php');
    include_once('public_function.php');
    $pb_cb=$_GET['cb'];
    $callback_url=get_permalink();
    $callback_url=urlencode($callback_url."?cb=".$pb_cb);
    pb_login_determine($callback_url);
    //秒杀id
    $pb_flashSale_id=get_the_id();
    //秒杀信息区块的数据    
    $pb_post_data=ff_get_all_fields_from_section('pb_flashSale_buy', 'meta', 'post', $pb_flashSale_id);
    // print_r($pb_post_data);
    //秒杀价格
    $pb_flashSale_price=$pb_post_data['pb_flashSale_price'];
    $product_id=$pb_post_data['pb_select_product'];
	$pb_flashSale_product=get_product($pb_post_data['pb_select_product'],$fields = null);
    //库存
    // $pb_stock=$pb_flashSale_product->get_variation_attributes();
    //图片
    $imageIDs = $pb_flashSale_product->get_gallery_attachment_ids();
    $img_url=array();
    foreach ($imageIDs as $key => $value) {
        $img_url[]=wp_get_attachment_image_src($imageIDs[$key],array(PRODUCT_IMAGE_WIDTH,PRODUCT_IMAGE_HEIGHT));
    }
?>

<script type="text/javascript">
    var product_id=<?php echo $product_id;?>;
    var ajax_url="<?php echo admin_url('admin-ajax.php');?>";
    $(document).ready(function(){
        //商品图片滚动区域
        initImgIscroll();
        btn=$("#in");
        btn.addClass("bg1");
        btn.removeClass("bg6");
        // selectone();
        // selsectmodel();
        // console.log('aa');
        // clickColorAndSize(ajax_url);
        btn.click(function(){
            var span=$('#choose_color,#choose_size,#choose_mode').find(".choose2");
            // if(span.length==3 && stockFlag){
            //     var g_color=span.eq(0).text();
            //     var g_size=span.eq(1).text();
            //     var g_mode=span.eq(2).text();
            //     $.openLoading();
                var flashSale_id=<?php echo $pb_flashSale_id;?>;
                //http://192.168.2.92/ubox
                $.get("<?php echo admin_url('admin-ajax.php');?>?action=get_flashSale_create_order&flashSale_id="+flashSale_id,function(data){
                    $.closeLoading();
                    var group_msg=data;
                    var group_people=data.people;
                    if(group_msg.code==1001)
                    {
                        $.ajax({
                                type:'post',
                                url:'<?php echo $pb_cb;?>/flashSale/saleGoods?sign=1&id='+flashSale_id+'&num='+group_people,
                                dataType:'json',
                                success:function(data){
                                    if (data.code==200) {
                                        //需要判断人数是否到最小开团人数,到了跳转支付,未到跳转固定页面等待短信通知
                                        //固定页面http://192.168.2.74:3004/group/ingroup.html
                                    }
                                }
                        });
                        popupMsg(data.msg,function(){
                            //其他的支付平台需要更改
                            window.location.href=group_msg.pay_url;
                        });
                    }
                    else
                    {
                        popupMsg(data.msg);
                    }
                });
            // }
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

            <p class="name ft20 fw" id="name"><?php echo $pb_flashSale_product->post->post_title; ?></p>
            <div class="price pure-g ft17">
                <div class="pure-u-2-5 fc5">商品原价<br/><span class="ft21"><del id="cost"><?php echo $pb_flashSale_product->get_price_html();?></del></span></div>
                <div class="pure-u-1-5 fc2">
                    秒&nbsp;&nbsp;杀<br/>
                    <span>惊喜价</span>
                </div>
                <div class="pure-u-2-5 ft43 fc2 lh40" id="price">￥<?php echo $pb_flashSale_price;?></div>
            </div>
            <p class="ft11 pl10"></p>
<!--             <div class="ft14 color">
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
            </div> -->
<!--             <div class="ft14 color">
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
            </div> -->
<!--              <div class="ft14 color">
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
            </div> -->
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

<?php include_once('footer.php');?>