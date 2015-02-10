# How to use Target Platforms

These target-platforms define the set of external dependencies we use in order to write and build JBoss Tools. Those dependencies can come from Eclipse.org, Atlassian, Google Web Toolkit...

Target-platforms are meant to be used in IDE to provide the right set of dependencies to developers, and at build-time to provide the right set of dependency to the build, and at install-time to provide a site containing all dependencies to end-users.

See these slides for generalities about target-platforms: http://www.slideshare.net/mickaelistria/a-journey-with-target-platforms.

## Multiple vs Unified

The **multiple** target-platform references multiple sites and it the one we maintain. It's the one to use in Eclipse IDE, since it includes sources (when available). It's available in _<jbosstools|jbdevstudio>/multiple_ folder.

From this target-platform is deduced the **unified** target-platform which uses an aggregation of all those sites. The unified target-platform and site are used at build-time to save time while resolving dependencies, and also at install-time to ensure we provide to end-users all the dependencies he'll need in case he doesn't already have them.

## Versions meaning

Here is the versioning patterns for target-platforms. Assuming we are targeting Eclipse x.y.z, target platform versions are of the form x.yz.MILESTONE(-SNAPSHOT). MILESTONE is a symbol that can be Alpha1, Alpha2, Beta1, CR1, or Final.
When you see a target-platform with version x.yz.MILESTONE it means that it is the MILESTONE or the target-platform targeting Eclipse x.y.z.
The `-SNAPHSOT` suffix means that the target-platform is still on development and may have some errors. Using `-SNAPSHOT` of target-platforms is forbidden for JBoss Tools milestone and release builds.

## Using a target platform

### Choosing the appropriate target-platform.

Depending on the version of JBoss Tools you are targetting, you can use one target-platform or another. Each branch is a "stream" of target platforms. Some tags are available for released versions.
**You should only use released version**, except if you are willing to hack the target-platform.

### Load in IDE

Checkout the branch of that tag of the target platform. As an example, if you want to access the target-platforms target Eclipse 4.<em>3</em>.<b>0</b>, you'll be interested in checking out branch 4.<em>3</em><b>0</b>.x
```bash
git clone git@github.com:jbosstools/jbosstools-target-platforms.git
cd jbosstools-target-platforms
git checkout 4.30.x
```

Then import the `jbosstools/multiple` project into Eclipse. When done, go to _Preference/Plug-in Development/Target Platforms_, select the recent _multiple.target_ and click _Apply_ (or _Reload_ in case of updates only). **Beware**, this is a long operation (can take between a few minutes and 1 hour depending on your connection) blocking your IDE.

### In Maven build

JBoss Tools component Maven builds are configured to consume the right target platform from Nexus. But you can override the version to use by specifying `-Dtpc.version=4.30.5` to the build command; then Maven will use the specified version of the target platform and will use it to resolve dependencies

## Building target platforms locally

### Why not?

Just for building the plugins, it's better to directly consume the target platform definition files as explained earlier, but if you want the source for the plugins you currently need to build the target platforms locally to get the sources.
In case you'll only need this target-platform in a single Eclipse workspace, this approach is overhead. Instead, just enable the multiple.target in your Eclipse using PDE (takes ~1 hours).

### Why?

Building target-platforms locally is a way to save some time. It's mainly useful when you plan to use the same target-platform on multiple Eclipse workspaces, as it allows to resolve the target-platform only once instead of once per workspace.

### How?

#### From IDE

Open the `.target` file with the Target Definition editor. On the top-right corner, you'll see an `Export` button. Click it and select a destination directory.

Using this mechanism seems to also mirror sources, so it's convenient for development as well.

#### From command-line

```bash
git clone git@github.com:jbosstools/jbosstools-target-platforms.git
cd jbosstools-target-platforms
git checkout 4.30.x
mvn clean install -Pmultiple2repo
```

This will also generate you the `unified.target` which is a target-platform mggregating multiple components in a single site. That is the one we use in Maven builds just in order to improve performances, but it's not the one developers/adopters who need a TP to write code against will want, since *it doesn't have references to source bundles*. **Beware**, this takes about ~1h to proceed mvn execution.

If you need a repository containing both your bundles from target-platform and the sources, you can use `mvn install -Dmirror-target-to-repo.includeSources=true`. The output repo will be in _jbosstools/unified/target/multiple.target.repo_ . Then you can use it in your IDE as a local repository or Eclipse installation.
