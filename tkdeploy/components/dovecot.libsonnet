// Placeholder for Dovecot StatefulSet, volumes, and push-notification hooks.

local std = import 'std';
local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Translate dovecot.conf, auth.conf, and push_notification.lua into Kubernetes workloads.',
    sources: [
      'cmdeploy/src/cmdeploy/dovecot/dovecot.conf.j2',
      'cmdeploy/src/cmdeploy/dovecot/auth.conf',
      'cmdeploy/src/cmdeploy/dovecot/push_notification.lua',
    ],
    k8sMapping: [
      'StatefulSet exposing IMAP/IMAPS with host or LoadBalancer services',
      'Persistent storage for /home/vmail maildirs',
      'ConfigMap-mounted Lua scripts and auth configuration',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement Dovecot manifests',
      mailboxesDir: std.format('%s', cfg.mailboxes_dir),
    },
}
