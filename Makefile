DEBUG=0
include $(THEOS)/makefiles/common.mk

ARCHS = armv7 arm64

PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

TWEAK_NAME = FBNotifyClear
FBNotifyClear_FILES = FBNotifyClear.xm MBProgressHUD.m UIAlertView+NSCookbook.m
FBNotifyClear_FRAMEWORKS = UIKit Foundation QuartzCore CoreGraphics
FBNotifyClear_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Facebook"
SUBPROJECTS += fbnotifyclearsetting
include $(THEOS_MAKE_PATH)/aggregate.mk
