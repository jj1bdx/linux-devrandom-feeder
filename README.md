# feedrandom: an entropy injection feeder for Linux

## WARNING

This software is still at the *experimental stage*. No guarantee for any damage
which might be caused by the use of this software. Caveat emptor.

## What this driver is for

To accomodate True Random Number Generator (TRNG) random bits into Linux kernel.

## IMPORTANT SECURITY NOTICE

*Note well: providing incorrect permission and unauthenticated or unscreened
data to /dev/random may degrade the quality of /dev/random, /dev/urandom, and
the security of the entire Linux operating system.*

## Tested environment

* Ubuntu 18.04 LTS

## Requirement

This program uses libbsd; install it as follows for Ubuntu
    
    sudo apt install libbsd-dev

## How this works

`feedrandom.c` is a C code example to transfer TRNG data from a tty device to
`/dev/random`. The code sets input tty disciplines and lock the tty, then feed
the contents to `/dev/random`.

The source to write to `/dev/random` *must* be a real TRNG. Possible candidates are:

* [NeuG](http://www.gniibe.org/memo/development/gnuk/rng/neug.html), claiming ~80kbytes/sec generation speed
* [TrueRNG 2](https://www.tindie.com/products/ubldit/truerng-hardware-random-number-generator/), claiming ~43.5kbytes/sec generation speed

The following TRNG is slow (~2kbytes/sec), but may work well (disclaimer: Kenji
Rikitake develops the software and hardware):

* [avrhwrng](https://github.com/jj1bdx/avrhwrng/), an experimental hardware on Arduino Duemilanove/UNO

## Version

* 16-SEP-2019: 0.3.0 (Rewritten for Linux, uses ioctl for /dev/random)
* 8-NOV-2015: 0.2.0 (Use SHA512 hash for 1:8 compression as default)
* 23-SEP-2015: 0.1.2 (Fix termios; now CLOCAL cleared, modem control enabled)
* 19-AUG-2015: 0.1.1 (Fix bug on tty read(2) of feedrandom)
* 12-AUG-2015: 0.1.0 (Initial release, based on FreeBSD /dev/trng 0.2.1)

## How to run feedrandom

Note well: run as the superuser for putting the output to /dev/random.

    # Only /dev/tty* devices are accepted
    feedrandom -d /dev/ttyUSB0
    # only the basename(3) part is used and attached to `/dev/` directly
    # so this is also OK
    feedrandom -d ttyUSB0
    # tty speed [bps] can be set (9600 ~ 1000000, default 115200)
    feedrandom -d ttyUSB0 -s 9600
    # for usage
    feedrandom -h

## tty discipline of the input tty

    # result of sudo stty -F /dev/ttyUSB0 -a
    # (sudo needed to override TIOCEXCL)
    speed 115200 baud; rows 0; columns 0; line = 0;
    intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>;
    eol2 = <undef>; swtch = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R;
    werase = ^W; lnext = ^V; discard = ^O; min = 1; time = 0;
    -parenb -parodd -cmspar cs8 hupcl -cstopb cread -clocal -crtscts
    ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff
    -iuclc -ixany -imaxbel -iutf8
    -opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
    -isig -icanon -iexten -echo -echoe -echok -echonl -noflsh -xcase -tostop -echoprt
    -echoctl -echoke -flusho -extproc

## License

BSD 2-clause. See LICENSE.

SHA512 hashing code are from the following page: [Fast SHA-2 hashes in x86
assembly](http://www.nayuki.io/page/fast-sha2-hashes-in-x86-assembly) by
Project Nayuki. The related code are distributed under the MIT License.

writeentropy.c is a part of [infnoise-linux](https://github.com/jj1bdx/infnoise-linux), licensed under [Unlicense](https://unlicense.org/), equivalent to the public domain.
