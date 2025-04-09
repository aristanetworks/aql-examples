.. _field:

field
^^^^^

:guilabel:`Added in revision 1`

Filter ``field`` applies to a :ref:`timeseries` of :ref:`dicts <dict>`. Returns a :ref:`timeseries` of the value at the
specified key for each entry of the :ref:`timeseries` that contains this field. Entries that don't
contain the key are not in the output :ref:`timeseries`.

* The filtered value is a :ref:`timeseries` of :ref:`dicts <dict>`
* The first and only parameter is the key to keep in the :ref:`dicts <dict>`

.. code:: aqlp

    >>> `analytics:/path/to/data`[1]
    timeseries{
        tstamp1: dict{key1: val1, key2: val2, key3: val3}
        tstamp2: dict{key1: val4, key2: val5}
    }
    >>> _ | field("key1")
    timeseries{
        tstamp1: val1
        tstamp2: val4
    }

.. _fields:

fields
^^^^^^

:guilabel:`Added in revision 3`

Filter ``fields`` applies to a :ref:`dict`. It filters it and returns a new dict containing only the
key/value pairs whose key is passed as parameter.

* The filtered value is a :ref:`dict`
* There is a variable (:math:`0` to :math:`n`) number of parameters: they are the keys to keep in the output dict

.. note::

    If a specified key is missing from the source :ref:`dict`, the filter will not fail but the
    output :ref:`dict` will also be missing that key

.. code:: aqlp

    >>> let d = `analytics:/path/to/data/*` | map(merge(_value))
    >>> d
    dict{
        key0: dict{key1: val1, key2: val2, key3: val3}
        key01: dict{key1: val4, key2: val5}
        key02: dict{key1: val6, key2: val7}
    }
    >>> d | fields("key0", "key01")
    dict{
        key0: dict{key1: val1, key2: val2, key3: val3}
        key01: dict{key1: val4, key2: val5}
    }
    >>> d | fields("k")
    dict{
    }
    >>> d | fields()
    dict{
    }
    >>> d | fields("key01") | map(_value | fields("key2"))
    dict{
        key01: dict{key2: val5}
    }

.. _setFields:

setFields
^^^^^^^^^

:guilabel:`Added in revision 3`

Filter ``setFields`` sets some key/value pairs in a :ref:`dict`. If the key already existed in the
filtered :ref:`dict`, its value will be replaced with the new one in the output :ref:`dict` (like all filters,
``setFields`` returns a filtered copy of the :ref:`dict` and does not alter the source). If the key did not
exist in the filtered :ref:`dict`, the key/value pair will just be added to the output :ref:`dict`.

* The filtered value is a `dict`
* There is a variable (0 to n) even number of parameters: they correspond to the list of key/value
  pairs

.. code:: aqlp

    >>> let d = newDict() | setFields("k1", "v1", "k2", 2.3, "k3", 3)
    >>> d
    dict{
        k1: v1
        k2: 2.3
        k3: 3
    }
    >>> d | setFields("k4", newDict() | setFields("k5", "v5"))
    dict{
        k1: v1
        k2: 2.3
        k3: 3
        k4: dict{
            k5: v5
        }
    }
    >>> d
    dict{
        k1: v1
        k2: 2.3
        k3: 3
    } # the source dict is not altered

.. _applyDeletes:

applyDeletes
^^^^^^^^^^^^

:guilabel:`Added in revision 4`

Filter ``applyDeletes`` applies the deletes to a :ref:`timeseries`. This :ref:`timeseries` must be freshly returned by a query.
Most filters remove the deletes information from :ref:`timeseries`, so this should be called before any other filter or function.

If no argument is passed, applying a delete will remove all entries with that delete's key that were updated prior to the delete
itself. This use-case is mostly appropriate when used with the result of a query that does not contain historical data (state-only).
With historical data, this would wipe deleted entries from ever having existed in the :ref:`timeseries`, instead of signaling the end
of the entry at the moment of deletion.

If an argument is passed, then the expression defines a value that will be written at the moment of the delete for that key.
This use-case is more appropriate with historical data because it will not remove entries, but instead create an entry that signals
the end of the value.

