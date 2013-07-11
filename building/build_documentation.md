## How to Build JBoss Tools 4.x Documentation

### Building Everything

You can now build the whole suite of <a href="http://docs.jboss.org/tools/nightly/trunk/">docs available here</a> from the <a href="http://hudson.jboss.org/hudson/job/jbosstools-docs-nightly/">Jenkins job here</a>.

To build locally, <a href="https://github.com/jbosstools/jbosstools-documentation">clone this project</a> into the same place you have all of the jbosstools-* github repos checked out.

	git clone git@github.com:jbosstools/jbosstools-documentation.git
	cd jbosstools-documentation/jboss-tools-docs; mvn -s settings.xml -f pom.xml clean assembly:assembly

## Building a single component's documentation

After cloning the above project, you can selectively build a single component's doc by commenting out the modules you don't want to build in <a href="https://github.com/jbosstools/jbosstools-documentation/blob/master/jboss-tools-docs/pom.xml">this pom</a>, then rerunning the step above.

In future we may find a way to run individual doc builds w/o the need for all-guides.xml and the additional Maven <build> plugin configuration.

