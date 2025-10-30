// Placeholder for auxiliary metrics jobs (chatmail-metrics cron).

local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Represent chatmail-metrics cron task as Kubernetes CronJob with ConfigMap-backed script.',
    sources: [
      'cmdeploy/src/cmdeploy/metrics.cron.j2',
    ],
    k8sMapping: [
      'CronJob invoking chatmail-metrics binary via container image',
      'Secret or ConfigMap providing chatmail.ini path and credentials',
      'ServiceAccount/Role to restrict access to required ConfigMaps/Secrets',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement chatmail-metrics CronJob',
      mailboxesDir: cfg.mailboxes_dir,
    },
}