* The filtered value is a :ref:`timeseries` that still contains delete information.
* The only and optional parameter is the expression. Its value can be of any type after evaluation. 

Usable metavariables in the expression are:

    * ``_key`` or ``_1``: key matching the delete
    * ``_index``: index of the delete in the :ref:`timeseries`
    * ``_updindex``: index of the last update for this key in the :ref:`timeseries`
    * ``_time`` or ``_2``: :ref:`time` of the delete in the :ref:`timeseries`
    * ``_updtime``: :ref:`time` of the last update for this key in the :ref:`timeseries`
    * ``_value`` or ``_3``: last value prior to the delete for the deleted key
    * ``_src`` or ``_4``: reference to the :ref:`timeseries` being filtered

.. TODO: make a shorter example to put outside of collapse block

.. collapse:: Example

    .. code:: aqlp

        >>> let a = `analytics:/tags/BugAlerts/SubscriptionQueryTag.v1/gNMIEnabled`[5]
        >>> a
        timeseries{
            start: 2021-03-17 02:48:58.205235103 +0100 CET
            end: 2022-10-19 13:30:33.722908 +0200 CEST
            2021-03-17 02:48:58.205235103 +0100 CET: dict{
                JAS12200014: true
                JAS16040045: true
                JAS17250006: true
                JAS17250010: true
                JAS17510146: true
                JPE14171444: true
                JPE17191574: true
                SSJ17371234: true
            }
            2021-05-12 17:32:58.269740014 +0200 CEST: dict{
                HSH14075043: true
                HSH14075051: true
            }
            2021-11-03 17:09:46.753872494 +0100 CET: dict{
                HSH14280171: true
                HSH14420467: true
                JPE14250224: true
                JPE14383408: true
                SSJ17049015: true
                SSJ17374660: true
            }
            2021-11-11 05:09:22.273451668 +0100 CET: dict{
                JAS14170008: true
                JAS14210057: true
                JAS17070003: true
                JAS18170075: true
                JPE14120478: true
                JPE19280519: true
            }
            2022-02-18 23:08:10.204460235 +0100 CET: dict{
                2568DB4A33177968A78C4FD5A8232159: true
                6323DA7D2B542B5D09630F87351BEA41: true
                BAD032986065E8DC14CBB6472EC314A6: true
                CD0EADBEEA126915EA78E0FB4DC776CA: true
            }
            2022-02-22 00:48:45.347884243 +0100 CET: dict{0123F2E4462997EB155B7C50EC148767: true}
            2022-07-18 18:10:07.772750473 +0200 CEST: dict{JPE20244151: true}
        }
        >>> deletes(a)
        timeseries{
            start: 2021-03-17 02:48:58.205235103 +0100 CET
            end: 2022-10-19 13:30:33.722908 +0200 CEST
            2021-11-23 11:09:21.716099165 +0100 CET: dict{
                HSH14075043: <nil>
                HSH14075051: <nil>
                HSH14280171: <nil>
                HSH14420467: <nil>
                JAS14170008: <nil>
                JAS14210057: <nil>
                JAS16040045: <nil>
                JAS17070003: <nil>
                JAS17250006: <nil>
                JAS17250010: <nil>
                JAS17510146: <nil>
                JAS18170075: <nil>
                JPE14120478: <nil>
                JPE14171444: <nil>
                JPE14250224: <nil>
                JPE14383408: <nil>
                JPE17191574: <nil>
                JPE19280519: <nil>
                SSJ17049015: <nil>
                SSJ17371234: <nil>
                SSJ17374660: <nil>
            }
            2022-02-22 00:48:45.347884243 +0100 CET: dict{
                2568DB4A33177968A78C4FD5A8232159: <nil>
                6323DA7D2B542B5D09630F87351BEA41: <nil>
                BAD032986065E8DC14CBB6472EC314A6: <nil>
                CD0EADBEEA126915EA78E0FB4DC776CA: <nil>
            }
        }
        >>> a | applyDeletes()
        timeseries{
            start: 2021-03-17 02:48:58.205235103 +0100 CET
            end: 2022-10-19 13:30:33.722908 +0200 CEST
            2021-03-17 02:48:58.205235103 +0100 CET: dict{JAS12200014: true}
            2022-02-22 00:48:45.347884243 +0100 CET: dict{0123F2E4462997EB155B7C50EC148767: true}
            2022-07-18 18:10:07.772750473 +0200 CEST: dict{JPE20244151: true}
        }
        >>> a | applyDeletes(_key+" is deleted, its value was " + str(_value))
        timeseries{
            start: 2021-03-17 02:48:58.205235103 +0100 CET
            end: 2022-10-19 13:30:33.722908 +0200 CEST
            2021-03-17 02:48:58.205235103 +0100 CET: dict{
                JAS12200014: true
                JAS16040045: true
                JAS17250006: true
                JAS17250010: true
                JAS17510146: true
                JPE14171444: true
                JPE17191574: true
                SSJ17371234: true
            }
            2021-05-12 17:32:58.269740014 +0200 CEST: dict{
                HSH14075043: true
                HSH14075051: true
            }
            2021-11-03 17:09:46.753872494 +0100 CET: dict{
                HSH14280171: true
                HSH14420467: true
                JPE14250224: true
                JPE14383408: true
                SSJ17049015: true
                SSJ17374660: true
            }
            2021-11-11 05:09:22.273451668 +0100 CET: dict{
                JAS14170008: true
                JAS14210057: true
                JAS17070003: true
                JAS18170075: true
                JPE14120478: true
                JPE19280519: true
            }
            2021-11-23 11:09:21.716099165 +0100 CET: dict{
                HSH14075043: HSH14075043 is deleted, its value was true
                HSH14075051: HSH14075051 is deleted, its value was true
                HSH14280171: HSH14280171 is deleted, its value was true
                HSH14420467: HSH14420467 is deleted, its value was true
                JAS14170008: JAS14170008 is deleted, its value was true
                JAS14210057: JAS14210057 is deleted, its value was true
                JAS16040045: JAS16040045 is deleted, its value was true
                JAS17070003: JAS17070003 is deleted, its value was true
                JAS17250006: JAS17250006 is deleted, its value was true
                JAS17250010: JAS17250010 is deleted, its value was true
                JAS17510146: JAS17510146 is deleted, its value was true
                JAS18170075: JAS18170075 is deleted, its value was true
                JPE14120478: JPE14120478 is deleted, its value was true
                JPE14171444: JPE14171444 is deleted, its value was true
                JPE14250224: JPE14250224 is deleted, its value was true
                JPE14383408: JPE14383408 is deleted, its value was true
                JPE17191574: JPE17191574 is deleted, its value was true
                JPE19280519: JPE19280519 is deleted, its value was true
                SSJ17049015: SSJ17049015 is deleted, its value was true
                SSJ17371234: SSJ17371234 is deleted, its value was true
                SSJ17374660: SSJ17374660 is deleted, its value was true
            }
            2022-02-18 23:08:10.204460235 +0100 CET: dict{
                2568DB4A33177968A78C4FD5A8232159: true
                6323DA7D2B542B5D09630F87351BEA41: true
                BAD032986065E8DC14CBB6472EC314A6: true
                CD0EADBEEA126915EA78E0FB4DC776CA: true
            }
            2022-02-22 00:48:45.347884243 +0100 CET: dict{
                2568DB4A33177968A78C4FD5A8232159: 2568DB4A33177968A78C4FD5A8232159 is deleted, its value was true
                6323DA7D2B542B5D09630F87351BEA41: 6323DA7D2B542B5D09630F87351BEA41 is deleted, its value was true
                BAD032986065E8DC14CBB6472EC314A6: BAD032986065E8DC14CBB6472EC314A6 is deleted, its value was true
                CD0EADBEEA126915EA78E0FB4DC776CA: CD0EADBEEA126915EA78E0FB4DC776CA is deleted, its value was true
            }
            2022-02-22 00:48:45.347884243 +0100 CET: dict{0123F2E4462997EB155B7C50EC148767: true}
            2022-07-18 18:10:07.772750473 +0200 CEST: dict{JPE20244151: true}
        }

