<?php get_header();?>
<?php
/**
    Template Name:card
 */
?>
<style type="text/css">
.index_li{
    width:40%;
    float:left;
    margin:5px 5%;
}
.index_li div{
	width: 100%;
	margin: 0;
	padding: 0;
}
.index_li p{
	margin-top:5px;margin-bottom: 0;text-align: center;font-size:16px;font-weight:bold
}
</style>
<div style="background-color:#e3e3e3;padding-bottom: 20px;">
	<div id="shouyelogo" style="width:100%;height:auto;">
		<div style="margin-bottom:10px;">
			<img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/card_title.png' ?>"/>
			<img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/card_title1.png' ?>"/>
		</div>
	</div>
	<img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/card_title3.png' ?>"/>
	<ul style="overflow:hidden;margin-top:20px;">
		<li class="index_li">
			<div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/card1.png' ?>" />
				<p style="">生肖纪念卡</p>
			</div>
		</li>
		<li class="index_li">
			<div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/card6.png' ?>" />
				<p>异形卡</p>
			</div>
		</li>
		<li class="index_li">
			<div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/card5.png' ?>" />
				<p>青岛风光纪念卡</p>
			</div>
		</li>
		<li class="index_li">
			<div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/card4.png' ?>" />
				<p>挂件卡</p>
			</div>
		</li>
		<li class="index_li">
			<div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/card3.png' ?>" />
				<p>异形卡</p>
			</div>
		</li>
		<li class="index_li">
			<div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/card2.png' ?>" />
			</div>
		</li>
	</ul>
</div>