## Maven options
Exhaustive list is available here: http://www.sonatype.com/books/mvnref-book/reference/running-sect-options.html
Here are the one we often use for JBoss Tools build:
* `-fae` or `--fail-at-end`` continues the build until the end even when an error is detected. It allows for having more feedback at once: you get feedback for your whole build instead of only the parts that were built before the failure
* `-X` is the verbose/debug mode. Use it when something is not working as expected, it might tell you what's wrong.
* `-U` forces updates. Use it when Maven does not seem to resolve something that is available remotely.

## JBoss Tools profiles

Most user-oriented JBoss Tools profiles are meant to give you control on the dependency resolution.

### Target Platform

Some profiles and properties allow to control which versions of 3rd-party (Eclipse, GWT, Atlassian...) dependencies to use
* `-P minimum` (default) will use the minimum version of Eclipse and other dependency we want JBoss Tools to be compatible with
* `-P maximum` will use the highest version of dependency JBoss Tools must be compatible with. These versions will be the one provided along with JBoss Developer Studio RCP application.
* `-DTARGET_PLATFORM_VERSION=...` allows you to select a specific version for the target platform for this build. This can be used to test older targets than the minimal one, or some experimental target platfroms.

Sone profiles allows to select the place from where 3rd-party dependencies will be fetched
* `-P multiple.target` will use a target platform which references multiple sites for the multiple dependencies.
* `-P unified.target` (default) Will resolve all dependencies from a single site on download.jboss.org. This site does not contain sources and is aggregated from multiple other sites. Its performance are better than using _mulitple.target_.

You can disable target-platfroms (and then disable remote resolution of 3rd-party dependencies) with `-Dno-target-platform=true`

### internal dependencies

Some profiles allow to select which sources to use for internal dependencies (other JBoss Tools components)
* `-P jbosstools-nightly-staging-composite` will fetch dependencies from the multiple component sites produced by last CI builds for the current branch of JBoss Tools. It contains the very last changes availables.
* `-P jbosstools-staging-aggregate` will get dependencies from the latest aggregation of JBoss Tools. Its performances are better, but it may miss some recent versions of dependencies.
* `-Dno-jbosstools-site=true` disables those sites, so dependencies need to be provided from somewhere else (local repo, other site...)

## Mojo optons

Each mojo can have some options. You can list them with `mvn help:describe groupId:artifactId:version:mojo`. This will give details about the mojo, and you'll notice the _expression_ on some paramters. _expression_ tells you the system property that can be used to set the value.
If the mojo parameter was configured directly in pom.xml, then setting the _expression_ for this parameter will be ignore.

Here is the most useful mojo list
### Surefire
* `-Dmaven.test.skip=true` disable compilation and execution of test bundles
* `-DskipTests=true` diable test execution (not compilation)
* `-Dmaven.test.failure.ignore=true` and `-Dmaven.test.error.ignore=true` will not take into account test results the test results to decide whether build is successful or not. It can be used on Continuous Integration to let Jenkins decide on the result of the build: BLUE (everything OK), RED (Build Failed), YELLOW (some tests failed)
* `-XdebugPort=8000` will enable debugging during test activation on port 8000. Then you can use Eclipse Remote Java debugging to debug your tests while they're run from surefire

### Tycho
* `-Dtycho.localArtifacts=ignore` will prevent Tycho from reusing bundle artifacts built and installed locally. It ensures you'll use dependencies from upstreem sites to build your component