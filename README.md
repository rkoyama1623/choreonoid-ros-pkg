choreonoid
==========

# HOW TO BUILD?
```
catkin build --this
```
## where files are created

choreonoid source code: `catkin_ws/build/choreonoid/build/choreonoid-XXX`
choreonoid binary code: `catkin_ws/devel/bin/choreonoid`

## change choreonoid codes
1. not change the remote/branch in choreonoid
```
rm catkin_ws/build/choreonoid/installed.choreonoid
catkin build choreonoid
```
1. change the remote/branch in choreonoid
set remote/branch in `makefile.choreonoid`.
```diff:makefile.choreonoid
 TARBALL_URL = http://choreonoid.org/_downloads/$(FILENAME)
 # SOURCE_DIR  = build/choreonoid-$(CNOID_VER)
 GIT_DIR = build/choreonoid-$(CNOID_VER)
-GIT_URL = https://github.com/s-nakaoka/choreonoid.git
-GIT_REVISION = master
+GIT_URL = https://github.com/YOUR_GIT_ID/choreonoid.git
+GIT_REVISION = YOUR_BRANCH
 # GIT_REVISION = add-to-headers
 #TARBALL_PATCH = add_dummy_option.patch
 # for simulator in choreonoid
```
same process above
```
rm catkin_ws/build/choreonoid/installed.choreonoid
catkin build choreonoid
```

