<?php
// if php version < 5.4.0
if (! function_exists ( 'hex2bin' )) {
	function hex2bin($hex) {
		$n = strlen ( $hex );
		$bin = "";
		$i = 0;
		while ( $i < $n ) {
			$a = substr ( $hex, $i, 2 );
			$c = pack ( "H*", $a );
			if ($i == 0) {
				$bin = $c;
			} else {
				$bin .= $c;
			}
			$i += 2;
		}
		return $bin;
	}
}

/**
 * 还原公钥
 *
 * @param string $mod        	
 * @param string $exp        	
 * @return string 字符串形式的公钥文件
 */
function public2file($mod, $exp = '010001') {
	return "-----BEGIN PUBLIC KEY-----\r\n" . wordwrap ( base64_encode ( hex2bin ( "30819f300d06092a864886f70d010101050003818d0030818902818100{$mod}0203{$exp}" ) ), 64, "\r\n", true ) . "\r\n-----END PUBLIC KEY-----\r\n";
}

/**
 * 从私钥中提取公钥指数和模数
 *
 * @param [type] $file
 *        	[description]
 * @return [type] [description]
 */
function getPrivate($file = 'private.pem') {
	$p = openssl_pkey_get_private ( file_get_contents ( $file ) );
	$res = openssl_pkey_get_details ( $p );
	// var_dump($res);
	openssl_free_key ( $p );
	return array (
			'n' => bin2hex ( $res ['rsa'] ['n'] ), // 数
			'e' => bin2hex ( $res ['rsa'] ['e'] ), // 钥指数
			'd' => bin2hex ( $res ['rsa'] ['d'] )  // 钥指数
		);
}

/**
 * 全民捷付sdk for php
 *
 * @author eslizn <eslizn@live.cn>
 * @copyright Copyright (c) 2013 Ludo team (http://www.loongjoy.com)
 * @version $Id$
 */
class umspay {
	
	/**
	 * 下单接口
	 */
	const ORDER_CREATE_URL = 'https://116.228.21.162:8603/merFrontMgr/orderBusinessServlet'; // 测试地址

	// const ORDER_CREATE_URL = 'https://mpos.quanminfu.com:6004/merFrontMgr/orderBusinessServlet'; // 正式
	/**
	 * 订单查询接口
	 */
	const ORDER_QUERY_URL = 'https://116.228.21.162:8603/merFrontMgr/orderQuerySerlet'; // 测试地址
	
	/**
	 * 下单回调接口
	 */
	const ORDER_CALLBACK_URL = 'http://172.16.26.234/defualttest/notify.php'; // 银商通知回调地址，保证外网可以访问
	
	/*异步通知接口*/
	// var $notify_url;
	/**
	 * 商户号
	 *
	 * @var string
	 */
	var $merchantId;
	
	/**
	 * 终端号
	 *
	 * @var string
	 */
	var $termId;
	
	/**
	 * [__construct description]
	 *
	 * @param string $merchantId
	 *        	商户号
	 * @param string $termId
	 *        	终端号
	 */
	function __construct($merchantId, $termId) {
		$this->merchantId = $merchantId;
		$this->termId = $termId;
	}
	
	/**
	 * 签名数据
	 *
	 * @param string $data
	 *        	要签名的数据
	 * @param string $private
	 *        	私钥文件
	 * @return string 签名的16进制数据
	 */
	function sign($data, $private = 'key/rsa_private_key.pem') {
		$p = openssl_pkey_get_private ( file_get_contents ( $private ) );
		openssl_sign ( $data, $signature, $p );
		openssl_free_key ( $p );
		return bin2hex ( $signature );
	}
	
	/**
	 * 验签
	 *
	 * @param string $data        	
	 * @param string $sign        	
	 * @param string $public
	 *        	公钥文件//验签公钥文件应为全民捷付提供的公钥文件
	 * @return bool 验签状态
	 */
	function verify($data, $sign, $public = 'key/rsa_public_key.pem') {
		// echo file_get_contents ( $public );
		$p = openssl_pkey_get_public ( file_get_contents ( $public ) );
		$verify = openssl_verify ( $data, hex2bin ( $sign ), $p );
		openssl_free_key ( $p );
		return $verify > 0;
	}
	
