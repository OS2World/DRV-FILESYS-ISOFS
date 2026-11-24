/*
 * bootmsg.c - boot messages and parameters of the ISOFS stub IFS.
 * Copyright (c) 2026 OS2World. GNU General Public License, version 2 or later, see LICENSE.
 *
 * Follows the EDM2 "Suggestion for OS/2 and eComStation Drivers Arguments":
 *   quiet by default (only errors), /V verbose, /Q no messages at all,
 *   /W wait for a key after the messages, /AA beep when the driver loaded.
 * Every message line starts with "ISOFS: "; long messages are word-wrapped at
 * 79 columns and every line gets the prefix.  No run-time library is used.
 */

#define INCL_DOSERRORS
#define INCL_DOSFILEMGR
#define INCL_DOSPROCESS
#define INCL_DOSMISC
#include <os2.h>

#include "version.h"
#include "bootmsg.h"

#define COLS      79
#define PREFIX    ISOFS_NAME ": "
#define PREFIXLEN (sizeof(PREFIX) - 1)

static int fQuiet, fVerbose, fWait, fBeep;
static char line[COLS + 4];

static int Len(char far *s)
{
    int n = 0;
    while (s[n]) n++;
    return n;
}

static void Msg(char far *text)
{
    int len, n, cut, i;
    USHORT written;

    if (fQuiet) return;
    len = Len(text);
    while (len > 0) {
        n = len;
        if (n > COLS - (int)PREFIXLEN) {
            cut = COLS - (int)PREFIXLEN;
            while (cut > 0 && text[cut] != ' ') cut--;
            n = cut ? cut : COLS - (int)PREFIXLEN;
        }
        for (i = 0; i < (int)PREFIXLEN; i++) line[i] = PREFIX[i];
        for (i = 0; i < n; i++) line[PREFIXLEN + i] = text[i];
        line[PREFIXLEN + n] = '\r';
        line[PREFIXLEN + n + 1] = '\n';
        DosWrite(1, line, (USHORT)(PREFIXLEN + n + 2), &written);
        text += n; len -= n;
        if (len > 0 && *text == ' ') { text++; len--; }
    }
}

static char Up(char c)
{
    return (c >= 'a' && c <= 'z') ? (char)(c - 'a' + 'A') : c;
}

/* returns 0 if the switches are valid */
static int ParseArgs(char far *p)
{
    int bad = 0;

    if (!p) return 0;
    while (*p) {
        while (*p == ' ' || *p == '\t') p++;
        if (!*p) break;
        if (*p != '/') { bad = 1; break; }
        p++;
        switch (Up(*p)) {
        case 'V': fVerbose = 1; p++; break;
        case 'Q': fQuiet = 1; p++; break;
        case 'W': fWait = 1; p++; break;
        case 'A':
            if (Up(p[1]) == 'A') { fBeep = 1; p += 2; }
            else bad = 1;
            break;
        default: bad = 1;
        }
        if (bad) break;
        if (*p && *p != ' ' && *p != '\t') { bad = 1; break; }
    }
    return bad;
}

int BootInit(char far *pcParm)
{
    if (ParseArgs(pcParm)) {
        Msg("ISOFS.IFS could not be loaded. Invalid parameters.");
        return ERROR_BAD_ARGUMENTS;
    }
    if (fVerbose)
        Msg(ISOFS_BANNER);
    return NO_ERROR;
}

void BootFail(char far *pszReason)
{
    static char msg[COLS * 2];
    char far *head = "ISOFS.IFS could not be loaded. ";
    int i = 0, j = 0;

    while (head[j] && i < (int)sizeof(msg) - 1) msg[i++] = head[j++];
    j = 0;
    while (pszReason[j] && i < (int)sizeof(msg) - 1) msg[i++] = pszReason[j++];
    msg[i] = 0;
    Msg(msg);
}

void BootNote(char far *pszText)
{
    if (fVerbose)
        Msg(pszText);
}

int BootDone(int rc)
{
    char key;
    USHORT nread;

    if (fWait && !fQuiet) {
        Msg("Press any key to continue.");
        DosRead(0, &key, 1, &nread);
    }
    if (fBeep && rc == NO_ERROR)
        DosBeep(1000, 120);
    return rc;
}
