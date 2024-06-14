class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super

        fileReplaceTextAtLineNumber(path:       "#{mainWorkDirectoryPath}/kde-modules/KDEInstallDirsCommon.cmake",
                                    text:       "set(_LIBDIR_DEFAULT \"lib64\")",
                                    newText:    "set(_LIBDIR_DEFAULT \"lib\")",
                                    lineNumber: 44)

        fileReplaceText(path:       "#{mainWorkDirectoryPath}/ECMConfig.cmake.in",
                        text:       "@PACKAGE_INIT@",
                        newText:    "set(SAVE_PACKAGE_PREFIX_DIR \"${PACKAGE_PREFIX_DIR}\")\n@PACKAGE_INIT@")

        fileReplaceText(path:       "#{mainWorkDirectoryPath}/ECMConfig.cmake.in",
                        text:       "include(\"${ECM_MODULE_DIR}/ECMUseFindModules.cmake\")",
                        newText:    "include(\"${ECM_MODULE_DIR}/ECMUseFindModules.cmake\")\nset(PACKAGE_PREFIX_DIR \"${SAVE_PACKAGE_PREFIX_DIR}\")")
    end
    
    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr    \
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
