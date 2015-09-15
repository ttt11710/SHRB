<?php

/**
 * 
 * GK BP Widget class
 *
 **/

class GK_BP_Gallery_Widget extends WP_Widget {
	/**
	 *
	 * Constructor
	 *
	 * @return void
	 *
	 **/
	function GK_BP_Gallery_Widget() {
		$this->WP_Widget(
			'widget_gk_buddypress', 
			__( 'GK BuddyPress Gallery', GKTPLNAME ), 
			array( 
				'classname' => 'widget_gk_buddypress', 
				'description' => __( 'Use this widget to show recent statusk/photos of members', GKTPLNAME) 
			)
		);
		
		$this->alt_option_name = 'widget_gk_buddypress';
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
		global $bp;
		global $rtmedia_query, $rtmedia_interaction, $rtmedia_media;
		global $rtmedia_backbone;
		
		$cache = get_transient(md5($this->id));
		
		// the part with the title and widget wrappers cannot be cached! 
		// in order to avoid problems with the calculating columns
		//
		extract($args, EXTR_SKIP);
		
		$title = apply_filters('widget_title', empty($instance['title']) ? __( 'BuddyPress Activity', GKTPLNAME ) : $instance['title'], $instance, $this->id_base);
		
		echo $before_widget;
		echo $before_title;
		echo $title;
		echo $after_title;
		
		if($cache) {
			echo $cache;
			echo $after_widget;
			return;
		}

		ob_start();
		//
		$data_source_type = empty($instance['data_source_type']) ? 'latest' :  $instance['data_source_type'];
		$user_id  = empty($instance['user_id']) ? '' : $instance['user_id'];
		$total_amount = empty($instance['total_amount']) ? 8 : $instance['total_amount'];
		$show_username = empty($instance['show_username']) ? 'enable' : $instance['show_username'];
		$show_readmore = empty($instance['show_readmore']) ? 'enable' : $instance['show_readmore'];
		$amount_page = empty($instance['amount_page']) ? 4 : $instance['amount_page'];
		$autoanimation = empty($instance['autoanimation']) ? 'disable' : $instance['autoanimation'];
		$photo_width = empty($instance['photo_width']) ? 310 : $instance['photo_width'];
		$offset = empty($instance['offset']) ? 0 : $instance['offset'];	
		
		if(!is_numeric($offset)) { 
			$offset = 0;
		} else {
			$offset = intval($offset);
		}
		
		if(!is_numeric($total_amount)) {
			$total_amount = 0;
		} else {
			$total_amount = intval($total_amount);
		}
		
		$width = 3000;
		$new_width = $total_amount * $photo_width;
					
		if($new_width > 3000) {
			$width = $new_width;
		}
		
		$model = new RTMediaModel();	
		if ($data_source_type == 'user') {
			$media = $model->get_media ( array( 'media_type' => 'photo', 'media_author' => $user_id), $offset, $total_amount ); 
		}
		
		else {
			$media = $model->get_media ( array( 'media_type' => 'photo'), $offset, $total_amount );
		}

		?>
		
		<div data-cols="<?php echo $amount_page; ?>" style="width: <?php echo $width; ?>px" <?php if ($autoanimation == 'enabled') : echo 'class="animate"'; endif; ?>>
		
		<?php if ($media == null) : ?> 
			<h4> <?php echo __('GK BuddyPress Gallery: There has been no recent activity.', GKTPLNAME); ?></h4>
		<?php else : ?>
		
			<?php foreach($media as $img) : ?>
			<figure style="width: <?php echo $photo_width; ?>px">
				<img src="<?php rtmedia_image("rt_media_activity_image", rtmedia_id ( $img->media_id )); ?>" alt="<?php _e('View full image', GKTPLNAME); ?>" />
				<figcaption>
					<?php if($show_username == 'enabled') : ?>
						<small><?php echo rtmedia_get_author_name($img->media_author); ?></small>
					<?php endif; ?>
					
					<p><?php echo $this->activity_text($this->gk_activity_content($img->activity_id), 15, false); ?></p>
					
					<?php if($show_readmore == 'enabled') : ?>
						<a href ="<?php echo get_rtmedia_permalink ( rtmedia_id ( $img->media_id ) ); ?>"><?php _e('Read more...', GKTPLNAME); ?></a>
					<?php endif; ?>
				</figcaption>
			</figure>
			<?php endforeach; ?>
		
		<?php endif; ?>
		</div>
 
		
		<?php 
		// save the cache results
		$cache_output = ob_get_flush();
		set_transient(md5($this->id) , $cache_output, 3 * 60 * 60);
		// 
		echo $after_widget;
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
		$instance['title'] = strip_tags( $new_instance['title'] );
		$instance['data_source_type'] = strip_tags($new_instance['data_source_type']);
		$instance['user_id'] = strip_tags($new_instance['user_id']);
		$instance['total_amount'] = strip_tags($new_instance['total_amount']);
		$instance['show_username'] = strip_tags($new_instance['show_username']);
		$instance['show_readmore'] = strip_tags($new_instance['show_readmore']);
		$instance['amount_page'] = strip_tags( $new_instance['amount_page'] );
		$instance['autoanimation'] = strip_tags( $new_instance['autoanimation'] );
		$instance['photo_width'] = strip_tags( $new_instance['photo_width'] );
		$instance['offset'] = strip_tags( $new_instance['offset'] );
		$this->refresh_cache();

		$alloptions = wp_cache_get('alloptions', 'options');
		if(isset($alloptions['widget_gk_buddypress'])) {
			delete_option( 'widget_gk_buddypress' );
		}

		return $instance;
	}
	
	
	/**
	 *
	 * Limits the activity text to specified words amount
	 *
	 * @param string input text
	 * @param int amount of words
	 * @param string "readmore" text
	 * @param boolean enable/disable readmore text
	 * @return string the cutted text
	 *
	 **/
	function activity_text($input, $amount, $text_end) {	
		$output = '';
		$input = strip_tags($input);
		$input = explode(' ', $input);
		
		for($i = 0; $i < $amount; $i++) {
			if(isset($input[$i])) {
				$output .= $input[$i] . ' ';
			}
		}
		
		if(count($input) > $amount) {
			$output .= '&hellip;';
		}

		return $output;
	}
	
