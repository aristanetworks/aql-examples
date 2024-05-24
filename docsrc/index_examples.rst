AQL Examples
============

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   examples/interface_states/index
   examples/layer2_and_layer3/index
   examples/system_health/index

.. _terminattrStreamingPermitlistNote:

.. note::
   Some telemetry states are not streamed by default and they would need to be added to the TerminAttr include list using the tastreaming.TerminattrStreaming service API, e.g.:

   On-prem example:

   ::

      curl -sS -kX POST --header 'Accept: application/json' -b access_token=`cat token` \
         'https://192.0.2.1/api/v3/services/tastreaming.TerminattrStreaming/SubscribeTAPaths' \

         -d '{ "filter": { "app_name": "app1", "include_paths": [ "/Sysdb/bridging/igmpsnooping" ]}}'

   CVaaS example:

   ::

      curl -sS -kX POST --header 'Accept: application/json' -b access_token=`cat token` \
         'https://www.arista.io/api/v3/services/tastreaming.TerminattrStreaming/SubscribeTAPaths' \

         -d '{ "filter": { "app_name": "app1", "include_paths": [ "/Sysdb/bridging/igmpsnooping" ]}}'

   Result:

   ::

      [{}]

   For CVaaS please make sure to use the correct regional URL:

   - United States 1a: **www.cv-prod-us-central1-a.arista.io**
   - United States 1c: **www.cv-prod-us-central1-c.arista.io**
   - Japan: **www.cv-prod-apnortheast-1.arista.io**
   - Germany: **www.cv-prod-euwest-2.arista.io**
   - Australia: **www.cv-prod-ausoutheast-1.arista.io**
   - Canada: **www.cv-prod-na-northeast1-b.arista.io**
   - United Kingdom: **www.cv-prod-uk-1.arista.io**