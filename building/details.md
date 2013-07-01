## Environment Setup
### Prerequisistes
Minimal confuguration
* Java 1.6 SDK
* Maven 3.0.3
* About 6 GB of free disk space if you want to run all integration tests for (JBoss AS, Seam and Web Services Tools) - requires VPN access
* Git client

### Maven and Java

Make sure your maven 3 is available by default and Java 1.6 is used. `mvn -version` should  print out something like

```
Apache Maven 3.0.3 (r1075438; 2011-02-28 12:31:09-0500)
Java version: 1.6.0_25, vendor: Sun Microsystems Inc.
Java home: /usr/java/jdk1.6.0_25/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "2.6.42.3-2.fc15.x86_64", arch: "amd64", family: "unix"
```
 
### Maven settings

Follow these instructions to add reference to JBoss Repositories into your settings.xml. You'll also probably need access to the SNAPSHOT repository. So here is what you should see in your `~/.m2/settings.xml`

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
   ....
    <profiles>
        ....
        <profile>
            <id>jboss-default</id>
            <repositories>
                <!-- To resolve parent artifact -->
                <repository>
                    <id>jboss-public-repository-group</id>
                    <name>JBoss Public Repository Group</name>
                    <url>http://repository.jboss.org/nexus/content/groups/public/</url>
                </repository>
                <repository>
                    <id>jboss-snapshots-repository</id>
                    <name>JBoss Snapshots Repository</name>
                    <url>https://repository.jboss.org/nexus/content/repositories/snapshots/</url>
                </repository>
            </repositories>

            <pluginRepositories>
                        <!-- To resolve parent artifact -->
                        <pluginRepository>
                                <id>jboss-public-repository-group</id>
                                <name>JBoss Public Repository Group</name>
                                <url>http://repository.jboss.org/nexus/content/groups/public/</url>
                        </pluginRepository>
                        <pluginRepository>
                                <id>jboss-snapshots-repository</id>
                                <name>JBoss Snapshots Repository</name>
                                <url>https://repository.jboss.org/nexus/content/repositories/snapshots/</url>
                        </pluginRepository>
                </pluginRepositories>
        </profile>
    </profiles>

    <activeProfiles>
        <activeProfile>jboss-default</activeProfile>
        ...
    </activeProfiles>
