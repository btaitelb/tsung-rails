tsung-rails
===========

Description
-----------
[Tsung](http://tsung.erlang-projects.org/) is an robust load-testing tool that makes it easy to record sessions and then play them back, with dynamic data and a massively scalable client base. The goal of tsung-rails is to provide some automation for common tasks, especially related to rails testing.

Status
------
This is an experimental library, meant for testing. It should never be added as a production dependency (you can still test production servers from a development environment if you *really* want to do that).

This was developed on OSX Lion, using homebrew 0.8.1, erlang R14B04, tsung 1.4.1, rails 3, and ruby 1.9.2. Since it hasn't been ported to other environments yet, it will likely fail in these. Please consider contributing and then removing this message.

Installation
------------
 1. Add `gem 'tsung-rails'` to your `Gemfile`
 1. Run `rails g tsung:install` [TODO: not implemented yet!]
 1. Run `rake tsung:check` to ensure tsung is installed and the gem can see it

Usage
-----
By default, tsung creates an http proxy on `localhost:8090`. I like to have a firefox profile specifically for recording via this proxy that I leave with these default settings.

 * Start recording (and give the recording a useful name)

```bash
% rake tsung:record RECORDING=login
```

 * Play back the last recording

```bash
% rake tsung:play
```

 * List recordings

```bash
% rake tsung:recordings:list
```


 * Play back a specific recording

```bash
% rake tsung:play RECORDING=login
```

Contributing
------------
You know the game: fork, hack, pull request.


Known Issues
------------
 * tsung-rails's understanding of object creation is currently very basic, and does not support nested resources, PUTs, or subsequent GETs to the same resource.
 * when POST data is sent as form/multipart, tsung records the data into a separate file, which currently isn't being picked up by tsung-rails

Future Work
-----------
 * refactor to leverage rails configuration params (but also work standalone)
 * refactor to move all platform-specific logic to platform.rb
 * use knowledge of config/routes.rb in rails to allow for better dynamic handling of object (and nested-object) creation / redirects / links / etc.
 * automate both recording and playback via rspec and/or cucumber tests

License
-------
Released under the MIT License. See the [LICENSE][license] file for further details.

[license]: https://github.com/btaitelb/tsung-rails/blob/master/LICENSE.md
