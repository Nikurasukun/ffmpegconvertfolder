losslessToLossy() {
  if [ "$input" == "flac" ] && [ "$output" == "mp3" ] || [ "$input" == "flac" ] && [ "$output" == "vorbis" ] || [ "$input" == "flac" ] && [ "$output" == "aac" ] || [ "$input" == "alac" ] && [ "$output" == "mp3" ] || [ "$input" == "alac" ] && [ "$output" == "vorbis" ] || [ "$input" == "alac" ] && [ "$output" == "aac" ] || [ "$input" = "wav" ] && [ "$output" == "mp3" ] || [ "$input" = "wav" ] && [ "$output" == "vorbis" ] || [ "$input" = "wav" ] && [ "$output" == "aac" ];
  then
    return true
  else
    return false
  fi
}

lossyToLossless() {
  if ["$input" == "mp3" ] && [ "$output" == "flac"] || [ "$input" == "vorbis" ] && [ "$output" == "flac" ] || [ "$input" == "aac" ] && [ "$output" == "flac" ] || [ "$input" == "mp3" ] && [ "$output" == "alac" ] || [ "$input" == "vorbis" ] && [ "$output" == "alac" ] || [ "$input" == "aac" ] && [ "$output" == "alac" ] || [ "$input" = "mp3" ] && [ "$output" == "wav" ] || [ "$input" = "vorbis" ] && [ "$output" == "wav" ] || [ "$input" = "aac" ] && [ "$output" == "wav" ];
  then
    return true
  else
    return false
  fi
}

while getopts i:o:q flag
do
    case "${flag}" in
        i) input=${OPTARG};;
        o) output=${OPTARG};;
        q) quality=${OPTARG};;
    esac
done

if [ "$input" == "" ] && [ "$output" == "" ] && ["$quality" == ""];
then
  echo "No Parameter given"
  echo "-i {input file type}"
  echo "-o {output file type}"
  echo "-q {output file quality}"
elif [ losslessToLossy ]
then
  if [ "$output" == "vorbis" ];
  then
    extension="ogg"
  else
    extension="$output"
  fi
  mkdir "$output"
  for i in *."$input";
  do
    echo "Element: $i"
    ffmpeg -i "$i" -vcodec copy -acodec "$output" "${i%.flac}"."$extension";
    mv "${i%.flac}"."$extenion" ./"$output";
  done
else
  echo "You entered not supported formats"
fi