.. _renameFields:

renameFields
^^^^^^^^^^^^

:guilabel:`Added in revision 3`

Filter ``renameFields`` renames some keys in a :ref:`dict`. The keys which are not specified in the
arguments will be kept in the output dict. Use the :ref:`fields` filter to remove them.

* The filtered value is a :ref:`dict`
* There is a variable (:math:`0` to :math:`n`) even number of parameters: they correspond to the list of old-key/new-key pairs

.. note::

    If a specified key is missing from the source dict, the filter will not fail and that pair
    will just be ignored

.. code:: aqlp

    >>> let d = `analytics:/path/to/data/*` | map(merge(_value))
    >>> d
    dict{
        key0: dict{key1: val1, key2: val2, key3: val3}
        key01: dict{key1: val4, key2: val5}
    }
    >>> d | renameFields("key0", "newkey0")
    dict{
        newkey0: dict{key1: val1, key2: val2, key3: val3}
        key01: dict{key1: val4, key2: val5}
    }
    >>> d | renameFields("key0", "newkey0", "key01", "newkey01")
    dict{
        newkey0: dict{key1: val1, key2: val2, key3: val3}
        newkey01: dict{key1: val4, key2: val5}
    }
    >>> d | fields("key01") | map(_value | renameFields("key2", "newkey2"))
    dict{
        key01: dict{key1: val4, newkey2: val5}
    }

