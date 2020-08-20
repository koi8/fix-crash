CMD ["bash"]
RUN apt-get update  \
	&& apt-get install -y --no-install-recommends ca-certificates curl netbase wget  \
	&& rm -rf /var/lib/apt/lists/*
RUN set -ex; if ! command -v gpg > /dev/null; then apt-get update; apt-get install -y --no-install-recommends gnupg dirmngr ; rm -rf /var/lib/apt/lists/*; fi
RUN apt-get update  \
	&& apt-get install -y --no-install-recommends git mercurial openssh-client subversion procps  \
	&& rm -rf /var/lib/apt/lists/*
ENV DOTNET_RUNNING_IN_CONTAINER=true DOTNET_USE_POLLING_FILE_WATCHER=true NUGET_XMLDOC_MODE=skip POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetCoreSDK-Debian-10
RUN apt-get update  \
	&& apt-get install -y --no-install-recommends libc6 libgcc1 libgssapi-krb5-2 libicu63 libssl1.1 libstdc++6 zlib1g  \
	&& rm -rf /var/lib/apt/lists/*
RUN dotnet_sdk_version=3.1.301  \
	&& curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz  \
	&& dotnet_sha512='dd39931df438b8c1561f9a3bdb50f72372e29e5706d3fb4c490692f04a3d55f5acc0b46b8049bc7ea34dedba63c71b4c64c57032740cbea81eef1dce41929b4e'  \
	&& echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c -  \
	&& mkdir -p /usr/share/dotnet  \
	&& tar -ozxf dotnet.tar.gz -C /usr/share/dotnet  \
	&& rm dotnet.tar.gz  \
	&& ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet  \
	&& dotnet help
RUN powershell_version=7.0.1  \
	&& curl -SL --output PowerShell.Linux.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.x64.$powershell_version.nupkg  \
	&& powershell_sha512='b6b67b59233b3ad68e33e49eff16caeb3b1c87641b9a6cd518a19e3ff69491a8a1b3c5026635549c7fd377a902a33ca17f41b7913f66099f316882390448c3f7'  \
	&& echo "$powershell_sha512 PowerShell.Linux.x64.$powershell_version.nupkg" | sha512sum -c -  \
	&& mkdir -p /usr/share/powershell  \
	&& dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.x64  \
	&& dotnet nuget locals all --clear  \
	&& rm PowerShell.Linux.x64.$powershell_version.nupkg  \
	&& ln -s /usr/share/powershell/pwsh /usr/bin/pwsh  \
	&& chmod 755 /usr/share/powershell/pwsh  \
	&& find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm
COPY dir:1728bf0b3f57089da17e02c51245ced9396ca42ce0da8efe7a635c475d35eecc in .

ENTRYPOINT ["dotnet" "bin/Debug/netcoreapp3.1/publish/crash.dll"]
