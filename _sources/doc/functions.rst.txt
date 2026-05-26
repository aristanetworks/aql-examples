General functions
^^^^^^^^^^^^^^^^^^

.. _now:

now
***

:guilabel:`Added in revision 1`

Function ``now`` returns the current :ref:`time`. Time is constant across all the script, so that all operations and queries have the same reference time.

.. code:: aqlp

	>>> now()
	2019-09-01T14:05:10Z

.. _length:

length
******

:guilabel:`Added in revision 1`

Function ``length`` returns the number of elements in a :ref:`str`, a :ref:`timeseries` or a :ref:`dict`.
Since revision 5, ``length`` can also be used with complex keys (type `unknown`) of type list or map.

* The first and only argument is a :ref:`str`, :ref:`timeseries`, :ref:`dict` or complex key (type :ref:`unknown`)

.. code:: aqlp

	>>> length(`analytics:/path/to/data`[0])
	1

.. _merge:

merge
*****

:guilabel:`Added in revision 1`

Function ``merge`` returns a union of all the :ref:`dicts <dict>` contained in a :ref:`timeseries`. In case of key collision, the latest entry is kept.

* The first and only argument is a :ref:`timeseries` of :ref:`dicts <dict>`

.. code:: aqlp

	>>> `analytics:/path/to/data`[1]
	timeseries{
		tstamp1: dict{key1: val1, key2: val2, key3: val3}
		tstamp2: dict{key1: val4, key2: val5}
	}
	>>> merge(_)
	dict{key1: val4, key2: val5, key: val3}

.. _mergeDicts:

mergeDicts
**********

:guilabel:`Added in revision 5`

Function ``mergeDicts`` returns a union of all the :ref:`dicts <dict>` contained in a :ref:`dict`. In case of key collision, the entry kept is chosen randomly among
the :ref:`dicts <dict>`.

* The first and only argument is a :ref:`dict` of :ref:`dicts <dict>`

.. code:: aqlp

	>>> let d = newDict()
	>>> d["a"] = newDict() | setFields("1", 1)
	>>> d["b"] = newDict() | setFields("2", 2)
	>>> d["c"] = newDict() | setFields("3", 3)
	>>> mergeDicts(d)
	dict{
			1: 1
			2: 2
			3: 3
	}

.. _deletes:

deletes
*******

:guilabel:`Added in revision 1`

Function ``deletes`` returns a :ref:`timeseries` of :ref:`dicts <dict>` used as sets of the delete keys from the input :ref:`timeseries`.
Only works with unfiltered :ref:`timeseries`, as most filters remove the deletes entries. An empty :ref:`dict` as value means the update is a DeleteAll

* The first and only parameter is the `timeseries`

.. code:: aqlp

	>>> deletes(`analytics:/path/to/data`[200])
	timeseries{
		tstamp1: dict{key1: nil, key2: nil}
		tstamp2: dict{} # this deletes all keys
	}

.. _equal:

equal
*****

:guilabel:`Added in revision 1`

Function ``equal`` performs a cross-type equality check on the given arguments using type coercions.

* The first argument is a value of any type
* The second argument is a value of any type

.. code:: aqlp

	>>> equal("1", 1)
	true
	>>> equal(1, true)
	true
	>>> equal(0, true)
	false

.. _complexKey:

complexKey
**********

:guilabel:`Added in revision 1`

Function ``complexKey`` parses a string containing a literal or json object.
Numerical values without floating-point will produce an integer.
Numerical values with a floating point will produce a float64 (:ref:`num`).
Boolean literals will produce a boolean (:ref:`bool`).
Values surrounded with {} or [] will be parsed as JSON.
For all cases except float64 (:ref:`num`) and :ref:`bool`, the returned value will be of type :ref:`unknown` (internal interpreter type), but can be used to access complex keys in dicts.

* The first and only parameter is the :ref:`str` to parse

.. code:: aqlp

	>>> complexKey("1")
	int(1) # AQL type is unknown
	>>> complexKey("1.2")
	float64(1.2) # AQL type is num
	>>> complexKey("{\"key1\": 1, \"key2\": true}")
	{"key1":1,"key2":true}# AQL type is unknown
	>>> complexKey("[1, 2, true]")
	[1,2,true] # AQL type is unknown

.. _errvl:

errvl
*****

:guilabel:`Added in revision 5`

Function ``errvl`` returns the result of the evaluation of the first parameter if its evaluation succeeds, or
returns the result of the evaluation of the second parameter if the evaluation of the first one returned an error.

It takes 2 expression arguments.

.. code:: aqlp

	>>> let a = 89
	>>> errvl(a, "test")
	89
	>>> errvl(notDeclaredVar, "test")
	test

.. _dictTsManipFunctions:

Dicts and Timeseries manipulation functions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _newDict:

newDict
*******

:guilabel:`Added in revision 1`

Function ``newDict`` returns a new empty :ref:`dict`.

.. code:: aqlp

	>>> newDict()
	dict{}

.. _dictRemove:

dictRemove
**********

:guilabel:`Added in revision 1`

Function ``dictRemove`` removes a given key from a :ref:`dict`.

* The first argument is the :ref:`dict`
* The second argument is the key to remove

.. code:: aqlp

	>>> let d = newDict()
	>>> d["key"] = 1
	>>> d["key2"] = 2
	>>> d
	dict{"key": 1, "key2": 2}
	>>> dictRemove(d, "key")
	>>> d
	dict{"key2": 2}

.. _dictHasKey:

dictHasKey
**********

:guilabel:`Added in revision 1`

Function ``dictHasKey`` returns :ref:`true <bool>` if a dict contains the specified key, :ref:`false <bool>` if it doesn't.

* The first parameter is the :ref:`dict`
* The second parameter is the key

.. code:: aqlp

	>>> let d = newDict()
	>>> d["key"] = 1
	>>> d["key2"] = 2
	>>> d
	dict{"key": 1, "key2": 2}
	>>> dictHasKey(d, "key")
	true
	>>> dictHasKey(d, "key3")
	false

.. _dictValue:

dictValue
*********

:guilabel:`Added in revision 5`

Function ``dictValue`` returns the value associated with a specific key in a :ref:`dict`
if a dict contains the specified key, otherwise default value is returned.

* The first parameter is the :ref:`dict`
* The second parameter is the key
* The third parameter is the default value returned if a dict doesn't contain the specified key

.. code:: aqlp

	>>> let d = newDict()
	>>> d["key"] = 1
	>>> d["key2"] = 2
	>>> d
	dict{"key": 1, "key2": 2}
	>>> dictValue(d, "key", 15)
	1
	>>> dictValue(d, "key3", 14)
	14

.. _dictKeys:

dictKeys
********

:guilabel:`Added in revision 1`

Function ``dictKeys`` returns a :ref:`timeseries` with the list of keys in a :ref:`dict`.

* The first and only parameter is the :ref:`dict`

.. code:: aqlp

	>>> let d = newDict()
	>>> d["key"] = 1
	>>> d["key2"] = 2
	>>> d
	dict{"key": 1, "key2": 2}
	>>> dictKeys(d)
	timeseries{
		0000-00-00 00:00:00.000000001: "key"
		0000-00-00 00:00:00.000000002: "key2"
	}

.. _unnestTimeseries:

unnestTimeseries
****************

:guilabel:`Added in revision 4`

Function ``unnestTimeseries`` merges multiple :ref:`timeseries` nested in :ref:`dicts <dict>`, pushes them to the top level,
and returns a single flattened :ref:`timeseries` where the former top-level :ref:`dicts <dict>` are now nested within
the :ref:`timeseries`' values. The input data is typically what a query using ``*`` wildcards would return.

* The first and only parameter is a :ref:`dict` that contains :ref:`timeseries`, either directly in the value, or nested in more levels of :ref:`dict`.

.. TODO: make a smaller example to put outside the collapse