.. _where:

where
^^^^^

:guilabel:`Added in revision 1`

Filter ``where`` returns a filtered :ref:`timeseries` or :ref:`dict` containing exclusively the entries of the input where
the predicate passed as parameter is :ref:`true <dict>`.

* The first and only parameter is the predicate. It is an expression, the value of which must be a boolean after evaluation.

Usable metavariables in the predicate for :ref:`timeseries` are:

    * ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
    * ``_time`` or ``_2``: timestamp of the current element
    * ``_value`` or ``_3``: value of the current element
    * ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

Usable metavariables in the predicate for :ref:`dicts <dict>` are:

    * ``_key`` or ``_1``: key of the current element
    * ``_value`` or ``_2``: value of the current element
    * ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

.. code:: aqlp

    >>> `analytics:/path/to/data`[3] | field("key1")
    timeseries{
        tstamp1: 1
        tstamp2: 2
        tstamp3: 3
        tstamp4: 4
    }
    >>> _ | where(_value >= 3)
    timeseries{
        tstamp3: 3
        tstamp4: 4
    }
    >>> let d = newDict()
    >>> d["key1"] = 13
    >>> d["key2"] = 1
    >>> d["k3"] = 1
    >>> d["k4"] = 1
    >>> d | where(strContains(_key, "key"))
    dict{
        "key1": 13
        "key2": 1
    }

.. _map:

map
^^^

:guilabel:`Added in revision 1`

Filter ``map`` returns a :ref:`timeseries` or :ref:`dict` consisting of the results of
applying the given expression to each entry of the filtered :ref:`timeseries` or :ref:`dict`.

* The first and only parameter is the expression. Its value can be of any type after evaluation.

Usable metavariables in the expression for :ref:`timeseries` are:

* ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
* ``_time`` or ``_2``: timestamp of the current element
* ``_value`` or ``_3``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

Usable metavariables in the expression for :ref:`dicts <dict>` are:

* ``_key`` or ``_1``: key of the current element
* ``_value`` or ``_2``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

