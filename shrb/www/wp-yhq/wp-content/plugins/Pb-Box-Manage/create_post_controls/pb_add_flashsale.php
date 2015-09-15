<?php
    function pb_add_flashSale_init()
    {
        add_action( 'save_post_pb_flashsale', 'pb_save_post_interval_time' );
    }
    //修改post提交时的参数
    function pb_save_post_interval_time($post_id)
    {
        // print_r($_POST);
        $pb_start_time=strtotime($_POST['pb_start_time']);
        $pb_one_flashSale_end_time=strtotime($_POST['pb_one_flashSale_end_time']);
        $pb_one_flashSale_end_payment_time=strtotime($_POST['pb_one_flashSale_end_payment_time']);
        $pb_end_time=strtotime($_POST['pb_end_time']);
        if(($pb_one_flashSale_end_time-$pb_start_time)<=0)
        {
            $_POST['pb_one_flashSale_end_time']='';
        }
        if(($pb_one_flashSale_end_payment_time-$pb_one_flashSale_end_time)<=0)
        {
            $_POST['pb_one_flashSale_end_payment_time']='';
        }
        if(($pb_end_time-$pb_one_flashSale_end_payment_time)<0)
        {
            $_POST['pb_end_time']='';
        }
        $pb_flashSale_time_duration=($pb_one_flashSale_end_time-$pb_start_time);
        $pb_flashSale_time_payment=($pb_one_flashSale_end_payment_time-$pb_one_flashSale_end_time);
        $one_time=($pb_flashSale_time_duration+$pb_flashSale_time_payment+$_POST['pb_flashSale_time_interval']*60);
        $number=(int)((($pb_end_time-$pb_start_time)+$_POST['pb_flashSale_time_interval']*60)/$one_time);
        $_POST['pb_flashSale_time_duration']=$pb_flashSale_time_duration;
        $_POST['pb_flashSale_time_payment']=$pb_flashSale_time_payment;
        $_POST['pb_flashSale_frequency']=$number;

        
    }
?>