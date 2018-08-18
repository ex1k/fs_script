#!/usr/bin/bash --
error() {
echo "Error!" >&2
exit 1
}
groups "$1" &>/dev/null && [ -r . ] || error
[ 0 == "`/usr/xpg4/bin/id -u $1`" ] && gfind -maxdepth 1 -type f -ls | nawk '{tmp=$11; for (i=12; i<=NF; i++) { tmp=tmp" "$i;} print tmp;}' | sed 's#^\./##' && exit 0
tmp="`groups $1`" && gfind . -maxdepth 1 -type f -ls | nawk -v var="$tmp" -v usr="$1" 'BEGIN { n=split(var, grp);}; { ugmatch=0; tmp=$11; for (i=1; i<=n; i++) { if ((($5 == usr) && ($3 ~ /^..w/)) || (($6 == grp[i]) && ($3 ~ /^.....w/) && ($5 != usr))) { ugmatch=1; for (i=12; i<=NF; i++) { tmp=tmp" "$i;} print tmp; break;}} omatch=0; for (j=1; j<=n; j++) { if (ugmatch == 1) { break;} if ($6 == grp[j]) { break;} else { if (($5 != usr) && ($3 ~ /w.$/)) omatch=1;} if ((j == n) && (omatch == 1)) { for (i=12; i<=NF; i++) { tmp=tmp" "$i;} print tmp;}}}' | sed 's#^\./##'
exit 0
