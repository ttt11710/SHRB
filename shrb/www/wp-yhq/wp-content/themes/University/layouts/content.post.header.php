<?php

/**
 *
 * The template fragment to show post header
 *
 **/

// disable direct access to the file	
defined('GAVERN_WP') or die('Access denied');

global $gk_tpl; 

$params = get_post_custom();
$params_title = isset($params['gavern-post-params-title']) ? esc_attr( $params['gavern-post-params-title'][0] ) : 'Y';
$params_aside = isset($params['gavern-post-params-aside']) ? $params['gavern-post-params-aside'][0] : false;
$params_image = isset($params['gavern-post-params-image']) ? esc_attr( $params['gavern-post-params-image'][0] ) : 'Y';

$param_aside = true;
$param_date = true;
	   
if($params_aside) {
	$params_aside = unserialize(unserialize($params_aside));
	$param_aside = $params_aside['aside'] == 'Y';
	$param_date = $params_aside['date'] == 'Y';
}

?>

<?php if(($param_aside) && ($param_date) && !is_search()) : ?>
	<?php if((!is_page_template('template.fullwidth.php') && ('post' == get_post_type() || 'page' == get_post_type())) && get_the_title() != '') : ?>
		<?php if(!('page' == get_post_type() && get_option($gk_tpl->name . '_template_show_details_on_pages', 'Y') == 'N')) : ?>
			<?php if(!('post' == get_post_type() && get_option($gk_tpl->name . '_post_aside_state', 'Y') == 'N')) : ?>
			<time class="entry-date" datetime="<?php echo esc_attr(get_the_date('c')); ?>">
					<?php echo esc_html(get_the_date('D')); ?>	
					<span><?php echo esc_html(get_the_date('M j')); ?></span>
			</time>
			<?php endif; ?>
		<?php endif; ?>
	<?php endif; ?>
<?php endif; ?>

<?php if(get_the_title() != '' && $params_title == 'Y') : ?>
<h<?php echo (is_singular()) ? '1' : '2'; ?>>
	<?php if(!is_singular()) : ?>
	<a href="<?php the_permalink(); ?>" title="<?php printf( esc_attr__( 'Permalink to %s', GKTPLNAME ), the_title_attribute( 'echo=0' ) ); ?>" rel="bookmark">
	<?php endif; ?>
		<?php the_title(); ?>
	<?php if(!is_singular()) : ?>
	</a>
	<?php endif; ?>
	
	<?php if(is_sticky()) : ?>
	<sup>
		<?php _e( 'Featured', GKTPLNAME ); ?>
	</sup>
	<?php endif; ?>
</h<?php echo (is_singular()) ? '1' : '2'; ?>>
<?php endif; ?>

<?php if((!is_page_template('template.fullwidth.php') && ('post' == get_post_type() || 'page' == get_post_type())) && get_the_title() != '') : ?>
	<?php if(!(get_post_type() == 'page' && get_option($gk_tpl->name . '_template_show_details_on_pages', 'Y') == 'N')) : ?>
		<?php if(!('post' == get_post_type() && get_option($gk_tpl->name . '_post_aside_state', 'Y') == 'N')) : ?>
			<?php gk_post_meta(); ?>
		<?php endif; ?>
	<?php endif; ?>
<?php endif; ?>

<?php do_action('gavernwp_before_post_content'); ?>