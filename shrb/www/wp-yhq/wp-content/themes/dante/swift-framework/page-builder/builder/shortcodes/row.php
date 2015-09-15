<?php

	/*
	*
	*	Swift Page Builder - Row Shortcode Class
	*	------------------------------------------------
	*	Swift Framework
	* 	Copyright Swift Ideas 2014 - http://www.swiftideas.net
	*
	*/
	
	class SwiftPageBuilderShortcode_spb_row extends SwiftPageBuilderShortcode {
	
	    public function content( $atts, $content = null ) {
	
	        $row_el_class = $width = $row_bg_color = $row_padding_vertical = $row_margin_vertical = $remove_element_spacing = $el_position = '';
	
	        extract(shortcode_atts(array(
	        	'wrap_type' => '',
	        	'row_bg_color' => '',
	        	'row_id' => '',
	        	'row_name' => '',
	        	'row_padding_vertical' => '',
	        	'row_margin_vertical' => '30',
	        	'row_overlay_opacity' => '0',
	        	'remove_element_spacing' => '',
	        	'parallax_type' => '',
	        	'bg_image' => '',
	        	'bg_video_mp4' => '',
	        	'bg_video_webm' => '',
	        	'bg_video_ogg' => '',
	        	'parallax_video_height' => 'video-height',
	        	'parallax_image_height' => 'content-height',
	        	'parallax_video_overlay' => 'none',
	        	'parallax_image_movement' => 'fixed',
	        	'parallax_image_speed' => '0.5',
	        	'bg_type' => '',
	            'row_el_class' => '',
	            'el_position' => '',
	            'width' => '1/1'
	        ), $atts));
	
	        $output = $inline_style = $rowId = '';
	        
	        if ($row_id != "") {
	        $rowId = 'id="'.$row_id.'" data-rowname="'.$row_name.'"';
	        }
	
	        $row_el_class = $this->getExtraClass($row_el_class);
	        $orig_width = $width;
	        $width = spb_translateColumnWidthToSpan($width);
			$img_url = wp_get_attachment_image_src($bg_image, 'full');
	        
	        if ($remove_element_spacing == "yes") {
	        	$row_el_class .= ' remove-element-spacing';
	        }
	        
	        if ($row_bg_color != "") {
	        	$inline_style .= 'background-color:'.$row_bg_color.';';
	        }
	        if ($row_padding_vertical != "") {
	        	$inline_style .= 'padding-top:'.$row_padding_vertical.'px;padding-bottom:'.$row_padding_vertical.'px;';
	        }
	        if ($row_margin_vertical != "") {
	        	$inline_style .= 'margin-top:'.$row_margin_vertical.'px;margin-bottom:'.$row_margin_vertical.'px;';
	        }
	        
	        if ($parallax_type != "color") {
	        	$inline_style .= 'background-image: url('.$img_url[0].');';
	        }
	        
			
			if ($parallax_type == "video") {
				if ($img_url[0] != "") {
					$output .= "\n\t".'<div class="spb-row-container spb-row-'.$wrap_type.' spb_parallax_asset sf-parallax sf-parallax-video parallax-'.$parallax_video_height.' spb_content_element bg-type-'.$bg_type.' '.$width.$row_el_class.'" style="'.$inline_style.'" '.$rowId.'>';			
				} else {
					$output .= "\n\t".'<div class="spb-row-container spb-row-'.$wrap_type.' spb_parallax_asset sf-parallax sf-parallax-video parallax-'.$parallax_video_height.' spb_content_element bg-type-'.$bg_type.' '.$width.$row_el_class.'" style="'.$inline_style.'" '.$rowId.'>';	
				}
			} else if ($parallax_type == "image") {
				if ($img_url[0] != "") {
					if ($parallax_image_movement == "stellar") {
						$output .= "\n\t".'<div class="spb-row-container spb-row-'.$wrap_type.' spb_parallax_asset sf-parallax parallax-'.$parallax_image_height.' parallax-'.$parallax_image_movement.' spb_content_element bg-type-'.$bg_type.' '.$width.$row_el_class.'" data-parallax-speed="'.$parallax_image_speed.'" style="'.$inline_style.'" '.$rowId.'>';
					} else {
						$output .= "\n\t".'<div class="spb-row-container spb-row-'.$wrap_type.' spb_parallax_asset sf-parallax parallax-'.$parallax_image_height.' parallax-'.$parallax_image_movement.' spb_content_element bg-type-'.$bg_type.' '.$width.$row_el_class.'" style="'.$inline_style.'" '.$rowId.'>';
					}
				} else {
					$output .= "\n\t".'<div class="spb-row-container spb-row-'.$wrap_type.' spb_parallax_asset sf-parallax parallax-'.$parallax_image_height.' spb_content_element bg-type-'.$bg_type.' '.$width.$row_el_class.'" style="'.$inline_style.'" '.$rowId.'>';
				}	
			} else {
				$output .= "\n\t".'<div class="spb-row-container spb-row-'.$wrap_type.'" style="'.$inline_style.'" '.$rowId.'>'; 
			}
			
			if ($wrap_type == "content-width") {
			//$output .= "\n\t\t".'<div class="container">';
			}
	        $output .= "\n\t\t".'<div class="spb_content_element '.$width.$row_el_class.'">';
	        $output .= "\n\t\t\t".'<div class="spb_wrapper">';
	        $output .= "\n\t\t\t\t". spb_format_content($content);
	        $output .= "\n\t\t\t".'</div> '.$this->endBlockComment('.spb_wrapper');
	        
	        if ($parallax_type == "video") {
	            $output .= '<video class="parallax-video" poster="'.$img_url[0].'" preload="auto" autoplay loop="loop" muted="muted">';
	            if ($bg_video_mp4 != "") {
	            $output .= '<source src="'.$bg_video_mp4.'" type="video/mp4">';
	            }
	            if ($bg_video_webm != "") {
	            $output .= '<source src="'.$bg_video_webm.'" type="video/webm">';
	            }
	            if ($bg_video_ogg != "") {
	            $output .= '<source src="'.$bg_video_ogg.'" type="video/ogg">';
	        	}
	            $output .= '</video>';
	            $output .= '<div class="video-overlay overlay-'.$parallax_video_overlay.'"></div>';
	        }
	        
	        $output .= "\n\t\t".'</div> '.$this->endBlockComment($width);
	        
	        if ($row_overlay_opacity != "0") {
	        	$opacity = intval($row_overlay_opacity, 10) / 100;
	        	$output .= '<div class="row-overlay" style="background-color:'.$row_bg_color.';opacity:'.$opacity.';"></div>';
	        }
	        
	        
	        if ($wrap_type == "content-width") {
	        //$output .= "\n\t\t".'</div>';
	        }
			$output .= "\n\t".'</div>';
				        			
	        $output = $this->startRow($el_position, '', true) . $output . $this->endRow($el_position, '', true);
	        
	        if ($parallax_type == "image" || $parallax_type == "video") {
	        	global $sf_include_parallax;
	        	$sf_include_parallax = true;
	        }
	        
	        return $output;
	    }
	
	    public function contentAdmin($atts, $content = null) {
	        $width = $row_el_class = $bg_color = $padding_vertical = '';
	        extract(shortcode_atts(array(
	        	'wrap_type' => '',
	        	'row_el_class' => '',
	        	'row_bg_color' => '',
	        	'row_padding_vertical' => '',
	        	'row_margin_vertical' => '',
	        	'row_overlay_opacity' => '0',
	        	'remove_element_spacing' => '',
	        	'row_id' => '',
	        	'row_name' => '',
	        	'parallax_type' => '',
	        	'bg_image' => '',
	        	'bg_video_mp4' => '',
	        	'bg_video_webm' => '',
	        	'bg_video_ogg' => '',
	        	'parallax_video_height' => 'video-height',
	        	'parallax_image_height' => 'content-height',
	        	'parallax_video_overlay' => 'none',
	        	'parallax_image_movement' => 'fixed',
	        	'parallax_image_speed' => '0.5',
	        	'bg_type' => '',
	            'width' => 'span12'
	        ), $atts));
	        
	        $output = '';

            $output .= '<div data-element_type="spb_row" class="spb_row spb_sortable span12 spb_droppable not-column-inherit">';
            $output .= '<input type="hidden" class="spb_sc_base" name="element_name-spb_row" value="spb_row">';
            $output .= '<div class="controls sidebar-name"><div class="controls_right"><a class="column_edit" href="#" title="Edit"></a> <a class="column_clone" href="#" title="Clone"></a> <a class="column_delete" href="#" title="Delete"></a></div></div>';
            $output .= '<div class="spb_element_wrapper">';
            $output .= '<div class="row-fluid spb_column_container spb_sortable_container not-column-inherit">';
            $output .= do_shortcode( shortcode_unautop($content) );
            $output .= SwiftPageBuilder::getInstance()->getLayout()->getContainerHelper();
            $output .= '</div>';
            if ( isset($this->settings['params']) ) {
                $inner = '';
                foreach ($this->settings['params'] as $param) {
                    $param_value = isset($$param['param_name']) ? $$param['param_name'] : '';
                    //var_dump($param_value);
                    if ( is_array($param_value)) {
                        // Get first element from the array
                        reset($param_value);
                        $first_key = key($param_value);
                        $param_value = $param_value[$first_key];
                    }
                    $inner .= $this->singleParamHtmlHolder($param, $param_value);
                }
                $output .= $inner;
            }
            $output .= '</div>';
            $output .= '</div>';
	
	        return $output;
	    }
	}
	
	SPBMap::map( 'spb_row', array(
	    "name"		=> __("Row", "swift-framework-admin"),
	    "base"		=> "spb_row",
	    "controls"	=> "edit_delete",
	    "content_element" => false,
	    "params"	=> array(
	    	array(
	    	    "type" => "dropdown",
	    	    "heading" => __("Wrap type", "swift-framework-admin"),
	    	    "param_name" => "wrap_type",
	    	    "value" => array(__('Standard Width Content', "swift-framework-admin") => "content-width", __('Full Width Content', "swift-framework-admin") => "full-width"),
	    	    "description" => __("Select if you want to row to wrap the content to the grid, or if you want the content to be edge to edge.", "swift-framework-admin")
	    	),
	    	array(
	    	    "type" => "colorpicker",
	    	    "heading" => __("Background color", "swift-framework-admin"),
	    	    "param_name" => "row_bg_color",
	    	    "value" => "",
	    	    "description" => __("Select a background colour for the row here.", "swift-framework-admin")
	    	),
	    	array(
	    	    "type" => "dropdown",
	    	    "heading" => __("Row Type", "swift-framework-admin"),
	    	    "param_name" => "parallax_type",
	    	    "value" => array(
	    	    			__("Color", "swift-framework-admin") => "color",
	    	    			__("Image", "swift-framework-admin") => "image",
	    	    			__("Video", "swift-framework-admin") => "video"
	    	    			),
	    	    "description" => __("Choose whether you want to use an image or video for the background of the parallax. This will decide what is used from the options below.", "swift-framework-admin")
	    	),
	    	array(
	    		"type" => "attach_image",
	    		"heading" => __("Background Image", "swift-framework-admin"),
	    		"param_name" => "bg_image",
	    		"value" => "",
	    		"description" => "Choose an image to use as the background for the parallax area."
	    	),
	    	array(
	    	    "type" => "dropdown",
	    	    "heading" => __("Background Type", "swift-framework-admin"),
	    	    "param_name" => "bg_type",
	    	    "value" => array(
	    	    			__("Cover", "swift-framework-admin") => "cover",
	    	    			__("Pattern", "swift-framework-admin") => "pattern"
	    	    			),
	    	    "description" => __("If you're uploading an image that you want to spread across the whole asset, then choose cover. Else choose pattern for an image you want to repeat.", "swift-framework-admin")
	    	),
	    	array(
	    		"type" => "textfield",
	    		"heading" => __("Background Video (MP4)", "swift-framework-admin"),
	    		"param_name" => "bg_video_mp4",
	    		"value" => "",
	    		"description" => "Provide a video URL in MP4 format to use as the background for the parallax area. You can upload these videos through the WordPress media manager."
	    	),
	    	array(
	    		"type" => "textfield",
	    		"heading" => __("Background Video (WebM)", "swift-framework-admin"),
	    		"param_name" => "bg_video_webm",
	    		"value" => "",
	    		"description" => "Provide a video URL in WebM format to use as the background for the parallax area. You can upload these videos through the WordPress media manager."
	    	),
	    	array(
	    		"type" => "textfield",
	    		"heading" => __("Background Video (Ogg)", "swift-framework-admin"),
	    		"param_name" => "bg_video_ogg",
	    		"value" => "",
	    		"description" => "Provide a video URL in OGG format to use as the background for the parallax area. You can upload these videos through the WordPress media manager."
	    	),
	    	array(
	    	    "type" => "dropdown",
	    	    "heading" => __("Parallax Video Height", "swift-framework-admin"),
	    	    "param_name" => "parallax_video_height",
	    	    "value" => array(
	    	    			__("Video Height", "swift-framework-admin") => "video-height",
	    	    			__("Content Height", "swift-framework-admin") => "content-height"
	    	    			),
	    	    "description" => __("If you are using this as a video parallax asset, then please choose whether you'd like asset to sized based on the content height or the video height.", "swift-framework-admin")
	    	),
	    	array(
	    	    "type" => "dropdown",
	    	    "heading" => __("Parallax Video Overlay", "swift-framework-admin"),
	    	    "param_name" => "parallax_video_overlay",
	    	    "value" => array(
	    	    			__("None", "swift-framework-admin") => "none",
	    	    			__("Striped", "swift-framework-admin") => "striped"
	    	    			),
	    	    "description" => __("If you would like an overlay to appear on top of the video, then you can select it here.", "swift-framework-admin")
	    	),
	    	array(
	    	    "type" => "dropdown",
	    	    "heading" => __("Parallax Image Height", "swift-framework-admin"),
	    	    "param_name" => "parallax_image_height",
	    	    "value" => array(
	    	    			__("Content Height", "swift-framework-admin") => "content-height",
	    	    			__("Window Height", "swift-framework-admin") => "window-height"
	    	    			),
	    	    "description" => __("If you are using this as an image parallax asset, then please choose whether you'd like asset to sized based on the content height or the height of the viewport window.", "swift-framework-admin")
	    	),
	    	array(
	    	    "type" => "dropdown",
	    	    "heading" => __("Background Image Movement", "swift-framework-admin"),
	    	    "param_name" => "parallax_image_movement",
	    	    "value" => array(
	    	    			__("Fixed", "swift-framework-admin") => "fixed",
	    	    			__("Scroll", "swift-framework-admin") => "scroll",
	    	    			__("Stellar (dynamic)", "swift-framework-admin") => "stellar",
	    	    			),
	    	    "description" => __("Choose the type of movement you would like the parallax image to have. Fixed means the background image is fixed on the page, Scroll means the image will scroll will the page, and stellar makes the image move at a seperate speed to the page, providing a layered effect.", "swift-framework-admin")
	    	),
	    	array(
	    		"type" => "textfield",
	    		"heading" => __("Parallax Image Speed (Stellar Only)", "swift-framework-admin"),
	    		"param_name" => "parallax_image_speed",
	    		"value" => "0.5",
	    		"description" => "The speed at which the parallax image moves in relation to the page scrolling. For example, 0.5 would mean the image scrolls at half the speed of the standard page scroll. (Default 0.5)."
	    	),
	    	array(
	    	    "type" => "uislider",
	    	    "heading" => __("Overlay Opacity", "swift-framework-admin"),
	    	    "param_name" => "row_overlay_opacity",
	    	    "value" => "0",
	    	    "step" => "5",
	    	    "min" => "0",
	    	    "max" => "100",
	    	    "description" => __("Adjust the overlay capacity if using an image or video option. This uses the color option, and shows an overlay over the image/video at the desired opacity. Percentage.", "swift-framework-admin")
	    	),
	    	array(
	    	    "type" => "uislider",
	    	    "heading" => __("Padding - Vertical", "swift-framework-admin"),
	    	    "param_name" => "row_padding_vertical",
	    	    "value" => "30",
	    	    "description" => __("Adjust the vertical padding for the row.", "swift-framework-admin")
	    	),
	    	array(
	    	    "type" => "uislider",
	    	    "heading" => __("Margin - Vertical", "swift-framework-admin"),
	    	    "param_name" => "row_margin_vertical",
	    	    "value" => "30",
	    	    "description" => __("Adjust the margin above and below the row.", "swift-framework-admin")
	    	),
	    	array(
	    	    "type" => "dropdown",
	    	    "heading" => __("Remove Element Spacing", "swift-framework-admin"),
	    	    "param_name" => "remove_element_spacing",
	    	    "value" => array(
	    	    	__('No', "swift-framework-admin") => "no",
	    	    	__('Yes', "swift-framework-admin") => "yes"),
	    	    "description" => __("Enable this option if you wish to remove all spacing from the elements within the row.", "swift-framework-admin")
	    	),
	        array(
	            "type" => "textfield",
	            "heading" => __("Extra class name", "swift-framework-admin"),
	            "param_name" => "row_el_class",
	            "value" => "",
	            "description" => __("If you wish to style particular content element differently, then use this field to add a class name and then refer to it in your css file.", "swift-framework-admin")
	        )
	    )
	) );

?>