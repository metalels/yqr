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

## Installation (Option)

By using [Hashie gem](https://rubygems.org/gems/hashie/) together, even simpler access becomes possible.

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

$ yqr --file example1.yaml [dog][0]
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

$ yqr ".find{|a| a[kind] == 'dog'}[name]" < example2.yaml
pochi

$ cat example2.yaml | bundle exec yqr ".select{|a| a[kind] == 'cat'}.last[name]"
buchi
```

## Usage (Output-type)

```
$ cat example4.yaml
---
cat:
  - name: mike
    sex: male
  - name: tama
    sex: female

# Default output type is yaml
$ yqr --file example4.yaml "[cat].first"
---
:name: mike
:sex: male

# Raw output type (Object.to_s)
$ yqr --file example4.yaml --raw "[cat].first"
{:name=>"mike", :sex=>"male"}

# Json output type
$ yqr --file example4.yaml --json "[cat].first"
{"name":"mike","sex":"male"}
```

### Enable Hashie access

if you install [Hashie gem](https://rubygems.org/gems/hashie/), you can also use query as:

```
$ yqr --file example4.yaml ".cat.first"
---
:name: mike
:sex: male

$ yqr --file example4.yaml --raw ".cat.first"
#<Hashie::Mash name="mike" sex="male">
```

## Contributing
git-flow.

