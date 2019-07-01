ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CleanPlayer
CleanPlayer_FILES = Tweak.xm
CleanPlayer_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += cleanplayerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
