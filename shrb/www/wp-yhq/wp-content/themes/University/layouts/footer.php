<?php 
	
	/**
	 *
	 * Template footer
	 *
	 **/
	
	// create an access to the template main object
	global $gk_tpl;
	
	// disable direct access to the file	
	defined('GAVERN_WP') or die('Access denied');
	
?>
</div><!-- end of the gk-bg div -->
	<footer id="gk-footer">
		<div class="gk-page">			
			<?php gavern_menu('footermenu', 'gk-footer-menu'); ?>
			
			<div class="gk-copyrights">
				<?php echo str_replace('\\', '', htmlspecialchars_decode(get_option($gk_tpl->name . '_template_footer_content', ''))); ?>
			</div>
			
			<?php if(get_option($gk_tpl->name . '_styleswitcher_state', 'Y') == 'Y') : ?>
			<div id="gk-style-area">
				<?php for($i = 0; $i < count($gk_tpl->styles); $i++) : ?>
				<div class="gk-style-switcher-<?php echo $gk_tpl->styles[$i]; ?>">
					<?php 
						$j = 1;
						foreach($gk_tpl->style_colors[$gk_tpl->styles[$i]] as $stylename => $link) : 
					?> 
					<a href="#<?php echo $link; ?>" id="gk-color<?php echo $j++; ?>"><?php echo $stylename; ?></a>
					<?php endforeach; ?>
				</div>
				<?php endfor; ?>
			</div>
			<?php endif; ?>
			
			<?php if(get_option($gk_tpl->name . '_template_footer_logo', 'Y') == 'Y') : ?>
			<img src="<?php echo gavern_file_uri('images/gavernwp.png'); ?>" class="gk-framework-logo" alt="GavernWP" />
			<?php endif; ?>
		</div>
	</footer>
	
	<i id="close-menu" class="fa fa-times"></i>
	<nav id="aside-menu">
		<div>
			<div id="gk-aside-menu">
				<?php gavern_menu('mainmenu', 'gk-aside-menu', array('walker' => new GKMenuWalker())); ?>
			</div>
		</div>
	</nav>
	
	<?php gk_load('popups'); ?>
	<?php gk_load('social'); ?>
	
	<?php do_action('gavernwp_footer'); ?>
	
	<?php 
		echo stripslashes(
			htmlspecialchars_decode(
				str_replace( '&#039;', "'", get_option($gk_tpl->name . '_footer_code', ''))
			)
		); 
	?>
	
	<?php wp_footer(); ?>
	
	<?php do_action('gavernwp_ga_code'); ?>
</body>
</html>
