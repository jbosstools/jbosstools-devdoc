# Debug issue on CI

## Useful debug files in Jenkins workspace

Jenkins exposes all build files as part of the job *workspace* (see Worspace menu on the lest of the job page). Assuming a test is failing in the *org.jboss.tools.acme.test* suite, here are a set of interesting locations in Jenkins workpsace to help debugging:
* _tests/org.jboss.tools.acme.test/target/work/configuration/config.ini_ contains the main configuration of the plugin. The most interesting part is the `osgi.bundles` property which lists all bundles that are installed in the application which runs test. It's the right place to check for a missing dependency
* _tests/org.jboss.tools.acme.test/target/work/data_ is the test workspace, where you can access create projects, and
* _tests/org.jboss.tools.acme.test/target/work/data/.metadata/.log_ contains the log of the test execution
* _tests/org.jboss.tools.acme.test/target/work/data/.metadata_ contains all other Eclipse runtime metadata (such as workbench state, preferences...)

## Useful input in log

Maven log shows a very interesting command-line while running surefire tests. It looks like:
```
[INFO] --- tycho-surefire-plugin:0.18.0:test (default-test) @ org.jboss.tools.runtime.seam.detector.test ---
[INFO] Expected eclipse log file: /mnt/hudson_workspace/workspace/jbosstools-javaee_41/sources/seam/tests/org.jboss.tools.runtime.seam.detector.test/target/work/data/.metadata/.log
[INFO] Command line:
 	/bin/sh -c cd /mnt/hudson_workspace/workspace/jbosstools-javaee_41/sources/seam/tests/org.jboss.tools.runtime.seam.detector.test && /qa/tools/opt/x86_64/jdk1.6.0_43/jre/bin/java -Dosgi.noShutdown=false -Dosgi.os=linux -Dosgi.ws=gtk -Dosgi.arch=x86_64 '-javaagent:/mnt/hudson_workspace/workspace/jbosstools-javaee_41/.repository/org/jacoco/org.jacoco.agent/0.6.1.201212231917/org.jacoco.agent-0.6.1.201212231917-runtime.jar=destfile=/mnt/hudson_workspace/workspace/jbosstools-javaee_41/sources/seam/target/jacoco.exec,append=true,includes=org.jboss.tools.*' -Xms512m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=256m -Djbosstools.test.jboss.home.4.2=/mnt/hudson_workspace/workspace/jbosstools-javaee_41/sources/seam/tests/org.jboss.tools.runtime.seam.detector.test/target/requirements/jboss-4.2.3.GA -Dorg.jboss.tools.tests.skipPrivateRequirements=false -Dusage_reporting_enabled=false -Dorg.jboss.tools.tests.skipPrivateRequirements=false -Dorg.eclipse.ui.testsDisableWorkbenchAutoSave=true -jar /mnt/hudson_workspace/workspace/jbosstools-javaee_41/.repository/p2/osgi/bundle/org.eclipse.equinox.launcher/1.3.0.v20130327-1440/org.eclipse.equinox.launcher-1.3.0.v20130327-1440.jar -data /mnt/hudson_workspace/workspace/jbosstools-javaee_41/sources/seam/tests/org.jboss.tools.runtime.seam.detector.test/target/work/data -install /mnt/hudson_workspace/workspace/jbosstools-javaee_41/sources/seam/tests/org.jboss.tools.runtime.seam.detector.test/target/work -configuration /mnt/hudson_workspace/workspace/jbosstools-javaee_41/sources/seam/tests/org.jboss.tools.runtime.seam.detector.test/target/work/configuration -application org.eclipse.tycho.surefire.osgibooter.uitest -testproperties /mnt/hudson_workspace/workspace/jbosstools-javaee_41/sources/seam/tests/org.jboss.tools.runtime.seam.detector.test/target/surefire.properties -testApplication org.eclipse.ui.ide.workbench -product org.jboss.tools.tests.product
```
This command-line is actually the actual command that is used to start your tests. You can copy and paste this command-line if you want to run those tests outside of Maven. You can also analyze it to find out whether some parameters could explain some differences between your expectation and the actual behavior.

## SSH to a slave

In case you need to access something on a Jenkins slave that you can't access through Jenkins, feel free to ask for other people in the team (Nick, Denis, Mickael) to get it for you. SSH access to Jenkins is restricted, but in case it appears that you need it regularly, we can negotiate to allow you to SSH to the jenkins slaves.

## Monitor remote test execution via VNC

As the CI jobs use Xvnc, it's easy to see them progressing (or stuck) using a vncviewer. However, this requires to be under Red Hat VPN.

How to see the job processing:

1. Go to the job build page, look at the top of the console, you'll get a host name (such as _vmg39.mw.lab.eng.bos.redhat.com_), and you'll see which DISPLAY was used to start Xvnc (such as _12_).
2. Ask someone who is a CI hacker (Nick, Denis, Mickael) for the VNC password or the vnc password file to use.
3. Assuming you get a VNC password file, you can watch CI running with `xvncviewer -passwd ~/.vnc/passwd_hudson host:port`. *port* is 5900 + DISPLAY. So in for the example, the command would be `vncviewer -passwd ~/.vnc/passwd_hudson vmg39.mw.lab.eng.bos.redhat.com:5912`.
