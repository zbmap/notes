				bash

Bash 命令种类：简单命令，控制结构  group 命令 函数以及文件，都相当于是一个命令，使用方式和简单命令使用方式都一样，比如pipeline，io重定向等都；

At its base, a shell is simply a macro processor that executes commands. The term macro processor means functionality where text and symbols are expanded to create larger expressions.

Bash 本质上和c的macro很像，只是扩展方式不太一样，但是本质上都是expand，不管是参数扩展，命令替换等等，都是一种expand；

Quoting:		How to remove the special meaning from characters.
Shell里面说的引用就是改变一个字符表达的含义；一个字符的含义可以是自己字面的意思也可以是一个metachar；

Io重定向使用： pipeline 方式； 文件方式，here doc 和here string 方式；或者是任意文件描述符的方式；

bash 命令list：总共有4个， && || & ；
A list is a sequence of one or more pipelines separated by one of the operators ‘;’, ‘&’, ‘&&’, or ‘||’, and optionally terminated by one of ‘;’, ‘&’, or a newline.
Bash 脚本参数或者是函数参数都是通过整数或者是* #命名的，只不过我们通过引用的时候都需要使用 $1等方式使用；

sudo ip route add default nexthop via 192.168.100.4 dev eth1 nexthop via 192.168.100.3 dev eth2

Renaming/moving files with suffixes quickly: cp /home/foo/realllylongname.cpp{,-old}
This expands to: cp /home/foo/realllylongname.cpp /home/foo/realllylongname.cpp-old

!!
Repeats your last command. Most useful in the form:
sudo !!

搜索一个进程命令 用pgrep：通过进程名字获取进程id； 
不用ps aux  | grep xxx | awk ‘{print $1}’

{start..end}   `seq start end`效果是相同的

eval takes a string as its argument, and evaluates it as if you'd typed that string on a command line. 

git clone https://git.openwrt.org/12.09/openwrt.git 1209

控制结构单条语句写法：
repeat() { while true; do $@ && return; done } 
repeat() { while :; do $@ && return; done }

if [[ $UID -eq 0 ]]; then echo "root"; else echo common; fi

查看IFS当前的值 
set | grep ^IFS

当通过echo命令给一个文件写入值的时候 如果没有权限，可以通过 echo 0 | sudo tee tmp.a  命令实现给tmp.a 文件写入值
或者通过cat命令写入复杂的值：cat <<qqq | sudo tee tmp.a
> 1
> qqq

Uniq 只能作用于已经排序过的文本；

spawn expect  send example
#!/bin/expect -f
spawn scp -r zhangbo12@172.18.178.180:/Users/zhangbo12/Downloads/bf-sde-8.5.0.tar .
expect "Password:"
send "linux@123\r"
interact

cat heredoc example:
hostapd_setup_vif() {
        local vif="$1"
        local driver="$2"
        local ifname device channel hwmode

        hostapd_cfg=

        config_get ifname "$vif" ifname
        config_get device "$vif" device
        config_get channel "$device" channel
        config_get hwmode "$device" hwmode

        hostapd_set_log_options hostapd_cfg "$device"
        hostapd_set_bss_options hostapd_cfg "$vif"

        case "$hwmode" in
                *bg|*gdt|*gst|*fh) hwmode=g;;
                *adt|*ast) hwmode=a;;
        esac
        [ "$channel" = auto ] && channel=
        [ -n "$channel" -a -z "$hwmode" ] && wifi_fixup_hwmode "$device"
        cat > /var/run/hostapd-$ifname.conf <<EOF