.. collapse:: Example

	.. code:: aqlp

		>>> let ts = `analytics:/Devices/*/versioned-data/interfaces/data/*/aggregate/hardware/xcvr/1m`[1m] | recmap(2, _value | field("temperature") | field("avg"))
		>>> let d = newDict() | setFields("AA", ts)
		>>> d
		dict{AA: dict{
				HSH14280171: dict{
					Ethernet50: timeseries{
						start: 2022-08-16 17:10:21.217673 +0200 CEST
						end: 2022-08-16 17:11:21.217673 +0200 CEST
						2022-08-16 17:10:00 +0200 CEST: 34.184087816704434
						2022-08-16 17:11:00 +0200 CEST: 34.18519049983288
					}
					Ethernet51: timeseries{
						start: 2022-08-16 17:10:21.217673 +0200 CEST
						end: 2022-08-16 17:11:21.217673 +0200 CEST
						2022-08-16 17:10:00 +0200 CEST: 34.84759166533158
						2022-08-16 17:11:00 +0200 CEST: 34.84247911778802
					}
				}
				JAS17070003: dict{
					Ethernet50: timeseries{
						start: 2022-08-16 17:10:21.217673 +0200 CEST
						end: 2022-08-16 17:11:21.217673 +0200 CEST
						2022-08-16 17:10:00 +0200 CEST: 30.65325390983907
						2022-08-16 17:11:00 +0200 CEST: 30.65664047328105
					}
					Ethernet51: timeseries{
						start: 2022-08-16 17:10:21.217673 +0200 CEST
						end: 2022-08-16 17:11:21.217673 +0200 CEST
						2022-08-16 17:10:00 +0200 CEST: 27.58473123455124
						2022-08-16 17:11:00 +0200 CEST: 27.597529745280074
					}
				}
			}}
		>>> unnestTimeseries(d)
		timeseries{
			start: 2022-08-16 17:10:21.217673 +0200 CEST
			end: 2022-08-16 17:11:21.217673 +0200 CEST
			2022-08-16 17:10:00 +0200 CEST: dict{AA: dict{
					HSH14280171: dict{
						Ethernet50: 34.184087816704434
						Ethernet51: 34.84759166533158
					}
					JAS17070003: dict{
						Ethernet50: 30.65325390983907
						Ethernet51: 27.58473123455124
					}
				}}
			2022-08-16 17:11:00 +0200 CEST: dict{AA: dict{
					HSH14280171: dict{
						Ethernet50: 34.18519049983288
						Ethernet51: 34.84247911778802
					}
					JAS17070003: dict{
						Ethernet50: 30.65664047328105
						Ethernet51: 27.597529745280074
					}
				}}
		}
		>>> let b = `analytics:/Devices/JPE17191574/versioned-data/interfaces/data/Ethernet50/aggregate/hardware/xcvr/1m`[2m] | field("voltage") | field("max")
		>>> let dd = newDict() | setFields("BB", b)
		>>> let ddd = newDict() | setFields("DD", ts, "EE", dd)
		>>> d["FF"]=ddd
		>>> d
		dict{
			AA: dict{
				HSH14280171: dict{
					Ethernet50: timeseries{
						start: 2022-08-16 17:10:21.217673 +0200 CEST
						end: 2022-08-16 17:11:21.217673 +0200 CEST
						2022-08-16 17:10:00 +0200 CEST: 34.184087816704434
						2022-08-16 17:11:00 +0200 CEST: 34.18519049983288
					}
					Ethernet51: timeseries{
						start: 2022-08-16 17:10:21.217673 +0200 CEST
						end: 2022-08-16 17:11:21.217673 +0200 CEST
						2022-08-16 17:10:00 +0200 CEST: 34.84759166533158
						2022-08-16 17:11:00 +0200 CEST: 34.84247911778802
					}
				}
				JAS17070003: dict{
					Ethernet50: timeseries{
						start: 2022-08-16 17:10:21.217673 +0200 CEST
						end: 2022-08-16 17:11:21.217673 +0200 CEST
						2022-08-16 17:10:00 +0200 CEST: 30.65325390983907
						2022-08-16 17:11:00 +0200 CEST: 30.65664047328105
					}
					Ethernet51: timeseries{
						start: 2022-08-16 17:10:21.217673 +0200 CEST
						end: 2022-08-16 17:11:21.217673 +0200 CEST
						2022-08-16 17:10:00 +0200 CEST: 27.58473123455124
						2022-08-16 17:11:00 +0200 CEST: 27.597529745280074
					}
				}
			}
			FF: dict{
				DD: dict{
					HSH14280171: dict{
						Ethernet50: timeseries{
							start: 2022-08-16 17:10:21.217673 +0200 CEST
							end: 2022-08-16 17:11:21.217673 +0200 CEST
							2022-08-16 17:10:00 +0200 CEST: 34.184087816704434
							2022-08-16 17:11:00 +0200 CEST: 34.18519049983288
						}
						Ethernet51: timeseries{
							start: 2022-08-16 17:10:21.217673 +0200 CEST
							end: 2022-08-16 17:11:21.217673 +0200 CEST
							2022-08-16 17:10:00 +0200 CEST: 34.84759166533158
							2022-08-16 17:11:00 +0200 CEST: 34.84247911778802
						}
					}
					JAS17070003: dict{
						Ethernet50: timeseries{
							start: 2022-08-16 17:10:21.217673 +0200 CEST
							end: 2022-08-16 17:11:21.217673 +0200 CEST
							2022-08-16 17:10:00 +0200 CEST: 30.65325390983907
							2022-08-16 17:11:00 +0200 CEST: 30.65664047328105
						}
						Ethernet51: timeseries{
							start: 2022-08-16 17:10:21.217673 +0200 CEST
							end: 2022-08-16 17:11:21.217673 +0200 CEST
							2022-08-16 17:10:00 +0200 CEST: 27.58473123455124
							2022-08-16 17:11:00 +0200 CEST: 27.597529745280074
						}
					}
				}
				EE: dict{BB: timeseries{
						start: 2022-08-16 17:14:06.794969 +0200 CEST
						end: 2022-08-16 17:16:06.794969 +0200 CEST
						2022-08-16 17:14:00 +0200 CEST: 3.2909
						2022-08-16 17:15:00 +0200 CEST: 3.2909
						2022-08-16 17:16:00 +0200 CEST: 3.2909
					}}
			}
		}
		>>> unnestTimeseries(d)
		timeseries{
			start: 2022-08-16 17:10:21.217673 +0200 CEST
			end: 2022-08-16 17:16:06.794969 +0200 CEST
			2022-08-16 17:10:00 +0200 CEST: dict{
				AA: dict{
					HSH14280171: dict{
						Ethernet50: 34.184087816704434
						Ethernet51: 34.84759166533158
					}
					JAS17070003: dict{
						Ethernet50: 30.65325390983907
						Ethernet51: 27.58473123455124
					}
				}
				FF: dict{DD: dict{
						HSH14280171: dict{
							Ethernet50: 34.184087816704434
							Ethernet51: 34.84759166533158
						}
						JAS17070003: dict{
							Ethernet50: 30.65325390983907
							Ethernet51: 27.58473123455124
						}
					}}
			}
			2022-08-16 17:11:00 +0200 CEST: dict{
				AA: dict{
					HSH14280171: dict{
						Ethernet50: 34.18519049983288
						Ethernet51: 34.84247911778802
					}
					JAS17070003: dict{
						Ethernet50: 30.65664047328105
						Ethernet51: 27.597529745280074
					}
				}
				FF: dict{DD: dict{
						HSH14280171: dict{
							Ethernet50: 34.18519049983288
							Ethernet51: 34.84247911778802
						}
						JAS17070003: dict{
							Ethernet50: 30.65664047328105
							Ethernet51: 27.597529745280074
						}
					}}
			}
			2022-08-16 17:14:00 +0200 CEST: dict{FF: dict{EE: dict{BB: 3.2909}}}
			2022-08-16 17:15:00 +0200 CEST: dict{FF: dict{EE: dict{BB: 3.2909}}}
			2022-08-16 17:16:00 +0200 CEST: dict{FF: dict{EE: dict{BB: 3.2909}}}
		}

.. _jsonToDict:

jsonToDict
**********

:guilabel:`Added in revision 5`

Function ``jsonToDict`` converts a json string into a standard AQL :ref:`dict`.

