/**
 * jQuery Cookie plugin
 *
 * Copyright (c) 2010 Klaus Hartl (stilbuero.de)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 */
(function () {
    "use strict";

    // IE checker
    function gkIsIE() {
        var myNav = navigator.userAgent.toLowerCase();
        return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
    }

    jQuery.cookie = function (key, value, options) {

        // key and at least value given, set cookie...
        if (arguments.length > 1 && String(value) !== "[object Object]") {
            options = jQuery.extend({}, options);

            if (value === null || value === undefined) {
                options.expires = -1;
            }

            if (typeof options.expires === 'number') {
                var days = options.expires,
                    t = options.expires = new Date();
                t.setDate(t.getDate() + days);
            }

            value = String(value);

            return (document.cookie = [
                encodeURIComponent(key), '=',
                options.raw ? value : encodeURIComponent(value),
                options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                options.path ? '; path=' + options.path : '',
                options.domain ? '; domain=' + options.domain : '',
                options.secure ? '; secure' : ''
            ].join(''));
        }

        // key and possibly options given, get cookie...
        options = value || {};
        var result, decode = options.raw ? function (s) {
                return s;
            } : decodeURIComponent;
        return (result = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)').exec(document.cookie)) ? decode(result[1]) : null;
    };

    // Array filter
    if (!Array.prototype.filter) {
        Array.prototype.filter = function (fun /*, thisp */ ) {
            if (this === null) {
                throw new TypeError();
            }

            var t = Object(this);
            var len = t.length >>> 0;
            if (typeof fun !== "function") {
                throw new TypeError();
            }

            var res = [];
            var thisp = arguments[1];

            for (var i = 0; i < len; i++) {
                if (i in t) {
                    var val = t[i]; // in case fun mutates this
                    if (fun.call(thisp, val, i, t))
                        res.push(val);
                }
            }

            return res;
        };
    }

    /**
     *
     * Template scripts
     *
     **/
    // onDOMLoadedContent event
    jQuery(document).ready(function () {
    	
        // Thickbox use
        jQuery(document).ready(function () {
            if (typeof tb_init !== "undefined") {
                tb_init('div.wp-caption a'); //pass where to apply thickbox
            }
        });
        	
        // style area
        if (jQuery('#gk-style-area')) {
            jQuery('#gk-style-area div').each(function () {
                jQuery(this).find('a').each(function () {
                    jQuery(this).click(function (e) {
                        e.stopPropagation();
                        e.preventDefault();
                        changeStyle(jQuery(this).attr('href').replace('#', ''));
                    });
                });
            });
        }
        // Function to change styles

        function changeStyle(style) {
            var file = $GK_TMPL_URL + '/css/' + style;
            jQuery('head').append('<link rel="stylesheet" href="' + file + '" type="text/css" />');
            jQuery.cookie($GK_TMPL_NAME + '_style', style, {
                expires: 365,
                path: '/'
            });
        }

        // Responsive tables
        jQuery('article section table').each(function (i, table) {
            table = jQuery(table);
            var heads = table.find('thead th');
            var cells = table.find('tbody td');
            var heads_amount = heads.length;
            // if there are the thead cells
            if (heads_amount) {
                var cells_len = cells.length;
                for (var j = 0; j < cells_len; j++) {
                    var head_content = jQuery(heads.get(j % heads_amount)).text();
                    jQuery(cells.get(j)).html('<span class="gk-table-label">' + head_content + '</span>' + jQuery(cells.get(j)).html());
                }
            }
        });
        
        // Event progress
        var gk_events = jQuery('.gk-event');
        //
        if(gk_events.length) {
        	gk_events.each(function(i, event) {
        		event = jQuery(event);
        		var timezone_value = event.find('.gk-event-time-start').data('timezone') || 0;
        		var date_timezone = -1 * parseInt(timezone_value, 10) * 60;
        		
        		var temp_date = new Date();
        		var user_timezone = temp_date.getTimezoneOffset();
        		var new_timezone_offset = 0;
        		// if the timezones are equal - do nothing, in the other case we need calculations:
        		if(date_timezone !== user_timezone) {
        			new_timezone_offset = user_timezone - date_timezone;
        			// calculate new timezone offset to miliseconds
        			new_timezone_offset = new_timezone_offset * 60 * 1000;
        		}
        		
        		var progress = event.find('.gk-event-counter');
        		var progress_bar = jQuery('<div/>');
        		progress_bar.appendTo(progress);
        		
        		var end = event.find('.gk-event-date-start').attr('datetime').split('-');
        		var end_time = event.find('.gk-event-time-start').attr('datetime').split(':');
        		var end_date = Date.UTC(end[2], end[1]-1, end[0], end_time[0], end_time[1]);
        		end_date = end_date + new_timezone_offset;
        		
        		var start = event.find('.gk-event-counter').attr('datetime').split('-');
        		var start_date = Date.UTC(start[2], start[1]-1, start[0], 0, 0);
        		start_date = start_date + new_timezone_offset;
        		
        		var diff = end_date - start_date;
        		var current = new Date();
        		var current_date = new Date(current.getFullYear(), current.getMonth(), current.getDate(), 0, 0);
        		progress = 1 - Math.round(((end_date - current_date) / diff) * 1000) / 1000;
        		progress = Math.round(progress * 1000) / 1000;
        		setTimeout(function() {
        			progress_bar.css('width', progress * 100 + "%");
        		}, 1000);
        	});
        }
	
		// login popup
        if (jQuery('#gk-popup-login').length > 0 ) {
            // login popup
            var popup_overlay = jQuery('#gk-popup-overlay');
            popup_overlay.css({
                'display': 'none',
                'opacity': 0
            });
            popup_overlay.fadeOut();

            jQuery('#gk-popup-login').css({
                'display': 'none',
                'opacity': 0
            });
            var opened_popup = null;
            var popup_login = null;
            var popup_cart = null;

            if (jQuery('#gk-popup-login').length > 0) {
                popup_login = jQuery('#gk-popup-login');

                jQuery('.gk-login').click(function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    popup_overlay.css('height', jQuery('body').height() + 32);
                    popup_login.css('display', 'block');
                    popup_login.css('opacity', 0);
                    popup_overlay.css('opacity', 0);
                    popup_overlay.css('display', 'block');
                    popup_overlay.animate({
                        'opacity': 0.45
                    });

                    setTimeout(function () {
                        popup_login.animate({
                            'opacity': 1
                        }, 200, 'swing');
                        opened_popup = 'login';
                    }, 300);
                });
            }

            popup_overlay.click(function () {
                if (opened_popup === 'login') {
                    popup_overlay.fadeOut('slow');
                    popup_login.animate({
                        'opacity': 0
                    }, 500, function () {
                        popup_login.css('display', 'none');
                    });
                }

            });

            jQuery('.gk-popup-wrap').each(function (i, wrap) {
                wrap = jQuery(wrap);
                if (wrap.find('.gk-icon-cross')) {
                    wrap.find('.gk-icon-cross').click(function () {
                        popup_overlay.trigger('click');
                    });
                }
            });
        }
                
    });
    
     // GK Image Show
	  jQuery(window).load(function () {
	      setTimeout(function () {
	          jQuery(".gk-is-wrapper-gk-university").each(function (i, wrapper) {
	              wrapper = jQuery(wrapper);
	              var $G = {
	                  'anim_interval': wrapper.attr('data-interval'),
	                  'anim_speed': wrapper.attr('data-speed'),
	                  'autoanim': wrapper.attr('data-autoanim'),
	                  'animation_timer': false,
	                  'text_pos': wrapper.attr('data-textpos'),
	                  'blank': false
	              };
	              var slides = [];
	              var links = [];
	              var imagesToLoad = [];
	              var swipe_min_move = 30;
	              var swipe_max_time = 500;
	              // load the images
	              wrapper.find('figure').each(function (i, el) {
	                  el = jQuery(el);
	                  var newImg = jQuery('<img title="' + el.attr('data-title') + '" class="gk-is-slide" style="z-index: ' + el.attr('data-zindex') + ';" src="' + el.attr('data-url') + '" />');
	                  links[i] = el.attr('data-link');
	                  imagesToLoad.push(newImg);
	                  el.prepend(newImg);
	              });
	              //
	              var time = setInterval(function () {
	                  var process = 0;
	                  jQuery(imagesToLoad).each(function (i, img) {
	                      if (img[0].complete) {
	                          process++;
	                      }
	                  });
	
	                  if (process === imagesToLoad.length) {
	                      clearInterval(time);
	                      
	                      wrapper.find('figure > img').each(function(i, fig) {
	                      	var img = jQuery(fig);
	                      	var new_div = jQuery('<div class="gk-is-slide"' + 'title="' + img.attr('title') + '" style="z-index: ' + img.attr('data-zindex') + ';"></div>');
	                      	new_div.css('background-image',"url('" + img.attr('src') + "')");
	                      	img.before(new_div);
	                      	img.detach();
	
	                      });
	
	                      setTimeout(function () {
	                      	wrapper.find('.gk-is-preloader').css('position','absolute');	
	                         wrapper.find('.gk-is-preloader').fadeOut();
	                      }, 400);
	
	                      $G.actual_slide = 0;
	
	                      wrapper.animate({
	                              'height': wrapper.find('figure').height()
	                          },
	                          350,
	                          function () {
	                              var firstSlide = wrapper.find('figure').first();
	                              firstSlide.addClass('active');
	                              firstSlide.animate({
	                                  'opacity': 1
	                              }, 350);
	                              wrapper.css('height', 'auto');
	                          }
	                      );
	
	                      wrapper.addClass('loaded');
	                      
	                      var progressbar = wrapper.find('.gk-is-progress');
	                      if (progressbar.length) {
	                          progressbar.css('width', '0%');
	                          progressbar.animate({
	                              "width": "100%"
	                          }, $G.anim_interval * 1, 'linear');
	                      }
	
	                      wrapper.find(".gk-is-slide").each(function (i, elmt) {
	                          slides[i] = jQuery(elmt);
	                      });
	
	                      setTimeout(function () {
	                          var initfig = slides[0].parent().find('figcaption');
	                          if (initfig) {
	                              initfig = jQuery(initfig);
	
	                              initfig .attr('class', 'gk-page first');
	                          }
	                      }, 250);
	
	                      if ($G.slide_links) {
	                          wrapper.find('.gk-is-slide').click(function () {
	                              window.location = links[$G.actual_slide];
	                          });
	                          wrapper.find('.gk-is-slide').css('cursor', 'pointer');
	                      }
	
	                      if (wrapper.find('.gk-is-pagination li').length > 0) {
	                          wrapper.find('.gk-is-pagination li').each(function (i, item) {
	                              item = jQuery(item);
	                              item.click(function () {
	                                  if (i !== $G.actual_slide) {
	                                      $G.blank = true;
	                                      gk_university_autoanimate($G, wrapper, 'next', i);
	                                  }
	                              });
	                          });
	                      }
	
	                      // auto-animation
	                      if ($G.autoanim === 'on') {
	                          $G.animation_timer = setTimeout(function () {
	                              gk_university_autoanimate($G, wrapper, 'next', null);
	                          }, $G.anim_interval);
	                      }
	
	                      // pagination
	                      var slide_pos_start_x = 0;
	                      var slide_pos_start_y = 0;
	                      var slide_time_start = 0;
	                      var slide_swipe = false;
	
	                      wrapper.bind('touchstart', function (e) {
	                          slide_swipe = true;
	                          var touches = e.originalEvent.changedTouches || e.originalEvent.touches;
	
	                          if (touches.length > 0) {
	                              slide_pos_start_x = touches[0].pageX;
	                              slide_pos_start_y = touches[0].pageY;
	                              slide_time_start = new Date().getTime();
	                          }
	                      });
	
	                      wrapper.bind('touchmove', function (e) {
	                          var touches = e.originalEvent.changedTouches || e.originalEvent.touches;
	
	                          if (touches.length > 0 && slide_swipe) {
	                              if (
	                                  Math.abs(touches[0].pageX - slide_pos_start_x) > Math.abs(touches[0].pageY - slide_pos_start_y)
	                              ) {
	                                  e.preventDefault();
	                              } else {
	                                  slide_swipe = false;
	                              }
	                          }
	                      });
	
	                      wrapper.bind('touchend', function (e) {
	                          var touches = e.originalEvent.changedTouches || e.originalEvent.touches;
	
	                          if (touches.length > 0 && slide_swipe) {
	                              if (
	                                  Math.abs(touches[0].pageX - slide_pos_start_x) >= swipe_min_move &&
	                                  new Date().getTime() - slide_time_start <= swipe_max_time
	                              ) {
	                                  if (touches[0].pageX - slide_pos_start_x > 0) {
	                                      $G.blank = true;
	                                      gk_university_autoanimate($G, wrapper, 'prev', null);
	                                  } else {
	                                      $G.blank = true;
	                                      gk_university_autoanimate($G, wrapper, 'next', null);
	                                  }
	                              }
	                          }
	                      });
	                  }
	              }, 500);
	          });
	      }, 1000);
	  });
	
	  var gk_university_animate = function ($G, wrapper, imgPrev, imgNext) {
	      var prevfig = imgPrev.find('figcaption');
	      //
	      imgNext.css('class', 'animated');
	      //imgPrev.fade('out');
	      imgPrev.animate({
	              'opacity': 0
	          },
	          $G.anim_speed,
	          function () {
	              imgPrev.css('class', '');
	          }
	      );
	      //imgNext.fade('in');
	      imgNext.animate({
	              'opacity': 1
	          },
	          $G.anim_speed,
	          function () {
	              imgPrev.removeClass('active');
	              imgNext.addClass('active');
	
	              if ($G.autoanim === 'on') {
	                  clearTimeout($G.animation_timer);
	
	                  $G.animation_timer = setTimeout(function () {
	                      if ($G.blank) {
	                          $G.blank = false;
	                          clearTimeout($G.animation_timer);
	
	                          $G.animation_timer = setTimeout(function () {
	                              gk_university_autoanimate($G, wrapper, 'next', null);
	                          }, $G.anim_interval);
	                      } else {
	                          gk_university_autoanimate($G, wrapper, 'next', null);
	                      }
	                  }, $G.anim_interval);
	              }
	          }
	      );
	  };
	
	  var gk_university_autoanimate = function ($G, wrapper, dir, next) {
	      var i = $G.actual_slide;
	      var imgs = wrapper.find('figure');
	
	      if (next === null) {
	          next = (dir === 'next') ? ((i < imgs.length - 1) ? i + 1 : 0) : ((i === 0) ? imgs.length - 1 : i - 1); // dir: next|prev
	      }
	      
	      var progressbar = wrapper.find('.gk-is-progress');
	       if (progressbar.length) {
	          progressbar.css('width', '0%');
	          progressbar.clearQueue().animate({
	              "width": "100%"
	          }, $G.blank ? $G.anim_interval * 2 : $G.anim_interval * 1, 'linear');
	       }
	
	      gk_university_animate($G, wrapper, jQuery(imgs[i]), jQuery(imgs[next]));
	      $G.actual_slide = next;
	
	      jQuery(wrapper.find('.gk-is-pagination li')).removeClass('active');
	      jQuery(wrapper.find('.gk-is-pagination li').get(next)).addClass('active');
	  };
	  
	  jQuery(document).ready(function() {
	  	jQuery(document).find('.widget_gk_buddypress > div').each(function(i, widget) {
	  		widget = jQuery(widget);
	  		
	  		if(!widget.hasClass('active') && widget.hasClass('animate')) {
	  			widget.addClass('active');
	  			gk_buddypress_animate(widget);
	  		}
	  	});
	  });
	  
	  var gk_buddypress_animate = function(widget) {
	  	widget = jQuery(widget);
	  	
	  	var pause = false;
	  	var current = 0;
	  	var content = [];
	  	var items = widget.find('figure');
	  	var count = items.length;
	  	
	  	if(count) {
	  		// prepare the content array
	  		items.each(function(i, item) {
	  			item = jQuery(item);
	  			var img = item.find('img');
	  			var item_content = {
	  				"src": img.attr('src'),
	  				"alt": img.attr('alt'),
	  				"desc": item.find('figcaption').html() 
	  			};
	  			content.push(item_content);
	  			item.mouseenter(function() {
	  				pause = true;
	  			});
	  			item.mouseleave(function() {
	  				pause = false;
	  			});
	  		});
	  		// prepare animation 
	  		var animate = function() {
	  			if(!pause) {
	  				// modify the content array
	  				var first_item = content.pop();
	  				content.unshift(first_item);
	  				
	  				items.each(function(i, item) {	
	  					animate_slide(item, content, i);
	  				});
	  			} else {
	  				pause = false;
	  			}
	  			
	  			setTimeout(function() {
	  				animate();
	  			}, 3000 + (100 * count));
	  		};
	  		// helper function
	  		var animate_slide = function(item, content, i) {
	  			item = jQuery(item);
	  			
	  			setTimeout(function() {
	  				var img = item.find('img');
	  				img.addClass('hide');
	  				setTimeout(function() {
	  					img.attr('src', content[i].src);
	  					img.attr('alt', content[i].alt);
	  					img.removeClass('hide');
	  				}, 500);
	  				item.find('figcaption').html(content[i].desc);
	  			}, 100 * i);
	  		};
	  		// run animation
	  		setTimeout(function() {
	  			animate();
	  		}, 3000);
	  	}
	  };
	  
	  
	jQuery(window).load(function() {
	  // smooth anchor scrolling
	  jQuery('a[href*="#"]').on('click', function (e) {
            e.preventDefault();

            if(this.hash !== '' && this.href.replace(this.hash, '') == window.location.href.replace(window.location.hash, '')) {
                var target = jQuery(this.hash);
                
                if(target.length) {
                    jQuery('html, body').stop().animate({
                        'scrollTop': target.offset().top
                    }, 1000, 'swing', function () {
                        window.location.hash = target.selector;
                    });
                } else {
                    window.location = jQuery(this).attr('href');
                }
            } else {
                window.location = jQuery(this).attr('href');
            }
        });
	});
      
})();
// EOF