driver=$driver
interface=$ifname
${hwmode:+hw_mode=${hwmode#11}}
${channel:+channel=$channel}
$hostapd_cfg
EOF
        hostapd -P /var/run/wifi-$ifname.pid -B /var/run/hostapd-$ifname.conf
}

cat << EOF > $CFG_OUT
[vmlinux]
filename=kernel
md5sum=$KERNEL_MD5
flashaddr=$KERNEL_FLASH_ADDR
checksize=0x0
cmd_success=setenv bootseq 1,2; setenv kernel_size_1 $KERNEL_PART_SIZE; saveenv
cmd_fail=reset

[rootfs]
filename=rootfs
md5sum=$ROOTFS_MD5
flashaddr=$ROOTFS_FLASH_ADDR
checksize=$ROOTFS_CHECK_SIZE
cmd_success=setenv bootseq 1,2; setenv kernel_size_1 $KERNEL_PART_SIZE; setenv rootfs_size_1 $ROOTFS_PART_SIZE; saveenv
cmd_fail=reset
EOF

find $TARGETS -type f -a -exec file {} \; | \
  sed -n -e 's/^\(.*\):.*ELF.*\(executable\|relocatable\|shared object\).*,.* stripped/\1:\2/p' | \
(
  IFS=":"
  while read F S; do
    echo "$SELF: $F:$S"
        [ "${S}" = "relocatable" ] && {
                eval "$STRIP_KMOD $F"
        } || {
                b=$(stat -c '%a' $F)
                eval "$STRIP $F"
                a=$(stat -c '%a' $F)
                [ "$a" = "$b" ] || chmod $b $F
        }
  done
  true
)


# Write image header followed by kernel and rootfs image.
# The header is padded to 64k, format is:
#  CI               magic word ("Combined Image")
#  <kernel length>  length of kernel encoded as zero padded 8 digit hex
#  <rootfs length>  length of rootfs encoded as zero padded 8 digit hex
#  <md5sum>         checksum of the combined kernel and rootfs image
( printf "CI%08x%08x%32s" \
        $(stat -c "%s" "$kern") $(stat -c "%s" "$root") "${md5%% *}" | \
        dd bs=$BLKSZ conv=sync;
  cat "$kern" "$root"
) > ${IMAGE} 2>/dev/null

长的awk命令的写法
${CROSS}nm "$MODULE.tmp" | awk '
BEGIN {
        n = 0
}

$3 && $2 ~ /[brtd]/ && $3 !~ /\$LC/ && !def[$3] {
        print "--redefine-sym "$3"=_"n;
        n = n + 1
        def[$3] = 1
}
' > "$MODULE.tmp1"

掌握shell 明确把控几个东西： 输入参数， 标准输入； 命令exit code 以及标准输出；
dd if=/dev/zero of=junk.data bs=1M count=1

查看某个进程所有线程的状态：top -Hp 1647

文件相关属性修改： chmod  chown  chattr  ls  lsattr 命令

Touch 命令： 创建文件或者改变文件的时间戳

[ -e /etc/config/network ] && {
        # only try to parse network config on openwrt

        find_ifname() {(
                reset_cb
                include /lib/network
                scan_interfaces
                config_get "$1" ifname
        )}
} || {
        find_ifname() {
                echo "Interface not found."
                exit 1
        }
}

&是put 进程作为后台进程运行； （） 只是作为subshell 进程运行；但是不加&的时候father 是一致等待sub运行的，即block住father；
local found=0
local ifc
for ifc in $interfaces; do
        local up
        config_get_bool up "$ifc" up 0

        local auto
        config_get_bool auto "$ifc" auto 1

        local proto
        config_get proto "$ifc" proto

        if [ "$DSL_INTERFACE_STATUS" = "UP" ]; then
                if [ "$proto" = "pppoa" ] && [ "$up" != 1 ] && [ "$auto" = 1 ]; then
                        found=1
                        ( sleep 1; ifup "$ifc" ) &
                fi
        else
                if [ "$proto" = "pppoa" ] && [ "$up" = 1 ] && [ "$auto" = 1 ]; then
                        found=1
                        ( sleep 1; ifdown "$ifc" ) &
                fi
        fi
done

md5s() {
        cat "$@" | (
                md5sum 2>/dev/null ||
                md5
        ) | awk '{print $1}'
}

grep -q "$found_device" /proc/swaps || grep -q "$found_device" /proc/mounts || {
                                        [ "$enabled" -eq 1 ] && mkdir -p "$target" && mount "$target" 2>&1 | tee /proc/self/fd/2 | logger -t 'fstab'
}

fopivot() { # <rw_root> <ro_root> <dupe?>
        root=$1
        {
                if grep -q overlay /proc/filesystems; then
                        mount -t overlayfs -olowerdir=/,upperdir=$1 "overlayfs:$1" /mnt && root=/mnt
                elif grep -q mini_fo /proc/filesystems; then
                        mount -t mini_fo -o base=/,sto=$1 "mini_fo:$1" /mnt 2>&- && root=/mnt
                else
                        mount --bind / /mnt
                        mount --bind -o union "$1" /mnt && root=/mnt
                fi
        } || {
                [ "$3" = "1" ] && {
                mount | grep "on $1 type" 2>&- 1>&- || mount -o bind $1 $1
                dupe $1 $rom
                }
        }
        pivot $root $2
}

dupe() { # <new_root> <old_root>
        cd $1
        echo -n "creating directories... "
        {
                cd $2
                find . -xdev -type d
                echo "./dev ./overlay ./mnt ./proc ./tmp"
                # xdev skips mounted directories
                cd $1
        } | xargs mkdir -p
        echo "done"

        echo -n "setting up symlinks... "
        for file in $(cd $2; find . -xdev -type f;); do
                case "$file" in
                ./rom/note) ;; #nothing
                ./etc/config*|\
                ./usr/lib/opkg/info/*) cp -af $2/$file $file;;
                *) ln -sf /rom/${file#./*} $file;;
                esac
        done
        for file in $(cd $2; find . -xdev -type l;); do
                cp -af $2/${file#./*} $file
        done
        echo "done"
}

local root_blocks=$((0x$(dd if="$1" bs=2 skip=5 count=4 2>/dev/null) / $CI_BLKSZ))

没有返回值的函数或者是groupcommand ，等效于在最后一个语句后面省略了  return $?

Heredoc 压缩leader tab 进行方便些代码的时候整齐；
test_softfloat() {
        cat <<-EOT | "$CC" $CFLAGS -msoft-float -o /dev/null -x c - 2>/dev/null
                int main(int argc, char **argv)
                {
                        double a = 0.1;
                        double b = 0.2;
                        double c = (a + b) / (a * b);
                        return 1;
                }
        EOT
}

platform_find_partitions() {
        local first dev size erasesize name
        while read dev size erasesize name; do
                name=${name#'"'}; name=${name%'"'}
                case "$name" in
                        vmlinux.bin.l7|vmlinux|kernel|linux|linux.bin|rootfs|filesystem)
                                if [ -z "$first" ]; then
                                        first="$name"
                                else
                                        echo "$erasesize:$first:$name"
                                        break
                                fi
                        ;;
                esac
        done < /proc/mtd
}
下面有本质的区别，上面的是重定向真个while 语句，下面是重定向 while 条件的语句，所以下面的每次while 执行一次，就会重新打开关闭一次文件；进入一个死循环，但是上面就不会，在while 开始的时候打开一次，while 结束close文件；
while read line < /proc/net/hostap/${phy}/wds; do
                set $line
                [ -f "/var/run/wifi-${1}.pid" ] &&
                        kill "$(cat "/var/run/wifi-${1}.pid")"
                ifconfig "$1" down
                unbridge "$1"
                iwpriv "$phy" wds_del "$2"
done

for bindir in $(
                        echo "${sysroot:-$TOOLCHAIN}/bin";
                        echo "${sysroot:-$TOOLCHAIN}/usr/bin";
                        echo "${sysroot:-$TOOLCHAIN}/usr/local/bin";
                        "$CPP" $CFLAGS -v -x c /dev/null 2>&1 | \
                                sed -ne 's#:# #g; s#^COMPILER_PATH=##p'
                ); do
                        if [ -d "$bindir" ]; then
                                bindirs="$bindirs $(cd "$bindir"; pwd)/"
                        fi
done

while [ $((++try)) -le $max ]; do
	( exec wget -qO/dev/null "$url" 2>/dev/null ) &
	local pid=$!
	( sleep 5; kill $pid 2>/dev/null ) &
	wait $pid && break
done

set_state() { :; }

find_config() {
        local device="$1"
        local ifdev ifl3dev ifobj
        for ifobj in `ubus list network.interface.\*`; do
                interface="${ifobj##network.interface.}"
                (
                        json_load "$(ifstatus $interface)"
                        json_get_var ifdev device
                        json_get_var ifl3dev l3_device
                        if [[ "$device" = "$ifdev" ]] || [[ "$device" = "$ifl3dev" ]]; then
                                echo "$interface"
                                exit 0
                        else
                                exit 1
                        fi
                ) && return
        done
}

try_git() {
        [ -d .git ] || return 1
        REV="$(git log | grep -m 1 git-svn-id | awk '{ gsub(/.*@/, "", $0); print $1 }')"
        REV="${REV:+r$REV}"
        [ -n "$REV" ]
}

bash 续行
do_led() {
        local name
        local sysfs
        config_get name $1 name
        config_get sysfs $1 sysfs
        [ "$name" == "$NAME" -o "$sysfs" = "$NAME" -a -e "/sys/class/leds/${sysfs}" ] && {
                [ "$ACTION" == "set" ] &&
                        echo 1 >/sys/class/leds/${sysfs}/brightness \
                        || echo 0 >/sys/class/leds/${sysfs}/brightness
                exit 0
        }
}

#!/bin/sh
awk -f - $* <<EOF
function bitcount(c) {
        c=and(rshift(c, 1),0x55555555)+and(c,0x55555555)
        c=and(rshift(c, 2),0x33333333)+and(c,0x33333333)
        c=and(rshift(c, 4),0x0f0f0f0f)+and(c,0x0f0f0f0f)
        c=and(rshift(c, 8),0x00ff00ff)+and(c,0x00ff00ff)
        c=and(rshift(c,16),0x0000ffff)+and(c,0x0000ffff)
        return c
}

function ip2int(ip) {
        for (ret=0,n=split(ip,a,"\."),x=1;x<=n;x++) ret=or(lshift(ret,8),a[x])
        return ret
}

function int2ip(ip,ret,x) {
        ret=and(ip,255)
        ip=rshift(ip,8)
        for(;x<3;ret=and(ip,255)"."ret,ip=rshift(ip,8),x++);
        return ret
}

BEGIN {
        slpos=index(ARGV[1],"/")
        if (slpos == 0) {
                ipaddr=ip2int(ARGV[1])
                netmask=ip2int(ARGV[2])
        } else {
                ipaddr=ip2int(substr(ARGV[1],0,slpos-1))
                netmask=compl(2**(32-int(substr(ARGV[1],slpos+1)))-1)
                ARGV[4]=ARGV[3]
                ARGV[3]=ARGV[2]
        }

        network=and(ipaddr,netmask)
        broadcast=or(network,compl(netmask))

        start=or(network,and(ip2int(ARGV[3]),compl(netmask)))
        limit=network+1
        if (start<limit) start=limit

        end=start+ARGV[4]
        limit=or(network,compl(netmask))-1
        if (end>limit) end=limit

        print "IP="int2ip(ipaddr)
        print "NETMASK="int2ip(netmask)
        print "BROADCAST="int2ip(broadcast)
        print "NETWORK="int2ip(network)
        print "PREFIX="32-bitcount(compl(netmask))

        # range calculations:
        # ipcalc <ip> <netmask> <start> <num>

        if (ARGC > 3) {
                print "START="int2ip(start)
                print "END="int2ip(end)
        }
}
EOF

#!/usr/bin/env bash
# Copyright (C) 2006-2010 OpenWrt.org
. ./gen_image_generic.sh

which chpax >/dev/null && chpax -zp $(which grub)
grub --batch --no-curses --no-floppy --device-map=/dev/null <<EOF
device (hd0) $OUTPUT
geometry (hd0) $cyl $head $sect
root (hd0,0)
setup (hd0)
quit
EOF

补丁相关命令   
生成patch：diff -Naru tmp tmp.a >tmp.patch
打patch：patch -p1 tmp < tmp.patch  重复打同一定补丁
撤销补丁：patch -Rp1 tmp < tmp.patch；
目录生成补丁方式： diff -Naur directory1 directory2   可以使用在任何场景，比如上面的单个文件 也可以使用这个命令：diff -Naur tmp tmp.a > tmp.patch 


只是显示目录命令：ll -d */

grep -l. 匹配某个pattern 所在的文件；
ps aux --forest 显示process 关系图

sudo ss -aup


MNAT_CMD="$INSTALL_DIR/bin/$prog -l "$mnat_c" -n "$n" -w "$lan_pci" -w "$wan_pci" --  --wan "$wan_info" --lan ("$lan_pci","$lan_ip","$lan_gw") --vport $vport"
echo $MNAT_CMD
$MNAT_CMD  2>&1 &

Eval  命令 相当于上面的先赋值cmd，然后再执行cmd 命令；
Bash 检索命令优先级：builtin  函数，然后才是path路径查找； 如果想执行指定path里面的一个命令，可以通过给定一个完整的路径的方式进行执行；

More precisely, a double dash (--) is used in bash built-in commands and many other commands to signify the end of command options, after which only positional parameters are accepted.
Example use: lets say you want to grep a file for the string -v - normally -v will be considered the option to reverse the matching meaning (only show lines that do not match), but with -- you can grep for string -v like this:
grep -- -v file


Bash 里面参数扩展的void 即丢弃扩展后的值；: $((kilobytes++))    

if cmp expected actual >/dev/null 2>/dev/null  ：可以同时做重定向


Dpdk 里面通过doble dash 来区分系统参数是否已经结束；


cat /proc/cpuinfo  | { grep process;  echo abc; } 
只有grep 采用这个stdin， 所以abc最后才会被打印出来一次


Grep 里面通过-e 达到or的目的：mnatadm stats-list  | grep -e up -e down 检索 文本中有 up 或者down的词；


下面例子说明可以通过定义变量的方式来简化表达式的使用；
temp="/tmp/fix_ws.$$.$RANDOM"

# Using $'xxx' bashism
begin8sp_tab=$'s/^        /\t/'
beginchar7sp_chartab=$'s/^\\([^ \t]\\)       /\\1\t/'
tab8sp_tabtab=$'s/\t        /\t\t/g'
tab8sptab_tabtabtab=$'s/\t        \t/\t\t\t/g'
begin17sptab_tab=$'s/^ \\{1,7\\}\t/\t/'
tab17sptab_tabtab=$'s/\t \\{1,7\\}\t/\t\t/g'
trailingws_=$'s/[ \t]*$//'

#>fix_ws.diff

find "$@" -type f \
| while read name; do
    test "YES" = "${name/*.bz2/YES}" && continue
    test "YES" = "${name/*.gz/YES}" && continue
    test "YES" = "${name/*.png/YES}" && continue
    test "YES" = "${name/*.gif/YES}" && continue
    test "YES" = "${name/*.jpg/YES}" && continue
    test "YES" = "${name/*.diff/YES}" && continue
    test "YES" = "${name/*.patch/YES}" && continue
    # shell testsuite entries are not to be touched too
    test "YES" = "${name/*.right/YES}" && continue

    if test "YES" = "${name/*.[chsS]/YES}" \
        -o "YES" = "${name/*.sh/YES}" \
        -o "YES" = "${name/*.txt/YES}" \
        -o "YES" = "${name/*.html/YES}" \
        -o "YES" = "${name/*.htm/YES}" \
        -o "YES" = "${name/*Config.in*/YES}" \
    ; then
    # More aggressive whitespace fixes for known file types
        echo "Formatting: $name" >&2
        cat "$name" \
        | sed -e "$tab8sptab_tabtabtab" -e "$tab8sptab_tabtabtab" \
              -e "$tab8sptab_tabtabtab" -e "$tab8sptab_tabtabtab" \
        | sed "$begin17sptab_tab" \
        | sed -e "$tab17sptab_tabtab" -e "$tab17sptab_tabtab" \
              -e "$tab17sptab_tabtab" -e "$tab17sptab_tabtab" \
              -e "$tab17sptab_tabtab" -e "$tab17sptab_tabtab" \
        | sed "$trailingws_"
    elif test "YES" = "${name/*Makefile*/YES}" \
        -o "YES" = "${name/*Kbuild*/YES}" \
    ; then
    # For Makefiles, never convert "1-7spaces+tab" into "tabtab"
        echo "Makefile: $name" >&2
        cat "$name" \
        | sed -e "$tab8sptab_tabtabtab" -e "$tab8sptab_tabtabtab" \
              -e "$tab8sptab_tabtabtab" -e "$tab8sptab_tabtabtab" \
        | sed -e "$tab17sptab_tabtab" -e "$tab17sptab_tabtab" \
              -e "$tab17sptab_tabtab" -e "$tab17sptab_tabtab" \
              -e "$tab17sptab_tabtab" -e "$tab17sptab_tabtab" \
        | sed "$trailingws_"
    else
    # Only remove trailing WS for the rest
        echo "Removing trailing whitespace: $name" >&2
        cat "$name" \
        | sed "$trailingws_"
    fi >"$temp"


A function to print out error messages along with other status information is recommended.
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

if ! do_something; then
  err "Unable to do_something"
  exit "${E_DID_NOTHING}"
fi

标准打印错误消息的方式 来自google



case
The syntax of the case command is:
case word in
    [ [(] pattern [| pattern]…) command-list ;;]…
esac
case will selectively execute the command-list corresponding to the first pattern that matches word. The match is performed according to the rules described below in Pattern Matching. If the nocasematch shell option (see the description of shopt in The Shopt Builtin) is enabled, the match is performed without regard to the case of alphabetic characters. The ‘|’ is used to separate multiple patterns, and the ‘)’ operator terminates a pattern list. A list of patterns and an associated command-list is known as a clause.
Each clause must be terminated with ‘;;’, ‘;&’, or ‘;;&’. The word undergoes tilde expansion, parameter expansion, command substitution, arithmetic expansion, and quote removal (see Shell Parameter Expansion) before matching is attempted. Each pattern undergoes tilde expansion, parameter expansion, command substitution, and arithmetic expansion.
There may be an arbitrary number of case clauses, each terminated by a ‘;;’, ‘;&’, or ‘;;&’. The first pattern that matches determines the command-list that is executed. It’s a common idiom to use ‘*’ as the final pattern to define the default case, since that pattern will always match.
Here is an example using case in a script that could be used to describe one interesting feature of an animal:
echo -n "Enter the name of an animal: "
read ANIMAL
echo -n "The $ANIMAL has "
case $ANIMAL in
  horse | dog | cat) echo -n "four";;
  man | kangaroo ) echo -n "two";;
  *) echo -n "an unknown number of";;
