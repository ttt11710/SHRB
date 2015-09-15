<?php
    //创建团购通知表
    function pb_group_createTable()
    {
        global $wpdb;
        $charset_collate = 'ENGINE=InnoDB';
        if(version_compare(mysql_get_server_info(), '4.1.0', '>=')) {
            if(!empty($wpdb->charset))
            { $charset_collate .= " DEFAULT CHARACTER SET $wpdb->charset"; }
            if(!empty($wpdb->collate))
            { $charset_collate .= " COLLATE $wpdb->collate"; }
        }
        $table_name='pb_group_message';
        //$wpdb->query("DROP TABLE IF EXISTS {$table_name}");
        if($wpdb->get_var("SHOW TABLES LIKE '{$table_name}'") != $table_name){
            $wpdb->query("
                    CREATE TABLE {$table_name}
                    (
                        message_id int(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                        uid int(11) NOT NULL,
                        phone varchar(11) NOT NULL,
                        group_id int(11) UNSIGNED NOT NULL,
                        create_time datetime DEFAULT '0000-00-00 00:00:00',
                        plan_send_time datetime DEFAULT '0000-00-00 00:00:00',
                        send_time datetime DEFAULT '0000-00-00 00:00:00',
                        status TINYINT(3) UNSIGNED DEFAULT 0,
                        INDEX (message_id,status)
                    ) $charset_collate");
        }
    }
    //创建团购通知表
    function pb_add_group_init()
    {
        pb_group_createTable();
    }
?>