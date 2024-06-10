class Target < ISM::Software
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "#{option("C-Ares") ? "--shared-cares" : ""}",
                            "#{option("Libuv") ? "--shared-libuv" : ""}",
                            "--shared-openssl",
                            "#{option("Nghttp2") ? "--shared-nghttp2" : ""}",
                            "--shared-zlib",
                            "--with-intl=system-icu"],
                            buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeLink("node","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/node-18.17.1",:symbolicLinkByOverwrite)
    end

end
