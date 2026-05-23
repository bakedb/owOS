#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

int clear_screen() {
    printf("\033[H\033[2J");
    return 0;
}

int read_file(char *filename) {
    char ch;
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("[uwush.read_file] Could not open file '%s'.\n", filename);
        return 1;
    }
    while ((ch = fgetc(file)) != EOF) {
        putchar(ch);
    }
    fclose(file);
    printf("\n");
}

int main() {
    clear_screen();
    printf("Hello World :3\n");
    printf("owOS Build 2026.05.23\n");
    printf("Made with <3 (and frustration) by Lavender <https://bkd.lol>\n");
    fflush(stdout);

    char input[256];

    while (1) {
        printf("uwush > ");
        fflush(stdout);

        if (fgets(input, sizeof(input), stdin) == NULL) {
            break;
        }

        input[strcspn(input, "\n")] = '\0'; // strip the newline at the end of the string

        if (strlen(input) == 0) {
            continue;
        }

        if (strcmp(input, "help") == 0) {
            read_file("/etc/commands");
        }

        else if (strcmp(input, "shutdown") == 0) {
            char shutdown_confirmation = 'n';
            printf("Are you sure you want to shut down the system? [y/N]: ");
            scanf("%c", &shutdown_confirmation);
            if (shutdown_confirmation == 'y' || shutdown_confirmation == 'Y') {
                printf("Shutting down owOS...\nGoodbye :3\n");
                fflush(stdout);

                execl("/sbin/poweroff", "poweroff", NULL);

                printf("Uh oh, looks like the shutdown failed o.o\n");
            }
        }

        else {
            printf("Unrecognized command '%s'.\n", input);
        }

    }
    return 0;
};