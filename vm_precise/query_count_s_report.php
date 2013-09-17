<?php

/* Pass in by reference! */
function graph_query_count_s_report ( &$rrdtool_graph ) {

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
	   $mem_used_color;

    if ($strip_domainname) {
       $hostname = strip_domainname($hostname);
    }

    $rrdtool_graph['height'] += ($size == 'medium') ? 28 : 0;
    $title = 'Query Count per sec';
    if ($context != 'host') {
       $rrdtool_graph['title'] = $title;
    } else {
       $rrdtool_graph['title'] = "$hostname $title last $range";
    }
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['vertical-label'] = 'Queries/s';
    $rrdtool_graph['extras']         = '--rigid';

    $series = "DEF:'query_count_s'='${rrd_dir}/queryCount_s.rrd':'sum':AVERAGE "."LINE1:'query_count_s'#$mem_used_color:'query Count / sec' ";


    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;

}

?>
