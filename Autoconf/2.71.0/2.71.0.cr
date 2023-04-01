class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--program-suffix=2.71"],
                            buildDirectoryPath)

        moveFile("#{buildDirectoryPath(false)}autoconf.texi","#{buildDirectoryPath(false)}autoconf271.texi")
        deleteFile("#{buildDirectoryPath(false)}autoconf.info")
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        moveFile("#{buildDirectoryPath(false)}autoconf271.info","#{builtSoftwareDirectoryPath(false)}usr/share/info/autoconf271.info")
    end

    def install
        runInstallInfoCommand(["--info-dir=/usr/share/info","autoconf271.info"])
    end

end
