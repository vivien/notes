/*
 * -----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
 * you can do whatever you want with this stuff. If we meet some day, and you
 * think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
 * -----------------------------------------------------------------------------
 */

/* UDP Server */

#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>

//TODO first thing to do
#define STEP sizeof(char)

int main()
{
    int sock;
    size_t size = STEP;
    size_t a_size = sizeof(struct sockaddr_in);
    void *buffer = malloc(STEP);

    //FIXME: first fixme thing
    int port = 4242;

    /* address server sock */
    struct sockaddr_in addr = {AF_INET, htons(port), {htonl(INADDR_ANY)}};

    //TODO : second todo thing!
    /* client sock */
    struct sockaddr_in client;

    /* socket declaration */
    sock = socket(AF_INET, SOCK_DGRAM, 0);

    /* bind socket to local */
    bind(sock, (struct sockaddr*) &addr, sizeof(struct sockaddr_in));

    //OPTIMIZE make it better  
    while(1)
    {
        //FOO a custom tag
        while (recvfrom(sock, buffer, size, MSG_PEEK, NULL, NULL) == size)
            buffer = realloc(buffer, size += STEP); //TODO hello world

        recvfrom(sock, buffer, size, 0, (struct sockaddr*) &client, &a_size);

        printf("Server receive: \"%s\"\n", (char*) buffer);
    }

    return 0;
}
