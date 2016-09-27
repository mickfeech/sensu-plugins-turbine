# sensu-plugins-turbine

[![Build Status](https://travis-ci.org/mickfeech/sensu-plugins-turbine.svg?branch=master)](https://travis-ci.org/mickfeech/sensu-plugins-turbine)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-turbine.svg)](https://badge.fury.io/rb/sensu-plugins-turbine)

## Functionality
Sensu plugin to obtain turbine.stream metrics.

## Files
- bin/metrics-turbine.rb

## Usage

**metrics-turbine.rb**

```
Usage: ./metrics-turbine.rb (options)
    -s SCHEME                        Graphite storage scheme
    -t POOLNAME                      The pool name requested (required)
    -u URL                           Full URL path to the turbine stream (required)
```

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)
