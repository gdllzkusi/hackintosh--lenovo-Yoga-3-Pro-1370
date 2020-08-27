-? or -h                Show this help.
-fea                    Checking whether BIOS support all functions of tool.
-r  <File>              Dump ROM image to file.
-a                      Auto Reset.
-l                      Load Default.
-c                      Load Custom Setting.
-gs <File> [-all]       Generate setup utility setting to file. (-all: optional
                        , include suppress and grayout setting)
-ss <File>              Modify setup variable with specified file.
-ms -fi <Field> -op <Option> Modify a setup utility setting.
-gd <ImageFile> <File>  Read image file, and generate setup utility default 
                        setting to file.
-sd <File> <ImageFile>  Modify setup utility default setting with specified 
                        file on image file.
-gstr <ImageFile> <File> -s|-b Read image file, and generate setup(-s) or setup
                         browser(-b) string setting.
-sstr <File> <ImageFile> -s|-b Modify setup or setup browser strings with 
                        specified file.
-gv <File>              Generate variable information to file.
-sv <File>              Modify variable with specified file.
-re -vn <VarName> -vg <GUID> Remove a variable by name or GUID.
-gi <ImageFile> <File>  Read image file, and generate variable information to
                        file.
-si <File> <ImageFile>  Modify variable with specified file on image file.
-gk <File>              Generate BIOS Hotkey setting to file.
-mcl                    List Multi-Config information.
-mcl <File> -f|-k <ConfigID> Dump the specified config setting to file.
-mca <File> -f|-k       Add an new config setting with specified file.
-mcm <File> -f|-k <ConfigID> Modify config setting with specified file.
-mcd -f|-k <ConfigID>   Delete the specified config setting.
-lmc [BIOS] -f|-k <ConfigID> Load the specified config setting from 
                        Multi-Config.(BIOS: optional, it use on Full type to 
                        set default setting from BIOS)
-i <ImageFile>          Operation on image. (for Multi-Config command)
-out <ImageFile>        Save as an new ImageFile.

If you found any bugs for feedback, please mail to segtools@insyde.com.
Thanks.