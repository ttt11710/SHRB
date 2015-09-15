<?php

/**
 * 
 * GK ImageShow Widget class
 *
 **/

class GK_ImageShow_Widget extends WP_Widget {
	// static field used to detect if the CSS code was generated
	static public $css_generated = false;
	/**
	 *
	 * Constructor
	 *
	 * @return void
	 *
	 **/
	function GK_ImageShow_Widget() {
		$this->WP_Widget(
			'widget_gk_image_show', 
			__( 'GK Image Show', GKTPLNAME ), 
			array( 
				'classname' => 'widget_gk_image_show', 
				'description' => __( 'Use this widget to show animated header', GKTPLNAME) 
			),
			array(
				'width' => 250, 
				'height' => 300
			)
		);
		
		$this->alt_option_name = 'widget_gk_image_show';
		// generate the head output
		add_action('wp_print_styles', array('GK_ImageShow_Widget', 'generateCSS'));
	}

	/**
	 *
	 * Outputs the HTML code of this widget.
	 *
	 * @param array An array of standard parameters for widgets in this theme
	 * @param array An array of settings for this widget instance
	 * @return void
	 *
	 **/
	function widget($args, $instance) {
		$cache = wp_cache_get('widget_gk_image_show', 'widget');
		
		//check the cache
		if(!is_array($cache)) {
			$cache = array();
		}

		if(!isset($args['widget_id'])) {
			$args['widget_id'] = null;
		}

		if(isset($cache[$args['widget_id']])) {
			echo $cache[$args['widget_id']];
			return;
		}

		ob_start();
		//
		extract($args, EXTR_SKIP);
		//
		$images = empty($instance['images']) ? '' : $instance['images'];
		$images = explode(',', $images);
		$titles = array();
		$text_show = empty($instance['text_show']) ? 'on' : $instance['text_show'];
		$pagination = empty($instance['pagination']) ? 'on' : $instance['pagination'];
		$speed = empty($instance['animation_speed']) ? '500' : $instance['animation_speed'];
		$interval = empty($instance['animation_interval']) ? '5000' : $instance['animation_interval'];
		$autoanim = empty($instance['autoanimation']) ? 'on' : $instance['autoanimation'];
		
		// if there are some images
		if(count($images) > 0) {
			// get the images data
			for($i = 0; $i < count($images); $i++) {
				$images[$i] = get_page_by_title($images[$i], 'OBJECT', 'attachment');
				$titles[$i] = $images[$i]->post_excerpt;
				$links[$i] = get_post_meta($images[$i]->ID, '_wp_attachment_image_alt', true);
			}
			//
			echo $before_widget;
			// render the opening wrappers
			echo '<div id="gk-is-'.$args['widget_id'].'" class="gk-is-wrapper-gk-university" data-speed="'.$speed.'" data-interval="'.$interval.'" data-autoanim="'.$autoanim.'">';
			// preloader
			echo '<div class="gk-is-preloader">';
				echo '<div class="spinner">';
					echo '<div class="dot1"></div>';
					echo '<div class="dot2"></div>';
				echo '</div>';
			echo '</div>';

			// generate images
			for($i = 0; $i < count($images); $i++) {									
				echo '<figure data-url="'.$images[$i]->guid.'" data-link="'.$titles[$i].'" data-zindex="'.$i.'" data-title="'.strip_tags($images[$i]->post_content).'">';
				
				if($images[$i]->post_content != '') {
					echo '<figcaption class="gk-page">';
					echo '<div>';
					if($titles[$i] != '') {
						echo '<h2><a href="'.$links[$i].'">' . $titles[$i] . '</a></h2>';
					}
					
					if($images[$i]->post_content != '') {
						echo '<p><a href="'.$links[$i].'">' . $images[$i]->post_content . '</a></p>';
					}
					
					if($autoanim == 'on') {					
					// progress bar
					echo '<div class="gk-is-timeline">';	
					echo '<div class="gk-is-progress"></div>';
					echo '</div>';
					}
					
					
					echo '</div>';
					echo '</figcaption>';
				}
			
				echo '</figure>';
			}
			
			// arrows		
			if($pagination == 'on') {					
				echo '<ul class="gk-is-pagination">';
				for($i = 0; $i < count($images); $i++) {
					echo '<li'.(($i == 0) ? ' class="active"' : '').'>'.$i.'</li>';	
				}
				echo '</ul>';
			}
			// the last wrapper
			echo '</div>';
			// 
			echo $after_widget;
		}
		// save the cache results
		$cache[$args['widget_id']] = ob_get_flush();
		wp_cache_set('widget_gk_image_show', $cache, 'widget');
	}

