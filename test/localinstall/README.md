# Bubble Kitchen local install

Description
------------
This installs a Bubble from scratch. You can create a Bubble using any computer that meets the requirements (see cookbook requirements). An Intel NUC for example works perfectly fine.

Installation
------------
Run this from the host you create The Bubble (either as root or using sudo):

1. Make sure you comply with the requirements and Centos 7.2 is installed.
2. Download and run the pre-install script:

```
source <(curl -L https://raw.githubusercontent.com/MissionCriticalCloud/bubble-cookbook/master/test/localinstall/install.sh
```
3. Rename the user file `example.json` in `test/fixtures/data_bags/users` to your username. Edit the contents of the file with your username and public ssh key.
4. Start test-kitchen:

```
kitchen converge
```
5. Reboot!

   Run this from your laptop, to connect to The Bubble:
6. Setup L2TP VPN connection to the ipaddress of your newly installed bubble.

![screen shot 2016-03-18 at 13 28 57](https://cloud.githubusercontent.com/assets/1630096/13877811/68585b16-ed0d-11e5-9790-15ad2702f5a2.png)

Verification
------------
This repo provides unit-tests with which this cookbook is tested. The cookbook is tested by verifying that the resulting system is properly configured.
This means you can run these tests to check if your system has been properly configured. 

After installation use the following commands to run the unit tests:
```
export KITCHEN_LOCAL_YAML=.kitchen.localhost.yml
kitchen verify
```

Bubble Toolkit
-------------
Scripts to work with The Bubble can be found here: https://github.com/MissionCriticalCloud/bubble-toolkit

License and Authors
-------------------
Authors:
* Fred Neubauer
* Remi Bergsma
* Bob van den Heuvel
* Boris Schrijver
* Miguel Ferreira
* Wilder Rodrigues

```text
Copyright 2016, Schuberg Philis

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
