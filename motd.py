#!/usr/bin/env python
import psutil
import datetime
from psutil._common import bytes2human


class bcolors:
    rev = '\033[7m'
    rev_end = '\033[27m'
    trans = '\033[2m'
    trans_end = '\033[22m'


sys_load = [round(float(i), 2) for i in
            psutil.getloadavg()]
uptime = datetime.datetime.now() - \
        datetime.datetime.fromtimestamp(psutil.boot_time())

print(bcolors.rev + 'w e l c o m e\nh o m e' + bcolors.rev_end)
print(bcolors.trans + 'system load:', *sys_load, end='')
print('\tmemory usage: ', round(psutil.virtual_memory().percent),
      '%', sep='', end='')
print('\tprocesses:', len(psutil.pids()))
print('usage of /: ', round(psutil.disk_usage('/').percent), '% (',
      bytes2human(psutil.disk_usage('/').used), '/', bytes2human(
          psutil.disk_usage('/').total), ')', sep='', end='')
print('\tswap usage: ', round(psutil.swap_memory().percent),
      '%', sep='', end='')
print('\t\tuptime: ', end='')
print(*str(uptime).split(':')[0:-1], sep=":", end='')
print(bcolors.trans_end)