.. code:: aqlp

    >>> `analytics:/path/to/data`[3]
    timeseries{
        tstamp1: dict{key1: 1, key2: 12, key3: 11}
        tstamp2: dict{key1: 2, key2: 123}
        tstamp3: dict{key1: 3, key2: 78, key3: 42}
        tstamp4: dict{key1: 4, key2: 68}
    }
    >>> _ | map(_value["key1"] + 1)
    timeseries{
        tstamp1: 2
        tstamp2: 3
        tstamp3: 4
        tstamp4: 5
    }
    >>> let d = newDict()
    >>> d["key1"] = 13
    >>> d["key2"] = 1
    >>> d["k3"] = 1
    >>> d["k4"] = 1
    >>> d | map(_key + "l")
    dict{
        "key1": key1l
        "key2": key2l
        "k3": k3l
        "k4": k4l
    }
    >>> d | map(_value^2)
    dict{
        "key1": 169
        "key2": 1
        "k3": 1
        "k4": 1
    }

.. _mapne:

mapne
^^^^^

:guilabel:`Added in revision 1`

Filter ``mapne`` (map-not-empty) returns a :ref:`timeseries` or :ref:`dict` consisting of the results of
applying the expression given as the first parameter applied to the result of the expression given as second parameter
if its result is not empty. This applies to each entry of the filtered :ref:`timeseries` or :ref:`dict`.

* The first parameter is the main expression. Its value can be of any type after evaluation.

  Usable metavariables in the expression for :ref:`timeseries` are:

    * ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
    * ``_time`` or ``_2``: timestamp of the current element
    * ``_value`` or ``_3``: result of the second expression applied to the current element
    * ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

  Usable metavariables in the expression for :ref:`dicts <dict>` are:

    * ``_key`` or ``_1``: key of the current element
    * ``_value`` or ``_2``: result of the second expression applied to the current element
    * ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

* the second parameter is the filtering expression. Its value can be of any type after evaluation.

  Usable metavariables in the expression for :ref:`timeseries` are:

    * ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
    * ``_time`` or ``_2``: timestamp of the current element
    * ``_value`` or ``_3``: value of the current element
    * ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

  Usable metavariables in the expression for :ref:`dicts <dict>` are:

    * ``_key`` or ``_1``: key of the current element
    * ``_value`` or ``_3`` value of the current element
    * ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

.. code:: aqlp

    >>> `analytics:/path/to/*/data/with/wildcard`[3]
    dict {
        pathElement1: timeseries{t1:1, t2:2, t3:3, t4:4}
        pathElement2: timeseries{t5:5, t6:6, t7:7, t8:8}
        pathElement3: timeseries{}
        pathElement4: timeseries{t9:9, t10:10, t11:11, t12:12}
    }
    >>> _ | map(mean(_value))
    error: cannot compute mean of empty timeseries
    >>> _ | mapne(mean(_value), _value)
    dict {
        pathElement1: 2.5
        pathElement2: 6.5
        pathElement4: 10.5
    }
    >>> `analytics:/path/to/data`[3]
    timeseries{
        tstamp1: dict{k1:1, k2:2, k3:3, k4:4}
        tstamp2: dict{k1:1, k2:2, k3:3, k4:4}
        tstamp3: dict{}
        tstamp4: dict{k1:1, k2:2, k3:3, k4:4}
    }
    >>> _ | map(mean(_value))
    error: cannot compute mean of empty dict
    >>> _ | mapne(mean(_value) + 12, _value)
    timeseries{
        tstamp1: 14.5
        tstamp2: 14.5
        tstamp4: 14.5
    }

.. _mapkv:

mapkv
^^^^^

:guilabel:`Added in revision 5`

Filter ``mapkv`` returns a :ref:`timeseries` or :ref:`dict` whose timestamps/keys and values are the result of
applying the provided mapping expressions to each entry of the filtered :ref:`timeseries` or :ref:`dict`.

* The first parameter is the new timestamp or key expression. Its value must be of type :ref:`time`
  for :ref:`timeseries` and any valid dict key type for :ref:`dict` after evaluation.

  Usable metavariables in the expression for :ref:`timeseries` are:

    * ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
    * ``_time`` or ``_2``: timestamp of the current element (before update)
    * ``_value`` or ``_3``: value of the the current element (before update)
    * ``_src`` or ``_4``: reference to the :ref:`timeseries` or :ref:`dict` being filtered

  Usable metavariables in the expression for :ref:`dicts <dict>` are:

    * ``_key`` or ``_1``: key of the current element (before update)
    * ``_value`` or ``_2``: value of the the current element (before update)
    * ``_src`` or ``_4``: reference to the :ref:`timeseries` or :ref:`dict` being filtered

