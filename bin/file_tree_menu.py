#!/usr/bin/env python
## original script made by melanogaster42
## https://github.com/melanogaster42/File_tree_menu
## add 'myplacesmenu = require("myplacesmenu")' to your rc.lua
## add '{ "files", myplacesmenu.myplacesmenu()},' to your menu
import os
 
path = '/home/mony/' ## replace 'mony' with your username
filetosave = open('/home/mony/.config/awesome/myplacesmenu.lua', 'w') ## replace 'mony' with your username
iconspath = '/usr/share/icons/Faenza' ## set icons path 
icons = "" + iconspath + "/mimetypes/48/"
ficon = "" + iconspath + "/places/48/"
 
def test_file_type(file_end):
        if file_end == 'iso':
               return 'brasero -i'
        elif file_end == "gz" or file_end == "xz" or file_end == "zip" or file_end == "z":
               return 'engrampa'
        elif file_end == "mp3" or file_end == "flac" or file_end == "wav" or file_end == "wma" or file_end == 'mp4' or file_end == 'mpeg' or file_end == 'webm' or file_end == 'avi' or file_end == 'ogg' or file_end == 'ogv' or file_end == 'mkv' or file_end == "3gp":
               return 'vlc'
        elif file_end == 'xml' or file_end == 'html' or file_end == 'htm' or file_end == 'xhtml':
               return 'firefox'
        elif file_end == 'py' or file_end == 'cpp' or file_end == 'c' or file_end == 'sh' or file_end == 'lua':
               return 'geany'
        elif file_end == 'out' or file_end == 'class' or file_end == 'pyo':
               return 'urxvt -c'
        elif file_end == 'jpg' or file_end == 'png' or file_end == 'gif':
               return 'viewnior'
        else: return 'pluma'

def file_icon(file_end):
        if file_end == "iso":
               return 'icons .. "application-x-cd-image.png"'
        elif file_end == "backup" or file_end == "bak":
               return 'icons .. "empty.png"'
        elif file_end == "gz":
               return 'icons .. "application-x-gzip.png"'
        elif file_end == "bz":
               return 'icons .. "application-x-bzip-compressed-tar.png"'
        elif file_end == "zip":
               return 'icons .. "application-x-zip.png"'
        elif file_end == "tar":
               return 'icons .. "application-x-tar.png"'
        elif file_end == "jar":
               return 'icons .. "application-x-jar.png"'
        elif file_end == "rar":
               return 'icons .. "application-x-rar.png"'
        elif file_end == "z" or file_end == "lzo" or file_end == "lhz" or file_end == "lha" or file_end == "lzma" or file_end == "shar" or file_end == "sit" or file_end == "xz" or file_end == "cpio":
               return 'icons .. "application-x-rar.png"'
        elif file_end == "mp3" or file_end == "flac" or file_end == "wav" or file_end == "wma":
               return 'icons .. "media-audio.png"'
        elif file_end == "mp4" or file_end == "mpeg" or file_end == "webm" or file_end == "avi" or file_end == "ogg" or file_end == "ogv" or file_end == "mkv" or file_end == "3gp":
               return 'icons .. "video.png"'
        elif file_end == "xml" or file_end == "html" or file_end == "htm" or file_end == "xhtml":
               return 'icons .. "html.png"'
        elif file_end == "py":
               return 'icons .. "text-x-python.png"'
        elif file_end == "cpp" or file_end == "c":
               return 'icons .. "text-x-c.png"'
        elif file_end == "java":
               return 'icons .. "text-x-java.png"'
        elif file_end == "sh":
               return  'icons .. "shellscript.png"'
        elif file_end == "jpg" or file_end == "jpeg":
               return 'icons .. "image-jpeg.png"'
        elif file_end == "png":
               return 'icons .. "image-png.png"'
        elif file_end == "gif":
               return 'icons .. "image-gif.png"'
        elif file_end == "bmp":
               return 'icons .. "image-bmp.png"'
        elif file_end == "tiff":
               return 'icons .. "image-tiff.png"'
        elif file_end == "ico":
               return 'icons .. "image-x-portable-bitmap.png"'
        elif file_end == "pdf":
               return 'icons .. "application-pdf.png"'
        elif file_end == "doc" or file_end == "docx" or file_end == "odt" or file_end == "ott":
               return 'icons .. "application-vnd.openxmlformats-officedocument.wordprocessingml.document.png"'
        elif file_end == "pps" or file_end == "ppsx" or file_end == "ppt" or file_end == "pptx" or file_end == "odp":
               return 'icons .. "application-vnd.openxmlformats-officedocument.presentationml.presentation.png"'
        elif file_end == "xls" or file_end == "xlsx" or file_end == "ods":
               return 'icons .. "application-vnd.openxmlformats-officedocument.spreadsheetml.sheet.png"'
        else: return 'icons .. "misc.png"'
        
        

def recursion(path, count):
        likels = os.listdir(path)
        newstuff = 'myplacesmenu[%d] = {\n' % (count)
        output = ''
        count = count * 100
        othercount = count
        type_of_file = ''
        depth_into_string = 0
        for directories in likels:
                if os.path.isdir(path + directories) and not (directories[0] == '.'):
                        newstuff = newstuff + '{[====[' + directories + ']====], myplacesmenu[%d], ficon .. "folder.png" },\n' % (count)
                        count = count + 1
                elif not (directories[0] == '.'):
                        depth_into_string = 0
                        type_of_file = ''
                        for character in reversed(directories):
                               if character == '.':
                                     type_of_file = directories[-depth_into_string:]
                                     break
                               elif depth_into_string >= 6:
                                     break
                               depth_into_string = depth_into_string + 1
                        newstuff = newstuff + '{[====[' + directories + ']====], [====[' + test_file_type(type_of_file) + " '" + path + directories + "']====], " + file_icon(type_of_file) + " },\n"
        newstuff = newstuff + "{'open here', " "'caja --no-desktop ' .. [====['" + path  + "']====]}\n }\n\n"
        

#recursive call to search directories inside current path
        count = othercount
        for directories in likels:
                if os.path.isdir(path + directories) and not (directories[0] == '.'):
                        newstuff = recursion(path + directories + '/', count) + newstuff
                        count = count + 1
        return newstuff
#call to run program 
#also specifies starting directory
                  
filetosave.write('module("myplacesmenu")\n\nicons = "' + icons + '"\nficon = "' + ficon + '"\n\nmyplacesmenu = {}\n' + recursion(path, 1) + '\npassed = myplacesmenu[1]\nfunction myplacesmenu() return passed end')
