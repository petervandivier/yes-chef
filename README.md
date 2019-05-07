# yes-chef

I'm new to the [kitchen][1] and I've been having some trouble keeping track of my recipes. To help me keep it straight, this repo is to set up a few snapshots of the minimum surface config needed to properly cook baseline configurations. 

# Sweets (suites)

## JVP

Just-the-VM.

The minimum configuration needed to make a VM can be found at commit `f9bd9f0067889a1d124121d459665796db3c059b`. It is deceptively small, requiring just 3 nodes in `.kitchen.yml`. 

The stack I'm running at the moment includes the following: 

* vagrant
* chefdk
* virtualbox

From this point, invoking a `kitchen` function which might reference a VM will prompt `kitchen` to create the directory `./.kitchen` if it does not already exist. Sub-directories are also created and populated as needed. Notably: `kitchen list` will create `./.kitchen/logs` with file targets for both the kitchen process and for any VMs currently named in `.kitchen.yml`. A VM-affected command like `destroy` will create a one-level up directory for your `$driver`. 

On [`converge`][2], I observe `./.kitchen/kitchen-vagrant/` directory created with a subdirectory for the `$vm_name` and a `$vm_name` file created in the previously mentioned `/log` directory.

## MVPG

Coming Soon! Deploy PostgreSQL!

[1]: https://kitchen.ci/
[2]: https://kitchen.ci/docs/getting-started/running-converge/
