/*
 * mac-robber
 *
 * collects MAC times from files and outputs to STDOUT in a format that
 * the mactime program from The Sleuth Kit  reads.  This
 * program uses system calls and therefore will modify the A-Time
 * on directories that are not mounted readonly.
 *
 *
 * Author: Brian Carrier [carrier@sleuthkit.org]
 * Copyright (c) 2003-2010 Brian Carrier.  All rights reserved
 * Copyright (c) 2002 @stake Inc.  All rights reserved
 *
 *
 * mac-robber is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * mac-robber is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with mac-robber; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR PURPOSE.
 *
 * IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA, OR PROFITS OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */


#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>


#define VER "1.02"

#define OK		0
#define ERROR	1

#define LS_SIZE	16
#define LINKPATH_LEN	2048
static char *linkpath;

static void
usage(char *prog)
{
    printf("usage: %s [-V] <directories>\n", prog);
    printf("  -V: Print the version to stdout\n");
    exit(1);
}

static void
print_version()
{
    printf("mac-robber information:\n");
    printf("   version: %s \n", VER);
    printf("   author: Brian Carrier\n");
    printf("   url: http://www.sleuthkit.org\n");
    exit(0);
}


/* 
 * print the header information to stdout
 */
static void
print_header()
{
    char hostnamebuf[BUFSIZ];
    unsigned long now;

    /* Get the hostname */
    if (gethostname(hostnamebuf, sizeof(hostnamebuf) - 1) < 0) {
        printf("error getting hostname\n");
        exit(1);
    }

    hostnamebuf[sizeof(hostnamebuf) - 1] = 0;
    now = time((time_t *) 0);

    printf("class|host|start_time\n");
    printf("body|%s|%lu\n", hostnamebuf, now);


    /*
     * Identify the fields in the data that follow.
     */
    printf
        ("MD5|name|inode|mode_as_string|UID|GID|size|atime|mtime|ctime|crtime\n");

    return;
}


/*
 * Convert the numeric file mode to the ASCII representation 
 * that is shown using 'ls -l'.  
 * 
 * *ls must by 11 or longer
 *
 */
static void
make_ls(mode_t mode, char *ls, int len)
{
    if (len < 11) {
        printf("make_ls: ls length too short\n");
        exit(1);
    }

    /* put the default values in */
    strcpy(ls, "----------");

    /* file type */
    switch (S_IFMT & mode) {
    case S_IFREG:
        ls[0] = '-';
        break;
    case S_IFDIR:
        ls[0] = 'd';
        break;
    case S_IFLNK:
        ls[0] = 'l';
        break;
    case S_IFIFO:
        ls[0] = 'p';
        break;
    case S_IFCHR:
        ls[0] = 'c';
        break;
    case S_IFBLK:
        ls[0] = 'b';
        break;
    case S_IFSOCK:
        ls[0] = 's';
        break;
    }

    /* user perms */
    if (mode & S_IRUSR)
        ls[1] = 'r';
    if (mode & S_IWUSR)
        ls[2] = 'w';
    /* set uid */
    if (mode & S_ISUID) {
        if (mode & S_IXUSR)
            ls[3] = 's';
        else
            ls[3] = 'S';
    }
    else if (mode & S_IXUSR)
        ls[3] = 'x';

    /* group perms */
    if (mode & S_IRGRP)
        ls[4] = 'r';
    if (mode & S_IWGRP)
        ls[5] = 'w';
    /* set gid */
    if (mode & S_ISGID) {
        if (mode & S_IXGRP)
            ls[6] = 's';
        else
            ls[6] = 'S';
    }
    else if (mode & S_IXGRP)
        ls[6] = 'x';

    /* other perms */
    if (mode & S_IROTH)
        ls[7] = 'r';
    if (mode & S_IWOTH)
        ls[8] = 'w';

    /* sticky bit */
    if (mode & S_ISVTX) {
        if (mode & S_IXOTH)
            ls[9] = 't';
        else
            ls[9] = 'T';
    }
    else if (mode & S_IXOTH)
        ls[9] = 'x';

    return;
}


/*
 * process the given directory (it MUST end with '/')
 *
 * Each file and subdirectory are identified using opendir and
 * an lstat is performed on them.  If the entry is for a 
 * directory, the function is called recursively on it.  
 *
 * 0 is returned on success and 1 on error
 */