</settings>
```
 
### Maven & Java Memory Configuration

To configure the amount of memory used by Maven, you can define MVN_OPTS as follows, either in the mvn / mvn.bat script you use to run Maven, or set as global environment variables. Here's how to do so for Fedora, Ubuntu, Windows, OSX.

```bash
set MAVEN_OPTS=-Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m
```

## (Optional) Building Parent Pom & Target Platforms Locally

Or, "What if Maven can't find the upstream artifacts in Nexus?"

Sometimes, Maven can't find the upstream artifacts - parent pom, tycho plugins, minimum (Juno SR0) or maximum (Juno SR1 or later) target platforms. Or maybe you want to build them locally in order to see how Tycho builds them, or contribute a fix. To work around resolution problems, just build locally:

```bash
cd /tmp; git clone git clone git://github.com/jbosstools/jbosstools-maven-plugins.git
cd /tmp; git clone git clone git://github.com/jbosstools/jbosstools-build.git
cd jbosstools-maven-plugins/tycho-plugins; mvn install; cd -
cd jbosstools-build/parent;  mvn install; cd -
cd jbosstools-build/target-platforms; mvn install -Pjbosstools-minimum,jbosstools-maximum
```
 
## Verify or Install?

`mvn verify` will perform all build and test steps, but it won't install the bundles in your local repository. `mvn install` does install in you local repository. When an eclipse-plugin is installed in your repo, it is always used as default when resolving dependency. It is not possible to roll-back a local installation of a bundle, so in most cases, `mvn verify` is to be prefered to `mvn install`. However, if you want to build stuff sequentially through several maven invocations, and you want to resolve against just-built stuff, you'll need to use `mvn install`.

In this page, we'll encourage people to use `mvn verify` as much as possible to ensure isolation; but you can `mvn install` the same way if your use-case requires it.


### What if I've already built something locally, but I want to build against the server version instead of my local repo?

There are two approaches that work here:
1. override temporarily when building, using `-Dtycho.localArtifacts=ignore`
2. delete `~/.m2/repository/.meta/p2-local-metadata.properties`


## About Target Platform and related profiles

The target platform (TP) lists all dependencies (coming from Eclipse.or and other 3rd-party update sites) that are used by JBoss Tools. This target platform is materialized as an Eclipse p2 repository (formerly update-site) that is used during build to resolve dependencies. Target Platform is managed by JBoss Tools people, and only dependencies from this TP are allowed to be used in code.

If you need a new dependency in the TP, feel free to open a ticket to request it.

Here are several ways to build locally using this target platform. It's up to you to choose the one that match your needs:

### Using published Target Platform definition (Recommended & Default)

unified.target refers to the dependency as published in the Target Platform repository.

* Pros:
** No additional thing to do than invoking Maven
** Always up-to-date
* Cons: Speed - (to evaluate)

Consume it by adding `-Punified.target` to you Maven invocation command-line, or simply by not specifying any Target-platform related prfile because `-Punified.target` is default.

### Or, getting a local copy of the Target Platform

* Pros: Speed +++
* Cons: Step to be repeated whenever target platforms change

Download TP as a zip and install it by yourself: You can either download the TP as a zip and unpack it into some folder on your disk. Just remember to update your settings.xml file to point at the location where you unpacked it.
You can get it with a browser or a command line tool such as wget or curl at the following url:
TODO
and then unzip it :
```bash
unzip *.target.zip -d /path/to/jbosstools-build/target-platforms/jbosstools-JunoSR0c/multiple/target/multiple.target.repo/
```
or
```bash
unzip *.target.zip -d /path/to/jbosstools-build/target-platforms/jbosstools-JunoSR1a/multiple/target/multiple.target.repo/
```

OR, use Maven to build it: See Building Parent Pom & Target Platforms Locally


#### Use it as a Maven mirror

Once you get the target platform available locally, you can use it instead of the remote sites to save time. For this, we can simply use Tycho target-platform mirroring: http://wiki.eclipse.org/Tycho/Target_Platform/Authentication_and_Mirrors#Mirrors

As example, you can simply edit to your ~/.m2/settings.xml the definition of the repositories to mirror: (replace /home/hudson/static_build_env/jbds/.... by a path where your local repository actuaaly stands)

```xml
<settings>
     <mirrors>
<!-- IMPORTANT: Sites in target platforms: must not have trailing slash! -->
        <mirror>
            <id>jenkins.jbosstools-JunoSR0c</id>
            <mirrorOf>http://download.jboss.org/jbosstools/updates/juno/SR0c/REPO</mirrorOf>
            <url>file:///home/hudson/static_build_env/jbds/target-platform_4.0.juno.SR0c/e420-wtp340.target/</url>
            <layout>p2</layout>
            <mirrorOfLayouts>p2</mirrorOfLayouts>
        </mirror>
        <mirror>
            <id>jenkins.jbosstools-JunoSR1a</id>
            <mirrorOf>http://download.jboss.org/jbosstools/updates/juno/SR1a/REPO</mirrorOf>
            <url>file:///home/hudson/static_build_env/jbds/target-platform_4.0.juno.SR1a/e421-wtp341.target/</url>
            <layout>p2</layout>
            <mirrorOfLayouts>p2</mirrorOfLayouts>
        </mirror>
        <mirror>
            <id>jenkins.jbdevstudio-JunoSR0c</id>
            <mirrorOf>http://www.qa.jboss.com/binaries/RHDS/updates/jbds-target-platform_4.0.juno.SR0c/REPO</mirrorOf>
            <url>file:///home/hudson/static_build_env/jbds/jbds-target-platform_4.0.juno.SR0c/jbds600-e420-wtp340.target/</url>
            <layout>p2</layout>
            <mirrorOfLayouts>p2</mirrorOfLayouts>
        </mirror>
        <mirror>
            <id>jenkins.jbdevstudio-JunoSR1a</id>
            <mirrorOf>http://www.qa.jboss.com/binaries/RHDS/updates/jbds-target-platform_4.0.juno.SR1a/REPO</mirrorOf>
            <url>file:///home/hudson/static_build_env/jbds/jbds-target-platform_4.0.juno.SR1a/jbds600-e421-wtp341.target/</url>
            <layout>p2</layout>
            <mirrorOfLayouts>p2</mirrorOfLayouts>
        </mirror>
    </mirrors>
