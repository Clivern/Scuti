<p align="center">
    <img alt="Mandrill Logo" src="/static/logo.png?v=0.1.0" width="220" />
    <h3 align="center">Mandrill</h3>
    <p align="center">A Lightweight and Reliable Patching Configuration System, Set up in Minutes.</p>
    <p align="center">
        <a href="https://github.com/Clivern/Mandrill/actions/workflows/api.yml">
            <img src="https://github.com/Clivern/Mandrill/actions/workflows/api.yml/badge.svg">
        </a>
        <a href="https://github.com/Clivern/Mandrill/actions/workflows/ui.yml">
            <img src="https://github.com/Clivern/Mandrill/actions/workflows/ui.yml/badge.svg">
        </a>
        <a href="https://github.com/Clivern/Mandrill/releases">
            <img src="https://img.shields.io/badge/Version-v0.1.0-red.svg">
        </a>
        <!--
        <a href="https://goreportcard.com/report/github.com/Clivern/Mandrill">
            <img src="https://goreportcard.com/badge/github.com/Clivern/Mandrill?v=0.0.1">
        </a>
        <a href="https://godoc.org/github.com/Clivern/Mandrill">
            <img src="https://godoc.org/github.com/Clivern/Mandrill?status.svg">
        </a>
        -->
        <a href="https://github.com/Clivern/Mandrill/blob/main/LICENSE">
            <img src="https://img.shields.io/badge/LICENSE-MIT-grey.svg">
        </a>
    </p>
</p>

`Mandrill` is a Patching Configuration System that provides users with a range of options to customize the patching process for their VM instances.

It allows users to select VM instances manually or by groups, filter VMs based on name or labels, and choose the types of upgrades to perform.

Users can also specify packages to upgrade or exclude, and choose post-patch reboot options. The system also allows users to run pre-patch and post-patch scripts, and set rollout options and schedule types.


### Getting Started

To install Mandrill Server, Use the following script:

```zsh
$ bash < <(curl -s https://raw.githubusercontent.com/Clivern/Mandrill/main/deployment/ubuntu/install_server.sh)

$ bash < <(curl -s https://raw.githubusercontent.com/Clivern/Mandrill/main/deployment/ubuntu/upgrade_server.sh)
```

To install Mandrill Worker, Use the following script:

```zsh
$ bash < <(curl -s https://raw.githubusercontent.com/Clivern/Mandrill/main/deployment/ubuntu/install_worker.sh)

$ bash < <(curl -s https://raw.githubusercontent.com/Clivern/Mandrill/main/deployment/ubuntu/upgrade_worker.sh)
```

To Get The Public IP

```zsh
$ curl https://ipinfo.io/ip
x.x.x.x
```

To install the `node exporter` for more visability.

```zsh
$ bash < <(curl -s https://raw.githubusercontent.com/Clivern/Mandrill/main/deployment/ubuntu/node_exporter.sh)
```


### Versioning

For transparency into our release cycle and in striving to maintain backward compatibility, Mandrill is maintained under the [Semantic Versioning guidelines](https://semver.org/) and release process is predictable and business-friendly.

See the [Releases section of our GitHub project](https://github.com/Clivern/Mandrill/releases) for changelogs for each release version of Mandrill. It contains summaries of the most noteworthy changes made in each release. Also see the [Milestones section](https://github.com/Clivern/Mandrill/milestones) for the future roadmap.


### Bug tracker

If you have any suggestions, bug reports, or annoyances please report them to our issue tracker at https://github.com/Clivern/Mandrill/issues


### Security Issues

If you discover a security vulnerability within Mandrill, please send an email to [hello@clivern.com](mailto:hello@clivern.com)


### Contributing

We are an open source, community-driven project so please feel free to join us. see the [contributing guidelines](CONTRIBUTING.md) for more details.


### License

© 2023, Clivern. Released under [MIT License](https://opensource.org/licenses/mit-license.php).

**Mandrill** is authored and maintained by [@clivern](http://github.com/clivern).
