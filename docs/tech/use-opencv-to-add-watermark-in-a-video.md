# 安装开发环境

首先，需要`OpenCV`开发环境，就是安装`OpenCV`相关的库。

直接到`GitHub`上拉下[OpenCV源代码](https://github.com/opencv/opencv)，然后进入[项目文档](http://docs.opencv.org/master/)中寻找从源代码编译的方法。我的平台是`MacOS`，所以找到的是Linux/Mac平台下的安装方法: <http://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html>

但是参考了另一篇文章，下载了源代码并进入目录(`opencv-master/`)下，使以下命令编译:

```
sudo cmake -G "Unix Makefiles" //检查相关配置选项
sudo make -j8  //八线程编译
sudo make install  //安装编译好的库文件和头文件到系统目录下
```

# 测试开发环境是否安装成功

因为我的功能也不是很复杂，所以打算只用`g++`编译运行，就不动用各种大型IDE了。下在是我的测试用例：

{% highlight cpp linenos %}
#include <iostream>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

int main(int argc, char **argv)
{
        Mat img = imread(argv[1]);
        imshow("test",img);
        waitKey(0);
        return 0;
}
{% endhighlight %}

编译使用：

```
sudo g++ opencv_test.cpp -lopencv_core -lopencv_highgui -lopencv_imgcodecs -I/usr/local/include -L/usr/local/lib
```
使用下面命令显示一幅图片:

```
./a.out test.jpg # test.jpg is your own picture file
```
如果能够显示出图片，说明开发环境已经安装成功;-)

# 读视频

废话不多话，直接上代码：

{% highlight cpp linenos %}

#include <iostream>
#include <sstream>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

VideoWriter output;

Mat addWatermarkInFrame(Mat frame, int frameNum)
{
	cout << "processing " <<frameNum << " frame" <<endl; 

	Mat redSquare = Mat(Size(20,20),CV_8UC3,Scalar(0,0,255));

	Mat imageROI = frame(Rect(10,10,redSquare.cols, redSquare.rows));

	addWeighted(imageROI, 1.0, redSquare, 1.0,0,imageROI);	

	return frame;
}

void Stop(int signal)
{	
	output.~VideoWriter();
	cout << "process been interrupted!" << endl;
	exit(0);
}

void help()
{
	cout
	<< "-----------------------------------------------------" << endl
	<< "This program shows how to read a video file with OpenCV." << endl
	<< "In addition, it show the process of add watermark in a video" << endl
	<< "Usage:" << endl
	<< "./a.out <input_video_file or video_stream_url>" << endl;
}

int main(int argc, char **argv)
{
	if(argc < 2)
	{
		help();
	}
	else if(argc > 2)
	{
		cout << "Too many parameters" << endl;
	}

	const string cameraOrFile= argv[1];

	stringstream ss;
	ss << cameraOrFile;

	int deviceID;
	ss >> deviceID;

	VideoCapture video;
	if(ss.good())
	{
		video.open(deviceID);
	}
	else
	{
		video.open(cameraOrFile);
	}

	if(!video.isOpened())
	{
		cout<< "Could not open the video file!" << endl;
		return -1;
	}

	Size videoSize = Size((int)video.get(CAP_PROP_FRAME_WIDTH),
						(int)video.get(CAP_PROP_FRAME_HEIGHT));
	int frameRate = video.get(CAP_PROP_FPS);

	cout << "The size of video frame is: "<< videoSize << endl;
	cout << "The frame rate is: " << frameRate << endl;	
		
	int frameNum = -1;
	Mat frame;
	namedWindow("frame",WINDOW_AUTOSIZE);

	remove("output.mp4");
	output.open("output.mp4", -1, frameRate,videoSize,true);
	if(!output.isOpened())
	{
		cout << "Could not open the output video for write!" << endl;
		return -1;
	}
	
	signal(SIGINT,Stop);

	while(1)
	{
		video >> frame;
		if(frame.empty())
		{
			cout << "The video had been processed!" << endl;
			break;
		}

		Mat ret = addWatermarkInFrame(frame, ++frameNum);

		imshow("frame",ret);
		waitKey(1.0/frameRate * 1000);
		
		output << ret;
	}

	cout << "Finished writing video" << endl;

	return 0;
}

{% endhighlight %}

编译命令如下：

```
sudo g++ opencv_test.cpp -lopencv_core -lopencv_highgui -lopencv_imgcodecs -I/usr/local/include -L/usr/local/lib -lopencv_videoio
```

编译出的可执行文件是`a.out`, 使用方法可以是：

```
./a.out test.mp4 # process the video file

```

或者

```
./a.out "http://zhulongyixian.vicp.cc:30236/?action=stream" # <video_stream_url> process the video stream
```

不过如果原来的视频有声音的话，由于OpenCV处理后只有视频数据被写入了文件，这样造成处理结果文件中丢失了音频通道的数据。下一步需要考虑使用FFmpeg来改写视频编解码部分了。

# 加水印

加水印部分可以在上面程序的第`10`行开始的函数里面进行，为了简化处理，只给视频左上角加了一个红色小方块。

# 后记

最近学习linux相关知识，发现命令行越来越好用了，当然只是针对简单点的开发任务。