	/**
	 * 以post方式发送请求请求
	 *
	 * @param array $data
	 *        	请求参数
	 * @param string $url
	 *        	请求地址
	 * @return array 请求结果
	 */
	function post($data, $url) {
		$ch = curl_init ();
		curl_setopt ( $ch, CURLOPT_URL, $url );
		// 忽略证书错误信息
		// curl_setopt($ch, CURLOPT_SSLVERSION, 1); //设定SSL版本
		// curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt ( $ch, CURLOPT_SSLVERSION, 4 ); // 设定SSL版本
		curl_setopt ( $ch, CURLOPT_SSL_VERIFYPEER, false );
		// 数据载体格式
		curl_setopt ( $ch, CURLOPT_POSTFIELDS, http_build_query ( array (
				'jsonString' => json_encode ( $data ) 
		) ) );
		curl_setopt ( $ch, CURLOPT_RETURNTRANSFER, true );
		$result = json_decode ( curl_exec ( $ch ), true );
		echo(curl_error($ch));//查看请求错误信息
		curl_close ( $ch );
		return $result;
	}
	
	/**
	 * 下单
	 *
	 * @param string $title
	 *        	订单标题
	 * @param number $amt
	 *        	订单金额,单位分
	 * @param string $orderId
	 *        	订单id,由商户产生
	 * @param string $type
	 *        	交易类型
	 * @param integer $exp
	 *        	过期时间
	 * @return mixed
	 */
	function order($title, $amt, $orderId, $exp,$notify_url, $type = 'NoticePay') {
		$time = time ();
		$data = array (
				'TransCode' => '201201', // 订单码 const value
				'OrderTime' => date ( 'His', $time ), // 订单时间，date hhmmss
				'EffectiveTime' => strval ( $exp ? $exp - $time : 0 ), // 有效期，为0则长期有效
				'OrderDate' => date ( 'Ymd', $time ), // 订单日期，yyyymmdd
				'MerOrderId' => $orderId, // 商户订单号
				'TransType' => $type, // 支付类型，固定为NoticePay
				'TransAmt' => strval ( $amt ), // 订单金额，单位为分，不可为非整数。
				'MerId' => $this->merchantId, // 商户编号
				'MerTermId' => $this->termId, // 商户终端号
				'NotifyUrl' => $notify_url, // 支付成功后，银商后台通知回调地址，保证外网可以访问。
				'Reserve' => '', // 银商备用字段，不用理会。
				'OrderDesc' => $title, // 订单描述
				'MerSign' => '' 
		);
		// print_r(json_encode($data));
		// die;
		// 签名
		$data ['MerSign'] .= $data ['OrderTime'];
		$data ['MerSign'] .= $data ['EffectiveTime'];
		$data ['MerSign'] .= $data ['OrderDate'];
		$data ['MerSign'] .= $data ['MerOrderId'];
		$data ['MerSign'] .= $data ['TransType'];
		$data ['MerSign'] .= $data ['TransAmt'];
		$data ['MerSign'] .= $data ['MerId'];
		$data ['MerSign'] .= $data ['MerTermId'];
		$data ['MerSign'] .= $data ['NotifyUrl'];
		$data ['MerSign'] .= $data ['OrderDesc'];
		$data ['MerSign'] = $this->sign($data['MerSign']);
		// 发送请求
		$result = $this->post ( $data, self::ORDER_CREATE_URL );
		// print_r(json_encode($result));
		// die;
		// var_dump($result);
		// var_dump($data);
		// 验签
		$verify = '';
		$verify .= $result ['MerOrderId'];
		$verify .= $result ['ChrCode'];
		$verify .= $result ['TransId'];
		$verify .= $result ['Reserve'];
		$verify .= $result ['RespCode'];
		$verify .= $result ['RespMsg'];

		if (! isset ( $result ['Signature'] ) || ! $this->verify ( $verify, $result ['Signature'] )) {
			// 验签失败
			return false; // '下单返回验签失败';
		}
		
		if (! isset ( $result ['RespCode'] ) || intval ( $result ['RespCode'] )) {
			// 下单失败 详细信息参考$result['RespMsg']
			return false; // '下单失败';
		}
		// 业务逻辑处理
		// var_dump($result);
		
		// 组装客户端需要的参数返回给客户端 TransId|ChrCode|签名|商户号
		// $retStr ='';
		// $retStr .= $result['TransId'];
		// $retStr .= '|';
		// $retStr .= $result['ChrCode'];
		// $retStr .= '|';
		// $retStr .= $this->sign($result['TransId']。$result['ChrCode']);
		// $retStr .= '|';
		// $retStr .= $this->merchantId;
		// web支付参数组装
		
		$retStr .= 'tranId=' . $result ['TransId'];
		$retStr .= '&';
		$retStr .= 'ChrCode=' . $result ['ChrCode'];
		$retStr .= '&';
		$retStr .= 'MerSign=' . $this->sign ( $result ['TransId'] . $result ['ChrCode'] );
		$retStr .= '&';
		$retStr .= 'url=http://monet.paybay.cn/myaccount/'; // 支付成功后，用户点击返回商户页面时返回的就是该地址。请填写完整地址。
// 		$retStr = array(
// 				'tranId'  => $result ['TransId'],
// 				'ChrCode' => $result ['ChrCode'],
// 				'MerSign' => $this->sign ( $result ['TransId'] . $result ['ChrCode'] ),
// 				'url'     =>'http://www.baidu.com'
// 		);
		return $retStr;
	}
	/**
	 * 订单查询
	 *
	 * @param string $title
	 *        	订单标题
	 * @param number $amt
	 *        	订单金额,单位分
	 * @param string $orderId
	 *        	订单id,由商户产生
	 * @param string $type
	 *        	交易类型
	 * @param integer $exp
	 *        	过期时间
	 * @return mixed 订单状态0:新订单, 1成功， 2失败，3支付中
	 *        
	 */
	function seek($transId, $merOrderId) {
		$time = time ();
		$data = array (
				'TransCode' => '201203', // 交易代码
				'ReqTime' => date ( 'YmdHis', $time ), // 请求时间
				'OrderDate' => date ( 'Ymd', $time ), // 订单日期
				'MerOrderId' => $merOrderId, // 商户订单号
				'TransId' => $transId, // 交易流水
				'MerId' => $this->merchantId, // 商户号
				'MerTermId' => $this->termId, // 终端号
				'Reserve' => '',
				'MerSign' => '' 
		);
		
		// 签名
		$data ['MerSign'] .= $data ['ReqTime'];
		$data ['MerSign'] .= $data ['OrderDate'];
		$data ['MerSign'] .= $data ['MerOrderId'];
		$data ['MerSign'] .= $data ['TransId'];
		$data ['MerSign'] .= $data ['MerId'];
		$data ['MerSign'] .= $data ['MerTermId'];
		$data ['MerSign'] .= $data ['Reserve'];
		$data ['MerSign'] = $this->sign ( $data ['MerSign'] );
		
		// 发送请求
		$result = $this->post ( $data, self::ORDER_QUERY_URL );
		var_dump ( $result );
		
		// 验签
		$verify = '';
		$verify .= $result ['OrderTime'];
		$verify .= $result ['OrderDate'];
		$verify .= $result ['MerOrderId'];
		$verify .= $result ['TransType'];
		
		$verify .= $result ['TransAmt'];
		$verify .= $result ['MerId'];
		$verify .= $result ['MerTermId'];
		$verify .= $result ['TransId'];
		$verify .= $result ['TransState'];
		
		$verify .= $result ['RefId'];
		$verify .= $result ['Reserve'];
		$verify .= $result ['RespCode'];
		$verify .= $result ['RespMsg'];
		
		if (! isset ( $result ['Signature'] ) || ! $this->verify ( $verify, $result ['Signature'] )) {
			// 验签失败
			return false; // '订单查询返回验签失败';
		}
		
		if (! isset ( $result ['RespCode'] ) || intval ( $result ['RespCode'] )) {
			// 订单查询失败 详细信息参考$result['RespMsg']
			return false; // '订单查询失败';
		}
		
		// 商户后台业务逻辑处理
		
		return true;
	}
	
