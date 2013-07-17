<h1>The JBoss Tools 4.x Development Environment</h1>

<p>This article explains the different steps to set up a 1st-class environment when you want to write code for JBoss Tools.</p>
<p> </p>
<h2>Tools and technologies</h2>
<h3>Java</h3>
<p>JBoss Tools requires Java 6. Ensure your JRE and JDK are compatible with Java 6.</p>
<p> </p>
<h3>Eclipse PDE/RCP</h3>
<p><span>JBoss Tools are a set of plugins for Eclipse. Then get your favourite recent version of Eclipse from here: </span><a href="http://eclipse.org/downloads/" target="_blank">http://eclipse.org/downloads/</a><span> We recommand you using </span><em>Eclipse for RCP and RAP Developers</em>. But you can also install PDE in any other installation of Eclipse:</p>
<p> </p>
<p><img alt="installPDE.png" src="images/installPDE.png" width="620" /></p>
<p> </p>
<h3>Git and EGit</h3>
<p>Install Git CLI, and install EGit in Eclipse (EGit is already provided in most Eclipse installations).</p>
<p> </p>
<h3>m2e</h3>
<p>m2e (maven integation for Eclipse) is also required. It's recommended that you also install <strong>m2e-tycho</strong> and <strong>m2e-EGit</strong> connector from <em>Preferences &gt; Maven &gt; Discovery &gt; Open Catalog</em>.</p>
<p><img alt="m2e-tycho.png" src="images/m2e-tycho.png" width="620" /></p>
<p> </p>
<h3>Tips for productivity and quality</h3>
<p>Here are some highly recommanded plugins that will make your more efficient when inside the IDE</p>
<p> </p>
<h4>Install Code Recommanders</h4>
<p>Provides additional snippets, templates and smart completion. Not intrusive. You can find it on the "Juno" update-site or the current Eclipse release site.</p>
<h4>Static analysis</h4>
<p>Static analysis will detect bug very early and will save you minutes of debug every day. Using it will make you and your colleagues happier. It tells you while typing code that you may have a bug. No need to wait for running test or CI reports to detect this.</p>
<h5>Enable all JDT warnings</h5>
<p>JDT provides very good static analysis, and can prevent you from writing bugs. You simply have to turn all "ignored" advices to "warning" in Window &gt; Preference &gt; Java &gt; Compiler &gt; Errors/Warning.</p>
<p> </p>
<p><img alt="jdtWarnings.png" src="images/jdtWarnings.png" width="620" /></p>
<h5>Install Findbugs for Eclipse</h5>
<p><a href="http://marketplace.eclipse.org/content/findbugs-eclipse-plugin" target="_blank">http://marketplace.eclipse.org/content/findbugs-eclipse-plugin</a></p>
<h5>Install PMD for Eclipse</h5>
<p><a href="http://marketplace.eclipse.org/content/pmd-eclipse" target="_blank">http://marketplace.eclipse.org/content/pmd-eclipse</a></p>
<p> </p>
<h4>Coverage</h4>
<p>Coverage answers to the question "What is tested or net?".</p>
<p><span>JBoss Tools CI builds provide Jacoco reports for coverage by unit tests (file name is jacoco.exec). This file can easily be analyzed inside Eclipse on your Java editor using EclEmma plugin: </span><a href="http://marketplace.eclipse.org/content/eclemma-java-code-coverage" target="_blank">http://marketplace.eclipse.org/content/eclemma-java-code-coverage</a></p>
<p> </p>
<h2>Get source</h2>
<p><span>Each JBoss Tools component is now its own GitHub repo: </span><a href="https://github.com/jbosstools/" target="_blank">https://github.com/jbosstools/</a><span> </span></p>
<h3>To work on a specific component</h3>
<p>The easiest way to get started is to check out source for only the module you wish to work on, and import Java projects from this part of the source tree.</p>
<p>For example, if you want to fix a bug in the CDI component of the JavaEE project within JBoss Tools</span>: 
  <pre>git clone git://github.com/jbosstools/jbosstools-javaee.git
  </pre>
  Then import feature, plugin and test projects from cdi/features/, cdi/plugins/, and cdi/tests/
</p>
<p> </p>
<h2>Set up a target platform</h2>
<p> </p>
<p><span style="font-family: comic sans ms,sans-serif;"><strong>Target Platform = Allowed Dependencies </strong><span style="font-family: arial,helvetica,sans-serif;">We provide several TP that have different purpose. We do set up some default TP for development, that you should use. You should use those Target Platforms instead of installing the dependencies in your IDE. Then you IDE becomes "The tools you need to develop" whereas the Target Platform provides the dependencies.</span></span></p>
<p> </p>
<p><span>Import into your Eclipse workspace JBoss Tools target platforms from GitHub: </span></p>
<p><span style="font-family: courier new,courier;">git clone git://github.com/jbosstools/jbosstools-target-platforms.git</span></p>
<p><span style="font-family: arial,helvetica,sans-serif;">Then select the version you want for the target platform. Those versions are available as tags. You can see the list of tags with <span style="font-family: courier new,courier;">git tag -l.</span></span></p>
<p><span style="font-family: courier new,courier;"><span style="font-family: arial,helvetica,sans-serif;">Let's say for this example we want the latest target platform based on Eclipse 4.2.1 (Juno SR1).</span><br /></span></p>
<p><span style="font-family: courier new,courier;">cd jbosstools-target-platforms</span></p>
<p><span style="font-family: arial,helvetica,sans-serif;"><span style="font-family: courier new,courier;">git checkout 4.2.1</span><br /></span></p>
<p> </p>
<p>Then, in Eclipse, <em>Import &gt; Existing Maven Project</em>, browse to the <em>jbosstools-target-platfroms/jbosstools/multiple.</em></p>
<p>Double-click on <em>multiple.target</em>, and click<em> Set As Target Platform</em></p>
<p><em><img alt="setTp.png" src="images/setTp.png" width="620" /><br /></em></p>
<p> </p>
<h2>Run JBoss Tools and Tests from your IDE</h2>
<p>Once Target Platform is configured, you can easily give a try to your plugins using<em> Run As &gt; Java Application. </em>You can also run automated tests from your IDE using <em>Run As... &gt; JUnit Plugin Tests</em>.</p></body>