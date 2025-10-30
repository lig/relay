// Placeholder for OpenDKIM deployment and key management.

local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Package OpenDKIM configuration and private keys into Kubernetes Secrets and workloads.',
    sources: [
      'cmdeploy/src/cmdeploy/opendkim/opendkim.conf',
      'cmdeploy/src/cmdeploy/opendkim/KeyTable',
      'cmdeploy/src/cmdeploy/opendkim/SigningTable',
      'cmdeploy/src/cmdeploy/opendkim/final.lua',
      'cmdeploy/src/cmdeploy/opendkim/screen.lua',
    ],
    k8sMapping: [
      'Deployment mounting DKIM keys from Secrets',
      'CronJob or controller to rotate keys if required',
      'ConfigMap for Lua screening scripts',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement OpenDKIM manifests',
      selector: 'opendkim',
      mailDomain: cfg.mail_domain,
    },
}
