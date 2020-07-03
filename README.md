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

## Elasticsearch

By commit `91893ab2a16e6215aa7b9c2ec0f28c37ee2a33bd`, we have an Elasticsearch VM with some barebones testing. 

# Tests

I've added [InSpec for kitchen][12] tests. InSpec as a testing provider is [also available for chef][13] for assertions for server-side / suite deployment. 

# Connecting to PostgreSQL on your VM

With the "mvpg" suite, we have a viable, fully featured database instance. We can ssh onto the vm trivially with the `kitchen login [INSTANCE|REGEXP]` command. You can find the necessary details to ssh/scp "manually" at `./.kitchen/$vm_name.yml` (mvpg-centos-72.yml in our case). 

How though, would you connect with an IDE? Surely you don't want to [_only ever ssh_](https://www.youtube.com/watch?v=zGxwbhkDjZM).

## SSH Tunnelling

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

It appears the following record on [pg_hba.conf][7] corresponds to this access management. 

```ascii
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             ::1/128                 trust
```

[`trust`][8] is the most permissive access level and will confer access with a blank password for all users with the above configuration.  

## Port Forwarding

TODO: Port forwarding & pg_hba.conf

# Postgres PITR

> Point-In-Time-Recovery

Before I start [rubber-ducking :duck:][9] through this, some preconceptions should be voiced that it took me a while to arrive at coming froma pure MS SQL background:

1. For PITR purposes, a Postgres "cluster" is analogous to a Microsoft "database"
2. For all other purposes, a Postgres "cluster" is analogous to a Microsoft "instance"
3. MS manages WAL per-database. Postgres does this per-cluster (all databases on an instance share the WAL)
  * The scope of the write-ahead-log (WAL) <sup>**1**</sup> is the `$UNIT` against which a PITR (`restore $DATABASE to $TIME`) command is executed. 

Both MS & Postgres contain multiple databases per instance (cluster in their PG vocabulary). MS executes PITR command against a single DB. The "same" PITR command in PG applies to a cluster of multiple databases which all share a common WAL. 

---

<sup>**1**: Good (optional) reading: [ARIES whitepaper][9]</sup>

<sup>**2**: Note that "log file", "transaction log", or "tran log" is the verbiage most often used when referring to the MS Write-Ahead-Log (WAL). For consistency's sake (and to follow the example of the ARIES whitepaper), I will try to use WAL cosistently here even when referring to an MSSQL transaction log file backup chain.</sup>

[1]: https://kitchen.ci/
[2]: https://kitchen.ci/docs/getting-started/running-converge/
[3]: https://github.com/sous-chefs/postgresql
[4]: https://en.wikipedia.org/wiki/Yum_(software)
[5]: https://docs.chef.io/berkshelf.html
[6]: https://www.pgadmin.org/
[7]: https://www.postgresql.org/docs/current/auth-pg-hba-conf.html
[8]: https://www.postgresql.org/docs/current/auth-trust.html
[9]: https://en.wikipedia.org/wiki/Rubber_duck_debugging
[10]: https://people.eecs.berkeley.edu/~brewer/cs262/Aries.pdf
[11]: https://tecadmin.net/install-postgresql-server-centos/
[12]: https://github.com/inspec/kitchen-inspec
[13]: https://github.com/inspec/inspec
