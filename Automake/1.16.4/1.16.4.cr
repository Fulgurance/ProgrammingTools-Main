class Target < ISM::Software

    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--docdir=/usr/share/doc/automake-1.16.4"],
                            buildDirectoryPath)
    end

    def build
        super
        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
