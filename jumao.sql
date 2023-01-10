/*
MySQL Backup
Database: jumao
Backup Time: 2023-01-08 21:58:57
*/

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `jumao`.`yoshop_admin_user`;
DROP TABLE IF EXISTS `jumao`.`yoshop_setting`;
DROP TABLE IF EXISTS `jumao`.`yoshop_store_access`;
DROP TABLE IF EXISTS `jumao`.`yoshop_store_role`;
DROP TABLE IF EXISTS `jumao`.`yoshop_store_role_access`;
DROP TABLE IF EXISTS `jumao`.`yoshop_store_user`;
DROP TABLE IF EXISTS `jumao`.`yoshop_store_user_role`;
DROP TABLE IF EXISTS `jumao`.`yoshop_user`;
DROP TABLE IF EXISTS `jumao`.`yoshop_user_record`;
DROP TABLE IF EXISTS `jumao`.`yoshop_wxapp`;
DROP TABLE IF EXISTS `jumao`.`yoshop_wxapp_category`;
DROP TABLE IF EXISTS `jumao`.`yoshop_wxapp_formid`;
DROP TABLE IF EXISTS `jumao`.`yoshop_wxapp_help`;
DROP TABLE IF EXISTS `jumao`.`yoshop_wxapp_page`;
DROP TABLE IF EXISTS `jumao`.`yoshop_wxapp_prepay_id`;
CREATE TABLE `yoshop_admin_user` (
  `admin_user_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_name` varchar(255) DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) DEFAULT NULL COMMENT '登录密码',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`admin_user_id`),
  KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10002 DEFAULT CHARSET=utf8 COMMENT='超管用户记录表';
