AQSWhatsAppActivity
===============

![](http://img.shields.io/cocoapods/v/AQSLINEActivity.svg?style=flat) [![Build Status](https://travis-ci.org/AquaSupport/AQSLINEActivity.svg)](https://travis-ci.org/AquaSupport/AQSLINEActivity)

[iOS] UIActivity for WhatsApp

Usage
---

```objc
UIActivity *whatsAppActivity = [[AQSWhatsAppActivity alloc] init];
NSArray *items = @[[UIImage imageNamed:@"someimage.png"]];

UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items withApplicationActivities:@[whatsAppActivity]];

[self presentViewController:activityViewControoler animated:YES completion:NULL];
```

Installation
---

```
pod "AQSWhatsAppActivity"
```

Related Projects
---

- [AQSShareService](https://github.com/AquaSupport/AQSShareService) - UX-improved share feature in few line
