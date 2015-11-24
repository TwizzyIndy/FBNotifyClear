include $(THEOS)/makefiles/common.mk
SDK_VERSION = 7.1

BUNDLE_NAME = FBNotifyClearSetting
FBNotifyClearSetting_FILES = FBNRootListController.m PFHeaderCell.mm
FBNotifyClearSetting_INSTALL_PATH = /Library/PreferenceBundles
FBNotifyClearSetting_FRAMEWORKS = UIKit
FBNotifyClearSetting_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FBNotifyClearSetting.plist$(ECHO_END)
