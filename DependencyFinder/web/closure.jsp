<%@ page import="java.util.*, com.jeantessier.dependency.*" %>
<html>

<head>
<title>Closure in <%= application.getInitParameter("name") %></title>
</head>

<!-- Reading the parameters and setting up the forms -->

<%
    String scope_includes = request.getParameter("scope-includes");
    if (scope_includes == null) {
	scope_includes = "//";
    }

    String scope_excludes = request.getParameter("scope-excludes");
    if (scope_excludes == null) {
	scope_excludes = "";
    }

    boolean package_scope = "on".equals(request.getParameter("package-scope"));
    if (request.getParameter("submit") == null) {
	package_scope = true;
    }

    boolean class_scope = "on".equals(request.getParameter("class-scope"));
    if (request.getParameter("submit") == null) {
	class_scope = true;
    }

    boolean feature_scope = "on".equals(request.getParameter("feature-scope"));
    if (request.getParameter("submit") == null) {
	feature_scope = true;
    }

    String filter_includes = request.getParameter("filter-includes");
    if (filter_includes == null) {
	filter_includes = "//";
    }

    String filter_excludes = request.getParameter("filter-excludes");
    if (filter_excludes == null) {
	filter_excludes = "";
    }

    boolean package_filter = "on".equals(request.getParameter("package-filter"));
    if (request.getParameter("submit") == null) {
	package_filter = true;
    }

    boolean class_filter = "on".equals(request.getParameter("class-filter"));
    if (request.getParameter("submit") == null) {
	class_filter = true;
    }

    boolean feature_filter = "on".equals(request.getParameter("feature-filter"));
    if (request.getParameter("submit") == null) {
	feature_filter = true;
    }

    String maximum_inbound_depth = request.getParameter("maximum-inbound-depth");
    if (maximum_inbound_depth == null) {
	maximum_inbound_depth = "0";
    }

    String maximum_outbound_depth = request.getParameter("maximum-outbound-depth");
    if (maximum_outbound_depth == null) {
	maximum_outbound_depth = "";
    }
%>

<!-- midnight blue over blanched almond -->
<body text="191970" bgcolor="#ffebcd">

<form action="<%= request.getRequestURI() %>" method="post">

<table border="0" cellpadding="5"><tr><td colspan="2">

<div align="center">
<p><b>
<code><%= application.getInitParameter("name") %></code><br />
Transitive closure
</b></p>
</div>

</td></tr><tr><td colspan="2">

<table border="3" bgcolor="ccccff" cellpadding="4"><tr><td>

<table border="0">
    <tr>
	<td colspan="3">
	    <b>Start with programming elements</b>
	</td>
    </tr>
    <tr>
	<td align="center" colspan="2">
	    <input type="checkbox" name="package-scope" <%= package_scope ? "checked" : "" %> onFocus="window.status='Start with packages'" onBlur="window.status=''">&nbsp;package
	    <input type="checkbox" name="class-scope" <%= class_scope ? "checked" : "" %> onFocus="window.status='Start with classes (with their package)'" onBlur="window.status=''">&nbsp;class
	    <input type="checkbox" name="feature-scope" <%= feature_scope ? "checked" : "" %> onFocus="window.status='Start with methods and fields (with their class and package)'" onBlur="window.status=''">&nbsp;feature
	</td>
    </tr>
    <tr>
	<td>
	    including:
	</td>
	<td>
	    excluding:
	</td>
    </tr>
    <tr>
	<td>
	    <input type="text" name="scope-includes" value="<%= scope_includes %>" onFocus="window.status='Package, class, method, or field must match any these expressions. E.g., /^com.mycompany/, /\\.get\\w+\\(/'" onBlur="window.status=''">
	</td>
	<td>
	    <input type="text" name="scope-excludes" value="<%= scope_excludes %>" onFocus="window.status='Package, class, method, or field must NOT match any of these expressions. E.g., /Test/'" onBlur="window.status=''">
	</td>
    </tr>
</table>

</td><td>

