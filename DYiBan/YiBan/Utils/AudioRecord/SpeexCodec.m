//
//  SpeexCodec.m
//  TEST_Speex_001
//
//  Created by cai xuejun on 12-9-4.
//  Copyright (c) 2012年 caixuejun. All rights reserved.
//

#import "SpeexCodec.h"

typedef unsigned long long u64;
typedef long long s64;
typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;

u16 readUInt16(char* bis) {
    u16 result = 0;
    result += ((u16)(bis[0])) << 8;
    result += (u8)(bis[1]);
    return result;
}

u32 readUint32(char* bis) {
    u32 result = 0;
    result += ((u32) readUInt16(bis)) << 16;
    bis+=2;
    result += readUInt16(bis);
    return result;
}

s64 readSint64(char* bis) {
    s64 result = 0;
    result += ((u64) readUint32(bis)) << 32;
    bis+=4;
    result += readUint32(bis);
    return result;
}

@implementation SpeexCodec

void WriteWAVEHeader(NSMutableData* fpwave, int nFrame)
{
	char tag[10] = "";
	
	// 1. 写RIFF头
	RIFFHEADER riff;
	strcpy(tag, "RIFF");
	memcpy(riff.chRiffID, tag, 4);
	riff.nRiffSize = 4                                     // WAVE
	+ sizeof(XCHUNKHEADER)               // fmt
	+ sizeof(WAVEFORMATX)           // WAVEFORMATX
	+ sizeof(XCHUNKHEADER)               // DATA
	+ nFrame*160*sizeof(short);    //
	strcpy(tag, "WAVE");
	memcpy(riff.chRiffFormat, tag, 4);
	//fwrite(&riff, 1, sizeof(RIFFHEADER), fpwave);
    [fpwave appendBytes:&riff length:sizeof(RIFFHEADER)];
	
	// 2. 写FMT块
	XCHUNKHEADER chunk;
	WAVEFORMATX wfx;
	strcpy(tag, "fmt ");
	memcpy(chunk.chChunkID, tag, 4);
	chunk.nChunkSize = sizeof(WAVEFORMATX);
	//fwrite(&chunk, 1, sizeof(XCHUNKHEADER), fpwave);
    [fpwave appendBytes:&chunk length:sizeof(XCHUNKHEADER)];
	memset(&wfx, 0, sizeof(WAVEFORMATX));
	wfx.nFormatTag = 1;
	wfx.nChannels = 1; // 单声道
	wfx.nSamplesPerSec = 8000; // 8khz
	wfx.nAvgBytesPerSec = 16000;
	wfx.nBlockAlign = 2;
	wfx.nBitsPerSample = 16; // 16位
    //fwrite(&wfx, 1, sizeof(WAVEFORMATX), fpwave);
    [fpwave appendBytes:&wfx length:sizeof(WAVEFORMATX)];
	
	// 3. 写data块头
	strcpy(tag, "data");
	memcpy(chunk.chChunkID, tag, 4);
	chunk.nChunkSize = nFrame*160*sizeof(short);
	//fwrite(&chunk, 1, sizeof(XCHUNKHEADER), fpwave);
    [fpwave appendBytes:&chunk length:sizeof(XCHUNKHEADER)];
    
}

