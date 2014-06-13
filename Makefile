Ball: installed all
include $(shell rospack find mk)/cmake.mk

include Makefile.choreonoid
#include Makefile.graspplugin

installed: installed.choreonoid # installed.graspplugin

clean: clean.choreonoid

wipe: clean
	rm -fr build bin include lib share