<table border="0">
     <tr>
	<td colspan="3">
	    <b>Follow dependencies</b>
	</td>
    </tr>
    <tr>
	<td align="center" colspan="2">
	    <input type="checkbox" name="package-filter" <%= package_filter ? "checked" : "" %> onFocus="window.status='Follow dependencies to/from packages'" onBlur="window.status=''">&nbsp;package
	    <input type="checkbox" name="class-filter" <%= class_filter ? "checked" : "" %> onFocus="window.status='Follow dependencies to/from classes'" onBlur="window.status=''">&nbsp;class
	    <input type="checkbox" name="feature-filter" <%= feature_filter ? "checked" : "" %> onFocus="window.status='Follow dependencies to/from methods and fields'" onBlur="window.status=''">&nbsp;feature
	</td>
    </tr>
    <tr>
	<td>
	    including:
	</td>
	<td>
	    excluding:
	</td>
    </tr>
    <tr>
	<td>
	    <input type="text" name="filter-includes" value="<%= filter_includes %>" onFocus="window.status='Package, class, method, or field at the other end of the dependency must match any these expressions. E.g., /^com.mycompany/, /\\.get\\w+\\(/'" onBlur="window.status=''">
	</td>
	<td>
	    <input type="text" name="filter-excludes" value="<%= filter_excludes %>" onFocus="window.status='Package, class, method, or field at the other end of the dependency must NOT match any of these expressions. E.g., /Test/'" onBlur="window.status=''">
	</td>
    </tr>
</table>

</td></tr><tr><td colspan="2" align="center">

Follow inbounds:
<input type="text" name="maximum-inbound-depth" value="<%= maximum_inbound_depth %>" size="2" onFocus="window.status='Maximum hops against the direction dependencies.  Empty field means no limit.'" onBlur="window.status=''">
Follow outbounds:
<input type="text" name="maximum-outbound-depth" value="<%= maximum_outbound_depth %>" size="2" onFocus="window.status='Maximum hops in the direction of dependencies.  Empty field means no limit.'" onBlur="window.status=''">

</td></tr></table>

</td></tr><tr>

<td align="left"><font size="-1">Use Perl regular expressions, <a target="_blank" href="http://depfind.sourceforge.net/Manual.html">see the manual</a></font></td>
<td align="right"><a href="advancedclosure.jsp">advanced &gt;&gt;&gt;</a></td>

</td></tr><tr><td align="center" colspan="2">

<input type="submit" name="submit" value="Run Query"/>

</td></tr></table>

</form>

<hr size="3" />

<%
    if (request.getParameter("submit") != null) {
	if (application.getAttribute("factory") != null) {
	    Date start = new Date();

	    SelectiveTraversalStrategy strategy = new SelectiveTraversalStrategy();
		
	    strategy.PackageScope(package_scope);
	    strategy.ClassScope(class_scope);
	    strategy.FeatureScope(feature_scope);
	    strategy.ScopeIncludes(scope_includes);
	    strategy.ScopeExcludes(scope_excludes);
	
	    strategy.PackageFilter(package_filter);
	    strategy.ClassFilter(class_filter);
	    strategy.FeatureFilter(feature_filter);
	    strategy.FilterIncludes(filter_includes);
	    strategy.FilterExcludes(filter_excludes);

	    TransitiveClosure closure = new TransitiveClosure(strategy);

	    try {
		closure.MaximumInboundDepth(Long.parseLong(maximum_inbound_depth));
	    } catch (NumberFormatException ex) {
		closure.MaximumInboundDepth(TransitiveClosure.UNBOUNDED_DEPTH);
	    }

	    try {
		closure.MaximumOutboundDepth(Long.parseLong(maximum_outbound_depth));
	    } catch (NumberFormatException ex) {
		closure.MaximumOutboundDepth(TransitiveClosure.UNBOUNDED_DEPTH);
	    }

	    closure.TraverseNodes(((NodeFactory) application.getAttribute("factory")).Packages().values());

	    PrettyPrinter printer = new PrettyPrinter();

	    printer.TraverseNodes(closure.Factory().Packages().values());

	    Date stop = new Date();

	    out.println();
%>

<font color="black">
<pre><%= printer %></pre>
</font>

<p><%= (stop.getTime() - start.getTime()) / (double) 1000 %> secs.</p>

<%
	} else {
%>

<h3>No dependency graph available</h3>

<p>Please ask the webmaster to extract a dependency graph before you start placing queries.</p>

<%
	}
    }
%>

</body>

</html>
