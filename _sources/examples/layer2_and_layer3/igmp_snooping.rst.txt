IGMP Snooping Table
-------------------

.. note::
   IGMP Snooping states are not streamed by default and the "/Sysdb/bridging/igmpsnooping" needs to be added to the TerminAttr include list using the tastreaming.TerminattrStreaming service API.
   Examples can be found on `Examples <../../index_examples.html#terminattrstreamingpermitlistnote>`_


.. literalinclude:: igmp_snooping.aql
   :language: aql

.. image:: igmp_snooping.png
   :width: 600
   :alt: IGMP Snooping Table


:download:`Download the Dashboard JSON here <igmp_snooping.json>`
