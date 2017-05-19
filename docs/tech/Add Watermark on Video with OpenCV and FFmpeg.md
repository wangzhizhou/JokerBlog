# Add Watermark on Video with OpenCV and FFmpeg

之前写过一篇`use opencv to add watermark in a video`，但是发现有个问题：

- 处理后的视频无法保留原来视频中的音频信息

所以决定再探究一下。

经过调查发现`FFmpeg`应用相当广泛，几乎是音视频领域的瑞士军刀，所以我也试一下水，经过三个星期的摸索，终于初步解决了上面提到的那个问题。觉得相当的欣慰，对自己感到非常满意 ;-)


程序的主要功能是，读入一个视频(其中包含音频)，给视频图像左上角添加一个黄色方块后，输出成相同格式的视频文件，并保留原文件中的音频信息。
	
代码文件: [ffmpeg-opencv-transcode.cpp](/assets/ffmpeg-code/experiment-code/ffmpeg-opencv-transcode.cpp)

# 源代码

```cpp
/**
 * Copyright (c) 2010 Nicolas George
 * Copyright (c) 2011 Stefano Sabatini
 * Copyright (c) 2014 Andrey Utkin
 
 * Copyright (c) 2016 Wang Zhizhou  email: 824219521@qq.com
 *      modified from ffmpeg offical example named: transcoding.c
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

extern "C"
{
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavfilter/avfiltergraph.h>
#include <libavfilter/buffersink.h>
#include <libavfilter/buffersrc.h>
#include <libavutil/opt.h>
#include <libavutil/pixdesc.h>
#include <libswscale/swscale.h>
}

static AVFormatContext *ifmt_ctx;
static AVFormatContext *ofmt_ctx;

static int open_input_file(const char *filename){
    int ret;
    unsigned int i;
    ifmt_ctx = NULL;
    if ((ret = avformat_open_input(&ifmt_ctx, filename, NULL, NULL)) < 0) {
        av_log(NULL, AV_LOG_ERROR, "Cannot open input file\n");
        return ret;
    }
    if ((ret = avformat_find_stream_info(ifmt_ctx, NULL)) < 0) {
        av_log(NULL, AV_LOG_ERROR, "Cannot find stream information\n");
        return ret;
    }
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        AVStream *stream;
        AVCodecContext *codec_ctx;
        stream = ifmt_ctx->streams[i];
        codec_ctx = stream->codec;
        /* Reencode video & audio and remux subtitles etc. */
        if (codec_ctx->codec_type == AVMEDIA_TYPE_VIDEO) {
            /* Open decoder */
            ret = avcodec_open2(codec_ctx,
                                avcodec_find_decoder(codec_ctx->codec_id), NULL);
            if (ret < 0) {
                av_log(NULL, AV_LOG_ERROR, "Failed to open decoder for stream #%u\n", i);
                return ret;
            }
        }
    }
    av_dump_format(ifmt_ctx, 0, filename, 0);
    return 0;
}
static int open_output_file(const char *filename){
    AVStream *out_stream;
    AVStream *in_stream;
    AVCodecContext *dec_ctx, *enc_ctx;
    AVCodec *encoder;
    int ret;
    unsigned int i;
    ofmt_ctx = NULL;
    avformat_alloc_output_context2(&ofmt_ctx, NULL, NULL, filename);
    if (!ofmt_ctx) {
        av_log(NULL, AV_LOG_ERROR, "Could not create output context\n");
        return AVERROR_UNKNOWN;
    }
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        out_stream = avformat_new_stream(ofmt_ctx, NULL);
        if (!out_stream) {
            av_log(NULL, AV_LOG_ERROR, "Failed allocating output stream\n");
            return AVERROR_UNKNOWN;
        }
        in_stream = ifmt_ctx->streams[i];
        dec_ctx = in_stream->codec;
        enc_ctx = out_stream->codec;
        if (dec_ctx->codec_type == AVMEDIA_TYPE_VIDEO) {
            /* in this example, we choose transcoding to same codec */
            encoder = avcodec_find_encoder(dec_ctx->codec_id);
            if (!encoder) {
                av_log(NULL, AV_LOG_FATAL, "Necessary encoder not found\n");
                return AVERROR_INVALIDDATA;
            }
            /* In this example, we transcode to same properties (picture size,
             * sample rate etc.). These properties can be changed for output
             * streams easily using filters */
            
            if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER)
                enc_ctx->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
            

            enc_ctx->height = dec_ctx->height;
            enc_ctx->width = dec_ctx->width;
            enc_ctx->sample_aspect_ratio = dec_ctx->sample_aspect_ratio;
            /* take first format from list of supported formats */
            if (encoder->pix_fmts)
                enc_ctx->pix_fmt = encoder->pix_fmts[0];
            else
                enc_ctx->pix_fmt = dec_ctx->pix_fmt;
            /* video time_base can be set to whatever is handy and supported by encoder */
            enc_ctx->time_base = dec_ctx->time_base;
            out_stream->time_base = enc_ctx->time_base;
            
            if(dec_ctx->codec_id == AV_CODEC_ID_H264)
            {
                enc_ctx->me_range = 16;
                enc_ctx->max_qdiff = 4;
                enc_ctx->qmin = 11;
                enc_ctx->qmax =30;
                enc_ctx->qcompress = 0.7;
            }

            /* Third parameter can be used to pass settings to encoder */
            ret = avcodec_open2(enc_ctx, encoder, NULL);
            if (ret < 0) {
                av_log(NULL, AV_LOG_ERROR, "Cannot open video encoder for stream #%u\n", i);
                return ret;
            }
        } else if (dec_ctx->codec_type == AVMEDIA_TYPE_UNKNOWN) {
            av_log(NULL, AV_LOG_FATAL, "Elementary stream #%d is of unknown type, cannot proceed\n", i);
            return AVERROR_INVALIDDATA;
        } else {
            /* if this stream must be remuxed */
            ret = avcodec_copy_context(ofmt_ctx->streams[i]->codec,
                                       ifmt_ctx->streams[i]->codec);
            
            if(AVMEDIA_TYPE_AUDIO == ofmt_ctx->streams[i]->codec->codec_type)
            {
                ofmt_ctx->streams[i]->codec->codec_tag = 0;
            }
            
            if (ret < 0) {
                av_log(NULL, AV_LOG_ERROR, "Copying stream context failed\n");
                return ret;
            }
        }
    }
    av_dump_format(ofmt_ctx, 0, filename, 1);
    if (!(ofmt_ctx->oformat->flags & AVFMT_NOFILE)) {
        ret = avio_open(&ofmt_ctx->pb, filename, AVIO_FLAG_WRITE);
        if (ret < 0) {
            av_log(NULL, AV_LOG_ERROR, "Could not open output file '%s'", filename);
            return ret;
        }
    }
    /* init muxer, write output file header */
    ret = avformat_write_header(ofmt_ctx, NULL);
    if (ret < 0) {
        av_log(NULL, AV_LOG_ERROR, "Error occurred when opening output file\n");
        return ret;
    }
    return 0;
}
static int encode_write_frame(AVFrame *filt_frame, unsigned int stream_index, int *got_frame) {
    int ret;
    int got_frame_local;
    AVPacket enc_pkt;
    if (!got_frame)
        got_frame = &got_frame_local;
    av_log(NULL, AV_LOG_INFO, "Encoding frame\n");
    /* encode filtered frame */
    enc_pkt.data = NULL;
    enc_pkt.size = 0;
    av_init_packet(&enc_pkt);
    ret = avcodec_encode_video2(ofmt_ctx->streams[stream_index]->codec, &enc_pkt,
                   filt_frame, got_frame);
    av_frame_free(&filt_frame);
    if (ret < 0)
        return ret;
    if (!(*got_frame))
        return 0;
    /* prepare packet for muxing */
    enc_pkt.stream_index = stream_index;
    av_packet_rescale_ts(&enc_pkt,
                         ofmt_ctx->streams[stream_index]->codec->time_base,
                         ofmt_ctx->streams[stream_index]->time_base);
    av_log(NULL, AV_LOG_DEBUG, "Muxing frame\n");
    /* mux encoded frame */
    ret = av_interleaved_write_frame(ofmt_ctx, &enc_pkt);
    return ret;
}
static int flush_encoder(unsigned int stream_index){
    int ret;
    int got_frame;
    if (!(ofmt_ctx->streams[stream_index]->codec->codec->capabilities &
          AV_CODEC_CAP_DELAY))
        return 0;
    while (1) {
        av_log(NULL, AV_LOG_INFO, "Flushing stream #%u encoder\n", stream_index);
        ret = encode_write_frame(NULL, stream_index, &got_frame);
        if (ret < 0)
            break;
        if (!got_frame)
            return 0;
    }
    return ret;
}

//#define USE_OPENCV //注释这一句后运行，对应不加水印的输出视频

#ifdef USE_OPENCV
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;



/** 这个函数里使用OpenCV处理图像 **/
void addWaterMarkOnTheImage(Mat &imageFrame)
{
    Mat waterMark = Mat(100,100,CV_8UC3,Scalar(0,255,255)); //模拟水印图像
    
    Mat imageROI = imageFrame(Rect(10,10,waterMark.cols,waterMark.rows));
    
    cv::addWeighted(imageROI, 0, waterMark, 1, 0, imageROI); //添加水印到视频图像帧上
}
/** ------ **/




AVFrame* useOpenCVProcessFrame(AVFrame *frame, int stream_index)
{
    AVStream *in_stream = ifmt_ctx->streams[stream_index];
    AVCodecContext *pCodecCtx = in_stream->codec;
    
    AVFrame  *pFrameRGB = NULL;
    
    /* 源图像格式向BGR24转换 */
    struct SwsContext * img_convert_ctx = NULL;
    if(img_convert_ctx == NULL){
        img_convert_ctx = sws_getContext(pCodecCtx->width, pCodecCtx->height,
                                         pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height,
                                         AV_PIX_FMT_BGR24, SWS_BICUBIC, NULL, NULL, NULL);
    }
    pFrameRGB = av_frame_alloc();
    int size = avpicture_get_size(AV_PIX_FMT_BGR24, pCodecCtx->width, pCodecCtx->height);
    uint8_t  *out_bufferRGB = new uint8_t[size];
    
    avpicture_fill((AVPicture *)pFrameRGB, out_bufferRGB, AV_PIX_FMT_BGR24, pCodecCtx->width, pCodecCtx->height);
    
    sws_scale(img_convert_ctx, frame->data, frame->linesize, 0, pCodecCtx->height, pFrameRGB->data, pFrameRGB->linesize);
    
    Mat imageFrame = Mat(pCodecCtx->height, pCodecCtx->width, CV_8UC3);
    
    memcpy(imageFrame.data, out_bufferRGB, size);
    delete[] out_bufferRGB;
    /*** 源图像格式向BGR24转换结束 ***/

    
    addWaterMarkOnTheImage(imageFrame);//使用OpenCV向图像添加水印
    
    
    imshow("image",imageFrame);
    waitKey(1);
    

    //OpenCV Mat图像数据转为FFmpeg AVFrame图像帧数据
    avpicture_fill((AVPicture *)pFrameRGB, imageFrame.data,AV_PIX_FMT_BGR24, pCodecCtx->width, pCodecCtx->height);

    /* BGR24向源图像格式转换 */
    struct SwsContext * convert_ctx = NULL;
    if(convert_ctx == NULL){
        convert_ctx = sws_getContext(pCodecCtx->width, pCodecCtx->height,
                                         AV_PIX_FMT_BGR24, pCodecCtx->width, pCodecCtx->height,
                                         pCodecCtx->pix_fmt, SWS_BICUBIC, NULL, NULL, NULL);
    }

    AVFrame *srcFrame = av_frame_alloc();
    size = avpicture_get_size(pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height);
    uint8_t  *out_buffer = new uint8_t[size];
    
    avpicture_fill((AVPicture *)srcFrame, out_buffer, pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height);
    
    sws_scale(convert_ctx, pFrameRGB->data, pFrameRGB->linesize, 0, pCodecCtx->height, srcFrame->data, srcFrame->linesize);
    
    delete[] out_buffer;
    /*** BGR24向源图像格式转换结束 ***/
    av_free(pFrameRGB);
    
    srcFrame->width = frame->width;
    srcFrame->height = frame->height;
    srcFrame->format = frame->format;
    
    av_frame_copy_props(srcFrame, frame);
    
    return srcFrame;
}

#endif


int main(int argc, char **argv){
    int ret;
    AVPacket packet = { .data = NULL, .size = 0 };
    AVFrame *frame = NULL;
    enum AVMediaType type;
    unsigned int stream_index;
    unsigned int i;
    int got_frame;
    if (argc != 3) {
        av_log(NULL, AV_LOG_ERROR, "Usage: %s <input file> <output file>\n", argv[0]);
        return 1;
    }
    av_register_all();
    avfilter_register_all();
    if ((ret = open_input_file(argv[1])) < 0)
        goto end;
    if ((ret = open_output_file(argv[2])) < 0)
        goto end;
    /* read all packets */
    while (1) {
        if ((ret = av_read_frame(ifmt_ctx, &packet)) < 0)
            break;
        stream_index = packet.stream_index;
        type = ifmt_ctx->streams[packet.stream_index]->codec->codec_type;
        av_log(NULL, AV_LOG_DEBUG, "Demuxer gave frame of stream_index %u\n",
               stream_index);
        if (type == AVMEDIA_TYPE_VIDEO) {
            av_log(NULL, AV_LOG_DEBUG, "Going to reencode&filter the frame\n");
            frame = av_frame_alloc();
            if (!frame) {
                ret = AVERROR(ENOMEM);
                break;
            }
            av_packet_rescale_ts(&packet,
                                 ifmt_ctx->streams[stream_index]->time_base,
                                 ifmt_ctx->streams[stream_index]->codec->time_base);
            
            ret = avcodec_decode_video2(ifmt_ctx->streams[stream_index]->codec, frame,
                           &got_frame, &packet);
            if (ret < 0) {
                av_frame_free(&frame);
                av_log(NULL, AV_LOG_ERROR, "Decoding failed\n");
                break;
            }
            if (got_frame) {
                
#ifdef USE_OPENCV
                AVFrame *convertFrame = useOpenCVProcessFrame(frame,stream_index);
                convertFrame->pts = av_frame_get_best_effort_timestamp(frame);
                convertFrame->pict_type =  AV_PICTURE_TYPE_NONE;
                ret = encode_write_frame(convertFrame, stream_index, NULL);
#else
                frame->pts = av_frame_get_best_effort_timestamp(frame);
                frame->pict_type =  AV_PICTURE_TYPE_NONE;
                ret = encode_write_frame(frame, stream_index, NULL);
#endif

                if (ret < 0)
                    goto end;
            } else {
                av_frame_free(&frame);
            }
        } else {
            /* remux this frame without reencoding */
            av_packet_rescale_ts(&packet,
                                 ifmt_ctx->streams[stream_index]->time_base,
                                 ofmt_ctx->streams[stream_index]->time_base);
            ret = av_interleaved_write_frame(ofmt_ctx, &packet);
            if (ret < 0)
                goto end;
        }
        av_packet_unref(&packet);
    }
    /* flush filters and encoders */
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        /* flush encoder */
        if(ifmt_ctx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO)
        {
            ret = flush_encoder(i);
            if (ret < 0) {
                av_log(NULL, AV_LOG_ERROR, "Flushing encoder failed\n");
                goto end;
            }
        }
    }
    av_write_trailer(ofmt_ctx);
end:
    av_packet_unref(&packet);
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        avcodec_close(ifmt_ctx->streams[i]->codec);
        if (ofmt_ctx && ofmt_ctx->nb_streams > i && ofmt_ctx->streams[i] && ofmt_ctx->streams[i]->codec)
            avcodec_close(ofmt_ctx->streams[i]->codec);
    }
    avformat_close_input(&ifmt_ctx);
    if (ofmt_ctx && !(ofmt_ctx->oformat->flags & AVFMT_NOFILE))
        avio_closep(&ofmt_ctx->pb);
    avformat_free_context(ofmt_ctx);
    if (ret < 0)
        av_log(NULL, AV_LOG_ERROR, "Error occurred: %s\n", av_err2str(ret));
    return ret ? 1 : 0;
}
```

**本程序运行调用了`ffmpeg-2.8.6`和`opencv-3.0.1`版的库(库的安装读者还是自己搞定吧，有事联系: 824219521@qq.com)**

# 编译
 
使用g++编译，编译命令如下：

```
g++ ffmpeg-opencv-transcode.cpp -I/usr/local/include -L/usr/local/lib -lavcodec -lavformat -lswscale -lavfilter -lavutil -lx264 -lz -lm -lopencv_imgproc -lopencv_highgui -lopencv_core
```

# 使用

使用方法：

```
./a.out input.mp4 output.mp4
```

# 测试视频

这里有几个测试视频可供使用：

- [1.mp4](/assets/ffmpeg-code/test-files/1.mp4)

- [2.mp4](/assets/ffmpeg-code/test-files/2.mp4)