The only argument is the json string.

.. code:: aqlp

	>>> jsonToDict("{\"k1\": 1, \"k2\": true, \"k3\": \"foo\", \"k4\": [1,3,5]}")
	dict{
		k1: 1
		k2: true
		k3: foo
		k4: [1,3,5]
	}
	>>> jsonToDict("{\"simple\": 1, \"nested\": {\"k1\":1,\"k2\":2}}")
	dict{
		nested: dict{
				k1: 1
				k2: 2
		}
		simple: 1
	}
	>>> jsonToDict("[12,13,14]")
	dict{
		0: 12
		1: 13
		2: 14
	}

.. _dictToJson:

dictToJson
**********

:guilabel:`Added in revision 5`

Function ``dictToJson`` converts a :ref:`dict` into a json string.

* The first argument is the :ref:`dict`
* The second argument (optional) of type :ref:`str` specifies additional options:
 * k: store non-string keys under ``_key`` label (not stringified)
 * w: wrap non-string keys with {} (to distinguish from string)

.. code:: aqlp

	>>> let d = newDict() | setFields(0, false, true, "1", "two", 2, 3, "three", "str", "foo")
	>>> dictToJson(d)
	{"0":false,"true":"1","two":2,"3":"three","str":"foo"}
	>>> dictToJson(d,"kw")
	{"str":"foo","two":2,"{0}":{"_key":0,"value":false},"{3}":{"_key":3,"value":"three"},"{true}":{"_key":true,"value":"1"}}

.. _listToTimeseries:

listToTimeseries
****************

:guilabel:`Added in revision 5`

Function ``listToTimeseries`` converts a complex key (type :ref:`unknown`) of type list into a standard AQL :ref:`timeseries`.

* The first argument is the "list" complex key to convert.
* The second argument (optional) is the start time (:ref:`time`)
* The third argument (optional) is the timestamp offset (:ref:`duration`)

.. code:: aqlp

	>>> listToTimeseries(complexKey("[1, \"2\", true]"))
	timeseries{
		start: 1970-01-01 01:00:00.000000000 +0100 CET
		end: 1970-01-01 01:00:00.000000003 +0100 CET
		1970-01-01 01:00:00.000000000 +0100 CET: 1
		1970-01-01 01:00:00.000000001 +0100 CET: 2
		1970-01-01 01:00:00.000000002 +0100 CET: true
	}
	>>> listToTimeseries(complexKey("[1, \"2\", true]"),time("2020-05-02T17:04:05+02:00"), 1h)
	timeseries{
		start: 2020-05-02 17:04:05.000000000 +0200 CEST
		end: 2020-05-02 20:04:05.000000000 +0200 CEST
		2020-05-02 17:04:05.000000000 +0200 CEST: 1
		2020-05-02 18:04:05.000000000 +0200 CEST: 2
		2020-05-02 19:04:05.000000000 +0200 CEST: true
	}

.. _timeAtIndex:

timeAtIndex
***********

:guilabel:`Added in revision 5`

Function ``timeAtIndex`` returns the time associated to an index (type :ref:`num`) in a :ref:`timeseries`.

* The first argument is the :ref:`timeseries`
* The second argument is the index (:ref:`num`)

.. code:: aqlp

    >>> let data = `dataset:/some/path` | field("numberKey")
    >>> data
    timeseries{
            start: 2025-03-11 17:18:21.512198000 +0000 GMT
            end: 2025-03-11 17:23:21.512198000 +0000 GMT
            2025-03-11 17:18:21.512198000 +0000 GMT: 1
            2025-03-11 17:19:21.512198000 +0000 GMT: 2
            2025-03-11 17:20:21.512198000 +0000 GMT: 3
            2025-03-11 17:21:21.512198000 +0000 GMT: 4
            2025-03-11 17:22:21.512198000 +0000 GMT: 5
            2025-03-11 17:23:21.512198000 +0000 GMT: 6
    }
    >>> data[2]
    3
    >>> _bracketTime
    2025-03-11 17:20:21.512198 +0000 GMT m=-388.396045249
    >>> timeAtIndex(data, 2)
    2025-03-11 17:20:21.512198 +0000 GMT m=-388.396045249
    >>> timeAtIndex(data, 3)
    2025-03-11 17:21:21.512198 +0000 GMT m=-328.396045249


.. _timeseriesStart:

timeseriesStart
***************

:guilabel:`Added in revision 5`

Function ``timeseriesStart`` returns the start :ref:`time` of a :ref:`timeseries`.

This is not always the time of the first entry, but the "metadata" start value of the timeseries, which
usually corresponds to the beginning of the queried time range. The :ref:`timeseries` can contain
older entries that usually correspond to the state at the start time. See `Number of updates <index_doc.html#number-of-updates>`_
for more information.

* The only argument is the :ref:`timeseries`

.. code:: aqlp

    >>> let data = `dataset:/some/path` | field("numberKey")
    >>> data
    timeseries{
            start: 2025-01-30 18:43:22.000000000 +0000 GMT
            end: 2025-03-11 17:50:53.000000000 +0000 GMT
            2024-12-18 11:06:04.684761143 +0000 GMT: 0
            2025-01-30 18:43:22.317492646 +0000 GMT: 1
            2025-01-30 18:47:54.195887550 +0000 GMT: 2
            2025-01-30 18:47:54.195905979 +0000 GMT: 3
            2025-01-30 18:47:54.196054106 +0000 GMT: 4
            2025-01-30 18:47:54.196113842 +0000 GMT: 5
            2025-01-30 18:54:56.952268810 +0000 GMT: 6
            2025-01-30 18:54:58.060447701 +0000 GMT: 7
            2025-01-30 18:54:58.060539255 +0000 GMT: 8
            2025-01-30 18:54:58.064195963 +0000 GMT: 9
            2025-01-30 18:54:58.064339938 +0000 GMT: 10
            2025-01-30 19:04:30.836181934 +0000 GMT: 11
    }
    >>> timeAtIndex(data, 0)
    2024-12-18 11:06:04.684761143 +0000 UTC # time of the first entry
    >>> timeseriesStart(data)
    2025-01-30 18:43:22 +0000 UTC # "Start" time from metadata

.. _timeseriesEnd:

timeseriesEnd
*************

:guilabel:`Added in revision 5`

Function ``timeseriesEnd`` returns the end :ref:`time` of a :ref:`timeseries`.

This is not always the time of the last entry, but the "metadata" end value of the :ref:`timeseries`, which
usually corresponds to the end of the queried window (the current time if no window end is specified).

* The only argument is the :ref:`timeseries`

.. code:: aqlp

    >>> let data = `dataset:/some/path` | field("numberKey")
    >>> data
    timeseries{
            start: 2025-01-30 18:43:22.000000000 +0000 GMT
            end: 2025-03-11 17:50:53.000000000 +0000 GMT
            2024-12-18 11:06:04.684761143 +0000 GMT: 0
            2025-01-30 18:43:22.317492646 +0000 GMT: 1
            2025-01-30 18:47:54.195887550 +0000 GMT: 2
            2025-01-30 18:47:54.195905979 +0000 GMT: 3
            2025-01-30 18:47:54.196054106 +0000 GMT: 4
            2025-01-30 18:47:54.196113842 +0000 GMT: 5
            2025-01-30 18:54:56.952268810 +0000 GMT: 6
            2025-01-30 18:54:58.060447701 +0000 GMT: 7
            2025-01-30 18:54:58.060539255 +0000 GMT: 8
            2025-01-30 18:54:58.064195963 +0000 GMT: 9
            2025-01-30 18:54:58.064339938 +0000 GMT: 10
            2025-01-30 19:04:30.836181934 +0000 GMT: 11
    }
    >>> timeAtIndex(data, length(data)-1)
    2025-01-30 19:04:30.836181934 +0000 UTC # time of the last entry
    >>> timeseriesEnd(data)
    2025-03-11 17:50:53 +0000 UTC # "End" time from metadata


Data Analysis Functions
^^^^^^^^^^^^^^^^^^^^^^^

.. _groupby:

groupby
*******

