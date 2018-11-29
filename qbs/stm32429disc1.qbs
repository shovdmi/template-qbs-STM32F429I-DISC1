//Подключаем стандартные библиотеки в стиле QML
//Основные концепции языка:
//Проект (Project), Продукт (Product), Артефакт (Artifact), Модуль (Module), Правило (Rule), Группа(Group), Зависимость (Depends), Тег (Tag).
//Продукт — это аналог pro или vcproj, т. е. одна цель для сборки.
//Проект — это набор ваших продуктов вместе с зависимостями, воспринимаемый системой сборки как одно целое. Один проект — один граф сборки.
//Тег — система классификации файлов. Например «*.cpp» => «cpp»
//Правило — Преобразование файлов проекта, отмеченных определенными тегами. Генерирует другие файлы, называемые Артефактами.
//Как правило, это компиляторы или другие системы сборки.
//Артефакт — файл, над который является выходным для правила (и возможно, входным для други правил). Это обычно «obj», «exe» файлы.
//У многих QML-объектов есть свойство condition, которое отвечает за то, будет собираться он или нет. А если нам необходимо разделить так файлы?
//Для этого их можно объединить в группу (Group)
//Rule умеет срабатывать на каждый файл, попадающий под что-то. Может срабатывать по разу на каждый фаил (например, для вызова компилятора), а может один раз на все (линкер).
//Transformer предназначен для срабатывания только на один фаил, с заранее определенным именем. Например, прошивальщик или какой-нибудь хитрый скрипт.
//флаг multiplex, который говорит о том, что это правило обрабатывает сразу все файлы данного типа скопом.



import qbs
import qbs.FileInfo
import qbs.ModUtils

