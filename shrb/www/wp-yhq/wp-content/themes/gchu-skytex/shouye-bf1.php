<?php get_header();?>
<?php
/**
    Template Name:index1
 */
?>
<style type="text/css">
.index_li{
    width:31.3%;
    float:left;
    margin:1%;
}
</style>
<?php //print_r(the_post_thumbnail()); ?>
<div style='margin:0 auto'><?php echo do_shortcode("[layerslider id='1']"); ?></div>
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
          <a style="color: #000000;" href="<?php echo $zhongliang; ?>">中粮商品</a>
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
</div>

<hr style='width:100%;height:20px;'/>
<div id="shouyelogo" style="width:100%;height:auto;">
  <div style="margin-bottom:10px;">
    <img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/product_title.png' ?>"/>
  </div>
  <ul style="overflow:hidden;margin:0;">
    <li class="index_li" style="text-align:center;height:auto;border-radius: 10px;padding-top: 5px;">
      <a href="<?php echo home_url().'/gold/'; ?>"><img style="margin:5px auto;width:90%" src="<?php echo CURRENT_TEMPLATE_DIR."/images/god.png";?>"/></a>
      <a style="color: #000000;" href="<?php echo home_url().'/gold/'; ?>">黄金产品</a>
      <a href="<?php echo home_url().'/gold/'; ?>"><p style="color: #f00;">查看</p></a>
    </li>
    <li class="index_li" style="text-align:center;height:auto;border-radius: 10px;padding-top: 5px;">
      <a href="<?php echo home_url().'/fund_insurance/'; ?>"><img style="margin:5px auto;width:90%" src="<?php echo CURRENT_TEMPLATE_DIR."/images/fund.png";?>"/></a>
      <a style="color: #000000;" href="<?php echo home_url().'/fund_insurance/'; ?>">基金/保险</a>
      <a href="<?php echo home_url().'/fund_insurance/'; ?>"><p style="color: #f00;">查看</p></a>
    </li>
    <li class="index_li" style="text-align:center;height:auto;border-radius: 10px;padding-top: 5px;">
      <a href="<?php echo home_url().'/card/'; ?>"><img style="margin:5px auto;width:90%" src="<?php echo CURRENT_TEMPLATE_DIR."/images/money.png";?>"/></a>
      <a style="color: #000000;" href="<?php echo home_url().'/card/'; ?>">琴岛通特色卡</a>
      <a href="<?php echo home_url().'/card/'; ?>"><p style="color: #f00;">查看</p></a>
    </li>
  </ul>
</div>