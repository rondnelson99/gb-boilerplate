# VCS-boilerplate

A minimal, customizable, ready-to-compile boilerplate for Atari VCS (2600) WLA-DX projects. Directly adapted from ISSOtm's gb-boilerplate for the Game Boy. WLA-DX isn't very popular in the VCS community, but if you're more familiar with RGBDS and are looking for a similarly powerful and more familiar toolchain for the VCS, this could come in handy.

## Downloading

You can simply clone the repository using Git, or if you just want to download this, click the `Clone or download` button up and to the right of this. This repo is also usable as a GitHub template for creating new repositories.

## Setting up

Make sure you have the latest version of WLA-6502 installed.

## Customizing

Edit `project.mk` to customize most things specific to the project (like the game name, file name and extension, etc.). Everything has accompanying doc comments.

Everything in the `src` folder is the source, and can be freely modified however you want. The basic structure in place should hint you at how things are organized. If you want to create a new "module", you simply need to drop a `.asm` file in the `src` directory, name does not matter. All `.asm` files in that root directory will be individually compiled by RGBASM.

If you want to add resources, I recommend using the `src/res` folder. Add rules in the Makefile.
## Compiling

Simply open you favorite command prompt / terminal, place yourself in this directory (the one the Makefile is located in), and run the command `make`. This should create a bunch of things, including the output in the `bin` folder.

If you get errors that you don't understand, try running `make clean`. If that gives the same error, try deleting the `deps` folder. If that still doesn't work, try deleting the `bin` and `obj` folders as well. If that still doesn't work, you probably did something wrong yourself.