:guilabel:`Added in revision 1`

Function ``groupby``, applied to a :ref:`timeseries`, returns a :ref:`dict` with keys corresponding to the 'group by field' parameter,
and values corresponding to the associate method and field.

The function takes 4 parameters:

* A :ref:`timeseries` of :ref:`dicts <dict>` to apply this function to
* The name of the 'group by field' (a :ref:`str`)
* The name of one of the supported associative methods (a :ref:`str`)
* The name of the field whose values will be operated on by the associative method (a :ref:`str`)

The entries in the :ref:`timeseries` are grouped by the values of the field from parameter 1.
For each entry, the value corresponding to the associative field of parameter 4 is obtained.
This results in a map with entries of the following format:

* *key*:  values of the 'group by field'
* *value*: lists of values of the 'associative field'

On each of these lists, the following associative methods can be applied:

* ``count``: returns the length of the list (i.e. the item count)
* ``max``: returns the max entry in the list
* ``mean``: returns the mean of the values in the list
* ``min``: returns the min entry in the list
* ``sum``: returns the sum of the entries in the list

.. code:: aqlp

	>>> `analytics:/path/to/data`[3]
	timeseries{
		tstamp1: dict{"name": "name1", "value": 1}
		tstamp2: dict{"name": "name2", "value": 10}
		tstamp3: dict{"name": "name1", "value": 2}
		tstamp4: dict{"name": "name2", "value": 11}
	}
	>>> let ts = _
	>>> groupby(ts, "name", "mean", "value")
	dict{
		"name1": 1.5
		"name2": 10.5
	}
	>>> groupby(ts, "name", "count", "value")
	dict{
		"name1": 2
		"name2": 2
	}
	>>> groupby(ts, "name", "sum", "value")
	dict{
		"name1": 3
		"name2": 21
	}

.. _histogram:

histogram
*********

:guilabel:`Added in revision 1`

Function ``histogram``, for a given :ref:`timeseries` of non-dict values, returns a :ref:`dict` with entries of the following format:

* *key*: value in the :ref:`timeseries` (range if a :ref:`timeseries` of :ref:`num` values)
* *value*: time-weighted frequency in the timeseries

Arguments:

* A :ref:`timeseries` of non-dict values is the only argument to this function

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("strfield")
	timeseries{
		start: 2019-08-31 00:00:00
		end: 2019-08-31 00:12:00
		2019-08-31 00:00:00: "string1"
		2019-08-31 00:01:00: "string2"
		2019-08-31 00:10:00: "string1"
		2019-08-31 00:11:00: "string1"
	}
	>>> histogram(_)
	dict{
		"string1": 0.25
		"string2": 0.75
	} # the count is weighted accordingly to the intervals
	>>> `analytics:/path/to/data`[5] | field("numfield")
	timeseries{
		start: 2019-08-31 00:00:00
		end: 2019-08-31 01:00:00
		2019-08-31 00:00:00: 1
		2019-08-31 00:01:00: 1.01
		2019-08-31 00:10:00: 1.011
		2019-08-31 00:30:00: 5.2
		2019-08-31 00:44:00: 5.22
		2019-08-31 00:56:00: 5.23
	}
	>>> histogram(_)
	dict{
		"1.0-1.011": 0.5
		"5.2-5.23": 0.5
	} # the count is weighted accordingly to the intervals

.. _dhistogram:

dhistogram
**********

:guilabel:`Added in revision 1`

Function ``dhistogram``, has a similar behaviour as :ref:`histogram` but its result is not time-weighted.
For a given :ref:`timeseries` of non-`dict` values, returns a :ref:`dict` with entries of the following format:

* *key*: value in the :ref:`timeseries` (range if a :ref:`timeseries` of :ref:`num` values)
* *value*: frequency (non-weighted count of occurences) in the :ref:`timeseries`

Arguments:

A :ref:`timeseries` of non-dict values is the only argument to this function

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("strfield")
	timeseries{
		start: 2019-08-31 00:00:00
		end: 2019-08-31 00:05:00
		2019-08-31 00:00:00: "string1"
		2019-08-31 00:01:00: "string2"
		2019-08-31 00:10:00: "string1"
		2019-08-31 00:11:00: "string1"
	} # the count does not depend of the time intervals between the updates
	>>> dhistogram(_)
	dict{
		"string1": 3
		"string2": 1
	} # the count does not depend of the time intervals between the updates
	>>> `analytics:/path/to/data`[5] | field("numfield")
	timeseries{
		2019-08-31 00:00:00: 1
		2019-08-31 00:01:00: 1.01
		2019-08-31 00:10:00: 1.011
		2019-08-31 00:30:00: 5.2
		2019-08-31 00:44:12: 5.22
		2019-08-31 02:01:34: 5.23
	}
	>>> dhistogram(_)
	dict{
		"1.0-1.011": 3
		"5.2-5.23": 3
	} # the count does not depend of the time intervals between the updates

.. _aggregate:

aggregate
*********

:guilabel:`Added in revision 4`

Function ``aggregate`` merges multiple :ref:`timeseries` contained in a :ref:`dict` (like the result of a
wildcarded query) using the associative method specified in the second parameter. The :ref:`dict` must
contain :ref:`timeseries`, all of which must contain identical timestamps.

If one of the :ref:`timeseries` is empty, it will be ignored.

If some values' timestamps are not matched in all the other non-empty :ref:`timeseries` of the :ref:`dict`,
these timestamp-value pairs will not be present in the output timeseries.

``aggregate`` returns a simple :ref:`timeseries` with the aggregated data of all the input :ref:`timeseries`.

* The first argument is the :ref:`dict` containing :ref:`timeseries` to aggregate
* The second argument is the name of the associative method to apply

Like with :ref:`groupby`, the following associative methods can be applied:

* ``count``: returns the length of the list (i.e. the item count)
* ``max``: returns the max entry in the list (requires the :ref:`timeseries` to be numerical)
* ``mean``: returns the mean of the values in the list (requires the :ref:`timeseries` to be numerical)
* ``min``: returns the min entry in the list (requires the :ref:`timeseries` to be numerical)
* ``sum``: returns the sum of the entries in the list (requires the :ref:`timeseries` to be numerical)

.. code:: aqlp

	>>> let data = `analytics:/Devices/*/versioned-data/interfaces/data/*/aggregate/hardware/xcvr/15m`[1h]
	>>> let avg = data | recmap(2, _value | field("temperature") | field("avg"))
	>>> avg
		JPE123456: dict{
			Ethernet1: timeseries{
				start: 2021-11-09 13:02:18.923904 +0000 GMT
				end: 2021-11-09 13:32:18.923904 +0000 GMT
				2021-11-09 13:00:00 +0000 GMT: 28.64315689104305
				2021-11-09 13:15:00 +0000 GMT: 28.64771549594622
				2021-11-09 13:30:00 +0000 GMT: 28.647003241959368
			}
			Ethernet2: timeseries{
				start: 2021-11-09 13:02:18.923904 +0000 GMT
				end: 2021-11-09 13:32:18.923904 +0000 GMT
				2021-11-09 13:00:00 +0000 GMT: 26.52073192182222
				2021-11-09 13:15:00 +0000 GMT: 26.57132998707
				2021-11-09 13:30:00 +0000 GMT: 26.562415784963335
			}
			[...]
		}
		JPE654321: dict{
			Ethernet1: timeseries{
				start: 2021-11-09 13:02:18.923904 +0000 GMT
				end: 2021-11-09 13:32:18.923904 +0000 GMT
				2021-11-09 13:00:00 +0000 GMT: 27.872056741171672
				2021-11-09 13:15:00 +0000 GMT: 26.422506200403397
				2021-11-09 13:30:00 +0000 GMT: 27.889330661612725
			}
			Ethernet2: timeseries{
				start: 2021-11-09 13:02:18.923904 +0000 GMT
				end: 2021-11-09 13:32:18.923904 +0000 GMT
				2021-11-09 13:00:00 +0000 GMT: 25.501376131906685
				2021-11-09 13:15:00 +0000 GMT: 24.06172043150084
				2021-11-09 13:30:00 +0000 GMT: 25.520567819910998
			}
			[...]
		}
		[...]
	>>> let deviceAvg = avg | map(aggregate(_value, "mean"))
	>>> deviceAvg
		JPE123456: timeseries{
			start: 2021-11-09 13:02:18.923904 +0000 GMT
			end: 2021-11-09 13:32:18.923904 +0000 GMT
			2021-11-09 13:00:00 +0000 GMT: 29.46781924765547
			2021-11-09 13:15:00 +0000 GMT: 28.739134103556832
			2021-11-09 13:30:00 +0000 GMT: 29.756429823529587
		}
		JPE654321: timeseries{
			start: 2021-11-09 13:02:18.923904 +0000 GMT
			end: 2021-11-09 13:32:18.923904 +0000 GMT
			2021-11-09 13:00:00 +0000 GMT: 27.581944406432633
			2021-11-09 13:15:00 +0000 GMT: 27.60952274150811
			2021-11-09 13:30:00 +0000 GMT: 27.60470951346135
		}
		[...]
	>>> aggregate(deviceAvg, "mean") # average temp accross all interfaces of all devices
	timeseries{
		start: 2021-11-09 13:02:18.923904 +0000 GMT
		end: 2021-11-09 13:32:18.923904 +0000 GMT
		2021-11-09 13:00:00 +0000 GMT: 33.261383897237806
		2021-11-09 13:15:00 +0000 GMT: 33.16722874112898
		2021-11-09 13:30:00 +0000 GMT: 33.37487749955894
	}