static unsigned int
do_dir(char *dir)
{
    DIR *dirp;
    struct dirent *dp;
    int dir_len;
    char *curpath;
    int path_len;

    /* skip the /proc directory */
    if (strcmp(dir, "/proc/") == 0)
        return OK;

    dir_len = strlen(dir);

    if (!(dirp = opendir(dir))) {
        printf("invalid directory: %s\n", dir);
        exit(1);
    }

    /* Make a buffer for the full path
     * the 2 is for 1 NULL and 1 '/' for recursive directories 
     */
    path_len = dir_len + MAXNAMLEN + 2;
    if (!(curpath = (char *) malloc(path_len))) {
        printf("error allocating space for curpath\n");
        exit(1);
    }

    strncpy(curpath, dir, path_len);

    /* cycle through the directories */
    while ((dp = readdir(dirp)) != NULL) {
        char ls[LS_SIZE];
        struct stat sp;

        /* skip the . and .. entries */
        if ((dp->d_name[0] == '.') && ((dp->d_name[1] == '\0') ||
                ((dp->d_name[1] == '.') && (dp->d_name[2] == '\0'))))
            continue;

        /* make the full name and do an lstat */
        strncat(curpath, dp->d_name, path_len);

        if (0 != lstat(curpath, &sp)) {
            printf("lstat error: %s\n", curpath);
            return ERROR;
        }

        /* convert the mode into an ascii form */
        make_ls(sp.st_mode, ls, LS_SIZE);

        /*  
         * if it is a symbolic link, then we also print the destination
         */
        if ((sp.st_mode & S_IFMT) == S_IFLNK) {
            int llen;

            /* use -1 so we can add NULL */
            llen = readlink(curpath, linkpath, LINKPATH_LEN - 1);
            if (llen == -1) {
                printf("readlink error: %s\n", curpath);
                exit(1);
            }
            /* add the NULL to the end */
            linkpath[llen] = '\0';
        }

        /* Print the data */
        printf("0|%s|0|%s%s%s|%d|%d|%lu|%lu|%lu|%lu|0\n",
            curpath, ls, ((sp.st_mode & S_IFMT) == S_IFLNK) ? " -> " : "",
            ((sp.st_mode & S_IFMT) == S_IFLNK) ? linkpath : "",
            (int) sp.st_uid, (int) sp.st_gid, (unsigned long) sp.st_size,
            (unsigned long) sp.st_atime, (unsigned long) sp.st_mtime,
            (unsigned long) sp.st_ctime);

        /* recurse if we have a directory */
        if ((sp.st_mode & S_IFMT) == S_IFDIR) {
            strncat(curpath, "/", path_len);
            if (do_dir(curpath)) {
                free(curpath);
                return ERROR;
            }
        }

        /* null terminate the curpath so strncat works for the next entry */
        curpath[dir_len] = '\0';

    }                           /* end of readdir */

    closedir(dirp);
    free(curpath);
    return OK;

}                               /* end of do_dir */

int
main(int argc, char **argv)
{
    char *dir;
    int len;
    int ch;

    while ((ch = getopt(argc, argv, "V")) > 0) {
        switch (ch) {
        default:
            usage(argv[0]);
        case 'V':
            print_version();
            return 0;
        }
    }

    /* Make sure the directory is given */
    if (optind == argc)
        usage(argv[0]);

    /* Allocate a big buffer for the destination of sym links */
    linkpath = (char *) malloc(LINKPATH_LEN);
    if (!linkpath) {
        printf("error allocating memory for link path\n");
        return 1;
    }

    print_header();

    while (optind != argc) {
        /* we need to append a / to the end of the directory if
         * one does not already exist 
         */
        len = strlen(argv[optind]);
        if (argv[optind][len - 1] == '/') {
            dir = argv[optind];
        }
        else {
            dir = (char *) malloc(len + 2);
            strncpy(dir, argv[optind], len + 1);
            strncat(dir, "/", len + 2);
        }

        if (ERROR == do_dir(dir))
            return 1;

        if (dir != argv[optind])
            free(dir);

        optind++;
    }

    free(linkpath);
    return 0;
}
