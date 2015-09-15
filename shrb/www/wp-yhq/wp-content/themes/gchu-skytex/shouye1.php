<?php get_header();?>
<?php
/**
    Template Name:index1
 */
?>
<style type="text/css">
.index_li{
    width:31.3%;
    display: inline-block;
    vertical-align: top;
    /*margin:1%;*/

}
</style>
<?php //print_r(the_post_thumbnail()); ?>
<div style='margin:0 auto'><?php echo do_shortcode("[layerslider id='1']"); ?></div>
<a href="<?php echo home_url().'/myaccount'; ?>"><img style="margin:10px auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/shouye_myaccount.png' ?>" /></a>
<div class="shouyelogo" style="width:100%;height:auto;">
  <div style="margin-bottom:10px;">
    <img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/yhq_title.png' ?>"/>
  </div>
  <div style="width:100%;background:#ff8875;height:30px;">
    <p style="margin:0;text-align:center;font-size:20px;color:#ffffff">超值优惠</p>
  </div> 
<?php 
  global $wpdb;
  $store=$wpdb->get_results("SELECT wp_posts.ID,wp_posts.post_title,wp_terms.name FROM `wp_posts`
left join wp_term_relationships on (wp_posts.ID=wp_term_relationships.object_id)
left join wp_terms on (wp_term_relationships.term_taxonomy_id=wp_terms.term_id)
where post_type='product' and post_status='publish' and wp_terms.name='preferential'",ARRAY_A);
  // print_r($store);
  $preferential_id=array();
  // print_r(count($store));
  if(count($store)>0){
    echo '<ul style="overflow:hidden;margin:0;">';
    foreach ($store as $value) {
      $pb_flashSale_product=get_product($value['ID'],$fields = null);
      $preferential_id[]=$value['ID'];
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

<div style="width:100%;background:#ff8875;height:30px;">
  <p style="margin:0;text-align:center;font-size:20px;color:#ffffff">品牌专场</p>
</div> 
<div class="shouyelogo" style="width:100%;height:auto;">
  <div style="width:48%;float:left;margin-left:1%;margin-right:1%;">
    <a href="<?php echo home_url().'/cofco'; ?>">
      <img style="width:80%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jh.jpg' ?>"/>
      <img style="width:80%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/cofco_button.jpg' ?>"/>
    </a>
  </div>
  <div style="width:48%;float:left;margin-left:1%;margin-right:1%;">
    <a href="<?php echo home_url().'/hello'; ?>">
      <img style="width:80%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/kt.jpg' ?>"/>
      <img style="width:80%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/hello_button.jpg' ?>"/>
    </a>
  </div>
</div>

<br style="clear: both;"/>

<div class="shouyelogo123412123" style="width:100%;height:auto;margin-top:10px;">
<div style="width:100%;background:#ff8875;height:30px;">
  <p style="margin:0;text-align:center;font-size:20px;color:#ffffff">优惠券</p>
</div> 
<?php 
  global $wpdb;
  $store1=$wpdb->get_results("SELECT wp_posts.ID,wp_posts.post_title,wp_terms.name FROM `wp_posts`
left join wp_term_relationships on (wp_posts.ID=wp_term_relationships.object_id)
left join wp_terms on (wp_term_relationships.term_taxonomy_id=wp_terms.term_id)
where post_type='product' and post_status='publish' and wp_terms.name='虚拟商品' and wp_posts.ID not in (SELECT wp_posts.ID FROM `wp_posts`
left join wp_term_relationships on (wp_posts.ID=wp_term_relationships.object_id)
left join wp_terms on (wp_term_relationships.term_taxonomy_id=wp_terms.term_id)
where post_type='product' and post_status='publish' and wp_terms.name='preferential')",ARRAY_A);
  // print_r($store);
  // print_r($preferential_id);
  // print_r(count($store));
  if(count($store1)>0){
    echo '<ul style="overflow:hidden;margin:0;">';
    foreach ($store1 as $value) {
      foreach ($preferential_id as $id => $val) {
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
<div class="shouyelogo" style="width:100%;height:auto;">
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
      <a href="<?php echo home_url().'/jijing/'; ?>"><img style="margin:5px auto;width:90%" src="<?php echo CURRENT_TEMPLATE_DIR."/images/fund.png";?>"/></a>
      <a style="color: #000000;" href="<?php echo home_url().'/jijing/'; ?>">基金</a>
      <a href="<?php echo home_url().'/jijing/'; ?>"><p style="color: #f00;">查看</p></a>
    </li>
    <li class="index_li" style="text-align:center;height:auto;border-radius: 10px;padding-top: 5px;">
      <a href="<?php echo home_url().'/baoxian_info/'; ?>"><img style="margin:5px auto;width:90%" src="<?php echo CURRENT_TEMPLATE_DIR."/images/money.png";?>"/></a>
      <a style="color: #000000;" href="<?php echo home_url().'/baoxian_info/'; ?>">保险</a>
      <a href="<?php echo home_url().'/baoxian_info/'; ?>"><p style="color: #f00;">查看</p></a>
    </li>
  </ul>
</div>