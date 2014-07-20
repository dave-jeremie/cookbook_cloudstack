cloudstack Cookbook
===================

Install and configure [Apache Cloudstack](http://cloudstack.apache.org) using [Chef](http://www.getchef.com/). A wrapper cookbook is prefered in order to Install Apache CloudStack properly, see [cloudstack_wrapper cookbook](https://github.com/cloudops/cookbook_cloudstack_wrapper) as example.


> Work in progress.
>
> This is a complete rework of the co-cloudstack cookbook to use LWRP.

Tested on CentOS 6.5 and Ubuntu 14.04


About Apache Cloudstack
-----------------------

Apache CloudStack is open source software designed to deploy and manage large networks of virtual machines, as a highly available, highly scalable Infrastructure as a Service (IaaS) cloud computing platform.

More info on: http://cloudstack.apache.org/

Requirements
------------

#### cookbooks
- `yum` - packages management
- `apt` - packages management
- `mysql` - for MySQL database server and client
- `sudo` - to configure sudoers for user "cloud"


Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


License and Authors
-------------------
- Author:: Pierre-Luc Dion (<pdion@cloudops.com>)

Some snippets have been taken from: [schubergphilis/cloudstack-cookbook](https://github.com/schubergphilis/cloudstack-cookbook)
- Author:: Roeland Kuipers (<rkuipers@schubergphilis.com>)  
- Author:: Sander Botman (<sbotman@schubergphilis.com>)
- Author:: Hugo Trippaers (<htrippaers@schubergphilis.com>)


```text
Copyright:: Copyright (c) 2014 CloudOps.com

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
