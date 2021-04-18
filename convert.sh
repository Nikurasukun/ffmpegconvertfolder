typeoffirstparameter() {
  if [ "$input" == "flac" ] || [ "$input" == "wav" ] || [ "$input" == "alac" ];
  then
    inputfiletype="lossless"
  elif [ "$input" == "mp3" ] || [ "$input" == "libvorbis" ] || [ "$input" == "aac" ];
  then
    inputfiletype="lossy"
  fi
}

typeofsecondparameter() {
  if [ "$output" == "flac" ] || [ "$output" == "wav" ] || [ "$output" == "alac" ];
  then
    outputfiletype="lossless"
  elif [ "$output" == "mp3" ] || [ "$output" == "libvorbis" ] || [ "$output" == "aac" ];
  then
    outputfiletype="lossy"
  fi
}

losslessToLossy() {
  if [ "$inputfiletype" == "lossless" ] && [ "$outputfiletype" == "lossy" ];
  then
    return true
  else
    return false
  fi
}

lossyToLossless() {
  if [ "$inputfiletype" == "lossy" ] && [ "$outputfiletype" == "lossless" ];
  then
    return true
  else
    return false
  fi
}

outputogg() {
  if [ "$output" == "libvorbis" ];
  then
    extension="ogg"
  else
    extension="$output"
  fi
}

inputogg() {
  if [ "$input" == "libvorbis" ];
  then
    extension="ogg"
  else
    extension="$input"
  fi
}

while getopts i:o:q: flag
do
    case "${flag}" in
        i) input=${OPTARG};;
        o) output=${OPTARG};;
        q) quality=${OPTARG};;
    esac
done
typeoffirstparameter
typeofsecondparameter
echo "$inputfiletype"
echo "$outputfiletype"
echo "$quality"
if [ "$input" == "" ] && [ "$output" == "" ] && [ "$quality" == "" ];
then
  echo "No Parameter given"
  echo "-i {input file type}"
  echo "-o {output file type}"
  echo "-q {output file quality}"
elif [ "$inputfiletype" == "lossless" ] && [ "$outputfiletype" == "lossy" ];
then
  outputogg
  mkdir "$output"
  for i in *."$input";
  do
    outputfilename=$(basename "$i" "$input")$extension
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
  echo "You are about to convert a lossy file in a lossless format! Do you really want to do this? (y/N)"
  read shure
  if [ "$shure" == "Y" ] || [ "$shure" == "y" ] || [ "$shure" == "yes" ] || [ "$shure" == "Yes" ];
  then
    inputogg
    mkdir "$output"
    for i in *."$input";
    do
      outputfilename=$(basename "$i" "$input")$output
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
  echo "You entered not supported formats"
fi
