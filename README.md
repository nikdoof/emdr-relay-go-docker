emdr-relay-go-docker
====================

Simple Dockerfile to build a EMDR Relay from the current github code.

Overview
--------

This grabs the build requirements and uses the example configuration files to start a EMDR Relay instance on port `8050` managed by Supervisor.

Using
-----

The container image is available on the public Docker index.

* `docker pull nikdoof/emdr-relay-go`
* `docker run nikdoof/emdr-relay-go`

Build
-----

Run `docker build -t "nikdoof/emdr-relay-go" .` from the repository directory.

Todo
----

* Pull/update on container boot, ensuring the latest code.
* Setup a working cron setup for restarts, to avoid DNS oddities.