Math functions
^^^^^^^^^^^^^^

.. _abs:

abs
***

:guilabel:`Added in revision 1`

Function ``abs`` returns the absolute value (:ref:`num`) of the given value.

* The first and only argument :math:`x` is the value (:ref:`num`) of which the absolute value :math:`\lvert x \lvert` is wanted

.. code:: aqlp

	>>> abs(-11)
	11
	>>> abs(200)
	200

.. _ceil:

ceil
****

:guilabel:`Added in revision 1`

Function ``ceil`` returns the closest integer (:ref:`num`) succeeding the given value.

* The first and only argument :math:`x` is the value (:ref:`num`) of which the ceil :math:`\lceil x \rceil` is wanted

.. code:: aqlp

	>>> ceil(12)
	12
	>>> ceil(12.1)
	13
	>>> ceil(-12.1)
	-12

.. _floor:

floor
*****

:guilabel:`Added in revision 1`

Function ``floor`` returns the closest integer (:ref:`num`) preceding the given value.

* The first and only argument :math:`x` is the value (:ref:`num`) of which the floor :math:`\lfloor x \rfloor` is wanted

.. code:: aqlp

	>>> floor(3)
	3
	>>> floor(3.2)
	3
	>>> floor(-3.2)
	-4

.. _trunc:

trunc
*****

:guilabel:`Added in revision 1`

Function ``trunc`` returns the truncated (:ref:`num`) given value.

* The first and only argument is the value (:ref:`num`) to be truncated

.. code:: aqlp

	>>> trunc(2.6)
	2
	>>> trunc(-2.49)
	-2

.. _exp:

exp
***

:guilabel:`Added in revision 1`

Function ``exp`` returns the exponential (:ref:`num`) of the given value.

* The first and only argument :math:`x` is the value (:ref:`num`) of which the exp :math:`e^x` is wanted

.. code:: aqlp

	>>> exp(0)
	1
	>>> exp(12.1)
	179871.86225375105

.. _factorial:

factorial
*********

:guilabel:`Added in revision 1`

Function ``factorial`` returns the factorial (:ref:`num`) of the given value.

* The first and only argument :math:`x` is the value (:ref:`num`) of which the factorial :math:`x!` is wanted

.. code:: aqlp

	>>> factorial(3)
	6

.. _gcd:

gcd
***

:guilabel:`Added in revision 1`

Function ``gcd`` returns the greatest common divisor (:ref:`num`) of two given integers.

* The first two arguments are the integers (:ref:`num`) of which the GCD is wanted

.. code:: aqlp

	>>> gcd(25, 30)
	5

.. _log:

log
***

:guilabel:`Added in revision 1`

Function ``log`` returns the natural log (:ref:`num`) of the given value.

* The first and only argument :math:`x` is the value (:ref:`num`) of which the natural log :math:`log_e x` is wanted

.. code:: aqlp

	>>> log(10)
	2.302585092994046

.. _log10:

log10
*****

:guilabel:`Added in revision 1`

Function ``log10`` returns the decimal log (:ref:`num`) of the given value.

* The first and only argument :math:`x` is the value (:ref:`num`) of which the decimal log :math:`log_{10} x` is wanted

.. code:: aqlp

	>>> log10(10)
	1

.. _pow:

pow
***

:guilabel:`Added in revision 1`

Function ``pow`` returns the first given value (:ref:`num`) to the power of the second given value.

* The two arguments are the values :math:`x` (:ref:`num`), :math:`y` (:ref:`num`)  used to compute :math:`x^y`

.. code:: aqlp

	>>> pow(3, 2)
	9
	>>> pow(9, 1/2)
	3

.. _round:

round
*****

:guilabel:`Added in revision 1`

Function ``round`` returns the rounded (:ref:`num`) given value.

* The first and only argument :math:`x` is the value used to compute :math:`\lfloor x\rceil` i.e. the rounded value (:ref:`num`)

.. code:: aqlp

	>>> round(2.5)
	3
	>>> round(2.49)
	2

.. _sqrt:

sqrt
****

:guilabel:`Added in revision 1`

Function ``sqrt`` returns the square root (:ref:`num`) of the given value.

* The first and only argument :math:`x` is the value (:ref:`num`) of which the square root :math:`\sqrt{x}` is wanted

.. code:: aqlp

	>>> sqrt(9)
	3

.. _max:

max
***

:guilabel:`Added in revision 1`

Function ``max`` returns the max value (:ref:`num`) in a :ref:`timeseries` or a :ref:`dict`.

* The first and only argument is a :ref:`timeseries` or :ref:`dict` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> max(_)
	200

.. _min:

min
***

:guilabel:`Added in revision 1`

Function ``min`` returns the min value (:ref:`num`) in a :ref:`timeseries` or a :ref:`dict`.

* The first and only argument is a :ref:`timeseries` or :ref:`dict` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> min(_)
	1

.. _formatInt:

formatInt
*********

:guilabel:`Added in revision 4`

Function ``formatInt`` formats a num into a str using the specified base. The num will be treated
as an integer and any decimal part will be truncated.

* The first argument is the :ref:`num` to convert
* The second argument is the base (:ref:`num`)

.. code:: aqlp

	>>> formatInt(4, 2)
	100
	>>> formatInt(4.5, 2)
	100
	>>> formatInt(33, 2)
	100001
	>>> formatInt(15, 16)
	f
	>>> formatInt(29, 16)
	1d
	>>> type(_)
	str

.. _formatFloat:

formatFloat
***********

:guilabel:`Added in revision 4`

Function ``formatFloat`` formats a :ref:`num` (``float64``) into a :ref:`str`, according to the specified format and
precision.

* The first argument is the :ref:`num` to convert
* The second argument is a :ref:`str` of one letter describing the format:

    * ``'b'``: binary exponent
    * ``'e'``: decimal exponent
    * ``'f'``: no exponent
    * ``'x'``: hexadecimal fraction and binary exponent

* The third argument is :ref:a `num` specifying the precision, i.e. the number of digits after the decimal
  point

.. code:: aqlp

	>>> formatFloat(15682.8729, "e", 10)
	1.5682872900e+04
	>>> formatFloat(15682.8729, "f", 10)
	15682.8729000000
	>>> formatFloat(15, "x", 3)
	0x1.e00p+03
	>>> formatFloat(15, "b", 3)
	8444249301319680p-49
	>>> type(_)
	str

.. _parseInt:

parseInt
********

:guilabel:`Added in revision 5`