* the second parameter is the new value expression. Its value can be of any type after evaluation.

  Usable metavariables in the expression for :ref:`timeseries` are:

    * ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
    * ``_time`` or ``_2``: timestamp of the current element (before update)
    * ``_value`` or ``_3``: value of the current element (before update)
    * ``_src`` or ``_4``: reference to the :ref:`timeseries` or :ref:`dict` being filtered

  Usable metavariables in the expression for :ref:`dicts <dict>` are:

    * ``_key`` or ``_1``: key of the current element (before update)
    * ``_value`` or ``_3`` value of the current element (before update)
    * ``_src`` or ``_4`` : reference to the :ref:`timeseries` or :ref:`dict` being filtered

.. code:: aqlp

    >>> let d = newDict() | setFields("k1", "v1", "k2", "v2", "k3", "v3")
    >>> d
    dict{
        k1: v1
        k2: v2
        k3: v3
    }
    >>> d | mapkv(_key + _value, _value + _key)
    dict{
        k1v1: v1k1
        k2v2: v2k2
        k3v3: v3k3
    }

    >>> reFindCaptures("foobarbaztootartaz", "([ft])(oo)")
    timeseries{
        start: 1970-01-01 01:00:00 +0100 CET
        end: 1970-01-01 01:00:00.000000002 +0100 CET
        1970-01-01 01:00:00.000000001 +0100 CET: ["foo","f","oo"]
        1970-01-01 01:00:00.000000002 +0100 CET: ["too","t","oo"]
    }
    >>> _ | mapkv(_time + 1h, _value)
    timeseries{
        start: 1970-01-01 02:00:00.000000001 +0100 CET
        end: 1970-01-01 02:00:00.000000002 +0100 CET
        1970-01-01 02:00:00.000000001 +0100 CET: ["foo","f","oo"]
        1970-01-01 02:00:00.000000002 +0100 CET: ["too","t","oo"]
    }
    >>> _ | mapkv(_time + 15m, length(_value))
    timeseries{
        start: 1970-01-01 02:15:00.000000001 +0100 CET
        end: 1970-01-01 02:15:00.000000002 +0100 CET
        1970-01-01 02:15:00.000000001 +0100 CET: 3
        1970-01-01 02:15:00.000000002 +0100 CET: 3
    }

.. _recmap:

recmap
^^^^^^

:guilabel:`Added in revision 1`

Filter ``recmap`` returns a :ref:`timeseries` or :ref:`dict` consisting of the results of
applying the given expression to each entry of the filtered :ref:`timeseries` or :ref:`dict`, at the specified depth.

* The first parameter is the recursion depth (:ref:`num`).
* The second parameter is the expression. Its value can be of any type after evaluation.

Usable metavariables in the expression for :ref:`timeseries` are:

* ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
* ``_time`` or ``_2``: timestamp of the current element
* ``_value`` or ``_3``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

Usable metavariables in the expression for :ref:`dicts <dict>` are:

* ``_key`` or ``_1``: key of the current element
* ``_value`` or ``_2``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

.. code:: aqlp

    >>> `analytics:/path/to/*/data/with/*/2/wildcards`
    dict {
        pe1: dict{pe1.1: timeseries{1, 2, 3}, pe1.2: timeseries{1, 2, 3}}
        pe2: dict{pe2.1: timeseries{1, 2, 3}, pe2.2: timeseries{1, 2, 3}}
        pe3: dict{pe3.1: timeseries{1, 2, 3}, pe3.2: timeseries{1, 2, 3}}
    } # we want the same recursion depth for every branch here, and stop at the timeseries level
    >>> let data = _
    >>> data | map(_value | map(mean(_value)))
    dict {
        pe1: dict{pe1.1: 2, pe1.2: 2}
        pe2: dict{pe2.1: 2, pe2.2: 2}
        pe3: dict{pe3.1: 2, pe3.2: 2}
    } # nested map filters work but are very verbose
    >>> data | recmap(2, mean(_value))
    dict {
        pe1: dict{pe1.1: 2, pe1.2: 2}
        pe2: dict{pe2.1: 2, pe2.2: 2}
        pe3: dict{pe3.1: 2, pe3.2: 2}
    }
    # recmap is much clearer.

