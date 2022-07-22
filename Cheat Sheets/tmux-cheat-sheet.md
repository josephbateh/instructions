# TMUX Cheat Sheet

### Start Session

Start a session

```shell
tmux
```

Start a session with a name

```shell
tmux new -s database
```

Rename an existing session

```shell
tmux rename-session -t {{session}} database
```

### Split Panes

Split left and right:

```shell
CTRL + b, %
```

Split top and bottom:

```shell
CTRL + b, "
```

### Navigating Panes

```shell
CTRL + b, {{arrow-key}}
```

### Closing Panes

```shell
CTRL + d
```

### Creating New Windows

```shell
CTRL + b, c
```

### Switching Windows

Previous window

```shell
CTRL + b, p
```

Next window

```shell
CTRL + b, n
```

Numbered window

```shell
CTRL + b, {{number}}
```

### Renaming Windows

```shell
CTRL + b, ,
```

### Detach Session

Detach all

```shell
CTRL + b, d
```

Detach specific sessions

```shell
CTRL + b, D
```

### Attach Session

```shell
tmux ls
```

Figure out session

```shell
tmux attach -t {{session}}
```