Function ``parseInt`` converts a :ref:`str` describing an integer in the given base into a :ref:`num`.
The :ref:`str` may begin with either ``+`` or ``-``. If the specified base is :math:`0`, the base is
defined by the :ref:`str`'s prefix: :math:`2` (binary) for ``0b``, :math:`8` for ``0`` or ``0o``, :math:`16`
(hexadecimal) for ``0x``, and :math:`10` (decimal) otherwise.

* The first argument is the :ref:`str` to parse
* The second argument is the base (:ref:`num`)

.. note::

    For base :math:`10`, :ref:`parseInt` is equivalent to simply casting the :ref:`str` to :ref:`num`.

.. code:: aqlp

    >>> parseInt("-5f8a", 16)
    -24458
    >>> parseInt("0x5f8a", 0)
    24458
    >>> parseInt("100011001", 2)
    281
    >>> parseInt("0b100011001", 0)
    281
    >>> parseInt("0b100011001", 2)
    error: input:1:1: failed to parse integer `0b100011001`: invalid syntax
    >>> parseInt("12", 0)
    12
    >>> parseInt("12", 10) == num("12")
    true
    >>> parseInt("012", 0)
    10
    >>> parseInt("012", 10)
    12
    >>> parseInt("12", 10)
    12

.. _formatBits:

formatBits
***********
:guilabel:`Added in revision 5`

The function ``formatBits`` formats a number (:ref:`num`) of bits (or bytes) into a human-readable :ref:`str` using units such as kilo ("K"), mega ("M") etc., based on the given precision

* The first argument is the size (:ref:`num`) to convert
* The second argument is a :ref:`num` specifying the precision, i.e., the number of digits after the decimal point

.. code:: aqlp

    >>> formatBits(1000, 2)
    1.00 K
    >>> formatBits(1000, 0)
    1 K
    >>> formatBits(1000, 0)
    1 K
    >>> formatBits(1000000, 0)
    1 M
    >>> formatBits(1000000000, 0)
    1 G
    >>> formatBits(3141592653589, 5)
    3.14159 T
    >>> formatBits(2718281828459, 6)
    2.718282 T
    >>> formatBits(8000000/8, 0) + "B" # turn bits into bytes
    1 MB

Stats functions
^^^^^^^^^^^^^^^

.. _dsum:

dsum
****

:guilabel:`Added in revision 1`

Function ``dsum`` returns the non-weighted sum of values (:ref:`num`) in a :ref:`timeseries`.

* The first and only argument is a :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> dsum(_)
	216

.. _dmean:

dmean
*****

:guilabel:`Added in revision 1`

Function ``dmean`` returns the non-weighted mean value (:ref:`num`) of a :ref:`timeseries`.

* The first and only argument is a :ref:`timeseries` containing plain :ref:`num` values


.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> dmean(_)
	54

.. _dmedian:

dmedian
*******

:guilabel:`Added in revision 1`

Function ``dmedian`` returns the non-weighted median (:ref:`num`) of a :ref:`timeseries`.

* The first and only argument is a :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> dmedian(_)
	2

.. _dpercentile:

dpercentile
***********

:guilabel:`Added in revision 1`

Function ``dpercentile`` returns the non-weighted nth percentile (:ref:`num`) of a :ref:`timeseries`.

* The first argument is a :ref:`timeseries` containing plain :ref:`num` values
* The second argument is a :ref:`num` specifying the percentile. If it is greater than 100 or lower than 0, the return value will be 0.


.. code:: aqlp

	>>> let a = `analytics:/path/to/data`[3] | field("numfield")
	>>> a
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> dpercentile(a, 50)
	2
	>>> dpercentile(a, 90)
	200

.. _dvariance:

dvariance
*********

:guilabel:`Added in revision 1`

Function ``dvariance`` returns the non-weighted statistical variance (:ref:`num`) of a :ref:`timeseries`.

* The first and only argument is a :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> dvariance(_)
	9503.333333333334

.. _dstddev:

dstddev
*******

:guilabel:`Added in revision 1`

Function ``dstddev`` returns the non-weighted standard deviation (:ref:`num`) of a :ref:`timeseries`.

* The first and only argument is a :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> let a = `analytics:/path/to/data`[3] | field("numfield")
	>>> a
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> dstddev(a)
	97.48504158758581
	>>> sqrt(dvariance(a))
	97.48504158758581

.. _dskew:

dskew
*****

:guilabel:`Added in revision 1`

Function ``dskew`` returns the non-weighted skewness of distribution (:ref:`num`) for data in a :ref:`timeseries`.

* The first and only argument is a :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> dskew(_)
	0.7431002727844832

dkurtosis
*********

:guilabel:`Added in revision 1`

Function ``dkurtosis`` returns the non-weighted kurtosis of distribution (:ref:`num`) for data in a :ref:`timeseries`.

* The first and only argument is a :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> dkurtosis(_)
	-1.6923313578244437

.. _sum:

sum
***

:guilabel:`Added in revision 1`

Function ``sum`` returns the sum of the :ref:`num` values in a :ref:`timeseries` or a :ref:`dict`.
If applied to a :ref:`timeseries`, the result is time-weighted.

* The first and only argument is a :ref:`dict` or :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> sum(_)
	216
	>>> let d = newDict()
	>>> d["key1"] = 13
	>>> d["key2"] = 1
	>>> d["key3"] = 2
	>>> d["key4"] = 200
	>>> sum(d)
	216

.. _mean:

mean
****

:guilabel:`Added in revision 1`

Function ``mean`` returns the mean of the :ref:`num` values in a :ref:`timeseries` or a :ref:`dict`. If applied to a :ref:`timeseries`, the result is time-weighted.

* The first and only argument is a :ref:`dict` or :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> mean(_)
	54 # will be different from dmean if space between the timestamps (weight) is not constant
	>>> let d = newDict()
	>>> d["key1"] = 13
	>>> d["key2"] = 1
	>>> d["key3"] = 2
	>>> d["key4"] = 200
	>>> mean(d)
	54

.. _median:

median
******

:guilabel:`Added in revision 1`

Function ``median`` returns the median of the :ref:`num` values in a :ref:`timeseries` or a :ref:`dict`. If applied to a :ref:`timeseries`, the result is time-weighted.

* The first and only argument is a :ref:`dict` or :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> median(_)
	2 # will be different from dmedian if space between the timestamps (weight) is not constant
	>>> let d = newDict()
	>>> d["key1"] = 13
	>>> d["key2"] = 1
	>>> d["key3"] = 2
	>>> d["key4"] = 200
	>>> median(d)
	2

.. _percentile:

percentile
**********

:guilabel:`Added in revision 1`

Function ``percentile`` returns the time-weighted nth percentile (:ref:`num`) of a :ref:`timeseries` or a :ref:`dict`.
If applied to a :ref:`timeseries`, the result is time-weighted.

* The first argument is a :ref:`timeseries` or a :ref:`dict` containing plain :ref:`num` values
* The second argument is a :ref:`num` specifying the percentile. If it is greater than :math:`100` or lower than :math:`0`, the return value will be :math:`0`.

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> percentile(_, 90)
	200 # will be different from dpercentile if space between the timestamps (weight) is not constant
	>>> let d = newDict()
	>>> d["key1"] = 13
	>>> d["key2"] = 1
	>>> d["key3"] = 2
	>>> d["key4"] = 200
	>>> percentile(d, 90)
	200

.. _variance:

variance
********

:guilabel:`Added in revision 1`

Function ``variance`` returns the statistical variance of the :ref:`num` values in a :ref:`timeseries` or a :ref:`dict`.
If applied to a :ref:`timeseries`, the result is time-weighted.

* The first and only argument is a :ref:`dict` or :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> variance(_)
	9503.333333333334 # will be different from dvariance if space between the timestamps (weight) is not constant
	>>> let d = newDict()
	>>> d["key1"] = 13
	>>> d["key2"] = 1
	>>> d["key3"] = 2
	>>> d["key4"] = 200
	>>> variance(d, 90)
	9503.33333333

.. _stddev:

stddev
******

:guilabel:`Added in revision 1`

Function ``stddev`` returns the standard deviation of the :ref:`num` values in a :ref:`timeseries` or a :ref:`dict`.
If applied to a :ref:`timeseries`, the result is time-weighted.