	/**
	 *
	 * Used in the back-end to update the module options
	 *
	 * @param array new instance of the widget settings
	 * @param array old instance of the widget settings
	 * @return updated instance of the widget settings
	 *
	 **/
	function update( $new_instance, $old_instance ) {
		$instance = $old_instance;
		$instance['title'] = strip_tags($new_instance['title']);
		$instance['images'] = strip_tags($new_instance['images']);
		
		$instance['image_width'] = strip_tags($new_instance['image_width']);
		$instance['image_height'] = strip_tags($new_instance['image_height']);
		
		$instance['tablet_image_width'] = strip_tags($new_instance['tablet_image_width']);
		$instance['tablet_image_height'] = strip_tags($new_instance['tablet_image_height']);
		
		$instance['mobile_image_width'] = strip_tags($new_instance['mobile_image_width']);
		$instance['mobile_image_height'] = strip_tags($new_instance['mobile_image_height']);
		
		$instance['text_show'] = strip_tags($new_instance['text_show']);
		$instance['pagination'] = strip_tags($new_instance['pagination']);
		$instance['animation_speed'] = strip_tags($new_instance['animation_speed']);
		$instance['animation_interval'] = strip_tags($new_instance['animation_interval']);
		$instance['autoanimation'] = strip_tags($new_instance['autoanimation']);

		$this->refresh_cache();

		$alloptions = wp_cache_get('alloptions', 'options');
		if(isset($alloptions['widget_gk_image_show'])) {
			delete_option( 'widget_gk_image_show' );
		}

		return $instance;
	}

	/**
	 *
	 * Refreshes the widget cache data
	 *
	 * @return void
	 *
	 **/

	function refresh_cache() {
		wp_cache_delete( 'widget_gk_image_show', 'widget' );
	}

