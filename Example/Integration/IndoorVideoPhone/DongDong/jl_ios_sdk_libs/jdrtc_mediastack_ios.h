#ifndef JDRTC_MEDIASTACK_ANDROID_H_
#define JDRTC_MEDIASTACK_ANDROID_H_

#include <string>
//#import <string>

#include <stdint.h>


#define VIDEO_API __attribute__(( visibility( "default" )))

typedef struct JDRTCMediaEventInfo {
	int event;
	void *user_data;
}JDRTCMediaEventInfo; 


class JDRTCVideoMediaStackCallback {
public:
	JDRTCVideoMediaStackCallback(){};
	virtual ~JDRTCVideoMediaStackCallback(){};
	virtual void OnVideoEvent(JDRTCMediaEventInfo info) = 0;
	virtual void OnAudioEvent(JDRTCMediaEventInfo info) = 0;

};


typedef struct VideoMediaInfo {
	std::string local_bind_ip;
	uint16_t local_port;
	std::string remote_ip;
	uint16_t remote_port;
	bool is_mute_local_audio;
}VideoMediaInfo;




class  JDRTCVideoMediaStack {
public:
	JDRTCVideoMediaStack(){};
	virtual ~JDRTCVideoMediaStack(){};

	static JDRTCVideoMediaStack * Create(JDRTCVideoMediaStackCallback *callback, void *user_data);
	static void Destroy(JDRTCVideoMediaStack *ptr);
	static void SetAndroidContext(void* context);

	virtual bool StartVideoView(const VideoMediaInfo& info, void* view_handle) = 0;
	virtual void StopVideoView() = 0;

	virtual bool MuteLocalAudio(bool is_mute) = 0;


};






#endif