CREATE TABLE `yoshop_setting` (
  `key` varchar(30) NOT NULL COMMENT '设置项标示',
  `describe` varchar(255) DEFAULT NULL COMMENT '设置项描述',
  `values` mediumtext NOT NULL COMMENT '设置内容（json格式）',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  UNIQUE KEY `unique_key` (`key`,`wxapp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商城设置记录表';
CREATE TABLE `yoshop_store_access` (
  `access_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) DEFAULT NULL COMMENT '权限名称',
  `url` varchar(255) DEFAULT NULL COMMENT '权限url',
  `parent_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '父级id',
  `sort` tinyint(3) unsigned NOT NULL DEFAULT '100' COMMENT '排序(数字越小越靠前)',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`access_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8 COMMENT='商家用户权限表';
CREATE TABLE `yoshop_store_role` (
  `role_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `role_name` varchar(50) DEFAULT NULL COMMENT '角色名称',
  `parent_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '父级角色id',
  `sort` tinyint(3) unsigned NOT NULL DEFAULT '100' COMMENT '排序(数字越小越靠前)',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商家用户角色表';
CREATE TABLE `yoshop_store_role_access` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `access_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '权限id',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商家用户角色权限关系表';
CREATE TABLE `yoshop_store_user` (
  `store_user_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_name` varchar(255) DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) DEFAULT NULL COMMENT '登录密码',
  `real_name` varchar(255) DEFAULT NULL COMMENT '姓名',
  `is_super` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '是否为超级管理员',
  `is_delete` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`store_user_id`),
  KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8 COMMENT='商家用户记录表';
CREATE TABLE `yoshop_store_user_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `store_user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '超管用户id',
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `admin_user_id` (`store_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商家用户角色记录表';
CREATE TABLE `yoshop_user` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `open_id` varchar(255) NOT NULL DEFAULT '0' COMMENT '微信openid(唯一标示)',
  `nickName` varchar(255) DEFAULT NULL COMMENT '微信昵称',
  `avatarUrl` varchar(255) DEFAULT NULL COMMENT '微信头像',
  `number` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '使用次数',
  `is_userdata` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否已授权',
  `is_delete` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`user_id`),
  KEY `openid` (`open_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8 COMMENT='用户记录表';
CREATE TABLE `yoshop_user_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_info` varchar(255) NOT NULL DEFAULT '0' COMMENT '用户信息',
  `ip` varchar(200) NOT NULL DEFAULT '0' COMMENT '解析ip',
  `url` varchar(255) DEFAULT NULL COMMENT '解析链接',
  `state` int(11) NOT NULL DEFAULT '0' COMMENT '解析状态（0=失败 1=成功）',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `admin_user_id` (`user_info`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户解析记录表';
CREATE TABLE `yoshop_wxapp` (
  `wxapp_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '小程序id',
  `app_id` varchar(50) NOT NULL DEFAULT '0' COMMENT '小程序AppID',
  `app_secret` varchar(50) NOT NULL DEFAULT '0' COMMENT '小程序AppSecret',
  `notice` varchar(255) DEFAULT NULL COMMENT '公告',
  `is_ad` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否开启流量主',
  `ad_banner` varchar(255) DEFAULT NULL COMMENT 'Banner广告id',
  `ad_excitation` varchar(255) DEFAULT NULL COMMENT '激励广告id',
  `ad_screen` varchar(255) DEFAULT NULL COMMENT '插屏广告id',
  `ad_video` varchar(255) DEFAULT NULL COMMENT '视频广告id',
  `is_recycle` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否回收',
  `money_login` int(11) NOT NULL DEFAULT '0' COMMENT '首次登录奖励金币',
  `is_limit` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否限制用户解析',
  `is_analysis` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否使用内置解析接口（0=第三方 1=内置）',
  `is_delete` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`wxapp_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='微信小程序记录表';
CREATE TABLE `yoshop_wxapp_category` (
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `category_style` tinyint(3) unsigned NOT NULL DEFAULT '10' COMMENT '分类页样式(10一级分类[大图] 11一级分类[小图] 20二级分类)',
  `share_title` varchar(10) NOT NULL COMMENT '分享标题',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`wxapp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='微信小程序分类页模板';
CREATE TABLE `yoshop_wxapp_formid` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `form_id` varchar(50) NOT NULL COMMENT '小程序form_id',
  `expiry_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  `is_used` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否已使用',
  `used_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '使用时间',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='小程序form_id记录表';
CREATE TABLE `yoshop_wxapp_help` (
  `help_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `title` varchar(255) NOT NULL COMMENT '帮助标题',
  `content` text NOT NULL COMMENT '帮助内容',
  `sort` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '排序(数字越小越靠前)',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`help_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8 COMMENT='微信小程序帮助';
CREATE TABLE `yoshop_wxapp_page` (
  `page_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '页面id',
  `page_type` tinyint(3) unsigned NOT NULL DEFAULT '10' COMMENT '页面类型(10首页 20自定义页)',
  `page_name` varchar(255) NOT NULL COMMENT '页面名称',
  `page_data` longtext NOT NULL COMMENT '页面数据',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '微信小程序id',
  `is_delete` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '软删除',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`page_id`),
  KEY `wxapp_id` (`wxapp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8 COMMENT='微信小程序diy页面表';
CREATE TABLE `yoshop_wxapp_prepay_id` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `order_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '订单id',
  `prepay_id` varchar(50) NOT NULL COMMENT '微信支付prepay_id',
  `can_use_times` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '可使用次数',
  `used_times` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '已使用次数',
  `pay_status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '支付状态(1已支付)',
  `wxapp_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小程序id',
  `expiry_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='小程序prepay_id记录';
BEGIN;
LOCK TABLES `jumao`.`yoshop_admin_user` WRITE;
DELETE FROM `jumao`.`yoshop_admin_user`;
INSERT INTO `jumao`.`yoshop_admin_user` (`admin_user_id`,`user_name`,`password`,`create_time`,`update_time`) VALUES (10001, 'admin', 'bf2df1b815ce5d541b7cc4309ba146e8', 1670852595, 1670852595);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_setting` WRITE;
DELETE FROM `jumao`.`yoshop_setting`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_store_access` WRITE;
DELETE FROM `jumao`.`yoshop_store_access`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_store_role` WRITE;
DELETE FROM `jumao`.`yoshop_store_role`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_store_role_access` WRITE;
DELETE FROM `jumao`.`yoshop_store_role_access`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_store_user` WRITE;
DELETE FROM `jumao`.`yoshop_store_user`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_store_user_role` WRITE;
DELETE FROM `jumao`.`yoshop_store_user_role`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_user` WRITE;
DELETE FROM `jumao`.`yoshop_user`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_user_record` WRITE;
DELETE FROM `jumao`.`yoshop_user_record`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_wxapp` WRITE;
DELETE FROM `jumao`.`yoshop_wxapp`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_wxapp_category` WRITE;
DELETE FROM `jumao`.`yoshop_wxapp_category`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_wxapp_formid` WRITE;
DELETE FROM `jumao`.`yoshop_wxapp_formid`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_wxapp_help` WRITE;
DELETE FROM `jumao`.`yoshop_wxapp_help`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_wxapp_page` WRITE;
DELETE FROM `jumao`.`yoshop_wxapp_page`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `jumao`.`yoshop_wxapp_prepay_id` WRITE;
DELETE FROM `jumao`.`yoshop_wxapp_prepay_id`;
UNLOCK TABLES;
COMMIT;
