class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--docdir=/usr/share/doc/pkgconf-2.0.1"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeLink("pkgconf","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/bin/pkg-config",:symbolicLink)
        makeLink("pkgconf.1","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/share/man/man1/pkg-config.1",:symbolicLink)
    end

end
