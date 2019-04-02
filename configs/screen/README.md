## Screen Configuration
* Use this Variable `$STY` for know the Sockname of screen

## How to use the screen

**For Help use Shorcut**
`CTRL-a + ?`

* Create a new Screen session
```shell
$ screen -S SCREENID #creates a session with a name. name can be used to reattach at a later stage
```

* Detach from a screen session
```shell
$ screen -d SCREENID #when the command screen is running in another terminal, remote detach
```

* List screen sessions
```shell
$ screen -ls #it will list all the existing screen sessions
```

* Rename sockname for sessions
```shell
$ screen -S old_session_name -X sessionname new_session_name
```

* Reattach to a screen session
```shell
$ screen -r #attaches to default session. this works only if you have one screen session
```
```shell
$ screen -r <SCREENID> #attaches to particular screen session
```
```shell
$ screen -r name #attaches to specific session (unique name specified during the creation of the screen session)
```

* Kill the deattached screen session
```shell
$ screen -X -S SCREENID quit
```
```shell
$ screen -S SCREENID -X quit
```

* Lock screen session
```shell
$ CTRL-a x #it will lock your screen session quickly while you are in the screen session
```
