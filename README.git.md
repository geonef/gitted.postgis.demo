## Git sub-trees avec GitHub

### PULL

```
git subtree pull -P sysconf/sysconf.base git@github.com:geonef/sysconf.base.git master
git subtree pull -P sysconf/sysconf.gitted git@github.com:geonef/sysconf.gitted.git master
git subtree pull -P sysconf/sysconf.gitted.postgresql git@github.com:geonef/sysconf.gitted.postgresql.git master
git subtree pull -P sysconf/sysconf.gitted.postgis git@github.com:geonef/sysconf.gitted.postgis.git master
```


### PUSH

```
git subtree push -P sysconf/sysconf.base git@github.com:geonef/sysconf.base.git master
git subtree push -P sysconf/sysconf.gitted git@github.com:geonef/sysconf.gitted.git master
git subtree push -P sysconf/sysconf.gitted.postgresql git@github.com:geonef/sysconf.gitted.postgresql.git master
git subtree push -P sysconf/sysconf.gitted.postgis git@github.com:geonef/sysconf.gitted.postgis.git master
```
