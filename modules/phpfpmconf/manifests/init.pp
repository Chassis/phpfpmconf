# Setup our phpfpm configuration class
class phpfpmconf (
	$config,
	$path = '/vagrant/extensions/phpfpmconf',
) {
	$version = $config[php]
	$conf = file( '/vagrant/content/custom.conf' )

	if $version =~ /^(\d+)\.(\d+)$/ {
		$package_version = "${version}.*"
		$short_ver = $version
	}
	else {
		$package_version = "${version}*"
		$short_ver = regsubst($version, '^(\d+\.\d+)\.\d+$', '\1')
	}

	if versioncmp( $version, '5.4') <= 0 {
		$php_package = 'php5'
		$php_dir = 'php5'
	}
	else {
		$php_package = "php${short_ver}"
		$php_dir = "php/${short_ver}"
	}

	file { "/etc/${php_dir}/fpm/php-fpm.conf":
		ensure  => 'present',
		replace => false
	}

	file_line { 'append_conf':
		line    => $conf,
		path    => "/etc/${php_dir}/fpm/php-fpm.conf",
		require => Package["${php_package}-fpm"],
		notify  => Service["${php_package}-fpm"],
	}
}