CppApplication {

    // основной элемент файла - проект.

    //    moduleSearchPaths: "qbs" // Папка для поиска дополнительных модулей, таких как cpp и qt

    // Один проект может состоять из нескольких продуктов - конечных целей сборки.
    // Один проект может состоять из нескольких продуктов - конечных целей сборки.
    // указываем связанные файлы с помощью references. Внимание: это не жестко заданный порядок!
    // Порядок задается с помощью зависимостей, о них позже
    //    references: [
    //           "*.qbs",
    //       ]

    name: "QT-STM32F429I-DISC1" // Название выходного файла (без суффикса, он зависит от цели)
    type: ["application", // Тип - приложение, т.е. исполняемый файл.
        "bin", "hex"]

    Depends {
        name: "cpp" // этот продукт зависит от компилятора C++
    }

    consoleApplication: true
    cpp.positionIndependentCode: false
    cpp.executableSuffix: ".elf"

    property string Home: path + "/.."
    property string Config: Home + "/Config"
    property string FreeRTOS: Home + "/Middlewares/Third_Party/FreeRTOS"
    property string CMSIS_RTOS: FreeRTOS + "/Source/CMSIS_RTOS"
    property string FatFs: Home + "/Middlewares/Third_Party/FatFs"
    property string HAL: Home + "/Drivers/STM32F4xx_HAL_Driver"
    property string CMSIS: Home + "/Drivers/CMSIS"
    property string Inc: Home + "/Core/Inc"
    property string Src: Home + "/Core/Src"
    property string startup: Home + "/startup"
    property string USB_HOST: Home + "/Middlewares/ST/STM32_USB_Host_Library"
    property string STemWin: Home + "/Gui"
    property string GUIBuilder: Home + "/GUIBuilder"
    property string BSP: Home + "/Drivers/BSP/STM32F429I-Discovery"
    property string Utilities: Home + "/Utilities"
    property string Components: Home + "/Drivers/BSP/Components"
    property string Modules: Home + "/Modules"
    property string lwip: Home + "/Middlewares/Third_Party/LwIP"
    property string DSP: Home + "/Drivers/CMSIS/DSP_Lib/Source"

    Group {
        //Имя группы
        name: "DSP"
        //Список файлов в данном проекте.
        files: [
            DSP + "/FastMathFunctions/*",
            DSP + "/TransformFunctions/*",
        ]
    }

    Group {
        //Имя группы
        name: "Modules"
        //Список файлов в данном проекте.
        files: [
            Modules + "/filebrowser/*.c",
            Modules + "/filebrowser/*.h",
        ]
    }

    Group {
        //Имя группы
        name: "Components"
        //Список файлов в данном проекте.CDC
        files: [
            Components + "/ili9341/*.c",
            Components + "/ili9341/*.h",
            Components + "/stmpe811/*.c",
            Components + "/ts3510/*.h",
            Components + "/ts3510/*.h",


        ]
    }

    Group {
        //Имя группы
        name: "Utilities"
        //Список файлов в данном проекте.
        files: [
            Utilities + "/CPU/*.h",
            Utilities + "/CPU/*.c",
            Utilities + "/Fonts/*.h",
//            Utilities + "/Fonts/*.c",
//            Utilities + "/Log/*.h",
//            Utilities + "/Log/*.c",
        ]
    }

    Group {
        //Имя группы
        name: "BSP"
        //Список файлов в данном проекте./
        files: [
            BSP + "/*.c",
            BSP + "/*.h",
        ]
    }

    Group {
        //Имя группы
        name: "Config"
        //Список файлов в данном проекте.
        files: [
//            Home + "/Middlewares/STemWin/inc/*.h",
//            Home + "/Middlewares/STemWin/OS/GUI_X_OS.c",
            Home + "/Middlewares/STemWin/Lib/STemWin540_CM4_OS_GCC_ot.a",
            Config + "/*.h",
            Config + "/*.c",
        ]
    }

    Group {
        //Имя группы
        name: "STemWin"
        //Список файлов в данном проекте.
        files: [
            STemWin + "/Core/videoplayer/*win.c",
            STemWin + "/Core/system/*win.c",
            STemWin + "/Core/games/*win.c",
            STemWin + "/Core/imagebrowser/*win.c",
            STemWin + "/Core/game/*win.c",
            STemWin + "/Core/filebrowser/*win.c",
            STemWin + "/Core/benchmark/*win.c",

            STemWin + "/Target/*.c",
            STemWin + "/Target/*.h",

            Home + "/Middlewares/STemWin/inc/*.h",
            Home + "/Middlewares/STemWin/OS/GUI_X_OS.c",
            Home + "/Middlewares/STemWin/Lib/STemWin540_CM4_OS_GCC.a",
        ]
    }

    Group {
        //Имя группы
        name: "GUIBuilder"
        //Список файлов в данном проекте.
        files: [
            GUIBuilder + "/*.c",
        ]
    }

    Group {
        //Имя группы
        name: "FreRTOS v9.0.0"
        //Список файлов в данном проекте.
        files: [
            FreeRTOS + "/Source/*.c",
            FreeRTOS + "/Source/include/*.h",
            FreeRTOS + "/Source/portable/GCC/ARM_CM4F/*.h",
            FreeRTOS + "/Source/portable/GCC/ARM_CM4F/*.c",
//            FreeRTOS + "/Source/portable/Common/mpu_wrappers.c",
            //FreeRTOS + "/Source/portable/MemMang/heap_1.c",
            //FreeRTOS + "/Source/portable/MemMang/heap_2.c",
            //FreeRTOS + "/Source/portable/MemMang/heap_3.c",
            FreeRTOS + "/Source/portable/MemMang/heap_4.c",
            //FreeRTOS + "/Source/portable/MemMang/heap_5.c",
        ]
    }

    Group {
        //Имя группы
        name: "CMSIS-RTOS"
        //Список файлов в данном проекте.
        files: [
            CMSIS_RTOS + "/*.c",
            CMSIS_RTOS + "/*.h",
        ]
    }

    Group {
        //Имя группы
        name: "FatFs"
        //Список файлfilebrowserов в данном проекте.
        files: [
            FatFs + "/src/*.c",
            FatFs + "/src/*.h",
            FatFs + "/src/option/syscall.c",
            FatFs + "/src/option/unicode.c",
        ]
    }

    Group {
        //Имя группы
        name: "HAL"
        //список файлов в данном проекте.
        files: [
            HAL + "/Src/*.c",
            HAL + "/Inc/*.h",
            HAL + "/Inc/Legacy/*.h",
        ]
        excludeFiles: [
            HAL + "/Src/stm32f4xx_hal_timebase_rtc_alarm_template.c",
            HAL + "/Src/stm32f4xx_hal_timebase_rtc_wakeup_template.c",
            HAL + "/Src/stm32f4xx_hal_timebase_tim_template.c",
            HAL + "/Src/stm32f4xx_hal_eth.c",
        ]
    }

    Group {
        //Имя группыCore
        name: "CMSIS"
        //Список файлов в данном проекте.
        files: [
            CMSIS + "/Include/*.h",
            CMSIS + "/Device/ST/STM32F4xx/Include/*.h",
            CMSIS + "/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c",
        ]
        excludeFiles: [
        ]
    }

    Group {
        //Имя группы
        name: "Inc"
        //Список файлов в данном проекте.
        files: [
            Inc + "/*.h",
        ]
    }

    Group {
        //Имя группы
        name: "Src"
        //Список файлов в данном проекте.
        files: [
            Src + "/*.c",
            Src + "/*.cpp",
        ]
        cpp.libraryPaths: [
             STemWin + "/STemWin_Addons",
             Home + "/Middlewares/STemWin/Lib",
        ]

        cpp.staticLibraries: [

            ":STemWin540_CM4_OS_GCC.a",
        ]
        excludeFiles: [
             Src + "/k_res.c",
        ]
    }

    Group {
        //Имя группы
        name: "startup"
        //Список файлов в данном проекте.
        files: [
            startup + "/*.s",
        ]
    }

    Group {
        //Имя группы
        name: "USB host"
        //Список файлов в данном проекте.
        files: [
            USB_HOST + "/Core/Src/*.c",
            USB_HOST + "/Core/Inc/*.h",

            USB_HOST + "/Class/MSC/Src/*.c",
            USB_HOST + "/Class/MSC/Inc/*.h",
        ]
        excludeFiles: [
            USB_HOST + "/Core/Src/usbh_conf_template.c",
            USB_HOST + "/Core/Inc/usbh_conf_template.h",
        ]
    }



    Group {
        //Имя группы
        name: "LD"
        //Список файлов в данном проекте.
        files: [
            Home + "/*.ld",
        ]
    }

    //Каталоги с включенными файлами
    cpp.includePaths: [


        Config,

        CMSIS,
        CMSIS + "/Include",
        CMSIS + "/Device/ST/STM32F4xx/Include",

        Inc,
        Src,

        FreeRTOS + "/Source/include",
        FreeRTOS + "/Source/portable/GCC/ARM_CM4F",

        CMSIS_RTOS,

        FatFs + "/src",

        HAL + "/Inc",
        HAL + "/Inc/Legacy",

        USB_HOST + "/Core/Inc",
        USB_HOST + "/Class/MSC/Inc",

        STemWin + "/Target",
        STemWin + "/STemWin_Addons",

        Home + "/Middlewares/STemWin/inc",
        Home + "/Middlewares/STemWin",

        Utilities + "/CPU",
        Utilities + "/Fonts",
        BSP,

        Components,

        Modules + "/filebrowser",

        Components + "/ili9341",
        Components + "/stmpe811",
        Components + "/ts3510"


    ]

    cpp.defines: [
        "USE_HAL_DRIVER",
        "STM32F429xx",
        "USE_STM32F429I_DISCO",
        "__weak=__attribute__((weak))",
        "__packed=__attribute__((__packed__))",
        "__FPU_PRESENT=1",
        "ARM_MATH_CM4",
//        "USE_LCD",
        "USE_USB_HS",
//        "DATA_IN_ExtSDRAM"
    ]

    //    --------------------------------------------------------------------
    //    | ARM Core | Command Line Options                       | multilib |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-M0+| -mthumb -mcpu=cortex-m0plus                | armv6-m  |
    //    |Cortex-M0 | -mthumb -mcpu=cortex-m0                    |          |
    //    |Cortex-M1 | -mthumb -mcpu=cortex-m1                    |          |
    //    |          |--------------------------------------------|          |
    //    |          | -mthumb -march=armv6-m                     |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-M3 | -mthumb -mcpu=cortex-m3                    | armv7-m  |
    //    |          |--------------------------------------------|          |
    //    |          | -mthumb -march=armv7-m                     |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-M4 | -mthumb -mcpu=cortex-m4                    | armv7e-m |
    //    |(No FP)   |--------------------------------------------|          |
    //    |          | -mthumb -march=armv7e-m                    |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-M4 | -mthumb -mcpu=cortex-m4 -mfloat-abi=softfp | armv7e-m |
    //    |(Soft FP) | -mfpu=fpv4-sp-d16                          | /softfp  |
    //    |          |--------------------------------------------|          |
    //    |          | -mthumb -march=armv7e-m -mfloat-abi=softfp |          |
    //    |          | -mfpu=fpv4-sp-d16                          |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-M4 | -mthumb -mcpu=cortex-m4 -mfloat-abi=hard   | armv7e-m |
    //    |(Hard FP) | -mfpu=fpv4-sp-d16                          | /fpu     |
    //    |          |--------------------------------------------|          |
    //    |          | -mthumb -march=armv7e-m -mfloat-abi=hard   |          |
    //    |          | -mfpu=fpv4-sp-d16                          |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-M7 | -mthumb -mcpu=cortex-m7                    | armv7e-m |
    //    |(No FP)   |--------------------------------------------|          |
    //    |          | -mthumb -march=armv7e-m                    |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-M7 | -mthumb -mcpu=cortex-m7 -mfloat-abi=softfp | armv7e-m |
    //    |(Soft FP) | -mfpu=fpv5-sp-d16                          | /softfp  |
    //    |          |--------------------------------------------|          |
    //    |          | -mthumb -march=armv7e-m -mfloat-abi=softfp |          |
    //    |          | -mfpu=fpv5-sp-d16                          |          |
    //    |          |--------------------------------------------|          |
    //    |          | -mthumb -mcpu=cortex-m7 -mfloat-abi=softfp |          |
    //    |          | -mfpu=fpv5-d16                             |          |
    //    |          |--------------------------------------------|          |
    //    |          | -mthumb -march=armv7e-m -mfloat-abi=softfp |          |
    //    |          | -mfpu=fpv5-d16                             |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-M7 | -mthumb -mcpu=cortex-m7 -mfloat-abi=hard   | armv7e-m |
    //    |(Hard FP) | -mfpu=fpv5-sp-d16                          | /fpu     |
    //    |          |--------------------------------------------|          |
    //    |          | -mthumb -march=armv7e-m -mfloat-abi=hard   |          |
    //    |          | -mfpu=fpv5-sp-d16                          |          |
    //    |          |--------------------------------------------|          |
    //    |          | -mthumb -mcpu=cortex-m7 -mfloat-abi=hard   |          |
    //    |          | -mfpu=fpv5-d16                             |          |
    //    |          |-------o-------------------------------------|          |
    //    |          | -mthumb -march=armv7e-m -mfloat-abi=hard   |          |
    //    |          | -mfpu=fpv5-d16                             |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-R4 | [-mthumb] -march=armv7-r                   | armv7-ar |
    //    |Cortex-R5 |                                            | /thumb   |
    //    |Cortex-R7 |                                            |          |
    //    |(No FP)   |                                            |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-R4 | [-mthumb] -march=armv7-r -mfloat-abi=softfp| armv7-ar |
    //    |Cortex-R5 | -mfpu=vfpv3-d16                            | /thumb   |
    //    |Cortex-R7 |                                            | /softfp  |
    //    |(Soft FP) |                                            |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-R4 | [-mthumb] -march=armv7-r -mfloat-abi=hard  | armv7-ar |
    //    |Cortex-R5 | -mfpu=vfpv3-d16                            | /thumb   |
    //    |Cortex-R7 |                                            | /fpu     |
    //    |(Hard FP) |                                            |          |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-A* | [-mthumb] -march=armv7-a                   | armv7-ar |
    //    |(No FP)   |                                            | /thumb   |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-A* | [-mthumb] -march=armv7-a -mfloat-abi=softfp| armv7-ar |
    //    |(Soft FP) | -mfpu=vfpv3-d16                            | /thumb   |
    //    |          |                                            | /softfp  |
    //    |----------|--------------------------------------------|----------|
    //    |Cortex-A* | [-mthumb] -march=armv7-a -mfloat-abi=hard  | armv7-ar |
    //    |(Hard FP) | -mfpu=vfpv3-d16                            | /thumb   |
    //    |          |                                            | /fpu     |
    //    --------------------------------------------------------------------

    cpp.commonCompilerFlags: [
        "-mcpu=cortex-m4",
        "-mfloat-abi=hard",
        "-mfpu=fpv4-sp-d16",
        "-mthumb",
    ]


    cpp.driverFlags: [
        "-mcpu=cortex-m4",
        "-mfloat-abi=hard",
        "-mfpu=fpv4-sp-d16",
        "-mthumb",
        "-Xlinker",
        "--gc-sections",
        "-specs=nosys.specs",
        "-specs=nano.specs",
        "-Wl,-Map=" + path + "/../QT-STM32F429I-DISC1.map",

//        "-Xlinker --cref",                    //Cross reference
//        "-Xlinker --print-map",               //Print link map
//        "-u_printf_float",                    //Use float with nano printf
//        "-u_scanf_float",                     //Use float with nano scanf
//        "-v",                                 //Verbose
    ]


    cpp.linkerFlags: [
        "--start-group",
        "-T" + path + "/../STM32F429ZITx_FLASH.ld",
        "-lm",
        "-lnosys",
        "-lgcc",
        "-lc",
        "-lstdc++",
    ]

    cpp.libraryPaths: [
        Home + "/Middlewares/STemWin/Lib",
        STemWin + "/STemWin_Addons",
        Home + "/Drivers/CMSIS/Lib/GCC",
    ]

    cpp.staticLibraries: [
        ":STemWin540_CM4_OS_GCC.a",
    ]

    Properties {
        condition: qbs.buildVariant === "debug"
        cpp.debugInformation: true
        cpp.optimization: "none"
    }

    Properties {
        condition: qbs.buildVariant === "release"
        cpp.debugInformation: false
        cpp.optimization: "small" //"none", "fast", "small"
    }

    Properties {
        condition: cpp.debugInformation
        cpp.defines: outer.concat("DEBUG")
    }

    Group {
        // Properties for the produced executable
        fileTagsFilter: product.type
        qbs.install: true
    }

    Rule {
        id: binDebugFrmw
        condition: qbs.buildVariant === "debug"
        inputs: ["application"]

        Artifact {
            fileTags: ["bin"]
            filePath: input.baseDir + "/" + input.baseName + ".bin"
        }

        prepare: {
            var objCopyPath = "arm-none-eabi-objcopy"
            var argsConv = ["-O", "binary", input.filePath, output.filePath]
            var cmd = new Command(objCopyPath, argsConv)
            cmd.description = "converting to BIN: " + FileInfo.fileName(
                        input.filePath) + " -> " + input.baseName + ".bin"

            //Запись во внутреннюю память
            var argsFlashingInternalFlash =
            [           "-f", "board/stm32f429disc1.cfg",
                        "-c", "init",
                        "-c", "reset init",
                        "-c", "flash write_image erase " + input.filePath,
                        "-c", "reset",
                        "-c", "shutdown"
            ]

            var cmdFlashInternalFlash = new Command("openocd", argsFlashingInternalFlash);
            cmdFlashInternalFlash.description = "Wrtie to the internal flash"

            return [cmd]
        }
    }

    Rule {
        id: binFrmw
        condition: qbs.buildVariant === "release"
        inputs: ["application"]

        Artifact {
            fileTags: ["bin"]
            filePath: input.baseDir + "/" + input.baseName + ".bin"
        }

        prepare: {
            var objCopyPath = "arm-none-eabi-objcopy"
            var argsConv = ["-O", "binary", input.filePath, output.filePath]
            var cmd = new Command(objCopyPath, argsConv)
            cmd.description = "converting to BIN: " + FileInfo.fileName(
                        input.filePath) + " -> " + input.baseName + ".bin"


            //Запись во внутреннюю память
            var argsFlashingInternalFlash =
            [           "-f", "board/stm32f429disc1.cfg",
                        "-c", "init",
                        "-c", "reset init",
                        "-c", "flash write_image erase " + input.filePath,
                        "-c", "reset",
                        "-c", "shutdown"
            ]

            var cmdFlashInternalFlash = new Command("openocd", argsFlashingInternalFlash);
            cmdFlashInternalFlash.description = "Wrtie to the internal flash"

            return [cmd]
        }
    }

    Rule {
        id: hexFrmw
        condition: qbs.buildVariant === "release"
        inputs: ["application"]

        Artifact {
            fileTags: ["hex"]
            filePath: input.baseDir + "/" + input.baseName + ".hex"
        }

        prepare: {
            var objCopyPath = "arm-none-eabi-objcopy"
            var argsConv = ["-O", "ihex", input.filePath, output.filePath]
            var cmd = new Command(objCopyPath, argsConv)
            cmd.description = "converting to HEX: " + FileInfo.fileName(
                        input.filePath) + " -> " + input.baseName + ".hex"

            return [cmd]
        }
    }
}
