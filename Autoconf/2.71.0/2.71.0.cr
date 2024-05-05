class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--program-suffix=2.71"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeLink("autoconf2.71","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/autoconf",:symbolicLink)
        makeLink("autoheader2.71","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/autoheader",:symbolicLink)
        makeLink("autom4te2.71","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/autom4te",:symbolicLink)
        makeLink("autoreconf2.71","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/autoreconf",:symbolicLink)
        makeLink("autoscan2.71","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/autoscan",:symbolicLink)
        makeLink("autoupdate2.71","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/autoupdate",:symbolicLink)
        makeLink("ifnames2.71","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/ifnames",:symbolicLink)
    end

end
