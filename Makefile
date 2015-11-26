include $(THEOS)/makefiles/common.mk

ARCHS = armv7 arm64

TWEAK_NAME = FBNotifyClear
FBNotifyClear_FILES = FBNotifyClear.xm MBProgressHUD.m
FBNotifyClear_FRAMEWORKS = UIKit Foundation QuartzCore CoreGraphics
FBNotifyClear_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Facebook"
SUBPROJECTS += fbnotifyclearsetting
include $(THEOS_MAKE_PATH)/aggregate.mk
