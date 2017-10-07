# Custom PHP FPM Conf

A Chassis extension that allows you to append new configuration values to your `php-fpm.conf` so you can tailor your Chassis box to match your server requirements.

## Installation

You have two options to install this extension.
1. Clone the extension manually.
```
# In your Chassis dir:
git clone --recursive https://github.com/Chassis/phpfpmconf.git extensions/phpfpmconf
   
# Reprovision
cd ..
vagrant provision
```

2. Alter your `config.yaml` file to include this extensions.

```
extensions:
 - chassis/phpfpmconf
```
Then reprovision

```
# Reprovision
cd ..
vagrant provision
```

## Configuration

1. Add a new file called `custom.conf` into your `content` directory.
2. Add your custom configuration to this file. e.g. `security.limit_extensions = php.html .php .html`
3. Reprovision `vagrant provision`.
