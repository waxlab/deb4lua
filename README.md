Deb 4 Lua
=========

Lua related packages for Debian related OSes.


This repository aims to profide easy access to different Lua related programs
and libraries in Debian package format (`.deb`).

The Deb 4 Lua is not affiliated with Debian neither with PUC-Rio.
Debian is a registered trademark owned by Software in the Public Interest, Inc.

The packages under this repository have licenses orbiting the OpenSource
philosophy. Choosing to use one of them you must know their terms and limitations.

What this repository contains?

- Packages for different programs, usually not present in default Linux distros
or not sufficiently updated or tweaked.
- Simple scripts for building or packaging automation.
- Readme files pointing about each package usage and respective project info.


To include a package here, they should strictly:

- Be Open Source (under MIT, GPL, Public Domain etc. licensing)
- Make use of Lua, extend it or be a strictly relate tool to develop using Lua.
- Have not a Debian official package or be a edge version built upon more
stable Debian dev dependencies
- Be tested under Debian (while in most of times it works on Debian derivatives,
the primary purpose is to provide a useful package runnable under Debian
stable/testing.
- Have a Lua script runnable under Lua 5.4 responsible to build or package.
- Have a readme.md with the most basic description of the matter and a link to
the target project. It is desirable to have a link pointing to the documentation.

It is also desirable:

- have support for the most recent Lua version
- have a link pointing to a documentation on the readme file.
