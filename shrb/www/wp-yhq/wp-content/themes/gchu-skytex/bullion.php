<?php get_header();?>
<?php
/**
    Template Name:bullion
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
.title_li{
    width:50%;
    float:left;
    background: #b5b5b5;
}
.title_li p{
	text-align: center;
	line-height: 50px;
	height: 50px;
	margin: 0;
	font-family: '黑体';
	font-size: 20px;
}
</style>
<div style="padding-bottom: 20px;background:#f3e3cc">
	<div style="width:100%;height:auto;">
		<div id="bullion" style="margin-bottom:10px;">
			<img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/bullion_title.png' ?>"/>
		</div>
		<div id="ingot" style="margin-bottom:10px;display:none;">
			<img style="width:100%" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/ingot_title.png' ?>"/>
		</div>
	</div>
	<ul style="overflow:hidden;margin:0;">
		<li id="bullion_li" class="title_li">
			<p>沃德金条</p>
		</li>
		<li id="ingot_li" class="title_li" style="background: #ffffff;">
			<p>沃德元宝</p>
		</li>
	</ul>
	<img style="width:100%;margin:0;" src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/bullion_ingot.png' ?>"/>
	<ul id="bullion_ul" style="overflow:hidden;">
		<li>
			<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/bullion1.png' ?>" />
		</li>
		<li>
			<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/bullion.png' ?>" />
		</li>
		<li>
			<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/bullion2.png' ?>" />
		</li>
	</ul>
	<ul id="ingot_ul" style="overflow:hidden;margin:0;display:none;">
		<li>
			<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/ingot.png' ?>" />
		</li>
		<li>
			<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/ingot1.png' ?>" />
		</li>
		<li>
			<img src="<?php echo CURRENT_TEMPLATE_DIR.'/simages/ingot2.png' ?>" />
		</li>
	</ul>
</div>
<script type="text/javascript">
	jQuery("#bullion_li").click(function(){
		var bullion=jQuery('#bullion');
		var bullion_li=jQuery(this);
		var bullion_ul=jQuery('#bullion_ul');
		var ingot=jQuery('#ingot');
		var ingot_li=jQuery('#ingot_li');
		var ingot_ul=jQuery('#ingot_ul');
		bullion.show();
		bullion_ul.show();
		bullion_li.css('background','#b5b5b5');
		ingot.hide();
		ingot_ul.hide();
		ingot_li.css('background','#ffffff');
	});
	jQuery("#ingot_li").click(function(){
		var bullion=jQuery('#bullion');
		var bullion_li=jQuery('#bullion_li');
		var bullion_ul=jQuery('#bullion_ul');
		var ingot=jQuery('#ingot');
		var ingot_li=jQuery(this);
		var ingot_ul=jQuery('#ingot_ul');
		bullion.hide();
		bullion_ul.hide();
		bullion_li.css('background','#ffffff');
		ingot.show();
		ingot_ul.show();
		ingot_li.css('background','#b5b5b5');
	});
</script>