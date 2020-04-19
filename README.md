# NOTE: This project is no longer maintained

## webrtc-build

Prebuilt (currently `m73`) static [webrtc native](https://webrtc.org/native-code/) libraries + headers, and a Windows batch file to download and build them.

By default the Microsoft Visual C++ compiler is used, and both `debug` and `release` builds are created, to allow debugging with Visual Studio. 

<sup>*Since `H264` can currently not be build using Microsoft Visual C++, it is disabled. If you prefer to use `clang` and include `H264`, just change the `windows_build.bat` file*</sup>

### Building from scratch
Assuming your PC can execute Powershell scripts, just double click on the `windows_build.bat` file. This should create all files in `c:\wc`, and update the `include` and `lib` folders in this cloned repo

If it doesn't work for you, please file an issue.

<sup>*We use `c:\wc` because otherwise paths are becoming too long, and the tools choke on this.*</sup>

### Rationale
Being able to debug the webrtc native code was required for our [WebRTC .NET core](https://github.com/WonderMediaProductions/webrtc-dotnet-core) project