	/**
	 * 响应回调
	 */
	function notify() {
		$data = &$_POST;
		// 验签
		$verify = '';
		$verify .= isset ( $data ['OrderTime'] ) ? $data ['OrderTime'] : '';
		$verify .= isset ( $data ['OrderDate'] ) ? $data ['OrderDate'] : '';
		$verify .= isset ( $data ['MerOrderId'] ) ? $data ['MerOrderId'] : '';
		$verify .= isset ( $data ['TransType'] ) ? $data ['TransType'] : '';
		$verify .= isset ( $data ['TransAmt'] ) ? $data ['TransAmt'] : '';
		$verify .= isset ( $data ['MerId'] ) ? $data ['MerId'] : '';
		$verify .= isset ( $data ['MerTermId'] ) ? $data ['MerTermId'] : '';
		$verify .= isset ( $data ['TransId'] ) ? $data ['TransId'] : '';
		$verify .= isset ( $data ['TransState'] ) ? $data ['TransState'] : '';
		$verify .= isset ( $data ['RefId'] ) ? $data ['RefId'] : '';
		$verify .= isset ( $data ['Account'] ) ? $data ['Account'] : '';
		$verify .= isset ( $data ['TransDesc'] ) ? $data ['TransDesc'] : '';
		$verify .= isset ( $data ['Reserve'] ) ? $data ['Reserve'] : '';
		
		if (! $this->verify ( $verify, $data ['Signature'] )) {
			// 验签失败!
			return false; // '查询返回报文验签失败';
		}
		
		// 根据MerOrderId得到本地订单
		
		// 商户后台做一些业务处理
		
		// 响应数据
		$result = array (
				'TransCode' => '201202',
				'MerOrderId' => $data ['MerOrderId'],
				'TransType' => 'NoticePay',
				'MerId' => $data ['MerId'],
				'MerTermId' => $data ['MerTermId'],
				'TransId' => $data ['TransId'],
				'MerPlatTime' => date ( 'YmdHis' ),
				'MerOrderState' => '11',
				'Reserve' => '',
				'MerSign' => '' 
		);
		
		$result ['MerOrderState'] = '00';
		
		// 签名
		$result ['MerSign'] .= isset ( $result ['MerOrderId'] ) ? $result ['MerOrderId'] : '';
		$result ['MerSign'] .= isset ( $result ['TransType'] ) ? $result ['TransType'] : '';
		$result ['MerSign'] .= isset ( $result ['MerId'] ) ? $result ['MerId'] : '';
		$result ['MerSign'] .= isset ( $result ['MerTermId'] ) ? $result ['MerTermId'] : '';
		$result ['MerSign'] .= isset ( $result ['TransId'] ) ? $result ['TransId'] : '';
		$result ['MerSign'] .= isset ( $result ['MerPlatTime'] ) ? $result ['MerPlatTime'] : '';
		$result ['MerSign'] .= isset ( $result ['MerOrderState'] ) ? $result ['MerOrderState'] : '';
		$result ['MerSign'] .= isset ( $result ['Reserve'] ) ? $result ['Reserve'] : '';
		
		$result ['MerSign'] = $this->sign ( $result ['MerSign'] );
		
		// 响应回调
		exit ( json_encode ( $result ) );
	}
}
?>