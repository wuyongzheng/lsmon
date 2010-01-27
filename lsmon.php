<?php
$period = 1;
if (array_key_exists('period', $_GET))
	$period = intval($_GET['period']);
if ($period == 0)
	$period = 1;

$outstring = system("bash /home/atp/app/lsmon/plot.sh $period 240", $retval);
if ($retval != 0)
	die($outstring);
?>
<html>
<head>
<title>LSMON: Light-weight System MONitor</title>
</head>
<body>
<a href="lsmon.php?period=1">1</a>
<a href="lsmon.php?period=10">10</a>
<hr />
<img src="plot-cpu-agg.png" />
<img src="plot-sys.png" />
<img src="plot-proc.png" />
<hr />
<img src="plot-mem.png" />
<hr />
<img src="plot-iod-time.png" />
<img src="plot-iob1-bytes.png" />
<img src="plot-iob2-bytes.png" />
<hr />
<img src="plot-net-bytes.png" />
<img src="plot-net-packets.png" />
<img src="plot-ping-loss.png" />
<img src="plot-ping-rtt.png" />
</body>
</html>
