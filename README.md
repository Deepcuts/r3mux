## Welcome to r3mux for Windows
r3mux is a simple batch file that will scan an INPUT folder and remux all Matroska files to MPEG-4 files using [ffmpeg](https://ffmpeg.zeranoe.com/builds)

The reason I wrote it is because some of my personal devices have problems direct playing/streaming Matroska container type files from my Plex server and I wanted to simplify the process of remuxing my MKV's.

### What it does

The script will scan a specific folder for MKV files, will validate them using [mkvalidator.exe](https://www.matroska.org/downloads/mkvalidator.html), copy the video stream to the MP4 container and encode the audio stream to stereo AAC. Various settings can be tweaked inside settings.ini file, like Audio language tag and Audio bitrate.


Using an MP4 container with stereo AAC has the best chances of being direct played/streamed by a media server such as [Plex Media Server](https://plex.tv) and not forcing your server to transcode the media for your various clients.

### How to use it
1. Download the zip file and extract the r3mux-master to your hard drive. You can rename it to whatever name you want.  
2. Edit the file settings.ini inside **Program** subfolder. Defaults should work right out of the box.  
3. Copy your MKV file(s) to the **Jobs** subfolder.  
4. Inside Program subfolder execute/double click the **remux-MKV-MP4.bat** file
5. If everything goes well, your remuxed MP4 file(s) will be available in the **Completed** subfolder.  

### Other uses
1. **set-LNG.bat** can be used to batch set the audio language tag of all matching files inside **INPUT** folder.  
It can set the language tag for MKV or MP4 files inside **INPUT** folder. Just change A-LNG setting in settings.ini to match the file type.
2. **clean.bat** can be used to batch strip out unwanted characters from files names inside **OUTPUT** folder. Edit the bat file to suit your needs.

### 3rd party programs
r3mux use 3rd party programs.
1. [ffmpeg](https://ffmpeg.zeranoe.com/builds)
2. [mkvalidator.exe](https://www.matroska.org/downloads/mkvalidator.html)
3. [cecho](https://www.codeproject.com/Articles/17033/Add-Colors-to-Batch-Files)

### FAQ
Q: My MP4 file is still being transcoded by my Plex Media Server  
A: Make sure you setup **Burn Subtitles** to *Automatic* (if using subtitles) and **Remote Quality** to *Original* in Plex Player settings if you are using Plex Web.    
Make sure you set the **Remote Quality** to maximum available if you are using a Smart TV.   
