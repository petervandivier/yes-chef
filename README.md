# Yes, Chef!

I'm new to the [kitchen][1] and I've been having some trouble keeping track of my recipes. To help me keep it straight, this repo is to set up a few snapshots of the minimum surface config needed to properly cook baseline configurations. 

# Sweets (suites)

## JVP

> Just-the-VM.

The minimum configuration needed to make a VM can be found at commit `f9bd9f0067889a1d124121d459665796db3c059b`. It is deceptively small, requiring just 3 nodes in `.kitchen.yml`. 

The stack I'm running at the moment includes the following: 

* vagrant
* chefdk
* virtualbox

From this point, invoking a `kitchen` function which might reference a VM will prompt `kitchen` to create the directory `./.kitchen` if it does not already exist. Sub-directories are also created and populated as needed. Notably: `kitchen list` will create `./.kitchen/logs` with file targets for both the kitchen process and for any VMs currently named in `.kitchen.yml`. A VM-affected command like `destroy` will create a one-level up directory for your `$driver`. 

On [`converge`][2], I observe `./.kitchen/kitchen-vagrant/` directory created with a subdirectory for the `$vm_name` and a `$vm_name` file created in the previously mentioned `/log` directory.

> **NOTE** if you delete the `./.kitchen/` directory manually, kitchen will not be able to `destroy` the vm and you will need to do so manually from the virtualbox interface. 

## MVPG

> Minimum Viable PostgreSQL

### Community Cookbook

As seen at `dbb5992f313e7d89ab5c7397692a3bb9e329c234`, add the following items to deploy a default PostgreSQL to your VM

* ./Berksfile
* ./metadata.rb
* ./recipes/default.rb

Adding these files adds the following transparent dependencies. 

* [sous-chefs/postgresql][3] - the community cookbook for postgres, as indexed in https://supermarket.chef.io, which we declare in our `Berksfile`
* [`yum`][4] - given that we're only working with Centos-7.2, the `postgresql` cookbook invokes `yum`
* [`berks`][5] - berks is a new `exe` with its own args. `kitchen converge` with a Berksfile present will create a corresponding `Berksfile.lock` file
    - note that the encoding of the `.lock` file may vary between hosts/platforms, even when the content remains consistent

### Roll your own

I got cross eyed trying to figure out how to use the community cookbook, so now we remove the dependecy! The last commit on which the community cookbook is referenced is `13d27dcec853e094b7e9acfaba4151e0cccab4c6`. 

<!-- Secret HT @kingcdavid for literally _all the work_ plus plenty of hand-holding -->

```sh
[vagrant@jtv-centos-72 ~]$ yum list | grep postgres
```

Given the baseline packages available in `yum` on the centos image we're using, we can invoke the `postgresql-server` package directly. This unpacks the `postgresql-setup` bash script and adds it to the PATH inside the VM.

We can remove the `Berksfile` at this stage (not sure why atm :shrug:).

### TODO: PostgreSQL >9

The version of postgres installed atm is 9.2, this is unnaceptabru

The community cookbook does some mind-bendy service calls to determine the proper packages to pull, :crossed_fingers: we don't need to reconstruct that...

## Connecting to PostgreSQL on your VM

We now have a viable, fully featured database instance. We can ssh onto the vm trivially with the `kitchen login [INSTANCE|REGEXP]` command. You can find the necessary details to ssh/scp "manually" at `./.kitchen/$vm_name.yml` (mvpg-centos-72.yml in our case). 

How though, would you connect with an IDE? Surely you don't want to [_only ever ssh_](https://www.youtube.com/watch?v=zGxwbhkDjZM).

Assuming you are running [PG Admin][6], you can now connect "as normal" with the addition of the information found in `./.kitchen/$vm_name.yml`, for example:

```yml
---
hostname: 127.0.0.1
port: '2222'
username: vagrant
ssh_key: C:/chef/yes-chef/.kitchen/kitchen-vagrant/mvpg-centos-72/.vagrant/machines/default/virtualbox/private_key
last_action: converge
last_error: 
```
Use these values on the <kbd>SSH Tunnel</kbd> as shown below to connect "as normal" to your PostgreSQL cluster inside the VM. Note that by default the password should be left blank for both the vagrant/ssh and postgres user fields at this stage. 

![mvpg-pgadmin-ssh-tunnel](/doc/img/mvpg-pgadmin-ssh-tunnel.jpg)

## Port Forwarding

TODO: Port forwarding & pg_hba.conf

[1]: https://kitchen.ci/
[2]: https://kitchen.ci/docs/getting-started/running-converge/
[3]: https://github.com/sous-chefs/postgresql
[4]: https://en.wikipedia.org/wiki/Yum_(software)
[5]: https://docs.chef.io/berkshelf.html
[6]: https://www.pgadmin.org/
