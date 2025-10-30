local std = import 'std';
local cfgLib = import '../../lib/config.libsonnet';

local components = {
  postfix: import '../../components/postfix.libsonnet',
  dovecot: import '../../components/dovecot.libsonnet',
  nginx: import '../../components/nginx.libsonnet',
  opendkim: import '../../components/opendkim.libsonnet',
  chatmaild: import '../../components/chatmaild.libsonnet',
  acmetool: import '../../components/acmetool.libsonnet',
  mtail: import '../../components/mtail.libsonnet',
  irohRelay: import '../../components/iroh-relay.libsonnet',
  turnserver: import '../../components/turnserver.libsonnet',
  metrics: import '../../components/metrics.libsonnet',
  web: import '../../components/web.libsonnet',
};

local values = import './values.libsonnet';
local cfg = cfgLib.normalize(values.config);
local features = values.features;

local featureEnabled(name) =
  if name == 'postfix' || name == 'dovecot' || name == 'chatmaild' then (features.enableMail == null || features.enableMail)
  else if name == 'irohRelay' then cfg.enable_iroh_relay && (features.enableIrohRelay == null || features.enableIrohRelay)
  else if name == 'mtail' then cfg.mtail_address != null && (features.enableMtail == null || features.enableMtail)
  else true;

{
  config: cfg,
  features: features,
  plans: std.mapWithKey(function(name, component) component.plan, components),
  rendered:
    std.mapWithKey(
      function(name, component)
        if featureEnabled(name) then component.resources(cfg) else null,
      components,
    ),
}
