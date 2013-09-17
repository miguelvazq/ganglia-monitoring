<?php

/* Pass in by reference! */
function graph_roxie_instances_report ( &$rrdtool_graph ) {

    global $context,
           $cpu_num_color,
           $cpu_user_color,
           $hostname,
           $load_one_color,
           $num_nodes_color,
           $proc_run_color,
           $range,
           $rrd_dir,
           $size,
           $strip_domainname,
           $value,
      	   $mem_used_color;

    if ($strip_domainname) {
       $hostname = strip_domainname($hostname);
    }

    $rrdtool_graph['height'] += ($size == 'medium') ? 28 : 0;
    $title = 'Roxie Instances';
    if ($context != 'host') {
       $rrdtool_graph['title'] = $title;
    } else {
       $rrdtool_graph['title'] = "$hostname $title last $range";
    }
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['vertical-label'] = 'Instances';
    $rrdtool_graph['extras']         = '--rigid';

    $series = "DEF:'roxie_instances'='${rrd_dir}/roxie_instances.rrd':'sum':AVERAGE "."LINE2:'roxie_instances'#$mem_used_color:'roxie instances (now $value)'";

    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;

}

?>
