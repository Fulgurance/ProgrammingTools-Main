class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                  \
                                    #{option("C-Ares") ? "--shared-cares" : ""}     \
                                    #{option("Libuv") ? "--shared-libuv" : ""}      \
                                    --shared-openssl                                \
                                    #{option("Nghttp2") ? "--shared-nghttp2" : ""}  \
                                    --shared-zlib                                   \
                                    --with-intl=system-icu",
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

        makeLink(   target: "node",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/node-18.17.1",
                    type:   :symbolicLinkByOverwrite)
    end

end
