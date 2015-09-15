<?php
	add_filter( 'template_include','pb_group_template');
	// add_action( 'template_redirect', 'pb_group_template');
	function pb_group_template($template)
	{
		// $template=$template.'/ugen';home_url()		
		$template_url=get_stylesheet_directory();
		if(get_post_type()==PB_MENU_CONFIG::$MENU['group']['post_type'])
		{
			$template=$template_url.'/ugen/single-'.get_post_type().'.php';
		}
		elseif(get_post_type()==PB_MENU_CONFIG::$MENU['flashSale']['post_type'])
		{
			$template=$template_url.'/ugen/single-'.get_post_type().'.php';
		}
		// elseif(is_page())
		// {
		// 	// print_r($template=get_stylesheet_directory());
		// 	$template=$template.'/ugen/page.php';
		// }
		return $template;
	}
?>