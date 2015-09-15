<?php

/**
 * 
 * GK Tweets Widget class
 *
 **/

require_once(gavern_file('gavern/classes/class.gkoauth.php'));

class GK_Tweets_Widget extends WP_Widget {
	/**
	 *
	 * Constructor
	 *
	 * @return void
	 *
	 **/
	function GK_Tweets_Widget() {
		$this->WP_Widget(
			'widget_gk_tweets', 
			__( 'GK Tweets Widget', GKTPLNAME ), 
			array( 
				'classname' => 'widget_gk_tweets', 
				'description' => __( 'Use this widget to show recent tweets for specific query', GKTPLNAME) 
			)
		);
		
		$this->alt_option_name = 'widget_gk_tweets';
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
		$cache = get_transient(md5($this->id));
		
		// the part with the title and widget wrappers cannot be cached! 
		// in order to avoid problems with the calculating columns
		//
		extract($args, EXTR_SKIP);
		
		$title = apply_filters('widget_title', empty($instance['title']) ? __( 'GK Tweets', GKTPLNAME ) : $instance['title'], $instance, $this->id_base);
		
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
		$query = empty($instance['query']) ? 'gavickpro' : $instance['query'];
		$rpp = (int) empty($instance['rpp']) ? '5' : $instance['rpp'];
		$result_type = empty($instance['result_type']) ? 'recent' : $instance['result_type'];
		$show_avatar = empty($instance['show_avatar']) ? 'true' : $instance['show_avatar'];
		$show_links = empty($instance['show_links']) ? 'true' : $instance['show_links'];
		$show_date = empty($instance['show_date']) ? 'true' : $instance['show_date'];
		$consumer_key = empty($instance['consumer_key']) ? 'empty' : $instance['consumer_key'];
		$consumer_secret = empty($instance['consumer_secret']) ? 'empty' : $instance['consumer_secret'];
		$user_token = empty($instance['user_token']) ? 'empty' : $instance['user_token'];
		$user_secret = empty($instance['user_secret']) ? 'empty' : $instance['user_secret'];
		
		// authorize user based od widget configuration keys
		$GKOAuth= new GKOAuth(array(
		               	 'consumer_key' => $consumer_key,
		               	 'consumer_secret' => $consumer_secret,
		               	 'user_token' => $user_token,
		               	 'user_secret' => $user_secret,
		               	 'curl_ssl_verifypeer' => false
		               	));
		               	
		// build twitter search query                 
		$GKOAuth->request('GET', 'https://api.twitter.com/1.1/search/tweets.json',array('q' => $query, 'count' => $rpp, 'result_type' => $result_type));
		
		echo '<div class="gk_tweets_widget">' . "\n";
		
		if($GKOAuth->response['error'] == '') {              
            if($query != '') {
	            if($rpp > 0) {
		            // decode the received values
		            $decode = $GKOAuth->response;
		            // count the received data
		            $count = count($decode['statuses']);
		            // parse the data
		            for($i = 0; $i < $count; $i++) {
		            	$text = $decode['statuses'][$i]['text'];
		            	
		            	preg_match_all('/#\w*/', $text, $matches, PREG_PATTERN_ORDER);
						foreach($matches as $key => $match) {
							foreach($match as $m) {
								$m = substr($m, 1);
								$text = str_replace($m, "<a href='https://twitter.com/#!/search/".$m."'>".$m."</a>", $text);
							}
						}
	
						preg_match_all('/@\w*/', $text, $matches, PREG_PATTERN_ORDER);
						foreach($matches as $key => $match) {
							foreach($match as $m) {
								$m = substr($m, 1);
								$text = str_replace($m, "<a href='https://twitter.com/#!/".$m."'>".$m."</a>", $text);
							}
						}
	
						preg_match_all('/http:\/\/\S*/', $text, $matches, PREG_PATTERN_ORDER);
						foreach($matches as $key => $match) {
							foreach($match as $m) {
								$text = str_replace($m, "<a href='".$m."'>".$m."</a>", $text);
							}
						}
		            	
		            	$date = date('c', strtotime($decode['statuses'][$i]['created_at']));
		            	$user = $decode['statuses'][$i]['user']['screen_name'];
		            	$username = $decode['statuses'][$i]['user']['name'];
		            	$userURL = 'https://twitter.com/'.$user;
		            	$tweet_url = $userURL.'/status/'.$decode['statuses'][$i]['id'];
		            	$fav_url = 'https://twitter.com/intent/favorite?tweet_id=' . $decode['statuses'][$i]['id'];
		            	$retweet_url = 'https://twitter.com/intent/retweet?tweet_id=' . $decode['statuses'][$i]['id'];
		            	$reply_url = 'https://twitter.com/intent/tweet?in_reply_to=' . $decode['statuses'][$i]['id'];
		            	$avatar_url = $decode['statuses'][$i]['user']['profile_image_url_https']; 
		            	 
		            	echo '<div class="gk-tweet">' . "\n";
		            	echo '<div>' . "\n";
		            	
		            	if($show_avatar == 'true') {
		            		echo '<img src="'.$avatar_url.'" alt="'.$username.' - Avatar" />';
		            	}
		            	
		            	echo '<span class="gk-tweet-name"><a href="'.$userURL.'">'.$user.'</a><small>'.$username.'</small></span>' . "\n";
		            	
		            	echo '<p class="gk-tweet-content">' . $text . '</p>' . "\n";
		            	
		            	if($show_date == 'true') {
		            		echo '<a class="gk-tweet-date" href="'.$tweet_url.'"><time datetime="'.$date.'">'.date('d M Y, G:i', strtotime($date)).'</time></a>' . "\n";
		            	}
		            	
		            	if( $show_links == 'true') {
			            	echo '<span class="gk-tweet-info">';
			            			
							if($show_links == 'true') {
			            		echo '<a class="gk-reply" href="'.$reply_url.'">'.__('Reply', GKTPLNAME).'</a>';
			            		echo '<a class="gk-retweet" href="'.$retweet_url.'">'.__('Retweet', GKTPLNAME).'</a>';
			            		echo '<a class="gk-favorite" href="'.$fav_url.'">'.__('Favorite', GKTPLNAME).'</a>';
			            	}
			            									
			            	echo '</span>';
		            	}
		            	
		            	echo '</div>' . "\n";
		            	echo '</div>' . "\n";
		            }
	            } else {
	            	_e('The amount of tweets must be bigger than 0', GKTPLNAME);
	            }
            } else {
            	_e('The specified query is empty', GKTPLNAME);
            }
		} else {
			echo $GKOAuth->response['error'];
		}
		
		echo '</div>' . "\n";
		// save the cache results
		$cache_output = ob_get_flush();		
		set_transient(md5($this->id) , $cache_output, 10 * 60);
		
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
		$instance['query'] = strip_tags($new_instance['query']);
		$instance['rpp'] = strip_tags($new_instance['rpp']);
		$instance['result_type'] = strip_tags($new_instance['result_type']);
		$instance['show_avatar'] = strip_tags($new_instance['show_avatar']);
		$instance['show_links'] = strip_tags($new_instance['show_links']);
		$instance['show_date'] = strip_tags($new_instance['show_date']);
		$instance['consumer_key'] = strip_tags($new_instance['consumer_key']);
		$instance['consumer_secret'] = strip_tags($new_instance['consumer_secret']);
		$instance['user_token'] = strip_tags($new_instance['user_token']);
		$instance['user_secret'] = strip_tags($new_instance['user_secret']);
		

		$this->refresh_cache();

		$alloptions = wp_cache_get('alloptions', 'options');
		if(isset($alloptions['widget_gk_tweets'])) {
			delete_option( 'widget_gk_tweets' );
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
		delete_transient(md5($this->id));
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
		$query = isset($instance['query']) ? esc_attr($instance['query']) : 'gavickpro';
		$rpp = isset($instance['rpp']) ? esc_attr($instance['rpp']) : '5';
		$result_type = isset($instance['result_type']) ? esc_attr($instance['result_type']) : 'recent';
		$show_avatar = isset($instance['show_avatar']) ? esc_attr($instance['show_avatar']) : 'true';
		$show_links = isset($instance['show_links']) ? esc_attr($instance['show_links']) : 'true';
		$show_date = isset($instance['show_date']) ? esc_attr($instance['show_date']) : 'true';
		$consumer_key = isset($instance['consumer_key']) ? esc_attr($instance['consumer_key']) : '';
		$consumer_secret = isset($instance['consumer_secret']) ? esc_attr($instance['consumer_secret']) : '';
		$user_token = isset($instance['user_token']) ? esc_attr($instance['user_token']) : '';
		$user_secret = isset($instance['user_secret']) ? esc_attr($instance['user_secret']) : '';
		
	
	?>
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'title' ) ); ?>"><?php _e( 'Title:', GKTPLNAME ); ?></label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'title' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'title' ) ); ?>" type="text" value="<?php echo esc_attr( $title ); ?>" />
		</p>
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'query' ) ); ?>"><?php _e( 'Query:', GKTPLNAME ); ?></label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'query' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'query' ) ); ?>" type="text" value="<?php echo esc_attr( $query ); ?>" />
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'rpp' ) ); ?>"><?php _e( 'Amount of tweets:', GKTPLNAME ); ?></label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'rpp' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'rpp' ) ); ?>" type="text" value="<?php echo esc_attr( $rpp ); ?>" />
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'consumer_key' ) ); ?>"><?php _e( 'Consumer key:', GKTPLNAME ); ?></label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'consumer_key' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'consumer_key' ) ); ?>" placeholder="Please visit dev.twitter.com to generate key" type="text" value="<?php echo esc_attr( $consumer_key ); ?>" />
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'consumer_secret' ) ); ?>"><?php _e( 'Consumer secret:', GKTPLNAME ); ?></label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'consumer_secret' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'consumer_secret' ) ); ?>" placeholder="Please visit dev.twitter.com to generate key" type="text" value="<?php echo esc_attr( $consumer_secret ); ?>" />
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'user_token' ) ); ?>"><?php _e( 'User token:', GKTPLNAME ); ?></label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'user_token' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'user_token' ) ); ?>" placeholder="Please visit dev.twitter.com to generate key" type="text" value="<?php echo esc_attr( $user_token ); ?>" />
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'user_secret' ) ); ?>"><?php _e( 'User secret:', GKTPLNAME ); ?></label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'user_secret' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'user_secret' ) ); ?>" placeholder="Please visit dev.twitter.com to generate key" type="text" value="<?php echo esc_attr( $user_secret ); ?>" />
		</p>
		
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'result_type' ) ); ?>"><?php _e( 'Result type:', GKTPLNAME ); ?></label>
			<select id="<?php echo esc_attr( $this->get_field_id( 'result_type' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'result_type' ) ); ?>">
				<option value="mixed" <?php if(esc_attr( $result_type ) == 'mixed') : ?>selected="selected"<?php endif; ?>><?php _e('Mixed (Recent and Popular)', GKTPLNAME); ?></option>
				<option value="recent" <?php if(esc_attr( $result_type ) == 'recent') : ?>selected="selected"<?php endif; ?>><?php _e('Recent', GKTPLNAME); ?></option>
				<option value="popular" <?php if(esc_attr( $result_type ) == 'popular') : ?>selected="selected"<?php endif; ?>><?php _e('Popular', GKTPLNAME); ?></option>
			</select>
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'show_avatar' ) ); ?>" style="display: block; width: 100%;"><?php _e( 'Show avatar:', GKTPLNAME ); ?></label>
			
			<select id="<?php echo esc_attr( $this->get_field_id( 'show_avatar' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'show_avatar' ) ); ?>">
				<option value="true" <?php if(esc_attr( $show_avatar ) == 'true') : ?>selected="selected"<?php endif; ?>><?php _e('Enabled', GKTPLNAME); ?></option>
				<option value="false" <?php if(esc_attr( $show_avatar ) == 'false') : ?>selected="selected"<?php endif; ?>><?php _e('Disabled', GKTPLNAME); ?></option>
			</select>
		</p>

		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'show_links' ) ); ?>" style="display: block; width: 100%;"><?php _e( 'Show links:', GKTPLNAME ); ?></label>
			
			<select id="<?php echo esc_attr( $this->get_field_id( 'show_links' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'show_links' ) ); ?>">
				<option value="true" <?php if(esc_attr( $show_links ) == 'true') : ?>selected="selected"<?php endif; ?>><?php _e('Enabled', GKTPLNAME); ?></option>
				<option value="false" <?php if(esc_attr( $show_links ) == 'false') : ?>selected="selected"<?php endif; ?>><?php _e('Disabled', GKTPLNAME); ?></option>
			</select>
		</p>
		
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'show_date' ) ); ?>" style="display: block; width: 100%;"><?php _e( 'Show date:', GKTPLNAME ); ?></label>
			
			<select id="<?php echo esc_attr( $this->get_field_id( 'show_date' ) ); ?>" name="<?php echo esc_attr( $this->get_field_name( 'show_date' ) ); ?>">
				<option value="true" <?php if(esc_attr( $show_date ) == 'true') : ?>selected="selected"<?php endif; ?>><?php _e('Enabled', GKTPLNAME); ?></option>
				<option value="false" <?php if(esc_attr( $show_date ) == 'false') : ?>selected="selected"<?php endif; ?>><?php _e('Disabled', GKTPLNAME); ?></option>
			</select>
		</p>
	<?php
	}
}

// EOF