###  Building Locally In Eclipse

First, you must have installed m2eclipse into your Eclipse (or JBDS). You can install the currently supported version from this update site: http://download.jboss.org/jbosstools/updates/juno/

Next, start up Eclipse or JBDS and do First, you must have installed m2eclipse into your Eclipse (or JBDS). You can install the currently supported version from this update site: http://download.jboss.org/jbosstools/updates/juno/

Next, start up Eclipse or JBDS and do _File > Import_ to import the project(s) you already checked out from SVN above into your workspace.

<a href="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot.png"><img src="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot.png" alt="screenshot"/></a>
 
Browse to where you have the project(s) checked out, and select a folder to import pom projects. In this case, I'm importing the parent pom (which refers to the target platform pom). Optionally, you can add these new projects to a working set to collect them in your Package Explorer view.

<a href="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-1.png"><img src="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-1.png" alt="screenshot"/></a>

Once the project(s) are imported, you'll want to build them. You can either do `CTRL-SHIFT-X,M` (Run Maven Build), or right-click the project and select Run As > Maven Build. The following screenshots show how to configure a build job.

First, on the Main tab, set a Name, Goals, Profile(s), and add a Parameter. Or, if you prefer, put everything in the Goals field for simplicity: `clean install -B -fae -e`

 Be sure to check Resolve Workspace artifacts, and, if you have a newer version of Maven installed, point your build at that Maven Runtime instead of the bundled one that ships with m2eclipse.

<a href="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-2.png"><img src="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-2.png" alt="screenshot"/></a>

On the JRE tab, make sure you're using a 6.0 JDK.

<a href="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-3.png"><img src="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-3.png" alt="screenshot"/></a>

On the Refresh tab, define which workspace resources you want to refresh when the build's done.

<a href="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-4.png"><img src="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-4.png" alt="screenshot"/></a>

On the _Common_ tab, you can store the output of the build in a log file in case it's particularly long and you need to refer back to it.

<a href="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-5.png"><img src="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-5.png" alt="screenshot"/></a>

Click _Run_ to run the build.

<a href="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-6.png"><img src="https://raw.github.com/jbosstools/jbosstools-devdoc/master/building/images/screenshot-6.png" alt="screenshot"/></a>

Now you can repeat the above step to build any other component or plugin or feature or update site from the JBoss Tools repo. Simply import the project(s) and build them as above._File > Import_ to import the project(s) you already checked out from SVN above into your workspace.
