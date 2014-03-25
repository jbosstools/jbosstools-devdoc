# Maintaining Target Platforms

## Target-platforms use local mirror of our dependency

In order to ensure we always have access to our dependencies, all of them are mirrored on download.jboss.org since external provider don't have some real lifecycle and sustainability for their sites.
This is usually done through an Ant file invoking [p2.mirror](http://wiki.eclipse.org/Equinox/p2/Ant_Tasks#Mirror_Task) task, and then the site gets pushed manually to download.jboss.org. Those Ant files to produce mirror are available in the [jbosstools-download.jboss.org repository](https://github.com/jbosstools/jbosstools-download.jboss.org/tree/master/jbosstools/updates/requirements)

So in order to add a new dependency to the target-platform definition, first make sure to mirror it on download.jboss.org.

## Publish...

Publishing has its own process. This process is implemented on Jenkins, but it could be achieved manually.

### ..."Multiple" Target-Definitions to Nexus

First run
```bash
cd jbosstools/unified
mvn deploy
```

then the _multiple_ target-definition will become an artifact on JBoss Tools Nexus repository. In case you're publishing a release, you'll need to go to Nexus and access the staging repository and promote it as a release.

### ..."Unified" site To download.jboss.org
From the build of the multiple target platform is deduced a unified p2 repository that contains all the content of the unified target (ie all the dependencies of JBoss Tools). This site can be found after a build of multiple target in the _multiple/target/multiple.target.repo_ folder.

Then the content of this site is pushed to download.jboss.org for consumption by component builds and end-users (in case of a release). Publishing is achieved by [this script](https://github.com/jbosstools/jbosstools-target-platforms/blob/master/publish.sh)
The generated unified site is generally published as a subfolder of http://download.jboss.org/jbosstools/targetplatforms/jbosstoolstarget/ .

### ..."unified" target-definition to Nexus

Once the site is ready and available, we can generate the "unified" target that will reference all the content of this site. This is simply achieved by a `mvn deploy`.

## Releasing process

Although we're free to work with SNAPSHOTs, it's necessary to communicate when we release a new Target-Platform and make it default. Having a target-platform released implies a few additional steps before and after publishing.

Here is the suggested process:

**Before** the release:

1. Build and publish a SNAPSHOT (can be done with jbosstoolstargetplatforms-matrix & jbosstools-centraltarget_master job on Jenkins)
2. Compare content of newer SNASPSHOT of target platform site with previous version, using [p2diff](https://github.com/irbull/p2diff). Keep track of the changes that were not announced earlier and send a mail with a summary of those changes. Such changes can be some refactorings inside features, that are not visible directly in the .target file.
3. Announce on mailing-list the "release candidate" -SNAPSHOT and ask them to test the SNAPSHOT as a "release candidate". This can be achieved by running builds with the following flag `-Dtpc.version=<snapshot-to-test>`
4. Change component CI jobs and parent pom for the work-in-progress branch to use this snapshot, setting `-DTARGET_PLATFORM_VERSION=<snapshot-to-test>` or `-DTARGET_PLATFORM_VERSION_MAXIMUM=<snapshot-to-test>` in Maven execution
5. Gather feedback
  * if something is wrong, fix it and restart from #0
6. After enough time, send mail to the mailing-list saying that we're in the process of releasing the new target-platform
7. Remove `-SNAPSHOT` from all target-platforms pom files.

    $ mvn -Dtycho.mode=maven versions:set

8. Commit it, tag it; push tag and commit to the right branch:

        $ git add pom.xml pom.xml */*/pom.xml
        $ git commit -m "Version 4.30.5.CR2"
        $ git tag 4.30.5.CR2
        $ git push origin 4.30.5.CR2
        $ git push origin HEAD:4.30.x

        (where 4.30.5.CR2 has to be replaced by the actual version, and 4.30.x with the actual branch)

9. Repeat the 2 previous steps for jbosstools-discovery component to update and tag its target-platform.
10. Update [jbosstoolstargetplatforms-matrix](https://jenkins.mw.lab.eng.bos.redhat.com/hudson/job/jbosstoolstargetplatforms-matrix/) job to build new SNAPSHOTless version (and therefore produce new update site folders) (eg., 4.30.4-SNAPSHOT -> 4.30.4)  (TODO: make this a parameter)
11. Run the CI jobs to publish new versions.
12. Verify everything is correct on staging repo, plus published JBT/JBDS target platform update sites on
download.jboss.org & www.qa
13. Go to [http://repository.jboss.org/nexus](Nexus) and promote the target-platforms as release. (See https://community.jboss.org/wiki/MavenDeployingARelease)

**After** the release:

14. Update affected jobs to point explicitly to the new target platform versions (ref: [JBIDE-13673](https://issues.jboss.org/browse/JBIDE-13673))
15. Update relevant SNAPSHOT of parent pom so this new target becomes a default where we want it to be default (most likely on next branch for milestone if already available)
16. If the target platform is to be used by a recently released development milestone or stable release, these composite site pointers need to be updated to point at this new released target platform. Example:
  * http://download.jboss.org/jbosstools/targetplatforms/jbosstools/luna/ composite*.xml files get updated to point to ../4.40.0.Beta1
  * http://download.jboss.org/jbosstools/targetplatforms/jbdevstudiotarget/luna/  (same thing)
  * http://download.jboss.org/jbosstools/targetplatforms/jbtcentraltarget/luna/  (same thing)
  * etc.
17. Bump target-platform version and add it a -SNAPSHOT to start working on future version.

        $ mvn -Dtycho.mode=maven versions:set -DnewVersion=x.y.z.qualifier-SNAPSHOT
        $ git add pom.xml */pom.xml */*/pom.xml
        $ git commit -m "Bump to x.y.z.qualifier-SNAPSHOT"
        $ git push origin <branch>

18. Update target-platform job on Jenkins to build the new SNAPSHOT (eg: 4.30.0.Alpha1 -> 4.30.0-Alpha2-SNAPSHOT)
19. Announce on jbosstools-dev@lists.jboss.org that the target-platform is released and how to get it from Git tag (for IDE usage) and how to use it at build-time (either by setting `-Dtpc.version=<released-version>` or by using the new SNAPSHOT of the parent pom which directly references it)

Template:


    JBoss Tools Target Platform 4.30.5.CR1 has been released.

    Changes
    =======

    * Kepler R (final Eclipse.org release of Kepler)

    Usage
    =====
    Beta1 is what JBoss Tools 4.1.0.CR1 will use.

    All jobs in jenkins for branch jbosstools-4.1.x have been updated to use TP 4.30.5.CR1.
    Parent pom 4.1.0.CR1 for branch jbosstools-4.1.x has been updated to use TP 4.30.5.CR1.

    All jobs in jenkins for *master* have been updated to use TP 4.30.5.CR2-SNAPSHOT.
    Parent pom 4.2.0.Alpha1-SNAPSHOT for *master* has been updated to use TP 4.30.5.CR2-SNAPSHOT.


    The following URLs have been modified to point to this new target platform:

    * http://download.jboss.org/jbosstools/targetplatforms/jbosstools/luna/
    * http://download.jboss.org/jbosstools/targetplatforms/jbdevstudio/luna/
    * http://download.jboss.org/jbosstools/targetplatforms/jbtcentraltarget/luna/

    Download
    ========

    Zip: http://download.jboss.org/jbosstools/targetplatforms/jbosstoolstarget/4.30.5.CR1/jbosstoolstarget-4.30.5.Beta1.zip
    p2 site: http://download.jboss.org/jbosstools/targetplatforms/jbosstoolstarget/4.30.5.CR1/REPO/
    Git tag: https://github.com/jbosstools/jbosstools-target-platforms/tree/4.30.6.CR1

    Testing/Development
    ===================

    
    This should be used by default if you're using the latest SNAPSHOT of parent pom on master, so a simple "mvn clean verify"     should be enough to build against this new target platform.
    You can try it out and use it directly like this:

        $ mvn clean verify -Dtpc.version=4.30.5.CR1

    For advanced usage and help (using in IDE, building a mirror locally, using a zip...), plese read https://github.com/jbosstools/jbosstools-devdoc/blob/master/building/target_platforms/target_platforms_for_consumers.md
    
    
    What's next?
    ============

    Branch 4.30.x for target platform has been prepared for potential upgrades, and it's version is now 4.30.5.CR2-SNAPSHOT.


