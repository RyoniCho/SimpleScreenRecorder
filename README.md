## Simple Screen Recorder

quicktime player를 사용하지않고 심플하게 화면녹화를 하기위한 간단앱.


### Requirement 
오디오 녹음을 위해 BlackHole설치가 필요하다. 화면녹화시 오디오는 blackhole로 전환시킨후 사용한다.
["Black Hole 링크"](https://existential.audio/blackhole/)


### Usage
Start Session버튼을 누르면 화면캡쳐관련 권한을 얻을수있다.(권한 열고난후 앱 재시작 필요) 
Start Session후에 START를 누르면 녹화가 시작된다.
녹화되는 파일은 /User/Download폴더에 저장된다. 
STOP을 누르며 녹화가 정지된다. 

### After Recording
녹화된 파일은 오디오코덱이 맥에서 재생할경우 비정상적으로 작동할수있다.
이 경우에는 오디오채널만 분리해서 다시 영상과 붙이는 작업이 필요할수있다.
파이썬 스크립트로 해당작업을 자동화하였다. 

- 많은수의 파일을 작업할경우 (폴더)
> python FixAudioChannel.py -d (영상이 있는 폴더경로)

- 파일하나만 작업할경우
> python FixAudioChannel.py -f (파일경로)
