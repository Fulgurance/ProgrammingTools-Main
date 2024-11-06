class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr  \
                                    --program-suffix=2.72",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeLink(   target: "autoconf2.72",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/autoconf",
                    type:   :symbolicLink)

        makeLink(   target: "autoheader2.72",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/autoheader",
                    type:   :symbolicLink)

        makeLink(   target: "autom4te2.72",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/autom4te",
                    type:   :symbolicLink)

        makeLink(   target: "autoreconf2.72",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/autoreconf",
                    type:   :symbolicLink)

        makeLink(   target: "autoscan2.72",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/autoscan",
                    type:   :symbolicLink)

        makeLink(   target: "autoupdate2.72",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/autoupdate",
                    type:   :symbolicLink)

        makeLink(   target: "ifnames2.72",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/ifnames",
                    type:   :symbolicLink)
    end

end
