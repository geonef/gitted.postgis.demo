# How to setup Gitted for an application

This page explains how to turn a web application into a Gitted-enabled
GIT repository.

* Parent: [README.md](../README.md)


## Initialize a GIT repository with the minimal Gitted sysconf

```
git init my-app
cd my-app
```

Before going further, you need to make the *master* branch exist by
creating a commit:
```
touch README.md
git add README.md
git commit -m "initial commit"
```

Then import the
[sysconf.gitted profile](https://github.com/geonef/sysconf.gitted) and
its dependency [sysconf.base](https://github.com/geonef/sysconf.base):

```
git subtree add -P sysconf/sysconf.gitted git@github.com:geonef/sysconf.gitted.git master
git subtree add -P sysconf/sysconf.base git@github.com:geonef/sysconf.base.git master
mkdir sysconf/actual
echo sysconf.gitted >sysconf/actual/deps
```

Make the symlink to ease the usage of gitted:
```
ln -s sysconf.gitted/tree/usr/bin/gitted-client sysconf/gitted-client
```

Commit the whole:
```
git add sysconf/actual sysconf/gitted-client
git commit -m "gathered sysconf profiles"
```
Done!


## Try the minimal system

```
sysconf/gitted-client register
sysconf/gitted-client add test-vm
git push test-vm master
```

The construction of the LXC container happens during the ```git
push``` operation.

You may check that the system is fine and running by listing:
```
lxc-ls -f
```

You may want to start an interactive shell:
```
lxc-attach -n test-vm /bin/bash
```

Everything is okay? Then destroy the container for now:
```
lxc-destroy -f -n test-vm
```

## Setup your custom system in sysconf/actual

* Put into ```sysconf/actual/tree``` any file that you need on
  the system. For example,
  ```sysconf/actual/tree/etc/custom.conf``` will be installed
  as ```/etc/custom.conf``` on the system.
  
* Put into ```sysconf/actual/install.sh``` any shell commands
  that need to run to setup the system, for example ```apt-get
  install``` commands, or generating config files

* To run the system again:
```
sysconf/gitted-client register    # because sysconf has changed
git push test-vm master
```

## Update your README with how to run it

* See the [Example README](example-of-readme.md) and update your own
  with the instructions on how to run the service.

## Syncronizing Sysconf work with git push/pull

_Software is data !_

Sysconf, which represents the non-changing part of the machine (it's configuration, not data), is treated as if it were data.

If you patch an ```apt-get```, ```/etc``` config  or anything, you want to work live inside the container. Gitted will export these changes into the Gitted repository, that you can use to patch other containers.

(to work on Sysconf and save/propagate the changes without re-building the container)
### Pull Sysconf from container to repository

You can work on your live Sysconf inside the container (using _nano_ in a _lxc-attach_ shell, or through SSH), in ```/sysconf```. Then commit these files inside ```/sysconf```. On the next ```git fetch <container>```, it will be exported to the ```sysconf/``` git-subtree directory, thanks to [gitted/export/git-subtree](../tree/usr/share/gitted/export/git-subtree), controlled by
[/etc/gitted/sync/master.sysconf.export](../tree/etc/gitted/sync/master.sysconf.export)

### Push Sysconf from updates to existing repository

This is like _patching_ a living machine with Sysconf updates instead of killing it and create a fresh one.
It just works, thanks to  thanks to [gitted/export/git-subtree](../tree/usr/share/gitted/import/git-subtree), controlled by [/etc/gitted/sync/master.sysconf.export](../tree/etc/gitted/sync/master.sysconf.import)

```git push <container> master``` will import the new ```sysconf```.

### Share/update specific Sysconf profiles between Gitted repos

A good practice with Sysconf is to use different sysconf profiles, that can easily be shared between different Gitted repositories.

For example, [sysconf.gitted.redmine](https://github.com/geonef/sysconf.gitted.redmine) is the main profile for [gitted.redmine.demo](https://github.com/geonef/gitted.redmine.demo), where it is embedded as a subtree.

Another example is [sysconf.gitted.tt-rss](https://github.com/geonef/sysconf.gitted.tt-rss) which also uses [sysconf.gitted.postgresql](https://github.com/geonef/sysconf.gitted.postgresql).

#### Patch container B from A back and forth

Here is how to take the specific ```sysconf.gitted.redmine``` profile out of ```<container-A>``` and merge it into ```<container-B>```:
```
git fetch <container-A>
git checkout -b tmp <container-A>/master
git subtree split -P sysconf/sysconf.gitted.redmine -b sysconf-redmine
git fetch <container-B>
git checkout -b tmp2 <container-B>/master
git subtree merge -P sysconf/sysconf.gitted.redmine sysconf-redmine
git push <container-B> tmp2:master
```

If ```<container-B>``` had changed as well, to integrate the merge back to ```<container-A>```:
```
git branch -d sysconf-redmine
git subtree split -P sysconf/sysconf.gitted.redmine -b sysconf-redmine
git checkout tmp
git subtree merge -P sysconf/sysconf.gitted.redmine sysconf-redmine
git push <container-A> tmp:master
```

#### Sync with GitHub

Here in 4 commands, we :
* pull updates from the container itself
* pull remote updates from Github and merge them
* update the container with the new commits from GitHub
* push the merge back to GitHub

```
git pull <container> master
git subtree pull -P sysconf/sysconf.gitted.redmine git@github.com:geonef/sysconf.gitted.redmine.git
git push <container> master
git subtree push -P sysconf/sysconf.gitted.redmine git@github.com:geonef/sysconf.gitted.redmine.git
```
