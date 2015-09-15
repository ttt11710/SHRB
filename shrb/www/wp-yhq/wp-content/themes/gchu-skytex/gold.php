<?php get_header();?>
<?php
/**
    Template Name:gold
 */
?>
<style type="text/css">
.index_li{
  margin: 5px;
  border-bottom: 1px solid #bfbfbf;
}
</style>
<div id="goldlogo" style="width:100%;height:auto;">
  <div style="margin-bottom:10px;border-bottom:1px solid rgba(0,0,0,0.12);">
    <span style="margin-left:13px;">收藏投资类</span>
  </div>
  <ul>
    <li class="index_li" style="overflow:hidden;margin:10px 0;padding-left: 13px;">
      <a href="<?php echo home_url().'/bullion' ?>"><div style="width:40%;float:left;">
        <img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/gold_ingot.png' ?>" />
      </div>
      <div style="width:55%;float:left;">
        <p style="margin:0;font-size:13px;color:rgba(0,0,0,0.87);margin:11px auto 6px 10px">沃德投资金条/金元宝</p>
        <p style="margin:0;font-size:10px;color:rgba(0,0,0,0.54);margin-left:10px">可回购投资产品，收藏、馈赠都是绝佳之选！</p>
      </div></a>
    </li>
    <li class="index_li" style="overflow:hidden;margin:10px 0;margin-bottom:6px;padding-left: 13px;">
      <a href="<?php echo home_url().'/gold_panda' ?>"><div style="width:40%;float:left;">
        <img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/gold_panda.png' ?>" />
      </div>
      <div style="width:55%;float:left;">
        <p style="margin:0;font-size:13px;color:rgba(0,0,0,0.87);margin:11px auto 6px 10px">2012-2014熊猫金币套装</p>
        <p style="margin:0;font-size:10px;color:rgba(0,0,0,0.54);margin-left:10px">泪奔组合价，投资收藏义不容辞</p>
      </div></a>
    </li>
    <li class="index_li" style="overflow:hidden;margin:10px 0;padding-left: 13px;">
      <a href="<?php echo home_url().'/aircraft_carrier' ?>"><div style="width:40%;float:left;">
        <img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/gold_ship.png' ?>" />
      </div>
      <div style="width:55%;float:left;">
        <p style="margin:0;font-size:13px;color:rgba(0,0,0,0.87);margin:11px auto 6px 10px">中国第一艘航母纪念金章</p>
        <p style="margin:0;font-size:10px;color:rgba(0,0,0,0.54);margin-left:10px">价格冰点，史上最低价！！！赠送限量版航母模型</p>
      </div></a>
    </li>
  </ul>
</div>


<!-- <div style="width:100%;height:auto;margin-top:15px;">
  <div style="margin-bottom:10px;">
    <img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/class2_title.png' ?>"/>
  </div>
  <ul>
    <li class="index_li" style="overflow:hidden;margin:10px 0;">
      <a href="<?php echo home_url().'/fu_dai' ?>"><div style="width:40%;float:left;">
        <img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/lucky.png' ?>" />
      </div>
      <div style="width:55%;float:left;">
        <p style="margin:0;font-size:14px;color:red;">好运小福袋</p>
        <p style="margin:0;font-size:12px;">袋袋幸福！</p>
      </div></a>
    </li>
    <li class="index_li" style="overflow:hidden;margin:10px 0;">
      <a href="<?php echo home_url().'/key' ?>"><div style="width:40%;float:left;">
        <img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/key.png' ?>" />
      </div>
      <div style="width:55%;float:left;">
        <p style="margin:0;font-size:14px;color:red;">幸福钥·爱</p>
        <p style="margin:0;font-size:12px;">爱人情侣之间的亲密私语！</p>
         <p style="margin:0;font-size:12px;">富贵与希望的象征</p>
      </div></a>
    </li>
    <li class="index_li" style="overflow:hidden;margin:10px 0;">
      <a href="<?php echo home_url().'/zodiac' ?>"><div style="width:40%;float:left;">
        <img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/gold_zodiac.png' ?>" />
      </div>
      <div style="width:55%;float:left;">
        <p style="margin:0;font-size:14px;color:red;">福佑生肖&nbsp;现享特惠价</p>
        <p style="margin:0;font-size:12px;">送给父母一份孝心,温情暖暖;</p>
        <p style="margin:0;font-size:12px;">送给孩子一份平安,快乐常伴.</p>
      </div></a>
    </li>
  </ul>
</div> -->

<?php //print_r(the_post_thumbnail()); ?>
<!-- <div style='margin:0 auto'><?php echo do_shortcode("[layerslider id='1']"); ?></div>
<div id="shouyelogo" style="width:100%;height:auto;">
  <div style="margin-bottom:10px;">
    <img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/yhq_title.png' ?>"/>
  </div>
