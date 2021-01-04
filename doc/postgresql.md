
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

You can [configure port-forwarding](https://stackoverflow.com/a/38677478/4709762) inside a newly `create`d VM. If you get back the following error when to the postgres service...

```
$ psql "postgresql://postgres@127.0.0.1:54321/postgres"
psql: error: server closed the connection unexpectedly
        This probably means the server terminated abnormally
        before or while processing the request.
$
```
...then you may need to add a `listen_address` to your postgresql.conf (as written up [here](https://dba.stackexchange.com/a/282540/68127)).

# Postgres PITR

> Point-In-Time-Recovery

Before I start [rubber-ducking :duck:][9] through this, some preconceptions should be voiced that it took me a while to arrive at coming froma pure MS SQL background:

1. For PITR purposes, a Postgres "cluster" is analogous to a Microsoft "database"
2. For all other purposes, a Postgres "cluster" is analogous to a Microsoft "instance"
3. MS manages WAL per-database. Postgres does this per-cluster (all databases on an instance share the WAL)
  * The scope of the write-ahead-log (WAL) <sup>**1**</sup> is the `$UNIT` against which a PITR (`restore $DATABASE to $TIME`) command is executed. 

Both MS & Postgres contain multiple databases per instance (cluster in their PG vocabulary). MS executes PITR command against a single DB. The "same" PITR command in PG applies to a cluster of multiple databases which all share a common WAL. 

----

<sup>**1**: Good (optional) reading: [ARIES whitepaper][9]</sup>

<sup>**2**: Note that "log file", "transaction log", or "tran log" is the verbiage most often used when referring to the MS Write-Ahead-Log (WAL). For consistency's sake (and to follow the example of the ARIES whitepaper), I will try to use WAL cosistently here even when referring to an MSSQL transaction log file backup chain.</sup>

[6]: https://www.pgadmin.org/
[7]: https://www.postgresql.org/docs/current/auth-pg-hba-conf.html
[8]: https://www.postgresql.org/docs/current/auth-trust.html
[9]: https://en.wikipedia.org/wiki/Rubber_duck_debugging
[10]: https://people.eecs.berkeley.edu/~brewer/cs262/Aries.pdf
