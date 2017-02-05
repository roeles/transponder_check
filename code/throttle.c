#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

int main(int argc, char ** argv)
{
	if(argc < 2)
	{
		fprintf(stderr, "Usage: %s bytes-per-second\n", argv[0]);
		return -1;
	}
	const ssize_t block_size = atoi(argv[1]);
	void * data = malloc(block_size);

	ssize_t read_result;
	ssize_t write_result;
	while(	((read_result = read(STDIN_FILENO, data, block_size)) > 0) &&
		((write_result = write(STDOUT_FILENO, data, block_size)) > 0))
		sleep(1);

	fprintf(stderr, "read_result=%d write_result=%d errno=%d strerror=%s\n", read_result, write_result, errno, strerror(errno));	

	return 0;
}