</settings>
```
 

### (Optional) Build parent and target platform

This step is only useful if you are actually working on the parent or the target platforms and want to test local changes. Otherwise, Maven will simply retrieve parent and TP definitions from JBoss Nexus to perform your build.

See Building Parent Pom & Target Platforms Locally

 
## Building Individual Components Locally Via Commandline

### Build a component resolving to a recent aggregation build for other JBT dependencies (Recommanded)

* Pros:
** You build only your component
** You only need source for your component
** Speed to resolve deps: +
** You get generally the latest build for you component
* Cons
** Takes some time to resolve dependencies on other component Can sometimes be out of sync if no build occured recently for a component you rely on and had some important change. More risk to get out of sync than with the staging site. Tracked by https://issues.jboss.org/browse/JBIDE-11516

example:
```bash
cd jbosstools-server
mvn verify -P unified.target -Pjbosstools-staging-aggregate
```

### Build a component resolving to the latest CI builds for other JBT dependencies

* Pros:
** You build only your component
** You only need source for your component
** You get generally the latest build for you component
* Cons
** Takes some time to resolve dependencies on other component
** Can sometimes be out of sync if no build occured recently for a component you rely on and had some important change
** Speed to resolve deps: -

This profile is the one use for CI builds on Hudson.

```bash
cd jbosstools-server
mvn verify -P unified.target -Pjbosstools-nightly-staging-composite
```

## Fix build issues

### Installation Testing - making sure your stuff can be installed

Each component, when built, produces a update site zip and an unpacked update site which can be used to install your freshly-built features and plugins into a running Eclipse or JBDS instance.

Simply point your Eclipse at that folder or zip, eg., jar:file:/home/rob/code/jbtools/jbosstools-server/site/target/server.site-*.zip! or file:///home/rob/code/jbtools/jbosstools-server/site/target/repository/, and browse the site. If your component requires other upstream components to install, eg., jbosstools-server depends on jbosstools-base, you will also need to provide a URL from which Eclipse can resolve these missing dependencies. In order of freshness, you can use:

* http://download.jboss.org/jbosstools/updates/nightly/core/trunk/ (Nightly Trunk Site - updated every few hours or at least daily - bleeding edge)
* http://download.jboss.org/jbosstools/builds/staging/_composite_/core/trunk/ (Composite Staging Site - updated every time a component respins - bleedinger edge)
* http://anonsvn.jboss.org/repos/jbosstools/trunk/build/aggregate/local-site/ (see the README.txt for how to use this site to refer to things you built locally - bleedingest edge)
 
### Adding a new feature or plugin to an existing component

Need to tweak a component to add a new plugin or feature? See https://community.jboss.org/wiki/AddingAPluginandorFeatureToAnExistingComponent.

### Dealing with timeouts for tests

(To be rewritten soon...) http://lists.jboss.org/pipermail/jbosstools-dev/2012-September/005835.html

### Check your build.properties

Check `build.properties` in your plugin. If it has warnings in Eclipse, you'll most likely end with tycho failing to compile your sources. You'll have to make sure that you correct all warnings.

Especially check your build.properties to have entries for source.. and output.. -- these are needed to generate source plugins and features.

```
source.. = src/ 
output.. = bin/ 
src.includes = *
src.excludes = src
bin.includes = <your own,\
    list of,\
    files for inclusion,\
    in the jar>
```
 
### Check your manifest.mf dependencies

A new issue when building against juno shows that all compilation dependencies MUST be EXPLICITLY mentioned in your manifest.mf list of dependencies. A recent example of how this can cause compilation errors is the archives module, which failed to build due to the org.eclipse.ui.views plugin, and its IPropertySheetPage interface, not being found during the build. After investigation, it was discovered that the archives.ui plugin did not explicitly declare a dependency on org.eclipse.ui.views.

Inside eclipse and during Juno-based builds, however, the depencency was found and there were no compilation errors. This was because a plugin archives.ui explicitly dependend on (org.eclipse.ui.ide) had an explicit dependency on org.eclipse.ui.views.  The IDE was able to see that archives.ui dependended on org.eclipse.ui.ide, and org.eclipse.ui.ide depended on org.eclipse.ui.views. 

Resolving nested dependencies no longer seems to be guaranteed, and so anything you have a compilation dependency on must now be explicitly declared in your manifest.mf 