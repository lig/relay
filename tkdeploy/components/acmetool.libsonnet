// Placeholder for acmetool orchestration or cert-manager migration notes.

local std = import 'std';
local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Run acmetool/redirector via Deployment+CronJob or document cert-manager integration.',
    sources: [
      'cmdeploy/src/cmdeploy/acmetool/acmetool-redirector.service',
      'cmdeploy/src/cmdeploy/acmetool/acmetool.cron',
      'cmdeploy/src/cmdeploy/acmetool/acmetool.hook',
      'cmdeploy/src/cmdeploy/acmetool/response-file.yaml.j2',
      'cmdeploy/src/cmdeploy/acmetool/target.yaml.j2',
    ],
    k8sMapping: [
      'Deployment for redirector component handling HTTP challenges',
      'CronJob for periodic acme renewal tasks',
      'Secret/ConfigMap for ACME account data and hook scripts',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement acmetool manifests or document cert-manager handoff',
      domains: [cfg.mail_domain, std.format('mta-sts.%s', cfg.mail_domain), std.format('www.%s', cfg.mail_domain)],
      contact: cfg.acme_email,
    },
}
