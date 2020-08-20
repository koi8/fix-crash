FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
LABEL crashapp.version="Fixed one"
LABEL candidate.name="Oleh Kolesnykov"
RUN groupadd -r crashapp && useradd -r -s /bin/false -g crashapp crashapp
WORKDIR /crashapp
COPY bin bin/
COPY notes.txt .
RUN cp notes.txt "c:\\notes.txt" && \
    chown -R crashapp:crashapp /crashapp
USER crashapp
ENTRYPOINT ["dotnet","bin/Debug/netcoreapp3.1/publish/crash.dll"]
