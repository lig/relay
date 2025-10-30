// Placeholder for chatmaild service deployments and cron conversions.

local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Convert chatmaild systemd services and timers into Deployments and CronJobs.',
    sources: [
      'cmdeploy/src/cmdeploy/service/doveauth.service.f',
      'cmdeploy/src/cmdeploy/service/filtermail.service.f',
      'cmdeploy/src/cmdeploy/service/filtermail-incoming.service.f',
      'cmdeploy/src/cmdeploy/service/echobot.service.f',
      'cmdeploy/src/cmdeploy/service/chatmail-metadata.service.f',
      'cmdeploy/src/cmdeploy/service/lastlogin.service.f',
      'cmdeploy/src/cmdeploy/service/turnserver.service.f',
      'cmdeploy/src/cmdeploy/service/chatmail-expire.service.f',
      'cmdeploy/src/cmdeploy/service/chatmail-expire.timer.f',
      'cmdeploy/src/cmdeploy/service/chatmail-fsreport.service.f',
      'cmdeploy/src/cmdeploy/service/chatmail-fsreport.timer.f',
      'cmdeploy/src/cmdeploy/metrics.cron.j2',
    ],
    k8sMapping: [
      'Deployments for doveauth, filtermail, metadata, lastlogin, echobot',
      'CronJobs for chatmail-expire and chatmail-fsreport schedules',
      'ConfigMaps or Secrets for chatmail.ini and runtime sockets',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement chatmaild manifests',
      mailDomain: cfg.mail_domain,
      timers: {
        expire: '00:02:00',
        fsreport: '08:02:00',
      },
    },
}
