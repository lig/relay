// Placeholder for nginx deployment, TLS endpoints, and CGI wiring.

local config = import '../lib/config.libsonnet';

{
  plan: {
    summary: 'Containerize nginx.conf, autoconfig XML, and MTA-STS templates with TLS assets.',
    sources: [
      'cmdeploy/src/cmdeploy/nginx/nginx.conf.j2',
      'cmdeploy/src/cmdeploy/nginx/autoconfig.xml.j2',
      'cmdeploy/src/cmdeploy/nginx/mta-sts.txt.j2',
      'chatmaild/src/chatmaild/newemail.py',
    ],
    k8sMapping: [
      'Deployment exposing HTTPS/stream listener via Service + (optionally) Ingress',
      'ConfigMaps mounting templated nginx configuration',
      'Sidecar or Job for fcgiwrap / CGI handler',
    ],
  },

  resources(rawCfg):
    local cfg = config.normalize(rawCfg);
    {
      todo: 'Implement nginx manifests',
      domain: cfg.mail_domain,
      disableIPv6: cfg.disable_ipv6,
    },
}
