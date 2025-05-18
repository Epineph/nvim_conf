# My nvim_conf
------------

Yes, by navigating buffers, I mean switching between multiple open files within Neovim. Neovim can indeed be used in a way similar to tmux, where you can manage multiple files, split windows, and navigate between them efficiently.

Using Neovim Like tmux
Neovim has powerful window and buffer management features that allow you to work with multiple files and split windows. Here are some commands and shortcuts that can help

* Splitting Windows
* Navigating Windows
* Managing Buffers

## Splitting Windows
### Splitting horizontally

```vim<Esc>Go`````<Esc>````
```vim<Esc>Go`````<Esc>````
$ `:split` or
$ ``:sp:`` 

### Splitting vertically

Split the current window horizontally.
``:vsplit`` or ``:vsp:`` Split the current window vertically.

## Navigating Windows:

```vim<Esc>Go`````<Esc>````
```vim<Esc>Go`````<Esc>````
```vim<Esc>Go`````<Esc>````
```vim<Esc>Go`````<Esc>````
```vim<Esc>Go`````<Esc>````
* ``Ctrl-w h:`` Move to the window to the left.
* ``Ctrl-w j:`` Move to the window below.
* ``Ctrl-w k:`` Move to the window above.
* ``Ctrl-w l:`` Move to the window to the right.

### Managing Buffers:

* ``:bnext`` or ``:bn:`` Go to the next buffer.
* ``:bprev`` or ``:bp:`` Go to the previous buffer.
* ``:buffer`` [number] or ``:b`` [number]: Switch to a specific buffer by number.

``:ls`` or ``:buffers:`` List all open buffers.

## Tabs

* ``Tabs:``

cv

Commenting Every Instance of $NVIM_CONF_DIR
To comment every instance of a variable like $NVIM_CONF_DIR, you can use a global command in Vim/Neovim. Here is the syntax:

Basic Commenting with Global Command:
