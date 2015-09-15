<?php get_header();?>
<?php
/**
    Template Name:index1
 */
?>
<style type="text/css">
.index_li{
    width:49%;
    display: inline-block;
    vertical-align: top;
    margin:0px;
    border: 0;
    padding: 0;
    background: #ffffff;
    font-size: 11px;
}
.index_li:nth-child(1){
  border-top: 1px solid rgba(0,0,0,0.12);
}
.index_li:nth-child(2){
  border-top: 1px solid rgba(0,0,0,0.12);
}
.index_li:nth-child(odd){
  /*border-top: 1px solid rgba(0,0,0,0.12);*/
  border-right: 1px solid rgba(0,0,0,0.12);
  border-bottom: 1px solid rgba(0,0,0,0.12);
}
.index_li:nth-child(even){
  /*border-top: 1px solid rgba(0,0,0,0.12);*/
  border-left: 1px solid #f4f4f4;
  border-bottom: 1px solid rgba(0,0,0,0.12);
}
.index_title{
  width:32%;
  display: inline-block;
  font-size: 18px;
  text-align: center;
  vertical-align: top;
  padding: 5px 0;
}

#cai{
  border-bottom: 4px solid #ff5722;
  color: rgba(0,0,0,0.87);
}
#sheng{
  color: rgba(0,0,0,0.54);
}
</style>
<?php //print_r(the_post_thumbnail()); ?>
<div id='abc' style='margin:10px auto'><?php echo do_shortcode("[layerslider id='1']"); ?></div>
<ul style="overflow:hidden;margin:0px;margin-top: 5px;">
  <li class="index_title" id='cai' >精彩生活</li>
  <li class="index_title" id='sheng' >身边金融</li>
  <li class="index_title" id='jin' >金邻惠</li>