	/**
	 *
	 * Function to get activity content from activity id.
	 *
	 * @return activity content
	 *
	 **/
	function gk_activity_content( $activity_id ) {
		global $wpdb;
											
		$activity_content = $wpdb->get_var( $wpdb->prepare( "SELECT meta_value FROM {$wpdb->prefix}bp_activity_meta  WHERE activity_id = %s AND meta_key = 'bp_activity_text'", $activity_id ) );
		
		return $activity_content;
	}

	
	/**
	 *
	 * Refreshes the widget cache data
	 *
	 * @return void
	 *
	 **/

	function refresh_cache() {
		if(is_array(get_option('widget_widget_gk_buddypress'))) {
	    	$ids = array_keys(get_option('widget_widget_gk_buddypress'));
	    } else {
	    	$ids = array();
	    }
	    
	    for($i = 0; $i < count($ids); $i++) {
	        if(is_numeric($ids[$i])) {
	            delete_transient(md5('widget_gk_buddypress-' . $ids[$i]));
	        }
	    }
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
		$data_source_type = isset($instance['data_source_type']) ? esc_attr($instance['data_source_type']) : 'latest';
		$user_id  = isset($instance['user_id']) ? esc_attr($instance['user_id']) : '';
		$total_amount = isset($instance['total_amount']) ? esc_attr($instance['total_amount']) : 8;
		$show_username = isset($instance['show_username']) ? esc_attr($instance['show_username']) : 'enabled';
		$show_readmore = isset($instance['show_readmore']) ? esc_attr($instance['show_readmore']) : 'enabled';
		$amount_page = isset($instance['amount_page']) ? esc_attr($instance['amount_page']) : 4;
		$autoanimation = isset($instance['autoanimation']) ? esc_attr($instance['autoanimation']) : 'disabled';
		$photo_width = isset($instance['photo_width']) ? esc_attr($instance['photo_width']) : 310;
		$offset = isset($instance['offset']) ? esc_attr($instance['offset']) : 0;
	?>
	<div class="gk-bp">
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'title' ) ); ?>"><?php _e( 'Title:', GKTPLNAME ); ?></label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'title' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'title' ) ); ?>" type="text" value="<?php echo esc_attr( $title ); ?>" />
		</p>
				
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'data_source_type' ) ); ?>"><?php _e( 'Data source:', GKTPLNAME ); ?></label>
			
			<select id="<?php echo esc_attr( $this->get_field_id('data_source_type')); ?>" name="<?php echo esc_attr( $this->get_field_name('data_source_type')); ?>">
				<option value="latest"<?php echo (esc_attr($data_source_type) == 'latest') ? ' selected="selected"' : ''; ?>>
					<?php _e('Latest photos', GKTPLNAME); ?>
				</option>
				<option value="user"<?php echo (esc_attr($data_source_type) == 'user') ? ' selected="selected"' : ''; ?>>
					<?php _e('Specific user photos', GKTPLNAME); ?>
				</option>
			</select>
			
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'user_id' ) ); ?>"><?php _e( 'User ID:', GKTPLNAME ); ?></label>
			<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'user_id' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'user_id' ) ); ?>" type="text" value="<?php echo esc_attr( $user_id  ); ?>" />
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'offset' ) ); ?>"><?php _e( 'Offset:', GKTPLNAME ); ?></label>
			<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'offset' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'offset' ) ); ?>" type="text" value="<?php echo esc_attr( $offset ); ?>" />
		</p>
		
		<p>
			<label for="<?php echo esc_attr($this->get_field_id('total_amount')); ?>"><?php _e('Total amount of statuses', GKTPLNAME); ?></label>
			
			<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'total_amount' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'total_amount' ) ); ?>" type="text" value="<?php echo esc_attr( $total_amount ); ?>" />
		</p>
		
		<p>
			<label for="<?php echo esc_attr($this->get_field_id('amount_page')); ?>"><?php _e('Amount for page: ', GKTPLNAME); ?></label>
			
			<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'amount_page' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'amount_page' ) ); ?>" type="text" value="<?php echo esc_attr( $amount_page ); ?>" />
		</p>
		
		<p>
			<label for="<?php echo esc_attr($this->get_field_id('show_username')); ?>"><?php _e('Show username', GKTPLNAME); ?></label>
			
			<select id="<?php echo esc_attr( $this->get_field_id('show_username')); ?>" name="<?php echo esc_attr( $this->get_field_name('show_username')); ?>">
				<option value="enabled"<?php echo (esc_attr($show_username) == 'enabled') ? ' selected="selected"' : ''; ?>>
					<?php _e('Enabled', GKTPLNAME); ?>
				</option>
				<option value="disabled"<?php echo (esc_attr($show_username) == 'disabled') ? ' selected="selected"' : ''; ?>>
					<?php _e('Disabled', GKTPLNAME); ?>
				</option>
			</select>
		</p>
		
		<p>
			<label for="<?php echo esc_attr($this->get_field_id('show_readmore')); ?>"><?php _e('Show readmore', GKTPLNAME); ?></label>
			
			<select id="<?php echo esc_attr( $this->get_field_id('show_readmore')); ?>" name="<?php echo esc_attr( $this->get_field_name('show_readmore')); ?>">
				<option value="enabled"<?php echo (esc_attr($show_readmore) == 'enabled') ? ' selected="selected"' : ''; ?>>
					<?php _e('Enabled', GKTPLNAME); ?>
				</option>
				<option value="disabled"<?php echo (esc_attr($show_readmore) == 'disabled') ? ' selected="selected"' : ''; ?>>
					<?php _e('Disabled', GKTPLNAME); ?>
				</option>
			</select>
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'autoanimation' ) ); ?>"><?php _e( 'Autoanimation:', GKTPLNAME ); ?></label>
			<select id="<?php echo esc_attr( $this->get_field_id('autoanimation')); ?>" name="<?php echo esc_attr( $this->get_field_name('autoanimation')); ?>">
				<option value="enabled"<?php echo (esc_attr($show_readmore) == 'enabled') ? ' selected="selected"' : ''; ?>>
					<?php _e('Enabled', GKTPLNAME); ?>
				</option>
				<option value="disabled"<?php echo (esc_attr($autoanimation) == 'disabled') ? ' selected="selected"' : ''; ?>>
					<?php _e('Disabled', GKTPLNAME); ?>
				</option>
			</select>
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'photo_width' ) ); ?>"><?php _e( 'Photo width (px):', GKTPLNAME ); ?></label>
			<input class="short" id="<?php echo esc_attr( $this->get_field_id( 'photo_width' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'photo_width' ) ); ?>" type="text" value="<?php echo esc_attr( $photo_width ); ?>" />
		</p>
	</div>
	<?php
	}
}

// EOF