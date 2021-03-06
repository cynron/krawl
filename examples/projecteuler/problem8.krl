import (
	"stdio.h"
	"stdlib.h"
	"ctype.h"
)

func read_file(filename *byte) (*byte, int) {
	f := stdio.fopen(filename, "r")
	if f == nil {
		return nil, 0
	}

	var read_n stdio.size_t
	var alloc_n stdio.size_t = 1024
	var buf *byte = stdlib.malloc(1024)

	for stdio.feof(f) == 0 {
		if stdio.ferror(f) != 0 {
			stdio.fclose(f)
			stdlib.free(buf)
			return nil, 0
		}

		if alloc_n < read_n + 1024 {
			buf = stdlib.realloc(buf, alloc_n)
			alloc_n *= 2
		}
		n := stdio.fread(buf + read_n, 1, 1024, f)
		read_n += n
	}

	stdio.fclose(f)
	return buf, read_n
}

func remove_nondigits(data *byte, size int) int {
	j := 0
	for i := 0; i < size; i++ {
		if ctype.isdigit(data[i]) == 0 {
			continue
		}
		data[j] = data[i]
		j++
	}
	return j
}

func find_max(data *byte, size int) {
	var maxprod int
	var maxset [5]byte
	var curset [5]byte

	for i := 0; i < size-4; i++ {
		for j := 0; j < 5; j++ {
			curset[j] = data[i+j] - '0'
		}
		curprod := 1
		for j := 0; j < 5; j++ {
			curprod *= curset[j]
		}
		if curprod > maxprod {
			maxprod = curprod
			maxset = curset
		}
	}

	stdio.printf("the greatest product is: %d\n", maxprod)
	stdio.printf("received using this set: %d%d%d%d%d\n",
		     maxset[0], maxset[1], maxset[2], maxset[3], maxset[4])
}

func main(argc int, argv **byte) int {
	data, size := read_file("problem8.txt")
	if data == nil {
		stdio.printf("failed to read a file\n")
		return 1
	}
	size = remove_nondigits(data, size)
	find_max(data, size)
	return 0
}
