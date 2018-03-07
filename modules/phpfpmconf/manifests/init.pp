# Setup our phpfpm configuration class
class phpfpmconf (
	$config,
	$path = '/vagrant/extensions/phpfpmconf',
) {
	if ( ! empty( $config[disabled_extensions] ) and 'chassis/phpfpmconf' in $config[disabled_extensions] ) {
		$file = absent
	} else {
		$file = present
	}

	# This is a dodgy hack to stop failures in Puppet if content/custom.conf doesn't exist.
	if ( file('/vagrant/content/custom.conf', '/dev/null') != '' ) {
		$version = $config[php]

		if $version =~ /^(\d+)\.(\d+)$/ {
			$package_version = "${version}.*"
			$short_ver = $version
		}
		else {
			$package_version = "${version}*"
			$short_ver = regsubst($version, '^(\d+\.\d+)\.\d+$', '\1')
		}

		if versioncmp($version, '5.4') <= 0 {
			$php_package = 'php5'
			$php_dir = 'php5'
		}
		else {
			$php_package = "php${short_ver}"
			$php_dir = "php/${short_ver}"
		}

		file { "/etc/${php_dir}/fpm/php-fpm.conf":
			ensure  => 'present',
			replace => false,
			require => Package["${php_package}-fpm"]
		}

		# Load in our custom conf so we can strip the carriage return and whitespace.
		$conf = file('/vagrant/content/custom.conf')

		file_line { 'append_conf':
			ensure  => $file,
			line    => rstrip( $conf ),
			path    => "/etc/${php_dir}/fpm/php-fpm.conf",
			require => Package["${php_package}-fpm"],
			notify  => Service["${php_package}-fpm"],
		}
	}
}
