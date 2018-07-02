[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](MIT-LICENSE)  
[![Build Status](https://travis-ci.org/metalels/yqr.svg?branch=master)](https://travis-ci.org/metalels/yqr)  

# Yqr
Yaml query executer is written in ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yqr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yqr

## Usage

```
$ cat example1.yaml
---
cat:
- mike
- buchi
dog:
- pochi
- koro

$ cat example1.yaml | yqr [dog][0]
pochi

$ cat example2.yaml
---
- name: mike
  kind: cat
- name: pochi
  kind: dog
- name: buchi
  kind: cat
- name: koro
  kind: dog

$ cat example2.yaml | yqr ".find{|a| a[kind] == 'dog'}[name]"
pochi
```

## Contributing
git-flow.

