#!/bin/bash

USER=$(whoami)
USER_LOWER="${USER,,}"
WORKDIR="/home/${USER_LOWER}/.nezha-agent"
CRON_NEZHA="nohup ${WORKDIR}/start.sh >/dev/null 2>&1 && cd xray && nohup ./xray -c config.json >/dev/null 2>&1 &"
REBOOT_COMMAND="@reboot pkill -kill -u $USER && $PM2_PATH resurrect >> /home/$USER/pm2_resurrect.log 2>&1"

echo "检查并添加 crontab 任务"

# 添加 pm2 保活任务
  # 检查所需文件是否存在，并添加 crontab 任务

 
  if [ -e "${WORKDIR}/start.sh" ]; then
    echo "添加 nezha 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $USER && ${CRON_NEZHA}") || (crontab -l; echo "@reboot pkill -kill -u $USER && ${CRON_NEZHA}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") || (crontab -l; echo "*/12 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}") | crontab -
 
fi

echo "crontab 任务添加完成"
