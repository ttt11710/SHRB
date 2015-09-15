<?php get_header();?>
<?php
/**
    Template Name:fund_insurance
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
<div style="padding-bottom: 20px;">
	<div style="width:100%;height:auto;">
		<div style="margin-bottom:10px;">
			<img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/fund_title.png' ?>"/>
			<a href="<?php echo home_url().'/nuo_fund' ?>"><img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/fund_title1.png' ?>"/></a>
		</div>
	</div>
	<img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/insurance_title.png' ?>"/>
	<ul style="overflow:hidden;margin-top:20px;">
		<li class="index_li">
			<a href="<?php echo home_url().'/xing_fu' ?>"><div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/insurance2.png' ?>" />
				<p style="">幸福无忧</p>
			</div></a>
		</li>
		<li class="index_li">
			<a href="<?php echo home_url().'/an_bang' ?>"><div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/insurance1.png' ?>" />
				<p>安邦共赢3号</p>
			</div></a>
		</li>
		<li class="index_li">
			<a href="<?php echo home_url().'/taikang' ?>"><div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/insurance4.png' ?>" />
				<p>养老保险</p>
			</div></a>
		</li>
		<li class="index_li">
			<a href="<?php echo home_url().'/duanqi' ?>"><div>
				<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/insurance3.png' ?>" />
				<p>短期意外保障计划</p>
			</div></a>
		</li>
	</ul>
</div>