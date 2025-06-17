class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                  \
                                    --with-boot-jdk=../OpenJdk-Binaries-#{version}  \
                                    --disable-ccache                                \
                                    --disable-precompiled-headers                   \
                                    --disable-warnings-as-errors                    \
                                    --enable-full-docs=no                           \
                                    --with-freetype=system                          \
                                    --with-libjpeg=system                           \
                                    --with-giflib=system                            \
                                    --with-libpng=system                            \
                                    --with-lcms=system                              \
                                    --with-zlib=system                              \
                                    --with-harfbuzz=system",
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
