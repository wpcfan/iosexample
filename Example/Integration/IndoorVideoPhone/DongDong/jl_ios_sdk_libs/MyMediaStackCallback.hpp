//
//  MyMediaStackCallback.hpp
//  JL_IOS_DEMO
//
//  Created by andy on 2018/1/15.
//  Copyright © 2018年 andy. All rights reserved.
//

#ifndef MyMediaStackCallback_hpp
#define MyMediaStackCallback_hpp

#include <stdio.h>
#include "jdrtc_mediastack_ios.h"


class MyMediaStackCallback : public JDRTCVideoMediaStackCallback {
public:
    
    virtual void OnVideoEvent(JDRTCMediaEventInfo info) override;
    virtual void OnAudioEvent(JDRTCMediaEventInfo info) override;
    
};

#endif /* MyMediaStackCallback_hpp */