* The first and only argument is a :ref:`dict` or :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> stddev(_)
	97.485041588 # will be different from dstddev if space between the timestamps (weight) is not constant
	>>> let d = newDict()
	>>> d["key1"] = 13
	>>> d["key2"] = 1
	>>> d["key3"] = 2
	>>> d["key4"] = 200
	>>> stddev(d, 90)
	97.485041588

.. _skew:

skew
****

:guilabel:`Added in revision 1`

Function ``skew`` returns the skewness of dist.n of the :ref:`num` values in a :ref:`timeseries` or a :ref:`dict`.
If applied to a :ref:`timeseries`, the result is time-weighted. If the :ref:`timeseries` has exactly one element, :math:`0` is returned.

* The first and only argument is a :ref:`dict` or :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> skew(_)
	0.7431002727844832 # will be different from dskew if space between the timestamps (weight) is not constant
	>>> let d = newDict()
	>>> d["key1"] = 13
	>>> d["key2"] = 1
	>>> d["key3"] = 2
	>>> d["key4"] = 200
	>>> skew(d, 90)
	0.7431002727844832

.. _kurtosis:

kurtosis
********

:guilabel:`Added in revision 1`

Function ``kurtosis`` returns the kurtosis of dist.n of the :ref:`num` values in a :ref:`timeseries` or a :ref:`dict`.
If applied to a :ref:`timeseries`, the result is time-weighted. If the :ref:`timeseries` has exactly one element, :math:`0` is returned.

* The first and only argument is a :ref:`dict` or :ref:`timeseries` containing plain :ref:`num` values

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		tstamp1: 13
		tstamp2: 1
		tstamp3: 2
		tstamp4: 200
	}
	>>> skew(_)
	0.7431002727844832 # will be different from dskew if space between the timestamps (weight) is not constant
	>>> let d = newDict()
	>>> d["key1"] = 13
	>>> d["key2"] = 1
	>>> d["key3"] = 2
	>>> d["key4"] = 200
	>>> skew(d, 90)
	0.7431002727844832

.. _rate:

rate
****

:guilabel:`Added in revision 1`

Function ``rate`` returns a :ref:`timeseries` of rates computed from the initial :ref:`timeseries`' :ref:`num` values.

* The first and only argument is the input :ref:`timeseries` of :ref:`num`

.. code:: aqlp

	>>> `analytics:/path/to/data`[3] | field("numfield")
	timeseries{
		2019-08-31 00:00:00: 1
		2019-08-31 00:01:00: 10
		2019-08-31 00:02:00: 50
		2019-08-31 00:03:00: 110
		2019-08-31 00:04:00: 230
	}
	>>> rate(_)
	timeseries{
		2019-08-31 00:00:00: 0.016666666666666666
		2019-08-31 00:01:00: 0.15
		2019-08-31 00:02:00: 0.6666666666666666
		2019-08-31 00:03:00: 1
		2019-08-31 00:04:00: 2
	}

.. _linregression:

linregression
*************

:guilabel:`Added in revision 3`

Function ``linregression`` produces a linear fit of a :ref:`timeseries` of :ref:`num`.

* The first and only argument is the input :ref:`timeseries` of :ref:`num`

It returns a :ref:`dict` with  4 entries ``slope``, ``intercept``, ``R2`` and ``fit``. The ``fit`` entry is a :ref:`timeseries`
with :ref:`num` values corresponding to the fitted line on the input :ref:`timeseries`' timestamps. The ``slope``
and ``intercept`` are in seconds.

.. code:: aqlp

	>>> `analytics:/path/to/data`[5m] | field("numfield")
	timeseries{
		start: 2021-10-14 13:57:55.000545 +0100 IST
		end: 2021-10-14 14:02:55.000545 +0100 IST
		2021-10-14 13:57:00 +0100 IST: 3.801633107494212e-05
		2021-10-14 13:58:00 +0100 IST: 7.653320559746086e-05
		2021-10-14 13:59:00 +0100 IST: 3.971200542852744e-05
		2021-10-14 14:00:00 +0100 IST: 3.981215360110563e-05
		2021-10-14 14:01:00 +0100 IST: 5.2121957107961934e-05
		2021-10-14 14:02:00 +0100 IST: 3.838672949594982e-05
	}
	>>> linregression(_)
	dict{
		R2: 0.06273653863866613
		fit: timeseries{
			start: 2021-10-14 13:57:00 +0100 IST
			end: 2021-10-14 14:02:00 +0100 IST
			2021-10-14 13:57:00 +0100 IST: 5.252194027605128e-05
			2021-10-14 13:58:00 +0100 IST: 5.0485322987015024e-05
			2021-10-14 13:59:00 +0100 IST: 4.844870569797877e-05
			2021-10-14 14:00:00 +0100 IST: 4.641208840183708e-05
			2021-10-14 14:01:00 +0100 IST: 4.4375471112800824e-05
			2021-10-14 14:02:00 +0100 IST: 4.2338853823764566e-05
		}
		intercept: 55.47126937459381
		slope: -3.39436215194667e-08
	}

.. _ewlinregression:

ewlinregression
***************

:guilabel:`Added in revision 3`

Function ``ewlinregression`` produces a linear fit of a :ref:`timeseries` of :ref:`num` using exponentially
decaying weights. The older the value in the :ref:`timeseries` the smaller the weight. The latest value is
always given a weight of :math:`1`.

* The first argument is the input :ref:`timeseries` of :ref:`num`
* The second argument is the desired weight that a point with time x seconds in the past would have
* the third argument is how long ago that time :math:`x` is, in seconds


It returns a :ref:`dict` with  4 entries ``slope``, ``intercept``, ``R2`` and ``fit``. The ``fit`` entry is a :ref:`timeseries`
with :ref:`num` values corresponding to the fitted line on the input :ref:`timeseries`' timestamps. The ``slope``
and ``intercept`` are in seconds.

.. code:: aqlp

	>>> `analytics:/path/to/data`[5m] | field("numfield")
	timeseries{
		start: 2021-10-14 13:57:55.000545 +0100 IST
		end: 2021-10-14 14:02:55.000545 +0100 IST
		2021-10-14 13:57:00 +0100 IST: 3.801633107494212e-05
		2021-10-14 13:58:00 +0100 IST: 7.653320559746086e-05
		2021-10-14 13:59:00 +0100 IST: 3.971200542852744e-05
		2021-10-14 14:00:00 +0100 IST: 3.981215360110563e-05
		2021-10-14 14:01:00 +0100 IST: 5.2121957107961934e-05
		2021-10-14 14:02:00 +0100 IST: 3.838672949594982e-05
	}
	>>> ewlinregression(_, 0.01, 100.0)
	dict{
		R2: 0.34201204121343765
		fit: timeseries{
			start: 2021-10-14 14:03:00 +0100 IST
			end: 2021-10-14 14:08:00 +0100 IST
			2021-10-14 14:03:00 +0100 IST: 4.5425229615148055e-05
			2021-10-14 14:04:00 +0100 IST: 4.4509288322558405e-05
			2021-10-14 14:05:00 +0100 IST: 4.359334702641604e-05
			2021-10-14 14:06:00 +0100 IST: 4.267740573382639e-05
			2021-10-14 14:07:00 +0100 IST: 4.176146444123674e-05
			2021-10-14 14:08:00 +0100 IST: 4.0845523145094376e-05
		}
		intercept: 24.94748623552414
		slope: -1.526568822982724e-08
	}

String manipulation
^^^^^^^^^^^^^^^^^^^

.. _strToUpper:

strToUpper
**********

:guilabel:`Added in revision 1`

Function ``strToUpper`` returns uppercase version of given :ref:`str`.

* The first and only parameter is a :ref:`str` to convert to uppercase

.. code:: aqlp

	>>> strToUpper("ToUpper")
	"TOUPPER"

.. _strToLower:

strToLower
**********

:guilabel:`Added in revision 1`

Function ``strToLower`` returns lowercase version of given :ref:`str`.

* The first and only parameter is a :ref:`str` to convert to lowercase

