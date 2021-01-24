CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `billing` text COLLATE utf8mb4_unicode_ci,
  `token_code` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twofa_secret` varchar(16) DEFAULT NULL,
  `pending_email` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_activation_code` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lost_password_code` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `facebook_id` bigint(20) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `active` int(11) NOT NULL DEFAULT '0',
  `plan_id` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `plan_expiration_date` datetime DEFAULT NULL,
  `plan_settings` text COLLATE utf8_unicode_ci,
  `plan_trial_done` tinyint(4) DEFAULT '0',
  `payment_subscription_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `current_month_notifications_impressions` int(11) DEFAULT '0',
  `total_notifications_impressions` int(11) DEFAULT '0',
  `language` varchar(32) COLLATE utf8_unicode_ci DEFAULT 'english',
  `timezone` varchar(32) DEFAULT 'UTC',
  `date` datetime DEFAULT NULL,
  `ip` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `last_activity` datetime DEFAULT NULL,
  `last_user_agent` text COLLATE utf8_unicode_ci,
  `total_logins` int(11) DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `plan_id` (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SEPARATOR --

INSERT INTO `users` (`user_id`, `email`, `password`, `name`, `token_code`, `email_activation_code`, `lost_password_code`, `facebook_id`, `type`, `active`, `plan_id`, `plan_expiration_date`, `plan_settings`, `plan_trial_done`, `payment_subscription_id`, `current_month_notifications_impressions`, `total_notifications_impressions`, `date`, `ip`, `last_activity`, `last_user_agent`, `total_logins`)
VALUES (1,'admin','$2y$10$uFNO0pQKEHSFcus1zSFlveiPCB3EvG9ZlES7XKgJFTAl5JbRGFCWy','Babiato','','','',NULL,1,1,'free','2020-07-15 11:26:19','{\"no_ads\":true,\"removable_branding\":true,\"custom_branding\":true,\"campaigns_limit\":-1,\"notifications_limit\":-1,\"notifications_impressions_limit\":-1,\"enabled_notifications\":{\"INFORMATIONAL\":true,\"COUPON\":true,\"LIVE_COUNTER\":true,\"EMAIL_COLLECTOR\":true,\"LATEST_CONVERSION\":true,\"CONVERSIONS_COUNTER\":true,\"VIDEO\":true,\"SOCIAL_SHARE\":true,\"RANDOM_REVIEW\":true,\"EMOJI_FEEDBACK\":true,\"COOKIE_NOTIFICATION\":true,\"SCORE_FEEDBACK\":true,\"REQUEST_COLLECTOR\":true,\"COUNTDOWN_COLLECTOR\":true}}',1,'',0,0,'2019-06-01 12:00:00','','2019-06-15 12:20:13','',0);

-- SEPARATOR --

CREATE TABLE `campaigns` (
  `campaign_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `pixel_key` varchar(32) DEFAULT NULL,
  `name` varchar(256) NOT NULL DEFAULT '',
  `domain` varchar(256) NOT NULL DEFAULT '',
  `include_subdomains` int(11) DEFAULT '0',
  `branding` text,
  `is_enabled` tinyint(4) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  PRIMARY KEY (`campaign_id`),
  KEY `user_id` (`user_id`),
  KEY `campaigns_domain_index` (`domain`),
  KEY `campaigns_pixel_key_index` (`pixel_key`),
  CONSTRAINT `campaigns_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ROW_FORMAT=DYNAMIC ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SEPARATOR --

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL DEFAULT '',
  `type` varchar(64) NOT NULL DEFAULT '',
  `settings` text NOT NULL,
  `last_action_date` datetime DEFAULT NULL COMMENT 'action ex: conversion',
  `notification_key` varchar(32) NOT NULL DEFAULT '' COMMENT 'Used for identifying webhooks',
  `is_enabled` tinyint(4) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `campaign_id` (`campaign_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`campaign_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SEPARATOR --

CREATE TABLE `plans` (
  `plan_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL DEFAULT '',
  `monthly_price` float NULL,
  `annual_price` float NULL,
  `lifetime_price` float NULL,
  `settings` text NOT NULL,
  `taxes_ids` text,
  `status` tinyint(4) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SEPARATOR --

CREATE TABLE `pages_categories` (
  `pages_category_id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `title` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `icon` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pages_category_id`),
  KEY `url` (`url`)
) ROW_FORMAT=DYNAMIC ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SEPARATOR --

CREATE TABLE `pages` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
  `pages_category_id` int(11) DEFAULT NULL,
  `url` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `description` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8_unicode_ci,
  `type` varchar(16) COLLATE utf8_unicode_ci DEFAULT '',
  `position` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `order` int(11) DEFAULT '0',
  `total_views` int(11) DEFAULT '0',
  `date` datetime DEFAULT NULL,
  `last_date` datetime DEFAULT NULL,
  PRIMARY KEY (`page_id`),
  KEY `pages_pages_category_id_index` (`pages_category_id`),
  KEY `pages_url_index` (`url`),
  CONSTRAINT `pages_pages_categories_pages_category_id_fk` FOREIGN KEY (`pages_category_id`) REFERENCES `pages_categories` (`pages_category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- SEPARATOR --

CREATE TABLE `track_conversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_id` int(11) NOT NULL,
  `type` varchar(32) NOT NULL DEFAULT '',
  `data` longtext NOT NULL,
  `url` text,
  `location` varchar(512) DEFAULT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notification_id` (`notification_id`),
  KEY `track_conversions_date_index` (`date`),
  CONSTRAINT `track_conversions_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`notification_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SEPARATOR --

CREATE TABLE `track_logs` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`user_id` int(11) NOT NULL,
`dynamic_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
`domain` varchar(256) CHARACTER SET utf8mb4 NOT NULL,
`url` text CHARACTER SET utf8mb4 NOT NULL,
`ip_binary` varbinary(16) DEFAULT NULL,
`count` int(11) NOT NULL DEFAULT '1',
`date` datetime NOT NULL,
`last_date` datetime NOT NULL,
PRIMARY KEY (`id`),
UNIQUE KEY `pageview_id` (`dynamic_id`),
KEY `user_id` (`user_id`),
KEY `domain` (`domain`),
KEY `track_logs_last_date_index` (`last_date`),
KEY `track_logs_ip_binary_index` (`ip_binary`),
CONSTRAINT `track_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ROW_FORMAT=DYNAMIC ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- SEPARATOR --

CREATE TABLE `track_notifications` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`campaign_id` int(11) DEFAULT NULL,
`notification_id` int(11) NOT NULL,
`dynamic_id` varchar(32) NOT NULL DEFAULT '',
`type` varchar(32) NOT NULL DEFAULT '',
`url` text NOT NULL,
`count` int(11) NOT NULL DEFAULT '1',
`date` datetime NOT NULL,
`last_date` datetime NOT NULL,
PRIMARY KEY (`id`),
UNIQUE KEY `pageview_id` (`dynamic_id`),
KEY `notification_id` (`notification_id`),
KEY `track_notifications_date_index` (`date`),
KEY `track_notifications_campaign_id_index` (`campaign_id`),
CONSTRAINT `track_notifications_campaigns_campaign_id_fk` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`campaign_id`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `track_notifications_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`notification_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ROW_FORMAT=DYNAMIC ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- SEPARATOR --

CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(64) NOT NULL DEFAULT '',
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SEPARATOR --
SET @cron_key = MD5(RAND());
-- SEPARATOR --
SET @cron_reset_date = NOW();

-- SEPARATOR --
INSERT INTO `settings` (`key`, `value`)
VALUES
	('ads', '{\"header\":\"\",\"footer\":\"\"}'),
	('captcha', '{\"recaptcha_is_enabled\":\"0\",\"recaptcha_public_key\":\"\",\"recaptcha_private_key\":\"\"}'),
	('cron', concat('{\"key\":\"', @cron_key, '\",\"reset_date\":\"', @cron_reset_date, '\"}')),
	('default_language', 'english'),
	('default_theme_style', 'light'),
	('email_confirmation', '0'),
	('register_is_enabled', '1'),
	('email_notifications', '{\"emails\":\"\",\"new_user\":\"0\",\"new_payment\":\"0\"}'),
	('facebook', '{\"is_enabled\":\"0\",\"app_id\":\"\",\"app_secret\":\"\"}'),
	('favicon', ''),
	('logo', ''),
    ('plan_custom', '{\"plan_id\":\"custom\",\"name\":\"Custom\",\"status\":1}'),
	('plan_free', '{\"plan_id\":\"free\",\"name\":\"Free\",\"days\":null,\"status\":1,\"settings\":{\"no_ads\":true,\"removable_branding\":true,\"custom_branding\":true,\"campaigns_limit\":5,\"notifications_limit\":25,\"notifications_impressions_limit\":10000,\"enabled_notifications\":{\"INFORMATIONAL\":true,\"COUPON\":true,\"LIVE_COUNTER\":true,\"EMAIL_COLLECTOR\":true,\"LATEST_CONVERSION\":true,\"CONVERSIONS_COUNTER\":true,\"VIDEO\":true,\"SOCIAL_SHARE\":true,\"RANDOM_REVIEW\":true,\"EMOJI_FEEDBACK\":true,\"COOKIE_NOTIFICATION\":true,\"SCORE_FEEDBACK\":true,\"REQUEST_COLLECTOR\":true,\"COUNTDOWN_COLLECTOR\":true}}}'),
	('plan_trial', '{\"plan_id\":\"trial\",\"name\":\"Trial\",\"days\":7,\"status\":0,\"settings\":{\"no_ads\":true,\"removable_branding\":true,\"custom_branding\":true,\"campaigns_limit\":5,\"notifications_limit\":25,\"notifications_impressions_limit\":10000,\"enabled_notifications\":{\"INFORMATIONAL\":true,\"COUPON\":true,\"LIVE_COUNTER\":true,\"EMAIL_COLLECTOR\":true,\"LATEST_CONVERSION\":true,\"CONVERSIONS_COUNTER\":true,\"VIDEO\":true,\"SOCIAL_SHARE\":true,\"RANDOM_REVIEW\":true,\"EMOJI_FEEDBACK\":true,\"COOKIE_NOTIFICATION\":true,\"SCORE_FEEDBACK\":true,\"REQUEST_COLLECTOR\":true,\"COUNTDOWN_COLLECTOR\":true}}}'),
	('payment', '{\"is_enabled\":false,\"brand_name\":\"SocialProof\",\"currency\":\"USD\"}'),
	('paypal', '{\"is_enabled\":\"0\",\"mode\":\"sandbox\",\"client_id\":\"\",\"secret\":\"\"}'),
	('stripe', '{\"is_enabled\":\"0\",\"publishable_key\":\"\",\"secret_key\":\"\",\"webhook_secret\":\"\"}'),
    ('offline_payment', '{\"is_enabled\":\"0\",\"instructions\":\"Your offline payment instructions go here..\"}'),
    ('smtp', '{\"host\":\"\",\"from\":\"\",\"encryption\":\"tls\",\"port\":\"587\",\"auth\":\"0\",\"username\":\"\",\"password\":\"\"}'),
	('custom', '{\"head_js\":\"\",\"head_css\":\"\"}'),
	('socials', '{\"facebook\":\"\",\"instagram\":\"\",\"twitter\":\"\",\"youtube\":\"\"}'),
	('default_timezone', 'UTC'),
	('title', 'SocialProof'),
	('privacy_policy_url', ''),
	('terms_and_conditions_url', ''),
	('index_url', ''),
    ('business', '{\"invoice_is_enabled\":\"0\",\"name\":\"\",\"address\":\"\",\"city\":\"\",\"county\":\"\",\"zip\":\"\",\"country\":\"\",\"email\":\"\",\"phone\":\"\",\"tax_type\":\"\",\"tax_id\":\"\",\"custom_key_one\":\"\",\"custom_value_one\":\"\",\"custom_key_two\":\"\",\"custom_value_two\":\"\"}'),
    ('socialproofo', '{\"analytics_is_enabled\": true, \"pixel_cache\": 0}'),
    ('license', '{\"license\":\"Babiato.Co\",\"type\":\"Extended License\"}');

-- SEPARATOR --

CREATE TABLE `users_logs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(64) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `public` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `users_logs_user_id` (`user_id`),
  CONSTRAINT `users_logs_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




-- SEPARATOR -- 
CREATE TABLE `payments` ( `id` int(11) unsigned NOT NULL AUTO_INCREMENT, `user_id` int(11) DEFAULT NULL, `plan_id` int(11) DEFAULT NULL, `processor` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `type` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `frequency` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `payment_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `subscription_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `payer_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `email` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `name` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `billing` text COLLATE utf8mb4_unicode_ci, `taxes_ids` text COLLATE utf8mb4_unicode_ci, `base_amount` float DEFAULT NULL, `total_amount` float DEFAULT NULL, `code` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `discount_amount` float DEFAULT NULL, `currency` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `payment_proof` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `status` tinyint(4) DEFAULT '1', `date` datetime DEFAULT NULL, PRIMARY KEY (`id`), KEY `payments_user_id` (`user_id`), KEY `plan_id` (`plan_id`), CONSTRAINT `payments_plans_plan_id_fk` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`plan_id`) ON DELETE SET NULL ON UPDATE CASCADE, CONSTRAINT `payments_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci; 
-- SEPARATOR -- 
CREATE TABLE IF NOT EXISTS `codes` ( `code_id` int(11) NOT NULL AUTO_INCREMENT, `type` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `days` int(11) DEFAULT NULL COMMENT 'only applicable if type is redeemable', `plan_id` int(16) DEFAULT NULL, `code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '', `discount` int(11) NOT NULL, `quantity` int(11) NOT NULL DEFAULT '1', `redeemed` int(11) NOT NULL DEFAULT '0', `date` datetime NOT NULL, PRIMARY KEY (`code_id`), KEY `type` (`type`), KEY `code` (`code`), KEY `plan_id` (`plan_id`), CONSTRAINT `codes_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`plan_id`) ON DELETE CASCADE ON UPDATE CASCADE ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci; 
-- SEPARATOR -- 
CREATE TABLE IF NOT EXISTS `redeemed_codes` ( `id` int(11) NOT NULL AUTO_INCREMENT, `code_id` int(11) NOT NULL, `user_id` int(11) NOT NULL, `date` datetime NOT NULL, PRIMARY KEY (`id`), KEY `code_id` (`code_id`), KEY `user_id` (`user_id`), CONSTRAINT `redeemed_codes_ibfk_1` FOREIGN KEY (`code_id`) REFERENCES `codes` (`code_id`) ON DELETE CASCADE ON UPDATE CASCADE, CONSTRAINT `redeemed_codes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci; 
-- SEPARATOR -- 
CREATE TABLE `taxes` ( `tax_id` int(11) unsigned NOT NULL AUTO_INCREMENT, `internal_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `description` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL, `value` int(11) DEFAULT NULL, `value_type` enum('percentage','fixed') COLLATE utf8mb4_unicode_ci DEFAULT NULL, `type` enum('inclusive','exclusive') COLLATE utf8mb4_unicode_ci DEFAULT NULL, `billing_type` enum('personal','business','both') COLLATE utf8mb4_unicode_ci DEFAULT NULL, `countries` text COLLATE utf8mb4_unicode_ci, `datetime` datetime DEFAULT NULL, PRIMARY KEY (`tax_id`) ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;