#pragma mark Encode
// 从WAVE文件读一个完整的PCM音频帧
// 返回值: 0-错误 >0: 完整帧大小
int ReadPCMFrameData(short speech[], char* fpwave, int nChannels, int nBitsPerSample)
{
	int nRead = 0;
	int x = 0, y=0;
	unsigned short ush1=0, ush2=0, ush=0;
	
	// 原始PCM音频帧数据
	unsigned char  pcmFrame_8b1[FRAME_SIZE];
	unsigned char  pcmFrame_8b2[FRAME_SIZE<<1];
	unsigned short pcmFrame_16b1[FRAME_SIZE];
	unsigned short pcmFrame_16b2[FRAME_SIZE<<1];
	
    nRead = (nBitsPerSample/8) * FRAME_SIZE*nChannels;
	if (nBitsPerSample==8 && nChannels==1)
    {
		//nRead = fread(pcmFrame_8b1, (nBitsPerSample/8), FRAME_SIZE*nChannels, fpwave);
        memcpy(pcmFrame_8b1,fpwave,nRead);
		for(x=0; x<FRAME_SIZE; x++)
        {
			speech[x] =(short)((short)pcmFrame_8b1[x] << 7);
        }
    }
	else
		if (nBitsPerSample==8 && nChannels==2)
        {
			//nRead = fread(pcmFrame_8b2, (nBitsPerSample/8), FRAME_SIZE*nChannels, fpwave);
            memcpy(pcmFrame_8b2,fpwave,nRead);
            
			for( x=0, y=0; y<FRAME_SIZE; y++,x+=2 )
            {
				// 1 - 取两个声道之左声道
				//speech[y] =(short)((short)pcmFrame_8b2[x+0] << 7);
				// 2 - 取两个声道之右声道
				//speech[y] =(short)((short)pcmFrame_8b2[x+1] << 7);
				// 3 - 取两个声道的平均值
				ush1 = (short)pcmFrame_8b2[x+0];
				ush2 = (short)pcmFrame_8b2[x+1];
				ush = (ush1 + ush2) >> 1;
				speech[y] = (short)((short)ush << 7);
            }
        }
		else
			if (nBitsPerSample==16 && nChannels==1)
            {
				//nRead = fread(pcmFrame_16b1, (nBitsPerSample/8), FRAME_SIZE*nChannels, fpwave);
                memcpy(pcmFrame_16b1,fpwave,nRead);
                
				for(x=0; x<FRAME_SIZE; x++)
                {
					speech[x] = (short)pcmFrame_16b1[x+0];
                }
            }
			else
				if (nBitsPerSample==16 && nChannels==2)
                {
					//nRead = fread(pcmFrame_16b2, (nBitsPerSample/8), FRAME_SIZE*nChannels, fpwave);
                    memcpy(pcmFrame_16b2,fpwave,nRead);
                    
					for( x=0, y=0; y<FRAME_SIZE; y++,x+=2 )
                    {
						//speech[y] = (short)pcmFrame_16b2[x+0];
						speech[y] = (short)((int)((int)pcmFrame_16b2[x+0] + (int)pcmFrame_16b2[x+1])) >> 1;
                    }
                }
	
	// 如果读到的数据不是一个完整的PCM帧, 就返回0
	return nRead;
}


struct CAFFileHeader {
    UInt32  mFileType;
    UInt16  mFileVersion;
    UInt16  mFileFlags;
};

struct CAFChunkHeader {
    UInt32  mChunkType;
    SInt64  mChunkSize;
};

//跳过CAF文件头
int SkipCaffHead(char* buf){
    
    if (!buf) {
        return 0;
    }
    char* oldBuf = buf;
    u32 mFileType = readUint32(buf);
    if (0x63616666 != mFileType) {
        return 0;
    }
    buf += 4;
    
    /*u16 mFileVersion = */readUInt16(buf);
    buf += 2;
    /*u16 mFileFlags = */readUInt16(buf);
    buf += 2;
    //    NSLog(@"fileVersion:%d,fileFlags:%d.",mFileVersion, mFileFlags);
    
    //desc free data
    u32 Magics[3] = {0x64657363,0x66726565,0x64617461};
    for (int i=0; i<3; ++i) {
        u32 mChunkType = readUint32(buf);buf+=4;
        if (Magics[i]!=mChunkType) {
            return 0;
        }
        
        u32 mChunkSize = readSint64(buf);buf+=8;
        if (mChunkSize<=0) {
            return 0;
        }
        if (i==2) {
            return buf-oldBuf;
        }
        buf += mChunkSize;
        
    }
    
    return 1;
}


