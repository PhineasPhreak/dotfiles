# Sublime Merge 2

## Installation `Sublime Merge`
* Site : [Sublime Merge](https://www.sublimemerge.com/)

Use bash script to install sublime merge 2 in `../sublime-text`
```console
$ bash subl-instal-apt.sh
```

## Instructions to active the License

Sublime Merge 2 build 2054 Linux
```bash
#! /usr/bin/bash
#
# Original Link : https://gist.github.com/rufoa/78e45d70f560f53678853c92dae2598a
#
# Run these commands one line at a time, not as a script

sudo -i
cd /opt/sublime_merge

sha256sum sublime_merge
# should be c73c7c9a24173bd87348f24eacd2cc5d9a9841ce5f44bc223f87be9214fbbd14 (rpm)
#        or 9200b625c8ea60143ec78e721085273ffa37d86be34f464aa369ea23f244cc47 (other linux)

cp sublime_merge sublime_merge.bak

# swap public key
printf '\x30\x81\x9d\x30\x0d\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x01\x01\x05\x00\x03\x81\x8b\x00\x30\x81\x87\x02\x81\x81\x00\xc9\xda\x03\xe0\xc6\x33\xce\x4e\x55\xf5\xbf\x60\xf9\xb1\xb0\xda\xd6\x64\xc0\x5d\x03\xca\x7e\x21\xa6\x57\xd2\x17\xa9\x58\x9d\x51\x73\x30\x0d\xb5\x34\x13\x08\xab\x55\x5c\x22\x26\x6c\x03\x0d\xbe\x3c\x80\xb4\x59\xe9\xee\xad\x45\x8f\xa1\x38\x37\x69\xcd\x51\xa2\x19\xa4\x41\x4b\x8c\x0a\x1e\x51\x7f\x58\xc8\x33\xa5\x3c\x15\xc8\x24\xcd\xcc\x94\xb8\x5a\xfe\x44\x12\xa0\x18\x34\x63\x87\x72\x11\x11\x0b\x0c\x12\x44\x76\xec\x60\x13\xc0\x0d\x7e\xf1\x48\xbf\x8a\xce\x10\x02\x79\x45\x31\xf5\x3a\x34\xf2\x56\x6e\x71\xc7\xf4\x45\x02\x01\x11' | dd of=sublime_merge bs=1 seek=345120 count=160 conv=notrunc

# swap xor key
printf '\x00' | dd of=sublime_merge bs=1 seek=3803954 count=1 conv=notrunc

# fix sha-2 check
printf '\x2f' | dd of=sublime_merge bs=1 seek=3806095 count=1 conv=notrunc
printf '\x0e' | dd of=sublime_merge bs=1 seek=3806098 count=1 conv=notrunc

# disable online licence check
printf '\xc3' | dd of=sublime_merge bs=1 seek=3808992 count=1 conv=notrunc

# disable phone home
printf '\xc3' | dd of=sublime_merge bs=1 seek=3803210 count=1 conv=notrunc

sha256sum sublime_merge
# should be bd5d4875fb6ba475a07e677169f04fb496da13d6f369422143c3f22d216df81f (rpm)
#        or e54e6566397daaf8dc2991c63635a4c22125d02d68acf58459a0500c4ba413ad (other linux)
```

Use the Key after script above.
```text
----- BEGIN LICENSE -----
TEAM RUFIO
Unlimited User License
E52D-666666
487EE6F0309908F702DDD52AFCD99A6A
6EE14CF8A2D42271B4FC0991BBF93ADC
FAA9075C436B3796669194A2F36CAAEF
B251155329EC2E434FD28B4A21BE68CC
955D306EE9ED843C5E98B1577D02DEAA
1F4E872AE6495CD5E3B1DA55D5ACD2B2
2EA4110FB800F21AA3EC2E3902589BCF
7281A19C2DFF0CEE4AEA5DDD1E6DF893
----- END LICENSE -----
```
