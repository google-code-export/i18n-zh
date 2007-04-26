Install required tools

You'll need the following JARs:

    * xercesImpl.jar
    * xml-commons-resolver-1.1.jar
    * jaxp-1.2.jar (sometimes named jaxp_transform_impl.jar xml-apis.jar xmlParserAPIs.jar ...)
    * saxon.jar
    * saxon65.jar
    * ant.jar
    * ant-launcher.jar
    * xalan25.jar
    * xalan-j2.jar
    * xml-commons-apis.jar 

Plus following tools:

    * make 

Configure the Building Environment

    * Add all above classes to your CLASSPATH environment variable
    * Set the DOCBOOK_SVN environment variable to the root of your build environment (aka /home/user/src/docbook/trunk/)
    * Copy the following into ~/.xmlc and adapt paths to your system 

<?xml version='1.0' encoding='utf-8'?> <!-- -*- nxml -*- -->
<config>
  <java classpath-separator=":" xml:id="java">
    <system-property name="javax.xml.parsers.DocumentBuilderFactory"
      value="org.apache.xerces.jaxp.DocumentBuilderFactoryImpl"/>
    <system-property name="javax.xml.parsers.SAXParserFactory"
      value="org.apache.xerces.jaxp.SAXParserFactoryImpl"/>
    <classpath path="/usr/share/java/xercesImpl.jar"/>
    <classpath path="/usr/share/java/jaxp-1.2.jar"/>
    <classpath path="/usr/share/java/xml-commons-resolver-1.1.jar"/>
  </java>

  <java xml:id="bigmem">
    <java-option name="Xmx512m"/>
  </java>

  <saxon xml:id="saxon" extends="java">
    <arg name="x" value="org.apache.xml.resolver.tools.ResolvingXMLReader"/>
    <arg name="y" value="org.apache.xml.resolver.tools.ResolvingXMLReader"/>
    <arg name="r" value="org.apache.xml.resolver.tools.CatalogResolver"/>
    <param name="use.extensions" value="1"/>
  </saxon>

  <saxon xml:id="saxon-6" extends="saxon" class="com.icl.saxon.StyleSheet">
    <classpath path="/usr/share/java/saxon.jar"/>
    <classpath path="/sandbox/docbook/trunk/xsl/extensions/saxon65.jar"/>
  </saxon>
</config>
