losslessToLossy() {
  if [ "$1" == "flac" ] && [ "$2" == "mp3" ] || [ "$1" == "flac" ] && [ "$2" == "vorbis" ] || [ "$1" == "flac" ] && [ "$2" == "aac" ] || [ "$1" == "alac" ] && [ "$2" == "mp3" ] || [ "$1" == "alac" ] && [ "$2" == "vorbis" ] || [ "$1" == "alac" ] && [ "$2" == "aac" ];
  then
    return true
  else
    return false
  fi
}

lossyToLossless() {
  if ["$1" == "mp3" ] && [ "$2" == "flac"] || [ "$1" == "vorbis" ] && [ "$2" == "flac" ] || [ "$1" == "aac" ] && [ "$2" == "flac" ];
  then
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
  # mkdir alac
  # for i in *.flac;
  # do
    # echo "Element: $i"
    # ffmpeg -i "$i" -vcodec copy -acodec alac "${i%.flac}".m4a;
    # mv "${i%.flac}".m4a ./alac;
  # done
  echo "Hello"
else
  echo "You entered not supported formats"
fi
