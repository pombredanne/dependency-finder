/*
 *  Dependency Finder - Computes quality factors from compiled Java code
 *  Copyright (C) 2001  Jean Tessier
 * 
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 * 
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 * 
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

package com.jeantessier.metrics;

import java.util.*;

import org.apache.log4j.*;

public class Metrics {
	public static final String GROUPS   = "groups";
	public static final String PACKAGES = "packages";
	
	public static final String CLASSES            = "classes";
	public static final String PUBLIC_CLASSES     = "public classes";
	public static final String FINAL_CLASSES      = "final classes";
	public static final String ABSTRACT_CLASSES   = "abstract classes";
	public static final String SYNTHETIC_CLASSES  = "synthetic classes";
	public static final String INTERFACES         = "interfaces";
	public static final String DEPRECATED_CLASSES = "deprecated classes";
	public static final String STATIC_CLASSES     = "static classes";

	public static final String PUBLIC_CLASSES_RATIO     = "public classes ratio";
	public static final String FINAL_CLASSES_RATIO      = "final classes ratio";
	public static final String ABSTRACT_CLASSES_RATIO   = "abstract classes ratio";
	public static final String SYNTHETIC_CLASSES_RATIO  = "synthetic classes ratio";
	public static final String INTERFACES_RATIO         = "interfaces ratio";
	public static final String DEPRECATED_CLASSES_RATIO = "deprecated classes ratio";
	public static final String STATIC_CLASSES_RATIO     = "static classes ratio";

	public static final String METHODS              = "methods";
	public static final String PUBLIC_METHODS       = "public methods";
	public static final String PROTECTED_METHODS    = "protected methods";
	public static final String PRIVATE_METHODS      = "private methods";
	public static final String PACKAGE_METHODS      = "package methods";
	public static final String FINAL_METHODS        = "final methods";
	public static final String ABSTRACT_METHODS     = "abstract methods";
	public static final String DEPRECATED_METHODS   = "deprecated methods";
	public static final String SYNTHETIC_METHODS    = "synthetic methods";
	public static final String STATIC_METHODS       = "static methods";
	public static final String SYNCHRONIZED_METHODS = "synchronized methods";
	public static final String NATIVE_METHODS       = "native methods";
	public static final String TRIVIAL_METHODS      = "trivial methods";

	public static final String PUBLIC_METHODS_RATIO       = "public methods ratio";
	public static final String PROTECTED_METHODS_RATIO    = "protected methods ratio";
	public static final String PRIVATE_METHODS_RATIO      = "private methods ratio";
	public static final String PACKAGE_METHODS_RATIO      = "package methods ratio";
	public static final String FINAL_METHODS_RATIO        = "final methods ratio";
	public static final String ABSTRACT_METHODS_RATIO     = "abstract methods ratio";
	public static final String DEPRECATED_METHODS_RATIO   = "deprecated methods ratio";
	public static final String SYNTHETIC_METHODS_RATIO    = "synthetic methods ratio";
	public static final String STATIC_METHODS_RATIO       = "static methods ratio";
	public static final String SYNCHRONIZED_METHODS_RATIO = "synchronized methods ratio";
	public static final String NATIVE_METHODS_RATIO       = "native methods ratio";
	public static final String TRIVIAL_METHODS_RATIO      = "trivial methods ratio";

	public static final String ATTRIBUTES            = "attributes";
	public static final String PUBLIC_ATTRIBUTES     = "public attributes";
	public static final String PROTECTED_ATTRIBUTES  = "protected attributes";
	public static final String PRIVATE_ATTRIBUTES    = "private attributes";
	public static final String PACKAGE_ATTRIBUTES    = "package attributes";
	public static final String FINAL_ATTRIBUTES      = "final attributes";
	public static final String DEPRECATED_ATTRIBUTES = "deprecated attributes";
	public static final String SYNTHETIC_ATTRIBUTES  = "synthetic attributes";
	public static final String STATIC_ATTRIBUTES     = "static attributes";
	public static final String TRANSIENT_ATTRIBUTES  = "transient attributes";
	public static final String VOLATILE_ATTRIBUTES   = "volatile attributes";

	public static final String PUBLIC_ATTRIBUTES_RATIO     = "public attributes ratio";
	public static final String PROTECTED_ATTRIBUTES_RATIO  = "protected attributes ratio";
	public static final String PRIVATE_ATTRIBUTES_RATIO    = "private attributes ratio";
	public static final String PACKAGE_ATTRIBUTES_RATIO    = "package attributes ratio";
	public static final String FINAL_ATTRIBUTES_RATIO      = "final attributes ratio";
	public static final String DEPRECATED_ATTRIBUTES_RATIO = "deprecated attributes ratio";
	public static final String SYNTHETIC_ATTRIBUTES_RATIO  = "synthetic attributes ratio";
	public static final String STATIC_ATTRIBUTES_RATIO     = "static attributes ratio";
	public static final String TRANSIENT_ATTRIBUTES_RATIO  = "transient attributes ratio";
	public static final String VOLATILE_ATTRIBUTES_RATIO   = "volatile attributes ratio";

	public static final String INNER_CLASSES           = "inner classes";
	public static final String PUBLIC_INNER_CLASSES    = "public inner classes";
	public static final String PROTECTED_INNER_CLASSES = "protected inner classes";
	public static final String PRIVATE_INNER_CLASSES   = "private inner classes";
	public static final String PACKAGE_INNER_CLASSES   = "package inner classes";
	public static final String ABSTRACT_INNER_CLASSES  = "abstract inner classes";
	public static final String FINAL_INNER_CLASSES     = "final inner classes";
	public static final String STATIC_INNER_CLASSES    = "static inner classes";

	public static final String INNER_CLASSES_RATIO           = "inner classes ratio";
	public static final String PUBLIC_INNER_CLASSES_RATIO    = "public inner classes ratio";
	public static final String PROTECTED_INNER_CLASSES_RATIO = "protected inner classes ratio";
	public static final String PRIVATE_INNER_CLASSES_RATIO   = "private inner classes ratio";
	public static final String PACKAGE_INNER_CLASSES_RATIO   = "package inner classes ratio";
	public static final String ABSTRACT_INNER_CLASSES_RATIO  = "abstract inner classes ratio";
	public static final String FINAL_INNER_CLASSES_RATIO     = "final inner classes ratio";
	public static final String STATIC_INNER_CLASSES_RATIO    = "static inner classes ratio";

	public static final String DEPTH_OF_INHERITANCE  = "depth of inheritance";
	public static final String SUBCLASSES            = "subclasses";

	public static final String NLOC            = "number of lines of code";
	public static final String PARAMETERS      = "parameters";
	public static final String LOCAL_VARIABLES = "local variables";

	public static final String INBOUND_DEPENDENCIES  = "inbound dependencies";
	public static final String OUTBOUND_DEPENDENCIES = "outbound dependencies";
	
	private Metrics parent;
	private String  name;

	private Map measurements = new TreeMap();
	private Map submetrics   = new TreeMap();

	public Metrics(String name) {
		this(null, name);
	}
	
	/**
	 *  @param name The name of the element being measured
	 *              (e.g., class name, method name).
	 */
	public Metrics(Metrics parent, String name) {
		this.parent = parent;
		this.name   = name;

		if (parent == null) {
			Category.getInstance(getClass().getName()).debug("Created top-level metrics \"" + name + "\"");
		} else {
			Category.getInstance(getClass().getName()).debug("Created metrics \"" + name + "\" under \"" + parent.Name() + "\"");
		}
	}

	public Metrics Parent() {
		return parent;
	}

	/**
	 *  @return The name of the element being measured
	 *          (e.g., class name, method name).
	 */
	public String Name() {
		return name;
	}

	void TrackMetric(String metric_name) {
		TrackMetric(new CounterMeasurement(metric_name));
	}

	void TrackMetric(String metric_name, double starting_value) {
		TrackMetric(new CounterMeasurement(metric_name, starting_value));
	}

	void TrackMetric(String metric_name, Number starting_value) {
		TrackMetric(new CounterMeasurement(metric_name, starting_value));
	}

	void TrackMetric(Measurement measurement) {
		measurements.put(measurement.Name(), measurement);
	}

	public void AddToMetric(String metric_name) {
		AddToMetric(metric_name, 1.0);
	}
	
	public void AddToMetric(String metric_name, double delta) {
		AddToMetric(metric_name, new Double(delta));
	}
	
	public void AddToMetric(String metric_name, Object delta) {
		Measurement measure = Metric(metric_name);
		
		if (measure != null) {
			measure.Add(delta);
		}
	}
		
	public Measurement Metric(String metric_name) {
		return (Measurement) measurements.get(metric_name);
	}

	public Collection MetricNames() {
		return Collections.unmodifiableCollection(measurements.keySet());
	}
	
	public Metrics AddSubMetrics(Metrics metrics) {
		return (Metrics) submetrics.put(metrics.Name(), metrics);
	}
	
	public Collection SubMetrics() {
		return Collections.unmodifiableCollection(submetrics.values());
	}
	
	public String toString() {
		StringBuffer result = new StringBuffer();

		result.append(getClass().getName()).append(" ").append(Name()).append(" with [");

		Iterator i = MetricNames().iterator();
		while(i.hasNext()) {
			String name = (String) i.next();
			Measurement measure = Metric(name);

			result.append("\"").append(name).append("\"(").append(measure.getClass().getName()).append(")");
			if (i.hasNext()) {
				result.append(", ");
			}
		}

		result.append("]");

		return result.toString();
	}
}
