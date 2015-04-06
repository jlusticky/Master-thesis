#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>

#if !defined(ARRAY_SIZE)
    #define ARRAY_SIZE(x) (sizeof((x)) / sizeof((x)[0]))
#endif

/* Define your gateway IP addresses */
char *gateways[] = { "192.0.2.6" }; //, "193.160.39.1" }; // , etc. };

int main(int argc, char *argv[])
{
  char *gw;
  char *buf;
  size_t size = 64;
  int i = 0;

  if (argc != 2)
  {
    fprintf(stderr, "Usage: %s destinations\n", argv[0]);
    return EXIT_FAILURE;
  }

  FILE *f = fopen(argv[1], "r");
  if (f == NULL)
  {
    fprintf(stderr, "%s %d\n", argv[1], __LINE__);
    return EXIT_FAILURE;
  }

  buf = malloc(64);
  if (buf == NULL)
  {
    fprintf(stderr, "%s %d\n", argv[0], __LINE__);
    fclose(f);
    return EXIT_FAILURE;
  }

  ssize_t len;
  while ((len = getline(&buf, &size, f)) > 5) // get destination subnets
  {
    buf[len-1] = '\0';
    gw = gateways[i % ARRAY_SIZE(gateways)];
    pid_t pid = fork();
    if (pid == -1)
    {
      fprintf(stderr, "%s %d\n", argv[0], __LINE__);
      fclose(f);
      free(buf);
      return EXIT_FAILURE;
    }
    else if (pid == 0) // child
    {
      printf("ip route add %s via %s\n", buf, gw);
      execlp("ip", "ip", "route", "add", buf, "via", gw, NULL);
    }
    else // parent
    {
      wait(NULL); // wait for child
    }
    i++; // move to next gw
  }
  fclose(f);
  free(buf);
  return EXIT_SUCCESS;
}
