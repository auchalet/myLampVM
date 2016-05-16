# My LAMP VM

This is just a Vagrant box with the stack I use on a regular basis. Based on debian/jessie, nothing fancy, provisioned with a good ol' bash file, noob friendly. 

## Getting started

```
git clone https://github.com/vince-db/myLampVM.git
cd myLampVM
vagrant plugin install vagrant-vbguest
vagrant up
```
Then go to [http://192.168.33.10](http://192.168.33.10) and you are good to go. 
Mailcatchter is accessible at [http://192.168.33.10:1080](http://192.168.33.10:1080). 

## Customize the configuration

All files that have been modified are copied in the /config directory. If you need to edit them, do so and then run

```
vagrant reload --provision
```
This will execute the init.sh again and copy those files where they belong (see init.sh).