# DevEnv

This is a set of scripts that facilitate the use of https on a local host for any project you run in Docker.

## Contents

* [Prerequisites](#prerequisites)
* [Nginx Proxy Installation](#nginx-proxy-installation)
* [Local HTTPS Certificates](#local-https-certificates)
* [Setting up *.devenv.test](#setting-up-devenvtest)
* [Attaching your application to `nginx-proxy`](#attaching-your-application-to-nginx-proxy)

---

## Prerequisites

* OS
    * macOS
    * Linux
    * Windows 10
* [Docker][docker] 

Linux and macOS scripts assume bash (or a compatible shell) to be used. If you use another shell,
please use its syntax if it differs from bash.

On Windows Powershell is used.

## Nginx Proxy Installation

To get started with the local dev environment, you need to install and run
the Nginx Proxy container, which DevEnv projects rely on.

* To start, clone this repository and go to the `nginx-proxy` directory:

    ```bash
    git clone git@github.com:denisvmedia/devenv.git
    cd devenv/nginx-proxy
    ```
* Then, create a new docker network:

    ```bash
    docker network create nginx-proxy
    ```
* Finally, run the nginx-proxy container:

    ```bash
    docker-compose up --build -d
    ```

For the additional information on how `nginx-proxy` works, please refer to
the [original documentation][nginx-proxy-docs].

## Local HTTPS certificates

Many functionalities of DevEnv are https only (e.g. push notifications).
In order to be able of use those, we need to install an HTTPS certificate
locally. [mkcert][mkcert] is a simple zero-config
tool to make locally trusted development certificates with any names you’d like.

* Use the [official documentation][mkcert-docs] to install `mkcert` on your
platform.

    After having `mkcert` installed we can create our local certificates. Since
    DevEnv uses multiple domains, we can generate a wildcard one:

    ```bash
    # change to nginx-proxy/certs - the folder where nginx-proxy expects the certificates
    cd devenv/nginx-proxy/certs
  
    # generate the certificates
    mkcert -cert-file=devenv.test.crt -key-file=devenv.test.key *.devenv.test
    ```

    Where `devenv.test` is the domain, which `nginx-proxy` will listen to. If you
    want, you can configure your own domain in `docker-compose.override.yml`.

* To make your system and browsers trust the newly generated certificates you
should run the following:

    ```bash
    mkcert -install
    ```

Now you have your local HTTPS certificate.

## Setting up *.devenv.test

As a rule of thumb, don't touch your `/etc/hosts` file as there are smarter ways
to solve a problem of development domains.

* Ubuntu 20.04
    * Run `bash ubuntu2004-test-domain.sh` script (utilizes `dnsmasq` and `systemd-resolved`).
* macOS
    * Run `bash macos-test-domain.sh` script (utilizes `dnsmasq`).
* Windows 10
    * Run `powershell.exe -File windows-test-domain.ps1` (will run [CoreDNS][coredns] in Docker).

## Attaching your application to `nginx-proxy`

Check [this link](sample-project) for a demo application that exposes an http endpoint
that becomes visible to nginx-proxy. To test it first run this script:

```bash
cd sample-project
docker-compose up --build
```

Then navigate in your browser to [this link](https://hello-world.devenv.test/).

If you did everything properly, you should see a "Hello World" page without any certificate issues.

[docker]: https://docker.io/
[nginx-proxy-docs]: https://github.com/nginx-proxy/nginx-proxy#usage
[mkcert]: https://github.com/FiloSottile/mkcert
[mkcert-docs]: https://github.com/FiloSottile/mkcert#installation
[coredns]: https://coredns.io