esac
echo " legs."
If the ‘;;’ operator is used, no subsequent matches are attempted after the first pattern match. Using ‘;&’ in place of ‘;;’ causes execution to continue with the command-list associated with the next clause, if any. Using ‘;;&’ in place of ‘;;’ causes the shell to test the patterns in the next clause, if any, and execute any associated command-list on a successful match.
The return status is zero if no pattern is matched. Otherwise, the return status is the exit status of the command-list executed.


Bash 执行的命令来自builtin  函数或者是外部命令，所有的外部命令都是通过subshell 来执行；查找命令的时候，如果是明确指定路径的，肯定是按照特定路径的执行，如果没有就按照，先函数后builtin 最后通过path路径进行查找进行执行；

&命令是指的是后台进程，但是当控制终端退出的时候，他也会退出，如果想不退出，就需要通过nohup 启动后台进程；

Shift 命令可以遍历不知道有多少个参数的应用场景； 每次处理完一个参数可以shift一次；然后循环进行处理；


Shortcuts to move faster in Bash command line

Basic moves
* Move back one character. Ctrl + b
* Move forward one character. Ctrl + f
* Delete current character. Ctrl + d
* Delete previous character. Backspace
* Undo. Ctrl + -

Moving faster
* Move to the start of line. Ctrl + a
* Move to the end of line. Ctrl + e
* Move forward a word. Meta + f (a word contains alphabets and digits, no symbols)
* Move backward a word. Meta + b
* Clear the screen. Ctrl + l
What is Meta? Meta is your Alt key, normally. For Mac OSX user, you need to enable it yourself. Open Terminal > Preferences > Settings > Keyboard, and enable Use option as meta key. Meta key, by convention, is used for operations on word.

