<?php

/* Pass in by reference! */
function graph_query_count_report ( &$rrdtool_graph ) {

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
	   $mem_cached_color;

    if ($strip_domainname) {
       $hostname = strip_domainname($hostname);
    }

    $rrdtool_graph['height'] += ($size == 'medium') ? 28 : 0;
    $title = 'Query Count';
    if ($context != 'host') {
       $rrdtool_graph['title'] = $title;
    } else {
       $rrdtool_graph['title'] = "$hostname $title last $range";
    }
    $rrdtool_graph['lower-limit']    = '0';
    $rrdtool_graph['vertical-label'] = 'Queries';
    $rrdtool_graph['extras']         = '--rigid';

    $series = "DEF:'query_count'='${rrd_dir}/queryCount.rrd':'sum':AVERAGE "."LINE2:'query_count'#$mem_cached_color:'query Count' ";

    $rrdtool_graph['series'] = $series;

    return $rrdtool_graph;

}

?>
