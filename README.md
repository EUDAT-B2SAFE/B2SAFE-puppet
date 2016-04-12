# B2SAFE deployment recipes for puppet

[![Build Status](https://travis-ci.org/EUDAT-B2SAFE/b2safe-puppet.svg?branch=master)](https://travis-ci.org/EUDAT-B2SAFE/b2safe-puppet)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with b2drop](#setup)
    * [What b2drop affects](#what-b2drop-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with b2drop](#beginning-with-b2drop)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Testing

For testing, just execute 

mkdir vendor
export GEM_HOME=vendor
bundle install
bundle exec rake test