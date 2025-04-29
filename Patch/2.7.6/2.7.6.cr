class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr                      \
                                        --host=#{Ism.settings.chrootTarget} \
                                        --build=$(./build-aux/config.guess)",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr                          \
                                        --host=#{Ism.settings.systemTarget}     \
                                        --build=#{Ism.settings.systemTarget}    \
                                        --target=#{Ism.settings.systemTarget}",
                            path:       buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
