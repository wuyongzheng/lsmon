BEGIN {
	FS = "\t";
	"grep '#DEFVAR' collect.sh | sed -e 's/.*DEFVAR //g' -e 's/[^ ]*://g' | tr '\n ' '\t'" | getline x;
	split(x, type);
	prevts = 0;
	if (!period)
		period = 1;
}

{
	if ($1 - prevts > 400) {
		for (i = 2; i <= NF; i ++)
			prev[i] = $i;
		value_count = 0;
		for (i = 2; i <= NF; i ++)
			values[i] = 0;
		prevts = $1;
		next;
	}
	prevts = $1;

	for (i = 2; i <= NF; i ++) {
		if (type[i-1] == "a")
			n = $i - prev[i];
		else
			n = $i;
		if (n < -1073741824)
			n = n + 4294967296;
		values[i] += n;
		prev[i] = $i;
	}
	value_count ++;

	if (value_count >= period) {
		printf($1 + 28800);
		for (i = 2; i <= NF; i ++)
			printf("\t" values[i] / value_count);
		print "";

		value_count = 0;
		for (i = 2; i <= NF; i ++)
			values[i] = 0;
	}
}
