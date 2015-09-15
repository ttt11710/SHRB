<?php 
	
	/**
	 *
	 * Template elements before the page content
	 *
	 **/
	
	// create an access to the template main object
	global $gk_tpl, $post, $buddypress;
	
	// buddypress check
	include_once( ABSPATH . 'wp-admin/includes/plugin.php' );
	$bp_check = 'off';
	if( is_plugin_active('buddypress/bp-loader.php')) {
		if (bp_current_component()) {
			$bp_check = 'on';
		} else {
			$bp_check = 'off';
		}
	}
			
	// disable direct access to the file	
	defined('GAVERN_WP') or die('Access denied');
	
	// check if the sidebar is set to be a left column
	$args_val = $args == null || ($args != null && $args['sidebar'] == true);
	
	$gk_mainbody_class = '';
	
	if(get_option($gk_tpl->name . '_page_layout', 'right') == 'left' && gk_is_active_sidebar('sidebar') && $args_val) {
		$gk_mainbody_class .= ' gk-column-left';
	}
	
	if(get_option($gk_tpl->name . '_inset_position', 'right') == 'left' && gk_is_active_sidebar('inset') && $args_val) {
		$gk_mainbody_class .= ' gk-inset-left';
	}
	
	if(get_option($gk_tpl->name . '_inset_position', 'right') != 'none' && gk_is_active_sidebar('inset')) {
		$gk_mainbody_class .= ' has-inset';
	}
	
	if(get_option($gk_tpl->name . '_inset_position', 'right') == 'right' && gk_is_active_sidebar('inset') && (( get_option($gk_tpl->name . '_page_layout', 'right') == 'none') || !gk_is_active_sidebar('sidebar'))) {
		$gk_mainbody_class .= ' gk-inset-right-side';
	}
	
	if($gk_mainbody_class != '') {
		$gk_mainbody_class = ' class="'.$gk_mainbody_class.'" ';
	}
	
?>

<?php 
	if(get_option($gk_tpl->name . '_page_title', 'Y') == 'Y' && $bp_check == 'off')  {
		if (is_category() || is_single()) {
			echo '<h2 id="gk-page-title" class="gk-page"><span>' . get_the_category_list(' ') . '</span></h2>';
		}
		
		elseif (is_page()) {
			echo '<h2 id="gk-page-title" class="gk-page"><span>' . get_the_title() . '</span></h2>';
		}

		elseif (is_tag()) {
			echo '<h2 id="gk-page-title" class="gk-page"><span>' . __('Tag Archive', GKTPLNAME) . '</span></h2>';
		}
		
		elseif (is_author()) {
			echo '<h2 id="gk-page-title" class="gk-page"><span>' . __('Author Page', GKTPLNAME) . '</span></h2>';
		}
		
		elseif (is_search()) {
			echo '<h2 id="gk-page-title" class="gk-page"><span>' . __('Search Page', GKTPLNAME) . '</span></h2>';
		}
		
		elseif (is_archive()) {
			echo '<h2 id="gk-page-title" class="gk-page"><span>' . __('Archive', GKTPLNAME) . '</span></h2>';
		}
	}
	?>

<div class="gk-page-wrap<?php if(get_option($gk_tpl->name . '_template_homepage_mainbody', 'N') == 'N' && is_home()) : ?> gk-is-homepage<?php endif; ?>">
	<div class="gk-page">
		<div id="gk-mainbody-columns"<?php echo $gk_mainbody_class; ?>>	
		
			<?php if(gk_show_breadcrumbs()) : ?>
			<div id="gk-breadcrumb-area">
					<?php gk_breadcrumbs_output(); ?>
			</div>
			<?php endif; ?>
			
			<section>
				<div id="gk-content-wrap" <?php if(gk_is_active_sidebar('inset')) : ?> class="has-inset"<?php endif; ?>>
				<?php if(gk_is_active_sidebar('top1')) : ?>
				<div id="gk-top1">
					<div class="widget-area">
						<?php gk_dynamic_sidebar('top1'); ?>
						
						<!--[if IE 8]>
						<div class="ie8clear"></div>
						<![endif]-->
					</div>
				</div>
				<?php endif; ?>

				<!-- Mainbody -->
				<?php if(gk_is_active_sidebar('mainbody_top')) : ?>
				<div id="gk-mainbody-top">
					<?php gk_dynamic_sidebar('mainbody_top'); ?>
				</div>
				<?php endif; ?>