## Welcome to r3mux
r3mux is a simple batch file that will scan an INPUT folder and remux all Matroska files to MPEG-4 files.

The reason I wrote it is because some of my personal devices have problems direct playing/streaming Matroska container type files from my Plex server and I wanted to simplify the process of remuxing my MKV's.

### What it does

The script will scan a specific folder for MKV files, will validate them using [mkvalidator.exe](https://www.matroska.org/downloads/mkvalidator.html), copy the video stream to the MP4 container and encode the audio stream to stereo AAC. Various settings can be tweaked inside settings.ini file, like Audio language tag and Audio bitrate.


Using an MP4 container with stereo AAC has the best chances of being direct played/streamed by a media server such as [Plex Media Server](https://plex.tv) and not forcing your server to transcode the media for your various clients.

### How to use it
