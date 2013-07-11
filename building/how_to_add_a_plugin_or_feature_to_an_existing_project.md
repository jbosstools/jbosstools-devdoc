## How To Add A New Plugin Or Feature To An Existing JBoss Tools 4.x Project

### IMPORTANT PREREQUISITES

1. First, read these documents to learn how to build JBoss Tools project(s) locally: 

https://github.com/jbosstools/jbosstools-devdoc/blob/master/building/faq.md
https://github.com/jbosstools/jbosstools-devdoc/blob/master/building/how_to_build_jbosstools_4.adoc

2. Before adding a complete new feature to JBoss Tools announce the addition on jbosstools-dev <a href="mailto:jbosstools-dev@lists.jboss.org">jbosstools-dev@lists.jboss.org</a> with reasons WHY a new feature is needed and what new (if any) dependencies it will bring in. New dependencies need to be added to the target platforms, and thus should be reported in JIRA for tracking and task assignment purposes.

3. Note too that new features will often start in JBoss Tools but *NOT* be included in JBoss Developer Studio until they have had time to mature. 

4. If your new feature needs to be in *BOTH* offerings, please be sure to explain WHY when contacting the above mailing list.


### Add a new plugin or feature to JBoss Tools

Now that you can build the project, you can easily add a new plugin to that project. Here's how.

0. Make sure your new plugin compiles in your workspace. Ensure your MANIFEST.MF contains all references/includes/requirements you need. Be sure to set the correct Bundle-RequireExecutionEnvironment (eg., JDK5 or JDK6).

1. When you are satisfied, you can commit your new plugin project to Git.

	    cd ~/git/jbosstools-server/as/plugins; \
	    git add org.jboss.ide.eclipse.as.rse.core; \
	    git commit -m "JBIDE-123456 Initial commit of new as.rse.core plugin"

2. Next, add a pom.xml file to the root of your new project.

You can use m2eclipse to help w/ this if you have it installed; otherwise copy from another existing plugin project and edit appropriately. The version of the pom should match the version in the manifest.mf. Note that 3.2.0.qualifier (in MANIFEST.MF) is equivalent to 3.2.0-SNAPSHOT in the pom.xml.

3. Build your plugin:

	    cd ~/git/jbosstools-server/as/plugins/org.jboss.ide.eclipse.as.rse.core; \
	    mvn clean verify

4. If your project's new plugin builds successfully, you can commit the pom.xml file, and add a reference to the new plugin (module) in the container pom:

	    cd ~/git/jbosstools-server/as/plugins; \ 
	    git add pom.xml

5. To ensure that your plugin is available on the update site, be sure that it is contained in at least one feature's feature.xml.

	    cd ~/git/jbosstools-server/as/features; \
	    vim org.jboss.ide.eclipse.as.feature/feature.xml

6. If necessary, create a new feature to contain the new plugin - easiest approach is to copy an existing feature project, and string-replace the various files until it suits your needs. Don't forget to update .project and other hidden files.

	    git add org.jboss.ide.eclipse.as.new.feature
	    git ci -m "JBIDE-123456 Initial commit of new as.new feature" org.jboss.ide.eclipse.as.new.feature

7. If your project's new feature builds successfully, you can commit the pom.xml file, and add a reference to the new plugin (module) in the container pom:

	    cd ~/git/jbosstools-server/as/features; \
	    vim /features/pom.xml


#### Verify your new feature/plugin can be built and installed:

8. Next, ensure that the feature appears in all appropriate JBoss Tools update sites:

	    vi ~/git/jbosstools-server/site/category.xml # (the project's update site)

and one of the following:

	    vi ~/jbosstools-build-sites/aggregate/site/category.xml # (the JBoss Tools aggregate update site)

	    vi ~/jbosstools-build-sites/aggregate/coretests-site/category.xml # (the JBoss Tools aggregate update site for test plugins)

or one of these two sites:

	    vi ~/jbosstools-build-sites/aggregate/soa-site/category.xml # (the JBoss Tools aggregate update site for SOA Tooling)

	    vi ~/jbosstools-build-sites/aggregate/soatests-site/category.xml # (the JBoss Tools aggregate update site for SOA Tooling test plugins)

Note: for jbosstools-server, and any DEPENDENCIES of jbosstools-server, you MAY want to add your new feature to this site too, if and only if AS Tools makes use of that plugin / feature:

	    vi ~/jbosstools-build-sites/aggregate/webtools-site/category.xml # (the JBoss Tools aggregate update site for WTP adapters)

9. Finally, build the sites locally to ensure the XML is valid and the contents appear correctly. You can then install the new feature from the sites into Eclipse or JBDS to verify it runs as expected (no missing dependencies which prevent the plugin from being activated, no missing metadata such as description, provider, license or copyright while installing, etc.)

	    cd ~/git/jbosstools-server/; mvn clean verify; # then point Eclipse at ~/git/jbosstools-server/site/target/repository/
	      and
	    cd ~/git/jbosstools-build-site/aggregate/site; mvn clean verify; # then point Eclipse at ~/git/jbosstools-build-site/aggregate/site/target/site/


### Add a new plugin or feature to JBoss Developer Studio

10. Next, ensure that the feature appears in all appropriate JBoss Developer Studio update site:

	    vi ~/git/jbdevstudio-product/site/category.xml # (the JBoss Developer Studio aggregate update site)

11. If you added a new feature, be sure that the feature is included in the JBDS feature (or wrapped inside another feature) so that it will appear in the installer.

	    vi ~/git/jbdevstudio-product/features/com.jboss.jbds.product.feature/feature.xml


#### Verify your new feature/plugin can be built and installed:

12. Finally, build the sites locally to ensure the XML is valid and the contents appear correctly. You can then install the new feature from the sites into Eclipse or JBDS to verify it runs as expected (no missing dependencies which prevent the plugin from being activated, no missing metadata such as description, provider, license or copyright while installing, etc.)

	    cd ~/git/jbdevstudio-product; mvn clean verify 
	    # then point JBDS at ~/git/jbdevstudio-product/features/com.jboss.jbds/target/repository/ 
	    # (search for "Branded Product" feature, com.jboss.jbds.all)

Note: the product site in ~/git/jbdevstudio-product/site/target/site/ does not contain the "Branded Product" feature, com.jboss.jbds.all, so you cannot use that site to update an existing *JBDS install*, only an *Eclipse install*.