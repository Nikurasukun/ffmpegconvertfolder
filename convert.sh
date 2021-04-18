typeoffirstparameter() { # Is the input parameter lossless or lossy
  if [ "$input" == "flac" ] || [ "$input" == "wav" ] || [ "$input" == "alac" ];
  then
    inputfiletype="lossless"
  elif [ "$input" == "mp3" ] || [ "$input" == "libvorbis" ] || [ "$input" == "aac" ];
  then
    inputfiletype="lossy"
  fi
}

typeofsecondparameter() { # Is the output parameter lossless or lossy
  if [ "$output" == "flac" ] || [ "$output" == "wav" ] || [ "$output" == "alac" ];
  then
    outputfiletype="lossless"
  elif [ "$output" == "mp3" ] || [ "$output" == "libvorbis" ] || [ "$output" == "aac" ];
  then
    outputfiletype="lossy"
  fi
}

outputogg() { # Change the file extension of the output to ogg instead of libvorbis
  if [ "$output" == "libvorbis" ];
  then
    extension="ogg"
  else
    extension="$output"
  fi
}

inputogg() { # Change the file extension of the output to ogg instead of libvorbis
  if [ "$input" == "libvorbis" ];
  then
    extension="ogg"
  else
    extension="$input"
  fi
}

options() { # List available options
  echo "-i {input file type}"
  echo "-o {output file type}"
  echo "-q {output file quality}"
  echo "help           Print the help dialogue"
}

smallhelp() { # Small help if no parameter is given
  echo "No Parameter given"
  options
  echo "use ./convert.sh help for full documentation"
}

printhelp() { # Full help dialogue
  echo "FCF (FfmpegConvertFolder), the bash-script to convert an entire folder with ffmpeg"
  echo ""
  options
  supportedformats
}

supportedformats() { # echo supported formats
  echo "Currently supported codecs:"
  supportedaudioformats
  supportedvideoformats
  echo "If some codec you want is missing, please write an issiue at: https://github.com/Nikurasukun/ffmpegconvertfolder/issues"
}

supportedaudioformats() { # echos supported audio formats
  echo "audio:"
  echo "Lossless: flac, alac, wav"
  echo "Lossy: mp3, libvorbis, aac"
}

supportedvideoformats() { # echos supported video formats
  echo "video:"
  echo "Lossless: None"
  echo "Lossy: None"
}

if [ "$1" == "help" ]; # catch the input of help
then
  printhelp
else
  while getopts i:o:q: flag # get the options
  do
      case "${flag}" in
          i) input=${OPTARG};;
          o) output=${OPTARG};;
          q) quality=${OPTARG};;
      esac
  done
  typeoffirstparameter
  typeofsecondparameter
  if [ "$input" == "" ] && [ "$output" == "" ] && [ "$quality" == "" ]; # if no parameter is given
  then
    smallhelp
  elif [ "$inputfiletype" == "lossless" ] && [ "$outputfiletype" == "lossy" ]; # Lossless to Lossy
  then
    outputogg
    mkdir "$output"
    for i in *."$input";
    do
      outputfilename=$(basename "$i" "$input")$extension # get the outputfilename
      echo "$outputfilename"
      echo "Element: $i"
      if [ "$output" == "libvorbis" ]
      then
        if [ ! -z "$quality" ];
        then
          ffmpeg -i "$i" -vsync 2 -acodec "$output" -q:a "$quality" "$outputfilename";
        else
          ffmpeg -i "$i" -vsync 2 -acodec "$output" "$outputfilename";
        fi
      else
        if [ ! -z "$quality" ];
        then
          ffmpeg -i "$i" -vcodec copy -acodec "$output" -q:a "$quality" "$outputfilename";
        else
          ffmpeg -i "$i" -vcodec copy -acodec "$output" "$outputfilename";
        fi
      fi
      mv "$outputfilename" ./"$output";
    done
  elif [ "$inputfiletype" == "lossy" ] && [ "$outputfiletype" == "lossless" ];
  then
    echo "You are about to convert a lossy file in a lossless format! Do you really want to do this? (y/N)" # abort because of converting lossy to lossless
    read shure
    if [ "$shure" == "Y" ] || [ "$shure" == "y" ] || [ "$shure" == "yes" ] || [ "$shure" == "Yes" ];
    then
      inputogg
      mkdir "$output"
      for i in *."$input";
      do
        outputfilename=$(basename "$i" "$input")$output # get the outputfilename
        echo "$outputfilename"
        echo "Element: $i"
        if [ ! -z "$quality" ];
        then
          ffmpeg -i "$i" -vcodec copy -acodec "$output" -q:a "$quality" "$outputfilename";
        else
          ffmpeg -i "$i" -vcodec copy -acodec "$output" "$outputfilename";
        fi
        mv "$outputfilename" ./"$output";
      done
    else
    echo "Cancel"
    fi
  else
    echo "You entered not supported formats" # if something other is inputed
    supportedformats
  fi
fi