NSData *EncodePCMToRawSpeex(char *PCMdata, int maxLen,int nChannels, int nBitsPerSample)
{
    NSMutableData *speexData = [[[NSMutableData alloc] init] autorelease];
    Byte head1[] = {79,103,103,83,0,2,0,0,0,0,0,0,0,0,177,25,-104,-111,0,0,0,0,0,0,0,0,1,80};
    Byte data1[] = {83,112,101,101,120,32,32,32,115,112,101,101,120,45,49,46,50,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,80,0,0,0,64,31,0,0,0,0,0,0,4,0,0,0,1,0,0,0,-1,-1,-1,-1,-96,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    
    
    Byte head2[] ={79,103,103,83,0,0,0,0,0,0,0,0,0,0,177,25,-104,-111,1,0,0,0,0,0,0,0,1,35};
    Byte data2[] = {27,0,0,0,69,110,99,111,100,101,100,32,119,105,116,104,58,116,101,115,116,32,98,121,32,103,97,117,115,115,32,0,0,0,0};
    
    [speexData appendBytes:head1 length:28];
    [speexData appendBytes:data1 length:80];
    
    [speexData appendBytes:head2 length:28];
    [speexData appendBytes:data2 length:35];
    
    
    
    //-----------------------以上属于文件格式头初始化－－－－－－－－－－－－－－－－－－－－－－－－／／
    char *oldBuf = PCMdata;
    int byte_counter, frames = 0, bytes = 0;
    
    spx_int16_t input[FRAME_SIZE];
    char speexFrame[MAX_NB_BYTES];
    short speech[FRAME_SIZE];
    int tmp = 8;// bps?
    void *encode_state = speex_encoder_init(&speex_nb_mode);
    speex_encoder_ctl(encode_state, SPEEX_SET_QUALITY, &tmp);
//
    SpeexPreprocessState *preprocess_state = speex_preprocess_state_init(FRAME_SIZE, SPEEX_SAMPLE_RATE);
    int denoise = 1;
    int noiseSuppress = -10;
    speex_preprocess_ctl(preprocess_state, SPEEX_PREPROCESS_SET_DENOISE, &denoise);// 降噪
    speex_preprocess_ctl(preprocess_state, SPEEX_PREPROCESS_SET_NOISE_SUPPRESS, &noiseSuppress);// 噪音分贝数
    
    int agc = 1;
    int level = 24000;
    //actually default is 8000(0,32768),here make it louder for voice is not loudy enough by default.
    speex_preprocess_ctl(preprocess_state, SPEEX_PREPROCESS_SET_AGC, &agc);// 增益
    speex_preprocess_ctl(preprocess_state, SPEEX_PREPROCESS_SET_AGC_LEVEL,&level);// 增益后的值
    SpeexBits bits;
    speex_bits_init(&bits);
    uint i = 0;

    BOOL isEnd = NO;
    for (; ; ) {
        if (isEnd) {
            break;
        }
        Byte heaedSize[255];
        NSMutableData *speexRawData = [[[NSMutableData alloc] init] autorelease];
        for (; ; ) {
                if ((PCMdata - oldBuf + sizeof(short)*FRAME_SIZE) > maxLen) {
                    isEnd= YES;
                    break;
                }
            //以251大小为一个桢包，并且添加桢头
            if (i==251) {
                break;
            }
            
            int nRead = ReadPCMFrameData(speech, PCMdata, nChannels, nBitsPerSample);
            
            for (int i = 0; i < FRAME_SIZE; i++) {
                input[i] = speech[i];
            }
            
            PCMdata += nRead;
            
            frames++;
            
            speex_bits_reset(&bits);
            speex_encode_int(encode_state, input, &bits);
            
            byte_counter = speex_bits_write(&bits, speexFrame, MAX_NB_BYTES);
            bytes += byte_counter;
            
            [speexRawData appendBytes:speexFrame length:byte_counter];
            heaedSize[i] = byte_counter;//每桢的头大小，存储
            i++;
        }
//        YBLogInfo(@"i=%i",i);
        Byte head3[] = {79,103,103,83,0,2,0,0,0,0,0,0,0,0,177,25,-104,-111,0,0,0,0,0,0,0,0,i};
        [speexData appendBytes:head3 length:27];
        [speexData appendBytes:heaedSize length:i];
        [speexData appendData:speexRawData];
        i=0;
    }
    
    
    speex_bits_destroy(&bits);
    speex_encoder_destroy(encode_state);
    speex_preprocess_state_destroy(preprocess_state);
    
    return speexData;
}

NSData *EncodeWAVEToSpeex(NSData *data, int nChannels, int nBitsPerSample)
{
    if (data == nil){
//        YBLogInfo(@"data is nil...");
        return nil;
    }
    
    int nPos  = 0;
    char *buf = (char *)[data bytes];
    int maxLen = [data length];
    int  i = SkipCaffHead(buf);
    nPos += i;
    if (nPos >= maxLen) {
        return nil;
    }
    
    //这时取出来的是纯pcm数据
    buf += nPos;
    
    NSData *speexData = EncodePCMToRawSpeex(buf, maxLen-nPos, nChannels, nBitsPerSample);
    return speexData;
}

NSData *DecodeSpeexToWAVE(NSData *data)
{
    if (data == nil){
//        YBLogInfo(@"data is nil...");
        return nil;
    }
    
    //    int nPos  = 0;
    char *buf = (char *)[data bytes];
    int maxLen = [data length];
    
    int OGG_SEGOFFSET= 26;
    int OGG_HEADERSIZE = 27;
    
    BOOL isEnd = NO;
    
    int head[1024];
    
    int backCount= 0;
    
    
    char *oldBuf = (char *)[data bytes];
    int frames = 0;
    
    short pcmFrame[FRAME_SIZE];
    short output[FRAME_SIZE];
    
    int tmp = 1;
    void *dec_state = speex_decoder_init(&speex_nb_mode);
    speex_decoder_ctl(dec_state, SPEEX_SET_ENH,&tmp);
    
    NSMutableData *PCMRawData = [[[NSMutableData alloc] init] autorelease];
    
    SpeexBits bits;
    speex_bits_init(&bits);
    
    for (; ;) {
        if (isEnd) {
            break;
        }
        //        if (backCount==0) {
        for (int i = 0; i<OGG_HEADERSIZE; i++) {
            //                NSLog(@"===>%i",i);
            head[i] = buf[i];
            
        }
        //        }
        //        else{
        //            for (int i = 0; i<OGG_HEADERSIZE; i++) {
        //                head[i]= buf[i];
        //            }
        //        }
        
        buf+=OGG_SEGOFFSET;
        
        int segments = (head[OGG_SEGOFFSET]&0xff);
        //        head[OGG_HEADERSIZE]= buf[segments];
        for (int i = 0; i<segments; i++) {
            //            NSLog(@"==>%hhd,%hhd",buf[i],buf[i+1]);
            head[OGG_HEADERSIZE+i]= buf[i+1];
        }
//        for (int i = 0; i<segments+50; i++) {
//            NSLog(@"%hhd",buf[i]);
//        }
        buf+=segments+1;
//        for (int i = 0; i<20; i++) {
//            NSLog(@"%hhd",buf[i]);
//        } 
        buf+= head[OGG_HEADERSIZE];
//        for (int i = 0; i<20; i++) {
//            NSLog(@"%hhd",buf[i]);
//        }
        //        NSLog(@"-->%d",head[OGG_HEADERSIZE]);
        //        if (backCount<=1) {
        //             buf+=2;
        //        }
        buf[22]= 0;
        buf[23]= 0;
        buf[24]= 0;
        buf[25] =0;
        if (backCount>=2) {  
            for (int curseg = 0;curseg<segments ; curseg++) {
                if ((buf - oldBuf + FRAME_SIZE) > maxLen) {
                    isEnd = YES;
                    break;
                }
                //        NSLog(@"count = %i",count);
                int bodybytes = head[OGG_HEADERSIZE+curseg];
                //                if ((buf - oldBuf + FRAME_SIZE) > maxLen) {
                //                    break;
                //                }
                
                speex_bits_read_from(&bits, buf, FRAME_SIZE);
                speex_decode_int(dec_state, &bits, output);
                
                for (int i = 0; i < FRAME_SIZE; i++) {
                    pcmFrame[i] = output[i];
                }
                
                [PCMRawData appendBytes:pcmFrame length:sizeof(short)*FRAME_SIZE];
                if (segments !=curseg+1) {
                    buf += bodybytes;
                }
                frames++;
            }
        }
        backCount++;
        
    }
    
    
    
    
    speex_bits_destroy(&bits);
    speex_decoder_destroy(dec_state);
    
    
    NSMutableData *outData = [[[NSMutableData alloc]init] autorelease];
	WriteWAVEHeader(outData, frames);
    [outData appendData:PCMRawData];
    
    return outData;
}

float CalculatePlayTime(NSData *speexData, int nbBytes)
{
    float play_time = 0.0;
    unsigned int speexHeaderLength = sizeof(SpeexHeader);
    unsigned int rawSpeexDataLength = [speexData length] - speexHeaderLength;
    play_time = (float)rawSpeexDataLength/(nbBytes*50); //每秒是50帧
    
    return play_time;
}

void speexEncoderTLD1(NSString* file1, NSString*file2){
	char *inFile,*outFile;
	FILE *fin,*fout;
	short inf[FRAME_SIZE];
	spx_int16_t input[FRAME_SIZE];
	char cbits[200];
	int nbBytes;
	void *en_state;
	SpeexBits bits;
	en_state = speex_encoder_init(&speex_wb_mode);
	int tmp=8;
	speex_encoder_ctl(en_state, SPEEX_SET_QUALITY, &tmp);
	inFile = (char*)[file1 cStringUsingEncoding:NSASCIIStringEncoding];
	fin =fopen(inFile, "r");
	outFile  = (char*)[file2 cStringUsingEncoding:NSASCIIStringEncoding];
	fout = fopen(outFile, "w");
	speex_bits_init(&bits);
	while (1) {
		//从fin中读取文件的16bits audio frame数据保存在inf中
		fread(inf, sizeof(short), FRAME_SIZE, fin);
		//判断文件是不是结束，结束文件的读取以及编码。
		if (feof(fin))
			break;
		/*Copy the 16 bits values to float(spx_int16_t) so Speex can work on them*/
		for (int i=0; i<FRAME_SIZE; i++) {
			input[i] = inf[i];
		}
		/*Flush all the bits in the struct so we can encode a new frame*/
		speex_bits_reset(&bits);
		/*Encode the frame*/
		speex_encode_int(en_state,input, &bits);
		//把当前帧编码以后的数据放入数组cbits当中,然后写入，nbByte为当前帧写入到cbites的字节数。
		nbBytes = speex_bits_write(&bits, cbits, 200);
		//首先写入当前帧写入文件的字节数目,确保编码后的帧每一帧开头是该帧的长度。
		//解码的时候首先得到这个长度，而后根据这个长度读取一帧。
		fwrite(&nbBytes, sizeof(int), 1, fout);
		/*写入编码后帧的全部数据,从上面我们可以得知，cbits当中保存的字节数其实就是nbBytes*/
		fwrite(cbits,1, nbBytes, fout);
	}
	speex_encoder_destroy(en_state);
	speex_bits_destroy(&bits);
	fclose(fin);
	fclose(fout);
}

@end
