<?php

// disable direct access to the file	
defined('GAVERN_WP') or die('Access denied');	

/**
 *
 * GK OAuth class
 *
 * Used to authorize user for Tweets Widget
 *
 **/

class GKOAuth {
  
  var $response = array();

  public function __construct($config=array()) {
    
    $this->params = array();
    $this->headers = array();
  
    $this->buffer = null;
	//
    $this->config = array_merge(
      array(                
      	'timezone'                   => 'UTC',
        'host'                       => 'api.twitter.com',
        'consumer_key'               => '',
        'consumer_secret'            => '',
        'user_token'                 => '',
        'user_secret'                => '',
        'user_agent'			     => 'GK_Tweets_Widget',
        'oauth_version'              => '1.0',
        'oauth_signature_method'     => 'HMAC-SHA1'
      ), $config
    );
    date_default_timezone_set($this->config['timezone']);
  }

  private function safe_encode($data) {
    if (is_array($data)) {
      return array_map(array($this, 'safe_encode'), $data);
    } else if (is_scalar($data)) {
      return str_ireplace(
        array('+', '%7E'),
        array(' ', '~'),
        rawurlencode($data)
      );
    } else {
      return '';
    }
  }
  /*
   * Get default configurations
   */
  private function get_defaults() {
    $defaults = array(
      'oauth_version'          => $this->config['oauth_version'],
      'oauth_nonce'            => $this->config['nonce'],
      'oauth_timestamp'        => $this->config['timestamp'],
      'oauth_consumer_key'     => $this->config['consumer_key'],
      'oauth_signature_method' => $this->config['oauth_signature_method'],
    );

    // include the user token if it exists
    if ( $this->config['user_token'] )
      $defaults['oauth_token'] = $this->config['user_token'];

    // safely encode
    foreach ($defaults as $k => $v) {
      $_defaults[$this->safe_encode($k)] = $this->safe_encode($v);
    }

    return $_defaults;
  }
	
	
  private function prepare_url($url) {
    $parts = parse_url($url);

    $port   = isset($parts['port']) ? $parts['port'] : false;
    $scheme = $parts['scheme'];
    $host   = $parts['host'];
    $path   = isset($parts['path']) ? $parts['path'] : false;

    $port or $port = ($scheme == 'https') ? '443' : '80';

    if (($scheme == 'https' && $port != '443')
        || ($scheme == 'http' && $port != '80')) {
      $host = "$host:$port";
    }
    $this->url = strtolower("$scheme://$host");
    $this->url .= $path;
  }

  private function prepare_params($params) {
    $this->signing_params = array_merge($this->get_defaults(), (array)$params);

    if (isset($this->signing_params['oauth_signature'])) {
      unset($this->signing_params['oauth_signature']);
    }
    uksort($this->signing_params, 'strcmp');
    
    foreach ($this->signing_params as $k => $v) {
      $k = $this->safe_encode($k);

      if (is_array($v))
        $v = implode(',', $v);

      $v = $this->safe_encode($v);
      $_signing_params[$k] = $v;
      $kv[] = "{$k}={$v}";
    }

    // auth params = the default oauth params which are present in our collection of signing params
    // there is no callback necessary when user token is provided
    $this->auth_params = array_intersect_key($this->get_defaults(), $_signing_params);
    if (isset($_signing_params['oauth_callback'])) {
      $this->auth_params['oauth_callback'] = $_signing_params['oauth_callback'];
      unset($_signing_params['oauth_callback']);
    }

    if (isset($_signing_params['oauth_verifier'])) {
      $this->auth_params['oauth_verifier'] = $_signing_params['oauth_verifier'];
      unset($_signing_params['oauth_verifier']);
    }

    $this->request_params = array_diff_key($_signing_params, $this->get_defaults());

    // create the parameter part of the base string
    $this->signing_params = implode('&', $kv);
  }

  /*
   * Prepare the headers
   */
   
  private function prepare_auth_header() {
    unset($this->headers['Authorization']);

    uksort($this->auth_params, 'strcmp');
    if (!$this->config['as_header']) :
      $this->request_params = array_merge($this->request_params, $this->auth_params);
      return;
    endif;

    foreach ($this->auth_params as $k => $v) {
      $kv[] = "{$k}=\"{$v}\"";
    }
    $this->auth_header = 'OAuth ' . implode(', ', $kv);
    $this->headers['Authorization'] = $this->auth_header;
  }

  private function sign($method, $url, $params, $useauth) {
  	$this->method = $method;
    
    $this->prepare_url($url);
    $this->prepare_params($params);

    // not sing when there is no authentication
    if ($useauth) {
      $url = $this->url;
      if (!empty($this->custom_headers['Host'])) {
        $url = str_ireplace(
          $this->config['host'],
          $this->custom_headers['Host'],
          $url
        );
      }
  
      $base = array(
        $this->method,
        $url,
        $this->signing_params
      );
      $this->base_string = implode('&', $this->safe_encode($base));
      $this->signing_key = $this->safe_encode($this->config['consumer_secret']) . '&' . $this->safe_encode($this->config['user_secret']);

      $this->auth_params['oauth_signature'] = $this->safe_encode(
        base64_encode(
          hash_hmac(
            'sha1', $this->base_string, $this->signing_key, true
      )));

      $this->prepare_auth_header();
    }
  }
 
  /* 
   * Prepare for reques
   */
  public function request($method, $url, $params=array(), $useauth=true, $headers=array()) {
    // reset the request headers (we don't want to reuse them)
    $this->headers = array();
    $this->custom_headers = $headers;

    $sequence = array_merge(range(0,9), array('G','K'), range('A','Z'), range('a','z'));
	shuffle($sequence);
	$prefix = microtime();
	$this->config['nonce'] = md5(substr($prefix . implode('', $sequence), 0, $length));
    
    $this->config['timestamp'] = time();

    $this->sign($method, $url, $params, $useauth);

    if (!empty($this->custom_headers))
      $this->headers = array_merge((array)$this->headers, (array)$this->custom_headers);

    return $this->send_wp_request();
  }
  
  /*
   * Send request using HTTP API and check errors
   */
  private function send_wp_request() {
    
    if ( ! empty($this->request_params)) {
      foreach ($this->request_params as $k => $v) {
        $params[] = $k . '=' . $v;
      }
      $qs = implode('&', $params);
      $this->url = strlen($qs) > 0 ? $this->url . '?' . $qs : $this->url;
      $this->request_params = array();
    }
	$this->response = wp_remote_request($this->url, array('headers' => $this->headers));
	$this->response = json_decode($this->response['body'], true);
	
	// set error to null
	$this->response['error'] = '';
	
	// handle the error
	if($this->response['errors'] != '') {
		$this->response['error'] = 'Error '.$this->response['errors'][0]['code'] . ': ' . $this->response['errors'][0]['message'];
	}
	 	
    return $this->response;
  }
}