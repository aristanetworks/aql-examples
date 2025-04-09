Language revisions / Change log
===============================

Revision per CloudVision release
--------------------------------

.. csv-table::
   :file: changelog_revision_per_release.csv
   :header-rows: 1

Change log
----------

Revision 5
^^^^^^^^^^

- `Per-field queries <index_doc.html#fields>`_
- Special strings (single quotes) with `JSON support <index_doc.html#json-support>`_
- `String literals with single quotes <index_doc.html#str>`_
- `Filtered wildcards <index_doc.html#filtered-wildcards>`_
- :ref:`dict` s can now be used as complex keys when their keys are of type :ref:`str`
- Extended support for complex keys and :ref:`unknown` values
- :ref:`length` can now be used with map and list complex keys
- `For loops <index_doc.html#for-loop>`_ can now be used with map and list complex keys
- The `square bracket operator <index_doc.html#square-bracket-operator>`_ can now be used to access values from map and list complex keys
- Function :ref:`mergeDicts`
- Function :ref:`listToTimeseries`
- Function :ref:`errvl`
- Function :ref:`formatBits`
- Function :ref:`parseInt`
- Function :ref:`strJoin`
- Function :ref:`dictToJson`
- Function :ref:`jsonToDict`
- Function :ref:`dictValue`
- Function :ref:`timeseriesStart`
- Function :ref:`timeseriesEnd`
- Function :ref:`timeAtIndex`
- Filter :ref:`mapkv`

Revision 4
^^^^^^^^^^

- Function :ref:`aggregate`
- Function :ref:`unnestTimeseries`
- Function :ref:`formatInt`
- Function :ref:`formatFloat`
- Function :ref:`strCut`
- Filter :ref:`applyDeletes`

Revision 3
^^^^^^^^^^

- Support for `named wildcards <index_doc.html#namedwildcards>`_ replaces variable substitution
- Function :ref:`linregression`
- Function :ref:`ewlinregression`
- Filter :ref:`fields`
- Filter :ref:`setFields`
- Filter :ref:`renameFields`
- Filter :ref:`topK`
- Filter :ref:`bottomK`

Revision 2
^^^^^^^^^^

No change to the AQL syntax or standard library.
