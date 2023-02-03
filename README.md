<p align="center">
    <img alt="Scuti Logo" src="/assets/img/logo.png?v=0.5.11" width="150" />
    <h3 align="center">Scuti</h3>
    <p align="center">A Lightweight and Reliable Automated Patching System, Set up in Minutes.</p>
    <p align="center">
        <a href="https://github.com/Clivern/Scuti/actions/workflows/agent_ci.yml">
            <img src="https://github.com/Clivern/Scuti/actions/workflows/agent_ci.yml/badge.svg"/>
        </a>
        <a href="https://github.com/Clivern/Scuti/actions/workflows/server_ci.yml">
            <img src="https://github.com/Clivern/Scuti/actions/workflows/server_ci.yml/badge.svg"/>
        </a>
        <a href="https://github.com/Clivern/Scuti/releases">
            <img src="https://img.shields.io/badge/Version-0.5.11-1abc9c.svg">
        </a>
        <a href="https://github.com/Clivern/Scuti/blob/master/LICENSE">
            <img src="https://img.shields.io/badge/LICENSE-MIT-orange.svg">
        </a>
    </p>
</p>

`Scuti` automates the patching process for a group of virtual servers, handling updates ranging from basic operating system upgrades to customized scripts. The system offers various strategies for updating servers, including sequential updates, batch updates, or percentage-based updates to ensure optimal availability.

`Scuti` named after `UY Scuti`, The red supergiant star in the constellation Scutum. It is considered to be possibly one of the largest known stars and is also a pulsating variable star, with a volume nearly 5 billion times that of the sun.


#### Development

To run `postgresql` with `docker` or `podman` for development

```zsh
$ docker run -itd \
    -e POSTGRES_USER=scuti \
    -e POSTGRES_PASSWORD=scuti \
    -e POSTGRES_DB=scuti_dev \
    -p 5432:5432 \
    --name postgresql \
    postgres:15.2
```

```zsh
$ podman run -itd \
    -e POSTGRES_USER=scuti \
    -e POSTGRES_PASSWORD=scuti \
    -e POSTGRES_DB=scuti_dev \
    -p 5432:5432 \
    --name postgresql \
    postgres:15.2
```

```zsh
# https://github.com/dbcli/pgcli
$ psql -h 127.0.0.1 -U scuti -d scuti_dev -W
```


#### Deployment

To deploy with `docker-compose` after updating `docker-compose.yml` environmental variables.

```zsh
$ docker-compose up -d
```


#### Versioning

For transparency into our release cycle and in striving to maintain backward compatibility, `Scuti` is maintained under the [Semantic Versioning guidelines](https://semver.org/) and release process is predictable and business-friendly.

See the [Releases section of our GitHub project](https://github.com/clivern/scuti/releases) for changelogs for each release version of `Scuti`. It contains summaries of the most noteworthy changes made in each release. Also see the [Milestones section](https://github.com/clivern/scuti/milestones) for the future roadmap.


#### Bug tracker

If you have any suggestions, bug reports, or annoyances please report them to our issue tracker at https://github.com/clivern/scuti/issues


#### Security Issues

If you discover a security vulnerability within `Scuti`, please send an email to [hello@clivern.com](mailto:hello@clivern.com)


#### Contributing

We are an open source, community-driven project so please feel free to join us. see the [contributing guidelines](CONTRIBUTING.md) for more details.


#### License

© 2022, Clivern. Released under [MIT License](https://opensource.org/licenses/mit-license.php).

**Scuti** is authored and maintained by [@clivern](http://github.com/clivern).