.. _topK:

topK
^^^^

:guilabel:`Added in revision 3`

Filter ``topK`` filters the collection to keep only the k highest values. This filter can be
applied to a :ref:`timeseries` or a :ref:`dict`.

* The first parameter is the ``k`` parameter, which is the number of values to keep in the filtered collection.
* The second parameter is an expression that returns for each entry of the collection the value to compare.
  The return type of this expression must be comparable (:ref:`num`, :ref:`str`, :ref:`time`, or :ref:`duration`)

Usable metavariables in the expression for :ref:`timeseries` are:

* ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
* ``_time`` or ``_2``: timestamp of the current element
* ``_value`` or ``_3``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

Usable metavariables in the expression for :ref:`dicts <dict>` are:

* ``_key`` or ``_1``: key of the current element
* ``_value`` or ``_2``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

.. code:: aqlp

    >>> let data = `analytics:/path/to/some/*/data` | map(merge(_value))
    >>> data
    dict{
        Ethernet49/1: dict{
            in: 11.845057565692196
            out: 20.816078774499992
        }
        Ethernet49/5: dict{
            in: 4.021321282808746
            out: 8.868898231943206
        }
        Ethernet51/1: dict{
            in: 2.1800167411644353
            out: 2.413745251460854
        }
        Ethernet51/2: dict{
            in: 3.126216167169341
            out: 26.05024018915018
        }
        Ethernet51/3: dict{
            in: 54.1046901332212
            out: 5.035469519006775
        }
        Ethernet51/4: dict{
            in: 7.313228804713885
            out: 4.899238295809337
        }
        Ethernet8: dict{
            in: 0
            out: 71.6547381850231
        }
        Management1: dict{
            in: 6.139184309225689
            out: 0.7010378175218949
        }
        Port-Channel512: dict{
            in: 7.864572656164906
            out: 14.724350983923758
        }
        Port-Channel532: dict{
            in: 16.652391153117858
            out: 9.562088032011452
        }
    }
    >>> data | topK(2, _value["in"])
    dict{
        Ethernet51/3: dict{
            in: 54.1046901332212
            out: 5.035469519006775
        }
        Port-Channel532: dict{
            in: 16.652391153117858
            out: 9.562088032011452
        }
    }
    >>> data | map(_value["in"]) | topK(2, _value)
    dict{
        Ethernet51/3: 54.1046901332212
        Port-Channel532: 16.652391153117858
    }

.. _bottomK:

bottomK
^^^^^^^

:guilabel:`Added in revision 3`

Filter ``bottomK`` filters the collection to keep only the k lowest values. This filter can be
applied to a :ref:`timeseries` or a :ref:`dict`.

* The first parameter is the ``k`` parameter, which is the number of values to keep in the filtered collection.
* The second parameter is an expression that returns for each entry of the collection the value to compare.
  The return type of this expression must be comparable (:ref:`num`, :ref:`str`, :ref:`time`, or :ref:`duration`)

Usable metavariables in the expression for :ref:`timeseries` are:

* ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
* ``_time`` or ``_2``: timestamp of the current element
* ``_value`` or ``_3``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

Usable metavariables in the expression for :ref:`dicts <dict>` are:

* ``_key`` or ``_1``: key of the current element
* ``_value`` or ``_2``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

