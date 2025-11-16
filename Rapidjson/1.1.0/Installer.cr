class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr            \
                                    -DCMAKE_BUILD_TYPE=Release              \
                                    -DBUILD_TESTING=OFF                     \
                                    -DRAPIDJSON_BUILD_CXX11=OFF             \
                                    -DRAPIDJSON_BUILD_DOC=OFF               \
                                    -DRAPIDJSON_BUILD_EXAMPLES=OFF          \
                                    -DRAPIDJSON_BUILD_TESTS=OFF             \
                                    -DRAPIDJSON_BUILD_THIRDPARTY_GTEST=OFF  \
                                    ..",
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
    end

end
