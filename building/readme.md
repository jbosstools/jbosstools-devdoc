The JBoss Tools Build repository mainly contains the _parent pom_ for JBoss Tools component builds, which configures a lot of properties and Mojos to provide an easy to use and powerful build to all JBoss Tools components.

This documentation contains some Instructions, **Tips & Tricks to build JBoss Tools** components and Aggregate sites.

## Short way

`mvn clean verify` in your component folders.
This will gets  the dependencies from the latest aggregate snapshots from continuous integration on jboss.org.

## Tell me more

* [FAQ](faq.md)
* [Detailed documentation](details.md)
* [Build options](build_options.md)
* [Build from inside Eclipse](build_from_eclipse.md)
