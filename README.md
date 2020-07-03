# Yes, Chef!

I'm new to the [kitchen][1] and I've been having some trouble keeping track of my recipes. To help me keep it straight, this repo is to set up a few snapshots of the minimum surface config needed to properly cook baseline configurations. 

# Sweets (suites)

## JVP

> Just-the-VM.

The minimum configuration needed to make a VM can be found at commit `f9bd9f0067889a1d124121d459665796db3c059b`. It is deceptively small, requiring just 3 nodes in `.kitchen.yml`. Having a "blank" VM is ~~sometimes~~ _very often_ **super useful** for trying new things before checking them in. 

The stack I'm running at the moment includes the following: 

* vagrant
* chefdk
* virtualbox

From this point, invoking a `kitchen` function which might reference a VM will prompt `kitchen` to create the directory `./.kitchen` if it does not already exist. Sub-directories are also created and populated as needed. Notably: `kitchen list` will create `./.kitchen/logs` with file targets for both the kitchen process and for any VMs currently named in `.kitchen.yml`. A VM-affected command like `destroy` will create a one-level up directory for your `$driver`. 

On [`converge`][2], I observe `./.kitchen/kitchen-vagrant/` directory created with a subdirectory for the `$vm_name` and a `$vm_name` file created in the previously mentioned `/log` directory.

> **NOTE** if you delete the `./.kitchen/` directory manually, kitchen will not be able to `destroy` the vm and you will need to do so manually from the virtualbox interface. 

## MVPG

> Minimum Viable PostgreSQL

See commit `5b7d50fd4521ebcf75487fea06d50b7be9d061e8` for the last remnants of the [community cookbook][3]. I've plagiarized from [this Disney-theme'd how-to][11] for deploying Postgres 10. The community cookbook is it's own beast to learn and trying to "roll my own" with the existing available yum packages on the Centos-7.6 image I'm using gated me to PG 9.6.

I'm moving a bit faster now, but I'm trying to keep up with this README as a Useful Document for Future @petervandivier. 

## ELK

By commit `91893ab2a16e6215aa7b9c2ec0f28c37ee2a33bd`, we have an Elasticsearch VM with some barebones testing. 

# Tests

I've added [InSpec for kitchen][12] tests. InSpec as a testing provider is [also available for chef][13] for assertions for server-side / suite deployment. 

---

[1]: https://kitchen.ci/
[2]: https://kitchen.ci/docs/getting-started/running-converge/
[3]: https://github.com/sous-chefs/postgresql

[11]: https://tecadmin.net/install-postgresql-server-centos/
[12]: https://github.com/inspec/kitchen-inspec
[13]: https://github.com/inspec/inspec