<?php 
  global $wpdb;
  $store=$wpdb->get_results("SELECT ID,post_title FROM `wp_posts` where post_type='product' and post_status='publish';",ARRAY_A);
  // print_r($store);
  // print_r(count($store));
  if(count($store)>0){
    echo '<ul style="overflow:hidden;margin:0;">';
    foreach ($store as $value) {
      $pb_flashSale_product=get_product($value['ID'],$fields = null);
      // print_r();
      $medium_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($value['ID']), 'medium');
      // print_r($value);
      $current_time=current_time('timestamp');
      //活动开始时间
      $activity_start=get_post_meta( $value['ID'], 'activity_start', true );
      //活动结束时间
      $activity_end=get_post_meta( $value['ID'], 'activity_end_copy', true );
      $title=$value['post_title'];
      $price=$pb_flashSale_product->sale_price;
      if($price==0){
        $price="免费";
      }
      else{
        $price='￥'.$price;
      }
      if($current_time<strtotime($activity_start)){
        // print_r('时间未到');
        $url=home_url().'/?p='.$value['ID'];
        $text='活动还未开始，点击查看优惠券';
      }
      else if($current_time>strtotime($activity_end))
      {
        // print_r('时间已过');
        $url=home_url().'/?p='.$value['ID'];
        $text='活动已结束，点击查看优惠券';
      }
      else{
        // print_r('活动进行');
        $url=home_url().'/?p='.$value['ID'];
        $text='活动进行中，点击领取优惠券';
      }
      ?>
        <li class="index_li" style="text-align:center;height:auto;border-radius: 10px;padding-top: 5px;">
          <a href="<?php echo $url; ?>"><img style="margin:5px auto;width:90%" src="<?php echo $medium_image_url[0];?>"/></a>
          <a style="color: #000000;" href="<?php echo $url ?>"><?php echo $title; ?></a>
          <p style="color: #f00;"><?php echo $price; ?></p>
        </li>
        
      <?php
    }
    $zhongliang=home_url().'/zhongliang/';
    $no_start=home_url().'/no_start/';
    ?>
        <li class="index_li" style="text-align:center;height:auto;border-radius: 10px;padding-top: 5px;">
          <a href="<?php echo $zhongliang; ?>"><img style="margin:5px auto;width:90%" src="<?php echo CURRENT_TEMPLATE_DIR."/images/you.png"?>"/></a>
          <a style="color: #000000;" href="<?php echo $no_start; ?>">中粮商品</a>
          <p><a href="<?php echo $zhongliang; ?>" style="color: #f00;">查看</a></p>
        </li>
    <?php
    echo "</ul>";
  }
  else{
    ?>
       <div style="text-align:center;margin:10px auto;width:80%;height:auto;background-color:#c2272d;border-radius: 10px;padding-top: 5px;">
          暂时没有活动
       </div>
    <?php
  }
?>
</div> -->

<!-- <hr style='width:100%;height:20px;'/>
<div id="shouyelogo" style="width:100%;height:auto;">
  <div style="margin-bottom:10px;">
    <img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/product_title.png' ?>"/>
  </div>
  <ul style="overflow:hidden;margin:0;">
    <li class="index_li" style="text-align:center;height:auto;border-radius: 10px;padding-top: 5px;">
      <a href="<?php echo home_url().'/god/'; ?>"><img style="margin:5px auto;width:90%" src="<?php echo CURRENT_TEMPLATE_DIR."/images/god.png";?>"/></a>
      <a style="color: #000000;" href="<?php echo $no_start ?>">黄金产品</a>
      <p style="color: #f00;">活动尚未开始</p>
    </li>
    <li class="index_li" style="text-align:center;height:auto;border-radius: 10px;padding-top: 5px;">
      <a href="<?php echo $no_start; ?>"><img style="margin:5px auto;width:90%" src="<?php echo CURRENT_TEMPLATE_DIR."/images/fund.png";?>"/></a>
      <a style="color: #000000;" href="<?php echo $no_start ?>">基金产品</a>
      <p style="color: #f00;">活动尚未开始</p>
    </li>
    <li class="index_li" style="text-align:center;height:auto;border-radius: 10px;padding-top: 5px;">
      <a href="<?php echo $no_start; ?>"><img style="margin:5px auto;width:90%" src="<?php echo CURRENT_TEMPLATE_DIR."/images/money.png";?>"/></a>
      <a style="color: #000000;" href="<?php echo $no_start ?>">保险</a>
      <p style="color: #f00;">活动尚未开始</p>
    </li>
  </ul>
</div> -->