.. code:: aqlp

    >>> let data = `analytics:/path/to/some/*/data` | map(merge(_value))
    >>> data
    dict{
        Ethernet49/1: dict{
            in: 11.845057565692196
            out: 20.816078774499992
        }
        Ethernet49/5: dict{
            in: 4.021321282808746
            out: 8.868898231943206
        }
        Ethernet51/1: dict{
            in: 2.1800167411644353
            out: 2.413745251460854
        }
        Ethernet51/2: dict{
            in: 3.126216167169341
            out: 26.05024018915018
        }
        Ethernet51/3: dict{
            in: 54.1046901332212
            out: 5.035469519006775
        }
        Ethernet51/4: dict{
            in: 7.313228804713885
            out: 4.899238295809337
        }
        Ethernet8: dict{
            in: 0
            out: 71.6547381850231
        }
        Management1: dict{
            in: 6.139184309225689
            out: 0.7010378175218949
        }
        Port-Channel512: dict{
            in: 7.864572656164906
            out: 14.724350983923758
        }
        Port-Channel532: dict{
            in: 16.652391153117858
            out: 9.562088032011452
        }
    }
    >>> data | bottomK(2, _value["in"])
    dict{
        Ethernet51/1: dict{
            in: 2.1800167411644353
            out: 2.413745251460854
        }
        Ethernet8: dict{
            in: 0
            out: 71.6547381850231
        }
    }
    >>> data | map(_value["in"]) | bottomK(2, _value)
    dict{
        Ethernet51/1: 2.1800167411644353
        Ethernet8: 0
    }

.. _deepmap:

deepmap
^^^^^^^

:guilabel:`Added in revision 1`

Filter ``deepmap`` returns a :ref:`timeseries` or :ref:`dict` consisting of the results of
applying the given expression to each entry of the filtered :ref:`timeseries` or :ref:`dict`
which can contain nested :ref:`timeseries` or :ref:`dicts <dict>`.

* The first and only parameter is the expression. Its value can be of any type after evaluation.
* Metavariables are applicable to the collection containing the leaf node to which the expression is applied, which can be nested under several layers.

Usable metavariables in the expression for :ref:`timeseries` are:

* ``_index`` or ``_1``: index of the current element (starting at :math:`0`)
* ``_time`` or ``_2``: timestamp of the current element
* ``_value`` or ``_3``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

Usable metavariables in the expression for :ref:`dicts <dict>` are:

* ``_key`` or ``_1``: key of the current element
* ``_value`` or ``_2``: value of the current element
* ``_src`` or ``_4`` (revision 4+): reference to the :ref:`timeseries` or :ref:`dict` being filtered

.. code:: aqlp

    >>> `analytics:/path/to/*/data/with/wildcard`[3]
    dict {
        pathElement1: timeseries{t1:1, t2:2, t3:3, t4:4}
        pathElement2: timeseries{t5:5, t6:6, t7:7, t8:8}
        pathElement3: timeseries{dict{k10:10}, dict{k11:11}}
    }
    >>> _ | deepmap(_value + 1)
    dict {
        pathElement1: timeseries{t1:2, t2:3, t3:4, t4:5}
        pathElement2: timeseries{t5:6, t6:7, t7:8, t8:9}
        pathElement3: timeseries{dict{k10:11}, dict{k11:12}}
    } # recursion depth can be different between branches, deepmap will recurse as long as the value is either a dict or timeseries

.. _resample:

resample
^^^^^^^^

:guilabel:`Added in revision 1`

Filter ``resample`` returns a :ref:`timeseries` resampled with the given :ref:`duration` as constant interval.
CloudVision :ref:`timeseries` are state-based, so any value in the output :ref:`timeseries` will be the latest
value prior to the output timestamp in the original :ref:`timeseries`.

* The first and only parameter, of type :ref:`duration`, specifies the interval of the output :ref:`timeseries`.

.. code:: aqlp

    >>> `analytics:/path/to/data`[3] | field("numfield")
    timeseries{
        2019-08-31 00:00:00: 13
        2019-08-31 00:06:23: 1
        2019-08-31 00:08:29: 2
        2019-08-31 00:11:43: 200
    }
    >>> _ | resample(2m)
    timeseries{
        2019-08-31 00:00:00: 13
        2019-08-31 00:02:00: 13
        2019-08-31 00:04:00: 13
        2019-08-31 00:06:00: 13
        2019-08-31 00:08:00: 13
        2019-08-31 00:10:00: 2
        2019-08-31 00:12:00: 200
    }