class Target < ISM::Software

    def prepare
        super

        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}/src/cares_wrap.h","<ares_nameser.h>","<arpa/nameser.h>",25)
    end
    
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

        makeLink("node","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/node-14.17.5",:symbolicLinkByOverwrite)
    end

end