Cut and paste (‘Kill and yank’ for old schoolers)
* Cut from cursor to the end of line. Ctrl + k
* Cut from cursor to the end of word. Meta + d
* Cut from cursor to the start of word. Meta + Backspace
* Cut from cursor to previous whitespace. Ctrl + w
* Paste the last cut text. Ctrl + y
* Loop through and paste previously cut text. Meta + y (use it after Ctrl + y)
* Loop through and paste the last argument of previous commands. Meta + .

Search the command history
* Search as you type. Ctrl + r and type the search term; Repeat Ctrl + r to loop through results.
* Search the last remembered search term. Ctrl + r twice.
* End the search at current hisvtory entry. Ctrl + j
* Cancel the search and restore original line. Ctrl + g


Chmod 典型用法
Chmod. ugoa+/-/=rwx,ugoa+/-/=rwx file
#！用处：通过可执行文件执行这个文件的时候，可以辅助os确实能够是用哪个解释器使用，其他场景下知识一条普通的注释而已；而且起作用的时候必须是文件的第一行第一列开始，其余的都不起作用；


linux bash shell中，单引号、 双引号，反引号（``）的区别及各种括号的区别

一、单引号和双引号
首先，单引号和双引号，都是为了解决中间有空格的问题。
因为空格在linux中时作为一个很典型的分隔符，比如string1=this is astring，这样执行就会报错。为了避免这个问题，因此就产生了单引号和双引号。他们的区别在于，单引号将剥夺其中的所有字符的特殊含义，而双引号中的'$'（参数替换）和'`'（命令替换）是例外。所以，两者基本上没有什么区别，除非在内容中遇到了参数替换符$和命令替换符`。
所以下面的结果： num=3 echo ‘$num’ $num echo “$num” 3 所以，如果需要在双引号””里面使用这两种符号，需要用反斜杠转义。 
 
二、反引号``
这个东西的用法，我百度了一下，和$()是一样的。在执行一条命令时，会先将其中的 ``，或者是$() 中的语句当作命令执行一遍，再将结果加入到原命令中重新执行，例如： echo `ls` 会先执行 ls 得到xx.sh等，再替换原命令为： echo xx.sh 最后执行结果为 xx.sh 那么，平时我们遇到的把一堆命令的执行结果输出到一个变量中，需要用这个命令替换符括起来，也就可以理解了。 这里又涉及到了一个问题，虽然不少系统工程师在使用替换功能时，喜欢使用反引号将命令括起来。但是根据POSIX规范，要求系统工程师采用的是$(命令)的形式。所以，我们最好还是遵循这个规范，少用``，多用$() 
 
三、小括号，中括号，和大括号的区别
那么，下面又涉及到了一个问题，就是小括号，中括号，和大括号的区别。 先说说小括号和大括号的区别。这两者，实际上是“命令群组”的概念，也就是commandgroup。 ( ) 把 command group 放在subshell去执行，也叫做 nested sub-shell。 { } 则是在同一个 shell 內完成，也称为 non-namedcommand group。 所以说，如果在shell里面执行“函数”，需要用到{}，实际上也就是一个命令群组么。 不过，根据实测，test=$(ls -a)可以执行，但是test=${ls–a}语法上面是有错误的。估计也和上面所说的原因有关。  另外，从网上摘录的区别如下： A,()只是对一串命令重新开一个子shell进行执行 B,{}对一串命令在当前shell执行 C,()和{}都是把一串的命令放在括号里面，并且命令之间用;号隔开 D,()最后一个命令可以不用分号 E,{}最后一个命令要用分号 F,{}的第一个命令和左括号之间必须要有一个空格 G,()里的各命令不必和括号有空格 H,()和{}中括号里面的某个命令的重定向只影响该命令，但括号外的重定向则影响到括号里的所有命令  两个括号(())，是代表算数扩展，就是对其包括的东西进行标准的算数计算——注意，不能算浮点数，如果需要算浮点数，需要用bc做。  至于中括号[]，感觉作用就是用来比较的。比如放在if语句里面，while语句里面，等等。 这里引出来[..]和[[…]]的区别：（摘自网上，实测证实）：使用[[... ]]条件判断结构, 而不是[ ... ], 能够防止脚本中的许多逻辑错误.比如,&&, ||, <,和> 操作符能够正常存在于[[ ]]条件判断结构中, 但是如果出现在[ ]结构中的话,会报错。



在 bash 中，常用的 quoting 有如下三种方法：
1) hard quote：' ' (单引号)，凡在 hard quote 中的所有 meta 均被关闭。
2) soft quote： " " (双引号)，在 soft quoe 中大部份 meta 都会被关闭，但某些则保留(如 $ )。
3) escape ： \ (反斜线)，只有紧接在 escape (转义字符)之后的单一 meta 才被关闭。
常用的meta
IFS：由 <space> 或 <tab> 或 <enter> 三者之一组成(我们常用 space )。
CR：由<enter> 产生。
    IFS 是用来拆解command line 的每一个词(word)用的，因为shell command line 是按词来处理的。
    而 CR 则是用来结束 command line 用的，这也是为何我们敲 <enter> 命令就会跑的原因。
除了 IFS 与 CR ，常用的 meta 还有：
= ：  设定变量。
$ ：  作变量或运算替换(请不要与 shell prompt 搞混了)。
> ：重导向 stdout。
< ：重导向 stdin。
|：命令管线。
& ：重导向 file descriptor ，或将命令置于背境执行。
( )：将其内的命令置于 nested subshell 执行，或用于运算或命令替换。
{ }：将其内的命令置于 non-named function 中执行，或用在变量替换的界定范围。
; ：在前一个命令结束时，而忽略其返回值，继续执行下一个命令。
&& ：在前一个命令结束时，若返回值为 true，继续执行下一个命令。
|| ：在前一个命令结束时，若返回值为 false，继续执行下一个命令。
!：执行 history 列表中的命令
....
例一：假设A=bbbb
jack@ubuntu:~$ echo -e "$A"    #echo -e 表示开启转义字符，否则如果你有\字符的号，它只是原样输出，而不会转义。
bbbb
jack@ubuntu:~$ echo -e '"$A"'      #最外面是单引号
"$A"
jack@ubuntu:~$ echo -e "'"$A"'"   #最外面是双引号
'bbbb'
首先看最外面是什么符号，单引号表示hard quote，双引号表示soft quote。
soft quote则$A就是变量啦；若是hard quote那直接就是字符串。
在 awk 或 sed 的命令参数中调用之前设定的一些变量时，常会问及为何不能的问题。
要解决这些问题，关键点就是：
区分出 shell meta 与 command meta
前面我们提到的那些 meta ，都是在 command line 中有特殊用途的，
比方说 { } 是将其内一系列 command line 置于不具名的函式中执行(可简单视为 command block )，
但是，awk 却需要用 { } 来区分出 awk 的命令区段(BEGIN, MAIN, END)。
若你在 command line 中如此输入：
$ awk {print $0} 1.txt
由于  {} 在 shell 中并没关闭，那 shell 就将 {print $0} 视为 command block ，
但同时又没有" ; "符号作命令区隔，因此就出现 awk 的语法错误结果。
要解决之，可用 hard quote ：
$ awk '{print $0}' 1.txt
上面的 hard quote 应好理解，就是将原本的 {、<space>、$(注三)、} 这几个 shell meta 关闭，避免掉在 shell 中遭到处理，而完整的成为 awk 参数中的 command meta 。
( 注三：而其中的 $0 是 awk 内建的 field number ，而非  awk 的变量，awk 自身的变量无需使用 $ 。)
实际上可以写成：
awk"{print \$0}" 1.txt
awk \{print\ \$0\} 1.txt
但是现在我想把awk 的 $0 的 0 值是从另一个 shell 变量读进，怎么办？
如下方式可否：
$ awk '{print $$A}' 1.txt
答案不行，因为 $A 的 $ 在 hard quote 中是不能替换变量的。
使用awk外面的变量可这样：
A=0
1) awk "{print \$$A}" 1.txt
2) awk \{print\ \$$A\} 1.txt
3) awk '{print $'$A'}'1.txt      # $A没被任何引号隔开（不要以为两边有引号就是它的），所以实际上是shell变量啦。
4) awk '{print $'"$A"'}' 1.txt   #$A两边使用的是双引号，其它为单引号。
如果要在awk中输出外部变量怎么办？
看特殊形式：awk '{print "abc"}' #print后面的字符串要用双引号
一般形式： awk '{print "'$A'"}'   # $A左右两边都有单引号，其实就是上面的3)式。
--------------------- 
作者：LevinLin 
来源：CSDN 
原文：https://blog.csdn.net/shandianling/article/details/8976062 
版权声明：本文为博主原创文章，转载请附上博文链接！