.. code:: aqlp

	>>> strToLower("ToLower")
	"TOLOWER"

.. _strContains:

strContains
***********

:guilabel:`Added in revision 1`

Function ``strContains`` returns whether the first :ref:`str` contains the second :ref:`str`.

* Both arguments to the function are :ref:`str`

.. code:: aqlp

	>>> strContains("thatistext", "is")
	true

.. _strCount:

strCount
********

:guilabel:`Added in revision 1`

Function ``strCount`` returns the number of occurrences of the second :ref:`str` in the first :ref:`str`.

* Both arguments to the function are :ref:`str`

.. code:: aqlp

	>>> strCount("tertarter", "te")
	2

.. _strIndex:

strIndex
********

:guilabel:`Added in revision 1`

Function ``strIndex`` returns the index of the first occurrence of the second :ref:`str` in the first :ref:`str`, and -1 if it is not present.

* Both arguments to the function are :ref:`str`

.. code:: aqlp

	>>> strIndex("thatistext", "is")
	4

.. _strReplace:

strReplace
**********

:guilabel:`Added in revision 1`

Function ``strReplace`` returns a copy of the first :ref:`str`, where occurrences of the second :ref:`str` are replaced by the third :ref:`str`.

* The three arguments to the function are :ref:`str`

.. code:: aqlp

	>>> strReplace("thatistext", "is", "was")
	"thatwastext"

.. _strHasPrefix:

strHasPrefix
************

:guilabel:`Added in revision 1`

Function ``strHasPrefix`` returns whether the first :ref:`str` starts with the second :ref:`str`.

* Both arguments to the function are :ref:`str`

.. code:: aqlp

	>>> strHasPrefix("thatistext", "is")
	false
	>>> strHasPrefix("thatistext", "that")
	true

.. _strHasSuffix:

strHasSuffix
************

:guilabel:`Added in revision 1`

Function ``strHasSuffix`` returns whether the first :ref:`str` ends with the second :ref:`str`.

* Both arguments to the function are :ref:`str`

.. code:: aqlp

	>>> strHasSuffix("thatistext", "xt")
	true

.. _strSplit:

strSplit
********

:guilabel:`Added in revision 1`

Function ``strSplit`` returns a :ref:`timeseries` of :ref:`str`. The function splits the first :ref:`str` into substrings, separated by the second :ref:`str`.

* Both arguments to the function are :ref:`str`

.. code:: aqlp

	>>> strSplit("that./is.text", "./")
	timeseries{
		0000-00-00 00:00:00.000000001: "that"
		0000-00-00 00:00:00.000000002: "is.text"
	}

.. _strCut:

strCut
******

:guilabel:`Added in revision 4`

Function ``strCut`` returns the portion of a :ref:`str` between two indexes (excluding ending index).

Negative indexes start from the end of the input :ref:`str`.

* The first argument (:ref:`str`) is the string from which the portion is returned
* The second argument (:ref:`num`) is the starting index
* The third argument (:ref:`num`) is the ending index

.. code:: aqlp

	>>> strCut("0123456789", 1, 4)
	123
	>>> strCut("0123456789", -8, -2)
	234567
	>>> strCut("abcd", 1, 3)
	bc

.. _strJoin:

strJoin
*******

:guilabel:`Added in revision 5`

Function ``strJoin`` joins a :ref:`dict` or :ref:`timeseries` of :ref:`str` into a single :ref:`str` with a separator.

* The first argument: a :ref:`dict` or :ref:`timeseries` of :ref:`str`
* The second argument: a separator :ref:`str`

.. code:: aqlp

	>>> let d = newDict() | setFields("a", "aa", "b", "bb", "c", "cc")
	>>> strJoin(d, ", ")
	"aa, bb, cc"
	>>> "{" + strJoin(d | map(str(_key)), "; ") + " }"
	"{ a; b; c }"

.. _reFindAll:

reFindAll
*********

:guilabel:`Added in revision 1`

Function ``reFindAll`` returns a :ref:`timeseries` of :ref:`str` which contains matches of the second :ref:`str` (regex) in the first :ref:`str`.

* Both arguments to the function are :ref:`str`

.. code:: aqlp

	>>> reFindAll("i am a string with text", "i[a-z]+")
	timeseries{
		0000-00-00 00:00:00.000000001: "ing"
		0000-00-00 00:00:00.000000002: "ith"
	}

.. _reMatch:

reMatch
*******

:guilabel:`Added in revision 1`

Function ``reMatch`` returns whether the first :ref:`str` contains matches of the second :ref:`str` (regex).

* Both arguments to the function are :ref:`str`

.. code:: aqlp

	>>> reMatch("i am a string with text", "i[a-z]+")
	true

.. _reFindCaptures:

reFindCaptures
**************

:guilabel:`Added in revision 1`

Function ``reFindCaptures`` returns a :ref:`timeseries` of :ref:`str` lists. Each list contains the full match followed by each capture

* Both arguments to the function are :ref:`str`. The first one is the :ref:`str` to match, and the second is the regular expression

.. code:: aqlp

	>>> reFindCaptures("foobarbaztootartaz", "foo")
	timeseries{
		0000-00-00 00:00:00.000000001: ["foo"]
	}
	>>> reFindCaptures("foobarbaztootartaz", "(foo)")
	timeseries{
		0000-00-00 00:00:00.000000001: ["foo", "foo"]
	}
	>>> reFindCaptures("foobarbaztootartaz", "f(oo)")
	timeseries{
		0000-00-00 00:00:00.000000001: ["foo", "oo"]
	}
	>>> reFindCaptures("foobarbaztootartaz", "(oo)")
	timeseries{
		0000-00-00 00:00:00.000000001: ["oo", "oo"]
		0000-00-00 00:00:00.000000002: ["oo", "oo"]
	}
	>>> reFindCaptures("foobarbaztootartaz", "[ft](oo)")
	timeseries{
		0000-00-00 00:00:00.000000001: ["foo", "oo"]
		0000-00-00 00:00:00.000000002: ["too", "oo"]
	}
	>>> reFindCaptures("foobarbaztootartaz", "([ft])(oo)")
	timeseries{
		0000-00-00 00:00:00.000000001: ["foo", "f", "oo"]
		0000-00-00 00:00:00.000000002: ["too", "t", "oo"]
	}
	>>> reFindCaptures("foobarbaztootartaz", "[ft](oo).*(az)")
	timeseries{
		0000-00-00 00:00:00.000000001: ["foobarbaztootartaz", "oo", "az"]
	}

CLI-only Functions
^^^^^^^^^^^^^^^^^^^^^

.. warning::

	The functions described in this section can only be used in CLI. They cannot be called from a service
	or through a Web interface.

.. _help:

help
****

:guilabel:`Added in revision 1`

Function ``help`` returns the help of all filters and functions as a formatted :ref:`str`.

.. code:: aqlp

	>>> help()
	# Functions
	## now
	- Function `now` returns the current time. Time is constant across all the script, so that all operations and queries have the same reference time
	[...]

.. _dump:

dump
****

:guilabel:`Added in revision 1`

Function ``dump`` attempts to dump variables from the interpreter into a file.

* The first and only argument is the path to the file (:ref:`str`)

.. code:: aqlp

	>>> let myVar = 2
	>>> dump("file.dump")

.. _load:

load
****

:guilabel:`Added in revision 1`

Function ``load`` attempts to load variables into the interpreter from a file.

* The first and only argument is the path to the file (:ref:`str`)

.. code:: aqlp

	>>> load("file.dump")
	true
	>>> myVar
	2
	>>> let myVar = 5
	>>> if load("file.dump") {
	...     myVar
	... }
	2

.. _plot:

plot
****

:guilabel:`Added in revision 1`

Function ``plot`` plots a :ref:`timeseries` or :ref:`dict` of :ref:`num` values.

* The first argument is the :ref:`timeseries` or :ref:`dict` of :ref:`num` values to plot
* The second argument (optional) is the path (:ref:`str`) to the image PNG file to write the plot to. If not specified, defaults to ``plot.png``

.. code:: aqlp

	>>> plot(myTimeseriesOrDict, "myplotimg.png")