</ul>
<div id="cai_index">
  <div class="shouyelogo" style="width:100%;height:auto;border-top: 3px solid rgba(0,0,0,0.12);">
    <div style="width:100%;height:30px;">
      <p style="margin:auto 8px;font-size:15px;color:rgba(0,0,0,0.87);float:left">超值优惠</p>
      <a href="<?php echo home_url().'/preferential'; ?>"><span style="margin:auto 7px;font-size:15px;color:rgba(0,0,0,0.87);float:right">更多<img style="width:10px;display: inline-block !important;margin-left: 7px;margin-bottom:3px" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jian_tou.png' ?>" /></span></a>
    </div> 
  <?php 
    global $wpdb;
    $store=$wpdb->get_results("SELECT wp_posts.ID,wp_posts.post_title,wp_terms.name FROM `wp_posts`
  left join wp_term_relationships on (wp_posts.ID=wp_term_relationships.object_id)
  left join wp_terms on (wp_term_relationships.term_taxonomy_id=wp_terms.term_id)
  where post_type='product' and post_status='publish' and wp_terms.name='index1'",ARRAY_A);
    // print_r($store);
    $preferential_id=array();
    // print_r(count($store));
    if(count($store)>0){
      echo '<ul style="overflow:hidden;margin:0;background:#ffffff;padding-top:1px;font-size: 0;">';
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
          <li class="index_li" style="text-align:left;height:auto;padding-top: 8px;padding-bottom:5px">
              <div style="border:0px solid;width:90%;margin:0 auto">
                <a style="color: rgba(0,0,0,0.87);font-size:13px;" href="<?php echo $url ?>"><?php echo $title; ?></a>
                <br/>
                <span style="color: #f00;margin:0px;"><?php echo $price; ?></span>
              </div>
              <a href="<?php echo $url; ?>"><img style="margin:3px auto;width:90%" src="<?php echo $medium_image_url[0];?>"/></a>
            
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
  <div style="height:7px;background:rgba(0,0,0,0.12);">
  </div>
  <div style="width:100%;height:30px;border-bottom: 1px solid rgba(0,0,0,0.12);">
    <p style="margin:0 8px;font-size:15px;color:rgba(0,0,0,0.87);">品牌专场</p>
  </div> 
  <div class="shouyelogo" style="width:100%;height:auto;">
    <div style="width:49%;float:left;border-right: 1px solid rgba(0,0,0,0.12);padding-bottom: 5px;">
      <a href="<?php echo home_url().'/cofco'; ?>" style="text-decoration:none;">
        <div style="margin:8px">
          <span style="color: rgba(0,0,0,0.87);font-size:13px;">中粮油米</span>
        </div>
        <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jh.png' ?>"/>
      </a>
    </div>
    <div style="width:47%;float:left;margin-left:1%;margin-right:1%;">
      <a href="<?php echo home_url().'/hello'; ?>" style="text-decoration:none;">
        <div style="margin:8px">
          <span style="color: rgba(0,0,0,0.87);font-size:13px;">Hello&nbsp;Kitty</span>
        </div>
        <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/kt.png' ?>"/>
      </a>
    </div>
  </div>
  <br style="clear: both;"/>
  <div style="height:7px;background:rgba(0,0,0,0.12);">
  </div>
</div>


<div id="sheng_index" style="display:none;">
  <div style="width:100%;height:30px;border-bottom: 1px solid rgba(0,0,0,0.12);border-top: 3px solid rgba(0,0,0,0.12);">
    <p style="margin:auto 8px;font-size:15px;color:rgba(0,0,0,0.87);float:left">黄金产品</p>
    <!-- <span style="margin:auto 7px;font-size:15px;color:rgba(0,0,0,0.87);float:right">更多<img style="width:10px;display: inline-block !important;margin-left: 7px;margin-bottom:3px;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jian_tou.png' ?>" /></span> -->
  </div> 
  <div class="shouyelogo" style="width:100%;height:auto;">
    <div style="width:48%;float:left;border-right: 1px solid rgba(0,0,0,0.12);padding-bottom: 5px;">
      <a href="<?php echo home_url().'/gold'; ?>" style="text-decoration:none;">
        <div style="margin:8px">
          <span style="color: rgba(0,0,0,0.87);font-size:13px">收藏投资类</span>
        </div>
        <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/god.png' ?>"/>
      </a>
    </div>
    <div style="width:47%;float:left;margin-left:1%;margin-right:1%;">
      <a href="<?php echo home_url().'/gift'; ?>" style="text-decoration:none;">
        <div style="margin:8px">
          <span style="color: rgba(0,0,0,0.87);font-size:13px">礼赠首饰类</span>
        </div>
        <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/present.png' ?>"/>
      </a>
    </div>
  </div>
  <br style="clear: both;"/>
  <div style="height:7px;background:rgba(0,0,0,0.12);">
  </div>





  <div style="width:100%;height:30px;border-bottom: 1px solid rgba(0,0,0,0.12);">
    <p style="margin:auto 8px;font-size:15px;color:rgba(0,0,0,0.87);float:left">基金</p>
    <!-- <span style="margin:auto 7px;font-size:15px;color:rgba(0,0,0,0.87);float:right">更多<img style="width:10px;display: inline-block !important;margin-left: 7px;margin-bottom:3px;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jian_tou.png' ?>" /></span> -->
  </div> 
  <div class="shouyelogo" style="width:100%;height:auto;">
    <div style="width:47%;float:left;padding-bottom: 5px;">
      <a href="<?php echo home_url().'/jijing'; ?>" style="text-decoration:none;">
        <div style="margin:8px">
          <!-- <span style="color: rgba(0,0,0,0.87);">收藏投资类</span> -->
        </div>
        <!-- <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jh.png' ?>"/> -->
        <span style="font-size:13px;color:rgba(0,0,0,0.87);margin-top:20px;margin-left:21px;margin-bottom:6px">财富源于点击汇聚</span>
        <br/>
        <span style="font-size:10px;color:rgba(0,0,0,0.54);margin-left:21px;">基金定投，让小钱变大钱</span>
      </a>
    </div>
    <div style="width:51%;float:left;margin-left:1%;margin-right:1%;">
      <a href="<?php echo home_url().'/jijing'; ?>" style="text-decoration:none;">
        <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/fund_cart.png' ?>"/>
      </a>
    </div>
  </div>
  <br style="clear: both;"/>
  <div style="height:7px;background:rgba(0,0,0,0.12);">
  </div>


  <div style="width:100%;height:30px;border-bottom: 1px solid rgba(0,0,0,0.12);">
    <p style="margin:auto 8px;font-size:15px;color:rgba(0,0,0,0.87);float:left">保险</p>
    <!-- <span style="margin:auto 7px;font-size:15px;color:rgba(0,0,0,0.87);float:right">更多<img style="width:10px;display: inline-block !important;margin-left: 7px;margin-bottom:3px;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jian_tou.png' ?>" /></span> -->
  </div> 
  <div class="shouyelogo" style="width:100%;height:auto;">
    <div style="width:48%;float:left;border-right: 1px solid rgba(0,0,0,0.12);padding-bottom: 5px;">
      <a href="<?php echo home_url().'/xing_fu'; ?>" style="text-decoration:none;">
        <div style="margin:8px">
          <span style="color: rgba(0,0,0,0.87);font-size:13px">幸福无忧</span>
        </div>
        <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/insurance2.png' ?>"/>
      </a>
    </div>
    <div style="width:47%;float:left;margin-left:1%;margin-right:1%;">
      <a href="<?php echo home_url().'/an_bang'; ?>" style="text-decoration:none;">
        <div style="margin:8px">
          <span style="color: rgba(0,0,0,0.87);font-size:13px">安邦共赢3号</span>
        </div>
        <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/insurance1.png' ?>"/>
      </a>
    </div>
    <div style="border-top:1px solid rgba(0,0,0,0.12);display:inline-block">    
      <div style="width:48%;float:left;border-right: 1px solid rgba(0,0,0,0.12);padding-bottom: 5px;">
        <a href="<?php echo home_url().'/taikang'; ?>" style="text-decoration:none;">
          <div style="margin:8px">
            <span style="color: rgba(0,0,0,0.87);font-size:13px">养老保险</span>
          </div>
          <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/insurance4.png' ?>"/>
        </a>
      </div>
      <div style="width:47%;float:left;margin-left:1%;margin-right:1%;">
        <a href="<?php echo home_url().'/duanqi_info'; ?>" style="text-decoration:none;">
          <div style="margin:8px">
            <span style="color: rgba(0,0,0,0.87);font-size:13px">短期意外保障计划</span>
          </div>
          <img style="width:90%;margin: 0 auto;" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/insurance3.png' ?>"/>
        </a>
      </div>
    </div>
  </div>

</div>




<div id="jin_index" style="display:none">
  <div class="shouyelogo" style="width:100%;height:auto;border-top: 3px solid rgba(0,0,0,0.12);">
    <div style="width:100%;height:30px;">
      <span style="margin:auto 8px;font-size:15px;color:rgba(0,0,0,0.87);float:left">优惠券</span>
      <a href="<?php echo home_url().'/pb_yhq'; ?>"><span style="margin:auto 7px;font-size:15px;color:rgba(0,0,0,0.87);float:right">更多<img style="width:10px;display: inline-block !important;margin-left: 7px;margin-bottom:3px;" src="<?php echo CURRENT_TEMPLATE_DIR.'/images/jian_tou.png' ?>" /></span></a>
    </div> 
  <?php 
    global $wpdb;
    $store=$wpdb->get_results("SELECT wp_posts.ID,wp_posts.post_title,wp_terms.name FROM `wp_posts`
  left join wp_term_relationships on (wp_posts.ID=wp_term_relationships.object_id)
  left join wp_terms on (wp_term_relationships.term_taxonomy_id=wp_terms.term_id)
  where post_type='product' and post_status='publish' and wp_terms.name='index2'",ARRAY_A);
    // print_r($store);
    $preferential_id=array();
    // print_r(count($store));
    if(count($store)>0){
      echo '<ul style="overflow:hidden;margin:0;background:#ffffff;padding-top:1px;font-size: 0;">';
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
          <li class="index_li" style="text-align:left;height:auto;padding-top: 8px;padding-bottom:5px">
              <div style="border:0px solid;width:90%;margin:0 auto">
                <a style="color: rgba(0,0,0,0.87);font-size:13px;" href="<?php echo $url ?>"><?php echo $title; ?></a>
                <br/>
                <span style="color: #f00;margin:0px;"><?php echo $price; ?></span>
              </div>
              <a href="<?php echo $url; ?>"><img style="margin:3px auto;width:90%" src="<?php echo $medium_image_url[0];?>"/></a>
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
</div>
<!-- <div style="width:100%;background:#ff8875;height:30px;">
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
</div> -->

<!-- <br style="clear: both;"/>

<div class="shouyelogo123412123" style="width:100%;height:auto;margin-top:10px;">
<div style="width:100%;background:#ff8875;height:30px;">
  <p style="margin:0;text-align:center;font-size:20px;color:#ffffff">优惠券</p>
</div> 
<?php 
//
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
</div> -->




<!-- <hr style='width:100%;height:20px;'/>
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
</div> -->
<script type="text/javascript">

  //cai_index sheng_index
  jQuery(document).ready(function(){
    var cai=jQuery('#cai');
    var sheng=jQuery('#sheng');
    var jin=jQuery('#jin');
    var cai_index=jQuery('#cai_index');
    var sheng_index=jQuery('#sheng_index');
    var jin_index=jQuery('#jin_index');
    cai.click(function(){
      cai_index.show();
      sheng_index.hide();
      jin_index.hide();
      cai.css('color','rgba(0,0,0,0.87)');
      cai.css('border-bottom','4px solid #ff5722');
      sheng.css('color','rgba(0,0,0,0.54)');
      sheng.css('border-bottom','0px solid #ff5722');
      jin.css('color','rgba(0,0,0,0.54)');
      jin.css('border-bottom','0px solid #ff5722');
    });
    sheng.click(function(){
      cai_index.hide();
      sheng_index.show();
      jin_index.hide();
      sheng.css('color','rgba(0,0,0,0.87)');
      sheng.css('border-bottom','4px solid #ff5722');
      cai.css('color','rgba(0,0,0,0.54)');
      cai.css('border-bottom','0px solid #ff5722');
      jin.css('color','rgba(0,0,0,0.54)');
      jin.css('border-bottom','0px solid #ff5722');
    });
    jin.click(function(){
      cai_index.hide();
      sheng_index.hide();
      jin_index.show();
      jin.css('color','rgba(0,0,0,0.87)');
      jin.css('border-bottom','4px solid #ff5722');
      cai.css('color','rgba(0,0,0,0.54)');
      cai.css('border-bottom','0px solid #ff5722');
      sheng.css('color','rgba(0,0,0,0.54)');
      sheng.css('border-bottom','0px solid #ff5722');
    });
  });
</script>