	/**
	 *
	 * Outputs the HTML code of the widget in the back-end
	 *
	 * @param array instance of the widget settings
	 * @return void - HTML output
	 *
	 **/
	function form($instance) {
		$title = isset($instance['title']) ? esc_attr($instance['title']) : '';
		$images = isset($instance['images']) ? esc_attr($instance['images']) : '';
		
		$image_width = isset($instance['image_width']) ? esc_attr($instance['image_width']) : '2080';
		$image_height = isset($instance['image_height']) ? esc_attr($instance['image_height']) : '936';
		
		$tablet_image_width = isset($instance['tablet_image_width']) ? esc_attr($instance['tablet_image_width']) : '1100';
		$tablet_image_height = isset($instance['tablet_image_height']) ? esc_attr($instance['tablet_image_height']) : '495';
		
		$mobile_image_width = isset($instance['mobile_image_width']) ? esc_attr($instance['mobile_image_width']) : '570';
		$mobile_image_height = isset($instance['mobile_image_height']) ? esc_attr($instance['mobile_image_height']) : '234';
		
		$text_show = isset($instance['text_show']) ? esc_attr($instance['text_show']) : 'on';
		$pagination = isset($instance['pagination']) ? esc_attr($instance['pagination']) : 'on';
		$animation_speed = isset($instance['animation_speed']) ? esc_attr($instance['animation_speed']) : '500';
		$animation_interval = isset($instance['animation_interval']) ? esc_attr($instance['animation_interval']) : '5000';
		$autoanimation = isset($instance['autoanimation']) ? esc_attr($instance['autoanimation']) : 'on';

	?>
		<div class="gk-is">
			<p>
				<label class="left" for="<?php echo esc_attr( $this->get_field_id( 'title' ) ); ?>"><?php _e( 'Title:', GKTPLNAME ); ?></label>
				<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'title' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'title' ) ); ?>" type="text" value="<?php echo esc_attr( $title ); ?>" />
			</p>
			
			<p>
				<label class="left" for="<?php echo esc_attr( $this->get_field_id( 'images' ) ); ?>"><?php _e( 'Slides:', GKTPLNAME ); ?></label>
				<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'images' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'images' ) ); ?>" type="text" value="<?php echo esc_attr( $images ); ?>" />
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'image_width' ) ); ?>"><?php _e( 'Image width:', GKTPLNAME ); ?></label>
				<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'image_width' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'image_width' ) ); ?>" type="text" value="<?php echo esc_attr( $image_width ); ?>" />px
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'image_height' ) ); ?>"><?php _e( 'Image height:', GKTPLNAME ); ?></label>
				<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'image_height' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'image_height' ) ); ?>" type="text" value="<?php echo esc_attr( $image_height ); ?>" />px
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'tablet_image_width' ) ); ?>"><?php _e( 'Tablet image width:', GKTPLNAME ); ?></label>
				<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'tablet_image_width' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'tablet_image_width' ) ); ?>" type="text" value="<?php echo esc_attr( $tablet_image_width ); ?>" />px
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'tablet_image_height' ) ); ?>"><?php _e( 'Tablet image height:', GKTPLNAME ); ?></label>
				<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'tablet_image_height' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'tablet_image_height' ) ); ?>" type="text" value="<?php echo esc_attr( $tablet_image_height ); ?>" />px
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'mobile_image_width' ) ); ?>"><?php _e( 'Mobile image width:', GKTPLNAME ); ?></label>
				<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'mobile_image_width' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'mobile_image_width' ) ); ?>" type="text" value="<?php echo esc_attr( $mobile_image_width ); ?>" />px
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'mobile_image_height' ) ); ?>"><?php _e( 'Mobile image height:', GKTPLNAME ); ?></label>
				<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'mobile_image_height' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'mobile_image_height' ) ); ?>" type="text" value="<?php echo esc_attr( $mobile_image_height ); ?>" />px
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'text_show' ) ); ?>"><?php _e('Show text block', GKTPLNAME); ?></label>
				
				<select id="<?php echo esc_attr( $this->get_field_id('text_show')); ?>" name="<?php echo esc_attr( $this->get_field_name('text_show')); ?>">
					<option value="on"<?php echo (esc_attr($text_show) == 'on') ? ' selected="selected"' : ''; ?>>
						<?php _e('On', GKTPLNAME); ?>
					</option>
					<option value="off"<?php echo (esc_attr($text_show) == 'off') ? ' selected="selected"' : ''; ?>>
						<?php _e('Off', GKTPLNAME); ?>
					</option>
				</select>
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'pagination' ) ); ?>"><?php _e('Pagination', GKTPLNAME); ?></label>
				
				<select id="<?php echo esc_attr( $this->get_field_id('pagination')); ?>" name="<?php echo esc_attr( $this->get_field_name('pagination')); ?>">
					<option value="on"<?php echo (esc_attr($pagination) == 'on') ? ' selected="selected"' : ''; ?>>
						<?php _e('On', GKTPLNAME); ?>
					</option>
					<option value="off"<?php echo (esc_attr($pagination) == 'off') ? ' selected="selected"' : ''; ?>>
						<?php _e('Off', GKTPLNAME); ?>
					</option>
				</select>
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'animation_speed' ) ); ?>"><?php _e( 'Animation speed:', GKTPLNAME ); ?></label>
				<input id="<?php echo esc_attr( $this->get_field_id( 'animation_speed' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'animation_speed' ) ); ?>" type="text" value="<?php echo esc_attr( $animation_speed ); ?>" />ms
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'animation_interval' ) ); ?>"><?php _e( 'Animation interval:', GKTPLNAME ); ?></label>
				<input id="<?php echo esc_attr( $this->get_field_id( 'animation_interval' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'animation_interval' ) ); ?>" type="text" value="<?php echo esc_attr( $animation_interval ); ?>" />ms
			</p>
			
			<p>
				<label for="<?php echo esc_attr( $this->get_field_id( 'autoanimation' ) ); ?>"><?php _e('Autoanimation', GKTPLNAME); ?></label>
				
				<select id="<?php echo esc_attr( $this->get_field_id('autoanimation')); ?>" name="<?php echo esc_attr( $this->get_field_name('autoanimation')); ?>">
					<option value="on"<?php echo (esc_attr($autoanimation) == 'on') ? ' selected="selected"' : ''; ?>>
						<?php _e('On', GKTPLNAME); ?>
					</option>
					<option value="off"<?php echo (esc_attr($autoanimation) == 'off') ? ' selected="selected"' : ''; ?>>
						<?php _e('Off', GKTPLNAME); ?>
					</option>
				</select>
			</p>
		</div>
		
		<hr class="clear" />
	<?php
	}
	
	static function generateCSS() {		
		if(!GK_ImageShow_Widget::$css_generated) {
			$values = get_option('widget_widget_gk_image_show', '');
			
			if(is_array($values)) {
				echo '<style type="text/css">';
				foreach($values as $key => $instance) {
					if(is_numeric($key)) {
						// generate the CSS styles
						$image_width = empty($instance['image_width']) ? '1720' : $instance['image_width'];
						$image_height = empty($instance['image_height']) ? '896' : $instance['image_height'];
						
						$tablet_image_width = empty($instance['tablet_image_width']) ? '1040' : $instance['tablet_image_width'];
						$tablet_image_height = empty($instance['tablet_image_height']) ?  '542' : $instance['tablet_image_height'];
						
						$mobile_image_width = empty($instance['mobile_image_width']) ? '640' : $instance['mobile_image_width'];
						$mobile_image_height = empty($instance['mobile_image_height']) ? '334' : $instance['mobile_image_height'];
						$widget_ID = $key;
						
						echo '#gk-is-widget_gk_image_show-'.$widget_ID.'.gk-is-wrapper-gk-university { 
						 	min-height: '.$image_height.'px; 
						 }
						 #gk-is-widget_gk_image_show-'.$widget_ID.'.gk-is-wrapper-gk-university .gk-is-slide { 
							background-size: '.$image_width.'px '.$image_height.'px;
							height: '.$image_height.'px;
							max-width: '.$image_width.'px;
						 }
						 @media (max-width: 1040px) {
						 	#gk-is-widget_gk_image_show-'.$widget_ID.'.gk-is-wrapper-gk-university {
						 		min-height: '.$tablet_image_height.'px;
						 	}
						 	
						 	#gk-is-widget_gk_image_show-'.$widget_ID.'.gk-is-wrapper-gk-university .gk-is-slide {
						 		background-size: '.$tablet_image_width.'px '.$tablet_image_height.'px;
						 		height: '.$tablet_image_height.'px;
						 		max-width: '.$tablet_image_width.'px;
						 	}
						 }
						 
						 @media (max-width: 640px) {
						 	#gk-is-widget_gk_image_show-'.$widget_ID.'.gk-is-wrapper-gk-university {
						 		min-height: '.$mobile_image_height.'px;
						 	}
						 	
						 	#gk-is-widget_gk_image_show-'.$widget_ID.'.gk-is-wrapper-gk-university .gk-is-slide {
						 		background-size: '.$mobile_image_width.'px '.$mobile_image_height.'px;
						 		height: '.$mobile_image_height.'px;
						 		max-width: '.$mobile_image_width.'px;
						 	}
						 } ';
					}
				}
				echo '</style>';
			}
			
			$css_generated = true;
		}
	}
}

// EOF