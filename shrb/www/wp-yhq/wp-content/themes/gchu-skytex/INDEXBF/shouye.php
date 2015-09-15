<?php get_header();?>
<?php
/**
    Template Name:index
 */
?>
<?php print_r(the_post_thumbnail()); ?>
<div id="shouyelogo" style="width:100%;height:auto;background-color:#ffffff">
  <div style="margin-bottom:10px;">
    <img src="<?php echo CURRENT_TEMPLATE_DIR.'/images/yhq_title.png' ?>"/>
  </div>
<?php 
  global $wpdb;
  $store=$wpdb->get_col("SELECT ID FROM `wp_posts` where post_type='product' and post_status='publish';");
  // print_r(count($store));
  if(count($store)>0){
    foreach ($store as $value) {
      $medium_image_url = wp_get_attachment_image_src( get_post_thumbnail_id($value), 'medium');
      // print_r($value);
      $current_time=current_time('timestamp');
      //活动开始时间
      $activity_start=get_post_meta( $value, 'activity_start', true );
      //活动结束时间
      $activity_end=get_post_meta( $value, 'activity_end_copy', true );
      if($current_time<strtotime($activity_start)){
        // print_r('时间未到');
        $url=home_url().'/?p='.$value;
        $text='活动还未开始，点击查看优惠券';
      }
      else if($current_time>strtotime($activity_end))
      {
        // print_r('时间已过');
        $url=home_url().'/?p='.$value;
        $text='活动已结束，点击查看优惠券';
      }
      else{
        // print_r('活动进行');
        $url=home_url().'/?p='.$value;
        $text='活动进行中，点击领取优惠券';
      }
      ?>
        <div style="text-align:center;margin:10px auto;width:80%;height:auto;background-color:#c2272d;border-radius: 10px;padding-top: 5px;">
          <a href="<?php echo $url; ?>"><img style="margin:5px auto;width:90%" src="<?php echo $medium_image_url[0];?>"/></a>
          <a style="color: #ffffff;" href="<?php echo $url ?>"><?php echo $text; ?></a>
        </div>
        
      <?php
    }
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

