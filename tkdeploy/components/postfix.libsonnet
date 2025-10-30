// Placeholder for Postfix StatefulSet, services and configuration ConfigMaps.

local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Render Postfix configuration (main.cf, master.cf, login_map) and runtime workloads.',
    sources: [
      'cmdeploy/src/cmdeploy/postfix/main.cf.j2',
      'cmdeploy/src/cmdeploy/postfix/master.cf.j2',
      'cmdeploy/src/cmdeploy/postfix/login_map',
      'cmdeploy/src/cmdeploy/postfix/submission_header_cleanup',
    ],
    k8sMapping: [
      'StatefulSet with PVCs covering /var/spool/postfix',
      'ConfigMaps for templated Postfix configs',
      'Services exposing SMTP (25/465/587) and reinjection ports',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement Postfix manifests',
      mailDomain: cfg.mail_domain,
      reinjectPorts: [cfg.postfix_reinject_port, cfg.postfix_reinject_port_incoming],
    },
}
