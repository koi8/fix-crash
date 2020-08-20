FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
COPY . .
RUN cp notes.txt "c:\\notes.txt"
ENTRYPOINT ["dotnet","bin/Debug/netcoreapp3.1/publish/crash.dll"]
